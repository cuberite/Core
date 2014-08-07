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
		Player:SendMessageSuccess("Setted own gamemode to " .. Split[2] .. "!")
		return true
	end

	local ChangeGM = function(OtherPlayer)
		OtherPlayer:SetGameMode(GameMode)
		if (OtherPlayer:GetName() == Player:GetName()) then
			Player:SendMessageSuccess("Setted own gamemode to " .. Split[2] .. "!")
		else
			OtherPlayer:SendMessageInfo(Player:GetName() .. " changed your gamemode to " .. Split[2] .. "!")
			Player:SendMessageSuccess("Setted gamemode from " .. OtherPlayer:GetName() .. " to " .. Split[2])
		end
		return true
	end

	local Success = cRoot:Get():FindAndDoWithPlayer(Split[3], ChangeGM)
	if (not Success) then
		SendMessageFailure(Player, "Player not found")
	end
	return true
end


function StringToGameMode(Str)
	if ((NoCaseCompare(Str, "survival") == 0) or (Str == "0")) then
		return gmSurvival
	elseif ((NoCaseCompare(Str, "creative") == 0) or (Str == "1")) then
		return gmCreative
	elseif ((NoCaseCompare(Str, "adventure") == 0) or (Str == "2")) then
		return gmAdventure
	elseif ((NoCaseCompare(Str, "spectator") == 0) or (Str == "3")) then
		-- return gmSpectator
		return 3
	else
		return nil
	end
end
