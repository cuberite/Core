
-- Implements spawn protection for Cuberite

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
	local BlockID = Player:GetWorld():GetBlock(Vector3i(BlockX, BlockY, BlockZ))
	if BlockID == E_BLOCK_BED or BlockID == E_BLOCK_BED_BED_HEAD then
		Player:SetBedPos(Vector3i(BlockX, BlockY, BlockZ), Player:GetWorld())
		Player:SendMessageInfo("You have set your spawn!")
		return true
	end
	
	if not Player:HasPermission("core.spawnprotect.bypass") and IsInSpawn(BlockX, BlockY, BlockZ, Player:GetWorld():GetName()) then
		if Player:GetWorld():GetBlock(BlockX, BlockY, BlockZ) == E_BLOCK_GRASS or
				Player:GetWorld():GetBlock(BlockX, BlockY, BlockZ) == E_BLOCK_DIRT then
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
