function OnPlayerJoined(Player)
	-- Send the MOTD to the player:
	ShowMOTDTo(Player)
	
	-- Add a message to the webadmin chat:
	AddMessage(nil, " " .. Player:GetName() .. " has joined the game")
	
	return false
end




