function HandleWeatherCommand(Split, Player)
	if( #Split ~= 2 ) then
		Player:SendMessage(cChatColor.Yellow .. "[INFO] " .. "Usage: /weather [clear/rain/thunder]" )
		return true;
	end

	if (Split[2] == "clear") then
		Player:GetWorld():SetWeather(0)
		Player:SendMessage(cChatColor.Green .. "[INFO] " .. "Downfall stopped" )
	elseif (Split[2] == "rain") then
		Player:GetWorld():SetWeather(1)
		Player:SendMessage(cChatColor.Green .. "[INFO] " .. "Let it rain!" )
	elseif (Split[2] == "thunder") then
		Player:GetWorld():SetWeather(2)
		Player:SendMessage(cChatColor.Green .. "[INFO] " .. "Thundery showers activate!")
	end
	
	return true
end
