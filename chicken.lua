MattLib = {
	Enabled = false,
	TargetPlayer = nil,
	ActiveKeys = {
		ALT1 = false
	},
	DrawDistances = false,
	Panels = {
		Frame = nil,
		WorkPanel = nil,
		OptionsBasePanel = nil,
		OptionsWorkPanel = nil,
	},
	
	Commands = {
		PlayerESP = {
			Active = false
		},
		PlayerHalos = {
			Active = false
		},
		PlayerAimbot = {
			Active = false
		},
		
	},
	KeyBinds = {
		PlayerAimbot = nil
	},
	LastWarn = 0,
	CtrlDown = false,
	LastCtrl = 0
}

KeyLib = {
	ALT1 = {
		Code = 262144,
		Name = "ALT1"
	}
}
local width, height = ScrW(), ScrH()
-- MATTLIB FUNCTIONALITY -- 
function MattLib:ShowGUI()
	local frame = self:CreateBaseFrame()
	local workPanel = self:CreateWorkPanel(frame)
	self:BuildMenu(workPanel)
end

function MattLib:CreateWorkPanel(frame)
	if self.Panels.WorkPanel then self.Panels.WorkPanel:Remove() end
	local workPanel = vgui.Create("DPanel", frame)
	workPanel:SetSize(width*.3 - 10, height*.3 - 30)
	workPanel:SetPos(5, 25)
	workPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(50, 50, 50))
	end
	self.Panels.WorkPanel = workPanel
	return workPanel
end

function MattLib:CreateBaseFrame()
	if self.Panels.Frame then self.Panels.Frame:Remove() end
	local frame = vgui.Create("DFrame")
	frame.IsCustom = true
	frame:SetPos(width*.35, height*.35)
	frame:SetSize(width*.3, height*.3)
	frame.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(0,155,155))
		draw.SimpleText("MattLib Hack Menu", "Trebuchet24", w/2,h + 30, Color(255,255,255,255), 1, 1)
	end  
	frame:ShowCloseButton(true)
	frame:SetVisible(true)
	frame:SetTitle("MattLib - Hack Client Alpha v0.1")
	self.Panels.Frame = frame
	frame:MakePopup() 
	
	local frameAnim = Derma_Anim("EaseInQuad", main, function(pnl, frameAnim, delta, data)
		frame:SetPos(width*.35, inQuad(delta, ScrH(), -ScrH()*.65)) -- Change the X coordinate from 200 to 200+600
	end)
	frameAnim:Start(.5) -- Animate for two seconds
	frame.Think = function(self)
		if frameAnim:Active() then
			frameAnim:Run()
		end
	end
	
	return frame
end

function MattLib:BuildMenu(workPanel)
	print("[MattLib]: Building Menu...")
	local commandListFrame = self:CreateCommandListFrame(workPanel)
	local commandListPanel = self:CreateCommandListPanel(commandListFrame)
	self:AddCommands(commandListPanel)
	local optionsBasePanel = self:CreateOptionsPanel(workPanel)
	local optionsWorkPanel = self:CreateOptionsWorkPanel(optionsBasePanel, true)
end

function MattLib:CreateOptionsPanel(workPanel)
	
	if self.Panels.OptionsBasePanel then
		self.Panels.OptionsBasePanel:Remove()
		self.Panels.OptionsBasePanel = nil
	end
	local wPanelSizeX, wPanelSizeY = workPanel:GetSize()
	
	local optionsBasePanel = vgui.Create("DPanel", workPanel)
	optionsBasePanel:SetPos((wPanelSizeX * .3) + 5, 5)
	optionsBasePanel:SetSize(wPanelSizeX - ((wPanelSizeX * .3) + 8),wPanelSizeY - 10)
	optionsBasePanel.Paint = function(self, w, h)
		draw.RoundedBox(0,0,0,w,h,Color(70,70,70))
		draw.RoundedBox(0,2,2,w-4,h * 0.1,Color(40,40,40))
		draw.SimpleText("Options", "Trebuchet18", w/2, (wPanelSizeY - 10) * 0.055, Color(255,255,255), 1, 1)
	end
	self.Panels.OptionsBasePanel = optionsBasePanel
	return optionsBasePanel
end

function MattLib:CreateOptionsWorkPanel(optionsBasePanel, default)
	local panelSizeX, panelSizeY = optionsBasePanel:GetSize()
	self:RemoveExistingOptionsWorkPanel()
	local optionsWorkPanel = vgui.Create("DButton", optionsBasePanel)
	optionsWorkPanel:SetText("")
	optionsWorkPanel:SetCursor("arrow")
	optionsWorkPanel:SetSize(panelSizeX - 4, panelSizeY - ((panelSizeY * 0.1) + 5))
	optionsWorkPanel:SetPos(2, (panelSizeY * 0.1) + 4)
	optionsWorkPanel.IsDefault = default
	optionsWorkPanel.Paint = function(self, w, h)
		draw.RoundedBox(0,0,0,w,h,Color(40,40,40))
		if self.IsDefault then draw.SimpleText("[ Please select a command ]", "Trebuchet24", w/2, h/2 - 5, Color(80, 80, 80), 1, 1) end
	end
	self.Panels.OptionsWorkPanel = optionsWorkPanel
	return optionsWorkPanel
end

function MattLib:RemoveExistingOptionsWorkPanel()
	if self.Panels.OptionsWorkPanel then
		self.Panels.OptionsWorkPanel:Remove()
		self.Panels.OptionsWorkPanel = nil
	end
	return
end

function MattLib:CreateCommandListFrame(workPanel)
	local wPanelSizeX, wPanelSizeY = workPanel:GetSize()
	
	local commandListPanel = vgui.Create("DPanel", workPanel)
	commandListPanel:SetSize(wPanelSizeX * .3 - 10, wPanelSizeY - 10)
	commandListPanel:SetPos(5, 5)
	commandListPanel.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(70, 70, 70, 255))
		draw.RoundedBox(0, 2, 2, w-4, (wPanelSizeY - 10) * 0.1, Color(40, 40, 40, 255))
		draw.SimpleText("Commands", "Trebuchet18", w/2, (wPanelSizeY - 10) * 0.055, Color(255,255,255), 1, 1)
	end
	return commandListPanel
end

function MattLib:AddCommands(commandListPanel)
	local panelSizeX, panelSizeY = commandListPanel:GetSize()
	local index = -1
	for commandName, currentState in pairs(self.Commands) do
		index = index + 1
		local newCommandPanel = self:AddSingleCommand(index, panelSizeX, panelSizeY, commandListPanel, commandName, currentState)
		
	end
end

function MattLib:AddSingleCommand(index, sizeX, sizeY, panel, name, state)
	local newCommandPanel = vgui.Create("DButton", panel)
	local cmdPanelY = sizeY *.125 --1/8th the size of the panel max size Y.
	newCommandPanel:SetSize(sizeX, cmdPanelY)
	newCommandPanel:SetPos(0, 5 + index*5+index*cmdPanelY)
	newCommandPanel:SetText("")
	newCommandPanel.DrawColor = Color(10,10,10)
	newCommandPanel.CommandName = name
	
	newCommandPanel.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,self.DrawColor)
		draw.SimpleText(name, "Trebuchet18", w/2, h/2, Color(255,255,255), 1, 1)
	end
	newCommandPanel.DoClick = function()
		print("We are clicking!")
		MattLib:ShowCommandOptions(newCommandPanel.CommandName)
	end
	newCommandPanel.OnCursorEntered = function()
		newCommandPanel.DrawColor = Color(30, 30, 30)
	end
	newCommandPanel.OnCursorExited = function()
		newCommandPanel.DrawColor = Color(10, 10, 10)
	end
	
	return newCommandPanel
end

function MattLib:CreateCommandListPanel(commandListFrame)
	local panelSizeX, panelSizeY = commandListFrame:GetSize()
	
	local commandListPanel = vgui.Create("DScrollPanel", commandListFrame)
	commandListPanel:SetSize(panelSizeX - 4, panelSizeY - (((panelSizeY - 10)*0.1)+6))
	commandListPanel:SetPos(2, ((panelSizeY - 10)*0.1)+5)
	commandListPanel.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(50,50,50,255))
	end
	
	return commandListPanel
end




function MattLib:ShowCommandOptions(name)
	print("[MattLib]: Showing Options for command '" .. name .. "'.")
	Build_Command_Options[name]()
end

function MattLib:BuildPlayerListing(workFrame, dropDownBase)
	local dBaseSizeX, dBaseSizeY = dropDownBase:GetSize()
	local dBasePosX, dBasePosY = dropDownBase:GetPos()
	local wFrameSizeX, wFrameSizeY = workFrame:GetSize()
	local dropDownList = vgui.Create("DScrollPanel",workFrame)
	dropDownList:SetPos(dBasePosX, dBasePosY + dBaseSizeY)
	dropDownList:SetSize(dBaseSizeX, wFrameSizeY * .7)
	dropDownList.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(20, 20, 20,255))
	end
	local index = -1
	for k,v in pairs(player.GetAll()) do
		if v == LocalPlayer() then continue end
		index = index + 1
		local newPlayerButton = vgui.Create("DButton", dropDownList)
		newPlayerButton:SetSize(dBaseSizeX, 40)
		newPlayerButton:SetPos(0, 5 + (40*index) + (5*index))
		newPlayerButton.DrawColor = Color(30, 30, 30)
		newPlayerButton.Paint = function(self, w, h)
			draw.RoundedBox(0,0,0,w,h,newPlayerButton.DrawColor)
			draw.SimpleText(v:Nick(), "Trebuchet18", w/2, h/2, Color(255,255,255,255),1,1)
		end
		newPlayerButton:SetText("")
		newPlayerButton.OnCursorEntered = function()
			newPlayerButton.DrawColor = Color(55, 55, 55)
		end
		newPlayerButton.OnCursorExited = function()
			newPlayerButton.DrawColor = Color(30, 30 ,30)
		end
		newPlayerButton.DoClick = function()
			dropDownBase.SelectedPlayer = v
			MattLib.TargetPlayer = v
			dropDownList:Remove()
			dropDownList = nil
			dropDownBase.DropDownButton.DropDownEnabled = false
			workFrame.DropDown = nil
		end
	end
	return dropDownList
end

function MattLib:CreateDropdown(workFrame)
	local dropDownBase = vgui.Create("DPanel", workFrame)
	local dropDownButton = vgui.Create("DButton", dropDownBase) --Nest applicable panels
	local wFrameSizeX, wFrameSizeY = workFrame:GetSize()
	
	workFrame.DropDown = nil
	workFrame.DoClick = function() --Remove the existing drop down menu if the background panel is clicked.
		if workFrame.DropDown != nil then
			workFrame.DropDown:Remove()
			workFrame.DropDown = nil
			dropDownButton.DropDownEnabled = false
		end
	end
	--Create Text Labels
	local targetLabel = vgui.Create("DLabel", workFrame)
	targetLabel:SetText("Target Player:")
	targetLabel:SetFont("Trebuchet24")
	targetLabel:SetColor(Color(255,255,255))
	targetLabel:SetPos( 20, 30 )
	targetLabel:SizeToContents()
		
	textSizeX, textSizeY = targetLabel:GetSize()
	
	--Dropdown Base
	dropDownBase:SetPos(35 + textSizeX, 20)
	dropDownBase:SetSize(wFrameSizeX - (30 + textSizeX) - 20, 40)
	if self.TargetPlayer == nil then
		dropDownBase.SelectedPlayer = "[Select Player]"
	else
		dropDownBase.SelectedPlayer = self.TargetPlayer
	end
	dropDownBase.Paint = function(self,w,h)
		draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
		if self.SelectedPlayer == "[Select Player]" then
			draw.SimpleText(self.SelectedPlayer, "Trebuchet18", (w- 40)/2, h/2, Color(255,255,255), 1, 1)
		else
			draw.SimpleText(self.SelectedPlayer:Nick(), "Trebuchet18", (w- 40)/2, h/2, Color(255,255,255), 1, 1)
		end
	end
	local dBaseSizeX, dBaseSizeY = dropDownBase:GetSize()
	--Drop down button
	dropDownButton:SetText("")
	dropDownButton:SetSize(40, 40)
	dropDownButton:SetPos(dBaseSizeX - 40, 0)
	dropDownButton.DropDownEnabled = false
	dropDownButton.DropDownPanel = nil
	dropDownButton.Paint = function(self, w, h)
		draw.RoundedBox(0,0,0,w,h,Color(30, 30, 30))
		if self.DropDownEnabled then
			draw.SimpleText(5, "Marlett", w/2, h/2, Color(255,255,255), 1, 1)
		else
			draw.SimpleText(6, "Marlett", w/2, h/2, Color(255,255,255), 1, 1)
		end
	end
	dropDownBase.DropDownButton = dropDownButton
	dropDownButton.DoClick = function()
		if dropDownButton.DropDownEnabled then
			dropDownButton.DropDownPanel:Remove()
			dropDownButton.DropDownPanel = nil
			dropDownButton.DropDownEnabled = false
			workFrame.DropDown = nil
		else
			dropDownButton.DropDownPanel = MattLib:BuildPlayerListing(workFrame, dropDownBase)
			dropDownButton.DropDownEnabled = true
			workFrame.DropDown = dropDownButton.DropDownPanel
		end
	end
	return dropDownBase
end

function MattLib:CreateKeybindButton(bindKeyType, workFrame, dimensions)
	local keyBindButton = vgui.Create("DButton", workFrame)
	if self.KeyBinds[bindKeyType] != nil then
		keyBindButton.CurrentBoundKeyText = string.upper(input.GetKeyName(self.KeyBinds[bindKeyType]))
	else
		keyBindButton.CurrentBoundKeyText = "[No Key Bound]"
	end
	keyBindButton:SetSize(dimensions.width, dimensions.height)
	keyBindButton:SetPos(dimensions.x, dimensions.y)
	keyBindButton:SetText("")
	keyBindButton.DrawColor = Color(60,60,60)
	keyBindButton.Paint = function(self, w, h)
		draw.RoundedBox(4,0,0,w,h,self.DrawColor)
		draw.SimpleText(self.CurrentBoundKeyText, "Trebuchet18", w/2, h/2, Color(255,255,255), 1, 1)
	end
	keyBindButton.OnCursorEntered = function()
		self.DrawColor = Color(80,80,80)
	end
	keyBindButton.OnCursorExited = function()
		self.DrawColor = Color(60,60,60)
	end
	keyBindButton.DoClick = function()
		keyBindButton:RequestFocus()
		keyBindButton.CurrentBoundKeyText = "PRESS ANY KEY"
		keyBindButton.DrawColor = Color(199, 143, 0)
		keyBindButton.OnKeyCodePressed = function(...)
			local args = {...} 
			local keyCode = args[2]

			MattLib.KeyBinds[bindKeyType] = keyCode --Bind key to command
			keyBindButton.DrawColor = Color(60,60,60) -- Reset key bind button draw color to default
			keyBindButton.CurrentBoundKeyText = "Key: " .. string.upper(tostring(input.GetKeyName(keyCode))) -- update key bind button key bind text.
			keyBindButton.OnKeyCodePressed = function() end
		end
	end
	
end

function MattLib:HandleKeyBinds()
	

	for commandName, keyCode in pairs(self.KeyBinds) do
		if keyCode != nil then
			if input.IsKeyDown(tonumber(keyCode)) then
				Continuous_Functions[commandName]()
			end
		else continue end
	end
	
	
	if input.IsKeyDown(KEY_LCONTROL) then
		if self.CtrlDown then return end
		self.CtrlDown = true
		if self.LastCtrl == nil then
			self.LastCtrl = CurTime()
		else
			local timeDiff = (CurTime() - self.LastCtrl)
			if timeDiff < .25 then
				self:ShowGUI()
			end
			self.LastCtrl = CurTime()
		end
	else
		if self.CtrlDown then self.CtrlDown = false end
	end
end

Build_Command_Options = {
	PlayerHalos = function()
		workFrame = MattLib:CreateOptionsWorkPanel(MattLib.Panels.OptionsBasePanel, false)
		workFrame.Paint = function(self, w, h)
			draw.RoundedBox(0,0,0,w,h,Color(40,40,40))
			draw.SimpleText("Note: At long distances the outline of players", "Trebuchet18", w/2, h/2 +50, Color(80, 80, 80), 1, 1)
			draw.SimpleText("may be incorrect.", "Trebuchet18", w/2, h/2 +65, Color(80, 80, 80), 1, 1)
		end
		
		local wFrameSizeX, wFrameSizeY = workFrame:GetSize()
		
		--Create Text Labels
		local drawHalosText = vgui.Create("DLabel", workFrame)
		drawHalosText:SetText("Draw Player Halos: ")
		drawHalosText:SetFont("Trebuchet24")
		drawHalosText:SetColor(Color(255,255,255))
		drawHalosText:SetPos( 20, 20 )
		drawHalosText:SizeToContents()
		local drawInfoText = vgui.Create("DLabel", workFrame)
		drawInfoText:SetText("Draw Player Info: ")
		drawInfoText:SetFont("Trebuchet24")
		drawInfoText:SetColor(Color(255,255,255))
		drawInfoText:SetPos( 20, 50 )
		drawInfoText:SizeToContents()
		
		textSizeX, textSizeY = drawHalosText:GetSize()
		--Create Check boxes
		//Halo check box
		local halosEnabledCheckbox = vgui.Create("DCheckBox", workFrame)
		halosEnabledCheckbox:SetPos(20 + textSizeX, 24)
		halosEnabledCheckbox:SetValue(false)
		PrintTable(hook.GetTable()["PreDrawHalos"])
		local isEnabled = table.HasValue(table.GetKeys(hook.GetTable()["PreDrawHalos"]), "PaintHalos_PlayerFinder")
		halosEnabledCheckbox:SetValue(isEnabled)
		halosEnabledCheckbox.OnChange = function()
			local value = halosEnabledCheckbox:GetChecked()
			if value then
				MattLib:AddChat(Color(255,0,0), "[MattLib]", Color(255,255,255), ": Player halos enabled.")
				Command_Functions.PlayerHalos(true)
				MattLib.Commands.PlayerHalos.Active = true
			else
				MattLib:AddChat(Color(255,0,0), "[MattLib]", Color(255,255,255), ": Player halos disabled.")
				Command_Functions.PlayerHalos(false)
				MattLib.Commands.PlayerHalos.Active = true
			end
		end
		// Info check box
		local infoEnabledCheckbox = vgui.Create("DCheckBox", workFrame)
		infoEnabledCheckbox:SetPos(20 + textSizeX, 54)
		infoEnabledCheckbox:SetValue(false)
		local isInfoEnabled = table.HasValue(table.GetKeys(hook.GetTable()["HUDPaint"]), "PaintInfo_PlayerFinder")
		infoEnabledCheckbox:SetValue(isInfoEnabled)
		infoEnabledCheckbox.OnChange = function()
			local value = infoEnabledCheckbox:GetChecked()
			if value then
				MattLib:AddChat(Color(255,0,0), "[MattLib]", Color(255,255,255), ": Player info enabled.")
				Command_Functions.PlayerInfo(true)
			else
				MattLib:AddChat(Color(255,0,0), "[MattLib]", Color(255,255,255), ": Player info disabled.")
				Command_Functions.PlayerInfo(false)
			end
		end
		
	end,
	PlayerESP = function(workFrame)
	
	end,
	PlayerAimbot = function()
		
		workFrame = MattLib:CreateOptionsWorkPanel(MattLib.Panels.OptionsBasePanel, false) --Create fresh options work frame
		
		dropDownBase = MattLib:CreateDropdown(workFrame) --Add target drop down

		--Key bind Label
		local keyBindLabel = vgui.Create("DLabel", workFrame) --Y addition must be 60 down.
		keyBindLabel:SetPos(20, 85)
		keyBindLabel:SetText("Aimbot Key Bind:")
		keyBindLabel:SetFont("Trebuchet24")
		keyBindLabel:SetColor(Color(255,255,255))
		keyBindLabel:SizeToContents()
		local textSizeX, textSizeY = keyBindLabel:GetSize()
		local wFrameSizeX, wFrameSizeY = workFrame:GetSize()
		
		local bindKeySizeX, bindKeySizeY = (wFrameSizeX - (40 + textSizeX)), 30
		local bindKeyX, bindKeyY = (30 + textSizeX), (85 + (textSizeY/2) - 15)
		local bindKeyDimensions = {
			x = bindKeyX,
			y = bindKeyY,
			width = bindKeySizeX,
			height = bindKeySizeY
		}
		
		--Add keybind button
		local bindKeyType = "PlayerAimbot"
		MattLib:CreateKeybindButton(bindKeyType, workFrame, bindKeyDimensions)
	end,
	
}

Command_Functions = {
	PlayerHalos = function(bValue)
		if bValue then
			hook.Add( "PreDrawHalos", "PaintHalos_PlayerFinder", function()
				halo.Add( player.GetAll(), Color(255,0,0), 2, 2, 5, true, true ) -- Renders all players through walls as red halos.
			end )
		else
			hook.Remove("PreDrawHalos", "PaintHalos_PlayerFinder")
		end
	end,
	PlayerInfo = function(bValue)
		if bValue then
			hook.Add( "HUDPaint", "PaintInfo_PlayerFinder", function()
				for k, v in pairs(player.GetAll()) do
					if v == LocalPlayer() then continue end
					local plyScreenPos = v:GetBonePosition(v:LookupBone("ValveBiped.Bip01_Head1")):ToScreen()
					plyScreenPos.x = plyScreenPos.x - 40
					local plyName = v:Nick()
					draw.RoundedBox(0, plyScreenPos.x, plyScreenPos.y, 80, 20, Color(10, 10, 10, 150))
					draw.SimpleText(plyName, "Trebuchet18", plyScreenPos.x + 40, plyScreenPos.y + 10, Color(255,255,255), 1, 1)
				end
			end )
		else
			hook.Remove( "HUDPaint", "PaintInfo_PlayerFinder")
		end
	end,
	PlayerESP = function()
	
	end,
}

Continuous_Functions = {
	PlayerAimbot = function()
		if MattLib.TargetPlayer == nil then
			if (CurTime() - MattLib.LastWarn > 1) then
				MattLib:AddChat(Color(255,0,0), "[MattLib]", Color(255,255,255), ": You have not selected a target!") 
				MattLib.LastWarn = CurTime()
			end	
		else
			-- Run command
			local target = MattLib.TargetPlayer
			if not IsValid(target) then return end
			local tHeadPosition = target:GetBonePosition(target:LookupBone("ValveBiped.Bip01_Head1"))
			local offSetAngle = (tHeadPosition - LocalPlayer():GetShootPos()):Angle()
			LocalPlayer():SetEyeAngles(offSetAngle)
		end	
	end,
}

-- HOOK ADDITIONS --




hook.Add( "Think", "MattLib_Tick", function(ply)
	MattLib:HandleKeyBinds()
end )

-- CONSOLE COMMANDS --

concommand.Add("MattLib_ShowGUI", function(ply, cmd, args)
	MattLib:ShowGUI()
	print("[MattLib]: GUI Menu Opening")
end )






-- UTILITY FUNCTIONS --
function GetPlayerByName(name)
	for k,v in pairs(player.GetAll()) do
		if v:Nick() == name then
			return v
		end
	end
end

function GetPlayerByPartName(namePart)
	local foundPlayers = {}
	for k,v in pairs(player.GetAll()) do
		local found = string.find(string.lower(v:Nick()), string.lower(namePart))
		if(found != nil) then
			table.insert(foundPlayers, v)
		end
	end
	print("Bots:")
	PrintTable(player.GetBots())
	for k,v in pairs(player.GetBots()) do
		print("Bot Located: " .. v:Nick())
		local found = string.find(string.lower(v:Nick()), string.lower(namePart))
		if(found != nil) then
			table.insert(foundPlayers, v)
		end
	end
	return foundPlayers
end
function MattLib:AddChat( ... )
	local arg = { ... }
		
	args = {}
	for _, v in ipairs( arg ) do
		if ( type( v ) == "string" or type( v ) == "table" ) then table.insert( args, v ) end
	end
		
	chat.AddText( unpack( args ) )
end
function inQuad(fraction, beginning, change)
	return change * (fraction ^ 2) + beginning
end

