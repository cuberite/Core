
-- Info.lua

-- Implements the g_PluginInfo standard plugin description

g_PluginInfo = 
{
	Name = "Core",
	Version = "14",
	Date = "2014-06-11",
	SourceLocation = "https://github.com/mc-server/Core",
	Description = [[Implements some of the basic commands needed to run a simple server.]],
	
	Commands =
	{
		["/back"] = 
		{
			Permission = "core.back",
			Handler = HandleBackCommand,
			HelpString = "Return to your last position",
		},

		["/ban"] = 
		{
			Permission = "core.ban",
			Handler = HandleBanCommand,
			HelpString = "Ban a player",
		},

		["/clear"] = 
		{
			Permission = "core.clear",
			Handler = HandleClearCommand,
			HelpString = "Clear the inventory of a player",
		},

		["/do"] = 
		{
			Permission = "core.do",
			Handler = HandleDoCommand,
			HelpString = "Runs a command as a player.",
		},

		["/difficulty"] = 
		{
			Permission = "core.difficulty",
			Handler = HandleDifficultyCommand,
			HelpString = "Change world's difficulty.",
		},
		
		["/fly"] = 
		{
			Permission = "core.fly",
			Handler = HandleFlyCommand,
			HelpString = " ~ Toggle fly",
		},

		["/give"] = 
		{
			Permission = "core.give",
			Handler = HandleGiveCommand,
			HelpString = "Give someone an item",
		},

		["/gamemode"] = 
		{
			Alias = "/gm",
			Permission = "core.changegm",
			Handler = HandleChangeGMCommand,
			HelpString = "Change your gamemode",
		},

		["/help"] = 
		{
			Permission = "core.help",
			Handler = HandleHelpCommand,
			HelpString = "Show available commands",
		},

		["/i"] = 
		{
			Permission = "core.give",
			Handler = HandleItemCommand,
			HelpString = "",
		},

		["/item"] = 
		{
			Permission = "core.give",
			Handler = HandleItemCommand,
			HelpString = "Give yourself an item.",
		},

		["/kick"] = 
		{
			Permission = "core.kick",
			Handler = HandleKickCommand,
			HelpString = "Kick a player",
		},

		["/kill"] = 
		{
			Permission = "core.kill",
			Handler = HandleKillCommand,
			HelpString = "Kill a player",
		},

		["/list"] = 
		{
			Permission = "core.list",
			Handler = HandleListCommand,
			HelpString = "Lists all connected players",
		},

		["/listranks"] =
		{
			Permission = "core.listranks",
			Handler = HandleListRanksCommand,
			HelpString = "List all the available ranks",
			Alias = "/ranks",
		},

		["/locate"] = 
		{
			Permission = "core.locate",
			Handler = HandleLocateCommand,
			HelpString = "Show your current server coordinates",
		},

		["/me"] = 
		{
			Permission = "core.me",
			Handler = HandleMeCommand,
			HelpString = "Broadcast what you are doing",
		},

		["/motd"] = 
		{
			Permission = "core.motd",
			Handler = HandleMOTDCommand,
			HelpString = "Show message of the day",
		},

		["/plugins"] = 
		{
			Permission = "core.plugins",
			Handler = HandlePluginsCommand,
			HelpString = "Show list of plugins",
		},

		["/portal"] =
		{
			Permission = "core.portal",
			Handler = HandlePortalCommand,
			HelpString = "Move to a different world",
		},

		["/rank"] =
		{
			Permission = "core.rank",
			Handler = HandleRankCommand,
			HelpString = "View or set a player's rank",
		},

		["/regen"] =
		{
			Permission = "core.regen",
			Handler = HandleRegenCommand,
			HelpString = "Regenerates a chunk",
		},

		["/reload"] = 
		{
			Permission = "core.reload",
			Handler = HandleReloadCommand,
			HelpString = "Reload all plugins",
		},

		["/save-all"] = 
		{
			Permission = "core.save-all",
			Handler = HandleSaveAllCommand,
			HelpString = "Save all worlds",
		},

		["/setspawn"] = 
		{
			Permission = "core.setspawn",
			Handler = HandleSetSpawnCommand,
			HelpString = "Change world spawn",
		},

		["/spawn"] = 
		{
			Permission = "core.spawn",
			Handler = HandleSpawnCommand,
			HelpString = "Return to the spawn",
		},

		["/stop"] = 
		{
			Permission = "core.stop",
			Handler = HandleStopCommand,
			HelpString = "Stops the server",
		},

		["/sudo"] = 
		{
			Permission = "core.sudo",
			Handler = HandleSudoCommand,
			HelpString = "Runs a command as a player",
		},

		["/tell"] = 
		{
			Permission = "core.tell",
			Alias = "/msg",
			Handler = HandleTellCommand,
			HelpString = "Send a private message",
		},

		["/time"] = 
		{
			Permission = "core.time",
			Handler = HandleTimeCommand,
			HelpString = "Sets the time of day",
		},

		["/toggledownfall"] = 
		{
			Permission = "core.toggledownfall",
			Handler = HandleDownfallCommand,
			HelpString = "Toggles downfall",
		},

		["/top"] = 
		{
			Permission = "core.top",
			Handler = HandleTopCommand,
			HelpString = "Teleport yourself to the topmost block",
		},

		["/tp"] = 
		{
			Permission = "core.teleport",
			Handler = HandleTPCommand,
			HelpString = "Teleport yourself to a player",
		},

		["/tpa"] = 
		{
			Permission = "core.tpa",
			Handler = HandleTPACommand,
			HelpString = "Ask to teleport yourself to a player",
		},

		["/tpaccept"] = 
		{
			Permission = "core.tpaccept",
			Handler = HandleTPAcceptCommand,
			HelpString = "Accept a teleportation request",
		},
		
		["/tpahere"] = 
		{
			Permission = "core.tpahere",
			Handler = HandleTPACommand,
			HelpString = " ~ Ask to teleport player to yourself",
		},
		
		["/tpdeny"] = 
		{
			Permission = "core.tpdeny",
			Handler = HandleTPDenyCommand,
			HelpString = " ~ Deny a teleportation request",
		},
		
		["/tphere"] = 
		{
			Permission = "core.tphere",
			Handler = HandleTPHereCommand,
			HelpString = " ~ Teleport player to yourself",
		},

		["/tps"] = 
		{
			Permission = "core.tps",
			Handler = HandleTpsCommand,
			HelpString = "Returns the tps (ticks per second) from the server.",
		},

		["/unban"] = 
		{
			Permission = "core.unban",
			Handler = HandleUnbanCommand,
			HelpString = "Unban a player",
		},

		["/viewdistance"] = 
		{
			Permission = "core.viewdistance",
			Handler = HandleViewDistanceCommand,
			HelpString = "Change your view distance",
		},

		["/weather"] = 
		{
			Permission = "core.weather",
			Handler = HandleWeatherCommand,
			HelpString = "Change world weather",
		},

		["/worlds"] = 
		{
			Permission = "core.worlds",
			Handler = HandleWorldsCommand,
			HelpString = "Shows a list of all the worlds",
		},

		["/vanish"] = 
		{
			Permission = "core.vanish",
			Handler = HandleVanishCommand,
			HelpString = " - Vanish",
		},
		
		["/whitelist"] =
		{
			Permission = "core.whitelist",
			Handler = HandleWhitelistCommand,
			HelpString= "Adds a player to the whitelist",
		},
		
		["/whitelistoff"] =
		{
			Permission = "core.whitelistoff",
			Handler = HandleWhitelistOffCommand,
			HelpString= "Turns whitelist processing off",
		},

		["/whiteliston"] =
		{
			Permission = "core.whiteliston",
			Handler = HandleWhitelistOnCommand,
			HelpString= "Turns whitelist processing on",
		},
	},  -- Commands


	
	ConsoleCommands =
	{
		["ban"] =
		{
			Handler =  HandleConsoleBan,
			HelpString = "Bans a player by name",
		},
		
		["tps"] =
		{
			Handler =  HandleTpsCommand,
			HelpString =  " - Returns the tps (ticks per second) from the server.",
		},


		["banip"] =
		{
			Handler =  HandleConsoleBanIP,
			HelpString = "Bans a player by IP",
			Alias = "ipban",
		},

		["banlist"] =
		{
			Handler = HandleConsoleBanList,
			HelpString = "Lists all players banned by name",
		},

		["banlist ips"] =
		{
			-- This is a dummy entry only to generate the documentation
			-- the real processing is done by the "banlist" command
			Handler =  HandleConsoleBanList,
			HelpString = "Lists all players banned by IP",
		},

		["clear"] =
		{
			Handler =  HandleConsoleClear ,
			HelpString = "Clear a player's inventory",
		},

		["gamemode"] =
		{
			Handler =  HandleConsoleGamemode,
			HelpString = "Change a player's gamemode",
		},

		["getversion"] =
		{
			Handler =  HandleConsoleVersion,
			HelpString = "Gets server version reported to 1.4+ clients",
		},

		["gm"] =
		{
			Handler =  HandleConsoleGamemode,
			HelpString = "Change a player's gamemode",
		},

		["give"] =
		{
			Handler =  HandleConsoleGive,
			HelpString = "Gives items to the specified player.",
		},

		["kick"] =
		{
			Handler =  HandleConsoleKick,
			HelpString = "Kicks a player by name",
		},

		["kill"] =
		{
			Handler =  HandleConsoleKill,
			HelpString = "Kill a player",
		},

		["list"] =
		{
			Handler =  HandleConsoleList,
			HelpString = "Lists all players in a machine-readable format",
		},

		["listgroups"] =
		{
			Handler =  HandleConsoleListGroups,
			HelpString = "Shows a list of all the groups",
		},

		["listranks"] =
		{
			Handler =  HandleConsoleListRanks,
			HelpString = "Shows a list of all the ranks",
		},

		["numchunks"] =
		{
			Handler =  HandleConsoleNumChunks,
			HelpString = "Shows number of chunks currently loaded",
		},

		["players"] =
		{
			Handler =  HandleConsolePlayers,
			HelpString = "Lists all connected players",
		},

		["plugins"] =
		{
			Handler = HandleConsolePlugins,
			HelpString = "Show list of plugins",
		},

		["rank"] =
		{
			Handler =  HandleConsoleRank,
			HelpString = "Set or view a player's rank",
		},

		["save-all"] =
		{
			Handler =  HandleConsoleSaveAll,
			HelpString = "Saves all chunks",
		},

		["say"] =
		{
			Handler =  HandleConsoleSay,
			HelpString = "Sends a chat message to all players",
		},

		["setversion"] =
		{
			Handler =  HandleConsoleVersion,
			HelpString = "Sets server version reported to 1.4+ clients",
		},

		["tp"] =
		{
			Handler =  HandleConsoleTeleport,
			HelpString = "Teleports a player",
		},

		["unban"] =
		{
			Handler =  HandleConsoleUnban,
			HelpString = "Unbans a player by name",
		},

		["unbanip"] =
		{
			Handler =  HandleConsoleUnbanIP,
			HelpString = "Unbans a player by IP",
		},

		["unloadchunks"] =
		{
			Handler = HandleConsoleUnload,
			HelpString = "Unloads all unused chunks",
		},
		
		["unrank"] =
		{
			Handler = HandleConsoleUnrank,
			HelpString = "Resets the player's rank to default",
		},
		
		["unwhitelist"] =
		{
			Handler = HandleConsoleUnwhitelist,
			HelpString = "Removes a player from the whitelist",
		},

		["weather"] =
		{
			Handler =  HandleConsoleWeather,
			HelpString = "Change weather in the specified world",
		},

		["whitelist"] =
		{
			Handler = HandleConsoleWhitelist,
			HelpString= "Shows the whitelist / adds a player to the whitelist",
		},
		
		["whitelistoff"] =
		{
			Handler = HandleConsoleWhitelistOff,
			HelpString= "Turns whitelist processing off",
		},

		["whiteliston"] =
		{
			Handler = HandleConsoleWhitelistOn,
			HelpString= "Turns whitelist processing on",
		},
	},
}


