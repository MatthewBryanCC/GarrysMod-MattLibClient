# GarrysMod-MattLibClient
A simple client used for abusing gamemodes on Garry's mod servers.

## Installation
1. Download the chicken.lua file.
2. Navigate to your "/Steam/steamapps/common/Garrysmod/garrysmod/lua/" folder, and copy the chicken.lua file there.
3. Download and install CheatEngine 7.2 or higher.

## Setup for running on other servers
**Note:** We do these steps below so we can target the hex value that controls if we can run our lua script on our server. We can proceed to join another server and change this value for ourselves, at will, with CheatEngine.

1. Open Garry's Mod and launch a local multiplayer server with at least 2 slots. 
2. Open CheatEngine and click the computer icon, this will allow you to select Garry's Mod.
3. Go back into Garry's Mod, open the console with the ` key (tilda key, under escape). Type in "sv_cheats 1". **Note: You may need to open the options menu and enable the console before you are able to open the menu.**
4. Then type in 'sv_allowcslua 100'.
5. Tab back into CheatEngine. In the hex value search bar, type '100'. Begin a new search.
6. Go back into Garry's Mod and open the console, and type 'sv_allowcslua 101'.
7. Go back into CheatEngine. In the hex value search bar, type '101'. Press next search.
8. At the bottom of CheatEngine, one or two values should remain. One of them should have a value of 101. **This value will be changed when you join another server (back to 0)**

**Keep CheatEngine open for when you join another server.**

## Opening the client on another server

1. Join a server. When connected, tab into CheatEngine and select the value at the bottom of CheatEngine which we found earlier. It should be a 0 now.
2. Change this value from a 0 to a 1.
3. Tab into Garry's Mod again and open the console with the ` key.
4. Type 'lua_openscript_cl chicken.lua'. 
5. If all done correctly, double tapping control rapidly will open the client!

### The rest of the client should be pretty self explainitory to use :). Have fun cheating.

## Coming features
1. Prop detection for prop hunt.
2. Traitor detector for TTT.
These are both actually done, but they're on my other computer and can't be bothered getting them yet. Send and issue if you really want me to update.
