-- Implements the OnKilling hook handler that effectively implements the hardcore mode of the server

-- If the server is in hardcore mode, bans the killed player
function OnKilling(Victim, Killer)
	if (Victim:IsPlayer()) then
		if (cRoot:Get():GetServer():IsHardcore()) then
			local Reason = "Killed in hardcore mode"

			AddPlayerToBanlist(Victim:GetName(), Reason, "Server-Core")
			KickPlayer(Victim:GetName(), Reason)
		end
	end
end
