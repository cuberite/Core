function OnPlayerPlacingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType)
	-- Don't fail if the block is air.
	if (BlockFace == -1) then
		return false
	end

	local PROTECTRADIUS = WorldsSpawnProtect[Player:GetWorld():GetName()];

	if not (Player:HasPermission("core.build")) then
		SendMessageFailure( Player, "You do not have the 'core.build' permission, thou cannot build" )
		return true
	end
	
	if not (Player:HasPermission("core.spawnprotect.bypass")) and (PROTECTRADIUS ~= 0) then
		local World = Player:GetWorld()
		local xcoord = World:GetSpawnX()
		local ycoord = World:GetSpawnY()
		local zcoord = World:GetSpawnZ()
		if not ((BlockX <= (xcoord + PROTECTRADIUS)) and (BlockX >= (xcoord - PROTECTRADIUS))) then
			return false -- Not in spawn area.
		end
		if not ((BlockY <= (ycoord + PROTECTRADIUS)) and (BlockY >= (ycoord - PROTECTRADIUS))) then 
			return false -- Not in spawn area.
		end
		if not ((BlockZ <= (zcoord + PROTECTRADIUS)) and (BlockZ >= (zcoord - PROTECTRADIUS))) then 
			return false -- Not in spawn area.
		end
			SendMessageFailure( Player, "Go further from spawn to build" )
			return true
	end
	
	return false
end

function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, Status, OldBlockType, OldBlockMeta)
	-- Don't fail if the block is air.
	if BlockFace == -1 then
		return false
	end

	local PROTECTRADIUS = WorldsSpawnProtect[Player:GetWorld():GetName()];

	if not (Player:HasPermission("core.build")) then
		SendMessageFailure( Player, "You do not have the 'core.build' permission, thou cannot build" )
		return true
	end
	
	if not (Player:HasPermission("core.spawnprotect.bypass")) and not (PROTECTRADIUS == 0) then
		local World = Player:GetWorld()
		local xcoord = World:GetSpawnX()
		local ycoord = World:GetSpawnY()
		local zcoord = World:GetSpawnZ()

		if not ((BlockX <= (xcoord + PROTECTRADIUS)) and (BlockX >= (xcoord - PROTECTRADIUS))) then
			return false -- Not in spawn area.
		end
		if not ((BlockY <= (ycoord + PROTECTRADIUS)) and (BlockY >= (ycoord - PROTECTRADIUS))) then 
			return false -- Not in spawn area.
		end
		if not ((BlockZ <= (zcoord + PROTECTRADIUS)) and (BlockZ >= (zcoord - PROTECTRADIUS))) then 
			return false -- Not in spawn area.
		end
	
		SendMessageFailure( Player, "Go further from spawn to build" )

		return true
	end

	return false
end
