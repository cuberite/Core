function HandlePortalCommand(Split, Player)
	local NumParams = #Split
	if (NumParams == 1) then
		SendMessage(Player, "You are in world " .. Player:GetWorld():GetName())
		return true
	elseif (NumParams ~= 2) then
		SendMessage(Player, "Usage: /portal [WorldName]")
		return true
	end

	if( Player:MoveToWorld(Split[2]) == false ) then
		SendMessageFailure( Player, "Could not move to world " .. Split[2] .. "!" )
		return true
	end

	SendMessageSuccess( Player, "Moved successfully to '" .. Split[2] .. "'! :D" )
	return true
end





function HandleWorldsCommand(Split, Player)
	local NumWorlds = 0
	local Worlds = {}
	cRoot:Get():ForEachWorld(function(World)
		table.insert(Worlds, World:GetName())
	end)

	SendMessage(Player, "There are " .. NumWorlds .. " worlds:")
	SendMessage(Player, table.concat(Worlds, ", "))
	SendMessage(Player, "You are in world " .. Player:GetWorld():GetName())
	return true
end




