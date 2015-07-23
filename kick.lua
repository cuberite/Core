function HandleKickCommand( Split, Player )

	if( #Split < 2 ) then
		SendMessage( Player, "Usage: /kick [Player] <Reason>" )
		return true
	end

	local Reason = cChatColor.Red .. "You have been kicked."
	if ( #Split > 2 ) then
		Reason = table.concat( Split, " ", 3 )
	end
	local IsPlayerKicked = false
	local Kick = function(OtherPlayer)
		IsPlayerKicked = true
		KickPlayer(Split[2], Reason)
	end

	cRoot:Get():FindAndDoWithPlayer(Split[2], Kick)
	if (IsPlayerKicked) then
		SendMessage( Player, "Kicked " ..Split[2] )
		return true
	end
	if (IsPlayerKicked == false) then
		SendMessageFailure( Player, "Player not found" )        
		return true
	end
end
