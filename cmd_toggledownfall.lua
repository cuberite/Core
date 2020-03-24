function HandleToggleDownfallCommand(Split, Player)
	local Response

	local WorldName = Split[2]
	local World = GetWorld(WorldName, Player)  -- Function is in functions.lua

	if not World then
		Response = SendMessage(Player, "There is no world \"" .. WorldName .. "\"")
	else
		-- Toggle between sun and rain
		World:SetWeather(World:IsWeatherWet() and wSunny or wRain)

		Response = SendMessageSuccess(Player, "Toggled downfall in world \"" .. World:GetName() .. "\"")
	end
	return true, Response
end

function HandleConsoleToggleDownfall(Split)
	return HandleToggleDownfallCommand(Split)
end
