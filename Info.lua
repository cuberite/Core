
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
			HelpString = "Runs a command as a player",
		},

		["/difficulty"] = 
		{
			Permission = "core.difficulty",
			Handler = HandleDifficultyCommand,
			HelpString = "Change world's difficulty",
		},

		["/enchant"] = 
		{
			Permission = "core.enchant",
			Handler = HandleEnchantCommand,
			HelpString = "Adds an enchantment to the specified player's held item",
			ParameterCombinations =
			{
				{
					Params = "PlayerName EnchantmentID",
					Help = "Adds the specified enchantment to the specified player's currently held item",
				},
				{
					Params = "PlayerName EnchantmentID level",
					Help = "Adds the specified enchantment of the given level to the specified player's currently held item",
				},
			},
		},

		["/fly"] = 
		{
			Permission = "core.fly",
			Handler = HandleFlyCommand,
			HelpString = "Toggle flight",
		},

		["/give"] = 
		{
			Permission = "core.give",
			Handler = HandleGiveCommand,
			HelpString = "Give someone an item",
			ParameterCombinations = 
			{
				{
					Params = "PlayerName ItemName",
					Help = "Gives the player one of the specified item",
				},
				{
					Params = "PlayerName ItemName Amount",
					Help = "Gives the player the given amount of the specified item",
				},
				{
					Params = "PlayerName ItemName Amount Data",
					Help = "Gives the player the given amount of the specified item with the given data value",
				},
				{
					Params = "PlayerName ItemName Amount Data DataTag",
					Help = "Gives the player the given amount of the specified item with the given data value and DataTag",
				},
			},
		},

		["/gamemode"] = 
		{
			Alias = "/gm",
			Permission = "core.changegm",
			Handler = HandleChangeGMCommand,
			HelpString = "Change your gamemode",
			ParameterCombinations = 
			{
				{
					Params = "gamemode",
					Help = "Change your own gamemode",
				},
				{
					Params = "gamemode PlayerName",
					Help = "Change the gamemode of the specified player, rather then your own",
				},
			},
		},

		["/help"] = 
		{
			Permission = "core.help",
			Handler = HandleHelpCommand,
			HelpString = "Show available commands",
		},

		["/ienchant"] = 
		{
			Permission = "core.enchant.self",
			Handler = HandleIEnchantCommand,
			HelpString = "Add an enchantment to an item",
			ParameterCombinations =
			{
				{
					Params = "EnchantmentID",
					Help = "Adds the specified enchantment to the currently held item",
				},
				{
					Params = "EnchantmentID level",
					Help = "Adds the specified enchantment of the given level to the currently held item",
				},
			},
		},

		["/item"] = 
		{
			Alias = "/i",
			Permission = "core.item",
			Handler = HandleItemCommand,
			HelpString = "Give yourself an item",
			ParameterCombinations = 
			{
				{
					Params = "ItemName",
					Help = "Gives the caller one of the specified item",
				},
				{
					Params = "ItemName Amount",
					Help = "Gives the caller the given amount of the specified item",
				},
				{
					Params = "ItemName Amount Data",
					Help = "Gives the caller the given amount of the specified item with the given data value",
				},
				{
					Params = "ItemName Amount Data DataTag",
					Help = "Gives the caller the given amount of the specified item with the given data value and DataTag",
				},
			},
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
			ParameterCombinations =
			{
				{
					Params = "[<status>] [<status>] ...",
					Help = "Filters the plugin list to show only the plugins with the specified status (default: loaded)",
				},
			},
		},

		["/portal"] =
		{
			Permission = "core.portal",
			Handler = HandlePortalCommand,
			HelpString = "Move to a different world",
		},
		
        ["/r"] =
        {
            Permission =  "core.tell",
            HelpString =  "Reply to last private message you recieved",
            Handler =  HandleRCommand,
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
			HelpString = "Regenerate a chunk",
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
			HelpString = "Stop the server",
		},

		["/sudo"] = 
		{
			Permission = "core.sudo",
			Handler = HandleSudoCommand,
			HelpString = "Run a command as a player",
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
			HelpString = "Set or display the time",
			Subcommands = 
			{
				day = 
				{
					HelpString = "Set the time to day",
					Permission = "core.time.set",
					Handler = HandleSpecialTimeCommand,
					ParameterCombinations = 
					{
						{
							Params = "WorldName",
							Help = "Set the time to day in the given world, rather than the current world",
						},
					},
				},
				night = 
				{
					HelpString = "Set the time to night",
					Permission = "core.time.set",
					Handler = HandleSpecialTimeCommand,
					ParameterCombinations = 
					{
						{
							Params = "WorldName",
							Help = "Set the time to night in the given world, rather than the current world",
						},
					},
				},
				set = 
				{
					HelpString = "Set the time to the value given",
					Permission = "core.time.set",
					Handler = HandleSetTimeCommand,
					ParameterCombinations = 
					{
						{
							Params = "time",
							Help = "Set the time to the value given",
						},
						{
							Params = "day",
							Help = "Set the time to day",
						},
						{
							Params = "night",
							Help = "Set the time to night",
						},
						{
							Params = "time WorldName",
							Help = "Set the time to the given value in the given world, rather than the current world",
						},
						{
							Params = "day WorldName",
							Help = "Set the time to day in the given world, rather than the current world",
						},
						{
							Params = "night WorldName",
							Help = "Set the time to night in the given world, rather than the current world",
						},
					},
				},
				add = 
				{
					HelpString = "Add the amount given to the current time",
					Permission = "core.time.set",
					Handler = HandleAddTimeCommand,
					ParameterCombinations = 
					{
						{
							Params = "amount",
							Help = "Add the amount given to the current time",
						},
						{
							Params = "amount WorldName",
							Help = "Add the amount to the time in the given world, rather than the current world",
						},
					},
				},
				query = 
				{
					Subcommands = 
					{
						daytime = 
						{
							HelpString = "Display the current time",
							Permission = "core.time.query.daytime",
							Handler = HandleQueryDaytimeCommand,
							ParameterCombinations = 
							{
								{
									Params = "WorldName",
									Help = "Display the time in the given world, rather than the current world",
								},
							},
						},
						gametime =
						{
							HelpString = "Display the amount of time elapsed since start",
							Permission = "core.time.query.gametime",
							Handler = HandleQueryGametimeCommand,
							ParameterCombinations = 
							{
								{
									Params = "WorldName",
									Help = "Display the time elapsed since start in the given world, rather than the current world",
								},
							},
						},
					},
				},
			},
		},

		["/toggledownfall"] = 
		{
			Permission = "core.toggledownfall",
			Handler = HandleDownfallCommand,
			HelpString = "Toggle the weather between clear skies and rain",
			ParameterCombinations =
			{
				{
					Params = "WorldName",
					Help = "Change the weather in the given world, rather than the current world",
				},
			},
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
			HelpString = "Accept a teleportation request from another player",
		},
		
		["/tpahere"] = 
		{
			Permission = "core.tpahere",
			Handler = HandleTPACommand,
			HelpString = "Ask another player to teleport to your location",
		},
		
		["/tpdeny"] = 
		{
			Permission = "core.tpdeny",
			Handler = HandleTPDenyCommand,
			HelpString = "Deny a teleportation request from another player",
		},
		
		["/tphere"] = 
		{
			Permission = "core.tphere",
			Handler = HandleTPHereCommand,
			HelpString = "Teleport player to your location",
		},

		["/tps"] = 
		{
			Permission = "core.tps",
			Handler = HandleTpsCommand,
			HelpString = "Return the ticks per second from the server",
		},

		["/unban"] = 
		{
			Permission = "core.unban",
			Handler = HandleUnbanCommand,
			HelpString = "Unban a player",
		},

		["/unsafegive"] = 
		{
			Permission = "core.give.unsafe",
			Handler = HandleUnsafeGiveCommand,
			HelpString = "Give someone an item, even if it is blacklisted",
			ParameterCombinations = 
			{
				{
					Params = "PlayerName ItemName",
					Help = "Give the player one of the specified item, even if it is blacklisted",
				},
				{
					Params = "PlayerName ItemName Amount",
					Help = "Give the player the given amount of the specified item, even if it is blacklisted",
				},
				{
					Params = "PlayerName ItemName Amount Data",
					Help = "Give the player the given amount of the specified item with the given data value, even if it is blacklisted",
				},
				{
					Params = "PlayerName ItemName Amount Data DataTag",
					Help = "Give the player the given amount of the specified item with the given data value and DataTag, even if it is blacklisted",
				},
			},
		},

		["/unsafeitem"] = 
		{
			Permission = "core.item.unsafe",
			Handler = HandleUnsafeItemCommand,
			HelpString = "Give yourself an item, even if it is blacklisted.",
			ParameterCombinations = 
			{
				{
					Params = "ItemName",
					Help = "Give the caller one of the specified item, even if it is blacklisted",
				},
				{
					Params = "ItemName Amount",
					Help = "Give the caller the given amount of the specified item, even if it is blacklisted",
				},
				{
					Params = "ItemName Amount Data",
					Help = "Give the caller the given amount of the specified item with the given data value, even if it is blacklisted",
				},
				{
					Params = "ItemName Amount Data DataTag",
					Help = "Give the caller the given amount of the specified item with the given data value and DataTag, even if it is blacklisted",
				},
			},
		},

		["/vanish"] =
		{
			Permission = "core.vanish",
			Handler = HandleVanishCommand,
			HelpString = "Disappear from view of other players",
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
			HelpString = "Change world's weather",
			ParameterCombinations =
			{
				{
					Params = "Weather",
					Help = "Set the weather to to the given condition, can be: clear, rain, or thunder",
				},
				{
					Params = "Weather DurationInSeconds",
					Help = "Set the weather to the given condition for the specified duration",
				},
				{
					Params = "Weather WorldName",
					Help = "Set the weather to the given condition in the given world, rather than the default world",
				},
				{
					Params = "Weather DurationInSeconds WorldName",
					Help = "Set the weather to the given condition for the specified duration in the given world, rather than the default world",
				},
			},
		},

		["/whitelist"] =
		{
			HelpString= "Manage the whitelist",
			Subcommands =
			{
				add =
				{
					HelpString = "Add a player to the whitelist",
					Permission = "core.whitelist",
					Handler = HandleWhitelistAddCommand,
					ParameterCombinations =
					{
						{
							Params = "PlayerName",
							Help = "Add the specified player to the whitelist",
						},
					},
				},
				list =
				{
					HelpString = "Show all players on the whitelist",
					Permission = "core.whitelist",
					Handler = HandleWhitelistListCommand,
				},
				off =
				{
					HelpString = "Disable whitelist processing",
					Permission = "core.whitelist",
					Handler = HandleWhitelistOffCommand,
				},
				on =
				{
					HelpString= "Enable whitelist processing",
					Permission = "core.whitelist",
					Handler = HandleWhitelistOnCommand,
				},
				remove =
				{
					HelpString = "Remove a player from the whitelist",
					Permission = "core.whitelist",
					Handler = HandleWhitelistRemoveCommand,
					ParameterCombinations =
					{
						{
							Params = "PlayerName",
							Help = "Remove the specified player from the whitelist",
						},
					},
				},
			},  -- Subcommands
		},  -- /whitelist

		["/worlds"] = 
		{
			Permission = "core.worlds",
			Handler = HandleWorldsCommand,
			HelpString = "Show a list of all the worlds",
		},
	},  -- Commands


	
	ConsoleCommands =
	{
		["ban"] =
		{
			Handler =  HandleConsoleBan,
			HelpString = "Ban a player by name",
		},
		
		["tps"] =
		{
			Handler =  HandleConsoleTps,
			HelpString =  "Return the ticks per second from the server",
		},


		["banip"] =
		{
			Handler =  HandleConsoleBanIP,
			HelpString = "Ban a player by IP address",
			Alias = "ipban",
		},

		["banlist"] =
		{
			Handler = HandleConsoleBanList,
			HelpString = "List all players banned by name",
		},

		["banlist ips"] =
		{
			-- This is a dummy entry only to generate the documentation
			-- the real processing is done by the "banlist" command
			Handler =  HandleConsoleBanList,
			HelpString = "List all players banned by IP address",
		},

		["clear"] =
		{
			Handler =  HandleConsoleClear ,
			HelpString = "Clear a player's inventory",
		},

		["enchant"] = 
		{
			Handler = HandleConsoleEnchant,
			HelpString = "Add an enchantment to the specified player's held item",
			ParameterCombinations =
			{
				{
					Params = "PlayerName EnchantmentID",
					Help = "Add the specified enchantment to the specified player's currently held item",
				},
				{
					Params = "PlayerName EnchantmentID level",
					Help = "Add the specified enchantment of the given level to the specified player's currently held item",
				},
			},
		},

		["gamemode"] =
		{
			Handler =  HandleConsoleGamemode,
			HelpString = "Change a player's gamemode",
			ParameterCombinations = 
			{
				{
					Params = "gamemode PlayerName",
					Help = "Change gamemode of the given player",
				},
			},
		},

		["gm"] =
		{
			Handler =  HandleConsoleGamemode,
			HelpString = "Change a player's gamemode",
			ParameterCombinations = 
			{
				{
					Params = "gamemode PlayerName",
					Help = "Change gamemode of the given player",
				},
			},
		},

		["give"] =
		{
			Handler =  HandleConsoleGive,
			HelpString = "Give an item to the specified player",
			ParameterCombinations = 
			{
				{
					Params = "PlayerName ItemName",
					Help = "Give the player one of the specified item",
				},
				{
					Params = "PlayerName ItemName Amount",
					Help = "Give the player the given amount of the specified item",
				},
				{
					Params = "PlayerName ItemName Amount Data",
					Help = "Give the player the given amount of the specified item with the given data value",
				},
				{
					Params = "PlayerName ItemName Amount Data DataTag",
					Help = "Give the player the given amount of the specified item with the given data value and DataTag",
				},
			},
		},

		["kick"] =
		{
			Handler =  HandleConsoleKick,
			HelpString = "Kick a player by name",
		},

		["kill"] =
		{
			Handler =  HandleConsoleKill,
			HelpString = "Kill a player by name",
		},

		["list"] =
		{
			Handler =  HandleConsoleList,
			HelpString = "List all players in a machine-readable format",
		},

		["listgroups"] =
		{
			Handler =  HandleConsoleListGroups,
			HelpString = "Show a list of all the groups",
		},

		["listranks"] =
		{
			Handler =  HandleConsoleListRanks,
			HelpString = "Show a list of all the ranks",
		},

		["numchunks"] =
		{
			Handler =  HandleConsoleNumChunks,
			HelpString = "Show the number of chunks currently loaded",
		},

		["players"] =
		{
			Handler =  HandleConsolePlayers,
			HelpString = "List all connected players",
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
		
		["regen"] =
		{
			Handler = HandleConsoleRegen,
			Alias = "regeneratechunk",
			HelpString = "Regenerate a chunk",
			ParameterCombinations =
			{
				{
					Params = "ChunkX ChunkZ",
					Help = "Regenerate the specified chunk",
				},
				{
					Params = "ChunkX ChunkZ WorldName",
					Help = "Regenerate the specified chunk in the specified world",
				}
			},
		},  -- regen

		["save-all"] =
		{
			Handler =  HandleConsoleSaveAll,
			HelpString = "Save all chunk data to the filesystem",
		},

		["say"] =
		{
			Handler =  HandleConsoleSay,
			HelpString = "Send a chat message to all players",
		},

		["time"] = 
		{
			HelpString = "Set or display the time",
			Subcommands = 
			{
				day =
				{
					Handler = HandleConsoleSpecialTime,
					HelpString = "Set the time to day",
					ParameterCombinations =
					{
						{
							Params = "WorldName",
							Help = "Set the time to day in the given world, rather than the default world",
						},
					},
				},
				night =
				{
					Handler = HandleConsoleSpecialTime,
					HelpString = "Set the time to night",
					ParameterCombinations =
					{
						{
							Params = "WorldName",
							Help = "Set the time to night in the given world, rather than the default world",
						},
					},
				},
				set =
				{
					Handler = HandleConsoleSetTime,
					HelpString = "Set the time to the value given",
					ParameterCombinations =
					{
						{
							Params = "time",
							Help = "Set the time to the given value"
						},
						{
							Params = "day",
							Help = "Set the time to day",
						},
						{
							Params = "night",
							Help = "Set the time to night",
						},
						{
							Params = "time WorldName",
							Help = "Set the time to the given value in the given world, rather than the default world",
						},
						{
							Params = "day WorldName",
							Help = "Set the time to day in the given world, rather than the default world",
						},
						{
							Params = "night WorldName",
							Help = "Set the time to night in the given world, rather than the default world",
						},
					},
				},
				add =
				{
					Handler = HandleConsoleAddTime,
					HelpString = "Add the amount given to the current time",
					ParameterCombinations =
					{
						{
							Params = "amount",
							Help = "Add the amount given to the current time"
						},
						{
							Params = "add WorldName",
							Help = "Add the amount to the time in the given world, rather than the default world",
						},
					},
				},
				query =
				{
					Subcommands =
					{
						daytime =
						{
							Handler = HandleConsoleQueryDaytime,
							HelpString = "Display the current time",
							ParameterCombinations =
							{
								{
									Params = "WorldName",
									Help = "Display the time in the given world, rather than the default world",
								},
							},
						},
						gametime =
						{
							Handler = HandleConsoleQueryGametime,
							HelpString = "Display the amount of time elapsed since start",
							ParameterCombinations =
							{
								{
									Params = "WorldName",
									Help = "Display the time elapsed since start in the given world, rather than the default world",
								},
							},
						},
					},
				},
			},
		},

		["toggledownfall"] =
		{
			Handler = HandleConsoleDownfall,
			HelpString = "Toggle the weather between clear skies and rain",
			ParameterCombinations =
			{
				{
					Params = "WorldName",
					Help = "Toggle the weather between clear skies and rain in the given world, rather than the default world",
				},
			},
		},

		["tp"] =
		{
			Handler =  HandleConsoleTeleport,
			HelpString = "Teleport a player",
		},

		["unban"] =
		{
			Handler =  HandleConsoleUnban,
			HelpString = "Unban a player by name",
		},

		["unbanip"] =
		{
			Handler =  HandleConsoleUnbanIP,
			HelpString = "Unban a player by IP address",
		},

		["unloadchunks"] =
		{
			Handler = HandleConsoleUnload,
			HelpString = "Unload all unused chunks",
		},
		
		["unrank"] =
		{
			Handler = HandleConsoleUnrank,
			HelpString = "Reset the player's rank to default",
		},
		
		["unsafegive"] =
		{
			Handler =  HandleConsoleUnsafeGive,
			HelpString = "Give items to the specified player, even if its blacklisted",
			ParameterCombinations = 
			{
				{
					Params = "PlayerName ItemName",
					Help = "Give the player one of the specified item, even if its blacklisted",
				},
				{
					Params = "PlayerName ItemName Amount",
					Help = "Give the player the given amount of the specified item, even if its blacklisted",
				},
				{
					Params = "PlayerName ItemName Amount Data",
					Help = "Give the player the given amount of the specified item with the given data value, even if its blacklisted",
				},
				{
					Params = "PlayerName ItemName Amount Data DataTag",
					Help = "Give the player the given amount of the specified item with the given data value and DataTag, even if its blacklisted",
				},
			},
		},
		
		["weather"] =
		{
			Handler =  HandleConsoleWeather,
			HelpString = "Change world's weather",
			ParameterCombinations =
			{
				{
					Params = "Weather",
					Help = "Set the weather to to the given condition, can be: clear, rain, or thunder",
				},
				{
					Params = "Weather DurationInSeconds",
					Help = "Set the weather to the given condition and have it last for the specified duration",
				},
				{
					Params = "Weather WorldName",
					Help = "Set the weather to the given condition in the given world, rather than the default world",
				},
				{
					Params = "Weather DurationInSeconds WorldName",
					Help = "Set the weather to the given condition and have it last for the specified duration in the given world, rather than the default world",
				},
			},
		},

		["whitelist"] =
		{
			HelpString= "Manage the whitelist",
			Subcommands =
			{
				add =
				{
					HelpString = "Add a player to the whitelist",
					Handler = HandleConsoleWhitelistAdd,
					ParameterCombinations =
					{
						{
							Params = "PlayerName",
							Help = "Add the specified player to the whitelist by name",
						},
					},
				},
				list =
				{
					HelpString = "List all the players on the whitelist",
					Handler = HandleConsoleWhitelistList,
				},
				off =
				{
					HelpString = "Disable whitelist processing",
					Handler = HandleConsoleWhitelistOff,
				},
				on =
				{
					HelpString = "Enable whitelist processing",
					Handler = HandleConsoleWhitelistOn,
				},
				remove =
				{
					HelpString = "Remove a player from the whitelist",
					Handler = HandleConsoleWhitelistRemove,
					ParameterCombinations =
					{
						{
							Params = "PlayerName",
							Help = "Remove the specified player from the whitelist by name",
						},
					},
				},
			},  -- Subcommands
		},  -- whitelist
	},  -- ConsoleCommands
	Permissions = 
	{
		["core.changegm"] =
		{
			Description = "Allow players to change the gamemode",
			RecommendedGroups = "admins",
		},

		["core.enchant"] =
		{
			Description = "Allow players to add enchantments to a currently held item",
			RecommendedGroups = "admins",
		},

		["core.enchant.self"] =
		{
			Description = "Allow players to add enchantments to their own currently held item",
			RecommendedGroups = "admins",
		},

		["core.give"] =
		{
			Description = "Allow players to give items to other players",
			RecommendedGroups = "admins",
		},

		["core.give.unsafe"] =
		{
			Description = "Allow players to give items to other players, even if the item is blacklisted",
			RecommendedGroups = "none",
		},

		["core.item"] =
		{
			Description = "Allow players to give items to themselves",
			RecommendedGroups = "admins",
		},

		["core.item.unsafe"] =
		{
			Description = "Allow players to give items to themselves, even if the item is blacklisted",
			RecommendedGroups = "none",
		},

		["core.time.set"] = 
		{
			Description = "Allow players to set the time of day",
			RecommendedGroups = "admins",
		},

		["core.time.query.daytime"] =
		{
			Description = "Allow players to display the time of day",
			RecommendedGroups = "everyone",
		},

		["core.time.query.gametime"] =
		{
			Description = "Allow players to display how long the world has existed",
		},
		
		["core.toggledownfall"] =
		{
			Description = "Allow players to toggle the weather between clear skies and rain",
			RecommendedGroups = "admins",
		},
		
		["core.weather"] =
		{
			Description = "Allow players to change the weather",
			RecommendedGroups = "admins",
		},
		

		["core.whitelist"] =
		{
			Description = "Allow players to manage the whitelist",
			RecommendedGroups = "admins",
		},
	},  -- Permissions
}  -- g_PluginInfo


