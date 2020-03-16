function HandleSaveAllCommand(Split, Player)
	local Response

	cRoot:Get():SaveAllChunks()

	if not Player then
		Response = SendMessage(nil, "Saving all worlds!")
	else
		cRoot:Get():BroadcastChat(cChatColor.Rose .. "[WARNING] " .. cChatColor.White .. "Saving all worlds!")
	end
	return true, Response
end

function HandleConsoleSaveAll(Split)
	return HandleSaveAllCommand(Split)
end
