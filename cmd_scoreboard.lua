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
	local Response
	local Scoreboard
	if Player then
		Scoreboard = Player:GetWorld():GetScoreBoard()
		gPlayer = Player
	else
		Scoreboard = cRoot:Get():GetDefaultWorld():GetScoreBoard()
	end

	if not Split[3] then
		Response = SendMessageFailure(Player, "add, remove, list, setdisplay, modify")
	end

	if Split[3] == "list" then
		Response = SendMessage(Player, cCompositeChat():AddTextPart("DisplayName -> Name : Type", "u @2"))
		Scoreboard:ForEachObjective(sendListObjectives)
	end

	if Split[3] == "remove" then
		if not Split[4] then
			Response = SendMessage(Player, "/scoreboard objectives remove <objective>")
		elseif Scoreboard:RemoveObjective(Split[4]) then
			Response = SendMessageSuccess(Player, Split[4] .. " has been removed")
		else
			Response = SendMessageFailure(Player, Split[4] .. " does not exist")
		end
	end

	if Split[3] == "add" then
		if not Split[4] or not criterias[Split[5]:lower()] or not Split[6] then
			Response = SendMessage(Player, "/scoreboard objectives add <name> <criteria> <displayName>")
		else
			local Name = Split[4]
			local criteria = criterias[Split[5]:lower()]
			local DisplayName = Split[6]

			Scoreboard:RegisterObjective(Name, DisplayName, criteria)
			Response = SendMessageSuccess(Player, "Objective " .. DisplayName .. " has been created")
		end
	end

	if Split[3] == "setdisplay" then
		if not slots[Split[4]:lower()] or not Split[5] then
			Response = SendMessage(Player, "/scoreboard objectives setdisplay <slot> <objective>")
		else
			local slot = slots[Split[4]:lower()]
			local Objective = Scoreboard:GetObjective(Split[5]):GetName()

			Scoreboard:SetDisplay(Objective, slot)
			Response = SendMessageSuccess(Player, "Objective " .. Objective .. " has been placed on " .. get_key_for_value(slots, slot))
		end
	end

	if Split[3] == "modify" then
		if not Split[4] or Split[5] ~= "displayName" or Split[6] then
			Response = SendMessage(Player, "/scoreboard objectives modify <objective> displayname <newName>")
		else
			local Objective = Scoreboard:GetObjective(Split[4])
			local newName = Split[6]

			Objective:SetDisplayName(newName)
			Response = SendMessageSuccess(Player, "Objective " .. Objective:getName() .. " has been renamed to " .. newName)
		end
	end

	return true, Response
end

function HandleScoreboardPlayersCommand(Split, Player)
	local Scoreboard
	local Response = SendMessageFailure(Player, "list, reset, get, set, add, remove, operation")

	if Player then
		Scoreboard = Player:GetWorld():GetScoreBoard()
		gPlayer = Player
	else
		Scoreboard = cRoot:Get():GetDefaultWorld():GetScoreBoard()
	end

	tplayer = Split[4]

	if Split[3] == "list" then
		if not Split[4] then
			Response = SendMessage(Player, "/scoreboard players list <player>")
		else
			Response = SendMessage(Player, "List of scores for " .. tplayer .. ": ")
			Scoreboard:ForEachObjective(listObjectiveofPlayer)
		end
	end

	if Split[3] == "reset" then
		if not Split[4] then
			Response = SendMessage(Player, "/scoreboard players reset (<player>)")
		else
			if  Split[5] then
				local Objective = Scoreboard:GetObjective(Split[5])
				Objective:ResetScore(tplayer)
			else
				Scoreboard:ForEachObjective(resetAllObjectives)
			end
			Response = SendMessageSuccess(Player, "Player's Score(s) has successfully been reseted")
		end
	end

	if Split[3] == "get" then
		if not Split[4] or not Split[5] then
			Response = SendMessage(Player, "/scoreboard players get <player> <objective>")
		else
			local tObjective = Scoreboard:GetObjective(Split[5])
			Response = SendMessage(Player, tObjective:GetScore(tplayer))
		end
	end

	if Split[3] == "set" then
		if not Split[4] or not Split[5] or not Split[6] then
			Response = SendMessage(Player, "/scoreboard players set <player> <objective> <ammount>")
		else	
			local tObjective = Scoreboard:GetObjective(Split[5])
			tObjective:SetScore(tplayer, Split[6])
			Response = SendMessageSuccess(Player, "Score " .. Split[6] .. " successfully assigned to " .. tplayer)
		end
	end

	if Split[3] == "add" then
		if not Split[4] or not Split[5] or not Split[6] then
			Response = SendMessage(Player, "/scoreboard players set <player> <objective> <ammount>")
		else	
			local tObjective = Scoreboard:GetObjective(Split[5])
			tObjective:AddScore(tplayer, Split[6])
			Response = SendMessageSuccess(Player, "Score " .. Split[6] .. " successfully increased to " .. tplayer)
		end
	end

	if Split[3] == "remove" then
		if not Split[4] or not Split[5] or not Split[6] then
			Response = SendMessage(Player, "/scoreboard players set <player> <objective> <ammount>")
		else	
			local tObjective = Scoreboard:GetObjective(Split[5])
			tObjective:SubScore(tplayer, Split[6])
			Response = SendMessageSuccess(Player, "Score " .. Split[6] .. " successfully decreased to " .. tplayer)
		end
	end

	if Split[3] == "operation" then
		if not Split[4] or not Split[5] or not Split[6] or not Split[7] or not Split[8] then
			Response = SendMessage(Player, "/scoreboard players operation <targetPlayer> <targetObjective> <operation> <sourcePlayer> <sourceObjective>")
		else
			local tObjective = Scoreboard:GetObjective(Split[5])
			local operation = Split[6]
			local sourcePlayer = Split[7]
			local sourceObjective = Scoreboard:getObjective(Split[8])

			if operator == "+=" then
				tObjective:SetScore(tPlayer, tObjective:GetScore(tPlayer) + sourceObjective:GetScore(sourcePlayer))
				Response = SendMessage(Player, tObjective:GetDisplayName() .. ":" .. tPlayer:GetName() .. " increased by " .. sourceObjective:GetDisplayName() .. ":" .. sourcePlayer:GetName())
			elseif operator == "-=" then
				tObjective:SetScore(tPlayer, tObjective:GetScore(tPlayer) - sourceObjective:GetScore(sourcePlayer))
				Response = SendMessage(Player, tObjective:GetDisplayName() .. ":" .. tPlayer:GetName() .. " decreased by " .. sourceObjective:GetDisplayName() .. ":" .. sourcePlayer:GetName())
			elseif operator == "*=" then
				Response = SendMessage(Player, tObjective:GetDisplayName() .. ":" .. tPlayer:GetName() .. " multiplied by " .. sourceObjective:GetDisplayName() .. ":" .. sourcePlayer:GetName())
				tObjective:SetScore(tPlayer, tObjective:GetScore(tPlayer) * sourceObjective:GetScore(sourcePlayer))
			elseif operator == "/=" then
				Response = SendMessage(Player, tObjective:GetDisplayName() .. ":" .. tPlayer:GetName() .. " divided by " .. sourceObjective:GetDisplayName() .. ":" .. sourcePlayer:GetName())
				tObjective:SetScore(tPlayer, tObjective:GetScore(tPlayer) / sourceObjective:GetScore(sourcePlayer))
			elseif operator == "%=" then
				Response = SendMessage(Player, tObjective:GetDisplayName() .. ":" .. tPlayer:GetName() .. " moduled by " .. sourceObjective:GetDisplayName() .. ":" .. sourcePlayer:GetName())
				tObjective:SetScore(tPlayer, tObjective:GetScore(tPlayer) % sourceObjective:GetScore(sourcePlayer))
			elseif operator == "=" then
				Response = SendMessage(Player, tObjective:GetDisplayName() .. ":" .. tPlayer:GetName() .. " set to " .. sourceObjective:GetDisplayName() .. ":" .. sourcePlayer:GetName())
				tObjective:SetScore(tPlayer, sourceObjective:GetScore(sourcePlayer))
			elseif operator == "<" then
				if sourceObjective:GetScore(sourcePlayer) < tObjective:GetScore(tPlayer) then
					tObjective:SetScore(tPlayer, sourceObjective:GetScore(sourcePlayer))
					Response = SendMessage(Player, tObjective:GetDisplayName() .. ":" .. tPlayer:GetName() .. " set to " .. sourceObjective:GetDisplayName() .. ":" .. sourcePlayer:GetName())
				end
			elseif operator == ">" then
				if sourceObjective:GetScore(sourcePlayer) > tObjective:GetScore(tPlayer) then
					tObjective:SetScore(tPlayer, sourceObjective:GetScore(sourcePlayer))
					Response = SendMessage(Player, tObjective:GetDisplayName() .. ":" .. tPlayer:GetName() .. " set to " .. sourceObjective:GetDisplayName() .. ":" .. sourcePlayer:GetName())
				end
			elseif operator == "><" then
				local temp = sourceObjective:GetScore(sourcePlayer)
				sourceObjective:SetScore(tObjective:GetScore(tPlayer))
				tObjective:SetScore(tPlayer, sourceObjective:GetScore(sourcePlayer))
				Response = SendMessage(Player, tObjective:GetDisplayName() .. ":" .. tPlayer:GetName() .. " and " .. sourceObjective:GetDisplayName() .. ":" .. sourcePlayer:GetName() .. " have been switched")
			else
				Response = SendMessage(Player, "operators: +=, -=, *=, /=, %=, =, <, >, ><")
			end
		end
	end
	return true, Response 
end

function listObjectiveofPlayer(Objective)
	local score = Objective:GetScore(tplayer)
	if score then
		if gPlayer then
			gPlayer:SendMessage(Objective:GetDisplayName() .. " -> " .. score)
		else
			LOG(Objective:GetDisplayName() .. " -> " .. score)
		end
	end
end

function resetAllObjectives(Objective)
	Objetive:ResetScore(tplayer)
end

function sendListObjectives(Objective)
	if gPlayer then
		gPlayer:SendMessage(Objective:GetDisplayName() .. " -> " .. Objective:GetName() .. ": " .. get_key_for_value(criterias, Objective:GetType()))
	else
		LOG(Objective:GetDisplayName() .. " -> " .. Objective:GetName() .. ": " .. get_key_for_value(criterias, Objective:GetType()))
	end
end


-- Handle commands for console

function HandleConsoleScoreboardObjectives(Split)
	return HandleScoreboardObjectivesCommand(Split)
end

function HandleConsoleScoreboardPlayers(Split)
	return HandleScoreboardPlayersCommand(Split)
end
