-- Implements time related commands and console commands


--local PlayerTimeCommandUsage = "Usage: /time [day/night] or [set/add] [amount] or [query] [daytime/gametime]"
local PlayerTimeAddCommandUsage = "Usage: /time add [amount]"
local PlayerTimeQueryCommandUsage = "Usage: /time query [daytime/gametime]"
local PlayerTimeSetCommandUsage = "Usage: /time set [amount/day/night]"
local ConsoleTimeCommandUsage = "Usage: time <WorldName> [day/night] or [set/add] [amount] or [query] [daytime/gametime]"

-- Times of day and night as defined in vanilla minecraft
local SpecialTimes = {
	["day"] = 1000,
	["night"] = 1000 + 12000,
}

-- Used to animate the transition between previous and new times
local function SetTime( World, TimeToSet )

	local CurrentTime = World:GetTimeOfDay()

	-- Is this correct, or should it roll over?
	-- For example, 25000 becoming 1000 rather then 24000 as it does currently
	-- Or, as another example, -1000 becoming 23000 instead of 0.
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
	World:BroadcastChatSuccess("Time was set to " .. TimeToSet)
	LOG("Time in world \"" .. World:GetName() .. "\" was set to " .. TimeToSet) -- Let the console know about time changes

	return true
end


-- Handler for "/time add [amount]" subcommand 
function HandleAddTimeCommand( Split, Player )

	local amount = Split[3]

	if tonumber(amount) == nil then
		SendMessage( Player, PlayerTimeAddCommandUsage )
		return true
	end

	local World = Player:GetWorld()
	local TimeToSet = World:GetTimeOfDay() + amount

	SetTime( World, TimeToSet )
	return true

end


-- Handler for "/time set [value]" subcommand 
function HandleSetTimeCommand( Split, Player )

	local Time = Split[3]
	local World = Player:GetWorld()

	-- Handle the vanilla cases of /time set [day/night], for compatibility
	if Time == "night" or Time == "day" then
		SetTime( World, SpecialTimes[Time] )
	elseif tonumber( Time ) ~= nil then
		SetTime( World, tonumber(Time) )
	else
		SendMessage( Player, PlayerTimeSetCommandUsage )
	end

	return true

end


-- Handler for /time [day/night]
function HandleSpecialTimeCommand( Split, Player )

	SetTime( Player:GetWorld(), SpecialTimes[Split[2]] )
	return true

end


-- Handler for /time query [daytime/gametime]
function HandleQueryTimeCommand( Split, Player )

	local Option = Split[3]
	local World = Player:GetWorld()
	local WorldName = World:GetName()

	-- Options daytime and gametime are based on their usage in vanilla
	if Option == "daytime" then
		SendMessage( Player, "The current time in World \"" .. WorldName .. "\" is " .. World:GetTimeOfDay() )
	elseif Option == "gametime" then
		SendMessage( Player, "The World \"" .. WorldName .. "\" has existed for " .. World:GetWorldAge() )
	else
		SendMessage( Player, PlayerTimeQueryCommandUsage )
	end

	return true
end


-- Handler for time console command
-- Not segregated into sub-commands to handle the <WorldName> parameter
function HandleConsoleTime(a_Split)

	if a_Split[3] == nil then
		return true, ConsoleTimeCommandUsage
	end

	local World = cRoot:Get():GetWorld(a_Split[2])
	if (World == nil) then
		return true, "There is no world \"" .. a_Split[2] .. "\""
	end

	local CurrentTime = World:GetTimeOfDay()
	local Command = a_Split[3]

	-- Handle the "time set [value]" console command
	local function SetTimeCommandParse()

		local Time = a_Split[4]

		-- Handle the vanilla values of [day/night] for compatibility
		if Time == "night" or Time == "day" then
			SetTime( World, SpecialTimes[Time] )
		elseif tonumber( Time ) ~= nil then
			SetTime( World, tonumber(Time) )
		else
			LOG(ConsoleTimeCommandUsage)
		end

		return true
	end

	-- Handle the "time query [daytime/gametime]" console command
	local function QueryTimeCommandParse()

		local option = a_Split[4]
		local WorldName = World:GetName()

		if option == "daytime" then
			LOG( "The current time in World \"" .. WorldName .. "\" is " .. CurrentTime )
		elseif option == "gametime" then
			LOG( "The World \"" .. WorldName .. "\" has existed for " .. World:GetWorldAge() )
		else
			LOG(ConsoleTimeCommandUsage)
		end

		return true
	end

	if Command == "day" or Command == "night" then
		SetTime( World, SpecialTimes[Command] )
	elseif Command == "set" and a_Split[4] ~= nil then
		SetTimeCommandParse()
	elseif Command == "add" and tonumber( a_Split[4] ) ~= nil then
		SetTime( World, CurrentTime + a_Split[4] )
	elseif Command == "query" and a_Split[4] ~= nil then
		QueryTimeCommandParse()
	else
		LOG(ConsoleTimeCommandUsage)
	end

	return true
end
