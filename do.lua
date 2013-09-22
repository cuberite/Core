function HandleDoCommand( Split, Player )

	if #Split < 3 then
		SendMessage( Player, "Usage: /do <player> <command *without slash*> [arguments]" )
		return true
	end

	-- Get the command and arguments.
	local newSplit = table.concat( Split, " ", 3 )

	local FoundPlayerCallback = function( a_Player )
		local pluginManager = cRoot:Get():GetPluginManager()
		pluginManager:ExecuteCommand( a_Player, newSplit )
		SendMessageSuccess( Player, "Command executed!" )
		return true
	end

	if not cRoot:Get():FindAndDoWithPlayer( Split[2], FoundPlayerCallback ) then
		SendMessageFailure( Player, "Could not find player" )
		return true
	end
	
	return true
end

function HandleSudoCommand ( Split, Player )

if #Split < 3 then
		SendMessage( Player, "Usage: /sudo <player> <command *without slash*> [arguments]" )
		return true
	end

	-- Get the command and arguments.
	local newSplit = table.concat( Split, " ", 3 )

	local FoundPlayerCallback = function( a_Player )
		local pluginManager = cRoot:Get():GetPluginManager()
		pluginManager:ForceExecuteCommand( a_Player, newSplit )
		SendMessageSuccess( Player, "Command executed!" )
		return true
	end

	if not cRoot:Get():FindAndDoWithPlayer( Split[2], FoundPlayerCallback ) then
		SendMessageFailure( Player, "Could not find player" )
		return true
	end
	
	return true
end
