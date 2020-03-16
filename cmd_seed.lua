function HandleSeedCommand(Split, Player)
	local Response

	local WorldName = Split[2]
	local World = GetWorld(WorldName, Player)
	
	if not World then
		Response = SendMessage(Player, "There is no world \"" .. WorldName .. "\"")
	else
		Response = SendMessage(Player, "Seed of world \"" .. World:GetName() .. "\": " .. World:GetSeed())
	end
	return true, Response
end

function HandleConsoleSeed(Split)
	return HandleSeedCommand(Split)
end
