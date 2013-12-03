function OnPlayerPlacingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, CursorX, CursorY, CursorZ, BlockType)
	-- Direction is air check
	if (BlockFace == -1) then
		return false
	end

	local PROTECTRADIUS = WorldsSpawnProtect[Player:GetWorld():GetName()];

	if not (Player:HasPermission("core.build")) then
		return true
	else
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

			WarnPlayer(Player)

			return true
		end
	end
	return false
end

function OnPlayerBreakingBlock(Player, BlockX, BlockY, BlockZ, BlockFace, Status, OldBlockType, OldBlockMeta)
	-- dont check if the direction is in the air
	if (BlockFace ~= -1) then

	local PROTECTRADIUS = WorldsSpawnProtect[Player:GetWorld():GetName()];

		if not (Player:HasPermission("core.build")) then
			return true
		else
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
			
				--WriteLog(0, BlockX, BlockY, BlockZ, Player:GetName(), id, meta)
				
				WarnPlayer(Player)

				return true
			end
		end
	end

	return false
end