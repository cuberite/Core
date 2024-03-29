function HandleVersionCommand(Split, Player)
	-- Send output to player:
	Response = SendMessage(Player, string.format(
		"This server is running Cuberite %s - %s (%s - %s) with Lua version %s and SQLite version %s.",
		cRoot:GetBuildSeriesName(),
		cRoot:GetBuildID(),
		cRoot:GetBuildCommitID(),
		cRoot:GetBuildDateTime(),
		_VERSION,
		sqlite3.version()
	))
	return true, Response
end
