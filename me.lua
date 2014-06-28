function HandleMeCommand( Split, Player )

	if not Split[2] then
		SendMessage( Player, "Usage: /me <action>" )
		return true
	else
		table.remove( Split, 1 )
		cRoot:Get():BroadcastChat( "* " .. Player:GetName() .. " " .. table.concat( Split , " " ) )
		return true
	end

end
