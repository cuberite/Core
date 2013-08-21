
-- main.lua

-- implements the main plugin entrypoint





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
IniFileExists = true





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

	-- Bind ingame commands:
	-- Please keep this list alpha-sorted.
	PluginManager:BindCommand("/back",            "core.back",            HandleBackCommand,            " - Return to your last position")
	PluginManager:BindCommand("/ban",             "core.ban",             HandleBanCommand,             " ~ Ban a player")
	PluginManager:BindCommand("/clear",           "core.clear",           HandleClearCommand,           " - Clear the inventory of some player")
	PluginManager:BindCommand("/do",              "core.do",              HandleDoCommand,              " - Runs a command as a player.")
	PluginManager:BindCommand("/give",            "core.give",            HandleGiveCommand,            " ~ Give someone an item")
	PluginManager:BindCommand("/gm",              "core.changegm",        HandleChangeGMCommand,        " ~ Change your gamemode")
	PluginManager:BindCommand("/groups",          "core.groups",          HandleGroupsCommand,          " - Shows a list of all the groups")
	PluginManager:BindCommand("/help",            "core.help",            HandleHelpCommand,            " ~ Show available commands")
	PluginManager:BindCommand("/i",               "core.give",            HandleItemCommand,            "")
	PluginManager:BindCommand("/item",            "core.give",            HandleItemCommand,            " - Give yourself an item.")
	PluginManager:BindCommand("/kick",            "core.kick",            HandleKickCommand,            " ~ Kick a player")
	PluginManager:BindCommand("/kill",            "core.kill",            HandleKillCommand,            " - Kill some player")
	PluginManager:BindCommand("/locate",          "core.locate",          HandleLocateCommand,          " - Show your current server coordinates")
	PluginManager:BindCommand("/me",              "core.me",              HandleMeCommand,              " ~ Tell what you are doing")
	PluginManager:BindCommand("/motd",            "core.motd",            HandleMOTDCommand,            " - Show message of the day")
	PluginManager:BindCommand("/msg",             "core.tell",            HandleTellCommand,            "")
	PluginManager:BindCommand("/plugins",         "core.plugins",         HandlePluginsCommand,         " - Show list of plugins")
	PluginManager:BindCommand("/portal",          "core.portal",          HandlePortalCommand,          " ~ Move to a different world")
	PluginManager:BindCommand("/rank",            "core.rank",            HandleRankCommand,            " ~ Add someone to a group")
	PluginManager:BindCommand("/regen",           "core.regen",           HandleRegenCommand,           " ~ Regenerates a chunk, current or specified")
	PluginManager:BindCommand("/reload",          "core.reload",          HandleReloadCommand,          " - Reload all plugins")
	PluginManager:BindCommand("/save-all",        "core.save-all",        HandleSaveAllCommand,         " - Saves all your worlds")
	PluginManager:BindCommand("/spawn",           "core.spawn",           HandleSpawnCommand,           " - Return to the spawn")
	PluginManager:BindCommand("/stop",            "core.stop",            HandleStopCommand,            " - Stops the server")
	PluginManager:BindCommand("/sudo",            "core.sudo",            HandleSudoCommand,            " - Runs a command as a player, ignoring permissions")
	PluginManager:BindCommand("/tell",            "core.tell",            HandleTellCommand,            " ~ Send a private message")
	PluginManager:BindCommand("/time",            "core.time",            HandleTimeCommand,            " ~ Sets the time of day")
	PluginManager:BindCommand("/toggledownfall",  "core.toggledownfall",  HandleDownfallCommand,        " - Toggles the weather")
	PluginManager:BindCommand("/top",             "core.top",             HandleTopCommand,             " - Teleport yourself to the top most block")
	PluginManager:BindCommand("/tp",              "core.teleport",        HandleTPCommand,              " ~ Teleport yourself to a player")
	PluginManager:BindCommand("/tpa",             "core.teleport",        HandleTPACommand,             " ~ Ask to teleport yourself to a player")
	PluginManager:BindCommand("/tpaccept",        "core.teleport",        HandleTPAcceptCommand,        " ~ Accept a teleportation request")
	PluginManager:BindCommand("/unban",           "core.unban",           HandleUnbanCommand,           " ~ Unban a player")
	PluginManager:BindCommand("/viewdistance",    "core.viewdistance",    HandleViewDistanceCommand,    " [".. cClientHandle.MIN_VIEW_DISTANCE .."-".. cClientHandle.MAX_VIEW_DISTANCE .."] - Change your view distance")
	PluginManager:BindCommand("/weather",         "core.weather",         HandleWeatherCommand,         " ~ Change world weather")
	PluginManager:BindCommand("/worlds",          "core.worlds",          HandleWorldsCommand,          " - Shows a list of all the worlds")

	InitConsoleCommands()

	-- Load settings:
	IniFile = cIniFile( "settings.ini" )
	if IniFile:ReadFile() then
		HardCore = IniFile:GetValueSet( "GameMode", "Hardcore", "false" )
		IniFile:WriteFile()
	else
		IniFileExists = false
		LOGWARNING("No settings file was found, the Core plugin WILL NOT function correctly!")
	end

	-- Load SpawnProtection and WorldLimit settings for individual worlds:
	cRoot:Get():ForEachWorld(
		function (a_World)
			WorldIni = cIniFile(a_World:GetIniFileName())
			if WorldIni:ReadFile() then
				WorldsSpawnProtect[a_World:GetName()] = WorldIni:GetValueSetI("SpawnProtect", "ProtectRadius", 10);
				WorldsWorldLimit[a_World:GetName()]   = WorldIni:GetValueSetI("WorldLimit",   "LimitRadius",   0);
				WorldIni:WriteFile()
			end
		end
	);

	-- Load whitelist:
	WhiteListIni = cIniFile(Plugin:GetLocalDirectory() .. "/whitelist.ini")
	if WhiteListIni:ReadFile() then
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
		WhiteListIni:WriteFile()
	end

	--LOAD BANNED (BAD LUCK, BRO)
	BannedPlayersIni = cIniFile( Plugin:GetLocalDirectory() .. "/banned.ini" )
	if BannedPlayersIni:ReadFile() == true then
		if BannedPlayersIni:GetNumValues( "Banned" ) > 0 then
			LOGINFO( "Core: loaded "  .. BannedPlayersIni:GetNumValues("Banned") .. " banned players." )
		end
	else
		BannedPlayersIni:SetValue( "Banned", "", "" ) -- So it adds an empty header
		BannedPlayersIni:DeleteValue( "Banned", "" ) -- And remove the value
		BannedPlayersIni:KeyComment( "Banned", "PlayerName=1" )
		BannedPlayersIni:WriteFile()
	end

	-- Add webadmin tabs:
	Plugin:AddWebTab("Manage Server",   HandleRequest_ManageServer)
	Plugin:AddWebTab("Server Settings", HandleRequest_ServerSettings)
	Plugin:AddWebTab("Chat",            HandleRequest_Chat)
	Plugin:AddWebTab("Playerlist",      HandleRequest_PlayerList)
	Plugin:AddWebTab("Whitelist",       HandleRequest_WhiteList)
	Plugin:AddWebTab("Permissions",     HandleRequest_Permissions)
	Plugin:AddWebTab("Manage Plugins",  HandleRequest_ManagePlugins)

	LoadMotd()

	LOG("Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())

	return true
end





-- BEGIN SPAWNPROTECT LOGFILE CODE (COURTSEY OF BEARBIN)
function WriteLog( breakPlace, X, Y, Z, player, id, meta )

	local logText = {}

	table.insert( logText, player )
	table.insert( logText, " tried to " )

	if breakPlace == 0 then
		table.insert( logText, "break " )
	else
		table.insert( logText, "place " )
	end


	table.insert( logText, ItemToString(cItem(id, 1, meta)) )
	table.insert( logText, " at ")
	table.insert( logText, tostring(X) )
	table.insert( logText, ", ")
	table.insert( logText, tostring(Y) )
	table.insert( logText, ", ")
	table.insert( logText, tostring(Z) )
	table.insert( logText, "." )

	LOGINFO( table.concat( logText, '') )

	if LOGTOFILE then
		local logFile = io.open( Plugin:GetLocalDirectory() .. '/blocks.log', 'a' )
		logFile:write( table.concat( logText, '' ) .. "\n" )
		logFile:close()
	end

	return
end

function WarnPlayer( Player )
	SendMessageFailure( Player, "Go further from spawn to build" )
	return true
end

function OnDisable()
	LOG( "Disabled Core!" )
end
--END AWESOMENESS :'(
