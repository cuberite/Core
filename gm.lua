function HandleChangeGMCommand(Split, Player)
	if (Split[2] == nil) then
		SendMessage(Player, "Usage: " .. Split[1] .. " [survival|creative|adventure|spectator] [player] ")
		return true
	end

	local GameMode = StringToGameMode(Split[2])
	if (GameMode == nil) then
		SendMessage(Player, "Usage: " .. Split[1] .. " [survival|creative|adventure|spectator] [player] ")
		return true
	end

	if (Split[3] == nil) then
		Player:SetGameMode(GameMode)
		Player:SendMessageSuccess("You set your own gamemode to " .. Split[2])
		return true
	end

	local ChangeGM = function(OtherPlayer)
		OtherPlayer:SetGameMode(GameMode)
		if (OtherPlayer:GetName() == Player:GetName()) then
			Player:SendMessageSuccess("You set your own gamemode to " .. Split[2])
		else
			OtherPlayer:SendMessageInfo(Player:GetName() .. " changed your gamemode to " .. Split[2])
			Player:SendMessageSuccess("Set gamemode of " .. OtherPlayer:GetName() .. " to " .. Split[2])
		end
		return true
	end

	local Success = cRoot:Get():FindAndDoWithPlayer(Split[3], ChangeGM)
	if (not Success) then
		SendMessageFailure(Player, "Player not found")
	end
	return true
end


local GameModeTable =
{
	["survival"] =  gmSurvival,
	["creative"] =  gmCreative,
	["adventure"] = gmAdventure,
	["spectator"] = 3,
}

function StringToGameMode(Str)
	local Number = tonumber(Str)
	if ((Number ~= nil) and (Number >= gmMin) and (Number <= gmMax)) then
		return Number
	end

	local StrLower = string.lower(Str)
	return GameModeTable[StrLower]
end
