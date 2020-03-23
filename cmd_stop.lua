function HandleStopCommand(Split, Player)
	cRoot:Get():BroadcastChat(cChatColor.Red .. "[WARNING] " .. cChatColor.White .. "Server is terminating!")
	cRoot:Get():QueueExecuteConsoleCommand("stop")
	return true
end
