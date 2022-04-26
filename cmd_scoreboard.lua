local criterias =
{
	["achievement"] = cObjective.otAchievement,
	["deathCount"] = cObjective.otDeathCount,
	["dummy"] = cObjective.otDummy,
	["health"] = cObjective.otHealth,
	["playerKillCount"] = cObjective.otPlayerKillCount,
	["stat"] = cObjective.otStat,
	["statBlockMine"] = cObjective.otStatBlockMine,
	["statEntityKill"] = cObjective.otStatEntityKill,
	["statEntityKilledBy"] = cObjective.otStatEntityKilledBy,
	["statItemBreak"] = cObjective.otStatItemCraft,
	["statItemUse"] = cObjective.otStatItemUse,
	["totalKillCount"] = cObjective.otTotalKillCount,
}

local slots =
{
	["list"] = cScoreboard.dsList,
	["belowname"] = cScoreboard.dsName,
	["sidebar"] = cScoreboard.dsSidebar,
	["count"] = cScoreboard.dsCount,
}

local gPlayer = nil
local tPlayer = nil

function HandleScoreboardObjectivesCommand(Split, Player)
	local Response = Player:SendMessageFailure("add, remove, list, setdisplay, modify")
	local Scoreboard = Player:GetWorld():GetScoreBoard()
	gPlayer = Player

	if Split[3] == "list" then
		Response = Player:SendMessage(cCompositeChat():AddTextPart("DisplayName -> Name : Type", "u @2"))
		Scoreboard:ForEachObjective(sendListObjectives)
	end

	if Split[3] == "remove" then
		if not Split[4] then
			Response = Player:SendMessageInfo("/scoreboard objectives remove <objective>")
		elseif Scoreboard:RemoveObjective(Split[4]) then
			Response = Player:SendMessageSuccess(Split[4] .. " has been removed")
		else
			Response = Player:SendMessageFailure(Split[4] .. " does not exist")
		end
	end

	if Split[3] == "add" then
		if not Split[4] or not criterias[Split[5]] or not Split[6] then
			Response = Player:SendMessageInfo("/scoreboard objectives add <name> <criteria> <displayName>")
		else
			local Name = Split[4]
			local criteria = criterias[Split[5]]
			local DisplayName = Split[6]

			Scoreboard:RegisterObjective(Name, DisplayName, criteria)
			Response = Player:SendMessageSuccess("Objective " .. DisplayName .. " has been created")
		end
	end

	if Split[3] == "setdisplay" then
		if not slots[Split[4]] or not Split[5] then
			Response = Player:SendMessageInfo("/scoreboard objectives setdisplay <slot> <objective>")	
		else
			local slot = slots[Split[4]]
			local Objective = Scoreboard:GetObjective(Split[5]):GetName()

			Scoreboard:SetDisplay(Objective, slot)
			Response = Player:SendMessageSuccess("Objective " .. Objective .. " has been placed on " .. get_key_for_value(slots, slot))
		end
	end

	if Split[3] == "modify" then
		if not Split[4] or Split[5] ~= "displayName" or Split[6] then
			Response = Player:SendMessageInfo("/scoreboard objectives modify <objective> displayname <newName>")
		else
			local Objective = Scoreboard:GetObjective(Split[4])
			local newName = Split[6]

			Objective:SetDisplayName(newName)
			Response = Player:SendMessageSuccess("Objective " .. Objective:getName() .. " has been renamed to " .. newName)
		end
	end

	return true, Response
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
	gPlayer:SendMessage(Objective:GetDisplayName() .. " -> " .. Objective:GetName() .. ": " .. get_key_for_value(criterias, Objective:GetType()))
end

