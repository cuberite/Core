function HandleSpawnCommand(Split, Player)
	SpawnX = WorldIni:GetValue("SpawnPosition", "X")
	SpawnY = WorldIni:GetValue("SpawnPosition", "Y")
	SpawnZ = WorldIni:GetValue("SpawnPosition", "Z")

	World = Player:GetWorld()
	SetBackCoordinates(Player)
	Player:TeleportToCoords(SpawnX, SpawnY, SpawnZ)
	SendMessageSuccess( Player, "Returned to world spawn" )
	return true

end

function HandleSetSpawnCommand(Split, Player)
	PlayerX = Player:GetPosX()
	PlayerY = Player:GetPosY()
	PlayerZ = Player:GetPosZ()
	
    WorldIni:DeleteValue("SpawnPosition", "X")
    WorldIni:DeleteValue("SpawnPosition", "Y")
    WorldIni:DeleteValue("SpawnPosition", "Z")
	
    WorldIni:SetValue("SpawnPosition", "X", PlayerX)
    WorldIni:SetValue("SpawnPosition", "Y", PlayerY)
    WorldIni:SetValue("SpawnPosition", "Z", PlayerZ)
    WorldIni:WriteFile()
	
    SendMessageSuccess( Player, "Changed spawn position to " .. PlayerX .. ", " .. PlayerY .. ", " .. PlayerZ )
    return true
end
