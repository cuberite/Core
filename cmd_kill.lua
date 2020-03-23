function HandleKillCommand(Split, Player)
	local Response

	local KillPlayer = function(OtherPlayer)
		OtherPlayer:TakeDamage(dtPlugin, nil, 1000, 1000, 0)

		if Split[2] then
			Response = SendMessageSuccess(Player, "Successfully killed player \"" .. OtherPlayer:GetName() .. "\"")
		end
	end

	if not Split[2] then
		if not Player then
			Response = SendMessage(nil, "Usage: " .. Split[1] .. " <player>")
		else
			KillPlayer(Player)
		end
	elseif Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], KillPlayer) then
		Response = SendMessageFailure(Player, "Player \"" .. Split[2] .. "\" not found")
	end
	return true, Response
end

function HandleConsoleKill(Split)
	return HandleKillCommand(Split)
end
