function HandleNumChunksCommand(Split, Player)
	-- List each world's chunk count into a table, sum the total chunk count:
	local Response = {}
	local Total = 0

	local GetWorldChunks = function(World)
		local numchunks = World:GetNumChunks()
		table.insert(Response, World:GetName() .. ": " .. numchunks .. " chunks")
		Total = Total + numchunks
	end

	table.insert(Response, "Number of loaded chunks:")
	cRoot:Get():ForEachWorld(GetWorldChunks)
	table.sort(Response)

	table.insert(Response, "Total: " .. Total .. " chunks")

	-- Return the complete report:
	return true, SendMessage(Player, table.concat(Response, "\n"))
end

function HandleConsoleNumChunks(Split)
	return HandleNumChunksCommand(Split)
end
