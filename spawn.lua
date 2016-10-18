
--- Teleports the specified player to the spawn of the world they're in
local function SendPlayerToWorldSpawn(a_Player)
	-- Get the spawn coords:
	local World = a_Player:GetWorld()
	local WorldIni = cIniFile()
	WorldIni:ReadFile(World:GetIniFileName())
	local SpawnX = WorldIni:GetValueI("SpawnPosition", "X")
	local SpawnY = WorldIni:GetValueI("SpawnPosition", "Y")
	local SpawnZ = WorldIni:GetValueI("SpawnPosition", "Z")

	-- Teleport to spawn (with ChunkStay):
	local PlayerUUID = a_Player:GetUUID()
	World:ChunkStay(
		{{SpawnX / 16, SpawnZ / 16}},
		nil,  -- OnChunkAvailable
		function()  -- OnAllChunksAvailable
			World:DoWithPlayerByUUID(PlayerUUID,
				function(a_CBPlayer)
					a_CBPlayer:TeleportToCoords(SpawnX, SpawnY, SpawnZ)
				end
			)
		end
	)
end





function HandleSpawnCommand(a_Split, a_Player)
	--[[
	Command signatures:
	/spawn  --> returns the player to the world's spawn
	/spawn <playername>  --> returns the specified player to the spawn of the world they're in
	--]]

	if ((#a_Split == 2) and (a_Split[2] ~= a_Player:GetName())) then
		if not(a_Player:HasPermission("core.spawn.others")) then
			SendMessageFailure(a_Player, "You don't have the permission to do that!")
			LOG(string.format(
				"Player \"%s\" tried to send \"%s\" to spawn, for which they don't have the required permission, core.spawn.others",
				a_Player:GetName(), a_Split[2]
			))
			return true
		end

		cRoot:Get():FindAndDoWithPlayer(a_Split[2],
			function(OtherPlayer)
				if (OtherPlayer:GetName() ~= a_Split[2]) then
					SendMessageFailure(a_Player, "Player " .. a_Split[2] .. " not found!" )
					return
				end
				SendMessageSuccess(a_Player, "Returned " .. OtherPlayer:GetName() .. " to world spawn")
				SendPlayerToWorldSpawn(OtherPlayer)
			end
		)
	else
		SendPlayerToWorldSpawn(a_Player)
	end
	return true
end





function HandleSetSpawnCommand(Split, Player)

	local WorldIni = cIniFile()
	WorldIni:ReadFile(Player:GetWorld():GetIniFileName())

	local PlayerX = Player:GetPosX()
	local PlayerY = Player:GetPosY()
	local PlayerZ = Player:GetPosZ()

	WorldIni:DeleteValue("SpawnPosition", "X")
	WorldIni:DeleteValue("SpawnPosition", "Y")
	WorldIni:DeleteValue("SpawnPosition", "Z")

	WorldIni:SetValueI("SpawnPosition", "X", PlayerX)
	WorldIni:SetValueI("SpawnPosition", "Y", PlayerY)
	WorldIni:SetValueI("SpawnPosition", "Z", PlayerZ)
	WorldIni:WriteFile(Player:GetWorld():GetIniFileName())

	SendMessageSuccess(Player, string.format("Changed spawn position to [X:%i Y:%i Z:%i]", PlayerX, PlayerY, PlayerZ))
	return true

end
