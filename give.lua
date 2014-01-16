function HandleGiveCommand(Split, Player )

	-- Make sure there are a correct number of arguments.
	if #Split ~= 3 and #Split ~= 4 and #Split ~= 5 and #Split ~= 6 and #Split ~= 7 then
		SendMessage( Player, "Usage: /give <player> <item> [amount] [meta] [custom name] [lore]" )
		SendMessage( Player, "The newline character for lore is \"`\"")
		return true
	end

	-- Get the item from the arguments and check it's valid.
	local FoundItem = nil
	local Item = cItem()
	if #Split == 5 then
		FoundItem = StringToItem( Split[3] .. ":" .. Split[5], Item )
	else
		FoundItem = StringToItem( Split[3], Item )
	end

	if not IsValidItem( Item.m_ItemType ) then  -- StringToItem does not check if item is valid
		FoundItem = false
	end

	if not FoundItem  then
		SendMessageFailure( Player, "Invalid item id or name!" )
		return true
	end

	-- Work out how many items the user wants.
	local ItemAmount = 1
	if #Split > 3 then
		ItemAmount = tonumber( Split[4] )
		if ItemAmount == nil or ItemAmount < 1 or ItemAmount > 512 then
			SendMessageFailure( Player, "Invalid amount!" )
			return true
		end
	end

	Item.m_ItemCount = ItemAmount
	if (Split[6] ~= nil) then
		Item.m_CustomName = tostring(Split[6])
	end
	if (Split[7] ~= nil) then
		Item.m_Lore = tostring(Split[7])
	end

	-- Get the playername from the split.
	local playerName = Split[2]

	local function giveItems( newPlayer )
		local ItemsGiven = newPlayer:GetInventory():AddItem( Item )
		if ItemsGiven == ItemAmount then
			SendMessageSuccess( newPlayer, "You were given " .. Item.m_ItemCount .. " of " .. Item.m_ItemType .. "." )
			if not newPlayer == Player then
				SendMessageSuccess( Player, "Items given!" )
			end
			LOG("Gave " .. newPlayer:GetName() .. " " .. Item.m_ItemCount .. " times " .. Item.m_ItemType .. ":" .. Item.m_ItemDamage )
		else
			SendMessageFailure( Player, "Not enough space in inventory, only gave " .. ItemsGiven )
			LOG( "Player " .. Player:GetName() .. " asked for " .. Item.m_ItemCount .. " times " .. Item.m_ItemType .. ":" .. Item.m_ItemDamage ..", but only could fit " .. ItemsGiven )
		end
		return true
	end

	-- Finally give the items to the player.
	-- Check to make sure that giving items was successful.
	if not cRoot:Get():FindAndDoWithPlayer( playerName, giveItems ) then
		SendMessageFailure( Player, "There was no player that matched your query." )
	end

	return true

end
