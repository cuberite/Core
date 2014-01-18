
-- web_plugins.lua

-- Implements the Plugins web tab used to manage plugins on the server

--[[
General info: The web handler loads the settings.ini file in its start, and reads the list of enabled
plugins out of it. Then it processes any changes requested by the user through the buttons; it carries out
those changes on the list of enabled plugins itself. Then it saves that list back to the settings.ini. The
changes aren't applied until the user expliticly clicks on "reload", since some changes require more than
single reloads of the page (such as enabling a plugin and moving it into place using the up / down buttons).
--]]





-- Stores whether the plugin list has changed and thus the server needs to reload plugins
-- Has to be defined outside so that it keeps its value across multiple calls to the handler.
local g_NeedsReload = false





--- Returns an array of plugin names that are enabled, in their load order
local function LoadEnabledPlugins(SettingsIni)
	local res = {};
	local IniKeyPlugins = SettingsIni:FindKey("Plugins")
	if (IniKeyPlugins == cIniFile.noID) then
		-- No [Plugins] key in the INI file
		return {}
	end
	
	-- Scan each value, remember each that is named "plugin"
	for idx = 0, SettingsIni:GetNumValues(IniKeyPlugins) - 1 do
		if (string.lower(SettingsIni:GetValueName(IniKeyPlugins, idx)) == "plugin") then
			table.insert(res, SettingsIni:GetValue(IniKeyPlugins, idx))
		end
	end
	return res
end





--- Saves the list of enabled plugins into the ini file
-- Keeps all the other values in the ini file intact
local function SaveEnabledPlugins(SettingsIni, EnabledPlugins)
	-- First remove all values named "plugin":
	local IniKeyPlugins = SettingsIni:FindKey("Plugins")
	if (IniKeyPlugins ~= cIniFile.noID) then
		for idx = SettingsIni:GetNumValues(IniKeyPlugins) - 1, 0, -1 do
			if (string.lower(SettingsIni:GetValueName(IniKeyPlugins, idx)) == "plugin") then
				SettingsIni:DeleteValueByID(IniKeyPlugins, idx)
			end
		end
	end
	
	-- Now add back the entire list of enabled plugins, in our order:
	for idx, name in ipairs(EnabledPlugins) do
		SettingsIni:AddValue("Plugins", "Plugin", name)
	end
	
	-- Save to file:
	SettingsIni:WriteFile("settings.ini")
	
	-- Mark the settings as changed:
	g_NeedsReload = true
end





--- Builds an HTML table containing the list of plugins
-- First the loaded plugins are listed in their load order
-- Then any plugins that are enabled but failed to load are listed alphabetically
-- Finally an alpha-sorted list of the disabled plugins
local function ListCurrentPlugins(EnabledPlugins)
	-- Retrieve a map of all known plugins:
	local PM = cPluginManager:Get()
	PM:FindPlugins()
	local PluginMap = PM:GetAllPlugins()
	
	-- Separate all enabled but not loaded plugins into ErrorPlugins array
	-- Put all successfully loaded plugins to LoadedPlugins array
	-- Also remove the enabled plugins from PluginList
	local ErrorPlugins = {}
	local LoadedPlugins = {}
	for idx, name in ipairs(EnabledPlugins) do
		if (PluginMap[name] == nil) then
			table.insert(ErrorPlugins, name)
		else
			table.insert(LoadedPlugins, name)
		end
		PluginMap[name] = nil
	end
	
	-- Put all known but not enabled plugins into DisabledPlugins array
	local DisabledPlugins = {}
	for name, plugin in pairs(PluginMap) do
		table.insert(DisabledPlugins, name)
	end
	
	-- Sort the plugin arrays:
	table.sort(ErrorPlugins)
	table.sort(DisabledPlugins)
	-- Do NOT sort LoadedPlugins - we want them listed in their load order instead!
	
	-- Output the LoadedPlugins table:
	local res = {}
	local ins = table.insert
	if (#LoadedPlugins > 0) then
		ins(res, [[
			<h4>Loaded plugins</h4>
			<p>These plugins have been successfully initialized and are currently running.</p>
			<table style=\"background-color: #efffef\">
			]]
		);
		local Num = #LoadedPlugins
		for idx, name in pairs(LoadedPlugins) do
			ins(res, [[<tr><td width="100%" style="background-color: #efffef">]])
			ins(res, name)
			ins(res, [[</td><td style="background-color: #efffef">]])
			if (idx == 1) then
				ins(res, [[<button type="button" disabled>Move Up</button> </td>]])
			else
				ins(res, '<form method="POST"><input type="hidden" name="PluginName" value="')
				ins(res, name)
				ins(res, '"><input type="submit" name="MoveUp" value="Move Up"></form></td>')
			end
			ins(res, [[</td><td style="background-color: #efffef">]])
			if (idx == Num) then
				ins(res, '<button type="button" disabled>Move Down</button></td>')
			else
				ins(res, '<form method="POST"><input type="hidden" name="PluginName" value="')
				ins(res, name)
				ins(res, '"><input type="submit" name="MoveDown" value="Move Down"></form></td>')
			end
			ins(res, '<td style=\"background-color: #efffef\"><form method="POST"><input type="hidden" name="PluginName" value="')
			ins(res, name)
			ins(res, '"><input type="submit" name="DisablePlugin" value="Disable"></form></td></tr>')
		end
		ins(res, "</table><br />")
	end
	
	-- Output ErrorPlugins table:
	if (#ErrorPlugins > 0) then
		ins(res, [[
			<hr /><h4>Errors</h4>
			<p>These plugins are configured to run, but encountered a problem during their initialization.
			MCServer disabled them temporarily and will try reloading them next time.</p>
			<table>]]
		)
		for idx, name in ipairs(ErrorPlugins) do
			ins(res, "<tr><td width=\"100%\" style=\"background-color: #ffefef\">")
			ins(res, name)
			ins(res, "</td><td style=\"background-color: #ffefef\"><form method='POST'><input type='hidden' name='PluginName' value='")
			ins(res, name)
			ins(res, "'><input type='submit' name='DisablePlugin' value='Disable'></form></td></tr>")
		end
		ins(res, "</table><br />")
	end
	
	-- Output DisabledPlugins table:
	if (#DisabledPlugins > 0) then
		ins(res, [[<hr /><h4>Disabled plugins</h4>
			<p>These plugins are installed, but are disabled in the configuration.</p>
			<table>]]
		)
		for idx, name in ipairs(DisabledPlugins) do
			ins(res, "<tr><td width=\"100%\">")
			ins(res, name)
			ins(res, '</td><td><form method="POST"><input type="hidden" name="PluginName" value="')
			ins(res, name)
			ins(res, '"><input type="submit" name="EnablePlugin" value="Enable"></form></td></tr>')
		end
		ins(res, "</table><br />")
	end
	
	return table.concat(res, "")
end





--- Disables the specified plugin
-- Saves the new set of enabled plugins into SettingsIni
-- Returns true if the plugin was disabled
local function DisablePlugin(SettingsIni, PluginName, EnabledPlugins)
	for idx, name in ipairs(EnabledPlugins) do
		if (name == PluginName) then
			table.remove(EnabledPlugins, idx)
			SaveEnabledPlugins(SettingsIni, EnabledPlugins)
			return true
		end
	end
	return false
end





--- Enables the specified plugin
-- Saves the new set of enabled plugins into SettingsIni
-- Returns true if the plugin was enabled (false if it was already enabled before)
local function EnablePlugin(SettingsIni, PluginName, EnabledPlugins)
	for idx, name in ipairs(EnabledPlugins) do
		if (name == PluginName) then
			-- Plugin already enabled, ignore this call
			return false
		end
	end
	-- Add the plugin to the end of the list, save:
	table.insert(EnabledPlugins, PluginName)
	SaveEnabledPlugins(SettingsIni, EnabledPlugins)
end





--- Moves the specified plugin up or down by the specified delta
-- Saves the new order into SettingsIni
-- Returns true if the plugin was moved, false if not (bad delta / not found)
local function MovePlugin(SettingsIni, PluginName, IndexDelta, EnabledPlugins)
	for idx, name in ipairs(EnabledPlugins) do
		if (name == PluginName) then
			local DstIdx = idx + IndexDelta
			if ((DstIdx < 1) or (DstIdx > #EnabledPlugins)) then
				LOGWARNING("Core WebAdmin: Requesting moving the plugin " .. PluginName .. " to invalid index " .. DstIdx .. " (max idx " .. #EnabledPlugins .. "); ignoring.")
				return false
			end
			EnabledPlugins[idx], EnabledPlugins[DstIdx] = EnabledPlugins[DstIdx], EnabledPlugins[idx]  -- swap the two - we're expecting ony +1 / -1 moves
			SaveEnabledPlugins(SettingsIni, EnabledPlugins)
			return true
		end
	end
	
	-- Plugin not found:
	return false
end





--- Processes the actions specified by the request parameters
-- Modifies EnabledPlugins directly to reflect the action
-- Returns the notification text to be displayed at the top of the page
local function ProcessRequestActions(SettingsIni, Request, EnabledPlugins)
	local PluginName = Request.PostParams["PluginName"];
	if (PluginName == nil) then
		-- No PluginName was provided, so there's no action to perform
		return
	end
	
	if (Request.PostParams["DisablePlugin"] ~= nil) then
		if (DisablePlugin(SettingsIni, PluginName, EnabledPlugins)) then
			return '<td><p style="color: green;"><b>You disabled plugin: "' .. PluginName .. '"</b></p>'
		end
	elseif (Request.PostParams["EnablePlugin"] ~= nil) then
		if (EnablePlugin(SettingsIni, PluginName, EnabledPlugins)) then
			return '<td><p style="color: green;"><b>You enabled plugin: "' .. PluginName .. '"</b></p>'
		end
	elseif (Request.PostParams["MoveUp"] ~= nil) then
		MovePlugin(SettingsIni, PluginName, -1, EnabledPlugins)
	elseif (Request.PostParams["MoveDown"] ~= nil) then
		MovePlugin(SettingsIni, PluginName,  1, EnabledPlugins)
	end
end





function HandleRequest_ManagePlugins(Request)
	local Content = ""
		
	if (Request.PostParams["reload"] ~= nil) then
		Content = Content .. "<head><meta http-equiv=\"refresh\" content=\"5;\"></head>"
		Content = Content .. "<p>Reloading plugins... This can take a while depending on the plugins you're using.</p>"
		cRoot:Get():GetPluginManager():ReloadPlugins()
		return Content
	end

	local SettingsIni = cIniFile()
	SettingsIni:ReadFile("settings.ini")

	local EnabledPlugins = LoadEnabledPlugins(SettingsIni)
	
	local NotificationText = ProcessRequestActions(SettingsIni, Request, EnabledPlugins)
	Content = Content .. (NotificationText or "")
	
	if (g_NeedsReload) then
		Content = Content .. [[
			<form method='POST'>
			<p style="background-color:#ffffaf"><b>
			You need to reload the plugins in order for the changes to take effect.
			&nbsp;<input type='submit' name='reload' value='Reload now!'>
			</b></p></form>
		]]
	end
	
	Content = Content .. ListCurrentPlugins(EnabledPlugins)
	
	Content = Content .. [[<hr />
	<h4>Reload</h4>
	<form method='POST'>
	<p>Click the reload button to reload all plugins.
	<input type='submit' name='reload' value='Reload!'></p>
	</form>]]
	return Content
end




