function HandleSayCommand(Split, Player)
	local Response

	if not Split[2] then
		Response = SendMessage(Player, "Usage: " .. Split[1] .. " <message ...>")
	elseif not Player then
		cRoot:Get():BroadcastChat(cChatColor.Gold .. "[SERVER] " .. cChatColor.Yellow .. table.concat(Split, " ", 2))
	else
		cRoot:Get():BroadcastChat("[" .. Player:GetName() .. "] " .. table.concat(Split, " ", 2))
	end
	return true, Response
end

function HandleConsoleSay(Split)
	return HandleSayCommand(Split)
end
