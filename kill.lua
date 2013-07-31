function HandleKillCommand( Split, Player )
if (Split[2] == nil) then
   Player:SendMessage("Usage: /kill <player>")
   return true
end
local HasKilled = false;
local KillPlayer = function(OtherPlayer)
   if (OtherPlayer:GetName() == Split[2]) then
       if (OtherPlayer:GetGameMode() == 1) then
           HasKilled = creative
       end
       if (OtherPlayer:GetGameMode() == 0) then
           OtherPlayer:TakeDamage(dtInVoid, nil, 1000, 1000, 0);
           HasKilled = true;
       end
   end
end
 
cRoot:Get():FindAndDoWithPlayer(Split[2], KillPlayer);
if (HasKilled == creative) then
    Player:SendMessage( "Player " .. Split[2] .. " is in creative mode");
    return true
end
if (HasKilled) then
    Player:SendMessage( "Player " .. Split[2] .. " is killed");
    return true
else
    Player:SendMessage( "Player not found" );
    return true
end
end
