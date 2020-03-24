function HandleDeOpCommand(Split, Player)
	if not Split[2] then
		return true, SendMessage(Player, "Usage: " .. Split[1] .. " <player>")
	else
		local PlayerName = Split[2]
		local DefaultRank = cRankManager:GetDefaultRank()

		return HandleRankCommand({"rank", PlayerName, DefaultRank}, Player)
	end
end

function HandleConsoleDeOp(Split)
	return HandleDeOpCommand(Split)
end
