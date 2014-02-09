function HandleTimeCommand( Split, Player )

	if Split[2] == nil then
		SendMessage( Player, "Usage: /time [day/night] or [set/add] [amount]" )
		return true
	end
	
	local TimeToSet = 0
	local CurrentTime = Player:GetWorld():GetTimeOfDay()

	local Server = cRoot:Get():GetServer()
	if string.upper( Split[2] ) == "DAY" then
		cRoot:Get():BroadcastChat(cChatColor.Green .. "[INFO] " .. cChatColor.White .. "Time was set to daytime" )
	elseif string.upper( Split[2] ) == "NIGHT" then
		TimeToSet = 12000 + 1000
		cRoot:Get():BroadcastChat( cChatColor.Green .. "[INFO] " .. cChatColor.White .. "Time was set to night time" )
	elseif string.upper( Split[2] ) == "SET" and tonumber( Split[3] ) ~= nil then
		TimeToSet = tonumber(Split[3])
		cRoot:Get():BroadcastChat( cChatColor.Green .. "[INFO] " .. cChatColor.White .. "Time was set to " .. Split[3] )
	elseif string.upper( Split[2] ) == "ADD" and tonumber( Split[3] ) ~= nil then
		TimeToSet = CurrentTime + Split[3]
		cRoot:Get():BroadcastChat( cChatColor.Green .. "[INFO] " .. cChatColor.White .. Split[3] .. "was added to the time" )
	else
		SendMessage( Player, "Usage: /time [day/night] or [set/add] [amount]" )
		return true
	end
	
	if CurrentTime > TimeToSet then
		for t = CurrentTime, TimeToSet, -2 do
			Player:GetWorld():SetTimeOfDay(t)
		end
	else
		for t = CurrentTime, TimeToSet, 2 do			
			Player:GetWorld():SetTimeOfDay(t)
		end
	end
	
	return true

end
