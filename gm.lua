-- Contains the functions to manage player gamemode from in game commands and console

local GameModeNameTable =
{
	[gmSurvival]  = "survival",
	[gmCreative]  = "creative",
	[gmAdventure] = "adventure",
	[gmSpectator] = "spectator",
}


local function ChangeGameMode( GameMode, PlayerName )

	local GMChanged = false

	-- Search through online players and if one matches
	-- the given PlayerName then change their gamemode
	cRoot:Get():FindAndDoWithPlayer(PlayerName, 
		function(PlayerMatch)
			if string.lower(PlayerMatch:GetName()) == string.lower(PlayerName) then
				PlayerMatch:SetGameMode(GameMode)
				SendMessage(PlayerMatch, "Gamemode set to " .. GameModeNameTable[GameMode] )
				GMChanged = true
			end
			return true
		end
		)

	return GMChanged

end


function HandleChangeGMCommand(Split, Player)
	
	local GameMode = StringToGameMode(Split[2])
	
	if ( GameMode == nil ) then
		SendMessage(Player, "Usage: " .. Split[1] .. " <survival|creative|adventure|spectator> [player] ")
		return true
	end

	local PlayerToChange = Split[3] or Player:GetName()
	
	if ChangeGameMode( GameMode, PlayerToChange ) then
		if (PlayerToChange ~= Player:GetName()) then
			SendMessageSuccess(Player,"Gamemode of " .. PlayerToChange .. " set to " .. GameModeNameTable[GameMode])
		end
		LOG(Player:GetName() .. " set the gamemode of " .. PlayerToChange .. " to " .. GameModeNameTable[GameMode])
	else
		SendMessageFailure(Player, "Player not found")
	end
	
	return true
end


function HandleConsoleGamemode(a_Split)
	-- Check params, translate into gamemode and player name:
	local GameMode = StringToGameMode(a_Split[2])
	local PlayerToChange = a_Split[3]
	
	if ((PlayerToChange == nil) or (GameMode == nil)) then
		return true, "Usage: " .. a_Split[1] .. " <survival|creative|adventure|spectator> <PlayerName> "
	end

	-- Report success or failure:
	if ChangeGameMode( GameMode, PlayerToChange ) then
		LOG("Console set the gamemode of " .. PlayerToChange .. " to " .. GameModeNameTable[GameMode])
	else
		LOG("Player not found")
	end
	
	return true
end


local GameModeTable =
{
	["0"]         = gmSurvival,
	["survival"]  = gmSurvival,
	["s"]         = gmSurvival,
	["1"]         = gmCreative,
	["creative"]  = gmCreative,
	["c"]         = gmCreative,
	["2"]         = gmAdventure,
	["adventure"] = gmAdventure,
	["a"]         = gmAdventure,
	["3"]         = gmSpectator,
	["spectator"] = gmSpectator,
	["sp"]        = gmSpectator,
}

function StringToGameMode(Str)
	local StrLower = string.lower(Str)
	return GameModeTable[StrLower]
end
