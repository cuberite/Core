function HandleSeedCommand(Split, Player)
	local Response

	local World = cRoot:Get():GetDefaultWorld()

	if Split[2] then
		World = cRoot:Get():GetWorld(Split[2])
	elseif Player then
		World = Player:GetWorld()
	end
	
	if not World then
		Response = SendMessage(Player, "There is no world \"" .. Split[2] .. "\"")
	else
		Response = SendMessage(Player, "Seed: " .. World:GetSeed())
	end
	return true, Response
end
