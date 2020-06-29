function HandlePortalCommand(Split, Player)
	local WorldName = Split[2]

	if Split[3] then
		SendMessage(Player, "Usage: " .. Split[1] .. " [world]")
	elseif not WorldName then
		SendMessage(Player, "You are in world \"" .. Player:GetWorld():GetName() .. "\"")
	elseif Player:GetWorld():GetName() == WorldName then
		SendMessageFailure(Player, "You are already in world \"" .. Split[2] .. "\"!")
	elseif not cRoot:Get():GetWorld(WorldName) then
		SendMessageFailure(Player, "Could not find world \"" .. Split[2] .. "\"!")
	elseif not Player:MoveToWorld(WorldName) then
		SendMessageFailure(Player, "Could not move to world \"" .. Split[2] .. "\"!")
	else
		SendMessageSuccess(Player, "Successfully moved to world \"" .. Split[2] .. "\"! :D")
	end

	return true
end
