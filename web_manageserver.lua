function HandleRequest_ManageServer( Request )
	local Content = "" 
	if (Request.PostParams["RestartServer"] ~= nil) then
		cRoot:Get():QueueExecuteConsoleCommand("restart");
	elseif (Request.PostParams["ReloadServer"] ~= nil) then
		cRoot:Get():GetPluginManager():ReloadPlugins();
	elseif (Request.PostParams["StopServer"] ~= nil) then
		cRoot:Get():QueueExecuteConsoleCommand("stop");
	elseif (Request.PostParams["WorldSaveAllChunks"] ~= nil) then
		cRoot:Get():GetWorld(Request.PostParams["WorldSaveAllChunks"]):QueueSaveAllChunks();
	end
	Content = Content .. [[
	<form method="POST">
	<table>
	<th colspan="3">Manage Server</th>
		<tr>
			<td style="text-align:center;"><input type="submit" value="Restart Server" name="RestartServer"></td>
			<td style="text-align:center;"><input type="submit" value="Reload Server" name="ReloadServer"></td>
			<td style="text-align:center;"><input type="submit" value="Stop Server" name="StopServer"></td>
		</tr>
	</th>
	</table>
	<br/>
	<table>
	<th colspan="2">Manage Worlds</th>
	]]
	local LoopWorlds = function( World )
		Content = Content .. [[
		<tr><td><input type="submit" value="]] .. World:GetName() .. [[" name="WorldSaveAllChunks"></td><td> Save all the chunks of world: <strong>]] .. World:GetName() .. [[</strong></td></tr>
		
		]]
	end
	cRoot:Get():ForEachWorld( LoopWorlds )
	Content = Content .. "</th></table>"
	
	return Content
end