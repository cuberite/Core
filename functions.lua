function SetBackCoordinates( Player )
	BackCoords[Player:GetName()] = Vector3i( Player:GetPosX(), Player:GetPosY(), Player:GetPosZ() )
end

function SendMessage(a_Player, a_Message)
	if (g_UsePrefixes) then
		a_Player:SendMessage(cChatColor.Yellow .. "[INFO] " .. cChatColor.White .. a_Message)
	else
		a_Player:SendMessage(cChatColor.Yellow .. a_Message)
	end
end

function SendMessageSuccess(a_Player, a_Message)
	if (g_UsePrefixes) then
		a_Player:SendMessage(cChatColor.Green .. "[INFO] " .. cChatColor.White .. a_Message)
	else
		a_Player:SendMessage(cChatColor.Green .. a_Message)
	end
end

function SendMessageFailure(a_Player, a_Message)
	if (g_UsePrefixes) then
		a_Player:SendMessage(cChatColor.Red .. "[INFO] " .. cChatColor.White .. a_Message)
	else
		a_Player:SendMessage(cChatColor.Red .. a_Message)
	end
end
