
-- Translate from weather descriptors to the weather value
-- Non-Vanilla weather descriptors were kept from previous console implementation
local WeatherNames =
{
	["clear"]        = wSunny,
	["sunny"]        = wSunny,
	["sun"]          = wSunny,
	["rain"]         = wRain,
	["rainy"]        = wRain,
	["storm"]        = wStorm,
	["thunder"]      = wStorm,
	["thunderstorm"] = wStorm,
	["lightning"]    = wStorm,
}

-- Strings displayed when changing to the specified weather conditions
local WeatherChanges =
{
	[wSunny] = "Changing to clear weather in world: ",
	[wRain]  = "Changing to rainy weather in world: ",
	[wStorm] = "Changing to rain and thunder in world: ",
}


--- Handles In-game and Console `weather` commands
-- 
--  @param Player is nil when called by console command
--  
function HandleWeatherCommand(Split, Player)
	local Response

	-- Parse the command into its components
	local Weather = WeatherNames[Split[2]]
	local TPS = 20
	local TicksToChange = (tonumber(Split[3]) or 0) * TPS
	local WorldName = Split[4]

	if not tonumber(Split[3]) then
		WorldName = Split[3]
	end
	
	local World = GetWorld(WorldName, Player)  -- Function is in functions.lua

	if not Weather then
		Response = SendMessage(Player, "Usage: " .. Split[1] .. " <clear|rain|thunder> [duration in seconds] [world]")
	elseif not World then
		Response = SendMessage(Player, "There is no world \"" .. WorldName .. "\"")
	else
		World:SetWeather(Weather)

		if TicksToChange ~= 0 then
			World:SetTicksUntilWeatherChange(TicksToChange)
		end
		
		Response = SendMessageSuccess(Player, WeatherChanges[Weather] .. World:GetName())
	end
	return true, Response
end

function HandleConsoleWeather(Split)
	return HandleWeatherCommand(Split)
end
