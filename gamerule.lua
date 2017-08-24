
-- gamerule.lua

-- Implements gamerule command and related functions



-- SQLite DB handler
local grDB
local ValidationCallbacks = {}
WorldContext = cRoot:Get():GetDefaultWorld()

-- Helper Validation functions
function ValidateBoolean(a_Value)
	a_Value = a_Value:lower()
	if (a_Value == "0" or a_Value == "false") then
		return true, false
	elseif (a_Value == "1" or a_Value == "true") then
		return true, true
	else
		return false, "is not true or false"
	end
end

function ValidateNumber(a_Value)
	if tonumber(a_Value) then
		return true, tonumber(a_Value)
	else
		return false, "is not a valid number"
	end
end


-- Saves value to ini file
function SaveValue(a_Rule, a_Value, a_World)
	local WorldIni = cIniFile()
	if (type(a_World) == "string") then -- File path
		WorldIni:ReadFile(a_World)
	elseif (type(a_World) == "nil") then -- Idiot
		return false
	else -- cIniFile
		WorldIni = a_World
	end
	WorldIni:CaseSensitive()
	if type(a_Value) == "boolean" then
		WorldIni:SetValueB("Game Rules", a_Rule, a_Value)
	elseif type(a_Value) == "number" then
		WorldIni:SetValueI("Game Rules", a_Rule, a_Value)
	else
		WorldIni:SetValue("Game Rules", a_Rule, a_Value)
	end
	WorldIni:Flush()
end

-- Register for validation
-- a_Rule is a string
-- a_Callback is a function
-- Returns boolean on success or failure
-- a_Callback should return true, value if value is valid, or false, reason if value is invalid
 -- Ex: AddGameRuleValidation('keepInventory', ValidateBoolean)
function AddGameRuleValidation(a_Rule, a_Callback)
	if (
		(type(a_Rule) ~= "string" or a_Rule == "") or
		(type(a_Callback) ~= "function")
	) then
		LOGWARNING("Cannot register validation for rule '" .. tostring(a_Rule or "<nil>") .."'")
		return false
	end
	if ValidationCallbacks[a_Rule] then
		LOGWARNING("Overriding validation function for " .. a_Rule .. " (" .. tostring(ValidationCallbacks[a_Rule]) .. " > " .. tostring(a_Callback) .. ")")
	end
	ValidationCallbacks[a_Rule] = a_Callback
	return true
end

-- Called when loading and saving values
-- Returns true, value if rule/value is valid, false, reason otherwise
function Validate(a_Rule, a_Value)
	local f = ValidationCallbacks[a_Rule]
	if f then
		return f(a_Value)
	end
	-- If no callback registered, just return a_Value as is
	return true, a_Value
end

local function LoadGameRules()
	cRoot:Get():ForEachWorld(function (a_World)
		local name = a_World:GetName()
		local WorldIni = cIniFile()
		WorldIni:CaseSensitive()
		WorldIni:ReadFile(a_World:GetIniFileName())
		GameRules[name] = {}
		local key = WorldIni:FindKey("Game Rules")
		if key == -1 then
			-- Cannot find Game Rules section
			LOGINFO("Game rules for world " .. name .. " not found, resetting to default game rules!")
			WorldIni:AddKeyName("Game Rules")
			local defaultIni = cIniFile()
			defaultIni:CaseSensitive()
			defaultIni:ReadFile("Plugins/Core/gamerules.ini")
			local key = defaultIni:FindKey("Game Rules")
			for v = 0, defaultIni:GetNumValues(key) -1 do
				local rule = defaultIni:GetValueName(key, v)
				local isValid, value = Validate(rule, defaultIni:GetValue(key, v))
				if isValid then
					SaveValue(rule, value, WorldIni)
					GameRules[name][rule] = value
				end
			end
			WorldIni:Flush()
		else
			for k = 0, WorldIni:GetNumValues(key)-1 do
				local rule = WorldIni:GetValueName(key, k)
				local isValid, value = Validate(rule, WorldIni:GetValue(key, k))
				if isValid then
					GameRules[name][rule] = value
				end
			end
		end
	end)
end

-- Initialization functions
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
	AddGameRuleValidation("keepInventory", ValidateBoolean)
	LoadGameRules()
	-- Loads gamerules.ini values into GaeRule table, or creates the ini file
	InitalizeDB()
	-- Register hooks for various game rules

end
