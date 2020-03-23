function HandleReloadCommand(Split, Player)
	cRoot:Get():BroadcastChat(cChatColor.Rose .. "[WARNING] " .. cChatColor.White .. "Reloading all plugins!")
	cRoot:Get():GetPluginManager():ReloadPlugins()
	return true
end
