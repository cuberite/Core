function HandleFlyCommand(Split, Player)
	
	if(Split[2] == nil or Split[2] == Player:GetName()) then
		Player:SetCanFly(not Player:CanFly());
		Player:SendMessageSuccess("Fly mode toggled!")
	elseif (Player:HasPermission("core.fly.others")) then
		
		local function ChangeFly( newPlayer )
			newPlayer:SetCanFly(not newPlayer:CanFly());
			newPlayer:SendMessageSuccess("Fly mode toggled!")
			Player:SendMessageSuccess("Fly mode for player " .. Split[2] ..  " toggled!")
			return true
		end

		if not cRoot:Get():FindAndDoWithPlayer( Split[2], ChangeFly ) then
			SendMessageFailure( Player, "There was no player that matched your query." )
		end
		
	else 
		Player:SendMessageFailure("You need core.fly.others permission to do that!")
	end
	
	return true
	
end
