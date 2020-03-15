function HandleSeedCommand(Split, Player)
	local World = cRoot:Get():GetDefaultWorld()

	if Split[2] then
		World = cRoot:Get():GetWorld(Split[2])
	elseif Player then
		World = Player:GetWorld()
	end
	
	if not World then
		SendMessage(Player, "There is no world \"" .. Split[2] .. "\"")
	else
		SendMessage(Player, "Seed: " .. World:GetSeed())
	end
	return true
end
