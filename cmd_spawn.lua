function HandleSpawnCommand(Split, Player)
	local Response

	local MoveToSpawn = function(OtherPlayer)
		local World = OtherPlayer:GetWorld()
		local SpawnX = World:GetSpawnX()
		local SpawnY = World:GetSpawnY()
		local SpawnZ = World:GetSpawnZ()

		OtherPlayer:TeleportToCoords(SpawnX, SpawnY, SpawnZ)

		if Split[2] then
			Response = SendMessageSuccess(Player, "Successfully returned player \"" .. OtherPlayer:GetName() .. "\" to world spawn")
		else
			Response = SendMessageSuccess(Player, "Successfully moved to world spawn")
		end
	end

	if not Split[2] then
		if not Player then
			Response = SendMessage(nil, "Usage: " .. Split[1] .. " <player>")
		else
			MoveToSpawn(Player)
		end
	elseif not Player or Player:HasPermission("core.spawn.others") then
		if Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], MoveToSpawn) then
			Response = SendMessageFailure(Player, "Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true, Response
end

function HandleConsoleSpawn(Split)
	return HandleSpawnCommand(Split)
end
