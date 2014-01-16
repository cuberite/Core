function HandleItemCommand( Split, Player )

	if ((#Split ~= 2) and (#Split ~=3) and (#Split ~=4) and (#Split ~=5)) then
		SendMessage( Player, "Usage: /i <item>[:meta] [amount] [custom name] [lore]" )
		SendMessage( Player, "The newline character for lore is \"`\"")
		return true
	end

	local itemSplit = StringSplit(Split[2], ":")
	local newSplit = {}

	newSplit[1] = "/give"
	newSplit[2] = Player:GetName()
	newSplit[3] = itemSplit[1]
	if Split[3] ~= nil then
		newSplit[4] = Split[3]
	else
		newSplit[4] = 1
	end
	if itemSplit[2] ~= nil then
		newSplit[5] = itemSplit[2]
	end
	if Split[4] ~= nil then
		newSplit[6] = Split[4]
	end
	if Split[5] ~= nil then
		newSplit[7] = Split[5]
	end

	HandleGiveCommand( newSplit, Player )
	return true

end
