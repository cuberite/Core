function HandleSpawnPointCommand(Split, Player)
	local Response
	
	local X
	local Y
	local Z
	local World = cRoot:Get():GetDefaultWorld()
	
	if Player then
		X = Player:GetPosX()
		Y = Player:GetPosY()
		Z = Player:GetPosZ()
		World = Player:GetWorld()
	end

	local SetSpawnPoint = function(OtherPlayer)
		OtherPlayer:SetBedPos(Vector3i(X, Y, Z), World)

		Response = SendMessageSuccess(Player, "Set the spawn point of player \"" .. OtherPlayer:GetName() .. "\" to (" .. math.floor(X) .. ", " .. math.floor(Y) .. ", " .. math.floor(Z) .. ") in world \"" .. World:GetName() .. "\"")
	end

	if (not Player and not Split[5]) or (Split[3] and not Split[5]) then
		Response = SendMessage(Player, "Usage: " .. Split[1] .. " <player> <x> <y> <z> [world]")
	elseif not Split[2] then
		SetSpawnPoint(Player)
	else
		if Split[3] then
			X = RelativeCommandCoord(Split[3], X)

			if not X then
				return true, SendMessageFailure(Player, "'" .. Split[3] .. "' is not a valid number")
			end
		end
		
		if Split[4] then
			Y = RelativeCommandCoord(Split[4], Y)
			
			if not Y then
				return true, SendMessageFailure(Player, "'" .. Split[4] .. "' is not a valid number")
			end
		end
		
		if Split[5] then
			Z = RelativeCommandCoord(Split[5], Z)

			if not Z then
				return true, SendMessageFailure(Player, "'" .. Split[5] .. "' is not a valid number")
			end
		end
		
		if Split[6] then
			World = cRoot:Get():GetWorld(Split[6])

			if not World then
				return true, SendMessageFailure(Player, "Invalid world \"" .. Split[6] .. "\"")
			end
		end
		
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], SetSpawnPoint) then
			Response = SendMessageFailure(Player, "Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true, Response
end

function HandleConsoleSpawnPoint(Split)
	return HandleSpawnPointCommand(Split)
end
