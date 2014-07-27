TpsCache = {}

function HandleTpsCommand(Split, Player)
	local ForEachWorld = function(World)
		if (TpsCache[World:GetName()] ~= nil) then
			Player:SendMessageInfo("World '" .. World:GetName() .. "': " .. TpsCache[World:GetName()] .. " TPS");
		end
	end
	cRoot:Get():ForEachWorld(ForEachWorld)
	
	return true
end

function OnWorldTick(World, TimeDelta)
    TpsCache[World:GetName()] = 1000 / TimeDelta
end
