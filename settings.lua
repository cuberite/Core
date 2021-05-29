
g_IniFile = nil

function LoadSettings(path)
	local IniFile = cIniFile()
	if not IniFile:ReadFile(path, false) then
		-- File does not exist
		LOGINFO("Didn't find a settings file. Creating a new one.")
		IniFile:AddHeaderComment("This is the settings file for the Core plugin. Lines starting with \";\" are comments.") 
		IniFile:AddHeaderComment("To reset please stop the server, delete this and restart.")

	end

	IniFile:WriteFile(path)

	g_IniFile = IniFile
end

function SaveSettings(path)
	g_IniFile:WriteFile(path)
end
