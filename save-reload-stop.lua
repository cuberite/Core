function HandleSaveAllCommand( Split, Player )

	cRoot:BroadcastChat(cChatColor.Rose .. "[WARNING] " .. cChatColor.White .. "Saving all worlds!" )
	cRoot:Get():SaveAllChunks()
	return true
end

function HandleStopCommand( Split, Player )

	cRoot:BroadcastChat(cChatColor.Red .. "[WARNING] " .. cChatColor.White .. "Server is terminating!" )
	cRoot:Get():QueueExecuteConsoleCommand("stop")
	return true
end

function HandleReloadCommand( Split, Player )

	cRoot:BroadcastChat(cChatColor.Rose .. "[WARNING] " .. cChatColor.White .. "Reloading all plugins!" )
	cRoot:Get():GetPluginManager():ReloadPlugins()
	return true
end
