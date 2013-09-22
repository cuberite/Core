function HandleRankCommand( Split, Player )

	if Split[2] == nil or Split[3] == nil then
		SendMessage( Player, "Usage: /rank [Player] [Group]" )
		return true
	end

	local GroupsIni = cIniFile( "groups.ini" )
	if GroupsIni:ReadFile() == false then
		GroupsIni:WriteFile()
	end

	if GroupsIni:FindKey(Split[3]) == -1 then
		SendMessageFailure( Player, "Group does not exist" )
		return true
	end

	local UsersIni = cIniFile("users.ini")
	if UsersIni:ReadFile() == false then
		UsersIni:WriteFile()
	end

	UsersIni:DeleteKey( Split[2] )
	UsersIni:GetValueSet( Split[2], "Groups", Split[3] )
	UsersIni:WriteFile()

	local loopPlayers = function( Player )
		if Player:GetName() == Split[2] then
			SendMessageSuccess( Player, "You were moved to group " .. Split[3] )
			Player:LoadPermissionsFromDisk()
		end
	end

	local loopWorlds = function ( World )
		World:ForEachPlayer( loopPlayers )
	end

	cRoot:Get():ForEachWorld( loopWorlds )
	SendMessageSuccess( Player, "Player " .. Split[2] .. " Was moved to " .. Split[3] )

	return true

end

function HandleGroupsCommand( Split, Player )

	local GroupsIni = cIniFile( "groups.ini" )
	if GroupsIni:ReadFile() == false then
		GroupsIni:WriteFile()
	end

	Number = GroupsIni:NumKeys() - 1
	Groups = {}
	for i=0, Number do
		table.insert( Groups, GroupsIni:KeyName( i ) )
	end

	SendMessage( Player, "Found " .. #Groups .. " groups" )
	SendMessage( Player, table.concat( Groups, " " ) )

	return true

end
