function OnPlayerJoined(Player)
	
	ShowMOTDTo(Player)
	AddMessage(nil, " " .. Player:GetName() .. " has joined the game")
	return false
	
end