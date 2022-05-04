local MOTD = {}

function LoadMOTD()
	-- Check if the file 'motd.txt' exists, if not, create it with default content:
	if not cFile:IsFile("motd.txt") then
		CreateFile = io.open("motd.txt", "w")
		CreateFile:write("&6Welcome to the Cuberite test server!\n&6https://cuberite.org/\n&6Type /help for all commands")
		CreateFile:close()
	end

	for Line in io.lines("motd.txt") do
		table.insert(MOTD, Line)
	end
end

function ShowMOTD(Player)
	for i = 1, #MOTD do
		Player:SendMessage(MOTD[i])
	end
end

function OnPlayerJoined(Player)
	-- Send the MOTD to the player:
	ShowMOTD(Player)
end

function HandleMOTDCommand(Split, Player)
	ShowMOTD(Player)
	return true
end
