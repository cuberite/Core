-- Returns the online mode UUID for a player name, if it exists
-- Otherwise returns an offline UUID
function GetPlayerUUID(PlayerName)
	if cRoot:Get():GetServer():ShouldAuthenticate() then
		-- The server is in online-mode, get the UUID from Mojang servers and check for validity:
		return cMojangAPI:GetUUIDFromPlayerName(PlayerName)
	end
	-- The server is in offline mode, generate an offline-mode UUID, no validity check is possible:
	return cClientHandle:GenerateOfflineUUID(PlayerName)
end

-- Returns the world object of the specified world name.
-- If a name isn't provided, the function returns the world of the specified player.
-- If a player isn't specified (e.g. console), the function returns the default world.
function GetWorld(WorldName, Player)
	if not WorldName then
		return Player and Player:GetWorld() or cRoot:Get():GetDefaultWorld()
	end
	return cRoot:Get():GetWorld(WorldName)
end

-- Kicks a player by name, with the specified reason; returns bool whether found
function KickPlayer(PlayerName, Reason)
	if not Reason then
		Reason = "You have been kicked"
	end

	local KickPlayer = function(Player)
		Player:GetClientHandle():Kick(Reason)
	end

	if not cRoot:Get():FindAndDoWithPlayer(PlayerName, KickPlayer) then
		-- Could not find player
		return false
	end

	-- Player has been kicked
	return true
end

function RelativeCommandCoord(Split, Coord)
	if Split then
		if string.sub(Split, 1, 1) == "~" then
			local Relative = tonumber(string.sub(Split, 2, -1))

			if Coord then
				if Relative then
					return Coord + Relative
				end
				return Coord
			end
			return Relative
		end
		return tonumber(Split)
	end
	return Split
end

-- Safer method to find players
function SafeDoWithPlayer(PlayerName, Function)
	local DoWithPlayer = function(World)
		World:DoWithPlayer(PlayerName, Function)
	end
	
	local QueueTask = function(World)
		World:QueueTask(DoWithPlayer)
	end

	cRoot:Get():ForEachWorld(QueueTask);
end

-- If the target is a player, the SendMessage function takes care of sending the message to the player.
-- If the target is a command block or the console, the message is simply returned to the calling function,
-- which delivers it appropriately
function SendMessage(Player, Message)
	if Player then
		Player:SendMessageInfo(Message)
		return nil
	end
	return Message
end

function SendMessageSuccess(Player, Message)
	if Player then
		Player:SendMessageSuccess(Message)
		return nil
	end
	return Message
end

function SendMessageFailure(Player, Message)
	if Player then
		Player:SendMessageFailure(Message)
		return nil
	end
	return Message
end

-- Teleports a_SrcPlayer to a player named a_DstPlayerName; if a_TellDst is true, will send a notice to the destination player
-- TODO: cleanup
function TeleportToPlayer( a_SrcPlayer, a_DstPlayerName, a_TellDst )

	local teleport = function(a_DstPlayerName)

		if a_DstPlayerName == a_SrcPlayer then
			-- Asked to teleport to self?
			SendMessageFailure( a_SrcPlayer, "Y' can't teleport to yerself" )
		else
			-- If destination player is not in the same world, move to the correct world
			if a_SrcPlayer:GetWorld() ~= a_DstPlayerName:GetWorld() then
				a_SrcPlayer:MoveToWorld( a_DstPlayerName:GetWorld(), true, Vector3d( a_DstPlayerName:GetPosX() + 0.5, a_DstPlayerName:GetPosY(), a_DstPlayerName:GetPosZ() + 0.5 ) )
			else
				a_SrcPlayer:TeleportToEntity( a_DstPlayerName )
			end
			SendMessageSuccess( a_SrcPlayer, "You teleported to " .. a_DstPlayerName:GetName() )
			if (a_TellDst) then
				SendMessage( a_DstPlayerName, a_SrcPlayer:GetName().." teleported to you" )
			end
		end

	end

	if not cRoot:Get():FindAndDoWithPlayer( a_DstPlayerName, teleport ) then
		SendMessageFailure( a_SrcPlayer, "Player " .. a_DstPlayerName .. " not found" )
	end

end
