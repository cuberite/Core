
-- gamerule_commands.lua

-- Handle Game Rule Commands
local function ListRules(a_WorldName)
	local ret = ""
	for rule in pairs(GameRules[a_WorldName]) do
		ret  = ret .. rule .. ", "
	end
	return ret:sub(1, -3)
end

local function QueryValue(a_Rule, a_WorldName)
	local value = GameRules[a_WorldName][a_Rule]
	if value then
		return a_Rule .. " = " .. tostring(value)
	end
	return cCompositeChat("No game rule called '" .. a_Rule .. "' is available", mtWarning)
end

local function SetValue(a_Rule, a_Value, a_World)
	local isValid, result = Validate(a_Rule, a_Value)
	if isValid then
		local worldName = a_World:GetName()
		GameRules[worldName][a_Rule] = result
		SaveValue(a_Rule, result, a_World:GetIniFileName())
		return "Game rule " .. a_Rule .. " in world '" .. worldName .. "' has been updated to " .. tostring(result)
	end
	return cCompositeChat("'" .. a_Value .. "' " .. result, mtWarning)
end

function HandleGameRuleCommand(a_Split, a_Player)
	-- TODO: Deal with 'world' in split
	local worldName = a_Player:GetWorld():GetName()
	if #a_Split == 1 then -- List currently set game rules
		a_Player:SendMessage(ListRules(worldName))
	elseif #a_Split == 2 then -- Show game rule value
		a_Player:SendMessage(QueryValue(a_Split[2], worldName))
	elseif #a_Split >= 3 then -- Set game rule
		local rule = a_Split[2]
		local world = cRoot:Get():GetWorld(a_Split[#a_Split])
		if world then
			local value = table.concat(a_Split, " ", 3, #a_Split -1)
			a_Player:SendMessage(SetValue(rule, value, world))
		else
			local value = table.concat(a_Split, " ", 3, #a_Split)
			a_Player:SendMessage(SetValue(rule, value, a_Player:GetWorld()))
		end
	end
	return true
end

function HandleConsoleGameRule(a_Split)
	local worldName = WorldContext:GetName()
	if #a_Split == 1 then -- list game rules in current world context
		LOG(ListRules(worldName))
		return true
	end
	local root = cRoot:Get()
	if #a_Split == 2 then -- List games rules in world, or view rule value in current world context
		local world = root:GetWorld(a_Split[2])
		if world then
			LOG(ListRules(world:GetName()))
		else
			LOG(QueryValue(a_Split[2], worldName))
		end
	elseif #a_Split == 3 then -- Set game rule in current world context or view rule value in world
		local world = root:GetWorld(a_Split[3])
		if world then
			LOG(QueryValue(a_Split[2], world:GetName()))
		else
			LOG(SetValue(a_Split[2], a_Split[3], WorldContext))
		end
	elseif #a_Split >= 4 then -- Set game rule in world
		local world = root:GetWorld(a_Split[#a_Split])
		if world then
			local value = table.concat(a_Split, " ", 3, #a_Split-1)
			LOG(SetValue(a_Split[2], value, world))
		else
			local value = table.concat(a_Split, " ", 3, #a_Split)
			LOG(SetValue(a_Split[2], value, WorldContext))
		end
	end
	return true
end

function HandleConsoleGameRuleWorld(a_Split)
	if (#a_Split == 2) then
		local newWorld = cRoot:Get():GetWorld(a_Split[2])
		if not newWorld then
			LOGWARNING(a_Split[2] .. " not a valid world!")
		else
			WorldContext = newWorld
		end
	end
	LOG("Current World Context: " .. WorldContext:GetName())
	return true
end
