
-- gamerule.lua

-- Implements gamerule command and related functions



-- SQLite DB handler
local grDB

-- Functions that handle hooks



-- Initialization functions
local function InitalizeIni()
	-- Try to open gamerules.ini and load [Game Rules] and [Types] keys
	-- Or copy default ini file to server root
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
		keepInventory =
		{
			"Player",
			"Inventory",
			"isOnline",
			"receivedInventory",
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

	-- Register hooks for various game rules
end
