-- Implements give and item commands and console commands


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

local MaxNumberOfItems = 64


--- Takes the given NBT DataTag and converts it to a table
-- 
--  @param DataTag String in the format of a minecraft NBT data tag
--  
--  @return True if successful, and false with an error message if a problem is encountered
--  
local function SplitDataTag( DataTag )

	local table = {}

	-- Modify the vanilla minecraft dataTag format to a lua table format
	DataTag = string.gsub(DataTag,":","=")
	DataTag = string.gsub(DataTag, "%[", "{")
	DataTag = string.gsub(DataTag, "%]", "}")

	-- Load the DataTag string into lua
	local DataTagFunc, err = loadstring( "dt = " .. DataTag )
	if not DataTagFunc then
		return false, err
	end
	setfenv(DataTagFunc, table)
	local Success, errMsg = pcall(DataTagFunc)
	if not Success then
		return false, errMsg
	end

	DataTagTable = table.dt

	return true, nil
end


--- Handles `give` and `item` commands, other then usage strings 
--  which are taken care of in their registered handlers
--  
--  @return False if PlayerName or ItemName are missing, or Amount or DataValue are invalid, true otherwise
--  
local function GiveItemCommand( Split, Player )

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
	local FoundItem = StringToItem( ItemName .. ":" .. DataValue, Item)

	-- StringToItem does not check if item is valid
	if not IsValidItem( Item.m_ItemType ) then
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

			local Message = MessageDataTagFailure .. errMsg or MessageUnknownError
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

	if not GiveItemCommand( Split, Player ) then
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

	if not GiveItemCommand( Split, Player ) then
		local Message = string.format( CommandUsage, Split[1] , ItemCommandUsageTail )
		if Player then
			SendMessage( Player, Message )
		else
			LOG( Message )
		end
	end

	return true

end