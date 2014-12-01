Implements some of the basic commands needed to run a simple server.

# Commands

### General
| Command | Permission | Description |
| ------- | ---------- | ----------- |
|/back | core.back | Return to your last position|
|/ban | core.ban | Ban a player|
|/clear | core.clear | Clear the inventory of a player|
|/difficulty | core.difficulty | Change world's difficulty.|
|/do | core.do | Runs a command as a player.|
|/fly | core.fly |  ~ Toggle fly|
|/gamemode | core.changegm | Change your gamemode|
|/give | core.give | Give someone an item|
|/help | core.help | Show available commands|
|/item | core.give | Give yourself an item.|
|/kick | core.kick | Kick a player|
|/kill | core.kill | Kill a player|
|/list | core.list | Lists all connected players|
|/listranks | core.listranks | List all the available ranks|
|/locate | core.locate | Show your current server coordinates|
|/me | core.me | Broadcast what you are doing|
|/motd | core.motd | Show message of the day|
|/plugins | core.plugins | Show list of plugins|
|/portal | core.portal | Move to a different world|
|/rank | core.rank | View or set a player's rank|
|/regen | core.regen | Regenerates a chunk|
|/reload | core.reload | Reload all plugins|
|/save-all | core.save-all | Save all worlds|
|/setspawn | core.setspawn | Change world spawn|
|/spawn | core.spawn | Return to the spawn|
|/stop | core.stop | Stops the server|
|/sudo | core.sudo | Runs a command as a player|
|/tell | core.tell | Send a private message|
|/time |  | Set or display the time|
|/time add | core.time.set | Add the amount given to the current time|
|/time day | core.time.set | Set the time to day|
|/time night | core.time.set | Set the time to night|
|/time query daytime | core.time.query.daytime | Display the current time|
|/time query gametime | core.time.query.gametime | Display the amount of time elapsed since start|
|/time set | core.time.set | Set the time to the value given|
|/toggledownfall | core.toggledownfall | Toggles downfall|
|/top | core.top | Teleport yourself to the topmost block|
|/tp | core.teleport | Teleport yourself to a player|
|/tpa | core.tpa | Ask to teleport yourself to a player|
|/tpaccept | core.tpaccept | Accept a teleportation request|
|/tpahere | core.tpahere |  ~ Ask to teleport player to yourself|
|/tpdeny | core.tpdeny |  ~ Deny a teleportation request|
|/tphere | core.tphere |  ~ Teleport player to yourself|
|/tps | core.tps | Returns the tps (ticks per second) from the server.|
|/unban | core.unban | Unban a player|
|/vanish | core.vanish |  - Vanish|
|/viewdistance | core.viewdistance | Change your view distance|
|/weather | core.weather | Change world weather|
|/whitelist |  | Manages the whitelist|
|/whitelist add |  | Adds a player to the whitelist|
|/whitelist list |  | Shows the players on the whitelist|
|/whitelist off |  | Turns whitelist processing off|
|/whitelist on |  | Turns whitelist processing on|
|/whitelist remove |  | Removes a player from the whitelist|
|/worlds | core.worlds | Shows a list of all the worlds|



# Permissions
| Permissions | Description | Commands | Recommended groups |
| ----------- | ----------- | -------- | ------------------ |
| core.back |  | `/back` |  |
| core.ban |  | `/ban` |  |
| core.changegm |  | `/gamemode` |  |
| core.clear |  | `/clear` |  |
| core.difficulty |  | `/difficulty` |  |
| core.do |  | `/do` |  |
| core.fly |  | `/fly` |  |
| core.give |  | `/give`, `/i`, `/item` |  |
| core.help |  | `/help` |  |
| core.kick |  | `/kick` |  |
| core.kill |  | `/kill` |  |
| core.list |  | `/list` |  |
| core.listranks |  | `/listranks` |  |
| core.locate |  | `/locate` |  |
| core.me |  | `/me` |  |
| core.motd |  | `/motd` |  |
| core.plugins |  | `/plugins` |  |
| core.portal |  | `/portal` |  |
| core.rank |  | `/rank` |  |
| core.regen |  | `/regen` |  |
| core.reload |  | `/reload` |  |
| core.save-all |  | `/save-all` |  |
| core.setspawn |  | `/setspawn` |  |
| core.spawn |  | `/spawn` |  |
| core.stop |  | `/stop` |  |
| core.sudo |  | `/sudo` |  |
| core.teleport |  | `/tp` |  |
| core.tell |  | `/tell` |  |
| core.time.query.daytime | Allows players to display the time of day | `/time query daytime` | everyone |
| core.time.query.gametime | Allows players to display how long the world has existed | `/time query gametime` |  |
| core.time.set | Allows players to set the time of day | `/time night`, `/time day`, `/time set`, `/time add` | admins |
| core.toggledownfall |  | `/toggledownfall` |  |
| core.top |  | `/top` |  |
| core.tpa |  | `/tpa` |  |
| core.tpaccept |  | `/tpaccept` |  |
| core.tpahere |  | `/tpahere` |  |
| core.tpdeny |  | `/tpdeny` |  |
| core.tphere |  | `/tphere` |  |
| core.tps |  | `/tps` |  |
| core.unban |  | `/unban` |  |
| core.vanish |  | `/vanish` |  |
| core.viewdistance |  | `/viewdistance` |  |
| core.weather |  | `/weather` |  |
| core.worlds |  | `/worlds` |  |
