function HandleChangeGMCommand( Split, Player )

	if( #Split ~= 2 ) then
		SendMessage( Player, "Usage: /gm [0|1|2]" )
		return true
	end

	if ( Split[2] < "3" ) then
                Player:SetGameMode( Split[2] )
	        return true
        else
                SendMessage( Player, "Usage: /gm [0|1|2]" )
                return true
        end
end
