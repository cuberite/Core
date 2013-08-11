function HandleDownfallCommand( Split, Player )
	World = Player:GetWorld()
	if World:GetWeather() == 0 then
		World:SetWeather(1)
	else
		World:SetWeather(0)
	end
	Player:SendMessage(cChatColor.Green .. "[INFO] " .. cChatColor.White .. "Downfall toggled")
	return true
end

function HandleWeatherCommand(Split, Player)
	if( #Split ~= 2 ) then
		Player:SendMessage( cChatColor.Green .. "Usage: /weather [Sun/Rain/Thunder]" )
		return true;
	end

	local Server = cRoot:Get():GetServer()
	if (Split[2] == "clear") then
		Player:GetWorld():SetWeather(0)
		Server:SendMessage( cChatColor.Green .. Player:GetName() .. " set the weather to Clear.")
	elseif (Split[2] == "rain") then
		Player:GetWorld():SetWeather(1)
		Server:SendMessage( cChatColor.Green .. Player:GetName() .. " set the weather to Rain.")
	elseif (Split[2] == "thunder") then
		Player:GetWorld():SetWeather(2)
		Server:SendMessage( cChatColor.Green .. Player:GetName() .. " set the weather to Thunder.")
      else
		Player:SendMessage( cChatColor.Green .. "Usage: /weather [Clear/Rain/Thunder]" )
	end
	return true
end
