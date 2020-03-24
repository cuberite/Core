function HandleRankCommand(Split, Player)
	local Response
	local PlayerName = Split[2]
	local NewRank = Split[3]
	
	local InformLoadRank = function(OtherPlayer)
		if PlayerName == OtherPlayer:GetName() then
			local Actor = "the server console"
			
			if Player then
				Actor = "player \"" .. Player:GetName() .. "\""
			end

			OtherPlayer:SendMessageInfo("You were assigned the rank " .. NewRank .. " by " .. Actor)
			OtherPlayer:LoadRank()
		end
	end

	if not PlayerName then
		Response = SendMessage(Player, "Usage: " .. Split[1] .. " <player> [rank]")
	else
		-- Translate the PlayerName to a UUID:
		local PlayerUUID = GetPlayerUUID(PlayerName)

		if not PlayerUUID or string.len(PlayerUUID) ~= 32 then
			Response = SendMessage(Player, "There is no player with the name \"" .. PlayerName .. "\"")
		else
			-- View the player's rank, if requested:
			if not NewRank then
				-- "/rank <PlayerName>" usage, display the rank:
				local CurrentRank = cRankManager:GetPlayerRankName(PlayerUUID)

				if CurrentRank == "" then
					Response = SendMessage(Player, "Player \"" .. PlayerName .. "\" has no rank assigned to them.")
				else
					Response = SendMessage(Player, "The rank of player \"" .. PlayerName .. "\" is " .. CurrentRank)
				end
			else
				-- Change the player's rank:
				if not cRankManager:RankExists(NewRank) then
					Response = SendMessage(Player, "The specified rank does not exist!")
				else
					cRankManager:SetPlayerRank(PlayerUUID, PlayerName, NewRank)

					-- Let the player know:
					SafeDoWithPlayer(PlayerName, InformLoadRank)

					local CurrentRank = cRankManager:GetPlayerRankName(PlayerUUID)
					Response = SendMessageSuccess(Player, "Player \"" .. PlayerName .. "\" is now in rank " .. CurrentRank)
				end
			end
		end
	end
	return true, Response
end

function HandleConsoleRank(Split)
	return HandleRankCommand(Split)
end
