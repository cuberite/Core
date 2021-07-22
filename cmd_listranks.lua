function HandleListRanksCommand(Split, Player)
	local Ranks = cRankManager:GetAllRanks()
	local ResetColor = cChatColor.Plain

	if not Player then
		-- Color codes are not used in the console
		ResetColor = ""
	end

	return true, SendMessage(Player, "Available ranks: " .. table.concat(Ranks, ResetColor .. ", ") .. " (total: " .. #Ranks .. ")")
end

function HandleConsoleListRanks(Split)
	return HandleListRanksCommand(Split)
end
