function HandleGiveCommand(Split, Player)

	-- Make sure there are a correct number of arguments.
	if #Split ~= 3 and #Split ~= 4 and #Split ~= 5 then
		SendMessage( Player, GetTranslation( Player, "give-usage" ) )
		return true
	end

	-- Get the item from the arguments and check it's valid.
	local Item = cItem()
	if #Split == 5 then
		local FoundItem = StringToItem( Split[3] .. ":" .. Split[5], Item )
	else
		local FoundItem = StringToItem( Split[3], Item )
	end

	if not IsValidItem( Item.m_ItemType ) then  -- StringToItem does not check if item is valid
		FoundItem = false
	end

	if not FoundItem  then
		SendMessageFailure( Player, GetTranslation( Player, "invalid-id" ) )
		return true
	end

	-- Work out how many items the user wants.
	local ItemAmount = 1
	if #Split > 3 then
		ItemAmount = tonumber( Split[4] )
		if ItemAmount == nil or ItemAmount < 1 or ItemAmount > 512 then
			SendMessageFailure( Player, GetTranslation( Player, "invalid-amount" ) )
			return true
		end
	end

	Item.m_ItemCount = ItemAmount

	-- Get the playername from the split.
	local playerName = Split[2]

	local function giveItems( newPlayer )
		local ItemsGiven = newPlayer:GetInventory():AddItem( Item )
		if ItemsGiven == ItemAmount then
			SendMessageSuccess( newPlayer, GetTranslation( Player, "you-were-given" ) .. " " .. Item.m_ItemCount .. " " .. GetTranslation( Player, "of-item" ) .. " " .. Item.m_ItemType .. "." )
			if not newPlayer == Player then
				SendMessageSuccess( Player, GetTranslation( Player, "items-given" ) )
			end
			LOG( GetConsoleTranslation("gave") .. " " .. newPlayer:GetName() .. " " .. Item.m_ItemCount .. " " .. GetConsoleTranslation("of") .. " " .. Item.m_ItemType .. ":" .. Item.m_ItemDamage )
		else
			SendMessageFailure( Player, GetTranslation( Player, "not-enough-space" .. " " .. ItemsGiven )
			LOG( Player:GetName() .. " " .. GetConsoleTranslation("asked-for") .. " " .. Item.m_ItemCount .. GetConsoleTranslation("of") .. Item.m_ItemType .. ":" .. Item.m_ItemDamage .. ", " .. GetConsoleTranslation("could-only-fit") .. ItemsGiven )
		end
		return true
	end

	-- Finally give the items to the player.
	itemStatus = cRoot:Get():FindAndDoWithPlayer( playerName, giveItems )

	-- Check to make sure that giving items was successful.
	if not itemStatus then
		SendMessageFailure( Player, GetTranslation( Player, "no-player-matched-query" ) )
	end

	return true

end
