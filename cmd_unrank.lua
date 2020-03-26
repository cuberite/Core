function HandleUnrankCommand(Split, Player)
	-- Also handles the /deop command
	local Response
	local PlayerName = Split[2]

	local InformLoadRank = function(OtherPlayer)
		local AuthorName = "the server console"
		
		if Player then
			AuthorName = "\"" .. Player:GetName() .. "\""
		end

		OtherPlayer:SendMessageInfo("You were unranked by " .. AuthorName)
		OtherPlayer:LoadRank()
	end

	if not PlayerName then
		Response = SendMessage(Player, "Usage: " .. Split[1] .. " <player>")
	else
		-- Translate the PlayerName to a UUID:
		local PlayerUUID = GetPlayerUUID(PlayerName)

		if not PlayerUUID or string.len(PlayerUUID) ~= 32 then
			Response = SendMessage(Player, "There is no player with the name \"" .. PlayerName .. "\"")
		else
			-- Unrank the player:
			cRankManager:RemovePlayerRank(PlayerUUID)

			-- Let the player know:
			SafeDoWithPlayer(PlayerName, InformLoadRank)

			Response = SendMessage(Player, "Player \"" .. PlayerName .. "\" is now in the default rank")
		end
	end
	return true, Response
end

function HandleConsoleUnrank(Split)
	return HandleUnrankCommand(Split)
end
