function HandleSayCommand(Split, Player)
	if not Split[2] then
		SendMessage(Player, "Usage: " .. Split[1] .. " <message ...>")
	elseif not Player then
		cRoot:Get():BroadcastChat(cChatColor.Gold .. "[SERVER] " .. cChatColor.Yellow .. table.concat(Split, " ", 2))
	else
		cRoot:Get():BroadcastChat("[" .. Player:GetName() .. "] " .. table.concat(Split, " ", 2))
	end
	return true
end
