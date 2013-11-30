function HandleDoCommand( Split, Player )

	if #Split < 3 then
		SendMessage( GetTranslation( Player, "do-usage" ) )
		return true
	end

	-- Get the command and arguments.
	local newSplit = table.concat( Split, " ", 3 )


	local FoundPlayerCallback = function( a_Player )
		local pluginManager = cRoot:Get():GetPluginManager()
		if (pluginManager:ExecuteCommand( a_Player, newSplit )) then
			SendMessageSuccess( Player, GetTranslation( Player, "command-executed" ) )
		else
			SendMessageFailure( Player, GetTranslation( Player, "command-execution-fail" ) )
		end
		return true
	end

	if not cRoot:Get():FindAndDoWithPlayer( Split[2], FoundPlayerCallback ) then
		SendMessageFailure( Player, GetTranslation( Player, "no-player-matched-query" ) )
		return true
	end
	
	return true
end

function HandleSudoCommand ( Split, Player )

	if #Split < 3 then
		SendMessage( GetTranslation( Player, "sudo-usage" ) )
		return true
	end

	-- Get the command and arguments.
	local newSplit = table.concat( Split, " ", 3 )

	local FoundPlayerCallback = function( a_Player )
		local pluginManager = cRoot:Get():GetPluginManager()
		if (pluginManager:ForceExecuteCommand( a_Player, newSplit )) then
			SendMessageSuccess( Player, "Command executed!" )
		else
			SendMessageFailure( Player, "Bad command - execution failed" )
		end
		return true
	end

	if not cRoot:Get():FindAndDoWithPlayer( Split[2], FoundPlayerCallback ) then
		SendMessageFailure( Player, "Could not find player" )
		return true
	end
	
	return true
end
