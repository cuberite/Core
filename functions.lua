function SetBackCoordinates( Player )
	BackCoords[Player:GetName()] = Vector3i( Player:GetPosX(), Player:GetPosY(), Player:GetPosZ() )
end

function SendMessage(a_Player, a_Message)
	if (g_UsePrefixes) then
		a_Player:SendMessage(cChatColor.Yellow .. "[INFO] " .. cChatColor.White .. a_Message)
	else
		a_Player:SendMessage(cChatColor.Yellow .. a_Message)
	end
end

function SendMessageSuccess(a_Player, a_Message)
	if (g_UsePrefixes) then
		a_Player:SendMessage(cChatColor.Green .. "[INFO] " .. cChatColor.White .. a_Message)
	else
		a_Player:SendMessage(cChatColor.Green .. a_Message)
	end
end

function SendMessageFailure(a_Player, a_Message)
	if (g_UsePrefixes) then
		a_Player:SendMessage(cChatColor.Red .. "[INFO] " .. cChatColor.White .. a_Message)
	else
		a_Player:SendMessage(cChatColor.Red .. a_Message)
	end
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
		RealName = a_Player:GetName()

		local Server = cRoot:Get():GetServer()
		LOGINFO( "'" .. RealName .. "' is being kicked for ( "..Reason..") " )
		Server:SendMessage("Kicking " .. RealName)

		a_Player:GetClientHandle():Kick(Reason)
	end

	if not cRoot:Get():FindAndDoWithPlayer( PlayerName, FoundPlayerCallback ) then
		-- Could not find player
		return false
	end

	return true, RealName  -- Player has been kicked

end
