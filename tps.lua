TpsCache = {}

function HandleTpsCommand(Split, Player)
	for WorldName, WorldTps in pairs(TpsCache) do
		Player:SendMessageInfo("World '" .. WorldName .. "': " .. GetWorldTPS(WorldName) .. " TPS");
	end

	return true
end

function GetWorldTPS(WorldName)
	local WorldTps = TpsCache[WorldName]
	local Sum = 0

	if (WorldTps == nil) then
		return nil
	end
	for i,Tps in ipairs(WorldTps) do
		Sum = Sum + Tps
	end

	return (Sum / #WorldTps)
end

function OnWorldTick(World, TimeDelta)
	local WorldTps = TpsCache[World:GetName()]
	if (WorldTps == nil) then
		WorldTps = {}
	end

	if (#WorldTps >= 10) then
		table.remove(WorldTps, 1)
	end

	table.insert(WorldTps, 1000 / TimeDelta)
    TpsCache[World:GetName()] = WorldTps
end
