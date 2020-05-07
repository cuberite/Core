function HandleNumChunksCommand(Split, Player)
	-- List each world's chunk count into a table, sum the total chunk count:
	local Response = {}
	local Total = 0

	local GetWorldChunks = function(World)
		table.insert(Response, SendMessage(Player, World:GetName() .. ": " .. World:GetNumChunks() .. " chunks"))
		Total = Total + World:GetNumChunks()
	end

	cRoot:Get():ForEachWorld(GetWorldChunks)
	table.sort(Response)

	table.insert(Response, SendMessage(Player, "Total: " .. Total .. " chunks"))

	-- Return the complete report:
	return true, table.concat(Response, "\n")
end

function HandleConsoleNumChunks(Split)
	return HandleNumChunksCommand(Split)
end
