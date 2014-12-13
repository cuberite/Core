-- Implements give and item commands and console commands


-- cIniFile object to store the blacklist
local ItemBlackList

-- Table to hold the processed data tag
local DataTagTable = {}

local CommandUsage = "Usage: %s %s"
local ItemCommandUsageTail = "<ItemName> [Amount] [Data] [DataTag]"
local GiveCommandUsageTail = "<PlayerName> " .. ItemCommandUsageTail

local MessagePlayerFailure = "Player not found"
local MessageAmountFailure = "The number you have entered ( %d ) is too big, it must be at most 64"
local MessageItemNameFailure = "There is no such item with name [ %s ]"
local MessageDataTagFailure = "Error processing dataTag: "
local MessageUnknownError = "< Unknown Error >"
local MessageGiveSuccessful = "Given [ %s ] x %d"
local MessageBadAmount = "Amount must be a number"
local MessageBadData = "Data must be a number"

local UnbalancedCurleyBracesFailure = "Missing or unexpected '{' or '}' detected"
local UnbalancedSquareBracketsFailure = "Missing or unexpected '[' or ']' detected"
local StartWithBraceFailure = "DataTag must start with a '{'"
local EndWithBraceFailure = "DataTag must end with a '}'"

local BlackListHeaderComment = "Contains the list of items that cannot be obtained through the give and item commands."
local BlackListHeaderComment2 = "Change values to 0 to remove items from blacklist."
local BlackListFileName = "itemblacklist.ini"
local BlackListFileCreationError = ": Could not create the file: " .. BlackListFileName
local BlackListKeyName = "ItemBlackList"

local MaxNumberOfItems = 64


--- Takes the given NBT DataTag and converts it to a table
-- 
--  @param DataTag String in the format of a minecraft NBT data tag
--  
--  @return True if successful, and false with an error message if a problem is encountered
--  
local function SplitDataTag( DataTag )

	-- Table where the assembled DataTag table is temporarily stored
	local Sandbox = {}

	-- Table where users strings are stored to protect from processing
	local SavedStrings = {}


	--- Save user strings to table to preserve them from additional processing
	--  
	--  @param StringToSave The string to be saved
	--  
	--  @return The string "%s#" where # is the position in the table where the string was saved
	--  
	local function PreserveString( StringToSave )
		table.insert( SavedStrings, StringToSave )
		return "\"%s" .. table.getn( SavedStrings ) .. "\""
	end


	--- Handle the un-escaped strings that Mojang allows into vanilla minecraft data tags
	--  and store them into the SavedStrings table
	--  
	--  @param StringToFix The string to be escaped
	--  
	--  @return The string ":[%s#]" where # is the position in the table where the string was saved
	--  
	local function HandleUnquotedString( StringToFix )
		StringToFix = string.gsub( StringToFix, ",", "\",\"" )
		return ":[" .. PreserveString( StringToFix ) .. "]"
	end


	--- Implements basic sanity checking on the DataTag to generate more meaningful error messages 
	--  
	--  @return True if checks pass, false with an error message otherwise
	--  
	local function VerifyDataTagFormat()

		-- Verify string starts and ends with expected brace
		if string.sub( DataTag, 1, 1 ) ~= "{" then
			return false, StartWithBraceFailure
		end
		if string.sub( DataTag, -1, -1 ) ~= "}" then
			return false, EndWithBraceFailure
		end

		-- Check for balanced curly braces and square brackets
		local FirstLoc, LastLoc = string.find( DataTag, "%b{}" )
		if FirstLoc ~= 1 or LastLoc ~= string.len( DataTag ) then
			return false, UnbalancedCurleyBracesFailure
		end

		local DataTagLen = string.len( DataTag )
		FirstLoc, LastLoc = string.find( DataTag, "%b[]" )

		if FirstLoc and LastLoc then
			local FirstBrace = math.min( string.find( DataTag, "%[" ) or DataTagLen , string.find( DataTag, "%]" ) or DataTagLen )
			local LastBrace = math.max( string.find( DataTag, "%[", LastLoc + 1 ) or 0, string.find( DataTag, "%]", LastLoc + 1 ) or 0)

			-- Loop over the string and make sure we've found all the square bracket pairs
			while LastLoc < LastBrace do
				local _, Tmp = string.find( DataTag, "%b[]", LastLoc + 1 )
				if not Tmp then
					break
				end
				LastLoc = Tmp
				Tmp = math.max( string.find( DataTag, "%[", LastLoc + 1 ) or 0 , string.find( DataTag, "%]", LastLoc + 1 ) or 0 )
				if Tmp and Tmp > LastBrace then
					LastBrace = Tmp
				end
			end

			if ( FirstLoc > FirstBrace ) or ( LastLoc < LastBrace ) then
				return false, UnbalancedSquareBracketsFailure
			end
		end

		return true
	end


	-- This preserves the users names, lore, etc before further processing
	-- We run prior to correcting escaping unquoted strings to allow for any 
	-- combination of symbols in strings that are entered by the user with 
	-- the appropriate leading and trailing quotes in place
	DataTag = string.gsub( DataTag, "\"([^\"]+)\"", PreserveString )


	-- This handles the unquoted strings in-between certain square brackets that vanilla allows
	-- Currently you cannot use the a `]` in those strings,
	-- but everything else is handled
	DataTag = string.gsub( DataTag, ":%s-%[%s-([^{\"%s][^%]]+[^\"])%]", HandleUnquotedString )


	-- Preliminary sanity checks on DataTag
	local Success, errMsg = VerifyDataTagFormat()
	if not Success then
		return false, errMsg
	end


	-- Modify the vanilla minecraft dataTag format to a lua table format
	DataTag = string.gsub( DataTag, ":", "=" )
	DataTag = string.gsub( DataTag, "%[", "{" )
	DataTag = string.gsub( DataTag, "%]", "}" )


	-- Restore lore, names, etc. into the string
	for index, value in ipairs( SavedStrings ) do
		DataTag = string.gsub( DataTag, "%%s" .. index, value )
	end
	


	-- Load the DataTag string into lua
	local DataTagFunc, err = loadstring( "dt = " .. DataTag )
	if not DataTagFunc then
		return false, err
	end
	setfenv(DataTagFunc, Sandbox)
	-- TODO: Investigate switching to xpcall() for better error handling
	local Success, errMsg = pcall(DataTagFunc)
	if not Success then
		return false, errMsg
	end

	DataTagTable = Sandbox.dt

	return true, nil

end


--- Handles `give` and `item` commands, other then usage strings 
--  which are taken care of in their registered handlers
--  
--  @param SafeCommand If true, then don't give unsafe items, if false then don't filter out items
--  
--  @return False if PlayerName or ItemName are missing, or Amount or DataValue are invalid, true otherwise
--  
local function GiveItemCommand( Split, Player, SafeCommand )

	local PlayerName = Split[2]
	local lcPlayerName = string.lower( PlayerName or "" )
	local ItemName = Split[3]
	local Amount = tonumber( Split[4] ) or 1
	local DataValue = tonumber( Split[5] ) or 0
	local Name

	if not PlayerName or not ItemName or Amount < 1 or DataValue < 0 then
		return false
	end

	-- Make sure that if an amount was given, that it was actually a number
	if Split[4] and not tonumber( Split[4] ) then
		if Player then
			SendMessageFailure( Player, MessageBadAmount )
		else
			LOG( MessageBadAmount )
		end
		return true
	end

	-- Make sure that if a data value was given that it was actually a number
	if Split[5] and not tonumber( Split[5] ) then
		if Player then
			SendMessageFailure( Player, MessageBadData )
		else
			LOG( MessageBadData )
		end
		return true
	end

	-- Get the item from the arguments and check it's valid.
	local Item = cItem()
	local FoundItem = StringToItem( ItemName .. ( DataValue ~= 0 and ( ":" .. DataValue ) or "" ), Item)

	-- StringToItem does not check if item is valid
	if not IsValidItem( Item.m_ItemType ) then
		FoundItem = false
	end


	--- Checks to see if the given item is on the blacklist
	--  
	--  @return False if checking is disabled or if the item is not blacklisted, true otherwise
	--  
	local function CheckUnSafeItem()

		-- If using unsafegive or unsafeitem, do not check if item is blacklisted
		if not SafeCommand then
			return false
		end

		-- If the value is on the blacklist and enabled, then don't let the user get the item
		return ItemBlackList:GetValueB( BlackListKeyName, Item.m_ItemType )

	end


	-- Check to see if the item is blacklisted
	if CheckUnSafeItem() then
		FoundItem = false
	end

	-- If the Item doesn't exist, return and inform the caller
	if not FoundItem then
		local Message = string.format( MessageItemNameFailure, ItemName )
		if Player then
			SendMessageFailure( Player, Message )
		else
			LOG( Message )
		end
		return true
	end

	-- Process the DataTag information, if available
	if Split[6] then

		-- The DataTag values may be split across a few different indicies if it contains any spaces,
		-- so concat the remainder of split together for processing
		local Success, errMsg = SplitDataTag( table.concat( Split, " ", 6 ) )

		if not Success then

			local Message = string.format( "%s%s", MessageDataTagFailure, errMsg or MessageUnknownError )
			if Player then
				SendMessageFailure( Player, Message )
			else
				LOG( Message )
			end

			return true
		end

		if DataTagTable.display then

			-- Set a custom name if given
			if DataTagTable.display.Name then
				Name = DataTagTable.display.Name
				Item.m_CustomName = Name
			end

			-- Set Lore if given
			if DataTagTable.display.Lore then
				local Lore = ""
				for _, value in ipairs(DataTagTable.display.Lore) do
					Lore = Lore .. value .. "`"  -- Newline is '`' character rather than "\n"
				end
				Item.m_Lore = Lore
			end
			
		end

		-- Add enchantments, if given and the item is enchantable
		if DataTagTable.ench and cItem:IsEnchantable(Item.m_ItemType, true) then
			for _, enchants in ipairs(DataTagTable.ench) do
				Item.m_Enchantments:SetLevel(enchants.id,enchants.lvl)
			end
		end

	end

	-- Vanilla only allows a player to receive 64 items at a time, respecting that limit here
	if Amount > MaxNumberOfItems then
		local Message = string.format(MessageAmountFailure, Amount)
		if Player then
			SendMessageFailure( Player, Message )
		else
			LOG( Message )
		end
		return true
	end

	--- Callback function used to add items to a players inventory
	--  
	--  @param NewPlayer The cPlayer object representing the player to give the item to
	--  
	--  @return True if successful, false if the player cannot be found
	--  
	local function giveItems( NewPlayer )

		if string.lower( NewPlayer:GetName() ) ~= lcPlayerName then
			return false
		end

		Item:AddCount(Amount - 1)
		NewPlayer:GetInventory():AddItem( Item )

		local MessageHead = string.format( MessageGiveSuccessful, ( Name or ItemToString( Item ) ), Amount )
		local MessageTail = " to " .. NewPlayer:GetName()
		SendMessageSuccess( NewPlayer, MessageHead )
		if Player and NewPlayer:GetName() ~= Player:GetName() then
			SendMessageSuccess( Player, MessageHead .. MessageTail )
		end
		LOG( ( Player and Player:GetName() or "Console" ) .. ": " .. MessageHead .. MessageTail )

		return true
	end

	-- Finally give the items to the player.
	-- Check to make sure that giving items was successful.
	if not cRoot:Get():FindAndDoWithPlayer( PlayerName, giveItems ) then
		if Player then
			SendMessageFailure( Player, MessagePlayerFailure )
		else
			LOG( MessagePlayerFailure )
		end
	end

	return true
end


--- Handle the `give` console and in-game command
--  Usage: give <PlayerName> <item> [amount] [data] [dataTag]
--  
function HandleGiveCommand( Split, Player )

	if not GiveItemCommand( Split, Player, true ) then
		local Message = string.format( CommandUsage, Split[1] , GiveCommandUsageTail )
		if Player then
			SendMessage( Player, Message )
		else
			LOG( Message )
		end
	end

	return true
end


--- Handle the `unsafegive` console and in-game command
--  Usage: unsafegive <PlayerName> <item> [amount] [data] [dataTag]
--  
function HandleUnsafeGiveCommand( Split, Player )

	if not GiveItemCommand( Split, Player, false ) then
		local Message = string.format( CommandUsage, Split[1] , GiveCommandUsageTail )
		if Player then
			SendMessage( Player, Message )
		else
			LOG( Message )
		end
	end

	return true
end


--- Handle the `item` in-game command
--  Usage: item <item> [amount] [data] [dataTag]
--  
function HandleItemCommand( Split, Player )

	table.insert( Split, 2, Player:GetName() )

	if not GiveItemCommand( Split, Player, true ) then
		local Message = string.format( CommandUsage, Split[1] , ItemCommandUsageTail )
		SendMessage( Player, Message )
	end

	return true
end


--- Handle the `unsafeitem` in-game command
--  Usage: unsafeitem <item> [amount] [data] [dataTag]
--  
function HandleUnsafeItemCommand( Split, Player )

	table.insert( Split, 2, Player:GetName() )

	if not GiveItemCommand( Split, Player, false ) then
		local Message = string.format( CommandUsage, Split[1] , ItemCommandUsageTail )
		SendMessage( Player, Message )
	end

	return true
end


--- Initialize the Item Blacklist
--  If the blacklist file cannot be found it attempts to create a new one
--  
function IntializeItemBlacklist( Plugin )

	-- Technical blocks that should NOT be given to players by default
	local DefaultBlackList = 
	{
		[34]  = true,  -- E_BLOCK_PISTON_EXTENSION
		[36]  = true,  -- E_BLOCK_PISTON_MOVED_BLOCK
		[140] = true,  -- E_BLOCK_FLOWER_POT
		[26]  = true,  -- E_BLOCK_BED
		[144] = true,  -- E_BLOCK_HEAD
		[63]  = true,  -- E_BLOCK_SIGN_POST
		[68]  = true,  -- E_BLOCK_WALLSIGN
		[117] = true,  -- E_BLOCK_BREWING_STAND
		[118] = true,  -- E_BLOCK_CAULDRON
		[64]  = true,  -- E_BLOCK_WOODEN_DOOR
		[193] = true,  -- E_ITEM_SPRUCE_DOOR
		[194] = true,  -- E_ITEM_BIRCH_DOOR
		[195] = true,  -- E_ITEM_JUNGLE_DOOR
		[196] = true,  -- E_ITEM_ACACIA_DOOR
		[197] = true,  -- E_ITEM_DARK_OAK_DOOR
		[71]  = true,  -- E_ITEM_IRON_DOOR
		[62]  = true,  -- E_BLOCK_LIT_FURNACE
		[55]  = true,  -- E_BLOCK_REDSTONE_WIRE
		[74]  = true,  -- E_BLOCK_REDSTONE_ORE_GLOWING
		[75]  = true,  -- E_BLOCK_REDSTONE_TORCH_OFF
		[94]  = true,  -- E_BLOCK_REDSTONE_REPEATER_ON
		[124] = true,  -- E_BLOCK_REDSTONE_LAMP_ON
		[150] = true,  -- E_BLOCK_ACTIVE_COMPARATOR
		[178] = true,  -- E_BLOCK_INVERTED_DAYLIGHT_SENSOR
		[9]   = true,  -- E_BLOCK_STATIONARY_WATER
		[8]   = true,  -- E_BLOCK_WATER
		[10]  = true,  -- E_BLOCK_LAVA
		[11]  = true,  -- E_BLOCK_STATIONARY_LAVA
		[60]  = true,  -- E_BLOCK_FARMLAND
		[59]  = true,  -- E_BLOCK_CROPS
		[142] = true,  -- E_BLOCK_POTATOES
		[141] = true,  -- E_BLOCK_CARROTS
		[104] = true,  -- E_BLOCK_PUMPKIN_STEM
		[105] = true,  -- E_BLOCK_MELON_STEM
		[83]  = true,  -- E_BLOCK_REEDS
		[115] = true,  -- E_BLOCK_NETHER_WART
		[92]  = true,  -- E_BLOCK_CAKE
		[119] = true,  -- E_BLOCK_END_PORTAL
		[90]  = true,  -- E_BLOCK_NETHER_PORTAL,
	}

	-- Check for an existing blacklist, this lets the use customize the list to their needs
	ItemBlackList = cIniFile()
	local Success = ItemBlackList:ReadFile( BlackListFileName )
	
	-- If the file doesn't exist, then create one with the default blacklist
	if not Success then
		ItemBlackList:AddKeyName( BlackListKeyName )
		ItemBlackList:AddHeaderComment( BlackListHeaderComment )
		ItemBlackList:AddHeaderComment( BlackListHeaderComment2 )
		
		for ValueName, Value in pairs( DefaultBlackList ) do
			ItemBlackList:AddValueB( BlackListKeyName, ValueName, Value )
		end
		
		Success = ItemBlackList:WriteFile( BlackListFileName )
		if not Success then
			LOG( Plugin:GetName() .. BlackListFileCreationError )
		end
		
	end

	return true
end
