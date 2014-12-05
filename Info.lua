
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
			ParameterCombinations = 
			{
				{
					Params = "gamemode",
					Help = "Change your own gamemode.",
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

		["/item"] = 
		{
			Alias = "/i",
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
							Help = "Set the time in the given world, rather than the current world",
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
							Help = "Set the time in the given world, rather than the current world",
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
									Help = "Display the time in the given world, rather than the current world",
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
			HelpString = "Toggles the weather between clear skies and rain",
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

		["/vanish"] =
		{
			Permission = "core.vanish",
			Handler = HandleVanishCommand,
			HelpString = " - Vanish",
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
					Help = "Set the weather to the given condition, for the specified duration",
				},
				{
					Params = "Weather WorldName",
					Help = "Set the weather to the given condition in the given world, rather than the default world",
				},
				{
					Params = "Weather DurationInSeconds WorldName",
					Help = "Set the weather to the given condition, have it last for the specified duration, in the given world",
				},
			},
		},

		["/whitelist"] =
		{
			HelpString= "Manages the whitelist",
			Subcommands =
			{
				add =
				{
					HelpString = "Adds a player to the whitelist",
					Permission = "core.whitelist",
					Handler = HandleWhitelistAddCommand,
					ParameterCombinations =
					{
						{
							Params = "PlayerName",
							Help = "Adds the specified player to the whitelist",
						},
					},
				},
				list =
				{
					HelpString = "Shows the players on the whitelist",
					Permission = "core.whitelist",
					Handler = HandleWhitelistListCommand,
				},
				off =
				{
					HelpString = "Turns whitelist processing off",
					Permission = "core.whitelist",
					Handler = HandleWhitelistOffCommand,
				},
				on =
				{
					HelpString= "Turns whitelist processing on",
					Permission = "core.whitelist",
					Handler = HandleWhitelistOnCommand,
				},
				remove =
				{
					HelpString = "Removes a player from the whitelist",
					Permission = "core.whitelist",
					Handler = HandleWhitelistRemoveCommand,
					ParameterCombinations =
					{
						{
							Params = "PlayerName",
							Help = "Removes the specified player from the whitelist",
						},
					},
				},
			},  -- Subcommands
		},  -- /whitelist

		["/worlds"] = 
		{
			Permission = "core.worlds",
			Handler = HandleWorldsCommand,
			HelpString = "Shows a list of all the worlds",
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
							Help = "Set the time in the given world, rather than the default world",
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
							Help = "Set the time in the given world, rather than the default world",
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
									Help = "Display the time in the given world, rather than the default world",
								},
							},
						},
					},
				},
			},
		},

		["toggledownfall"] =
		{
			Handler = HandleDownfallCommand,
			HelpString = "Toggles the weather between clear skies and rain",
			ParameterCombinations =
			{
				{
					Params = "WorldName",
					Help = "Change the weather in the given world, rather than the default world",
				},
			},
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
		
		["weather"] =
		{
			Handler =  HandleWeatherCommand,
			HelpString = "Change world's weather",
			ParameterCombinations =
			{
				{
					Params = "Weather",
					Help = "Set the weather to to the given condition, can be: clear, rain, or thunder",
				},
				{
					Params = "Weather DurationInSeconds",
					Help = "Set the weather to the given condition, for the specified duration",
				},
				{
					Params = "Weather WorldName",
					Help = "Set the weather to the given condition in the given world, rather than the default world",
				},
				{
					Params = "Weather DurationInSeconds WorldName",
					Help = "Set the weather to the given condition, have it last for the specified duration, in the given world",
				},
			},
		},

		["whitelist"] =
		{
			HelpString= "Manages the whitelist",
			Subcommands =
			{
				add =
				{
					HelpString = "Adds a player to the whitelist",
					Handler = HandleConsoleWhitelistAdd,
					ParameterCombinations =
					{
						{
							Params = "PlayerName",
							Help = "Adds the specified player to the whitelist",
						},
					},
				},
				list =
				{
					HelpString = "Lists all the players on the whitelist",
					Handler = HandleConsoleWhitelistList,
				},
				off =
				{
					HelpString = "Turns off whitelist processing",
					Handler = HandleConsoleWhitelistOff,
				},
				on =
				{
					HelpString = "Turns on whitelist processing",
					Handler = HandleConsoleWhitelistOn,
				},
				remove =
				{
					HelpString = "Removes a player from the whitelist",
					Handler = HandleConsoleWhitelistRemove,
					ParameterCombinations =
					{
						{
							Params = "PlayerName",
							Help = "Removes the specified player from the whitelist",
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
			Description = "Allows players to change gamemodes",
			RecommendedGroups = "admins",
		},

		["core.time.set"] = 
		{
			Description = "Allows players to set the time of day",
			RecommendedGroups = "admins",
		},

		["core.time.query.daytime"] =
		{
			Description = "Allows players to display the time of day",
			RecommendedGroups = "everyone",
		},

		["core.time.query.gametime"] =
		{
			Description = "Allows players to display how long the world has existed",
		},
		
		["core.toggledownfall"] =
		{
			Description = "Allows players to toggle the weather between clear skies and rain",
			RecommendedGroups = "admins",
		},
		
		["core.weather"] =
		{
			Description = "Allows players to change the weather",
			RecommendedGroups = "admins",
		},
		

		["core.whitelist"] =
		{
			Description = "Allows players to manage the whitelist",
			RecommendedGroups = "admins",
		},
	},  -- Permissions
}  -- g_PluginInfo


