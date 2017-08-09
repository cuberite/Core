
-- gamerule.lua

-- Implements gamerule command and related functions



-- SQLite DB handler
local grDB
local ini = cIniFile()
local boolean = "boolean"
local number = "number"


local function CheckType(rule, a_Type)
	local trueType = type(GameRules[rule])
	if trueType == "nil" then
		return true
	elseif trueType == a_Type then
		return true
	else
		return false
	end
end


-- Saves value to ini file
local function SaveValue(rule, value)
	if type(value) == boolean then
		ini:SetValueB("Game Rules", rule, value)
		ini:SetValue("Types", rule, boolean)
	elseif type(value) == number then
		ini:SetValueI("Game Rules", rule, value)
		ini:SetValue("Types", rule, number)
	else
		ini:SetValue("Game Rules", rule, value)
		ini:SetValue("Types", rule, "string")
	end
	ini:WriteFile("gamerules.ini")
end
	

local function HandleSplit(split)
	local ret = ""
	if #split == 1 then -- List currently set game rules
		for rule in pairs(GameRules) do
			ret = ret .. rule .. ", "
		end
		ret = ret:sub(1, -3)
		return ret
	elseif #split == 2 then -- Show game rule value
		if not(GameRules[split[2]]) then -- that game rule does not exist!
			return cCompositeChat("No game rule called '" .. split[2] .. "' is available", mtWarning)
		else
			return split[2] .. " = " .. tostring(GameRules[split[2]])
		end
	elseif #split >= 3 then -- Set game rule
		local rule = split[2]
		local lowerThird = split[3]:lower()
		local canSet = true
		if lowerThird == "true" then
			if CheckType(rule, boolean) then
				GameRules[rule] = true
				SaveValue(rule, true)
			else
				canSet = false
			end
		elseif lowerThird == "false" then
			if CheckType(rule, boolean) then
				GameRules[rule] = false
				SaveValue(rule, false)
			else
				canSet = false
			end
		elseif tonumber(lowerThird) ~= nil then
			if CheckType(rule, number) then
				GameRules[rule] = tonumber(lowerThird)
				SaveValue(rule, tonumber(lowerThird))
			else
				canSet = false
			end
		elseif CheckType(rule, "string") then
			split[3] = table.concat(split, " ", 3)
			GameRules[rule] = split[3]
			SaveValue(rule, split[3])
		else
			canSet = false
		end
		
		
		if canSet then
			return "Game rule " .. rule .. " has been updated to " .. split[3]
		elseif type(GameRules[rule]) == boolean then
			return cCompositeChat("'" .. split[3] .. "' is not true or false", mtWarning)
		elseif type(GameRules[rule]) == number then
			return cCompositeChat("'" .. split[3] .. "' is not a valid number", mtWarning)
		end
	end
end


-- Handle Commands
function HandleGameRuleCommand(split, player)
	player:SendMessage(HandleSplit(split))
	return true
end

function HandleConsoleGameRule(split)
	LOG(HandleSplit(split))
	return true
end


-- Initialization functions
local function InitalizeIni()
	-- Try to open gamerules.ini and load [Game Rules] and [Types] keys
	-- Or copy default ini file to server root
	ini:CaseSensitive()
	local function CopyIni()
		LOGINFO("Game Rule Settings not found or corrupt! Resetting to default game rules! (This may mess up your game)")
		cFile:Copy(cPluginManager:GetPluginsPath().."/"..cPluginManager:GetCurrentPlugin():GetFolderName().."/gamerules.ini", "gamerules.ini")
	end
	
	if not(ini:ReadFile("gamerules.ini")) then -- gamerules.ini doesn't exist
		CopyIni()
	else
		numKeys = ini:GetNumValues("Game Rules")
		if (numKeys ~= ini:GetNumValues("Types")) then
			-- gamerules.ini is corrupt!
			CopyIni()
		end
		-- Load game rules into GameRules table
		for rule = 0, numKeys -1 do
			local name = ini:GetValueName("Game Rules", rule)
			local valueType = ini:GetValue("Types", name)
			if valueType == boolean then
				GameRules[name] = ini:GetValueB("Game Rules", name)
			elseif valueType == number then
				GameRules[name] = ini:GetValueI("Game Rules", name)
			else -- assume string
				GameRules[name] = ini:GetValue("Game Rules", name)
			end			
		end
	end
end

local function InitalizeDB()
	-- Validate GameRule.sqlite or create a new DB
	local ErrMsg
	grDB, ErrMsg = NewSQLiteDB("GameRule.sqlite")
	if not(grDB) then
		LOGWARNING("Cannot open the Game Rule database, some things may not work right. SQLite: " .. (ErrMsg or "<no details>"))
		error(ErrMsg)
	end

	-- Table Structures
	local tables =
	{
		--[[
		tableName =
		{
			"column TYPE",
		},
		]]--
		keepInventory =
		{
			"Player",
			"Inventory",
			"isOnline BOOLEAN",
			"receivedInventory BOOLEAN",
		},
	}
	for table, columns in pairs(tables) do
		if not(grDB:CreateDBTable(table, columns)) then
			LOGWARNING("Cannot initialize " .. table )
			error("GameRule DB error: Creating Table " .. table)
		end
	end
end

--- Init function to be called upon plugin setup
function IntializeGameRule()
	-- Loads gamerules.ini values into GaeRule table, or creates the ini file
	InitalizeIni()
	InitalizeDB()
	-- Register hooks for various game rules
	
end
