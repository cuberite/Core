function HandleTellCommand(Split, Player, OtherPlayer)
   if (Split[2] == nil) or (Split[3] == nil) then
		Player:SendMessage("Usage: /tell [playername] [message]")
	      return true
	end
	
    
    local SendMessage = function(OtherPlayer)
   Sender = Player:GetName()
   Reciever = Split[2]
    if (OtherPlayer:GetName() == Split[2]) then
    Server = cRoot:Get():GetServer()
    
        	FullMsg = ""
		for i,v in ipairs(Split) do
			if(i>2) then
				if(FullMsg == "") then
					FullMsg = v
				else
					FullMsg = FullMsg .. " " .. v
				end	
			end
		end
    Player:SendMessage("To ".. cChatColor.Red ..Reciever..": ".. cChatColor.Green ..FullMsg.."")
    OtherPlayer:SendMessage("from ".. cChatColor.Red ..Sender..": ".. cChatColor.Green ..FullMsg.."")
    else
    Player:SendMessage(cChatColor.Red .. 'Player "' ..Split[2].. '" not found')
		end
end
cRoot:Get():ForEachPlayer(SendMessage)
	return true;
end


