function HandleOpCommand( Split, Player )
  local loopPlayers = function( Player )
		if Player:GetName() == Split[2] then
		    if (Player:IsInGroup("Admins")) then
		        return false
		    else
		        Player:AddToGroup("Admins")
			    Player:SendMessage( cChatColor.Green .. "You are admin now!" )
			    Player:LoadPermissionsFromDisk()
			end
		end
	end
	local loopWorlds = function ( World )
		World:ForEachPlayer( loopPlayers )
	end
    if (Split[2] == nil) then
        Player:SendMessage("Usage: /op <player")
        return true
    end
    if (Split[2] ~= nil) then
        cRoot:Get():ForEachWorld( loopWorlds )
        Player:SendMessage(cChatColor.Green .. "Player " .. Split[2] .. " is now admin!")
        return true
    end
end
    
        
 
