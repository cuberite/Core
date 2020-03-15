function HandleEffectCommand(Split, Player)
	if not Split[4] then
		Split[4] = 30
	end

	if not Split[5] then
		Split[5] = 0
	end

	local EffectID = tonumber(Split[3])
	local Amplifier = tonumber(Split[5])

	local ApplyEffect = function(OtherPlayer)
		local Seconds = (tonumber(Split[4]) * 20)

		OtherPlayer:AddEntityEffect(EffectID, Seconds, Amplifier)

		if Split[2] ~= "@a" then
			SendMessageSuccess(Player, "Successfully added effect to player \"" .. OtherPlayer:GetName() .. "\" for " .. Split[4] .. " seconds")
		end
	end

	local RemoveEffects = function(OtherPlayer)
		OtherPlayer:ClearEntityEffects()

		if Split[2] ~= "@a" then
			SendMessageSuccess(Player, "Successfully removed effects from player \"" .. OtherPlayer:GetName() .. "\"")
		end
	end

	if Split[3] ~= "clear" then
		if not Split[3] then
			SendMessage(Player, "Usage: " .. Split[1] .. " <player> <effect> [seconds] [amplifier] OR " .. Split[1] .. " <player> clear")
		elseif not EffectID or EffectID < 1 or EffectID > 23 then
			SendMessageFailure(Player, "Invalid effect ID \"" .. Split[3] .. "\"")
		elseif not tonumber(Split[4]) then
			SendMessageFailure(Player, "Invalid duration \"" .. Split[4] .. "\"")
		elseif tonumber(Split[4]) < 0 then
			SendMessageFailure(Player, "The duration in seconds must be at least 0")
		elseif tonumber(Split[4]) > 1000000 then
			SendMessageFailure(Player, "The duration in seconds must be at most 1000000")
		elseif not Amplifier then
			SendMessageFailure(Player, "Invalid amplification amount \"" .. Split[5] .. "\"")
		elseif Amplifier < 0 then
			SendMessageFailure(Player, "The amplification amount must be at least 0")
		elseif (Amplifier > 24 and EffectID == 19) or (Amplifier > 24 and EffectID == 20) then
			SendMessageFailure(Player, "The amplification amount must be at most 24")
		elseif Amplifier > 49 and EffectID == 10 then
			SendMessageFailure(Player, "The amplification amount must be at most 49")
		elseif Amplifier > 255 then
			SendMessageFailure(Player, "The amplification amount must be at most 255")
		elseif Split[2] == "@a" then
			cRoot:Get():ForEachPlayer(ApplyEffect)
			SendMessageSuccess(Player, "Successfully added effect to every player for " .. Split[4] .. " seconds")
		elseif not cRoot:Get():FindAndDoWithPlayer(Split[2], ApplyEffect) then
			SendMessageFailure(Player, "Player \"" .. Split[2] .. "\" not found")
		end

	elseif Split[2] == "@a" then
		cRoot:Get():ForEachPlayer(RemoveEffects)
		SendMessageSuccess(Player, "Successfully removed effects from every player")

	elseif not cRoot:Get():FindAndDoWithPlayer(Split[2], RemoveEffects) then
		SendMessageFailure(Player, "Player \"" .. Split[2] .. "\" not found")
	end
	return true
end
