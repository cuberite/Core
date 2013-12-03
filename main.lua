-- main.lua

-- Implements the main plugin entrypoint





-- Configuration
--  Use prefixes or not.
--  If set to true, messages are prefixed, e. g. "[FATAL]". If false, messages are colored.
g_UsePrefixes = true





-- Global variables
BannedPlayersIni = {}
WhiteListIni = {}
BackCoords = {}
Messages = {}
Destination = {}
WorldsSpawnProtect = {}
WorldsWorldLimit = {}
WorldsWorldDifficulty = {}





-- Called by MCServer on plugin start to initialize the plugin
function Initialize(Plugin)
	Plugin:SetName( "Core" )
	Plugin:SetVersion( 14 )

	-- Register for all hooks needed
	cPluginManager.AddHook( cPluginManager.HOOK_CHAT, OnChat )
	cPluginManager.AddHook( cPluginManager.HOOK_CRAFTING_NO_RECIPE, OnCraftingNoRecipe )
	cPluginManager.AddHook( cPluginManager.HOOK_DISCONNECT, OnDisconnect )
	cPluginManager.AddHook( cPluginManager.HOOK_KILLING, OnKilling )
	cPluginManager.AddHook( cPluginManager.HOOK_LOGIN, OnLogin )
	cPluginManager.AddHook( cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock )
	cPluginManager.AddHook( cPluginManager.HOOK_PLAYER_JOINED, OnPlayerJoined )
	cPluginManager.AddHook( cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving )
	cPluginManager.AddHook( cPluginManager.HOOK_PLAYER_PLACING_BLOCK, OnPlayerPlacingBlock )
	cPluginManager.AddHook( cPluginManager.HOOK_SPAWNING_ENTITY, OnSpawningEntity)
	cPluginManager.AddHook( cPluginManager.HOOK_TAKE_DAMAGE, OnTakeDamage)

	-- Bind ingame commands:
	-- Please keep this list alpha-sorted.
	local PluginManager = cPluginManager:Get()
	PluginManager:BindCommand("/back",            "core.back",            HandleBackCommand,            " - Return to your last position")
	PluginManager:BindCommand("/ban",             "core.ban",             HandleBanCommand,             " ~ Ban a player")
	PluginManager:BindCommand("/clear",           "core.clear",           HandleClearCommand,           " ~ Clear the inventory of a player")
	PluginManager:BindCommand("/do",              "core.do",              HandleDoCommand,              " ~ Runs a command as a player.")
	PluginManager:BindCommand("/difficulty",      "core.difficulty",      HandleDifficultyCommand,      " ~ Change world's difficulty.")
	PluginManager:BindCommand("/give",            "core.give",            HandleGiveCommand,            " ~ Give someone an item")
	PluginManager:BindCommand("/gm",              "core.changegm",        HandleChangeGMCommand,        " ~ Change your gamemode")
	PluginManager:BindCommand("/gamemode",        "core.changegm",        HandleChangeGMCommand,        " ~ Change your gamemode")
	PluginManager:BindCommand("/groups",          "core.groups",          HandleGroupsCommand,          " - Shows a list of all the groups")
	PluginManager:BindCommand("/help",            "core.help",            HandleHelpCommand,            " ~ Show available commands")
	PluginManager:BindCommand("/i",               "core.give",            HandleItemCommand,            "")
	PluginManager:BindCommand("/item",            "core.give",            HandleItemCommand,            " ~ Give yourself an item.")
	PluginManager:BindCommand("/kick",            "core.kick",            HandleKickCommand,            " ~ Kick a player")
	PluginManager:BindCommand("/kill",            "core.kill",            HandleKillCommand,            " ~ Kill a player")
	PluginManager:BindCommand("/locate",          "core.locate",          HandleLocateCommand,          " - Show your current server coordinates")
	PluginManager:BindCommand("/me",              "core.me",              HandleMeCommand,              " ~ Broadcast what you are doing")
	PluginManager:BindCommand("/motd",            "core.motd",            HandleMOTDCommand,            " - Show message of the day")
	PluginManager:BindCommand("/msg",             "core.tell",            HandleTellCommand,            "")
	PluginManager:BindCommand("/plugins",         "core.plugins",         HandlePluginsCommand,         " - Show list of plugins")
	PluginManager:BindCommand("/portal",          "core.portal",          HandlePortalCommand,          " ~ Move to a different world")
	PluginManager:BindCommand("/rank",            "core.rank",            HandleRankCommand,            " ~ Add someone to a group")
	PluginManager:BindCommand("/regen",           "core.regen",           HandleRegenCommand,           " ~ Regenerates a chunk, current or specified")
	PluginManager:BindCommand("/reload",          "core.reload",          HandleReloadCommand,          " - Reload all plugins")
	PluginManager:BindCommand("/save-all",        "core.save-all",        HandleSaveAllCommand,         " - Save all worlds")
	PluginManager:BindCommand("/setspawn",        "core.setspawn",        HandleSetSpawnCommand,        " ~ Change world spawn")
	PluginManager:BindCommand("/spawn",           "core.spawn",           HandleSpawnCommand,           " - Return to the spawn")
	PluginManager:BindCommand("/stop",            "core.stop",            HandleStopCommand,            " - Stops the server")
	PluginManager:BindCommand("/sudo",            "core.sudo",            HandleSudoCommand,            " ~ Runs a command as a player, ignoring permissions")
	PluginManager:BindCommand("/tell",            "core.tell",            HandleTellCommand,            " ~ Send a private message")
	PluginManager:BindCommand("/time",            "core.time",            HandleTimeCommand,            " ~ Sets the time of day")
	PluginManager:BindCommand("/toggledownfall",  "core.toggledownfall",  HandleDownfallCommand,        " - Toggles downfall")
	PluginManager:BindCommand("/top",             "core.top",             HandleTopCommand,             " - Teleport yourself to the topmost block")
	PluginManager:BindCommand("/tp",              "core.teleport",        HandleTPCommand,              " ~ Teleport yourself to a player")
	PluginManager:BindCommand("/tpa",             "core.teleport",        HandleTPACommand,             " ~ Ask to teleport yourself to a player")
	PluginManager:BindCommand("/tpaccept",        "core.teleport",        HandleTPAcceptCommand,        " ~ Accept a teleportation request")
	PluginManager:BindCommand("/unban",           "core.unban",           HandleUnbanCommand,           " ~ Unban a player")
	PluginManager:BindCommand("/viewdistance",    "core.viewdistance",    HandleViewDistanceCommand,    " [".. cClientHandle.MIN_VIEW_DISTANCE .."-".. cClientHandle.MAX_VIEW_DISTANCE .."] - Change your view distance")
	PluginManager:BindCommand("/weather",         "core.weather",         HandleWeatherCommand,         " ~ Change world weather")
	PluginManager:BindCommand("/worlds",          "core.worlds",          HandleWorldsCommand,          " - Shows a list of all the worlds")

	InitConsoleCommands()

	-- Load settings:
	IniFile = cIniFile()
	IniFile:ReadFile("settings.ini")
	HardCore = IniFile:GetValueSet("GameMode", "Hardcore", "false")
	IniFile:WriteFile("settings.ini")

	-- Load SpawnProtection and WorldLimit settings for individual worlds:
	cRoot:Get():ForEachWorld(
		function (a_World)
			local WorldIni = cIniFile()
			WorldIni:ReadFile(a_World:GetIniFileName())
			WorldsSpawnProtect[a_World:GetName()]   = WorldIni:GetValueSetI("SpawnProtect", "ProtectRadius", 10)
			WorldsWorldLimit[a_World:GetName()]     = WorldIni:GetValueSetI("WorldLimit",   "LimitRadius",   0)
			WorldsWorldDifficulty[a_World:GetName()]= WorldIni:GetValueSetI("Difficulty", "WorldDifficulty", 2)
			WorldIni:WriteFile(a_World:GetIniFileName())
		end
	)

	-- Load whitelist:
	WhiteListIni = cIniFile()
	if WhiteListIni:ReadFile("whitelist.ini") then
		if WhiteListIni:GetValueB("WhiteListSettings", "WhiteListOn", false) then
			if (WhiteListIni:GetNumValues( "WhiteList" ) > 0) then
				LOGINFO( "Core: loaded "  .. WhiteListIni:GetNumValues('WhiteList') .. " whitelisted players." )
			else
				LOGWARNING("WARNING: WhiteList is on, but there are no people in the whitelist!" )
			end
		end
	else
		WhiteListIni:SetValueB( "WhiteListSettings", "WhiteListOn", false )
		WhiteListIni:SetValue( "WhiteList", "", "" )	-- So it adds an empty header
		WhiteListIni:DeleteValue( "WhiteList", "" ) -- And remove the value
		WhiteListIni:KeyComment( "WhiteList", "PlayerName=1" )
		WhiteListIni:WriteFile("whitelist.ini")
	end

	-- Load banned:
	BannedPlayersIni = cIniFile()
	if (BannedPlayersIni:ReadFile("banned.ini")) then
		if (BannedPlayersIni:GetNumValues( "Banned" ) > 0) then
			LOGINFO( "Core: loaded "  .. BannedPlayersIni:GetNumValues("Banned") .. " banned players." )
		end
	else
		BannedPlayersIni:SetValue( "Banned", "", "" ) -- So it adds an empty header
		BannedPlayersIni:DeleteValue( "Banned", "" ) -- And remove the value
		BannedPlayersIni:KeyComment( "Banned", "PlayerName=1" )
		BannedPlayersIni:WriteFile("banned.ini")
	end

	-- Add webadmin tabs:
	Plugin:AddWebTab("Manage Server",   HandleRequest_ManageServer)
	Plugin:AddWebTab("Server Settings", HandleRequest_ServerSettings)
	Plugin:AddWebTab("Chat",            HandleRequest_Chat)
	Plugin:AddWebTab("Players",         HandleRequest_Players)
	Plugin:AddWebTab("Whitelist",       HandleRequest_WhiteList)
	Plugin:AddWebTab("Permissions",     HandleRequest_Permissions)
	Plugin:AddWebTab("Manage Plugins",  HandleRequest_ManagePlugins)

	LoadMotd()

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	return true
end

function WarnPlayer( Player )
	SendMessageFailure( Player, "Go further from spawn to build" )
	return true
end

function OnDisable()
	LOG( "Disabled Core!" )
end
