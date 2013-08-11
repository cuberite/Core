function HandleDownfallCommand( Split, Player )

	World = Player:GetWorld()

	if World:GetWeather() == 0 then
		World:SetWeather( 1 )
	else
		World:SetWeather( 0 )
	end

	SendMessageSuccess( Player, "Downfall toggled" )
	return true

end
