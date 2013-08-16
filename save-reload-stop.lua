function HandleSaveAllCommand( Split, Player )
	cRoot:Get():ForEachWorld(  
		function (a_World)  
			a_World:BroadcastChat(cChatColor.Rose .. "[WARNING] " .. cChatColor.White .. "Saving all worlds!" );  
		end  
	)
	
	cRoot:Get():SaveAllChunks()
	return true
end

function HandleStopCommand( Split, Player )
	cRoot:Get():ForEachWorld(  
		function (a_World)  
			a_World:BroadcastChat(cChatColor.Red .. "[WARNING] " .. cChatColor.White .. "Server is terminating!" );  
		end  
	)
	
	cRoot:Get():QueueExecuteConsoleCommand("stop")
	return true
end

function HandleReloadCommand( Split, Player )
	cRoot:Get():ForEachWorld(  
		function (a_World)  
			a_World:BroadcastChat(cChatColor.Rose .. "[WARNING] " .. cChatColor.White .. "Reloading all plugins!" );  
		end  
	)
	
	cRoot:Get():GetPluginManager():ReloadPlugins()
	return true
end
