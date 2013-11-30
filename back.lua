function HandleBackCommand( Split, Player )
	if BackCoords[Player:GetName()] == nil then
		SendMessageFailure(Player, GetTranslation( Player, "no-known-last-pos" ) )
		return true
	else
		Player:TeleportToCoords(BackCoords[Player:GetName()].x, BackCoords[Player:GetName()].y, BackCoords[Player:GetName()].z)
		SendMessageSuccess(Player, GetTranslation( Player, "back-teleported" ) )
	end
	return true
end
