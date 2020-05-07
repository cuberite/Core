function HandleUnloadChunksCommand(Split, Player)
	local UnloadChunks = function(World)
		World:QueueUnloadUnusedChunks()
	end

	cRoot:Get():ForEachWorld(UnloadChunks)
	return true, SendMessage(Player, "Successfully unloaded unused chunks")
end

function HandleConsoleUnloadChunks(Split)
	return HandleUnloadChunksCommand(Split)
end
