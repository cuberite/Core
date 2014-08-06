function SetBackCoordinates( Player )
	BackCoords[Player:GetName()] = Vector3d( Player:GetPosX(), Player:GetPosY(), Player:GetPosZ() )
end

function SendMessage(a_Player, a_Message)
	a_Player:SendMessageInfo(a_Message)
end

function SendMessageSuccess(a_Player, a_Message)
	a_Player:SendMessageSuccess(a_Message)
end

function SendMessageFailure(a_Player, a_Message)
	a_Player:SendMessageFailure(a_Message)
end

--- Returns the list of players banned by name, separated by ", "
function BanListByName()
	local NumValues = BannedPlayersIni:NumValues("Banned");
	local Banned = {};
	local KeyID = BannedPlayersIni:FindKey("Banned");
	for i = 1, NumValues do
		local PlayerName = BannedPlayersIni:ValueName(KeyID, i - 1);
		if (BannedPlayersIni:GetValueB("Banned", PlayerName)) then
			-- Player listed AND banned
			table.insert(Banned, PlayerName);
		end
	end
	return table.concat(Banned, ", ");
end

--- Returns the list of players banned by IP, separated by ", "
function BanListByIPs()
	-- TODO: No IP ban implemented yet
	return "";
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


function ReturnColorFromChar( Split, char )

	-- Check if the char represents a color. Else return nil.
	if char == "0" then
		return cChatColor.Black
	elseif char == "1" then
		return cChatColor.Navy
	elseif char == "2" then
		return cChatColor.Green
	elseif char == "3" then
		return cChatColor.Blue
	elseif char == "4" then
		return cChatColor.Red
	elseif char == "5" then
		return cChatColor.Purple
	elseif char == "6" then
		return cChatColor.Gold
	elseif char == "7" then
		return cChatColor.LightGray
	elseif char == "8" then
		return cChatColor.Gray
	elseif char == "9" then
		return cChatColor.DarkPurple
	elseif char == "a" then
		return cChatColor.LightGreen
	elseif char == "b" then
		return cChatColor.LightBlue
	elseif char == "c" then
		return cChatColor.Rose
	elseif char == "d" then
		return cChatColor.LightPurple
	elseif char == "e" then
		return cChatColor.Yellow
	elseif char == "f" then
		return cChatColor.White
	elseif char == "k" then
		return cChatColor.Random
	elseif char == "l" then
		return cChatColor.Bold
	elseif char == "m" then
		return cChatColor.Strikethrough
	elseif char == "n" then
		return cChatColor.Underlined
	elseif char == "o" then
		return cChatColor.Italic
	elseif char == "r" then
		return cChatColor.Plain
	end

end

function CheckHardcore(Victim)
	if cRoot:Get():GetServer():IsHardcore() then
		if Victim:IsPlayer() == true then
			BannedPlayersIni:SetValueB( "Banned", tolua.cast(Victim, "cPlayer"):GetName(), true )
			BannedPlayersIni:WriteFile( "banned.ini" )
		end
	end
end

-- Teleports a_SrcPlayer to a player named a_DstPlayerName; if a_TellDst is true, will send a notice to the destination player
function TeleportToPlayer( a_SrcPlayer, a_DstPlayerName, a_TellDst )

	local teleport = function(a_DstPlayerName)

		if a_DstPlayerName == a_SrcPlayer then
			-- Asked to teleport to self?
			SendMessageFailure( a_SrcPlayer, "Y' can't teleport to yerself!" )
		else
			SetBackCoordinates( a_SrcPlayer )
			a_SrcPlayer:TeleportToEntity( a_DstPlayerName )
			SendMessageSuccess( a_SrcPlayer, "You teleported to " .. a_DstPlayerName:GetName() .. "!" )
			if (a_TellDst) then
				SendMessage( a_DstPlayerName, a_SrcPlayer:GetName().." teleported to you!" )
			end
		end

	end

	local World = a_SrcPlayer:GetWorld()
	if not World:DoWithPlayer(a_DstPlayerName, teleport) then
		SendMessageFailure( a_SrcPlayer, "Can't find player " .. a_DstPlayerName)
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
	WorldIni:SetValue("Difficulty", "WorldDifficulty", Difficulty)
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
