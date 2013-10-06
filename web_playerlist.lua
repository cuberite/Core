function HandleRequest_PlayerList ( Request )

	-- Define the content variable.
	local Content = ""

	-- If a player needed to be kicked, kick them.
	if Request.Params["playerlist-kick"] ~= nil then
		
		local KickPlayerName = Request.Params["playerlist-kick"]
		local FoundPlayerCallback = function( Player )
			if( Player:GetName() == KickPlayerName ) then
				Player:GetClientHandle():Kick("You were kicked from the game!")
				Content = Content .. "<p>" .. KickPlayerName .. " has been kicked from the game!</p>"
			end
		end
	
		if cRoot:Get():FindAndDoWithPlayer( KickPlayerName, FoundPlayerCallback ) == false then
			Content = Content .. "<p>Could not find player " .. KickPlayerName .. " !</p>"
		end
		
	end
	
	-- Count all the players in the root.
	local playerCount = 0
	local playerCountCallback = function ( Player )
		playerCount++
	end
	cRoot:Get():ForEachPlayer( playerCountCallback )
	
	-- Count the numbers of players per-world.
	local perWorldPlayersCallback = function ( World )
	
		-- Name the world:
		Content = Content .. "<h4>" .. World:GetName() .. "</h4>"
	
		-- Create a table for players to sit in.
		Content = Content .. "<table>"
	
		-- Go through the players in the world and add them to the table.
		local PlayerNum = 0
		local AddPlayerToTable = function( Player )
			PlayerNum = PlayerNum + 1
			Content = Content .. "<tr>"
			Content = Content .. "<td style='width: 10px;'>" .. PlayerNum .. ".</td>"
			Content = Content .. "<td>" .. Player:GetName() .. "</td>"
			Content = Content .. "<td><a href='?playerlist-kick=" .. Player:GetName() .. "'>Kick</a></td>"
			Content = Content .. "</tr>"
		end
		World:ForEachPlayer( AddPlayerToTable )
	
		if PlayerNum == 0 then
			Content = Content .. "<tr><td>None</td></tr>"
		end
		
		Content = Content .. "</table>"
		Content = Content .. "<br>"
		
	end
	cRoot:Get():ForEachWorld( perWorldPlayersCallback )
	
	return Content
	
end
