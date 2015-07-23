function HandleClearCommand(Split, Player)
    
    if (Split[2] == nil) then
        Player:GetInventory():Clear()
        SendMessageSuccess( Player, "You cleared your own inventory" )
        return true
    end
        
    if Player:HasPermission("core.admin.clear") then
        local InventoryCleared = false;
        local ClearInventory = function(OtherPlayer)
            OtherPlayer:GetInventory():Clear()
            InventoryCleared = true
        end

        cRoot:Get():FindAndDoWithPlayer(Split[2], ClearInventory);
        if (InventoryCleared) then
            SendMessageSuccess(Player, "You cleared the inventory of " .. Split[2])
        else
            SendMessageFailure(Player, "Player not found")
        end
        
        return true
    end

    return false
    
end
