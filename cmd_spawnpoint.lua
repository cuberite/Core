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
		if Split[5] then
			if not Player then
				X = OtherPlayer:GetPosX()
				Y = OtherPlayer:GetPosY()
				Z = OtherPlayer:GetPosZ()
			end

			X = RelativeCommandCoord(Split[3], X)

			if not X then
				Response = SendMessageFailure(Player, "'" .. Split[3] .. "' is not a valid number")
			end

			Y = RelativeCommandCoord(Split[4], Y)

			if not Y then
				Response = SendMessageFailure(Player, "'" .. Split[4] .. "' is not a valid number")
			end

			Z = RelativeCommandCoord(Split[5], Z)

			if not Z then
				Response = SendMessageFailure(Player, "'" .. Split[5] .. "' is not a valid number")
			end
		end
		
		if Split[6] then
			World = cRoot:Get():GetWorld(Split[6])

			if not World then
				Response = SendMessageFailure(Player, "Invalid world \"" .. Split[6] .. "\"")
			end
		end

		if not Response then
			OtherPlayer:SetRespawnPosition(Vector3i(X, Y, Z), World)

			Response = SendMessageSuccess(Player, "Set the spawn point of player \"" .. OtherPlayer:GetName() .. "\" to (" .. math.floor(X) .. ", " .. math.floor(Y) .. ", " .. math.floor(Z) .. ") in world \"" .. World:GetName() .. "\"")
		end
	end

	if (not Player and not Split[5]) or (Split[3] and not Split[5]) then
		Response = SendMessage(Player, "Usage: " .. Split[1] .. " <player> <x> <y> <z> [world]")
	elseif not Split[2] then
		SetSpawnPoint(Player)
	elseif Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], SetSpawnPoint) then
		Response = SendMessageFailure(Player, "Player \"" .. Split[2] .. "\" not found")
	end
	return true, Response
end

function HandleConsoleSpawnPoint(Split)
	return HandleSpawnPointCommand(Split)
end
