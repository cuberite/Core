function HandleDifficultyCommand ( Split, Player )

	if( #Split ~= 2 ) then
		Player:SendMessage( "Usage: /difficulty [peaceful|easy|normal|hard]" )
		return true
	end

	if (Split[2] == "peaceful") or (Split[2] == "0") or (Split[2] == "p") then
            WorldIni:DeleteValue("Difficulty",   "WorldDifficulty")
            WorldIni:SetValue("Difficulty",   "WorldDifficulty",   0)
            WorldIni:WriteFile()
		Player:SendMessage( "World difficulty set to peaceful" )
            return true
	elseif (Split[2] == "easy") or (Split[2] == "1") or (Split[2] == "e") then
            WorldIni:DeleteValue("Difficulty",   "WorldDifficulty")
		WorldIni:SetValue("Difficulty",   "WorldDifficulty",   1)
            WorldIni:WriteFile()
		Player:SendMessage( "World difficulty set to easy" )
            return true
	elseif (Split[2] == "normal") or (Split[2] == "2") or (Split[2] == "n") then
            WorldIni:DeleteValue("Difficulty",   "WorldDifficulty")
		WorldIni:SetValue("Difficulty",   "WorldDifficulty",   2)
            WorldIni:WriteFile()
		Player:SendMessage( "World difficulty set to normal" )
            return true
	elseif (Split[2] == "hard") or (Split[2] == "3") or (Split[2] == "h") then
            WorldIni:DeleteValue("Difficulty",   "WorldDifficulty")
		WorldIni:SetValue("Difficulty",   "WorldDifficulty",   3)
            WorldIni:WriteFile()
		Player:SendMessage( "World difficulty set to hard" )
            return true
      else
		Player:SendMessage( "Usage: /difficulty [peaceful|easy|normal|hard]" )
            return true
	end
end

function OnTakeDamage(Receiver, TDI)
	Attacker = TDI.Attacker
	if Attacker == nil then
		return false
	end
    WorldDifficulty = WorldsWorldDifficulty[Attacker:GetWorld():GetName()]
    if Attacker:IsA("cSpider") then
        if (WorldDifficulty == 1) or (WorldDifficulty == 2) then
            TDI.FinalDamage = 2	
        end
        if (WorldDifficulty == 3) then
            TDI.FinalDamage = 3
        end
    end

    if Attacker:IsA("cEnderman") then
        if (WorldDifficulty == 1) then
            TDI.FinalDamage = 4	
        end
        if (WorldDifficulty == 2) then
            TDI.FinalDamage = 7
        end
        if (WorldDifficulty == 3) then
            TDI.FinalDamage = 10
        end
    end

    if Attacker:IsA("cZombie") then
        if (WorldDifficulty == 1) then
            if (Attacker:GetHealth() >= 16) then
                TDI.FinalDamage = 2
            end
            if (Attacker:GetHealth() < 16) and (Attacker:GetHealth() >= 11) then
                TDI.FinalDamage = 3	
            end      
            if (Attacker:GetHealth() < 11) and (Attacker:GetHealth() >= 6) then
                TDI.FinalDamage = 3	
            end   
            if (Attacker:GetHealth() < 6) then
                TDI.FinalDamage = 4
            end   
        end
        if (WorldDifficulty == 2) then
            if (Attacker:GetHealth() >= 16) then
                TDI.FinalDamage = 3
            end
            if (Attacker:GetHealth() < 16) and (Attacker:GetHealth() >= 11) then
                TDI.FinalDamage = 4
            end      
            if (Attacker:GetHealth() < 11) and (Attacker:GetHealth() >= 6) then
                TDI.FinalDamage = 5
            end   
            if (Attacker:GetHealth() < 6) then
                TDI.FinalDamage = 6
            end   
        end
        if (WorldDifficulty == 3) then
            if (Attacker:GetHealth() >= 16) then
                TDI.FinalDamage = 4
            end
            if (Attacker:GetHealth() < 16) and (Attacker:GetHealth() >= 11) then
                TDI.FinalDamage = 6
            end      
            if (Attacker:GetHealth() < 11) and (Attacker:GetHealth() >= 6) then
                TDI.FinalDamage = 7	
            end   
            if (Attacker:GetHealth() < 6) then
                TDI.FinalDamage = 9
            end          
        end
    end
    if Attacker:IsA("cSlime") then
        TDI.FinalDamage = 4
    end

    if Attacker:IsA("cCavespider") then
        if (WorldDifficulty == 1) or (WorldDifficulty == 2) then
            TDI.FinalDamage = 2	
        end
        if (WorldDifficulty == 3) then
            TDI.FinalDamage = 3
        end
    end
    if Attacker:IsA("cWolf") then
        TDI.FinalDamage = 4
    end

    if Attacker:IsA("cZombiepigman") then
        if (WorldDifficulty == 1) then
            TDI.FinalDamage = 5
        end
        if (WorldDifficulty == 2) then
            TDI.FinalDamage = 9
        end
        if (WorldDifficulty == 2) then
            TDI.FinalDamage = 13
        end
    end

    if Attacker:IsA("cSkeleton") then
        if (WorldDifficulty == 1) then
            TDI.FinalDamage = 2	
        end
        if (WorldDifficulty == 2) then
            TDI.FinalDamage = 2
        end
        if (WorldDifficulty == 2) then
            TDI.FinalDamage = 3
        end
    end
    if Attacker:IsA("cBlaze") then
        if (WorldDifficulty == 1) then
            TDI.FinalDamage = 4
        end
        if (WorldDifficulty == 2) then
            TDI.FinalDamage = 6
        end
        if (WorldDifficulty == 2) then
            TDI.FinalDamage = 9
        end
    end
    if Attacker:IsA("cWitch") then
        TDI.FinalDamage = 4
    end
end

function OnSpawningEntity(World, Entity)
    if (WorldDifficulty == 0) then
        if (Entity:GetClass() == "cZombie") then
            return true
        elseif (Entity:GetClass() == "cSpider") then
            return true
        elseif (Entity:GetClass() == "cCavespider") then
            return true
        elseif (Entity:GetClass() == "cEnderman") then
            return true
        elseif (Entity:GetClass() == "cSkeleton") then
            return true
        elseif (Entity:GetClass() == "cGhast") then
            return true
        elseif (Entity:GetClass() == "cCreeper") then
            return true
        elseif (Entity:GetClass() == "cSilverfish") then
            return true
        elseif (Entity:GetClass() == "cBlaze") then
            return true
        elseif (Entity:GetClass() == "cSlime") then
            return true
        elseif (Entity:GetClass() == "cWitch") then
            return true
        elseif (Entity:GetClass() == "cWolf") then
            return true
        else
            return false
        end
    end
end
        
