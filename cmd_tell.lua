local LastSender = {}

function HandleTellCommand(Split, Player)
	local Response
	
	local SenderName = "Server"
	local SenderUUID = "CuberiteServerConsoleSender"

	if Player then
		SenderName = Player:GetName()
		SenderUUID = Player:GetUUID()
	end
	
	local SendPrivateMessage = function(OtherPlayer)
		local Message = table.concat(Split, " ", 2)

		local ReceiverName = "Server"
		local ReceiverUUID = "CuberiteServerConsoleSender"
		
		if OtherPlayer then
			ReceiverName = OtherPlayer:GetName()
			ReceiverUUID = OtherPlayer:GetUUID()

			OtherPlayer:SendMessagePrivateMsg(Message, SenderName)
		else
			LOG("[MSG:" .. SenderName .. "] " .. Message)
		end
		LastSender[ReceiverUUID] = SenderUUID

		Response = SendMessageSuccess(Player, "Message to \"" .. ReceiverName .. "\" sent!")
        end

	if Split[1] == "r" or Split[1] == "/r" then
		if not Split[2] then
			Response = SendMessage(Player, "Usage: " .. Split[1] .. " <message ...>")
		elseif not LastSender[SenderUUID] then
			Response = SendMessageFailure(Player, "No last sender found")
		elseif "CuberiteServerConsoleSender" == LastSender[SenderUUID] then
			SendPrivateMessage()
		else
			local ReceiverName = cMojangAPI:GetPlayerNameFromUUID(LastSender[SenderUUID], true)
			if not cRoot:Get():FindAndDoWithPlayer(ReceiverName, SendPrivateMessage) then
				Response = SendMessageFailure(Player, "Player \"" .. ReceiverName .. "\" not found")
			end
		end
	else
		if not Split[3] then
			Response = SendMessage(Player, "Usage: " .. Split[1] .. " <player> <message ...>")
		elseif Split[2] == "" or not cRoot:Get():FindAndDoWithPlayer(Split[2], SendPrivateMessage) then
			Response = SendMessageFailure(Player, "Player \"" .. Split[2] .. "\" not found")
		end
	end
	return true, Response
end

function HandleConsoleTell(Split)
	return HandleTellCommand(Split)
end

function HandleRCommand(Split, Player)
	return HandleTellCommand(Split, Player)
end

function HandleConsoleR(Split)
	return HandleRCommand(Split)
end
