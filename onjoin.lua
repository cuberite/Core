function OnPlayerJoined(Player)
	
	ShowMOTDTo( Player )
	cRoot:Get():BroadcastChat(cChatColor.Yellow .. "[JOIN] " .. cChatColor.White .. Player:GetName() .. " has joined the game" )
	LOGINFO("Player " .. Player:GetName() .. " has joined the game." )
	return false
	
end