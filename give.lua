
local DataTagTable = {}

local UsageHead = "Usage: "
local UsageTail = " <player> <item> [amount] [data] [dataTag]"

local MessagePlayerFailure = "Player not found"
local MessageAmountFailureHead = "The number you have entered ("
local MessageAmountFailureTail = ") is too big, it must be at most 64"
local MessageItemNameFailure = "There is no such item with name [ "
local MessageDataTagFailure = "Error processing dataTag: "
local MessageUnknownError = "< Unknown Error >"

local MaxNumberOfItems = 64

local function SplitDataTag( DataTag )

	local table = {}

	DataTag = string.gsub(DataTag,":","=")
	DataTag = string.gsub(DataTag, "%[", "{")
	DataTag = string.gsub(DataTag, "%]", "}")

	local DataTagFunc, err = loadstring("dt = " .. DataTag)
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


function HandleGiveCommand( Split, Player )

	local PlayerName = Split[2]
	local lcPlayerName = string.lower( PlayerName or "" )
	local ItemName = Split[3]
	local Amount = tonumber( Split[4] ) or 1
	local DataValue = tonumber( Split[5] ) or 0
	local Name
	local Damage  -- Need to find out how this is passed in the DataTag, maybe add a non-standard?

	if not PlayerName or not ItemName or Amount < 1 or DataValue < 0 or DataValue > 15 then
		local Message = UsageHead .. Split[1] .. UsageTail
		if Player then
			SendMessage( Player, Message )
		else
			LOG( Message )
		end
		return true
	end

	-- Get the item from the arguments and check it's valid.
	local Item = cItem()
	local FoundItem = StringToItem( ItemName .. ":" .. DataValue, Item)

	if not IsValidItem( Item.m_ItemType ) then  -- StringToItem does not check if item is valid
		FoundItem = false
	end

	if not FoundItem  then
		local Message = MessageItemNameFailure .. ItemName .. " ]"
		if Player then
			SendMessageFailure( Player, Message )
		else
			LOG( Message )
		end
		return true
	end

	if Split[6] then

		local Success, errMsg = SplitDataTag( Split[6] )

		if not Success then

			local Message = MessageDataTagFailure .. errMsg or MessageUnknownError
			if Player then
				SendMessageFailure( Player, Message )
			else
				LOG( Message )
			end

			return true
		end

		if DataTagTable.display.Name then
			Name = DataTagTable.display.Name
			Item.m_CustomName = Name
		end

		if DataTagTable.display.Lore then
			local Lore = ""
			for _, value in ipairs(DataTagTable.display.Lore) do
				LOG(value)
				Lore = Lore .. value .. "`"  -- Newline is '`' character rather than "\n"
			end
			Item.m_Lore = Lore
		end

		if DataTagTable.ench then
			for _, enchants in ipairs(DataTagTable.ench) do
				Item.m_Enchantments:SetLevel(enchants.id,enchants.lvl)
			end
		end

	end

	if Amount > MaxNumberOfItems then
		local Message = MessageAmountFailureHead .. Amount .. MessageAmountFailureTail
		if Player then
			SendMessageFailure( Player, Message )
		else
			LOG( Message )
		end
		return true
	end

	local function giveItems( NewPlayer )

		if string.lower( NewPlayer:GetName() ) ~= lcPlayerName then
			return false
		end

		Item:AddCount(Amount - 1)
		NewPlayer:GetInventory():AddItem( Item )
		
		local MessageHead = "Given [" .. Name or ItemToString( Item ) .. "] x " .. Amount
		local MessageTail = " to " .. NewPlayer:GetName()
		SendMessageSuccess( NewPlayer, MessageHead )
		if Player then
			SendMessageSuccess( Player, MessageHead .. MessageTail )
		end
		LOG( Player and Player:GetName() or "Console" .. ": " .. MessageHead .. MessageTail )

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


function HandleItemCommand( Split, Player )

	table.insert( Split, 2, Player:GetName() )

	HandleGiveCommand( newSplit, Player )
	return true

end