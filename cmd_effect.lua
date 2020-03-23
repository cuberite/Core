function HandleEffectCommand(Split, Player)
	local Response

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
			Response = SendMessageSuccess(Player, "Successfully added effect to player \"" .. OtherPlayer:GetName() .. "\" for " .. Split[4] .. " seconds")
		end
	end

	local RemoveEffects = function(OtherPlayer)
		OtherPlayer:ClearEntityEffects()

		if Split[2] ~= "@a" then
			Response = SendMessageSuccess(Player, "Successfully removed effects from player \"" .. OtherPlayer:GetName() .. "\"")
		end
	end

	if Split[3] ~= "clear" then
		if not Split[3] then
			Response = SendMessage(Player, "Usage: " .. Split[1] .. " <player> <effect> [seconds] [amplifier] OR " .. Split[1] .. " <player> clear")
		elseif not EffectID or EffectID < 1 or EffectID > 23 then
			Response = SendMessageFailure(Player, "Invalid effect ID \"" .. Split[3] .. "\"")
		elseif not tonumber(Split[4]) then
			Response = SendMessageFailure(Player, "Invalid duration \"" .. Split[4] .. "\"")
		elseif tonumber(Split[4]) < 0 then
			Response = SendMessageFailure(Player, "The duration in seconds must be at least 0")
		elseif tonumber(Split[4]) > 1000000 then
			Response = SendMessageFailure(Player, "The duration in seconds must be at most 1000000")
		elseif not Amplifier then
			Response = SendMessageFailure(Player, "Invalid amplification amount \"" .. Split[5] .. "\"")
		elseif Amplifier < 0 then
			Response = SendMessageFailure(Player, "The amplification amount must be at least 0")
		elseif Amplifier > 255 then
			Response = SendMessageFailure(Player, "The amplification amount must be at most 255")
		elseif Split[2] == "@a" then
			cRoot:Get():ForEachPlayer(ApplyEffect)
			Response = SendMessageSuccess(Player, "Successfully added effect to every player for " .. Split[4] .. " seconds")
		elseif not cRoot:Get():FindAndDoWithPlayer(Split[2], ApplyEffect) then
			Response = SendMessageFailure(Player, "Player \"" .. Split[2] .. "\" not found")
		end

	elseif Split[2] == "@a" then
		cRoot:Get():ForEachPlayer(RemoveEffects)
		Response = SendMessageSuccess(Player, "Successfully removed effects from every player")

	elseif not cRoot:Get():FindAndDoWithPlayer(Split[2], RemoveEffects) then
		Response = SendMessageFailure(Player, "Player \"" .. Split[2] .. "\" not found")
	end
	return true, Response
end

function HandleConsoleEffect(Split)
	return HandleEffectCommand(Split)
end
