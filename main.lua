-- main.lua

-- Implements the main plugin entrypoint





-- Configuration
--  Use prefixes or not.
--  If set to true, messages are prefixed, e. g. "[FATAL]". If false, messages are colored.
g_UsePrefixes = true





-- Global variables
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

	-- Bind ingame commands:
	-- Please keep this list alpha-sorted.
	local PM = cPluginManager:Get()
	PM:BindCommand("/back",            "core.back",            HandleBackCommand,            " - Return to your last position")
	PM:BindCommand("/ban",             "core.ban",             HandleBanCommand,             " ~ Ban a player")
	PM:BindCommand("/clear",           "core.clear",           HandleClearCommand,           " ~ Clear the inventory of a player")
	PM:BindCommand("/do",              "core.do",              HandleDoCommand,              " ~ Runs a command as a player.")
	PM:BindCommand("/difficulty",      "core.difficulty",      HandleDifficultyCommand,      " ~ Change world's difficulty.")
	PM:BindCommand("/enchant",         "core.enchant",         HandleEnchantCommand,         " ~ Enchant the equipped item")
	PM:BindCommand("/give",            "core.give",            HandleGiveCommand,            " ~ Give someone an item")
	PM:BindCommand("/gm",              "core.changegm",        HandleChangeGMCommand,        " ~ Change your gamemode")
	PM:BindCommand("/gamemode",        "core.changegm",        HandleChangeGMCommand,        " ~ Change your gamemode")
	PM:BindCommand("/groups",          "core.groups",          HandleGroupsCommand,          " - Shows a list of all the groups")
	PM:BindCommand("/help",            "core.help",            HandleHelpCommand,            " ~ Show available commands")
	PM:BindCommand("/i",               "core.give",            HandleItemCommand,            "")
	PM:BindCommand("/item",            "core.give",            HandleItemCommand,            " ~ Give yourself an item.")
	PM:BindCommand("/kick",            "core.kick",            HandleKickCommand,            " ~ Kick a player")
	PM:BindCommand("/kill",            "core.kill",            HandleKillCommand,            " ~ Kill a player")
	PM:BindCommand("/locate",          "core.locate",          HandleLocateCommand,          " - Show your current server coordinates")
	PM:BindCommand("/me",              "core.me",              HandleMeCommand,              " ~ Broadcast what you are doing")
	PM:BindCommand("/motd",            "core.motd",            HandleMOTDCommand,            " - Show message of the day")
	PM:BindCommand("/msg",             "core.tell",            HandleTellCommand,            "")
	PM:BindCommand("/plugins",         "core.plugins",         HandlePluginsCommand,         " - Show list of plugins")
	PM:BindCommand("/portal",          "core.portal",          HandlePortalCommand,          " ~ Move to a different world")
	PM:BindCommand("/rank",            "core.rank",            HandleRankCommand,            " ~ Add someone to a group")
	PM:BindCommand("/regen",           "core.regen",           HandleRegenCommand,           " ~ Regenerates a chunk, current or specified")
	PM:BindCommand("/reload",          "core.reload",          HandleReloadCommand,          " - Reload all plugins")
	PM:BindCommand("/save-all",        "core.save-all",        HandleSaveAllCommand,         " - Save all worlds")
	PM:BindCommand("/setspawn",        "core.setspawn",        HandleSetSpawnCommand,        " ~ Change world spawn")
	PM:BindCommand("/spawn",           "core.spawn",           HandleSpawnCommand,           " - Return to the spawn")
	PM:BindCommand("/stop",            "core.stop",            HandleStopCommand,            " - Stops the server")
	PM:BindCommand("/sudo",            "core.sudo",            HandleSudoCommand,            " ~ Runs a command as a player, ignoring permissions")
	PM:BindCommand("/tell",            "core.tell",            HandleTellCommand,            " ~ Send a private message")
	PM:BindCommand("/time",            "core.time",            HandleTimeCommand,            " ~ Sets the time of day")
	PM:BindCommand("/toggledownfall",  "core.toggledownfall",  HandleDownfallCommand,        " - Toggles downfall")
	PM:BindCommand("/top",             "core.top",             HandleTopCommand,             " - Teleport yourself to the topmost block")
	PM:BindCommand("/tp",              "core.teleport",        HandleTPCommand,              " ~ Teleport yourself to a player")
	PM:BindCommand("/tpa",             "core.tpa",             HandleTPACommand,             " ~ Ask to teleport yourself to a player")
	PM:BindCommand("/tpaccept",        "core.tpaccept",        HandleTPAcceptCommand,        " ~ Accept a teleportation request")
	PM:BindCommand("/unban",           "core.unban",           HandleUnbanCommand,           " ~ Unban a player")
	PM:BindCommand("/viewdistance",    "core.viewdistance",    HandleViewDistanceCommand,    " [".. cClientHandle.MIN_VIEW_DISTANCE .."-".. cClientHandle.MAX_VIEW_DISTANCE .."] - Change your view distance")
	PM:BindCommand("/weather",         "core.weather",         HandleWeatherCommand,         " ~ Change world weather")
	PM:BindCommand("/worlds",          "core.worlds",          HandleWorldsCommand,          " - Shows a list of all the worlds")

	InitConsoleCommands()

	-- Load settings:
	IniFile = cIniFile()
	IniFile:ReadFile("settings.ini")
	HardCore = IniFile:GetValueSet("GameMode", "Hardcore", "false")
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

	LoadMotd()

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	return true
end

function OnDisable()
	LOG( "Disabled Core!" )
end
