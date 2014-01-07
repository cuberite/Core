function HandleRankCommand( Split, Player )

	if Split[2] == nil or Split[3] == nil then
		SendMessage( Player, "Usage: /rank [Player] [Group]" )
		return true
	end

	local GroupsIni = cIniFile()
	GroupsIni:ReadFile("groups.ini")

	if (GroupsIni:FindKey(Split[3]) == cIniFile.noID) then
		SendMessageFailure(Player, "Group does not exist")
		return true
	end

	local UsersIni = cIniFile()
	UsersIni:ReadFile("users.ini")

	UsersIni:DeleteKey(Split[2])
	UsersIni:GetValueSet(Split[2], "Groups", Split[3])
	UsersIni:WriteFile("users.ini")

	local loopPlayers = function( Player )
		if (Player:GetName() == Split[2]) then
			SendMessageSuccess(Player, "You were moved to group " .. Split[3])
			Player:LoadPermissionsFromDisk()
		end
	end

	local loopWorlds = function ( World )
		World:ForEachPlayer( loopPlayers )
	end

	cRoot:Get():ForEachWorld( loopWorlds )

	return true
end

function HandleGroupsCommand( Split, Player )

	local GroupsIni = cIniFile()
	GroupsIni:ReadFile("groups.ini")

	Number = GroupsIni:GetNumKeys() - 1
	Groups = {}
	for i = 0, Number do
		table.insert(Groups, GroupsIni:KeyName(i))
	end

	SendMessage(Player, "Found " .. #Groups .. " groups")
	SendMessage(Player, table.concat(Groups, " "))

	return true
end
