-- main.lua
-- Implements the main plugin entrypoint

function Initialize(Plugin)
	Plugin:SetName(g_PluginInfo.Name)

	-- Register for all hooks needed
	cPluginManager:AddHook(cPluginManager.HOOK_BLOCK_SPREAD,          OnBlockSpread)
	cPluginManager:AddHook(cPluginManager.HOOK_CHAT,                  OnChat)
	cPluginManager:AddHook(cPluginManager.HOOK_CRAFTING_NO_RECIPE,    OnCraftingNoRecipe)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_DESTROYED,      OnDisconnect)
	cPluginManager:AddHook(cPluginManager.HOOK_EXPLODING,             OnExploding)
	cPluginManager:AddHook(cPluginManager.HOOK_KILLING,               OnKilling)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BREAKING_BLOCK, OnPlayerBreakingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED,         OnPlayerJoined)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED,         OnPlayerJoined_WebChat)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_MOVING,         OnPlayerMoving)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_PLACING_BLOCK,  OnPlayerPlacingBlock)
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_RIGHT_CLICK,    OnPlayerRightClick)
	cPluginManager:AddHook(cPluginManager.HOOK_SPAWNING_MONSTER,      OnSpawningMonster)
	cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE,           OnTakeDamage)
	cPluginManager:AddHook(cPluginManager.HOOK_TICK,                  OnTick)
	cPluginManager:AddHook(cPluginManager.HOOK_WORLD_TICK,            OnWorldTick)

	-- Bind ingame commands:
	dofile(cPluginManager:GetPluginsPath() .. "/InfoReg.lua")
	RegisterPluginInfoCommands()
	RegisterPluginInfoConsoleCommands()

	-- Load SpawnProtection and WorldLimit settings for individual worlds:
	cRoot:Get():ForEachWorld(
		function (World)
			LoadWorldSettings(World)
		end
	)

	-- Initialize the banlist, load its DB, do whatever processing it needs on startup:
	InitializeBanlist()

	-- Initialize the whitelist, load its DB, do whatever processing it needs on startup:
	InitializeWhitelist()

	-- Initialize the Item Blacklist (the list of items that cannot be obtained using the give command):
	IntializeItemBlacklist(Plugin)

	-- Add webadmin tabs:
	cWebAdmin:AddWebTab("Manage Server",   "manage-server",   HandleRequest_ManageServer)
	cWebAdmin:AddWebTab("Server Settings", "server-settings", HandleRequest_ServerSettings)
	cWebAdmin:AddWebTab("Chat",            "chat",            HandleRequest_Chat)
	cWebAdmin:AddWebTab("Players",         "players",         HandleRequest_Players)
	cWebAdmin:AddWebTab("Whitelist",       "whitelist",       HandleRequest_WhiteList)
	cWebAdmin:AddWebTab("Permissions",     "permissions",     HandleRequest_Permissions)
	cWebAdmin:AddWebTab("Plugins",         "plugins",         HandleRequest_ManagePlugins)
	cWebAdmin:AddWebTab("Time & Weather",  "time-weather",    HandleRequest_Weather)
	cWebAdmin:AddWebTab("Ranks",           "ranks",           HandleRequest_Ranks)
	cWebAdmin:AddWebTab("Player Ranks",    "player-ranks",    HandleRequest_PlayerRanks)

	-- Load the message of the day from file, and cache it:
	LoadMOTD()

	WEBLOGINFO("Core is initialised")
	LOG("Initialised!")

	return true
end

function OnDisable()
	LOG("Disabling...")
end
