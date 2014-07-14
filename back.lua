function HandleBackCommand( Split, Player )
	if BackCoords[Player:GetName()] == nil then
		SendMessageFailure(Player, "No known last position")
		return true
	else
		local OnAllChunksAvaliable = function()
	    		Player:TeleportToCoords(BackCoords[Player:GetName()].x, BackCoords[Player:GetName()].y, BackCoords[Player:GetName()].z)
	    		SendMessageSuccess(Player, "Teleported back to your last known position")
		end
		Player:GetWorld():ChunkStay({{BackCoords[Player:GetName()].x/16, BackCoords[Player:GetName()].z/16}}, OnChunkAvailable, OnAllChunksAvaliable)	
	end
	return true
end
