local function GetAdminRankName()
	local Ranks = cRankManager:GetAllRanks()
	for _, Rank in ipairs(Ranks) do
		local Permissions = cRankManager:GetRankPermissions(Rank)
		for _, Permission in ipairs(Permissions) do
			if Permission == "*" then
				return Rank
			end
		end
	end
end

function HandleOpCommand(Split, Player)
	local Response

	if not Split[2] then
		Response = SendMessage(Player, "Usage: " .. Split[1] .. " <player>")
	else
		local PlayerName = Split[2]
		local AdminRankName = GetAdminRankName()

		if not AdminRankName then
			Response = SendMessage(Player, "No admin rank found, missing * permission")
		else
			return HandleRankCommand({"rank", PlayerName, AdminRankName}, Player)
		end
	end
	return true, Response
end

function HandleConsoleOp(Split)
	return HandleOpCommand(Split)
end
