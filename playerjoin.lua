function OnPlayerJoined(Player)
	-- Send the MOTD to the player:
	ShowMOTD(Player)

	-- Add a message to the webadmin chat:
	WEBLOGINFO(Player:GetName() .. " has joined the game")
end
