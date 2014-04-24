function HandleEnchantCommand( Split, Player )
	
	if #Split ~= 3 then
		SendMessage( Player, "Usage: '/enchant [Enchantment] [Level]'" )
		return true
	end
	
	local Item = Player:GetEquippedItem()
	if Item:IsEmpty() then
		SendMessageFailure(Player, "You haven't a item in the hand!")
		return true
	end
	
	local Enchantment = cEnchantments:StringToEnchantmentID(Split[2])
	local Level = tonumber(Split[3])
	
	if Enchantment == -1 then
		SendMessageFailure(Player, "Enchantment can't be found!")
		return true
	end
	
	if Level == nil then
		SendMessageFailure(Player, "Level isn't a number!")
		return true
	end
	
	Item.m_Enchantments:SetLevel(Enchantment, Level)
	
	local Inventory = Player:GetInventory()
	local SlotNumber = Inventory:GetEquippedSlotNum()
	Inventory:SetHotbarSlot(SlotNumber, Item)
	
	SendMessageSuccess(Player, "Item successfully enchanted")
	
	return true
	
end
