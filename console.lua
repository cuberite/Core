
-- console.lua

-- Implements things related to console commands





function HandleConsoleListGroups(a_Split)
	if (a_Split[3] ~= nil) then
		-- Too many params:
		return true, "Too many parameters. Usage: listgroups [rank]"
	end

	-- If no params are given, list all groups that the manager knows:
	local RankName = a_Split[2]
	if (RankName == nil) then
		-- Get all the groups:
		local Groups = cRankManager:GetAllGroups()

		-- Output the groups, concatenated to a string:
		local Out = "Available groups:\n"
		Out = Out .. table.concat(Groups, ", ")
		return true, Out
	end

	-- A rank name is given, list the groups in that rank:
	local Groups = cRankManager:GetRankGroups(RankName)
	local Out = "Groups in rank " .. RankName .. ":\n" .. table.concat(Groups, ", ")
	return true, Out
end





function HandleConsoleListRanks(Split)
	-- Get all the groups:
	local Groups = cRankManager:GetAllRanks()

	-- Output the groups, concatenated to a string:
	local Out = "Available ranks:\n"
	Out = Out .. table.concat(Groups, ", ")
	return true, Out
end





function HandleConsoleNumChunks(Split)
	-- List each world's chunk count into a table, sum the total chunk count:
	local Output = {}
	local Total = 0
	cRoot:Get():ForEachWorld(
		function(a_World)
			table.insert(Output, a_World:GetName() .. ": " .. a_World:GetNumChunks() .. " chunks")
			Total = Total + a_World:GetNumChunks()
		end
	)
	table.sort(Output)

	-- Return the complete report:
	return true, table.concat(Output, "\n") .. "\nTotal: " .. Total .. " chunks\n"
end





function HandleConsolePlayers(Split)
	local PlayersInWorlds = {}    -- "WorldName" => [players array]
	local AddToTable = function(Player)
		local WorldName = Player:GetWorld():GetName()
		if (PlayersInWorlds[WorldName] == nil) then
			PlayersInWorlds[WorldName] = {}
		end
		table.insert(PlayersInWorlds[WorldName], Player:GetName() .. " @ " ..  Player:GetIP())
	end

	cRoot:Get():ForEachPlayer(AddToTable)

	local Out = ""
	for WorldName, Players in pairs(PlayersInWorlds) do
		Out = Out .. "World " .. WorldName .. ":\n"
		for i, PlayerName in ipairs(Players) do
			Out = Out .. "  " .. PlayerName .. "\n"
		end
	end

	return true, Out
end





function HandleConsolePlugins(Split)
	-- Enumerate the plugins:
	local PluginTable = {}
	cPluginManager:Get():ForEachPlugin(
		function (a_CBPlugin)
			table.insert(PluginTable,
				{
					Name = a_CBPlugin:GetName(),
					Folder = a_CBPlugin:GetFolderName(),
					Status = a_CBPlugin:GetStatus(),
					LoadError = a_CBPlugin:GetLoadError()
				}
			)
		end
	)
	table.sort(PluginTable,
		function (a_Plugin1, a_Plugin2)
			return (string.lower(a_Plugin1.Folder) < string.lower(a_Plugin2.Folder))
		end
	)

	-- Prepare a translation table for the status:
	local StatusName =
	{
		[cPluginManager.psLoaded]   = "Loaded  ",
		[cPluginManager.psUnloaded] = "Unloaded",
		[cPluginManager.psError]    = "Error   ",
		[cPluginManager.psNotFound] = "NotFound",
		[cPluginManager.psDisabled] = "Disabled",
	}

	-- Generate the output:
	local Out = {}
	table.insert(Out, "There are ")
	table.insert(Out, #PluginTable)
	table.insert(Out, " plugins, ")
	table.insert(Out, cPluginManager:Get():GetNumLoadedPlugins())
	table.insert(Out, " loaded:\n")
	for _, plg in ipairs(PluginTable) do
		table.insert(Out, "  ")
		table.insert(Out, StatusName[plg.Status] or "        ")
		table.insert(Out, " ")
		table.insert(Out, plg.Folder)
		if (plg.Name ~= plg.Folder) then
			table.insert(Out, " (API name ")
			table.insert(Out, plg.Name)
			table.insert(Out, ")")
		end
		if (plg.Status == cPluginManager.psError) then
			table.insert(Out, " ERROR: ")
			table.insert(Out, plg.LoadError or "<unknown>")
		end
		table.insert(Out, "\n")
	end
	return true, table.concat(Out, "")
end





function HandleConsoleRank(a_Split)
	-- Check parameters:
	if ((a_Split[2] == nil) or (a_Split[4] ~= nil)) then
		-- Not enough or too many parameters
		return true, "Usage: " .. a_Split[1] .. " <player> [rank]"
	end

	-- Translate the PlayerName to a UUID:
	local PlayerName = a_Split[2]
	local PlayerUUID
	if (cRoot:Get():GetServer():ShouldAuthenticate()) then
		-- The server is in online-mode, get the UUID from Mojang servers and check for validity:
		PlayerUUID = cMojangAPI:GetUUIDFromPlayerName(PlayerName)
		if ((PlayerUUID == nil) or (string.len(PlayerUUID) ~= 32)) then
			return true, "There is no such player: " .. PlayerName
		end
	else
		-- The server is in offline mode, generate an offline-mode UUID, no validity check is possible:
		PlayerUUID = cClientHandle:GenerateOfflineUUID(PlayerName)
	end

	-- View the player's rank, if requested:
	if (a_Split[3] == nil) then
		-- "/rank <PlayerName>" usage, display the rank:
		local CurrRank = cRankManager:GetPlayerRankName(PlayerUUID)
		if (CurrRank == "") then
			return true, "The player has no rank assigned to them."
		else
			return true, "The player's rank is " .. CurrRank
		end
	end

	-- Change the player's rank:
	local NewRank = a_Split[3]
	if not(cRankManager:RankExists(NewRank)) then
		return true, "The specified rank does not exist!"
	end
	cRankManager:SetPlayerRank(PlayerUUID, PlayerName, NewRank)

	-- Update all players in the game of the given name and let them know:
	cRoot:Get():ForEachPlayer(
		function(a_CBPlayer)
			if (a_CBPlayer:GetName() == PlayerName) then
				a_CBPlayer:SendMessageInfo("You were assigned the rank " .. NewRank .. " by the server console")
				a_CBPlayer:LoadRank()
			end
		end
	)
	return true, "Player " .. PlayerName .. " is now in rank " .. NewRank
end





function HandleConsoleOp(a_Split)
	-- Check the params:
	if ((a_Split[2] == nil) or (a_Split[3] ~= nil)) then
		-- Not enough or too many parameters
		return true, "Usage: " .. a_Split[1] .. " <player>"
	end

	local PlayerName = a_Split[2]
	local AdminRank = GetAdminRank()

	if not AdminRank then
		SendMessage(a_Player, "No admin rank found, missing * permission")
		return true
	end

	return HandleConsoleRank({"rank", PlayerName, AdminRank})
end





function HandleConsoleDeOp(a_Split)
	-- Check the params:
	if ((a_Split[2] == nil) or (a_Split[3] ~= nil)) then
		-- Not enough or too many parameters
		return true, "Usage: " .. a_Split[1] .. " <player>"
	end

	local PlayerName = a_Split[2]
	local DefaultRank = cRankManager:GetDefaultRank()

	return HandleConsoleRank({"rank", PlayerName, DefaultRank})
end





function HandleConsoleTeleport(Split)
	local TeleportToCoords = function(Player)
		if (Player:GetName() == Split[2]) then
			IsPlayerOnline = true
			Player:TeleportToCoords(Split[3], Split[4], Split[5])
		end
	end

	local IsPlayerOnline = false
	local FirstPlayerOnline = false
	local GetPlayerCoords = function(Player)
		if (Player:GetName() == Split[3]) then
			PosX = Player:GetPosX()
			PosY = Player:GetPosY()
			PosZ = Player:GetPosZ()
			FirstPlayerOnline = true
		end
	end

	local TeleportToPlayer = function(Player)
		if (Player:GetName() == Split[2]) then
		    Player:TeleportToCoords(PosX, PosY, PosZ)
			IsPlayerOnline = true
		end
	end

	if (#Split == 3) then
		cRoot:Get():FindAndDoWithPlayer(Split[3], GetPlayerCoords)
		if (FirstPlayerOnline) then
			cRoot:Get():FindAndDoWithPlayer(Split[2], TeleportToPlayer)
			if (IsPlayerOnline) then
				return true, "Teleported " .. Split[2] .." to " .. Split[3]
			end
		else
				return true, "Player " .. Split[3] .." not found"
		end
	elseif (#Split == 5) then
		cRoot:Get():FindAndDoWithPlayer(Split[2], TeleportToCoords)
		if (IsPlayerOnline) then
			return true, "You teleported " .. Split[2] .. " to [X:" .. Split[3] .. " Y:" .. Split[4] .. " Z:" .. Split[5] .. "]"
		else
			return true, "Player not found"
		end
	else
		return true, "Usage: '" .. Split[1] .. " <target player> <destination player>' or 'tp <target player> <x> <y> <z>'"
	end
end




function HandleConsoleUnload(Split)
	local UnloadChunks = function(World)
		World:QueueUnloadUnusedChunks()
	end

	local Out = "Num loaded chunks before: " .. cRoot:Get():GetTotalChunkCount() .. "\n"
	cRoot:Get():ForEachWorld(UnloadChunks)
	Out = Out .. "Num loaded chunks after: " .. cRoot:Get():GetTotalChunkCount()
	return true, Out
end






function HandleConsoleUnrank(a_Split)
	-- Check params:
	if ((a_Split[2] == nil) or (a_Split[3] ~= nil)) then
		-- Too few or too many parameters:
		return true, "Usage: " .. a_Split[1] .. " <player>"
	end

	-- Translate the PlayerName to a UUID:
	local PlayerName = a_Split[2]
	local PlayerUUID
	if (cRoot:Get():GetServer():ShouldAuthenticate()) then
		-- The server is in online-mode, get the UUID from Mojang servers and check for validity:
		PlayerUUID = cMojangAPI:GetUUIDFromPlayerName(PlayerName)
		if ((PlayerUUID == nil) or (string.len(PlayerUUID) ~= 32)) then
			return true, "There is no such player: " .. PlayerName
		end
	else
		-- The server is in offline mode, generate an offline-mode UUID, no validity check is possible:
		PlayerUUID = cClientHandle:GenerateOfflineUUID(PlayerName)
	end

	-- Unrank the player:
	cRankManager:RemovePlayerRank(PlayerUUID)

	-- Update all players in the game of the given name and let them know:
	cRoot:Get():ForEachPlayer(
		function(a_CBPlayer)
			if (a_CBPlayer:GetName() == PlayerName) then
				a_CBPlayer:SendMessageInfo("You were unranked by the server console")
				a_CBPlayer:LoadRank()
			end
		end
	)
	return true, "Player " .. PlayerName .. " is now in the default rank."
end
