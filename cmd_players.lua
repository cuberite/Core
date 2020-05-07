function HandlePlayersCommand(Split, Player)
	local Response = {}

	local AddToResponse = function(OtherPlayer)
		table.insert(Response, SendMessage(Player, "  " .. OtherPlayer:GetName() .. " @ " ..  OtherPlayer:GetIP()))
	end
	
	local ForEachPlayer = function(World)
		table.insert(Response, SendMessage(Player, "World " .. World:GetName() .. ":"))
		World:ForEachPlayer(AddToResponse)
	end

	cRoot:Get():ForEachWorld(ForEachPlayer)

	return true, table.concat(Response, "\n")
end

function HandleConsolePlayers(Split)
	return HandlePlayersCommand(Split)
end
