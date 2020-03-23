function HandleSetSpawnCommand(Split, Player)
	local Response

	local World = Player:GetWorld()

	local PlayerX = Player:GetPosX()
	local PlayerY = Player:GetPosY()
	local PlayerZ = Player:GetPosZ()

	if World:SetSpawn(PlayerX, PlayerY, PlayerZ) then
		Response = SendMessageSuccess(Player, string.format("Successfully changed spawn position to [X:%i Y:%i Z:%i]", PlayerX, PlayerY, PlayerZ))
	else
		Response = SendMessageFailure(Player, "Failed to change spawn position")
	end
	return true, Response
end
