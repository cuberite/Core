-- Implements things related to console commands

function InitConsoleCommands()
	local PluginMgr = cPluginManager:Get()

	-- Please keep the list alpha-sorted
	PluginMgr:BindConsoleCommand("ban",         HandleConsoleBan,        " ~ Bans a player by name")
	PluginMgr:BindConsoleCommand("banlist ips", HandleConsoleBanList,    " - Lists all players banned by IP")
	PluginMgr:BindConsoleCommand("banlist",     HandleConsoleBanList,    " - Lists all players banned by name")
	PluginMgr:BindConsoleCommand("clear",       HandleConsoleClear  ,    " ~ Clear a player's inventory")
	PluginMgr:BindConsoleCommand("gamemode",    HandleConsoleGamemode,   " ~ Change a player's gamemode")
	PluginMgr:BindConsoleCommand("getversion",  HandleConsoleVersion,    " - Gets server version reported to 1.4+ clients")
	PluginMgr:BindConsoleCommand("gm",          HandleConsoleGamemode,   " ~ Change a player's gamemode")
	PluginMgr:BindConsoleCommand("give",        HandleConsoleGive,       " ~ Gives items to the specified player.")
	PluginMgr:BindConsoleCommand("kick",        HandleConsoleKick,       " ~ Kicks a player by name")
	PluginMgr:BindConsoleCommand("kill",        HandleConsoleKill,       " ~ Kill a player")
	PluginMgr:BindConsoleCommand("list",        HandleConsoleList,       " - Lists all players in a machine-readable format")
	PluginMgr:BindConsoleCommand("listgroups",  HandleConsoleListGroups, " - Shows a list of all the groups")
	PluginMgr:BindConsoleCommand("numchunks",   HandleConsoleNumChunks,  " - Shows number of chunks currently loaded")
	PluginMgr:BindConsoleCommand("players",     HandleConsolePlayers,    " - Lists all connected players")
	PluginMgr:BindConsoleCommand("rank",        HandleConsoleRank,       " ~ Add a player to a group")
	PluginMgr:BindConsoleCommand("save-all",    HandleConsoleSaveAll,    " - Saves all chunks")
	PluginMgr:BindConsoleCommand("say",         HandleConsoleSay,        " ~ Sends a chat message to all players")
	PluginMgr:BindConsoleCommand("setversion",  HandleConsoleVersion,    " ~ Sets server version reported to 1.4+ clients")
	PluginMgr:BindConsoleCommand("tp",          HandleConsoleTeleport,   " ~ Teleports a player")
	PluginMgr:BindConsoleCommand("unban",       HandleConsoleUnban,      " ~ Unbans a player by name")
	PluginMgr:BindConsoleCommand("unload",      HandleConsoleUnload,     " - Unloads all unused chunks")
	PluginMgr:BindConsoleCommand("weather",     HandleConsoleWeather,    " - Change wheater on the specified world")

end

function HandleConsoleGive(Split)

	-- Make sure there are a correct number of arguments.
	if #Split ~= 3 and #Split ~= 4 and #Split ~= 5 then
		return true, "Usage: give <player> <item> [amount] [meta]"
	end

	-- Get the item from the arguments and check it's valid.
	local Item = cItem()
	if #Split == 5 then
		local FoundItem = StringToItem(Split[3] .. ":" .. Split[5], Item)
	else
		local FoundItem = StringToItem(Split[3], Item)
	end
	if not IsValidItem(Item.m_ItemType) then  -- StringToItem does not check if item is valid
		FoundItem = false
	end

	if not FoundItem  then
		return true, "Invalid item id or name!"
	end

	-- Work out how many items the user wants.
	local ItemAmount = 1
	if #Split > 3 then
		ItemAmount = tonumber(Split[4])
		if ItemAmount == nil or ItemAmount < 1 or ItemAmount > 512 then
			return true, "Invalid amount!"
		end
	end

	Item.m_ItemCount = ItemAmount

	-- Get the playername from the split.
	local playerName = Split[2]

	local function giveItems(newPlayer)
		local ItemsGiven = newPlayer:GetInventory():AddItem(Item)
		if ItemsGiven == ItemAmount then
			SendMessageSuccess( newPlayer, "There you go!" )
			LOG("Gave " .. newPlayer:GetName() .. " " .. Item.m_ItemCount .. " times " .. Item.m_ItemType .. ":" .. Item.m_ItemDamage)
		else
			SendMessageFailure( Player, "Not enough space in inventory, only gave " .. ItemsGiven)
			return true, "Only " .. Item.m_ItemCount .. " out of " .. ItemsGiven .. "items could be delivered."
		end
	end

	-- Finally give the items to the player.
	itemStatus = cRoot:Get():FindAndDoWithPlayer(playerName, giveItems)

	-- Check to make sure that giving items was successful.
	if not itemStatus then
		return true, "There was no player that matched your query."
	end

	return true

end

function HandleConsoleBan(Split)
	if (#Split < 2) then
		return true, "Usage: ban [Player] <Reason>"
	end

	local Reason = cChatColor.Red .. "You have been banned."
	if( #Split > 2 ) then
		Reason = table.concat(Split, " ", 3)
	end

	if not(KickPlayer(Split[2], Reason)) then
		LOGINFO("Could not find player, but banned anyway" )
	else
		LOGINFO("Successfully kicked and banned player" )
	end
	BannedPlayersIni:SetValueB("Banned", Split[2], true)
	BannedPlayersIni:WriteFile("banned.ini")

	return true
end





function HandleConsoleKick(Split)
	if (#Split < 2) then
		return true, "Usage: kick [Player] <Reason>"
	end

	local Reason = cChatColor.Red .. "You have been kicked."
	if (#Split > 2) then
		Reason = table.concat(Split, " ", 3)
	end

	if (KickPlayer(Split[2], Reason)) then
		return true
	end

	return true, "Cannot find player " .. Split[2]
end





function HandleConsoleUnban(Split)

	if #Split < 2 then
		return true, "Usage: /unban [Player]"
	end

	if( BannedPlayersIni:GetValueB("Banned", Split[2], false) == false ) then
		return true, Split[2] .. " is not banned!"
	end

	BannedPlayersIni:SetValueB("Banned", Split[2], false, false)
	BannedPlayersIni:WriteFile("banned.ini")

	LOGINFO("Unbanned " .. Split[2])
	return true

end

function HandleConsoleBanList(Split)
	if (#Split == 1) then
		return true, BanListByName()
	end

	if (string.lower(Split[2]) == "ips") then
		return true, BanListByIPs()
	end

	return true, "Unknown banlist subcommand"
end

function HandleConsoleList(Split)
	-- Get a list of all players, one playername per line
	local Out = ""
	cRoot:Get():ForEachWorld(
		function (a_World)
			a_World:ForEachPlayer(
				function (a_Player)
					Out = Out .. a_Player:GetName() .. "\n"
				end
			)
		end
	)
	return true, Out
end

function HandleConsoleListGroups(Split)
	-- Read the groups.ini file:
	local GroupsIni = cIniFile()
	if (not(GroupsIni:ReadFile("groups.ini"))) then
		return true, "No groups found"
	end

	-- Read the groups:
	Number = GroupsIni:GetNumKeys()
	Groups = {}
	for i = 0, Number do
		table.insert(Groups, GroupsIni:GetKeyName(i))
	end

	-- Output the groups, concatenated to a string:
	local Out = "Groups:\n"
	Out = Out .. table.concat(Groups, ", ")
	return true, Out
end

function HandleConsoleNumChunks(Split)
	local Output = {}
	local AddNumChunks = function(World)
		Output[World:GetName()] = World:GetNumChunks()
	end

	cRoot:Get():ForEachWorld(AddNumChunks)

	local Total = 0
	local Out = ""
	for name, num in pairs(Output) do
		Out = Out .. "  " .. name .. ": " .. num .. " chunks\n"
		Total = Total + num
	end
	Out = Out .. "Total: " .. Total .. " chunks\n"

	return true, Out
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

function HandleConsoleVersion(Split)
	if (#Split == 1) then
		-- Display current version:
		local Version = cRoot:Get():GetPrimaryServerVersion()
		return true, "Primary server version: #" .. Version .. ", " .. cRoot:GetProtocolVersionTextFromInt(Version)
	end

	-- Set new value as the version:
	cRoot:Get():SetPrimaryServerVersion(tonumber(Split[2]))
	local Version = cRoot:Get():GetPrimaryServerVersion()
	return true, "Primary server version is now #" .. Version .. ", " .. cRoot:GetProtocolVersionTextFromInt(Version)
end

function HandleConsoleRank(Split)
	if (Split[2] == nil) or (Split[3] == nil) then
		return true, "Usage: /rank [Player] [Group]"
	end
	local Out = ""

	-- Read the groups.ini file:
	local GroupsIni = cIniFile()
	if (not(GroupsIni:ReadFile("groups.ini"))) then
		GroupsIni:WriteFile("groups.ini")
	end

	-- Find the group:
	if (GroupsIni:FindKey(Split[3]) == -1) then
		return true, Out .. "Group does not exist"
	end

	-- Read the users.ini file:
	local UsersIni = cIniFile()
	UsersIni:ReadFile("users.ini")

	-- Write the new group value to users.ini:
	UsersIni:DeleteKey(Split[2])
	UsersIni:GetValueSet(Split[2], "Groups", Split[3])
	UsersIni:WriteFile("users.ini")

	-- Reload the player's permissions:
	cRoot:Get():ForEachWorld(
		function (World)
			World:ForEachPlayer(
				function (Player)
					if (Player:GetName() == Split[2]) then
						SendMessageSuccess( Player, "You were moved to group " .. Split[3] )
						Player:LoadPermissionsFromDisk()
					end
				end
			)
		end
	)

	return true, Out .. "Player " .. Split[2] .. " was moved to " .. Split[3]
end

function HandleConsoleSaveAll(Split)

	cRoot:Get():BroadcastChat(cChatColor.Rose .. "[WARNING] " .. cChatColor.White .. "Saving all chunks!")
	cRoot:Get():SaveAllChunks()
	return true
end

function HandleConsoleSay(Split)
	table.remove(Split, 1)
	local Message = ""
	for i, Text in ipairs(Split) do
		Message = Message .. " " .. Text
	end
	Message = Message:sub(2)  -- Cut off the first space
	
	cRoot:Get():BroadcastChat(cChatColor.Gold .. "[SERVER] " .. cChatColor.Yellow .. Message)
	return true
end

function HandleConsoleUnload(Split)
	local UnloadChunks = function(World)
		World:UnloadUnusedChunks()
	end

	local Out = "Num loaded chunks before: " .. cRoot:Get():GetTotalChunkCount() .. "\n"
	cRoot:Get():ForEachWorld(UnloadChunks)
	Out = Out .. "Num loaded chunks after: " .. cRoot:Get():GetTotalChunkCount()
	return true, Out
end

function HandleConsoleKill(Split)
	if (#Split == 1) then
		return true, "Usage: /kill [Player]"
	end
    
	local HasKilled = false;
	local KillPlayer = function(Player)
		if (Player:GetName() == Split[2]) then
			Player:TakeDamage(dtInVoid, nil, 1000, 1000, 0)
			HasKilled = true         
		end
	end

	cRoot:Get():FindAndDoWithPlayer(Split[2], KillPlayer);
	if (HasKilled) then
		return true, "Player " .. Split[2] .. " is killed" 
	else
		return true, "Player not found" 
	end
end

function HandleConsoleClear(Split)
	if (#Split == 1) then
		return true, "Usage: /clear [Player]"
    end
    
    local InventoryCleared = false;
    local ClearInventory = function(Player)
        if (Player:GetName() == Split[2]) then
            Player:GetInventory():Clear()
            InventoryCleared = true
        end
    end

    cRoot:Get():FindAndDoWithPlayer(Split[2], ClearInventory);
    if (InventoryCleared) then
        return true, "You cleared the inventory of " .. Split[2]
    else
        return true, "Player not found" 
    end
end

function HandleConsoleWeather(Split)
        if #Split ~= 3 then
                return true, "Usage: /weather [world] [clear/rain/thunder]" 
        end

        Root = cRoot:Get()
        if Root:GetWorld(Split[2]) == nil then
            return true, "No world named "..Split[2]
        elseif (Split[3] == "clear") then
            Root:GetWorld(Split[2]):SetWeather(0)
            return true, "Downfall stopped" 
        elseif (Split[3] == "rain") then
            Root:GetWorld(Split[2]):SetWeather(1)
            return true, "Let it rain!" 
        elseif (Split[3] == "thunder") then
            Root:GetWorld(Split[2]):SetWeather(2)
            return true, "Thundery showers activate!"
        end
end

function HandleConsoleGamemode(Split)
	if #Split ~= 3 then
		return true, "Usage: " ..Split[1].. " [survival|creative|adventure] [player] " 
	end

	local IsPlayerOnline = false;
	local ChangeGM = function(Player)
		if (Player:GetName() == Split[3]) then
			IsPlayerOnline = true
			if (Split[2] == "survival") or (Split[2] == "0") then
				Player:SetGameMode(0)
			elseif (Split[2] == "creative") or (Split[2] == "1") then
				Player:SetGameMode(1)
			elseif (Split[2] == "adventure") or (Split[2] == "2") then
				Player:SetGameMode(2)
			else
				IsPlayerOnline = invalidgm
			end
		end
	end

	cRoot:Get():FindAndDoWithPlayer(Split[3], ChangeGM);
	if (IsPlayerOnline) then
		return true, "Changed gamemode for player " .. Split[3] 
	end
	if (IsPlayerOnline == invalidgm) then
		return true, "Usage: " ..Split[1].. " [survival|creative|adventure] [player] " 
	end
	if (IsPlayerOnline == false) then
		return true, "Player not found" 
	end
end

function HandleConsoleTeleport(Split)
	local TeleportToCoords = function(Player)
		if (Player:GetName() == Split[2]) then
			IsPlayerOnline = true
            Player:TeleportToCoords(Split[3], Split[4], Split[5])
		end
	end
	
	local IsPlayerOnline = false;
	local FirstPlayerOnline = false;
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

	if #Split == 3 then
	    cRoot:Get():FindAndDoWithPlayer(Split[3], GetPlayerCoords);
	    if (FirstPlayerOnline) then
	        cRoot:Get():FindAndDoWithPlayer(Split[2], TeleportToPlayer);
	        if (IsPlayerOnline) then
	            return true, "Teleported " .. Split[2] .." to " .. Split[3]
	        end
	    else
	        return true, "Player " .. Split[3] .." not found"
	    end
	elseif #Split == 5 then
	    cRoot:Get():FindAndDoWithPlayer(Split[2], TeleportToCoords);
	    if (IsPlayerOnline) then
		    return true, "You teleported " .. Split[2] .. " to [X:" .. Split[3] .. " Y:" .. Split[4] .. " Z:" .. Split[5] .. "]" 
		else
		    return true, "Player not found" 
		end
	else
		return true, "Usage: /tp [player] [toplayer] or /tp [player] [X Y Z]" 
	end
end
