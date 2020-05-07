function HandleDifficultyCommand ( Split, Player )
	if (Split[2] == nil) then
		if (#Split == 1) then
			SendMessage(Player, "Current world difficulty: " .. GetWorldDifficulty(Player:GetWorld()))
			SendMessage(Player, "To change: " .. Split[1] .. " <peaceful|easy|normal|hard>")
		else
			SendMessage( Player, "Usage: " .. Split[1] .. " <peaceful|easy|normal|hard>" )
		end
		return true
	end

	if (Split[2] == "peaceful") or (Split[2] == "0") or (Split[2] == "p") then
		SetWorldDifficulty(Player:GetWorld(), 0)
		SendMessage( Player, "World difficulty set to peaceful" )

		--Remove mobs which are not allowed in peaceful
		Player:GetWorld():ForEachEntity(
			function (a_Entity)
				if not(a_Entity:IsMob()) then
					return
				end
				if (a_Entity:GetMobFamily() == cMonster.mfHostile) then
					a_Entity:Destroy()
				end
			end
		)
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
		SendMessage( Player, "Usage: " .. Split[1] .. " <peaceful|easy|normal|hard>" )
	end

	return true
end
