
-- ranks.lua

-- Handles the rank-related commands





function HandleListRanksCommand(a_Split, a_Player)
	local Ranks = cRankManager:GetAllRanks()
	SendMessageSuccess(a_Player, "Ranks available: " .. table.concat(Ranks, ", ") .. " (total: " .. #Ranks .. ")")
	return true
end





function HandleRankCommand(a_Split, a_Player)
	-- Check the params:
	if ((a_Split[2] == nil) or (a_Split[4] ~= nil)) then
		-- Too many or too few parameters, print the usage:
		SendMessage(a_Player, "Usage: /rank <PlayerName> [<RankName>]")
		return true
	end

	-- Translate the PlayerName to a UUID:
	local PlayerName = a_Split[2]
	local PlayerUUID = cMojangAPI:GetUUIDFromPlayerName(PlayerName)
	if ((PlayerUUID == nil) or (string.len(PlayerUUID) ~= 32)) then
		SendMessage(a_Player, "There is no such player: " .. PlayerName)
		return true
	end
	
	-- View the player's rank, if requested:
	if (a_Split[3] == nil) then
		-- "/rank <PlayerName>" usage, display the rank:
		local CurrRank = cRankManager:GetPlayerRankName(PlayerUUID)
		if (CurrRank == "") then
			SendMessageSuccess(a_Player, "The player has no rank assigned to them.")
		else
			SendMessageSuccess(a_Player, "The player's rank is " .. CurrRank)
		end
		return true
	end

	-- Change the player's rank:
	local NewRank = a_Split[3]
	if not(cRankManager:RankExists(NewRank)) then
		SendMessage(a_Player, "The specified rank does not exist!")
		return true
	end
	cRankManager:SetPlayerRank(PlayerUUID, PlayerName, NewRank)

	-- Update all players in the game of the given name and let them know:
	cRoot:Get():ForEachPlayer(
		function(a_CBPlayer)
			if (a_CBPlayer:GetName() == PlayerName) then
				a_CBPlayer:SendMessage("You were assigned the rank " .. NewRank .. " by " .. a_Player:GetName() .. ".")
				a_CBPlayer:LoadRank()
			end
		end
	)
	return true
end




