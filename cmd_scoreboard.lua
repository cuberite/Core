local Criterias =
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

local Slots =
{
	["list"] = cScoreboard.dsList,
	["belowname"] = cScoreboard.dsName,
	["sidebar"] = cScoreboard.dsSidebar,
	["count"] = cScoreboard.dsCount,
}


function HandleScoreboardObjectivesCommand(Split, Player)
	local Response
	local Scoreboard
	local MultiLineResponse = {}

	if Player then
		Scoreboard = Player:GetWorld():GetScoreBoard()
	else
		Scoreboard = cRoot:Get():GetDefaultWorld():GetScoreBoard()
	end

	local SendListObjectives = function(Objective)
		table.insert(MultiLineResponse, SendMessage(Player, Objective:GetDisplayName() .. " -> " .. Objective:GetName() .. ": " .. get_key_for_value(Criterias, Objective:GetType())))
	end

	if not Split[3] then
		Response = SendMessageFailure(Player, "add, remove, list, setdisplay, modify")

	elseif Split[3] == "list" then
		Response = SendMessage(Player, cCompositeChat():AddTextPart("DisplayName -> Name : Type", "2n"))
		Scoreboard:ForEachObjective(SendListObjectives)

	elseif Split[3] == "remove" then
		if not Split[4] then
			Response = SendMessage(Player, "/scoreboard objectives remove <objective>")
		elseif Scoreboard:RemoveObjective(Split[4]) then
			Response = SendMessageSuccess(Player, Split[4] .. " has been removed")
		else
			Response = SendMessageFailure(Player, Split[4] .. " does not exist")
		end

	elseif Split[3] == "add" then
		if not Split[4] or not Criterias[Split[5]:lower()] or not Split[6] then
			Response = SendMessage(Player, "/scoreboard objectives add <name> <criteria> <displayName>")
		else
			local Name = Split[4]
			local Criteria = Criterias[Split[5]:lower()]
			local DisplayName = Split[6]

			Scoreboard:RegisterObjective(Name, DisplayName, Criteria)
			Response = SendMessageSuccess(Player, "Objective " .. DisplayName .. " has been created")
		end

	elseif Split[3] == "setdisplay" then
		if not Slots[Split[4]:lower()] or not Split[5] then
			Response = SendMessage(Player, "/scoreboard objectives setdisplay <slot> <objective>")
		else
			local Slot = Slots[Split[4]:lower()]
			local Objective = Scoreboard:GetObjective(Split[5]):GetName()

			Scoreboard:SetDisplay(Objective, Slot)
			Response = SendMessageSuccess(Player, "Objective " .. Objective .. " has been placed on " .. get_key_for_value(Slots, Slot))
		end

	elseif Split[3] == "modify" then
		if not Split[4] or Split[5] ~= "displayName" or Split[6] then
			Response = SendMessage(Player, "/scoreboard objectives modify <objective> displayname <newName>")
		else
			local Objective = Scoreboard:GetObjective(Split[4])
			local NewName = Split[6]

			Objective:SetDisplayName(NewName)
			Response = SendMessageSuccess(Player, "Objective " .. Objective:getName() .. " has been renamed to " .. NewName)
		end
	end

	table.insert(MultiLineResponse, 1, Response) -- Add the response of the command as first line
	return true, table.concat(MultiLineResponse, "\n")
end

function HandleScoreboardPlayersCommand(Split, Player)
	local Scoreboard
	local Response
	local TargetedPlayer = Split[4]
	local MultiLineResponse = {}

	if Player then
		Scoreboard = Player:GetWorld():GetScoreBoard()
	else
		Scoreboard = cRoot:Get():GetDefaultWorld():GetScoreBoard()
	end

	local ListPlayerObjective = function(Objective)
		local Score = Objective:GetScore(TargetedPlayer)
		if Score then
			table.insert(MultiLineResponse,SendMessage(GlobalPlayer, Objective:GetDisplayName() .. " -> " .. Score))
		end
	end

	local ResetAllObjectives = function(Objective)
		Objetive:ResetScore(TargetedPlayer)
	end

	if not Split[3] then
		Response = SendMessageFailure(Player, "list, reset, get, set, add, remove, operation")

	elseif Split[3] == "list" then
		if not Split[4] then
			Response = SendMessage(Player, "/scoreboard players list <player>")
		else
			Response = SendMessage(Player, "List of scores for " .. TargetedPlayer .. ": ")
			Scoreboard:ForEachObjective(ListPlayerObjective)
		end

	elseif Split[3] == "reset" then
		if not Split[4] then
			Response = SendMessage(Player, "/scoreboard players reset (<player>)")
		else
			if Split[5] then
				local Objective = Scoreboard:GetObjective(Split[5])
				Objective:ResetScore(TargetedPlayer)
			else
				Scoreboard:ForEachObjective(ResetAllObjectives)
			end
			Response = SendMessageSuccess(Player, "Player's Score(s) has successfully been reseted")
		end

	elseif Split[3] == "get" then
		if not Split[4] or not Split[5] then
			Response = SendMessage(Player, "/scoreboard players get <player> <objective>")
		else
			local TargetedObjective = Scoreboard:GetObjective(Split[5])
			Response = SendMessage(Player, TargetedObjective:GetScore(TargetedPlayer))
		end

	elseif Split[3] == "set" then
		if not Split[4] or not Split[5] or not Split[6] then
			Response = SendMessage(Player, "/scoreboard players set <player> <objective> <ammount>")
		else	
			local TargetedObjective = Scoreboard:GetObjective(Split[5])
			TargetedObjective:SetScore(TargetedPlayer, Split[6])
			Response = SendMessageSuccess(Player, "Score " .. Split[6] .. " successfully assigned to " .. TargetedPlayer)
		end

	elseif Split[3] == "add" then
		if not Split[4] or not Split[5] or not Split[6] then
			Response = SendMessage(Player, "/scoreboard players set <player> <objective> <ammount>")
		else	
			local TargetedObjective = Scoreboard:GetObjective(Split[5])
			TargetedObjective:AddScore(TargetedPlayer, Split[6])
			Response = SendMessageSuccess(Player, "Score " .. Split[6] .. " successfully increased to " .. TargetedPlayer)
		end

	elseif Split[3] == "remove" then
		if not Split[4] or not Split[5] or not Split[6] then
			Response = SendMessage(Player, "/scoreboard players set <player> <objective> <ammount>")
		else	
			local TargetedObjective = Scoreboard:GetObjective(Split[5])
			TargetedObjective:SubScore(TargetedPlayer, Split[6])
			Response = SendMessageSuccess(Player, "Score " .. Split[6] .. " successfully decreased to " .. TargetedPlayer)
		end

	elseif Split[3] == "operation" then
		if not Split[4] or not Split[5] or not Split[6] or not Split[7] or not Split[8] then
			Response = SendMessage(Player, "/scoreboard players operation <targetPlayer> <targetObjective> <operation> <sourcePlayer> <sourceObjective>")
		else
			local TargetedObjective = Scoreboard:GetObjective(Split[5])
			local Operator = Split[6]
			local SourcePlayer = Split[7]
			local SourceObjective = Scoreboard:GetObjective(Split[8])

			if Operator == "+=" then
				TargetedObjective:SetScore(TargetedPlayer, TargetedObjective:GetScore(TargetedPlayer) + SourceObjective:GetScore(SourcePlayer))
				Response = SendMessage(Player, TargetedObjective:GetDisplayName() .. ":" .. TargetedPlayer:GetName() .. " increased by " .. SourceObjective:GetDisplayName() .. ":" .. SourcePlayer:GetName())
			elseif Operator == "-=" then
				TargetedObjective:SetScore(TargetedPlayer, TargetedObjective:GetScore(TargetedPlayer) - SourceObjective:GetScore(SourcePlayer))
				Response = SendMessage(Player, TargetedObjective:GetDisplayName() .. ":" .. TargetedPlayer:GetName() .. " decreased by " .. SourceObjective:GetDisplayName() .. ":" .. SourcePlayer:GetName())
			elseif Operator == "*=" then
				Response = SendMessage(Player, TargetedObjective:GetDisplayName() .. ":" .. TargetedPlayer:GetName() .. " multiplied by " .. SourceObjective:GetDisplayName() .. ":" .. SourcePlayer:GetName())
				TargetedObjective:SetScore(TargetedPlayer, TargetedObjective:GetScore(TargetedPlayer) * SourceObjective:GetScore(SourcePlayer))
			elseif Operator == "/=" then
				Response = SendMessage(Player, TargetedObjective:GetDisplayName() .. ":" .. TargetedPlayer:GetName() .. " divided by " .. SourceObjective:GetDisplayName() .. ":" .. SourcePlayer:GetName())
				TargetedObjective:SetScore(TargetedPlayer, TargetedObjective:GetScore(TargetedPlayer) / SourceObjective:GetScore(SourcePlayer))
			elseif Operator == "%=" then
				Response = SendMessage(Player, TargetedObjective:GetDisplayName() .. ":" .. TargetedPlayer:GetName() .. " moduled by " .. SourceObjective:GetDisplayName() .. ":" .. SourcePlayer:GetName())
				TargetedObjective:SetScore(TargetedPlayer, TargetedObjective:GetScore(TargetedPlayer) % SourceObjective:GetScore(SourcePlayer))
			elseif Operator == "=" then
				Response = SendMessage(Player, TargetedObjective:GetDisplayName() .. ":" .. TargetedPlayer:GetName() .. " set to " .. SourceObjective:GetDisplayName() .. ":" .. SourcePlayer:GetName())
				TargetedObjective:SetScore(TargetedPlayer, SourceObjective:GetScore(SourcePlayer))
			elseif Operator == "<" then
				if SourceObjective:GetScore(SourcePlayer) < TargetedObjective:GetScore(TargetedPlayer) then
					TargetedObjective:SetScore(TargetedPlayer, SourceObjective:GetScore(SourcePlayer))
					Response = SendMessage(Player, TargetedObjective:GetDisplayName() .. ":" .. TargetedPlayer:GetName() .. " set to " .. SourceObjective:GetDisplayName() .. ":" .. SourcePlayer:GetName())
				end
			elseif Operator == ">" then
				if SourceObjective:GetScore(SourcePlayer) > TargetedObjective:GetScore(TargetedPlayer) then
					TargetedObjective:SetScore(TargetedPlayer, SourceObjective:GetScore(SourcePlayer))
					Response = SendMessage(Player, TargetedObjective:GetDisplayName() .. ":" .. TargetedPlayer:GetName() .. " set to " .. SourceObjective:GetDisplayName() .. ":" .. SourcePlayer:GetName())
				end
			elseif Operator == "><" then
				local temp = SourceObjective:GetScore(SourcePlayer)
				SourceObjective:SetScore(TargetedObjective:GetScore(TargetedPlayer))
				TargetedObjective:SetScore(TargetedPlayer, SourceObjective:GetScore(SourcePlayer))
				Response = SendMessage(Player, TargetedObjective:GetDisplayName() .. ":" .. TargetedPlayer:GetName() .. " and " .. SourceObjective:GetDisplayName() .. ":" .. SourcePlayer:GetName() .. " have been switched")
			else
				Response = SendMessage(Player, "operators: +=, -=, *=, /=, %=, =, <, >, ><")
			end
		end
	end

	table.insert(MultiLineResponse, 1, Response) -- Add the response of the command as first line
	return true, table.concat(MultiLineResponse, "\n")
end

-- Handle commands for console

function HandleConsoleScoreboardObjectives(Split)
	return HandleScoreboardObjectivesCommand(Split)
end

function HandleConsoleScoreboardPlayers(Split)
	return HandleScoreboardPlayersCommand(Split)
end
