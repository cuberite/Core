function HandlePortalCommand( Split, Player )

	if( #Split ~= 2 ) then
		SendMessage( Player, "Usage: /portal [WorldName]" )
		return true
	end

	if( Player:MoveToWorld(Split[2]) == false ) then
		SendMessageFailure( Player, "Could not move to world " .. Split[2] .. "!" )
		return true
	end

	SendMessageSuccess( Player, "Moved successfully to '" .. Split[2] .. "'! :D" )
	return true

end

function HandleWorldsCommand( Split, Player )

	local Worlds = {}
	cRoot:Get():ForEachWorld(function(World)
		Worlds[#Worlds + 1] = World:GetName()
	end)

	SendMessage( Player, "There are " .. #Worlds .. " worlds" )
	SendMessage( Player, table.concat( Worlds, ", " ) )
	return true

end
