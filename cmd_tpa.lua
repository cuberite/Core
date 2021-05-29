
-- cmd_tpa.lua

-- Adds the tpa command to the server.

local ToggleState = {}
local Settings = {}
local Cooldowns = {}
local Database = nil

local DatabasePath = "TPA.sqlite3"
local CooldownTableName = "CooldownLog"
local TransactionTableName = "Transactions"
local CleanupTime = 0
local CleanupCooldown = 5 * 60

-- constants for easier readability
local RequestCooldown = 2
local SuccessCooldown = 3

function OnPlayerJoined_TPA(Player)
	StoreCooldown(Player:GetUUID(), RequestCooldown, 1)
	StoreCooldown(Player:GetUUID(), SuccessCooldown, 1)
end

function InitializeTPA(Plugin)
	local PluginFolder = cPluginManager:GetPluginsPath() .. cFile:GetPathSeparator() .. Plugin:GetFolderName() .. cFile:GetPathSeparator()

	-- Load settings
	LoadSettings_TPA(g_IniFile)

	-- Creates/Loads Database
	Database = NewSQLiteDB(PluginFolder .. DatabasePath)

	if Database == nil or type(Database) =~ "table" then
		LOGERROR("Database for the tpa function could not be created!")
		return false
	end

	-- Creates the table if does not exist
	if not Database.CreateDBTable(CooldownTableName,
		{"PlayerUUID TEXT PRIMARY KEY",
		"LastRequest INT DEFAULT 0",
		"LastSuccess INT DEFAULT 0"}
	) then
		LOGERROR("Error in creating table in tpa database!")
		return false
	end
	
	Database.CreateDBTable(TransactionTableName,
		{"TransactionId TEXT PRIMARY KEY",
		"Source TEXT",
		"Destination TEXT",
		"Timestamp INT DEFAULT 0"}
	)
	return true
end

function OnDisable_TPA()
	Database.DB:close()
	os.remove(cPluginManager:GetPluginsPath() .. cFile:GetPathSeparator() .. cPluginManager:GetCurrentPlugin():GetFolderName() .. cFile:GetPathSeparator() .. DatabasePath)
end

function OnTick_TPA(TimeDelta)
	if os.time() - CleanupTime > CleanupCooldown then
		CleanupTime = os.time()
		CleanupTransaction()
	end
end

--------------------------------------------------------------------------------------------------------------------------------

function LoadSettings_TPA(IniFile)
	if IniFile:FindKey("TPA") == cIniFile.noID then
		-- File didn't exist
		IniFile:AddKeyName("TPA")

		IniFile:AddKeyComment("TPA", "Setting for the tpa command")
		IniFile:AddKeyComment("TPA", "Times maybe be set in the format of %h%m%s.")
		IniFile:AddValue("TPA", "CooldownRequest", "10s")
		IniFile:AddValue("TPA", "CooldownSucess", "60s")
		IniFile:AddValueB("TPA", "VerboseLogging", false)
	end

	local RequestCooldownString = IniFile:GetValue("TPA", "CooldownRequest", "10s")
	local SucessCooldownString =  IniFile:GetValue("TPA", "CooldownSucess", "60s")
	Settings["VerboseLogging"] =  IniFile:GetValueB("TPA", "VerboseLogging", false)
	Settings["RequestCooldown"] = StringToSeconds(RequestCooldownString)
	Settings["SuccessCooldown"] = StringToSeconds(SucessCooldownString)
end

--------------------------------------------------------------------------------------------------------------------------------

-- utility
function StringToSeconds(String)
	local TotalSecondCount = 0
	String = String:gsub(" ", "")
	String = String:lower()

	local hours = String:match("(%d+)h")
	if hours ~= nil then
		TotalSecondCount = TotalSecondCount + tonumber(hours) * 60 * 60
	end

	local minutes = String:match("(%d+)m")
	if minutes ~= nil then
		TotalSecondCount = TotalSecondCount + tonumber(minutes) * 60
	end

	local seconds = String:match("(%d+)s")
	if seconds ~= nil then
		TotalSecondCount = TotalSecondCount + tonumber(seconds)
	end

	return TotalSecondCount
end

function SendToBothParticipiants(Player, Destination, Message)
	cRoot:Get():FindAndDoWithPlayer(Destination, function(OtherPlayer)
		OtherPlayer:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
	end)
	Player:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
end

--------------------------------------------------------------------------------------------------------------------------------

-- handles sending teleport requests
function SendRequest(Split, Player)
	if #Split ~= 2 then
		Player:SendMessage("Usage: /tpa [Player]")
		return true
	end

	if Player:GetName() == Split[2] then
		Player:SendMessage("You can't teleport to yourself. The universe will implode!!!")
		return true
	end

	-- check for cooldown
	local NowTime = os.time()
	if NowTime - GetCooldown(Player:GetUUID(), RequestCooldown) < Settings["RequestCooldown"] and not Player:HasPermission("core.tpa.overrideCoolDown") then
		local Message = cCompositeChat()
		Message:AddTextPart("Sending request failed. Please wait for your cooldown to send a request to run out!", "@6")
		Player:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
		return true
	end

	if NowTime - GetCooldown(Player:GetUUID(), SuccessCooldown) < Settings["SuccessCooldown"] and not Player:HasPermission("core.tpa.overrideCoolDown") then
		local Message = cCompositeChat()
		Message:AddTextPart("Sending request failed. Please wait for your cooldown to teleport to run out!")
		Player:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
		return true
	end
	StoreCooldown(Player:GetUUID(), RequestCooldown, NowTime)

	-- check for hiding
	-- send request
	if not cRoot:Get():FindAndDoWithPlayer(Split[2], 
		function (OtherPlayer)
			if OtherPlayer:HasPermission("core.tpa.hide") then
				local Message = cCompositeChat()
				Message:AddTextPart("Player ", "@6")
				Message:AddTextPart(Split[2], "b@6")
				Message:AddTextPart(" was not found, aborting...", "@6")
				Player:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
				--return false
			end
			if (Player:HasPermission("core.tpa.override")) then
				local Message = cCompositeChat()
				Message:AddTextPart("Teleporting...", "@b")
				Player:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
				Player:TeleportToEntity(OtherPlayer)
				--return true
			end
			ID = CreateTransaction(Player, OtherPlayer)

			local Message = cCompositeChat()
			Message:AddTextPart("Sent request to " .. Split[2], "b@6")
			Player:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())

			Message = cCompositeChat()
			Message:AddTextPart("Player " .. Player:GetName() .. " has sent you a teleport request. ", "b@6")
			Message:AddRunCommandPart("Accept", "/tpaccept " .. ID, "u@a")
			Message:AddTextPart(" ")
			Message:AddRunCommandPart("Deny", "/tpdeny " .. ID, "u@c")
			OtherPlayer:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
			return true
		end
	) then
		-- failed
		local Message = cCompositeChat()
		Message:AddTextPart("Player ", "@6")
		Message:AddTextPart(Split[2], "b@6")
		Message:AddTextPart(" was not found, aborting...", "@6")
		Player:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
	end
	return true
end

-- handles accepting teleport requests
function AcceptRequest(Split, Player)
	if #Split ~= 2 then
		Player:SendMessage("Usage: /tpaccept [Player|ID]")
		return true
	end
	local ID = cUUID()

	local RowCount = 0

	local Destination = ""
	local Source = ""
	local Transaction = ""
	local Timestamp = 0

	if not ID:FromString(Split[2]) then
		-- Got Player
		for row in Database.DB:nrows("SELECT * FROM " .. TransactionTableName .. " WHERE Source = '" .. Split[2] .. "' ORDER BY TimeStamp DESC") do
			RowCount = RowCount + 1
			Destination = row["Destination"]
			Source = row["Source"]
			Timestamp = tonumber(row["Timestamp"])
			Transaction =  row["TransactionId"]
			-- Remove the TransactionId
			Database.DB:exec("DELETE FROM " .. TransactionTableName .. " WHERE TransactionId = '" .. Transaction .. "'")
		end
	else
		-- Got UUID
		for row in Database.DB:nrows("SELECT * FROM " .. TransactionTableName .. " WHERE TransactionId = '" .. Split[2] .. "'") do
			RowCount = RowCount + 1
			Destination = row["Destination"]
			Source = row["Source"]
			Timestamp = tonumber(row["Timestamp"])
			-- Remove the TransactionId
			Database.DB:exec("DELETE FROM " .. TransactionTableName .. " WHERE TransactionId = '" .. Split[2] .. "'")
		end
	end

	if RowCount == 0 then
		local Message = cCompositeChat()
		Message:AddTextPart("The request with timed out. Please resend the request!", "@b")
		Player:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
	else
		if Destination ~= Player:GetName() then
			local Message = cCompositeChat()
			Message:AddTextPart("An internal error occurred. Please resend the request!", "@b")
			Player:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
			SendToBothParticipiants(Player, Source, Message)
			return true
		end

		cRoot:Get():FindAndDoWithPlayer(Destination, function(OtherPlayer)
			Player:TeleportToEntity(OtherPlayer)
			StoreCooldown(OtherPlayer:GetUUID(), SuccessCooldown, Settings["SuccessCooldown"])
		end)
		local Message = cCompositeChat()
		Message:AddTextPart("Teleporting...", "@b")
		Player:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
		if Settings["VerboseLogging"] then
			LOG("Teleporting " .. Player:GetName() .. " to " .. OtherPlayer:GetName())
		end
	end

	return true
end

--handles denying teleport requests
function DenyRequest(Split, Player)
	if #Split ~= 2 then
		Player:SendMessage("Usage: /tpaccept [Player|ID]")
		return true
	end

	local ID = cUUID()

	local RowCount = 0

	local Destination = ""
	local Source = ""
	local Transaction = ""
	local Timestamp = 0

	if not ID:FromString(Split[2]) then
		-- Got Player
		for row in Database.DB:nrows("SELECT * FROM " .. TransactionTableName .. " WHERE Source = '" .. Split[2] .. "' ORDER BY TimeStamp DESC") do
			RowCount = RowCount + 1
			Destination = row["Destination"]
			Source = row["Source"]
			Timestamp = tonumber(row["Timestamp"])
			Transaction =  row["TransactionId"]
			-- Remove the TransactionId
			Database.DB:exec("DELETE FROM " .. TransactionTableName .. " WHERE TransactionId = '" .. Transaction .. "'")
		end
	else
		-- Got UUID
		for row in Database.DB:nrows("SELECT * FROM " .. TransactionTableName .. " WHERE TransactionId = '" .. Split[2] .. "'") do
			RowCount = RowCount + 1
			Destination = row["Destination"]
			Source = row["Source"]
			Timestamp = tonumber(row["Timestamp"])
			-- Remove the TransactionId
			Database.DB:exec("DELETE FROM " .. TransactionTableName .. " WHERE TransactionId = '" .. Split[2] .. "'")
		end
	end

	if RowCount == 0 then
		local Message = cCompositeChat()
		Message:AddTextPart("The request with timed out. Please resend the request!", "@b")
		Player:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
	else
		if Destination ~= Player:GetName() then
			local Message = cCompositeChat()
			Message:AddTextPart("An internal error occurred. Please resend the request!", "@b")
			SendToBothParticipiants(Player, Source, Message)
			return true
		end

		local Message = cCompositeChat()
		Message:AddTextPart("Your request to ".. Destination .." was denied", "@b")
		cRoot:Get():FindAndDoWithPlayer(Destination, function(OtherPlayer)
			OtherPlayer:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
		end)
		Message:Clear()
		Message:AddTextPart("Denied request from " .. Source, "@b")
		Player:SendMessageRaw(Message:CreateJsonString(), Message:GetMessageType())
	end

	return true
end

-- handles writing to database
function StoreCooldown(PlayerUUID, CooldownType, Cooldown)
	if CooldownType == RequestCooldown then
		Database.DB:exec("INSERT OR REPLACE INTO " .. CooldownTableName .. " (PlayerUUID, LastRequest) VALUES('" .. PlayerUUID .."', " .. Cooldown .. ")")
	elseif CooldownType == SuccessCooldown then
		Database.DB:exec("INSERT OR REPLACE INTO " .. CooldownTableName .. " (PlayerUUID, LastSuccess) VALUES('" .. PlayerUUID .."', " .. Cooldown .. ")")
	end
end

-- gets last action from database
function GetCooldown(PlayerUUID, CooldownType)
	for rows in Database.DB:nrows("SELECT * FROM ".. CooldownTableName .. " WHERE PlayerUUID = '".. PlayerUUID .. "'") do
		for k, v in pairs(rows) do
			if CooldownType == RequestCooldown and k == "LastRequest" then
				return v
			elseif CooldownType == SuccessCooldown and k == "LastSuccess" then
				return v
			end
		end
	end
	return 0
end

function CreateTransaction(From, To)
	-- create UUID
	local ID = cUUID:GenerateVersion3(From:GetName() .. To:GetName() .. os.os.time() .. math.random(100000)):ToShortString()
	-- store to database
	Database.DB:exec("INSERT OR REPLACE INTO " .. TransactionTableName .. " (TransactionId, Source, Destination, Timestamp) VALUES('" .. ID .. "', '".. From:GetName() .."', '" .. To:GetName() .."', " .. os.time() ..")")

	return ID
end

function CleanupTransaction()
	Database.DB:exec("DELETE FROM " .. TransactionTableName .. " WHERE Timestamp < " .. os.time() - CleanupCooldown)
end
