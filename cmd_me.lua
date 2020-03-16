function HandleMeCommand(Split, Player)
	if not Split[2] then
		SendMessage(Player, "Usage: " .. Split[1] .. " <action ...>")
	else
		cRoot:Get():BroadcastChat("* " .. Player:GetName() .. " " .. table.concat(Split , " " , 2))
	end
	return true
end
