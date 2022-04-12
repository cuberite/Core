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


	return false
end

function sendListObjectives(Objective)
		gPlayer:SendMessageInfo(Objective:GetDisplayName() .. " -> " .. Objective:GetName() .. ": " .. Objective:GetType())
end
