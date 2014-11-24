local CHAT_HISTORY = 50
local LastMessageID = 0

local JavaScript = [[
	<script type="text/javascript">
		function createXHR() 
		{
			var request = false;
			try {
				request = new ActiveXObject('Msxml2.XMLHTTP');
			}
			catch (err2) {
				try {
					request = new ActiveXObject('Microsoft.XMLHTTP');
				}
				catch (err3) {
					try {
						request = new XMLHttpRequest();
					}
					catch (err1) {
						request = false;
					}
				}
			}
			return request;
		}
		
		function OpenPage( url, postParams, callback ) 
		{
			var xhr = createXHR();
			xhr.onreadystatechange=function()
			{ 
				if (xhr.readyState == 4)
				{
					callback( xhr )
				} 
			}; 
			xhr.open( (postParams!=null)?"POST":"GET", url , true);
			if( postParams != null )
			{
				xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
			}
			xhr.send(postParams); 
		}

		function LoadPageInto( url, postParams, storage ) 
		{
			OpenPage( url, postParams, function( xhr ) 
			{
				var ScrollBottom = storage.scrollTop + storage.offsetHeight;
				var bAutoScroll = (ScrollBottom >= storage.scrollHeight); // Detect whether we scrolled to the bottom of the div
				
				results = xhr.responseText.split("<<divider>>");
				if( results[2] != LastMessageID ) return; // Check if this message was meant for us
				
				LastMessageID = results[1];
				if( results[0] != "" )
				{
					storage.innerHTML += results[0];
					
					if( bAutoScroll == true )
					{
						storage.scrollTop = storage.scrollHeight;
					}
				}
			} );
			
			
			return false;
		}
		
		function SendChatMessage() 
		{
			var MessageContainer = document.getElementById('ChatMessage');
			if( MessageContainer.value == "" ) return;
			
			var postParams = "ChatMessage=" + MessageContainer.value;
			OpenPage( "/~webadmin/Core/Chat/", postParams, function( xhr ) 
			{
				RefreshChat();
			} );
			MessageContainer.value = "";
		}
		
		function RefreshChat() 
		{
			var postParams = "JustChat=true&LastMessageID=" + LastMessageID;
			LoadPageInto("/~webadmin/Core/Chat/", postParams, document.getElementById('ChatDiv'));
		}
		
		setInterval(RefreshChat, 1000);
		window.onload = RefreshChat;
		
		var LastMessageID = 0;
		
	</script>
]]

local ChatLogMessages = {}
local WebCommands     = {}





function AddMessage( PlayerName, Message )
	LastMessageID = LastMessageID + 1
	table.insert( ChatLogMessages, { timestamp = os.date("[%Y-%m-%d %H:%M:%S]", os.time()), name = PlayerName, message = Message, id = LastMessageID } )
	while( #ChatLogMessages > CHAT_HISTORY ) do
		table.remove( ChatLogMessages, 1 )
	end
end





-- This function allows other plugins to add new commands to the webadmin.
function BindWebCommand(a_CommandString, a_HelpString, a_PluginName, a_CallbackName)
	assert(type(a_CommandString) == 'string')
	assert(type(a_PluginName) == 'string')
	assert(type(a_CallbackName) == 'string')
	
	for Idx, CommandInfo in ipairs(WebCommands) do
		if (CommandInfo.Command == a_CommandString) then
			return false, "That command is already bound to a plugin called \"" .. CommandInfo.PluginName .. "\"."
		end
	end
	
	table.insert(WebCommands, {CommandString = a_CommandString, HelpString = a_HelpString, PluginName = a_PluginName, CallbackName = a_CallbackName})
	return true
end





function HandleWebHelpCommand(a_User, a_Message)
	local Content = "Available Commands:"
	for Idx, CommandInfo in ipairs(WebCommands) do
		if (CommandInfo.HelpString ~= "") then
			Content = Content .. '<br />' .. CommandInfo.CommandString .. '&ensp; - &ensp;' .. CommandInfo.HelpString
		end
	end
	
	return Content
end





function HandleWebReloadCommand(a_User, a_Message)
	cPluginManager:Get():ReloadPlugins()
	return "Reloading Plugins"
end





-- Register some basic commands
BindWebCommand("/help", "Shows a list of all the possible commands", "Core", "HandleWebHelpCommand")
BindWebCommand("/reload", "Reloads all the plugins", "Core", "HandleWebReloadCommand")





function OnChat(a_Player, a_Message)
	AddMessage(a_Player:GetName(), a_Message)
end





--- Replaces http and https links with HTML links
--- It does this by selecting all the characters between "http(s)://" and a space, and puts an anker tag around it.
local function CheckForLinks(a_Message)
	-- Add a space to the whole message, so that the pattern finder can find all the links properly.
	a_Message = a_Message .. ' '
	
	local function PlaceString(a_Url)
		return '<a href="' .. a_Url .. '" target="_blank">' .. a_Url .. '</a>'
	end
	
	return a_Message:gsub('http://.- ', PlaceString):gsub('https://.- ', PlaceString)
end





function HandleRequest_Chat( Request )
	if( Request.PostParams["JustChat"] ~= nil ) then
		local LastIdx = 0
		if( Request.PostParams["LastMessageID"] ~= nil ) then LastIdx = tonumber( Request.PostParams["LastMessageID"] ) end
		local Content = ""
		for key, value in pairs(ChatLogMessages) do 
			if( value.id > LastIdx ) then
				if value.name == nil then
					Content = Content .. value.timestamp .. CheckForLinks(value.message) .. "<br>"
				else
					Content = Content .. value.timestamp .. " [" .. value.name .. "]: " .. CheckForLinks(value.message) .. "<br>"
				end
			end
		end
		Content = Content .. "<<divider>>" .. LastMessageID .. "<<divider>>" .. LastIdx
		return Content
	end
	
	if( Request.PostParams["ChatMessage"] ~= nil ) then
		local Split = StringSplit(Request.PostParams["ChatMessage"])
		local CommandExecuted = false
		for Idx, CommandInfo in ipairs(WebCommands) do
			if (CommandInfo.CommandString == Split[1]) then
				-- cPluginManager:CallPlugin doesn't support calling yourself, so we have to check if the command is from the Core.
				if (CommandInfo.PluginName == "Core") then
					AddMessage(nil, _G[CommandInfo.CallbackName](Request.Username, Request.PostParams["ChatMessage"]))
				else
					AddMessage(nil, cPluginManager:CallPlugin(CommandInfo.PluginName, CommandInfo.CallbackName, Request.Username, Request.PostParams["ChatMessage"]))
				end
				return ""
			end
		end
		
		if (Request.PostParams["ChatMessage"]:sub(1, 1) == "/") then
			AddMessage(nil, 'Unknown Command "' .. Request.PostParams["ChatMessage"] .. '"', "")
			return ""
		end
		
		cRoot:Get():BroadcastChat(cCompositeChat("[Web-" .. Request.Username .. "]: " .. Request.PostParams["ChatMessage"]):UnderlineUrls())
		AddMessage("Web-" .. Request.Username, Request.PostParams["ChatMessage"] )
		return ""
	end

	local Content = JavaScript
	Content = Content .. [[
	<div style="font-family: Courier; border: 1px solid #DDD; padding: 10px; width: 97%; height: 200px; overflow: scroll;" id="ChatDiv"></div>
	<input type="text" id="ChatMessage" onKeyPress="if (event.keyCode == 13) { SendChatMessage(); }"><input type="submit" value="Submit" onClick="SendChatMessage();">
	]]
	return Content
end
