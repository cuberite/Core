local Messages = {
	SpawnBeingSend = "You are being sent to %s's spawn",
	SpawnSentOther = "You are sending %s to %s's spawn",
	PlayerNotFound = "Player %s not found!",
	PermissionMissingSpecific = "You need %s permission to do that!",
	SpawnReached = "Returned to %s's spawn",
	SpawnSet = "Changed spawn position of %s to [X:%i Y:%i Z:%i]",
	SpawnSetFailure = "Couldn't change spawn position of %s to [X:%i Y:%i Z:%i]"
}

local function SendToWorldSpawn( Player )

	local World = Player:GetWorld()
	local PlayerName = Player:GetName()
	local OnAllChunksAvailable = function()
		World:DoWithPlayer(PlayerName, function (a_FreshPlayer)
			a_FreshPlayer:TeleportToCoords(World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ())
		end)
	end -- OnAllChunksAvailable
	World:ChunkStay({{ math.floor(World:GetSpawnX() / 16), math.floor(World:GetSpawnZ() / 16) }}, nil, OnAllChunksAvailable)

end

function HandleSpawnCommand(Split, Player)

	if ( (#Split == 2) and (Split[2] ~= Player:GetName()) ) then
		if Player:HasPermission("core.spawn.others") then
			local IsPlayerFound
			local FoundPlayerCallback = function(OtherPlayer)
				if (OtherPlayer:GetName() == Split[2]) then
					local OtherPlayerName = OtherPlayer:GetName()
					local OtherPlayerWorldName = OtherPlayer:GetWorld():GetName()
					Player:SendMessageSuccess( string.format( Messages.SpawnSentOther, OtherPlayerName, OtherPlayerWorldName ) )
					OtherPlayer:SendMessage( string.format( Messages.SpawnBeingSend, OtherPlayerWorldName ) )
					SendToWorldSpawn( OtherPlayer )
					IsPlayerFound = true
				end
			end
			cRoot:Get():FindAndDoWithPlayer(Split[2], FoundPlayerCallback)
			
			if not(IsPlayerFound) then
				Player:SendMessageFailure( string.format( Messages.PlayerNotFound, Split[2]) )
			end
		else
			Player:SendMessageFailure( string.format( Messages.PermissionMissingSpecific, "core.spawn.others" ) )
		end
	else
		Player:SendMessageInfo( string.format( Messages.SpawnReached, Player:GetWorld():GetName() ) )
		SendToWorldSpawn( Player )
	end
	
	return true

end

function HandleSetSpawnCommand(Split, Player)

	local World = Player:GetWorld()

	if ( World:SetSpawn(math.floor(Player:GetPosX()) + 0.5, math.floor(Player:GetPosY()), math.floor(Player:GetPosZ()) + 0.5) ) then
		Player:SendMessageSuccess( string.format( Messages.SpawnSet, World:GetName(), World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ() ) )
		return true
	else
		Player:SendMessageFailure( string.format( Messages.SpawnSetFailure, World:GetName(), World:GetSpawnX(), World:GetSpawnY(), World:GetSpawnZ() ) )
		return false
	end

end
