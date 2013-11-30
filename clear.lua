function HandleClearCommand( Split, Player )

  if (Split[2] == nil) then
     SendMessage( Player, GetTranslation( Player, "clear-usage" ) )
     return true
  end

  local InventoryCleared = false;
  local ClearInventory = function(OtherPlayer)
    if (OtherPlayer:GetName() == Split[2]) then
      OtherPlayer:GetInventory():Clear()
      InventoryCleared = true
    end
  end

  cRoot:Get():FindAndDoWithPlayer(Split[2], ClearInventory);
  if (InventoryCleared) then
    SendMessageSuccess( Player, GetTranslation( Player, "inv-cleared" ) .. Split[2] )
    return true
  else
    SendMessageFailure( Player, GetTranslation( Player, "player-not-found" ) )
    return true
  end

end
