function OnPlayerJoined(Player)
	--if( BannedPlayersIni:GetValueB("Banned", Player:GetName(), false) == true ) then
	--	LOGINFO( Player:GetName() .. " tried to join, but is banned!" )
	--	KickPlayer(Player:GetName(), cChatColor.Red .. "You are banned!" )
	--	return true
	--elseif( WhiteListIni:GetValueB("WhiteListSettings", "WhiteListOn", false ) == true ) then
	--	if( WhiteListIni:GetValueB("WhiteList", Player:GetName(), false ) == false ) then
	--		LOGINFO( Player:GetName() .. " tried to join, but is not whitelisted!" )
	--		KickPlayer(Player:GetName(), cChatColor.Red .. "You are not whitelisted!" )
	--	end
	--else
	
	ShowMOTDTo( Player )
	cRoot:Get():ForEachWorld(  
		function (a_World)  
			a_World:BroadcastChat(cChatColor.Yellow .. "[JOIN] " .. cChatColor.White .. Player:GetName() .. " has joined the game" );  
		end  
	)
	LOGINFO("Player " .. Player:GetName() .. " has joined the game." )
	return false
	
	--end
end

function OnDisconnect(Player, Reason)
	cRoot:Get():ForEachWorld(  
		function (a_World)  
			a_World:BroadcastChat(cChatColor.Yellow .. "[LEAVE] " .. cChatColor.White .. Player:GetName() .. " has left the game" );  
		end  
	)
	LOGINFO("Player " .. Player:GetName() .. " has left the game." )
	return true
end