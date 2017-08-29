function HandlePortalCommand(Split, Player)
	local NumParams = #Split
	if (NumParams == 1) then
		SendMessage(Player, "You are in world " .. Player:GetWorld():GetName())
		return true
	elseif (NumParams ~= 2) then
		SendMessage(Player, "Usage: " .. Split[1] .. " [world]")
		return true
	end
	local World = cRoot:Get():GetWorld(Split[2])
	if (Player:GetWorld():GetName() == Split[2]) then
		SendMessageFailure( Player, "You are in " .. Split[2] .. "!" )
		return true
	elseif( World == nil ) then
		SendMessageFailure( Player, "Could not find world " .. Split[2] .. "!" )
		return true
	elseif( Player:ScheduleMoveToWorld(World, Vector3d(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())) == false ) then
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
		NumWorlds = NumWorlds + 1
		Worlds[NumWorlds] = World:GetName()
	end)

	SendMessage(Player, "There are " .. NumWorlds .. " worlds:")
	SendMessage(Player, table.concat(Worlds, ", "))
	SendMessage(Player, "You are in world " .. Player:GetWorld():GetName())
	return true
end




