function HandleOpCommand(Split, Player)
	local Response

	if not Split[2] then
		Response = SendMessage(Player, "Usage: " .. Split[1] .. " <player>")
	else
		local PlayerName = Split[2]
		local AdminRank = GetAdminRank()

		if not AdminRank then
			Response = SendMessage(Player, "No admin rank found, missing * permission")
		else
			return HandleRankCommand({"rank", PlayerName, AdminRank}, Player)
		end
	end
	return true, Response
end

function HandleConsoleOp(Split)
	return HandleOpCommand(Split)
end
