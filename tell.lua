function HandleTellCommand(Split, Player, OtherPlayer)
	if (Split[2] == nil) or (Split[3] == nil) then
		SendMessage( Player, "Usage: /tell <player> <message>")
		return true
	end
	
	local SendMessage = function(OtherPlayer)
		
		Sender = Player:GetName()
		Reciever = Split[2]
	
		if (OtherPlayer:GetName() == Split[2]) then
			local newSplit = table.concat( Split, " ", 3 )
    
			SendMessageSuccess( Player, "Message to player " .. Reciever .. " sent!" )
			
			-- Conforms to http://forum.mc-server.org/showthread.php?tid=1212
			OtherPlayer:SendMessage(cChatColor.LightBlue .. "[MSG: " .. Sender .. "] " .. cChatColor.White .. newSplit )
		else
			SendMessageFailure( Player, 'Player "' ..Split[2].. '" not found')
		end
	end

	cRoot:Get():ForEachPlayer(SendMessage)
	return true;
end


