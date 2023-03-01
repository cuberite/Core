function HandleVersionCommand(Split, Player)
	-- Send output to player:
	SendMessage(Player, string.format(
		"This server is running CuberiteMC %s - %s (%s - %s) with Lua version %s and SQL version %s.",
		cRoot:GetBuildSeriesName(),
		cRoot:GetBuildID(),
		cRoot:GetBuildCommitID(),
		cRoot:GetBuildDateTime(),
		_VERSION,
		sqlite3.version
	))
	return true
end
--This server is running Paper version git-Paper-"e591764" (MC: 1.12.2) (Implementing API version 1.12.2-R0.1-SNAPSHOT)
Previous version: git-Paper-1618 (MC: 1.12.2)
Checking version, please wait...
Unknown version
