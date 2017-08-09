
-- gamerule.lua

-- Implements gamerule command and related functions



-- SQLite DB handler
local grDB
local ini = cIniFile()
-- Handle Commands



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
			if valueType == "boolean" then
				GameRules[name] = ini:GetValueB("Game Rules", name)
			elseif valueType == "number" then
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
