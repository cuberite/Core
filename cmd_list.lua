function HandleListCommand(Split, Player)
	local PlayerTable = {}

	local ForEachPlayer = function(a_Player)
		table.insert(PlayerTable, a_Player:GetName())
	end
	cRoot:Get():ForEachPlayer(ForEachPlayer)
	table.sort(PlayerTable)

	local Response = SendMessage(Player, "Players (" .. #PlayerTable .. "): " .. table.concat(PlayerTable, ", "))
	return true, Response
end

function HandleConsoleList(Split)
	return HandleListCommand(Split)
end
