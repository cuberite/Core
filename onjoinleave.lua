function OnPlayerJoined(Player)
	
	ShowMOTDTo( Player )
	cRoot:Get():BroadcastChat(cChatColor.Yellow .. "[JOIN] " .. cChatColor.White .. Player:GetName() .. " has joined the game" )
	LOGINFO("Player " .. Player:GetName() .. " has joined the game." )
	return false
	
end

function OnDisconnect(Player, Reason)

	cRoot:Get():BroadcastChat(cChatColor.Yellow .. "[LEAVE] " .. cChatColor.White .. Player:GetName() .. " has left the game" )
	LOGINFO("Player " .. Player:GetName() .. " has left the game." )
	return true
	
end