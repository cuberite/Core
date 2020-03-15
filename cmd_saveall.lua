function HandleSaveAllCommand(Split, Player)
	if not Player then
		SendMessage(nil, "Saving all worlds!")
	else
		cRoot:Get():BroadcastChat(cChatColor.Rose .. "[WARNING] " .. cChatColor.White .. "Saving all worlds!")
	end

	cRoot:Get():SaveAllChunks()
	return true
end
