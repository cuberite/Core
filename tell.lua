function HandleTellCommand(Split, Player)
	if (Split[2] == nil) or (Split[3] == nil) then
		SendMessage( Player, "Usage: /tell <player> <message>")
		return true
	end
	
	local FoundPlayer = false
	
	local SendMessage = function(OtherPlayer)
	
		if (OtherPlayer:GetName() == Split[2]) then
			local newSplit = table.concat( Split, " ", 3 )
    
			SendMessageSuccess( Player, "Message to player " .. Split[2] .. " sent!" )
			OtherPlayer:SendMessagePrivateMsg(newSplit, Player:GetName())
			
			FoundPlayer = true
		end
	end

	cRoot:Get():ForEachPlayer(SendMessage)
	
	if not FoundPlayer then
		SendMessageFailure( Player, 'Player "' ..Split[2].. '" not found')
	end
	
	return true;
end


