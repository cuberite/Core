function OnKilling(Victim, Killer)
	if Victim:IsPlayer() then
		SetBackCoordinates( Victim )
		if Killer == nil then
			if Victim:GetWorld():GetBlock(Victim:GetPosX(), Victim:GetPosY(), Victim:GetPosZ()) == 10 or Victim:GetWorld():GetBlock(Victim:GetPosX(), Victim:GetPosY(), Victim:GetPosZ()) == 11 then
				cRoot:Get():BroadcastChat( cChatColor.Red ..  "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " tried to swim in lava (and failed)" )
				CheckHardcore(Victim)
				return false
			end
			if Victim:IsOnFire() then
				cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was burnt to a cinder" )
				CheckHardcore(Victim)
				return false
			end
		else
			if Killer:IsPlayer() then
				cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was terminated by " .. Killer:GetName() )
				CheckHardcore(Victim)
				return false
			elseif Killer:IsMob() then
				if Killer:IsA("cZombie") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was eaten by a zombie")
				elseif Killer:IsA("cSkeleton") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was shot by a skeleton" )
				elseif Killer:IsA("cCreeper") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was blown up by a creeper")
				elseif Killer:IsA("cSpider") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was ripped apart by a giant spider")
				elseif Killer:IsA("cCaveSpider") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was poisoned by a giant cave spider")
				elseif Killer:IsA("cBlaze") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was flamed by a blaze")
				elseif Killer:IsA("cEnderman") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was " .. cChatColor.Random .. " by an enderman")
				elseif Killer:IsA("cSilverfish") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " encountered an unexpectedly fatal silverfish attack")
				elseif Killer:IsA("cSlime") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was absorbed and digested by a slime")
				elseif Killer:IsA("cWitch") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was enchanted (to death) by a witch")
				elseif Killer:IsA("cZombiepigman") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was slain by a zombie pigman")
				elseif Killer:IsA("cMagmacube") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was incinerated by a magmacube")
				elseif Killer:IsA("cWolf") then
					cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " was savaged by a wolf")
				end
				CheckHardcore(Victim)
				return false
			end
		end
		cRoot:Get():BroadcastChat( cChatColor.Red .. "[FATALITY] " .. cChatColor.White .. Victim:GetName() .. " died of mysterious circumstances")
		CheckHardcore(Victim)
	end
end
