function HandleTPCommand(a_Split, a_Player)

	if #a_Split == 2 or #a_Split == 3 then

		-- Teleport to player specified in a_Split[2], tell them unless a_Split[3] equals "-h":
		TeleportToPlayer( a_Player, a_Split[2], (a_Split[3] ~= "-h") )
		return true

	elseif #a_Split == 4 then

		-- Teleport to XYZ coords specified in a_Split[2, 3, 4]:
		SetBackCoordinates(a_Player)
		
		-- For relative coordinates
		local Function;
		local X = a_Split[2];
		Function = loadstring(a_Split[2]:gsub("~", "return " .. a_Player:GetPosX() .. "+0"));
		if Function then
			X = Function();
		end
		local Y = a_Split[3];
		Function = loadstring(a_Split[3]:gsub("~", "return " .. a_Player:GetPosY() .. "+0"));
		if Function then
			Y = Function();
		end
		local Z = a_Split[4];
		Function = loadstring(a_Split[4]:gsub("~", "return " .. a_Player:GetPosZ() .. "+0"));
		if Function then
			Z = Function();
		end
		
		a_Player:TeleportToCoords( X, Y, Z )
		SendMessageSuccess( a_Player, "You teleported to [X:" .. X .. " Y:" .. Y .. " Z:" .. Z .. "]" )
		return true

	else
		SendMessage( a_Player, "Usage: /tp [PlayerName] (-h) or /tp [X Y Z]" )
		return true
	end

end

function HandleTPACommand( Split, Player )

	if Split[2] == nil then
		SendMessage( Player, "Usage: /tpa [Player]" )
		return true
	end
	
	if Split[2] == Player:GetName() then
		SendMessage( Player, "You can't teleport to yourself!" )
		return true
	end

	local loopPlayer = function( OtherPlayer )
		if OtherPlayer:GetName() == Split[2] then
			SendMessage(OtherPlayer, Player:GetName() .. cChatColor.Plain .. " has requested you to teleport to them" )
			OtherPlayer:SendMessage("To teleport, type " .. cChatColor.LightGreen .. "/tpaccept" )
			OtherPlayer:SendMessage("To deny this request, type " .. cChatColor.Rose .. "/tpdeny" )
			SendMessageSuccess( Player, "Request sent to " .. OtherPlayer:GetName() )
			Destination[OtherPlayer:GetName()] = Player:GetName()
			TeleportRequestType[OtherPlayer:GetName()] = 1
		end
	end

	local loopWorlds = function( World )
		World:ForEachPlayer( loopPlayer )
	end

	cRoot:Get():ForEachWorld( loopWorlds )
	return true

end


function HandleTPAHereCommand( Split, Player )

	if Split[2] == nil then
		SendMessage( Player, "Usage: /tpahere [Player]" )
		return true
	end
	
	if Split[2] == Player:GetName() then
		SendMessage( Player, "You can't teleport to yourself!" )
		return true
	end

	local loopPlayer = function( OtherPlayer )
		if OtherPlayer:GetName() == Split[2] then
			SendMessage(OtherPlayer, Player:GetName() .. cChatColor.Plain .. " has requested you to teleport to them" )
			OtherPlayer:SendMessage("To teleport, type " .. cChatColor.LightGreen .. "/tpaccept" )
			OtherPlayer:SendMessage("To deny this request, type " .. cChatColor.Rose .. "/tpdeny" )
			SendMessageSuccess( Player, "Request sent to " .. OtherPlayer:GetName() )
			Destination[OtherPlayer:GetName()] = Player:GetName()
			TeleportRequestType[OtherPlayer:GetName()] = 2
		end
	end

	local loopWorlds = function( World )
		World:ForEachPlayer( loopPlayer )
	end

	cRoot:Get():ForEachWorld( loopWorlds )
	return true

end

function HandleTPAcceptCommand( Split, Player )

	if Destination[Player:GetName()] == nil then
		SendMessageFailure( Player, "Nobody has send you a teleport request" )
		return true
	end

	local loopPlayer = function( OtherPlayer )
		if Destination[Player:GetName()] == OtherPlayer:GetName() then
			if OtherPlayer:GetWorld():GetName() ~= Player:GetWorld():GetName() then
				if TeleportRequestType[OtherPlayer:GetName()] == 1 then
					OtherPlayer:MoveToWorld( Player:GetWorld():GetName() )
				elseif TeleportRequestType[OtherPlayer:GetName()] == 2 then
					Player:MoveToWorld( OtherPlayer:GetWorld():GetName() )
				end
			end
			
			if TeleportRequestType[Player:GetName()] == 1 then
				OtherPlayer:TeleportToEntity( Player )
				SendMessageSuccess( Player, OtherPlayer:GetName() .. " teleported to you" )
				SendMessageSuccess( OtherPlayer, "You teleported to " .. Player:GetName() )
			elseif TeleportRequestType[Player:GetName()] == 2 then
				Player:TeleportToEntity( OtherPlayer )
				SendMessageSuccess( OtherPlayer, Player:GetName() .. " teleported to you" )
				SendMessageSuccess( Player, "You teleported to " .. OtherPlayer:GetName() )
			end
			
			Destination[Player:GetName()] = nil
			TeleportRequestType[Player:GetName()] = nil
		end
	end

	local loopWorlds = function( World )
		World:ForEachPlayer( loopPlayer )
	end

	cRoot:Get():ForEachWorld( loopWorlds )
	return true

end

function HandleTPDenyCommand( Split, Player )

	if Destination[Player:GetName()] == nil then
		SendMessageFailure( Player, "Nobody has send you a teleport request" )
		return true
	end

	local loopPlayer = function( OtherPlayer )
		if Destination[Player:GetName()] == OtherPlayer:GetName() then
			SendMessageSuccess( Player,"Request denied." )
			SendMessageFailure( OtherPlayer, Player:GetName() .. " has denied your request" )
			Destination[Player:GetName()] = nil
			TeleportRequestType[Player:GetName()] = nil
		end
	end

	local loopWorlds = function( World )
		World:ForEachPlayer( loopPlayer )
	end

	cRoot:Get():ForEachWorld( loopWorlds )
	return true

end
