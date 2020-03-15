function HandleMeCommand(Split, Player)
	local Response

	if not Split[2] then
		Response = SendMessage(Player, "Usage: " .. Split[1] .. " <action ...>")
	else
		cRoot:Get():BroadcastChat("* " .. Player:GetName() .. " " .. table.concat(Split , " " , 2))
	end
	return true, Response
end
