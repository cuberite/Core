function HandleKickCommand(Split, Player)
	local Response
	local Reason
	
	local KickPlayer = function(OtherPlayer)
		if KickPlayer(Split[2], Reason) then
			Response = SendMessageSuccess(Player, "Successfully kicked player \"" .. OtherPlayer:GetName() .. "\"")
		else
			Response = SendMessageFailure(Player, "Failed to kick player \"" .. OtherPlayer:GetName() .. "\"")
		end
	end

	if not Split[2] then
		Response = SendMessage(Player, "Usage: " .. Split[1] .. " <player> [reason ...]")
	else
		if Split[3] then
			Reason = table.concat(Split, " ", 3)
		end

		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], KickPlayer) then
			Response = SendMessageFailure(Player, "Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true, Response
end

function HandleConsoleKick(Split)
	return HandleKickCommand(Split)
end
