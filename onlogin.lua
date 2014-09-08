function OnLogin(Client, ProtocolVersion, Username)
	if( Username ~= "" ) then
		if( WhiteListIni:GetValueB("WhiteListSettings", "WhiteListOn", false ) == true ) then
			if( WhiteListIni:GetValueB("WhiteList", Username, false ) == false ) then -- not on whitelist
				cRoot:Get():BroadcastChat(Username .. " tried to join, but is not on the whitelist.")
				LOGINFO( Username .. " tried to join, but is not on the whitelist." )
				Client:Kick("You are not whitelisted on this server!")
				return true -- Deny access to the server
			end
		end
	end
	return false
end
