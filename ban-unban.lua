function HandleBanCommand(Split, Player)

	if (#Split < 2) then
		SendMessage(Player, "Usage: /ban [Player] <Reason>")
		return true
	end

	-- If the player supplied a reason, use that, else use a default reason.
	if (#Split > 2) then
		local Reason = table.concat(Split, " ", 3)
	else
		local Reason = cChatColor.Red .. "You have been banned."
	end

	-- Actually ban the player.
	BannedPlayersIni:SetValueB("Banned", Split[2], true)
	BannedPlayersIni:WriteFile("banned.ini")

	-- Try akd kick the banned player, and send an appropriated response to the banner.
	if (KickPlayer(Split[2], Reason)) then
		SendMessageSuccess(Player, "Successfully kicked and banned " .. Split[2])
	else
		SendMessageFailure(Player, "Successfully Banned " .. Split[2])
	end
	
	return true

end

function HandleUnbanCommand( Split, Player )

	if (#Split < 2) then
		SendMessage(Player, "Usage: /unban [Player]")
		return true
	end

	if (BannedPlayersIni:GetValueB("Banned", Split[2], false) == false) then
		SendMessageFailure(Player, "Player is not banned!")
		return true
	end

	-- Actually unban the banned player.
	BannedPlayersIni:SetValueB("Banned", Split[2], false)
	BannedPlayersIni:WriteFile("banned.ini")

	LOGINFO(Player:GetName() .. " unbanned " .. Split[2])
	SendMessageSuccess(Player, "Unbannex " .. Split[2])

	return true

end
