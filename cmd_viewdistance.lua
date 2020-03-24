function HandleViewDistanceCommand(Split, Player)
	if not Split[2] then
		SendMessage(Player, "Usage: /viewdistance <".. cClientHandle.MIN_VIEW_DISTANCE .." - ".. cClientHandle.MAX_VIEW_DISTANCE ..">")
	else
		-- Check if the param is a number:
		local ViewDistance = tonumber(Split[2])

		if ViewDistance then
			Player:GetClientHandle():SetViewDistance(ViewDistance)

			SendMessageSuccess(Player, "Your view distance is now " .. Player:GetClientHandle():GetViewDistance())
		else
			SendMessageFailure(Player, "Invalid view distance value \"" .. Split[2] .. "\"")
		end
	end
	return true
end
