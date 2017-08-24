
-- gamerule_commands.lua

-- Handle Game Rule Commands

local function HandleSplit(a_Split, a_Player)
	local ret = ""
	local worldName = a_Player:GetWorld():GetName()
	if #a_Split == 1 then -- List currently set game rules
		for rule in pairs(GameRules[worldName]) do
			ret = ret .. rule .. ", "
		end
		ret = ret:sub(1, -3)
		return ret
	elseif #a_Split == 2 then -- Show game rule value
		if GameRules[worldName][a_Split[2]] == nil then -- that game rule does not exist!
			return cCompositeChat("No game rule called '" .. a_Split[2] .. "' is available", mtWarning)
		end
		return a_Split[2] .. " = " .. tostring(GameRules[worldName][a_Split[2]])
	elseif #a_Split >= 3 then -- Set game rule
		local rule = a_Split[2]
		local value = a_Split[3]
		local isValid, result = Validate(rule, value)
		if isValid then
			SaveValue(rule, result, a_Player:GetWorld():GetIniFileName())
			GameRules[worldName][rule] = result
			return "Game rule " .. rule .. " has been updated to " .. tostring(result)
		else
			return cCompositeChat("'" .. value .. "' " .. result, mtWarning)
		end
	end
end

function HandleGameRuleCommand(a_Split, a_Player)
	a_Player:SendMessage(HandleSplit(a_Split, a_Player))
	return true
end

function HandleConsoleGameRule(a_Split)
	LOG(HandleSplit(a_Split))
	return true
end

function HandleConsoleGameRuleWorld(a_Split)
	LOG("Not Yet")
	return true
end
