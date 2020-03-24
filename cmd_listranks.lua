function HandleListRanksCommand(Split, Player)
	local Ranks = cRankManager:GetAllRanks()
	return true, SendMessage(Player, "Available ranks: " .. table.concat(Ranks, cChatColor.Plain .. ", ") .. " (total: " .. #Ranks .. ")")
end

function HandleConsoleListRanks(Split)
	return HandleListRanksCommand(Split)
end
