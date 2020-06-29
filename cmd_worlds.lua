function HandleWorldsCommand(Split, Player)
	local NumWorlds = 0
	local Worlds = {}
	local Response = {}
	
	local ListWorld = function(World)
		NumWorlds = NumWorlds + 1
		Worlds[NumWorlds] = World:GetName()
	end

	cRoot:Get():ForEachWorld(ListWorld)

	-- Start creating the actual response
	table.insert(Response, SendMessage(Player, "There are " .. NumWorlds .. " worlds:"))
	table.insert(Response, SendMessage(Player, table.concat(Worlds, ", ")))

	if Player then
		SendMessage(Player, "You are in world " .. Player:GetWorld():GetName())
	end

	return true, table.concat(Response, "\n")
end

function HandleConsoleWorlds(Split)
	return HandleWorldsCommand(Split)
end
