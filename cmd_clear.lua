function HandleClearCommand(Split, Player)
	local Response

	local ClearInventory = function(OtherPlayer)
		OtherPlayer:GetInventory():Clear()

		if Split[2] then
			Response = SendMessageSuccess(Player, "You cleared the inventory of player \"" .. OtherPlayer:GetName() .. "\"")
		else
			Response = SendMessageSuccess(OtherPlayer, "You cleared your own inventory")
		end
	end

	if not Split[2] then
		if not Player then
			Response = SendMessage(nil, "Usage: " .. Split[1] .. " <player>")
		else
			ClearInventory(Player)
		end
	elseif not Player or Player:HasPermission("core.admin.clear") then
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], ClearInventory) then
			Response = SendMessageFailure(Player, "Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true, Response
end

function HandleConsoleClear(Split)
	return HandleClearCommand(Split)
end
