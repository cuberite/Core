function HandleTimeCommand( Split, Player )

	if Split[2] == nil then
		SendMessage( Player, "Usage: /time [day/night] or [set/add] [amount]" )
		return true
	end
	
	local World = Player:GetWorld()
	local TimeToSet = 0
	local CurrentTime = World:GetTimeOfDay()

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
	
	if TimeToSet > 24000 then
		TimeToSet = 24000
	elseif TimeToSet < 0 then
		TimeToSet = 0
	end
	
	local AnimationForward = true
	local AnimationSpeed = 480
	
	if CurrentTime > TimeToSet then
		AnimationForward = false
		AnimationSpeed = -480
	end
	
	local function DoAnimation()
		local TimeOfDay = World:GetTimeOfDay()
		if AnimationForward then
			if TimeOfDay < TimeToSet then
				World:SetTimeOfDay(TimeOfDay + AnimationSpeed)
				World:ScheduleTask(1, DoAnimation)
			else
				World:SetTimeOfDay(TimeToSet) -- Make sure we actualy get the time that was asked for.
			end
		else
			if TimeOfDay > TimeToSet then
				World:SetTimeOfDay(TimeOfDay + AnimationSpeed)
				World:ScheduleTask(1, DoAnimation)
			else
				World:SetTimeOfDay(TimeToSet) -- Make sure we actualy get the time that was asked for.
			end
		end
	end
	
	World:ScheduleTask(1, DoAnimation)
	return true

end
