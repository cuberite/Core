function HandleBanCommand( Split, Player )

	if( #Split < 2 ) then
		SendMessage( Player, GetTranslation( Player, "ban-usage" ) )
		return true
	end

	local Reason = cChatColor.Red .. "You have been banned."
	if( #Split > 2 ) then
		Reason = table.concat( Split, " ", 3 )
	end

	if KickPlayer(Split[2], Reason) == false then
		BannedPlayersIni:DeleteValue( "Banned", Split[2] )
		BannedPlayersIni:SetValueB( "Banned", Split[2], true )
		BannedPlayersIni:WriteFile()
		SendMessageFailure( Player, GetTranslation( Player, "banplayer-not-found" ) )
	else
		BannedPlayersIni:DeleteValue( "Banned", Split[2] )
		BannedPlayersIni:SetValueB( "Banned", Split[2], true )
		BannedPlayersIni:WriteFile()
		SendMessageSuccess( Player, GetTranslation( Player, "banplayer-success" ) )
	end
	return true

end

function HandleUnbanCommand( Split, Player )

	if( #Split < 2 ) then
		SendMessage( Player, GetTranslation( Player, "unban-usage" ) )
		return true
	end

	if( BannedPlayersIni:GetValueB("Banned", Split[2], false) == false ) then
		SendMessageFailure( Player, GetTranslation( Player, "unban-player-not-banned" ) )
		return true
	end

	BannedPlayersIni:DeleteValue("Banned", Split[2])
	BannedPlayersIni:SetValueB("Banned", Split[2], false)
	BannedPlayersIni:WriteFile()

	LOGINFO( Player:GetName() .. GetConsoleTranslation( "isunbanning" ) .. Split[2] )
	SendMessageSuccess( Player, GetTranslation( Player, "unbanning" ) .. Split[2] )

	return true

end
