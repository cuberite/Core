MobDamages = {}

function HandleDifficultyCommand ( Split, Player )
	if (Split[2] == nil) then
		if (#Split == 1) then
			SendMessage(Player, "Current world difficulty: " .. GetWorldDifficulty(Player:GetWorld()))
			SendMessage(Player, "To change: /difficulty [peaceful/easy/normal/hard]")
		else
			SendMessage( Player, "Usage: /difficulty [peaceful/easy/normal/hard]" )
		end
		return true
	end

	if (Split[2] == "peaceful") or (Split[2] == "0") or (Split[2] == "p") then
		SetWorldDifficulty(Player:GetWorld(), 0)
		SendMessage( Player, "World difficulty set to peaceful" )
	elseif (Split[2] == "easy") or (Split[2] == "1") or (Split[2] == "e") then
		SetWorldDifficulty(Player:GetWorld(), 1)
		SendMessage( Player, "World difficulty set to easy" )
	elseif (Split[2] == "normal") or (Split[2] == "2") or (Split[2] == "n") then
		SetWorldDifficulty(Player:GetWorld(), 2)
		SendMessage( Player, "World difficulty set to normal" )
	elseif (Split[2] == "hard") or (Split[2] == "3") or (Split[2] == "h") then
		SetWorldDifficulty(Player:GetWorld(), 3)
		SendMessage( Player, "World difficulty set to hard" )
	else
		SendMessage( Player, "Usage: /difficulty [peaceful/easy/normal/hard]" )
	end

	return true
end

function InitializeMobDamagesList()
	MobDamages["cSpider"]       = { 2, 2, 3  }
	MobDamages["cEnderman"]     = { 4, 7, 10 }
	MobDamages["cZombie"]       = {          }  -- Handled in OnTakeDamage()
	MobDamages["cSlime"]        = { 4, 4, 4  }
	MobDamages["cCaveSpider"]   = { 2, 2, 3  }
	MobDamages["cZombiePigman"] = { 5, 9, 13 }
	MobDamages["cSkeleton"]     = { 2, 2, 3  }
	MobDamages["cBlaze"]        = { 4, 6, 9  }
	
end

function OnTakeDamage(Receiver, TDI)
	if (TDI.Attacker == nil) then
		return false
	end

	local Attacker = TDI.Attacker
	local WorldDifficulty = GetWorldDifficulty(Attacker:GetWorld())

	if Attacker:IsA("cZombie") then
		if (WorldDifficulty == 1) then
			if (Attacker:GetHealth() >= 16)     then TDI.FinalDamage = 2;
			elseif (Attacker:GetHealth() >= 11) then TDI.FinalDamage = 3;
			elseif (Attacker:GetHealth() >= 6)  then TDI.FinalDamage = 3;
			else TDI.FinalDamage = 4; end
		elseif (WorldDifficulty == 2) then
			if (Attacker:GetHealth() >= 16)     then TDI.FinalDamage = 3;
			elseif (Attacker:GetHealth() >= 11) then TDI.FinalDamage = 4;
			elseif (Attacker:GetHealth() >= 6)  then TDI.FinalDamage = 5;
			else TDI.FinalDamage = 6; end
		elseif (WorldDifficulty == 3) then
			if (Attacker:GetHealth() >= 16)     then TDI.FinalDamage = 4;
			elseif (Attacker:GetHealth() >= 11) then TDI.FinalDamage = 6;
			elseif (Attacker:GetHealth() >= 6)  then TDI.FinalDamage = 7;
			else TDI.FinalDamage = 9; end
		end
		return false
	end

	if (MobDamages[Attacker:GetClass()] ~= nil) then
		TDI.FinalDamage = MobDamages[Attacker:GetClass()][WorldDifficulty]
	end
end

function OnSpawningEntity(World, Entity)
	NonSpawningEntities = { "cZombie", "cZombiePigman", "cSpider", "cCaveSpider", "cEnderman", "cEnderDragon", "cSkeleton", "cGhast", "cCrepper", "cSilverfish", "cBlaze", "cSlime", "cWitch", "cWither", "cSilverfish" }

	for i,line in ipairs(NonSpawningEntities) do
		if (Entity:GetClass() == line) then
			return true
		end
	end

	return false
end
