function HandleSpawnCommand(Split, Player)
	
	local WorldIni = cIniFile()
	WorldIni:ReadFile(Player:GetWorld():GetIniFileName())
	
	local SpawnX = WorldIni:GetValue("SpawnPosition", "X")
	local SpawnY = WorldIni:GetValue("SpawnPosition", "Y")
	local SpawnZ = WorldIni:GetValue("SpawnPosition", "Z")

	World = Player:GetWorld()
	SetBackCoordinates(Player)
	Player:TeleportToCoords(SpawnX, SpawnY, SpawnZ)
	SendMessageSuccess( Player, "Returned to world spawn" )
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
	
	WorldIni:SetValue("SpawnPosition", "X", PlayerX)
	WorldIni:SetValue("SpawnPosition", "Y", PlayerY)
	WorldIni:SetValue("SpawnPosition", "Z", PlayerZ)
	WorldIni:WriteFile(Player:GetWorld():GetIniFileName())
	
	SendMessageSuccess( Player, string.format("Changed spawn position to [X:%i Y:%i Z:%i]", PlayerX, PlayerY, PlayerZ) )
	return true
	
end
