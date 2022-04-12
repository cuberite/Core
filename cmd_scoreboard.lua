local criterias =
{
	["achievement"] = otAchievement,
	["deathCount"] = otDeathCount,
	["dummy"] = cObjective.otDummy,
	["health"] = otHealth,
	["playerKillCount"] = otPlayerKillCount,
	["stat"] = otStat,
	["statBlockMine"] = otStatBlockMine,
	["statEntityKill"] = otStatEntityKill,
	["statEntityKilledBy"] = otStatEntityKilledBy,
	["statItemBreak"] = otStatItemCraft,
	["statItemUse"] = otStatItemUse,
	["totalKillCount"] = otTotalKillCount,
}

local slots =
{
	["list"] = dsList,
	["belowname"] = dsName,
	["sidebar"] = cScoreboard.dsSidebar,
	["count"] = dsCount,
}

local gPlayer = nil
local tPlayer = nil

function HandleScoreboardObjectivesCommand(Split, Player)
	local Scoreboard = Player:GetWorld():GetScoreBoard()
	gPlayer = Player

	if Split[3] == "list" then
		Player:SendMessageInfo("DisplayName" .. " -> " .. "Name" .. ": " .. "Type")
		Scoreboard:ForEachObjective(sendListObjectives)
		return true
	end

	if Split[3] == "remove" then
		if not Split[4] then return false end

		local Objective = Scoreboard:GetObjective(Split[4])
		Objective:Reset()
		return true
	end

	if Split[3] == "add" then
		if not Split[4] or not criterias[Split[5]] or not Split[6] then return false end

		local Name = Split[4]
		local criteria = criterias[Split[5]]
		local DisplayName = Split[6]

		Scoreboard:RegisterObjective(Name, DisplayName, criteria)
		return true
	end

	if Split[3] == "setdisplay" then
		if not slots[Split[4]] or not Split[5] then return false end

		local slot = slots[Split[4]]
 		local Objective = Scoreboard:GetObjective(Split[5]):GetName()

 		Scoreboard:SetDisplay(Objective, slot)
		return true
	end

	if Split[3] == "modify" then
		if not Split[4] or Split[5] ~= "displayName" or Split[6] then return false end

		local Objective = Scoreboard:GetObjective(Split[4])
		local newName = Split[6]

		Objective:SetDisplayName(newName)

		return true
	end

	return false
end

function HandleScoreboardPlayersCommand(Split, Player)
	local Scoreboard = Player:GetWorld():GetScoreBoard()
	gPlayer = Player


	if not Split[4] then return false end
	tplayer = Split[4]

	if Split[3] == "list" then
		Player:SendMessageInfo("List of Score for " .. tplayer .. ": ")
		Scoreboard:ForEachObjective(listObjectiveofPlayer)
		return true
	end

	if Split[3] == "reset" then
		if Split[5] then
			local Objective = Scoreboard:GetObjective(Split[5])
			Objective:ResetScore(tplayer)
			return true
		end
		Scoreboard:ForEachObjective(resetAllObjectives)
		return true
	end

	if not Split[5] then return false end
	local tObjective = Scoreboard:GetObjective(Split[5])

	if Split[3] == "get" then
		tObjective:GetScore(tplayer)
		return true
	end

	if Split[3] == "set" then
		if not Split[6] then return false end
		tObjective:SetScore(tplayer, Split[6])
		return true
	end

	if Split[3] == "add" then
		if not Split[6] then return false end
		tObjective:AddScore(tplayer, Split[6])
		return true
	end

	if Split[3] == "remove" then
		if not Split[6] then return false end
		tObjective:SubScore(tplayer, Split[6])
		return true
	end

	if Split[3] == "operation" then
		if not Split[8] then return false end
		local operation = Split[6]
		local sourcePlayer = Split[7]
		local sourceObjective = Scoreboard:getObjective(Split[8])

		if operator == "+=" then
			tObjective:SetScore(tPlayer, tObjective:GetScore(tPlayer) + sourceObjective:GetScore(sourcePlayer))
			return true
		end
		if operator == "-=" then
			tObjective:SetScore(tPlayer, tObjective:GetScore(tPlayer) - sourceObjective:GetScore(sourcePlayer))
			return true
		end
		if operator == "*=" then
			tObjective:SetScore(tPlayer, tObjective:GetScore(tPlayer) * sourceObjective:GetScore(sourcePlayer))
			return true
		end
		if operator == "/=" then
			tObjective:SetScore(tPlayer, tObjective:GetScore(tPlayer) / sourceObjective:GetScore(sourcePlayer))
			return true
		end
		if operator == "%=" then
			tObjective:SetScore(tPlayer, tObjective:GetScore(tPlayer) % sourceObjective:GetScore(sourcePlayer))
			return true
		end
		if operator == "=" then
			tObjective:SetScore(tPlayer, sourceObjective:GetScore(sourcePlayer))
			return true
		end
		if operator == "<" then
			if sourceObjective:GetScore(sourcePlayer) < tObjective:GetScore(tPlayer) then
				tObjective:SetScore(tPlayer, sourceObjective:GetScore(sourcePlayer))
			end
			return true
		end
		if operator == ">" then
			if sourceObjective:GetScore(sourcePlayer) > tObjective:GetScore(tPlayer) then
				tObjective:SetScore(tPlayer, sourceObjective:GetScore(sourcePlayer))
			end
			return true
		end
		if operator == "><" then
			local temp = sourceObjective:GetScore(sourcePlayer)
			sourceObjective:SetScore(tObjective:GetScore(tPlayer))
			tObjective:SetScore(tPlayer, sourceObjective:GetScore(sourcePlayer))
			return true
		end
	end
	return false
end

function listObjectiveofPlayer(Objective)
	local score = Objective:GetScore(tplayer)
	if score then
		gPlayer:SendMessageInfo(Objective:GetDisplayName() .. " -> " .. score)
	end
end

function resetAllObjectives(Objective)
	Objetive:ResetScore(tplayer)
end

function sendListObjectives(Objective)
	gPlayer:SendMessageInfo(Objective:GetDisplayName() .. " -> " .. Objective:GetName() .. ": " .. Objective:GetType())
end
