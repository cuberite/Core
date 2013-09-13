function HandleTimeCommand( Split, Player )

	if Split[2] == nil then
		SendMessage( Player, "Usage: /time [Day/Night/Set/Add]" )
		return true
	end

	local Server = cRoot:Get():GetServer()
	if string.upper( Split[2] ) == "DAY" then
		Player:GetWorld():SetTimeOfDay( 0 )
		cRoot:Get():BroadcastChat(cChatColor.Green .. "[INFO] " .. cChatColor.White .. "Time was set to daytime" )
		return true
	elseif string.upper( Split[2] ) == "NIGHT" then
		Player:GetWorld():SetTimeOfDay( 12000 + 1000 )
		cRoot:Get():BroadcastChat( cChatColor.Green .. "[INFO] " .. cChatColor.White .. "Time was set to night time" )
		return true
	elseif string.upper( Split[2] ) == "SET" and tonumber( Split[3] ) ~= nil then
		Player:GetWorld():SetTimeOfDay( tonumber(Split[3]) )
		cRoot:Get():BroadcastChat( cChatColor.Green .. "[INFO] " .. cChatColor.White .. "Time was set to " .. Split[3] )
		return true
	elseif string.upper( Split[2] ) == "ADD" and tonumber( Split[3] ) ~= nil then
		Player:GetWorld():SetTimeOfDay( Player:GetWorld():GetTimeOfDay() + Split[3] )
		cRoot:Get():BroadcastChat( cChatColor.Green .. "[INFO] " .. cChatColor.White .. Split[3] .. "Was added to the time" )
		return true
	else
		SendMessage( Player, "Usage: /time [Day/Night/Set/Add]" )
		return true
	end
	return true

end
