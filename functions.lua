function SendMessage(a_Player, a_Message)
	a_Player:SendMessageInfo(a_Message)
end

function SendMessageSuccess(a_Player, a_Message)
	a_Player:SendMessageSuccess(a_Message)
end

function SendMessageFailure(a_Player, a_Message)
	a_Player:SendMessageFailure(a_Message)
end

--- Kicks a player by name, with the specified reason; returns bool whether found and player's real name
function KickPlayer( PlayerName, Reason )

	local RealName = ""
	if (Reason == nil) then
		Reason = "You have been kicked"
	end

	local FoundPlayerCallback = function( a_Player )
		a_Player:GetClientHandle():Kick(Reason)
		return true
	end

	if not cRoot:Get():FindAndDoWithPlayer( PlayerName, FoundPlayerCallback ) then
		-- Could not find player
		return false
	end

	return true -- Player has been kicked

end

-- Teleports a_SrcPlayer to a player named a_DstPlayerName; if a_TellDst is true, will send a notice to the destination player
function TeleportToPlayer( a_SrcPlayer, a_DstPlayerName, a_TellDst )

	local teleport = function(a_DstPlayerName)

		if a_DstPlayerName == a_SrcPlayer then
			-- Asked to teleport to self?
			SendMessageFailure( a_SrcPlayer, "Y' can't teleport to yerself" )
		else
			-- If destination player is not in the same world, move to the correct world
			if a_SrcPlayer:GetWorld() ~= a_DstPlayerName:GetWorld() then
				a_SrcPlayer:MoveToWorld( a_DstPlayerName:GetWorld(), true, Vector3d( a_DstPlayerName:GetPosX() + 0.5, a_DstPlayerName:GetPosY(), a_DstPlayerName:GetPosZ() + 0.5 ) )
			else
				a_SrcPlayer:TeleportToEntity( a_DstPlayerName )
			end
			SendMessageSuccess( a_SrcPlayer, "You teleported to " .. a_DstPlayerName:GetName() )
			if (a_TellDst) then
				SendMessage( a_DstPlayerName, a_SrcPlayer:GetName().." teleported to you" )
			end
		end

	end

	if not cRoot:Get():FindAndDoWithPlayer( a_DstPlayerName, teleport ) then
		SendMessageFailure( a_SrcPlayer, "Player " .. a_DstPlayerName .. " not found" )
	end

end

function getSpawnProtectRadius(WorldName)
	return WorldsSpawnProtect[WorldName]
end

function GetWorldDifficulty(a_World)
	local Difficulty = WorldsWorldDifficulty[a_World:GetName()]
	if (Difficulty == nil) then
		Difficulty = 1
	end

	return Clamp(Difficulty, 0, 3)
end

function SetWorldDifficulty(a_World, a_Difficulty)
	local Difficulty = Clamp(a_Difficulty, 0, 3)
	WorldsWorldDifficulty[a_World:GetName()] = Difficulty

	-- Update world.ini
	local WorldIni = cIniFile()
	WorldIni:ReadFile(a_World:GetIniFileName())
	WorldIni:SetValueI("Difficulty", "WorldDifficulty", Difficulty)
	WorldIni:WriteFile(a_World:GetIniFileName())
end

function LoadWorldSettings(a_World)
	local WorldIni = cIniFile()
	WorldIni:ReadFile(a_World:GetIniFileName())
	WorldsSpawnProtect[a_World:GetName()]    = WorldIni:GetValueSetI("SpawnProtect", "ProtectRadius", 10)
	WorldsWorldLimit[a_World:GetName()]      = WorldIni:GetValueSetI("WorldLimit",   "LimitRadius",   0)
	WorldsWorldDifficulty[a_World:GetName()] = WorldIni:GetValueSetI("Difficulty", "WorldDifficulty", 1)
	WorldIni:WriteFile(a_World:GetIniFileName())
end


--- Returns the cWorld object represented by the given WorldName,
--  if no world of the given name is found, returns nil and informs the Player, if given, otherwise logs to console.
--  If no WorldName was given, returns the default world if called without a Player,
--  or the current world that the player is in if called with a Player.
--
--  @param WorldName String containing the name of the world to find
--  @param Player cPlayer object representing the player calling the command
--
--  @return cWorld object representing the requested world, or nil if not found
--
--  Called from: time.lua, weather.lua,
--
function GetWorld( WorldName, Player )

	if not WorldName then
		return Player and Player:GetWorld() or cRoot:Get():GetDefaultWorld()
	else
		local World = cRoot:Get():GetWorld(WorldName)

		if not World then
			local Message = "There is no world \"" .. WorldName .. "\""
			if Player then
				SendMessage( Player, Message )
			else
				LOG( Message )
			end
		end

		return World
	end
end


function GetAdminRank()
	local AdminRank
	local Ranks = cRankManager:GetAllRanks()
	for _, Rank in ipairs(Ranks) do
		local Permissions = cRankManager:GetRankPermissions(Rank)
		for _, Permission in ipairs(Permissions) do
			if Permission == "*" then
				return Rank
			end
		end
	end
end
