-- main.lua

-- Implements the main plugin entrypoint





-- Configuration
--  Use prefixes or not.
--  If set to true, messages are prefixed, e. g. "[FATAL]". If false, messages are colored.
g_UsePrefixes = true





-- Global variables
BackCoords = {}
Messages = {}
WorldsSpawnProtect = {}
WorldsWorldLimit = {}
WorldsWorldDifficulty = {}
TpRequestTimeLimit = 0





-- Called by MCServer on plugin start to initialize the plugin
function Initialize(Plugin)
	Plugin:SetName( "Core" )
	Plugin:SetVersion( 14 )

	-- Register for all hooks needed
	cPluginManager:AddHook(cPluginManager.HOOK_CHAT,                  OnChat)
	cPluginManager:AddHook(cPluginManager.HOOK_CRAFTING_NO_RECIPE,    OnCraftingNoRecipe)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_DESTROYED,      OnDisconnect);
	cPluginManager:AddHook(cPluginManager.HOOK_KILLING,               OnKilling)
	cPluginManager:AddHook(cPluginManager.HOOK_LOGIN,                 OnLogin)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED,         OnPlayerJoined)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_MOVING,         OnPlayerMoving)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK,  OnPlayerPlacingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_SPAWNING_ENTITY,       OnSpawningEntity)
	cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE,           OnTakeDamage)
	cPluginManager:AddHook(cPluginManager.HOOK_WORLD_TICK,            OnWorldTick)
	cPluginManager:AddHook(cPluginManager.HOOK_TICK,                  OnTick)

	-- Bind ingame commands:
	
	-- Load the InfoReg shared library:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	
	-- Bind all the commands:
	RegisterPluginInfoCommands();
	
	-- Bind all the console commands:
	RegisterPluginInfoConsoleCommands();

	-- Load settings:
	IniFile = cIniFile()
	IniFile:ReadFile("settings.ini")
	HardCore = IniFile:GetValueSet("GameMode", "Hardcore", "false")
	TpRequestTimeLimit = IniFile:GetValueSet("Teleport", "RequestTimeLimit", "0")
	IniFile:WriteFile("settings.ini")
	-- Load SpawnProtection and WorldLimit settings for individual worlds:
	cRoot:Get():ForEachWorld(
		function (a_World)
			LoadWorldSettings(a_World)
		end
	)

	-- Load whitelist:
	WhiteListIni = cIniFile() -- Global
	if WhiteListIni:ReadFile("whitelist.ini") then
		if WhiteListIni:GetValueB("WhiteListSettings", "WhiteListOn", false) then
			if (WhiteListIni:GetNumValues( "WhiteList" ) > 0) then
				LOGINFO( "Loaded "  .. WhiteListIni:GetNumValues('WhiteList') .. " whitelisted players." )
			else
				LOGWARNING("Whitelist is on, but there are no players in the whitelist!" )
			end
		end
	else
		WhiteListIni:AddHeaderComment( "This is the whitelist file for MCServer, used for whitelisting players" )
		WhiteListIni:AddHeaderComment( "The format is: PlayerName=1 for whitelisted or PlayerName=0 for not (or just delete the value)" )
		WhiteListIni:SetValueB( "WhiteListSettings", "WhiteListOn", false )
		WhiteListIni:SetValue( "WhiteList", "", "" )	-- So it adds an empty header
		WhiteListIni:DeleteValue( "WhiteList", "" ) -- And remove the value
		WhiteListIni:WriteFile("whitelist.ini")
	end

	-- Load banned:
	BannedPlayersIni = cIniFile() -- Global
	if (BannedPlayersIni:ReadFile("banned.ini")) then
		if (BannedPlayersIni:GetNumValues( "Banned" ) > 0) then
			LOGINFO( "Loaded "  .. BannedPlayersIni:GetNumValues("Banned") .. " banned players." )
		end
	else
		WhiteListIni:AddHeaderComment( "This is the banned players file for MCServer, used for storing banned playernames" )
		WhiteListIni:AddHeaderComment( "The format is: PlayerName=1 for banned or PlayerName=0 for not (or just delete the value)" )
		BannedPlayersIni:SetValue( "Banned", "", "" ) -- So it adds an empty header
		BannedPlayersIni:DeleteValue( "Banned", "" ) -- And remove the value
		BannedPlayersIni:WriteFile("banned.ini")
	end

	-- Add webadmin tabs:
	Plugin:AddWebTab("Manage Server",   HandleRequest_ManageServer)
	Plugin:AddWebTab("Server Settings", HandleRequest_ServerSettings)
	Plugin:AddWebTab("Chat",            HandleRequest_Chat)
	Plugin:AddWebTab("Players",         HandleRequest_Players)
	Plugin:AddWebTab("Whitelist",       HandleRequest_WhiteList)
	Plugin:AddWebTab("Permissions",     HandleRequest_Permissions)
	Plugin:AddWebTab("Plugins",         HandleRequest_ManagePlugins)
	Plugin:AddWebTab("Time & Weather",  HandleRequest_Weather)
	Plugin:AddWebTab("Ranks",           HandleRequest_Ranks)

	LoadMotd()

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	return true
end

function OnDisable()
	LOG( "Disabled Core!" )
end
