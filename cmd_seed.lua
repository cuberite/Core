function HandleSeedCommand(Split, Player)
	local Response

	local WorldName = Split[2]
	local World = GetWorld(WorldName, Player)
	
	if not World then
		Response = SendMessage(Player, "There is no world \"" .. WorldName .. "\"")
	else
		Response = SendMessage(Player, "Seed: " .. World:GetSeed())
	end
	return true, Response
end
