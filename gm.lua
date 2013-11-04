function HandleChangeGMCommand( Split, Player )
	if( Split[2] == nil ) then
		SendMessage( Player, "Usage: " ..Split[1].. " [survival|creative|adventure] [player] " )
		return true
	end

	if( Split[3] == nil ) then
		if (Split[2] == "survival") or (Split[2] == "0") then
            		Player:SetGameMode(0)
            	elseif (Split[2] == "creative") or (Split[2] == "1") then
			Player:SetGameMode(1)
		elseif (Split[2] == "adventure") or (Split[2] == "2") then
			Player:SetGameMode(2)
		else
			SendMessage( Player, "Usage: " ..Split[1].. " [survival|creative|adventure] [player] " )		
		end
            	return true
	end

	local IsPlayerOnline = false;
	local ChangeGM = function(OtherPlayer)
		if (OtherPlayer:GetName() == Split[3]) then
			IsPlayerOnline = true
            		if (Split[2] == "survival") or (Split[2] == "0") then
				OtherPlayer:SetGameMode(0)
            		elseif (Split[2] == "creative") or (Split[2] == "1") then
				OtherPlayer:SetGameMode(1)
			elseif (Split[2] == "adventure") or (Split[2] == "2") then
				OtherPlayer:SetGameMode(2)
			else
				IsPlayerOnline = invalidgm
            		end
		end
	end

	cRoot:Get():FindAndDoWithPlayer(Split[3], ChangeGM);
	if (IsPlayerOnline) then
		SendMessage( Player, "Changed gamemode for player " .. Split[3] )
		return true
	end
	if (IsPlayerOnline == invalidgm) then
        	SendMessage( Player, "Usage: " ..Split[1].. " [survival|creative|adventure] [player] " )	
		return true
	end
      	if (IsPlayerOnline == false) then
        	SendMessageFailure( Player, "Player not found" )
		return true
	end
end
