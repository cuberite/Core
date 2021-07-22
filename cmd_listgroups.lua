function HandleListGroupsCommand(Split, Player)
	local Response

	if Split[3] then
		return true, SendMessage("Usage: " .. Split[1] .. " [rank]")
	end

	-- If no params are given, list all groups that the manager knows:
	local RankName = Split[2]
	local ResetColor = cChatColor.Plain

	if not Player then
		-- Color codes are not used in the console
		ResetColor = ""
	end

	if not RankName then
		-- Get all the groups:
		local Groups = cRankManager:GetAllGroups()

		Response = SendMessage(Player, "Available groups: " .. table.concat(Groups, ResetColor .. ", ") .. " (total: " .. #Groups .. ")")
	else
		-- A rank name is given, list the groups in that rank:
		local Groups = cRankManager:GetRankGroups(RankName)

		Response = SendMessage(Player, "Groups in rank " .. RankName .. ": " .. table.concat(Groups, ResetColor .. ", ") .. " (total: " .. #Groups .. ")")
	end
	return true, Response
end

function HandleConsoleListGroups(Split)
	return HandleListGroupsCommand(Split)
end
