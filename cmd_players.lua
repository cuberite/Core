function HandlePlayersCommand(Split, Player)
	local Response = {}

	local AddToResponse = function(OtherPlayer)
		table.insert(Response, "  " .. OtherPlayer:GetName() .. " @ " ..  OtherPlayer:GetIP())
	end
	
	local ForEachPlayer = function(World)
		table.insert(Response, "World " .. World:GetName() .. ":")
		World:ForEachPlayer(AddToResponse)
	end

	table.insert(Response, "Players online:")
	cRoot:Get():ForEachWorld(ForEachPlayer)

	return true, SendMessage(Player, table.concat(Response, "\n"))
end

function HandleConsolePlayers(Split)
	return HandlePlayersCommand(Split)
end
