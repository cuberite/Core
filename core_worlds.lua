-- General world-related core functionality, including difficulty, spawn protection and world limit
-- TODO: Move difficulty and world limit (border) functionality to main server

local WorldsSpawnProtect = {}
local WorldsWorldDifficulty = {}
local WorldsWorldLimit = {}

function LoadWorldSettings(World)
	local WorldIni = cIniFile()
	WorldIni:ReadFile(World:GetIniFileName())

	WorldsSpawnProtect[World:GetName()]    = WorldIni:GetValueSetI("SpawnProtect", "ProtectRadius",   10)
	WorldsWorldDifficulty[World:GetName()] = WorldIni:GetValueSetI("Difficulty",   "WorldDifficulty", 1)
	WorldsWorldLimit[World:GetName()]      = WorldIni:GetValueSetI("WorldLimit",   "LimitRadius",     0)

	WorldIni:WriteFile(World:GetIniFileName())
end


-- Implements server difficulty for Cuberite

local MobDamages =
{
	["cBlaze"]          = { 4,  6,  9  },
	["cCaveSpider"]     = { 2,  2,  3  },
	["cEnderDragon"]    = { 6,  10, 15 },
	["cEnderman"]       = { 4,  7,  10 },
	["cGiant"]          = { 26, 50, 75 },
	["cGuardian"]       = { 5,  6,  9  },
	["cIronGolem"]      = { 4,  7,  10 },
	["cSkeleton"]       = { 2,  2,  3  },
	["cSpider"]         = { 2,  2,  3  },
	["cWitherSkeleton"] = { 5,  8,  12 },
	["cZombie"]         = { 2,  3,  4  },
	["cZombiePigman"]   = { 5,  9,  13 },
	["cZombieVillager"] = { 2,  3,  4  },
}

function GetWorldDifficulty(World)
	local Difficulty = WorldsWorldDifficulty[World:GetName()]
	if not Difficulty then
		Difficulty = 1
	end

	return Clamp(Difficulty, 0, 3)
end

function SetWorldDifficulty(World, Difficulty)
	local Difficulty = Clamp(Difficulty, 0, 3)
	WorldsWorldDifficulty[World:GetName()] = Difficulty

	-- Update world.ini
	local WorldIni = cIniFile()
	WorldIni:ReadFile(World:GetIniFileName())

	WorldIni:SetValueI("Difficulty", "WorldDifficulty", Difficulty)

	WorldIni:WriteFile(World:GetIniFileName())
end

function OnTakeDamage(Receiver, TDI)
	local Attacker

	if TDI.Attacker then
		Attacker = TDI.Attacker
		local WorldDifficulty = GetWorldDifficulty(Attacker:GetWorld())
		local Damages = MobDamages[Attacker:GetClass()]
		if Damages then
			TDI.FinalDamage = Damages[WorldDifficulty]
		end
	end

	-- Apply armor protection
	local ArmorCover = Receiver:GetArmorCoverAgainst(Attacker, TDI.DamageType, TDI.FinalDamage)
	local EnchantmentCover = Receiver:GetEnchantmentCoverAgainst(Attacker, TDI.DamageType, TDI.FinalDamage)
	TDI.FinalDamage = TDI.FinalDamage - ArmorCover - EnchantmentCover
end

function OnSpawningMonster(World, Monster)
	if GetWorldDifficulty(World) == 0 and Monster:GetMobFamily() == cMonster.mfHostile then
		-- Don't spawn hostile mobs in peaceful mode
		return true
	end
	return false
end


-- Implements spawn protection for Cuberite

function GetSpawnProtectRadius(WorldName)
	return WorldsSpawnProtect[WorldName]
end

local function IsInSpawn(X, Y, Z, WorldName)
	local ProtectRadius = WorldsSpawnProtect[WorldName]
	
	if ProtectRadius > 0 then
		local World = cRoot:Get():GetWorld(WorldName)
		local SpawnArea = cBoundingBox(Vector3d(World:GetSpawnX() - ProtectRadius, -1000, World:GetSpawnZ() - ProtectRadius), Vector3d(World:GetSpawnX() + ProtectRadius, 1000, World:GetSpawnZ() + ProtectRadius))
		local PlayerLocation = Vector3d(X, Y, Z)

		if SpawnArea:IsInside(PlayerLocation) then
			return true
		end
	end
end

local function CheckBlockModification(Player, BlockX, BlockY, BlockZ)
	if not Player:HasPermission("core.build") then
		SendMessageFailure(Player, "You do not have the \"core.build\" permission, thou cannot build")
		return true
	end

	if not Player:HasPermission("core.spawnprotect.bypass") and IsInSpawn(BlockX, BlockY, BlockZ, Player:GetWorld():GetName()) then
		SendMessageFailure(Player, "Go further from spawn to build")
		return true
	end
end

function OnBlockSpread(World, BlockX, BlockY, BlockZ, Source)
	if Source == ssFireSpread and IsInSpawn(BlockX, BlockY, BlockZ, World:GetName()) then
		return true
	end
		
end

function OnExploding(World, ExplosionSize, CanCauseFire, X, Y, Z, Source, SourceData)
	if IsInSpawn(X, Y, Z, World:GetName()) then
		return true
	end
end

function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, Status, OldBlockType, OldBlockMeta)
	return CheckBlockModification(Player, BlockX, BlockY, BlockZ)
end

function OnPlayerPlacingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType)
	return CheckBlockModification(Player, BlockX, BlockY, BlockZ)
end

function OnPlayerRightClick(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ)
	if not Player:HasPermission("core.spawnprotect.bypass") and IsInSpawn(BlockX, BlockY, BlockZ, Player:GetWorld():GetName()) then
		local Block = Player:GetWorld():GetBlock(Vector3i(BlockX, BlockY, BlockZ))

		if Block == E_BLOCK_GRASS or Block == E_BLOCK_DIRT then
			if Player:GetEquippedItem():IsEmpty() then
				return false
			end
		end

		if Player:GetEquippedItem().m_ItemType ~= E_ITEM_FLINT_AND_STEEL and
				Player:GetEquippedItem().m_ItemType ~= E_ITEM_FIRE_CHARGE then
			return false
		end

		SendMessageFailure(Player, "Go further from spawn to build")
		return true
	end
end


-- Implements world limiter for Cuberite

local WorldLimiter_Flag = false -- True when teleportation is about to occur, false otherwise
local WorldLimiter_LastMessage = -100 -- The last time the player was sent a message about reaching the border
function OnPlayerMoving(Player)
	if (WorldLimiter_Flag == true) then
		return
	end

	local LimitChunks = WorldsWorldLimit[Player:GetWorld():GetName()]
	
	-- The world probably was created by an external plugin. Let's load the settings.
	if not LimitChunks then
		LoadWorldSettings(Player:GetWorld())
		LimitChunks = WorldsWorldLimit[Player:GetWorld():GetName()]
	end

	if (LimitChunks > 0) then
		local World = Player:GetWorld()
		local Limit = LimitChunks * 16 - 1
		local SpawnX = math.floor(World:GetSpawnX())
		local SpawnZ = math.floor(World:GetSpawnZ())
		local X = math.floor(Player:GetPosX())
		local Z = math.floor(Player:GetPosZ())
		local NewX = X
		local NewZ = Z
		
		if (X > SpawnX + Limit) then 
			NewX = SpawnX + Limit
		elseif (X < SpawnX - Limit) then
			NewX = SpawnX - Limit
		end

		if (Z > SpawnZ + Limit) then
			NewZ = SpawnZ + Limit
		elseif (Z < SpawnZ - Limit) then
			NewZ = SpawnZ - Limit
		end

		if (X ~= NewX) or (Z ~= NewZ) then
			WorldLimiter_Flag = true

			local UpTime = cRoot:Get():GetServerUpTime()
			if  UpTime - WorldLimiter_LastMessage > 30 then
				WorldLimiter_LastMessage = UpTime
				Player:SendMessageInfo("You have reached the world border")
			end

			local UUID = Player:GetUUID()
			World:ScheduleTask(3, function(World)
				World:DoWithPlayerByUUID(UUID, function(Player)
					Player:TeleportToCoords(NewX, Player:GetPosY(), NewZ)
					WorldLimiter_Flag = false
				end) 
			end)
		end	


	end
end
