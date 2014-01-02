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

	local loopPlayer = function( OtherPlayer )
		if OtherPlayer:GetName() == Split[2] then
			SendMessage( OtherPlayer, Player:GetName() .. " send a teleport request" )
			SendMessageSuccess( Player, "You send a teleport request to " .. OtherPlayer:GetName() )
			Destination[OtherPlayer:GetName()] = Player:GetName()
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
				OtherPlayer:MoveToWorld( Player:GetWorld():GetName() )
			end
			OtherPlayer:TeleportToEntity( Player )
			SendMessage( Player, OtherPlayer:GetName() .. " teleported to you" )
			SendMessageSuccess( OtherPlayer, "You teleported to " .. Player:GetName() )
			Destination[Player:GetName()] = nil
		end
	end

	local loopWorlds = function( World )
		World:ForEachPlayer( loopPlayer )
	end

	cRoot:Get():ForEachWorld( loopWorlds )
	return true

end
