
pcall(function()
	local main = game:GetObjects("rbxassetid://8428317923")[1];
	local DEX_W = loadstring(main:WaitForChild("Gui").Source)()()
	local Gui = DEX_W

	spawn(function() -- Main
		local HttpService = game:GetService'HttpService';

		local IntroFrame = Gui:WaitForChild("IntroFrame")

		local SideMenu = Gui:WaitForChild("SideMenu")
		local OpenToggleButton = Gui:WaitForChild("Toggle")
		local CloseToggleButton = SideMenu:WaitForChild("Toggle")
		local OpenScriptEditorButton = SideMenu:WaitForChild("OpenScriptEditor")

		local ScriptEditor = Gui:WaitForChild("ScriptEditor")

		local SlideOut = SideMenu:WaitForChild("SlideOut")
		local SlideFrame = SlideOut:WaitForChild("SlideFrame")
		local Slant = SideMenu:WaitForChild("Slant")

		local ExplorerButton = SlideFrame:WaitForChild("Explorer")
		local SettingsButton = SlideFrame:WaitForChild("Settings")

		local ExplorerPanel = Gui:WaitForChild("ExplorerPanel")
		local PropertiesFrame = Gui:WaitForChild("PropertiesFrame")
		local SaveMapWindow = Gui:WaitForChild("SaveMapWindow")
		local RemoteDebugWindow = Gui:WaitForChild("RemoteDebugWindow")

		local SettingsPanel = Gui:WaitForChild("SettingsPanel")
		local AboutPanel = Gui:WaitForChild("About")
		local SettingsListener = SettingsPanel:WaitForChild("GetSetting")
		local SettingTemplate = SettingsPanel:WaitForChild("SettingTemplate")
		local SettingList = SettingsPanel:WaitForChild("SettingList")

		local SaveMapCopyList = SaveMapWindow:WaitForChild("CopyList")
		local SaveMapSettingFrame = SaveMapWindow:WaitForChild("MapSettings")
		local SaveMapName = SaveMapWindow:WaitForChild("FileName")
		local SaveMapButton = SaveMapWindow:WaitForChild("Save")
		local SaveMapCopyTemplate = SaveMapWindow:WaitForChild("Entry")
		local SaveMapSettings = {
			CopyWhat = {
				Workspace = true,
				Lighting = true,
				ReplicatedStorage = true,
				ReplicatedFirst = true,
				StarterPack = true,
				StarterGui = true,
				StarterPlayer = true
			},
			SaveScripts = true,
			SaveTerrain = true,
			LightingProperties = true,
			CameraInstances = true
		}

--[[
local ClickSelectOption = SettingsPanel:WaitForChild("ClickSelect"):WaitForChild("Change")
local SelectionBoxOption = SettingsPanel:WaitForChild("SelectionBox"):WaitForChild("Change")
local ClearPropsOption = SettingsPanel:WaitForChild("ClearProperties"):WaitForChild("Change")
local SelectUngroupedOption = SettingsPanel:WaitForChild("SelectUngrouped"):WaitForChild("Change")
--]]

		local SelectionChanged = ExplorerPanel:WaitForChild("SelectionChanged")
		local GetSelection = ExplorerPanel:WaitForChild("GetSelection")
		local SetSelection = ExplorerPanel:WaitForChild("SetSelection")

		local Player = game:GetService("Players").LocalPlayer
		local Mouse = Player:GetMouse()

		local CurrentWindow = "Nothing c:"
		local Windows = {
			Explorer = {
				ExplorerPanel,
				PropertiesFrame
			},
			Settings = {SettingsPanel},
			SaveMap = {SaveMapWindow},
			Remotes = {RemoteDebugWindow},
			About = {AboutPanel},
		}

		function switchWindows(wName,over)
			if CurrentWindow == wName and not over then return end

			local count = 0

			for i,v in pairs(Windows) do
				count = 0
				if i ~= wName then
					for _,c in pairs(v) do c:TweenPosition(UDim2.new(1, 30, count * 0.5, count * 36), "Out", "Quad", 0.5, true) count = count + 1 end
				end
			end

			count = 0

			if Windows[wName] then
				for _,c in pairs(Windows[wName]) do c:TweenPosition(UDim2.new(1, -300, count * 0.5, count * 36), "Out", "Quad", 0.5, true) count = count + 1 end
			end

			if wName ~= "Nothing c:" then
				CurrentWindow = wName
				for i,v in pairs(SlideFrame:GetChildren()) do
					v.BackgroundTransparency = 1
					v.Icon.ImageColor3 = Color3.new(0.6, 0.6, 0.6)
				end
				if SlideFrame:FindFirstChild(wName) then
					SlideFrame[wName].BackgroundTransparency = 1
					SlideFrame[wName].Icon.ImageColor3 = Color3.new(1,1,1)
				end
			end
		end

		function toggleDex(on)
			if on then
				SideMenu:TweenPosition(UDim2.new(1, -330, 0, 0), "Out", "Quad", 0.5, true)
				OpenToggleButton:TweenPosition(UDim2.new(1,0,0,0), "Out", "Quad", 0.5, true)
				switchWindows(CurrentWindow,true)
			else
				SideMenu:TweenPosition(UDim2.new(1, 0, 0, 0), "Out", "Quad", 0.5, true)
				OpenToggleButton:TweenPosition(UDim2.new(1,-40,0,0), "Out", "Quad", 0.5, true)
				switchWindows("Nothing c:")
			end
		end

		local Settings = {
			ClickSelect = false,
			SelBox = false,
			ClearProps = false,
			SelectUngrouped = true,
			SaveInstanceScripts = true,
			UseNewDecompiler = true
		}

		pcall(function()
			local content = readfile('dexv3_settings.json');
			if content ~= nil and content ~= '' then
				local Saved = HttpService:JSONDecode(content);
				for i, v in pairs(Saved) do
					if Settings[i] ~= nil then
						Settings[i] = v;
					end
				end
			end
		end)

		function SaveSettings()
			local JSON = HttpService:JSONEncode(Settings);
			writefile('dexv3_settings.json', JSON);
		end

		local _decompile = decompile;

		function decompile(s, ...)
			if Settings.UseNewDecompiler then
				return _decompile(s, 'new');
			else
				return _decompile(s, 'legacy');
			end 
		end

		function ReturnSetting(set)
			if set == 'ClearProps' then
				return Settings.ClearProps
			elseif set == 'SelectUngrouped' then
				return Settings.SelectUngrouped
			elseif set == 'UseNewDecompiler' then
				return Settings.UseNewDecompiler
			end
		end

		OpenToggleButton.MouseButton1Up:connect(function()
			toggleDex(true)
		end)

		OpenScriptEditorButton.MouseButton1Up:connect(function()
			if OpenScriptEditorButton.Active then
				ScriptEditor.Visible = true
			end
		end)

		CloseToggleButton.MouseButton1Up:connect(function()
			if CloseToggleButton.Active then
				toggleDex(false)
			end
		end)

--[[
OpenToggleButton.MouseButton1Up:connect(function()
	SideMenu:TweenPosition(UDim2.new(1, -330, 0, 0), "Out", "Quad", 0.5, true)
	
	if CurrentWindow == "Explorer" then
		ExplorerPanel:TweenPosition(UDim2.new(1, -300, 0, 0), "Out", "Quad", 0.5, true)
		PropertiesFrame:TweenPosition(UDim2.new(1, -300, 0.5, 36), "Out", "Quad", 0.5, true)
	else
		SettingsPanel:TweenPosition(UDim2.new(1, -300, 0, 0), "Out", "Quad", 0.5, true)
	end
	
	OpenToggleButton:TweenPosition(UDim2.new(1,0,0,0), "Out", "Quad", 0.5, true)
end)

CloseToggleButton.MouseButton1Up:connect(function()
	SideMenu:TweenPosition(UDim2.new(1, 0, 0, 0), "Out", "Quad", 0.5, true)
	
	ExplorerPanel:TweenPosition(UDim2.new(1, 30, 0, 0), "Out", "Quad", 0.5, true)
	PropertiesFrame:TweenPosition(UDim2.new(1, 30, 0.5, 36), "Out", "Quad", 0.5, true)
	SettingsPanel:TweenPosition(UDim2.new(1, 30, 0, 0), "Out", "Quad", 0.5, true)
	
	OpenToggleButton:TweenPosition(UDim2.new(1,-30,0,0), "Out", "Quad", 0.5, true)
end)
--]]

--[[
ExplorerButton.MouseButton1Up:connect(function()
	switchWindows("Explorer")
end)

SettingsButton.MouseButton1Up:connect(function()
	switchWindows("Settings")
end)
--]]

		for i,v in pairs(SlideFrame:GetChildren()) do
			v.MouseButton1Click:connect(function()
				switchWindows(v.Name)
			end)

			-- v.MouseEnter:connect(function()v.BackgroundTransparency = 0.5 end)
			-- v.MouseLeave:connect(function()if CurrentWindow~=v.Name then v.BackgroundTransparency = 1 end end)
		end

--[[
ExplorerButton.MouseButton1Up:connect(function()
	if CurrentWindow ~= "Explorer" then
		CurrentWindow = "Explorer"
		
		ExplorerPanel:TweenPosition(UDim2.new(1, -300, 0, 0), "Out", "Quad", 0.5, true)
		PropertiesFrame:TweenPosition(UDim2.new(1, -300, 0.5, 36), "Out", "Quad", 0.5, true)
		SettingsPanel:TweenPosition(UDim2.new(1, 0, 0, 0), "Out", "Quad", 0.5, true)
	end
end)

SettingsButton.MouseButton1Up:connect(function()
	if CurrentWindow ~= "Settings" then
		CurrentWindow = "Settings"
		
		ExplorerPanel:TweenPosition(UDim2.new(1, 0, 0, 0), "Out", "Quad", 0.5, true)
		PropertiesFrame:TweenPosition(UDim2.new(1, 0, 0.5, 36), "Out", "Quad", 0.5, true)
		SettingsPanel:TweenPosition(UDim2.new(1, -300, 0, 0), "Out", "Quad", 0.5, true)
	end
end)
--]]

		function createSetting(name,interName,defaultOn)
			local newSetting = SettingTemplate:Clone()
			newSetting.Position = UDim2.new(0,0,0,#SettingList:GetChildren() * 60)
			newSetting.SName.Text = name

			local function toggle(on)
				if on then
					newSetting.Change.Bar:TweenPosition(UDim2.new(0,32,0,-2),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
					newSetting.Change.OnBar:TweenSize(UDim2.new(0,34,0,15),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
					newSetting.Status.Text = "On"
					Settings[interName] = true
				else
					newSetting.Change.Bar:TweenPosition(UDim2.new(0,-2,0,-2),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
					newSetting.Change.OnBar:TweenSize(UDim2.new(0,0,0,15),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
					newSetting.Status.Text = "Off"
					Settings[interName] = false
				end
			end	

			newSetting.Change.MouseButton1Click:connect(function()
				toggle(not Settings[interName])
				wait(1 / 12);
				pcall(SaveSettings);
			end)

			newSetting.Visible = true
			newSetting.Parent = SettingList

			if defaultOn then
				toggle(true)
			end
		end

		createSetting("Click part to select","ClickSelect",false)
		createSetting("Selection Box","SelBox",false)
		createSetting("Clear property value on focus","ClearProps",false)
		createSetting("Select ungrouped models","SelectUngrouped",true)
		createSetting("SaveInstance decompiles scripts","SaveInstanceScripts",true)
		createSetting("Use New Decompiler","UseNewDecompiler",false)

--[[
ClickSelectOption.MouseButton1Up:connect(function()
	if Settings.ClickSelect then
		Settings.ClickSelect = false
		ClickSelectOption.Text = "OFF"
	else
		Settings.ClickSelect = true
		ClickSelectOption.Text = "ON"
	end
end)

SelectionBoxOption.MouseButton1Up:connect(function()
	if Settings.SelBox then
		Settings.SelBox = false
		SelectionBox.Adornee = nil
		SelectionBoxOption.Text = "OFF"
	else
		Settings.SelBox = true
		SelectionBoxOption.Text = "ON"
	end
end)

ClearPropsOption.MouseButton1Up:connect(function()
	if Settings.ClearProps then
		Settings.ClearProps = false
		ClearPropsOption.Text = "OFF"
	else
		Settings.ClearProps = true
		ClearPropsOption.Text = "ON"
	end
end)

SelectUngroupedOption.MouseButton1Up:connect(function()
	if Settings.SelectUngrouped then
		Settings.SelectUngrouped = false
		SelectUngroupedOption.Text = "OFF"
	else
		Settings.SelectUngrouped = true
		SelectUngroupedOption.Text = "ON"
	end
end)
--]]

		local function getSelection()
			local t = GetSelection:Invoke()
			if t and #t > 0 then
				return t[1]
			else
				return nil
			end
		end

		Mouse.Button1Down:connect(function()
			if CurrentWindow == "Explorer" and Settings.ClickSelect then
				local target = Mouse.Target
				if target then
					SetSelection:Invoke({target}, true)
				end
			end
		end)

		SelectionChanged.Event:connect(function()
		end)

		SettingsListener.OnInvoke = ReturnSetting

		-- Map Copier

		function createMapSetting(obj,interName,defaultOn)
			local function toggle(on)
				if on then
					obj.Change.Bar:TweenPosition(UDim2.new(0,32,0,-2),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
					obj.Change.OnBar:TweenSize(UDim2.new(0,34,0,15),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
					obj.Status.Text = "On"
					SaveMapSettings[interName] = true
				else
					obj.Change.Bar:TweenPosition(UDim2.new(0,-2,0,-2),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
					obj.Change.OnBar:TweenSize(UDim2.new(0,0,0,15),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.25,true)
					obj.Status.Text = "Off"
					SaveMapSettings[interName] = false
				end
			end	

			obj.Change.MouseButton1Click:connect(function()
				toggle(not SaveMapSettings[interName])
			end)

			obj.Visible = true
			obj.Parent = SaveMapSettingFrame

			if defaultOn then
				toggle(true)
			end
		end

		function createCopyWhatSetting(serv)
			if SaveMapSettings.CopyWhat[serv] then
				local newSetting = SaveMapCopyTemplate:Clone()
				newSetting.Position = UDim2.new(0,0,0,#SaveMapCopyList:GetChildren() * 22 + 5)
				newSetting.Info.Text = serv

				local function toggle(on)
					if on then
						newSetting.Change.enabled.Visible = true
						SaveMapSettings.CopyWhat[serv] = true
					else
						newSetting.Change.enabled.Visible = false
						SaveMapSettings.CopyWhat[serv] = false
					end
				end	

				newSetting.Change.MouseButton1Click:connect(function()
					toggle(not SaveMapSettings.CopyWhat[serv])
				end)

				newSetting.Visible = true
				newSetting.Parent = SaveMapCopyList
			end
		end

		createMapSetting(SaveMapSettingFrame.Scripts,"SaveScripts",true)
		-- createMapSetting(SaveMapSettingFrame.Terrain,"SaveTerrain",true)
		-- createMapSetting(SaveMapSettingFrame.Lighting,"LightingProperties",true)
		-- createMapSetting(SaveMapSettingFrame.CameraInstances,"CameraInstances",true)

		createCopyWhatSetting("Workspace")
		createCopyWhatSetting("Lighting")
		createCopyWhatSetting("ReplicatedStorage")
		createCopyWhatSetting("ReplicatedFirst")
		createCopyWhatSetting("StarterPack")
		createCopyWhatSetting("StarterGui")
		createCopyWhatSetting("StarterPlayer")

		SaveMapName.Text = tostring(game.PlaceId).."MapCopy"

		SaveMapButton.MouseButton1Click:connect(function()
			local copyWhat = {}

			local copyGroup = Instance.new("Model",game:GetService('ReplicatedStorage'))

			local copyScripts = SaveMapSettings.SaveScripts

			-- local copyTerrain = SaveMapSettings.SaveTerrain

			-- local lightingProperties = SaveMapSettings.LightingProperties

			-- local cameraInstances = SaveMapSettings.CameraInstances

			-- local PlaceName = game:GetService'MarketplaceService':GetProductInfo(game.PlaceId).Name;
			-- PlaceName = PlaceName:gsub('%p', '');

			if Krnl then
				Krnl.SaveInstance.DecompileScripts = copyScripts
				Krnl.SaveInstance.Save()
			else
				if copyScripts then
					saveinstance{ noscripts = false, mode = "optimized" }
				else
					saveinstance{ noscripts = true, mode = "optimized" }
				end	
			end



			-----------------------------------------------------------------------------------

	--[[for i,v in pairs(SaveMapSettings.CopyWhat) do
		if v then
			table.insert(copyWhat,i)
		end
	end

	local consoleFunc = printconsole or writeconsole

	if consoleFunc then
		consoleFunc("Moon's place copier loaded.")
		consoleFunc("Copying map of game "..tostring(game.PlaceId)..".")
	end

	function archivable(root)
		for i,v in pairs(root:GetChildren()) do
			if not game:GetService('Players'):GetPlayerFromCharacter(v) then
				v.Archivable = true
				archivable(v)
			end
		end
	end

	function decompileS(root)
		for i,v in pairs(root:GetChildren()) do
			pcall(function()
				if v:IsA("LocalScript") then
					local isDisabled = v.Disabled
					v.Disabled = true
					v.Source = decompile(v)
					v.Disabled = isDisabled
				
					if v.Source == "" then 
						if consoleFunc then consoleFunc("LocalScript "..v.Name.." had a problem decompiling.") end
					else
						if consoleFunc then consoleFunc("LocalScript "..v.Name.." decompiled.") end
					end
				elseif v:IsA("ModuleScript") then
					v.Source = decompile(v)
				
					if v.Source == "" then 
						if consoleFunc then consoleFunc("ModuleScript "..v.Name.." had a problem decompiling.") end
					else
						if consoleFunc then consoleFunc("ModuleScript "..v.Name.." decompiled.") end
					end
				end
			end)
			decompileS(v)
		end
	end

	for i,v in pairs(copyWhat) do archivable(game[v]) end

	for j,obj in pairs(copyWhat) do
		if obj ~= "StarterPlayer" then
			local newFolder = Instance.new("Folder",copyGroup)
			newFolder.Name = obj
			for i,v in pairs(game[obj]:GetChildren()) do
				if v ~= copyGroup then
					pcall(function()
						v:Clone().Parent = newFolder
					end)
				end
			end
		else
			local newFolder = Instance.new("Model",copyGroup)
			newFolder.Name = "StarterPlayer"
			for i,v in pairs(game[obj]:GetChildren()) do
				local newObj = Instance.new("Folder",newFolder)
				newObj.Name = v.Name
				for _,c in pairs(v:GetChildren()) do
					if c.Name ~= "ControlScript" and c.Name ~= "CameraScript" then
						c:Clone().Parent = newObj
					end
				end
			end
		end
	end

	if workspace.CurrentCamera and cameraInstances then
		local cameraFolder = Instance.new("Model",copyGroup)
		cameraFolder.Name = "CameraItems"
		for i,v in pairs(workspace.CurrentCamera:GetChildren()) do v:Clone().Parent = cameraFolder end
	end

	if copyTerrain then
		local myTerrain = workspace.Terrain:CopyRegion(workspace.Terrain.MaxExtents)
		myTerrain.Parent = copyGroup
	end

	function saveProp(obj,prop,par)
		local myProp = obj[prop]
		if type(myProp) == "boolean" then
			local newProp = Instance.new("BoolValue",par)
			newProp.Name = prop
			newProp.Value = myProp
		elseif type(myProp) == "number" then
			local newProp = Instance.new("IntValue",par)
			newProp.Name = prop
			newProp.Value = myProp
		elseif type(myProp) == "string" then
			local newProp = Instance.new("StringValue",par)
			newProp.Name = prop
			newProp.Value = myProp
		elseif type(myProp) == "userdata" then -- Assume Color3
			pcall(function()
				local newProp = Instance.new("Color3Value",par)
				newProp.Name = prop
				newProp.Value = myProp
			end)
		end
	end

	if lightingProperties then
		local lightingProps = Instance.new("Model",copyGroup)
		lightingProps.Name = "LightingProperties"
	
		saveProp(game:GetService('Lighting'),"Ambient",lightingProps)
		saveProp(game:GetService('Lighting'),"Brightness",lightingProps)
		saveProp(game:GetService('Lighting'),"ColorShift_Bottom",lightingProps)
		saveProp(game:GetService('Lighting'),"ColorShift_Top",lightingProps)
		saveProp(game:GetService('Lighting'),"GlobalShadows",lightingProps)
		saveProp(game:GetService('Lighting'),"OutdoorAmbient",lightingProps)
		saveProp(game:GetService('Lighting'),"Outlines",lightingProps)
		saveProp(game:GetService('Lighting'),"GeographicLatitude",lightingProps)
		saveProp(game:GetService('Lighting'),"TimeOfDay",lightingProps)
		saveProp(game:GetService('Lighting'),"FogColor",lightingProps)
		saveProp(game:GetService('Lighting'),"FogEnd",lightingProps)
		saveProp(game:GetService('Lighting'),"FogStart",lightingProps)
	end

	if decompile and copyScripts then
		-- decompileS(copyGroup)
	end

	if SaveInstance then
		SaveInstance(copyGroup,SaveMapName.Text..".rbxm")
	elseif saveinstance then
		saveinstance(getelysianpath()..SaveMapName.Text..".rbxm",copyGroup)
	end
	--print("Saved!")
	if consoleFunc then
		consoleFunc("The map has been copied.")
	end
	SaveMapButton.Text = "The map has been saved"
	wait(5)
	SaveMapButton.Text = "Save"
	]]
		end)

		-- End Copier

		wait()

		IntroFrame:TweenPosition(UDim2.new(1,-301,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.5,true)

		switchWindows("Explorer")

		wait(1)

		SideMenu.Visible = true

		for i = 0,1,0.1 do
			IntroFrame.BackgroundTransparency = i
			IntroFrame.Main.BackgroundTransparency = i
			IntroFrame.Slant.ImageTransparency = i
			IntroFrame.Title.TextTransparency = i
			IntroFrame.Version.TextTransparency = i
			IntroFrame.Creator.TextTransparency = i
			IntroFrame.Sad.ImageTransparency = i
			wait()
		end

		IntroFrame.Visible = false

		SlideFrame:TweenPosition(UDim2.new(0,0,0,0),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.5,true)
		OpenScriptEditorButton:TweenPosition(UDim2.new(0,0,0,150),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.5,true)
		CloseToggleButton:TweenPosition(UDim2.new(0,0,0,180),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.5,true)
		Slant:TweenPosition(UDim2.new(0,0,0,210),Enum.EasingDirection.Out,Enum.EasingStyle.Quart,0.5,true)

		wait(0.5)

		for i = 1,0,-0.1 do
			OpenScriptEditorButton.Icon.ImageTransparency = i
			CloseToggleButton.TextTransparency = i
			wait()
		end

		CloseToggleButton.Active = true
		CloseToggleButton.AutoButtonColor = false

		OpenScriptEditorButton.Active = true
		OpenScriptEditorButton.AutoButtonColor = false
	end)

	spawn(function() -- Idk1
		--[[
	
Change log:

1/1/22
	Added new API dump support (new classes :sunglo:)
	
09/18
	Fixed checkbox mouseover sprite
	Encapsulated checkbox creation into separate method
	Fixed another checkbox issue

09/15
	Invalid input is ignored instead of setting to default of that data type
	Consolidated control methods and simplified them
	All input goes through ToValue method
	Fixed position of BrickColor palette
	Made DropDown appear above row if it would otherwise exceed the page height
	Cleaned up stylesheets

09/14
	Made properties window scroll when mouse wheel scrolled
	Object/Instance and Color3 data types handled properly
	Multiple BrickColor controls interfering with each other fixed
	Added support for Content data type
	
--]]

		wait(0.2)

		local UIS = game:GetService'UserInputService';

		local PropertiesFrame = Gui:WaitForChild("PropertiesFrame")
		local ExplorerFrame = Gui:WaitForChild("ExplorerPanel")

		-- Services
		local Teams = game:GetService("Teams")
		local Workspace = game:GetService("Workspace")
		local Debris = game:GetService("Debris")
		local ContentProvider = game:GetService("ContentProvider")
		local Players = game:GetService("Players")
		local ReplicatedStorage = game:GetService("ReplicatedStorage")

		-- Functions
		function httpGet(url)
			if(not game:GetService("RunService"):IsStudio()) then
				return game:HttpGet(url,true)
			else
				return workspace:WaitForChild("request"):InvokeServer(url)
			end
		end

		-- RbxApi Stuff

		local apiUrl = "https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/API-Dump.json"
		local maxChunkSize = 100 * 1000
		local ApiJson
		if script:FindFirstChild("RawApiJson") then
			ApiJson = script.RawApiJson
		else
			ApiJson = ""
		end


		function getCurrentApiJson()
			local jsonStr = nil
			local success
			success = pcall(function()
				jsonStr = httpGet(apiUrl)
				--print("Fetched json successfully")
			end)
			if success then
				--print("Returning json")
				--print(jsonStr:sub(1,500))
				return jsonStr
			end
		end

		function splitStringIntoChunks(jsonStr)
			-- Splits up a string into a table with a given size
			local t = {}
			for i = 1, math.ceil(string.len(jsonStr)/maxChunkSize) do
				local str = jsonStr:sub((i-1)*maxChunkSize+1, i*maxChunkSize)
				table.insert(t, str)
			end
			return t
		end

		local jsonToParse = getCurrentApiJson()

		function getRbxApi()
			local jsonDecode = function(...)
				return game:GetService("HttpService"):JSONDecode(...)
			end
			local runService = game:GetService("RunService");

			local get = function(url)
				return httpGet(url)
			end

			local dump = jsonDecode(get("https://raw.githubusercontent.com/MaximumADHD/Roblox-Client-Tracker/roblox/API-Dump.json"))
			local apiDump = dump["Classes"]
			local parsed = {};

			local parseProperty = function(member,class)
				local new = {
					tags = {},
					ValueType = member.ValueType.Name,
					Class = class,
					Name = member.Name,
					["type"] = member["MemberType"],
				}
				for _,tag in pairs(member.Tags or {}) do
					table.insert(new.tags,tag);
				end
				return new;
			end

			local parseEvent = function(member,class)
				local new = {
					tags = {},
					Arguments = {},
					["type"] = member["MemberType"],
					Class = class,
					Name = member.Name,
				}
				for _,tag in pairs(member.Tags or {}) do
					table.insert(new.tags,tag);
				end
				for _,arg in pairs(member.Parameters or {}) do
					table.insert(new.Arguments,{
						Name = arg.Name,
						Type = arg.Type.Name
					})
				end
				return new;
			end

			local parseFunction = function(member,class)
				local new = {
					tags = {},
					Class = class,
					Name = member.Name,
					["type"] = member["MemberType"],
					Arguments = {},
					ReturnType = member.ReturnType.Name;
				}
				for _,tag in pairs(member.Tags or {}) do
					table.insert(new.tags,tag);
				end
				for _,arg in pairs(member.Parameters) do
					table.insert(new.Arguments,{
						Name = arg.Name,
						Type = arg.Type.Name
					})
				end
				return new;
			end

			local parseCallback = function(member,class)
				local new = {
					tags = {},
					Arguments = {},
					["type"] = member["MemberType"],
					Class = class,
					Name = member.Name,
					ReturnType = member.ReturnType.Name
				}
				for _,tag in pairs(member.Tags or {}) do
					table.insert(new.tags,tag);
				end
				for _,arg in pairs(member.Parameters or {}) do
					table.insert(new.Arguments,{
						Name = arg.Name,
						Type = arg.Type.Name
					})
				end
				return new;
			end

			local enums = {}

			for _,enum in pairs(dump["Enums"]) do
				enums[enum.Name] = {EnumItems = {},Name = enum.Name}
				for _,item in pairs(enum.Items) do
					enums[enum.Name].EnumItems[item.Name] = item;
				end
			end

			local function sortAlphabetic(t, property)
				table.sort(t,function(x,y) 
					return x[property] < y[property]
				end)
			end

			local isEnum = function(enum)
				return enums[enum] ~= nil;
			end

			local function getProperties(className)
				local class = parsed[className]
				local properties = {}

				if not class then return properties end

				while class do
					for _,property in pairs(class.Properties) do
						table.insert(properties, property)
					end
					class = parsed[class.Superclass]
				end

				sortAlphabetic(properties, "Name")

				return properties
			end

			for _,data in pairs(apiDump) do
				local class = data.Name;
				local superclass = data.Superclass;
				local members = data.Members;
				parsed[class] = parsed[class] or {
					["Properties"] = {},
					Name = class,
					Superclass = data["Superclass"],
					Events = {},
					Functions = {},
					Callbacks = {},
					YieldFunctions = {},
					["tags"] = {},
					["type"] = "Class",
				}
				for _,member in pairs(members) do
					local subclass = member.MemberType;
					if(subclass == "Property" and member.ValueType ~= nil) then
						table.insert(parsed[class]["Properties"],parseProperty(member,class))
					elseif(subclass == "Event") then
						table.insert(parsed[class]["Events"],parseEvent(member,class))
					elseif(subclass == "Function") then
						table.insert(parsed[class]["Functions"],parseFunction(member,class))
					elseif(subclass == "YieldFunction") then
						table.insert(parsed[class]["YieldFunctions"],parseFunction(member,class))
					elseif(subclass == "Callback") then
						table.insert(parsed[class]["Callbacks"],parseCallback(member,class))
					end
				end
			end

			return {
				Classes = parsed,
				Enums = enums,
				GetProperties = getProperties,
				IsEnum = isEnum
			}
		end

		-- Modules
		local Permissions = {CanEdit = true}
		local RbxApi = getRbxApi()

--[[
	RbxApi.Classes
	RbxApi.Enums
	RbxApi.GetProperties(className)
	RbxApi.IsEnum(valueType)
--]]

		-- Styles

		local function CreateColor3(r, g, b) return Color3.new(r/255,g/255,b/255) end

		local Styles = {
			Font = Enum.Font.SourceSans;
			Margin = 5;
			Black = CreateColor3(0,0,0);
			Black2 = CreateColor3(24, 24, 24);
			White = CreateColor3(244,244,244);
			Hover = CreateColor3(2, 128, 144);
			Hover2 = CreateColor3(5, 102, 141);
		}

		local Row = {
			Font = Styles.Font;
			FontSize = Enum.FontSize.Size14;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextColor = Styles.White;
			TextColorOver = Styles.White;
			TextLockedColor = CreateColor3(155,155,155);
			Height = 24;
			BorderColor = CreateColor3(216/4,216/4,216/4);
			BackgroundColor = Styles.Black2;
			BackgroundColorAlternate = CreateColor3(32, 32, 32);
			BackgroundColorMouseover = CreateColor3(40, 40, 40);
			TitleMarginLeft = 15;
		}

		local DropDown = {
			Font = Styles.Font;
			FontSize = Enum.FontSize.Size14;
			TextColor = CreateColor3(255,255,255);
			TextColorOver = Styles.White;
			TextXAlignment = Enum.TextXAlignment.Left;
			Height = 16;
			BackColor = Styles.Black2;
			BackColorOver = Styles.Hover2;
			BorderColor = CreateColor3(45,45,45);
			BorderSizePixel = 2;
			ArrowColor = CreateColor3(160/2,160/2,160/2);
			ArrowColorOver = Styles.Hover;
		}

		local BrickColors = {
			BoxSize = 13;
			BorderSizePixel = 1;
			BorderColor = CreateColor3(160/3,160/3,160/3);
			FrameColor = CreateColor3(160/3,160/3,160/3);
			Size = 20;
			Padding = 4;
			ColorsPerRow = 8;
			OuterBorder = 1;
			OuterBorderColor = Styles.Black;
		}

		wait(1)

		local bindGetSelection = ExplorerFrame:WaitForChild("GetSelection")
		local bindSelectionChanged = ExplorerFrame:WaitForChild("SelectionChanged")
		local bindGetApi = PropertiesFrame.GetApi
		local bindGetAwait = PropertiesFrame.GetAwaiting
		local bindSetAwait = PropertiesFrame.SetAwaiting

		local ContentUrl = ContentProvider.BaseUrl .. "asset/?id="

		local SettingsRemote = Gui:WaitForChild("SettingsPanel"):WaitForChild("GetSetting")

		local propertiesSearch = PropertiesFrame.Header.TextBox

		local AwaitingObjectValue = false
		local AwaitingObjectObj
		local AwaitingObjectProp

		function searchingProperties()
			if propertiesSearch.Text ~= "" and propertiesSearch.Text ~= "Search Properties" then
				return true
			end
			return false
		end

		local function GetSelection()
			local selection = bindGetSelection:Invoke()
			if #selection == 0 then
				return nil
			else
				return selection
			end 
		end

		-- Number

		local function Round(number, decimalPlaces)
			return tonumber(string.format("%." .. (decimalPlaces or 0) .. "f", number))
		end

		-- Strings

		local function Split(str, delimiter)
			return str:split(delimiter)
		end

		-- Data Type Handling

		local function ToString(value, type)
			if type == "float" then
				return tostring(Round(value,2))
			elseif type == "Content" then
				if string.find(value,"/asset") then
					local match = string.find(value, "=") + 1
					local id = string.sub(value, match)
					return id
				else
					return tostring(value)
				end
			elseif type == "Vector2" then
				local x = value.x
				local y = value.y
				return string.format("%g, %g", x,y)
			elseif type == "Vector3" then
				local x = value.x
				local y = value.y
				local z = value.z
				return string.format("%g, %g, %g", x,y,z)
			elseif type == "Color3" then
				local r = value.r
				local g = value.g
				local b = value.b
				return string.format("%d, %d, %d", r*255,g*255,b*255)
			elseif type == "UDim2" then
				local xScale = value.X.Scale
				local xOffset = value.X.Offset
				local yScale = value.Y.Scale
				local yOffset = value.Y.Offset
				return string.format("{%d, %d}, {%d, %d}", xScale, xOffset, yScale, yOffset)
			else
				return tostring(value)
			end
		end

		local function ToValue(value,type)
			if type == "Vector2" then
				local list = Split(value,",")
				if #list < 2 then return nil end
				local x = tonumber(list[1]) or 0
				local y = tonumber(list[2]) or 0
				return Vector2.new(x,y)
			elseif type == "Vector3" then
				local list = Split(value,",")
				if #list < 3 then return nil end
				local x = tonumber(list[1]) or 0
				local y = tonumber(list[2]) or 0
				local z = tonumber(list[3]) or 0
				return Vector3.new(x,y,z)
			elseif type == "Color3" then
				local list = Split(value,",")
				if #list < 3 then return nil end
				local r = tonumber(list[1]) or 0
				local g = tonumber(list[2]) or 0
				local b = tonumber(list[3]) or 0
				return Color3.new(r/255,g/255, b/255)
			elseif type == "UDim2" then
				local list = Split(string.gsub(string.gsub(value, "{", ""),"}",""),",")
				if #list < 4 then return nil end
				local xScale = tonumber(list[1]) or 0
				local xOffset = tonumber(list[2]) or 0
				local yScale = tonumber(list[3]) or 0
				local yOffset = tonumber(list[4]) or 0
				return UDim2.new(xScale, xOffset, yScale, yOffset)
			elseif type == "Content" then
				if tonumber(value) ~= nil then
					value = ContentUrl .. value
				end
				return value
			elseif type == "float" or type == "int" or type == "double" then
				return tonumber(value)
			elseif type == "string" then
				return value
			elseif type == "NumberRange" then
				local list = Split(value,",")
				if #list == 1 then
					if tonumber(list[1]) == nil then return nil end
					local newVal = tonumber(list[1]) or 0
					return NumberRange.new(newVal)
				end
				if #list < 2 then return nil end
				local x = tonumber(list[1]) or 0
				local y = tonumber(list[2]) or 0
				return NumberRange.new(x,y)
			else
				return nil
			end
		end


		-- Tables

		local function CopyTable(T)
			local t2 = {}
			for k,v in pairs(T) do
				t2[k] = v
			end
			return t2
		end

		local function SortTable(T)
			table.sort(T, 
				function(x,y) return x.Name < y.Name
				end)
		end

		-- Spritesheet
		local Sprite = {
			Width = 13;
			Height = 13;
		}

		local Spritesheet = {
			Image = "http://www.roblox.com/asset/?id=128896947";
			Height = 256;
			Width = 256;
		}

		local Images = {
			"unchecked",
			"checked",
			"unchecked_over",
			"checked_over",
			"unchecked_disabled",
			"checked_disabled"
		}

		local function SpritePosition(spriteName)
			local x = 0
			local y = 0
			for i,v in pairs(Images) do
				if (v == spriteName) then
					return {x, y}
				end
				x = x + Sprite.Height
				if (x + Sprite.Width) > Spritesheet.Width then
					x = 0
					y = y + Sprite.Height
				end
			end
		end

		local function GetCheckboxImageName(checked, readOnly, mouseover)
			if checked then
				if readOnly then
					return "checked_disabled"
				elseif mouseover then
					return "checked_over"
				else
					return "checked"
				end
			else
				if readOnly then
					return "unchecked_disabled"
				elseif mouseover then
					return "unchecked_over"
				else
					return "unchecked"
				end
			end
		end

		local MAP_ID = 418720155

		-- Gui Controls --

		---- IconMap ----
		-- Image size: 256px x 256px
		-- Icon size: 16px x 16px
		-- Padding between each icon: 2px
		-- Padding around image edge: 1px
		-- Total icons: 14 x 14 (196)
		local Icon do
			local iconMap = 'http://www.roblox.com/asset/?id=' .. MAP_ID
			game:GetService('ContentProvider'):Preload(iconMap)
			local iconDehash do
				-- 14 x 14, 0-based input, 0-based output
				local f=math.floor
				function iconDehash(h)
					return f(h/14%14),f(h%14)
				end
			end

			function Icon(IconFrame,index)
				local row,col = iconDehash(index)
				local mapSize = Vector2.new(256,256)
				local pad,border = 2,1
				local iconSize = 16

				local class = 'Frame'
				if type(IconFrame) == 'string' then
					class = IconFrame
					IconFrame = nil
				end

				if not IconFrame then
					IconFrame = Create(class,{
						Name = "Icon";
						BackgroundTransparency = 1;
						ClipsDescendants = true;
						Create('ImageLabel',{
							Name = "IconMap";
							Active = false;
							BackgroundTransparency = 1;
							Image = iconMap;
							Size = UDim2.new(mapSize.x/iconSize,0,mapSize.y/iconSize,0);
						});
					})
				end

				IconFrame.IconMap.Position = UDim2.new(-col - (pad*(col+1) + border)/iconSize,0,-row - (pad*(row+1) + border)/iconSize,0)
				return IconFrame
			end
		end

		local function CreateCell()
			local tableCell = Instance.new("Frame")
			tableCell.Size = UDim2.new(0.5, -1, 1, 0)
			tableCell.BackgroundColor3 = Row.BackgroundColor
			tableCell.BorderColor3 = Row.BorderColor
			return tableCell
		end

		local function CreateLabel(readOnly)
			local label = Instance.new("TextLabel")
			label.Font = Row.Font
			label.FontSize = Row.FontSize
			label.TextXAlignment = Row.TextXAlignment
			label.BackgroundTransparency = 1

			if readOnly then
				label.TextColor3 = Row.TextLockedColor
			else
				label.TextColor3 = Row.TextColor
			end
			return label
		end

		local function CreateTextButton(readOnly, onClick)
			local button = Instance.new("TextButton")
			button.Font = Row.Font
			button.FontSize = Row.FontSize
			button.TextXAlignment = Row.TextXAlignment
			button.BackgroundTransparency = 1
			if readOnly then
				button.TextColor3 = Row.TextLockedColor
			else
				button.TextColor3 = Row.TextColor
				button.MouseButton1Click:connect(function()
					onClick()
				end)
			end
			return button
		end

		local function CreateObject(readOnly)
			local button = Instance.new("TextButton")
			button.Font = Row.Font
			button.FontSize = Row.FontSize
			button.TextXAlignment = Row.TextXAlignment
			button.BackgroundTransparency = 1
			if readOnly then
				button.TextColor3 = Row.TextLockedColor
			else
				button.TextColor3 = Row.TextColor
			end
			local cancel = Create(Icon('ImageButton',177),{
				Name = "Cancel";
				Visible = false;
				Position = UDim2.new(1,-20,0,0);
				Size = UDim2.new(0,20,0,20);
				Parent = button;
			})
			return button
		end

		local function CreateTextBox(readOnly)
			if readOnly then
				local box = CreateLabel(readOnly)
				return box
			else
				local box = Instance.new("TextBox")
				if not SettingsRemote:Invoke("ClearProps") then
					box.ClearTextOnFocus = false
				end
				box.Font = Row.Font
				box.FontSize = Row.FontSize
				box.TextXAlignment = Row.TextXAlignment
				box.BackgroundTransparency = 1
				box.TextColor3 = Row.TextColor
				return box
			end
		end

		local function CreateDropDownItem(text, onClick)
			local button = Instance.new("TextButton")
			button.Font = DropDown.Font
			button.FontSize = DropDown.FontSize
			button.TextColor3 = DropDown.TextColor
			button.TextXAlignment = DropDown.TextXAlignment
			button.BackgroundColor3 = DropDown.BackColor
			button.AutoButtonColor = false
			button.BorderSizePixel = 0
			button.Active = true
			button.Text = text

			button.MouseEnter:connect(function()
				button.TextColor3 = DropDown.TextColorOver
				button.BackgroundColor3 = DropDown.BackColorOver
			end)
			button.MouseLeave:connect(function()
				button.TextColor3 = DropDown.TextColor
				button.BackgroundColor3 = DropDown.BackColor
			end)
			button.MouseButton1Click:connect(function()
				onClick(text)
			end)	
			return button
		end

		local function CreateDropDown(choices, currentChoice, readOnly, onClick)
			local frame = Instance.new("Frame")	
			frame.Name = "DropDown"
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundTransparency = 1
			frame.Active = true

			local menu = nil
			local arrow = nil
			local expanded = false
			local margin = DropDown.BorderSizePixel;

			local button = Instance.new("TextButton")
			button.Font = Row.Font
			button.FontSize = Row.FontSize
			button.TextXAlignment = Row.TextXAlignment
			button.BackgroundTransparency = 1
			button.TextColor3 = Row.TextColor
			if readOnly then
				button.TextColor3 = Row.TextLockedColor
			end
			button.Text = currentChoice
			button.Size = UDim2.new(1, -2 * Styles.Margin, 1, 0)
			button.Position = UDim2.new(0, Styles.Margin, 0, 0)
			button.Parent = frame

			local function showArrow(color)
				if arrow then arrow:Destroy() end

				local graphicTemplate = Create('Frame',{
					Name="Graphic";
					BorderSizePixel = 0;
					BackgroundColor3 = color;
				})
				local graphicSize = 16/2

				arrow = ArrowGraphic(graphicSize,'Down',true,graphicTemplate)
				arrow.Position = UDim2.new(1,-graphicSize * 2,0.5,-graphicSize/2)
				arrow.Parent = frame
			end

			local function hideMenu()
				expanded = false
				showArrow(DropDown.ArrowColor)
				if menu then menu:Destroy() end
			end

			local function showMenu()
				expanded = true
				menu = Instance.new("Frame")
				menu.Size = UDim2.new(1, -2 * margin, 0, #choices * DropDown.Height)
				menu.Position = UDim2.new(0, margin, 0, Row.Height + margin)
				menu.BackgroundTransparency = 0
				menu.BackgroundColor3 = DropDown.BackColor
				menu.BorderColor3 = DropDown.BorderColor
				menu.BorderSizePixel = DropDown.BorderSizePixel
				menu.Active = true
				menu.ZIndex = 5
				menu.Parent = frame

				local parentFrameHeight = menu.Parent.Parent.Parent.Parent.Size.Y.Offset
				local rowHeight = menu.Parent.Parent.Parent.Position.Y.Offset
				if (rowHeight + menu.Size.Y.Offset) > math.max(parentFrameHeight,PropertiesFrame.AbsoluteSize.y) then
					menu.Position = UDim2.new(0, margin, 0, -1 * (#choices * DropDown.Height) - margin)
				end

				local function choice(name)
					onClick(name)
					hideMenu()
				end

				for i,name in pairs(choices) do
					local option = CreateDropDownItem(name, function()
						choice(name)
					end)
					option.Size = UDim2.new(1, 0, 0, 16)
					option.Position = UDim2.new(0, 0, 0, (i - 1) * DropDown.Height)
					option.ZIndex = menu.ZIndex
					option.Parent = menu
				end
			end

			showArrow(DropDown.ArrowColor)

			if not readOnly then

				button.MouseEnter:connect(function()
					button.TextColor3 = Row.TextColor
					showArrow(DropDown.ArrowColorOver)
				end)
				button.MouseLeave:connect(function()
					button.TextColor3 = Row.TextColor
					if not expanded then
						showArrow(DropDown.ArrowColor)
					end
				end)
				button.MouseButton1Click:connect(function()
					if expanded then
						hideMenu()
					else
						showMenu()
					end
				end)
			end

			return frame,button
		end

		local function CreateBrickColor(readOnly, onClick)
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,0,1,0)
			frame.BackgroundTransparency = 1

			local colorPalette = Instance.new("Frame")
			colorPalette.BackgroundTransparency = 0
			colorPalette.SizeConstraint = Enum.SizeConstraint.RelativeXX
			colorPalette.Size = UDim2.new(1, -2 * BrickColors.OuterBorder, 1, -2 * BrickColors.OuterBorder)
			colorPalette.BorderSizePixel = BrickColors.BorderSizePixel
			colorPalette.BorderColor3 = BrickColors.BorderColor
			colorPalette.Position = UDim2.new(0, BrickColors.OuterBorder, 0, BrickColors.OuterBorder + Row.Height)
			colorPalette.ZIndex = 5
			colorPalette.Visible = false
			colorPalette.BorderSizePixel = BrickColors.OuterBorder
			colorPalette.BorderColor3 = BrickColors.OuterBorderColor
			colorPalette.Parent = frame

			local function show()
				colorPalette.Visible = true
			end

			local function hide()
				colorPalette.Visible = false
			end

			local function toggle()
				colorPalette.Visible = not colorPalette.Visible
			end

			local colorBox = Instance.new("TextButton", frame)
			colorBox.Position = UDim2.new(0, Styles.Margin, 0, Styles.Margin)
			colorBox.Size = UDim2.new(0, BrickColors.BoxSize, 0, BrickColors.BoxSize)
			colorBox.Text = ""
			colorBox.MouseButton1Click:connect(function()
				if not readOnly then
					toggle()
				end
			end)

			if readOnly then
				colorBox.AutoButtonColor = false
			end

			local spacingBefore = (Styles.Margin * 2) + BrickColors.BoxSize

			local propertyLabel = CreateTextButton(readOnly, function()
				if not readOnly then
					toggle()
				end
			end)
			propertyLabel.Size = UDim2.new(1, (-1 * spacingBefore) - Styles.Margin, 1, 0)
			propertyLabel.Position = UDim2.new(0, spacingBefore, 0, 0)
			propertyLabel.Parent = frame

			local size = (1 / BrickColors.ColorsPerRow)

			for index = 0, 127 do
				local brickColor = BrickColor.palette(index)
				local color3 = brickColor.Color

				local x = size * (index % BrickColors.ColorsPerRow)
				local y = size * math.floor(index / BrickColors.ColorsPerRow)

				local brickColorBox = Instance.new("TextButton")
				brickColorBox.Text = ""
				brickColorBox.Size = UDim2.new(size,0,size,0)
				brickColorBox.BackgroundColor3 = color3
				brickColorBox.Position = UDim2.new(x, 0, y, 0)
				brickColorBox.ZIndex = colorPalette.ZIndex
				brickColorBox.Parent = colorPalette

				brickColorBox.MouseButton1Click:connect(function()
					hide()
					onClick(brickColor)
				end)
			end

			return frame,propertyLabel,colorBox
		end

		local function CreateColor3Control(readOnly, onClick)
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,0,1,0)
			frame.BackgroundTransparency = 1

			local colorBox = Instance.new("TextButton", frame)
			colorBox.Position = UDim2.new(0, Styles.Margin, 0, Styles.Margin)
			colorBox.Size = UDim2.new(0, BrickColors.BoxSize, 0, BrickColors.BoxSize)
			colorBox.Text = ""
			colorBox.AutoButtonColor = false

			local spacingBefore = (Styles.Margin * 2) + BrickColors.BoxSize
			local box = CreateTextBox(readOnly)
			box.Size = UDim2.new(1, (-1 * spacingBefore) - Styles.Margin, 1, 0)
			box.Position = UDim2.new(0, spacingBefore, 0, 0)
			box.Parent = frame

			return frame,box,colorBox
		end

		function CreateCheckbox(value, readOnly, onClick)
			local checked = value
			local mouseover = false

			local checkboxFrame = Instance.new("ImageButton")
			checkboxFrame.Size = UDim2.new(0, Sprite.Width, 0, Sprite.Height)
			checkboxFrame.BackgroundTransparency = 1
			checkboxFrame.ClipsDescendants = true
			--checkboxFrame.Position = UDim2.new(0, Styles.Margin, 0, Styles.Margin)

			local spritesheetImage = Instance.new("ImageLabel", checkboxFrame)
			spritesheetImage.Name = "SpritesheetImageLabel"
			spritesheetImage.Size = UDim2.new(0, Spritesheet.Width, 0, Spritesheet.Height)
			spritesheetImage.Image = Spritesheet.Image
			spritesheetImage.BackgroundTransparency = 1

			local function updateSprite()
				local spriteName = GetCheckboxImageName(checked, readOnly, mouseover)
				local spritePosition = SpritePosition(spriteName)
				spritesheetImage.Position = UDim2.new(0, -1 * spritePosition[1], 0, -1 * spritePosition[2])
			end

			local function setValue(val)
				checked = val
				updateSprite()
			end

			if not readOnly then
				checkboxFrame.MouseEnter:connect(function() mouseover = true updateSprite() end)
				checkboxFrame.MouseLeave:connect(function() mouseover = false updateSprite() end)
				checkboxFrame.MouseButton1Click:connect(function()
					onClick(checked)
				end)
			end

			updateSprite()

			return checkboxFrame, setValue
		end



		-- Code for handling controls of various data types --

		local getProperty = function(obj,name,isAtr)
			if(isAtr) then
				return obj:GetAttribute(name)
			else
				return obj[name]
			end
		end
		local Controls = {}

		Controls["default"] = function(object, propertyData, readOnly,isAttribute)
			local propertyName = propertyData["Name"]
			local propertyType = propertyData["ValueType"]

			local box = CreateTextBox(readOnly)
			box.Size = UDim2.new(1, -2 * Styles.Margin, 1, 0)
			box.Position = UDim2.new(0, Styles.Margin, 0, 0)

			local function update()
				local value = getProperty(object,propertyName,isAttribute)
				box.Text = ToString(value, propertyType)
			end

			if not readOnly then
				box.FocusLost:connect(function(enterPressed)
					Set(object, propertyData, ToValue(box.Text,propertyType), isAttribute)
					update()
				end)
			end

			update()

			if(not isAttribute) then
				object.Changed:connect(function(property)
					if (property == propertyName) then
						update()
					end
				end)
			else
				object:GetAttributeChangedSignal(propertyName):Connect(update);
			end

			return box
		end

		Controls["bool"] = function(object, propertyData, readOnly,isAttribute)
			local propertyName = propertyData["Name"]
			local checked = getProperty(object,propertyName,isAttribute)

			local checkbox, setValue = CreateCheckbox(checked, readOnly, function(value)
				Set(object, propertyData, not checked,isAttribute)
			end)
			checkbox.Position = UDim2.new(0, Styles.Margin, 0, Styles.Margin)

			setValue(checked)

			local function update()
				checked = getProperty(object,propertyName,isAttribute)
				setValue(checked)
			end

			if(not isAttribute) then
				object.Changed:connect(function(property)
					if (property == propertyName) then
						update()
					end
				end)
			else
				object:GetAttributeChangedSignal(propertyName):Connect(update);
			end

			if object:IsA("BoolValue") and not isAttribute then
				object.Changed:connect(function(val)
					update()
				end)
			end

			update()

			return checkbox
		end

		Controls["BrickColor"] = function(object, propertyData, readOnly,isAttribute)
			local propertyName = propertyData["Name"]

			local frame,label,brickColorBox = CreateBrickColor(readOnly, function(brickColor)
				Set(object, propertyData, brickColor, isAttribute)
			end)

			local function update()
				local value = getProperty(object,propertyName,isAttribute)
				brickColorBox.BackgroundColor3 = value.Color
				label.Text = tostring(value)
			end

			update()

			if(not isAttribute) then
				object.Changed:connect(function(property)
					if (property == propertyName) then
						update()
					end
				end)
			else
				object:GetAttributeChangedSignal(propertyName):Connect(update);
			end
			return frame
		end

		Controls["Color3"] = function(object, propertyData, readOnly,isAttribute)
			local propertyName = propertyData["Name"]

			local frame,textBox,colorBox = CreateColor3Control(readOnly)

			textBox.FocusLost:connect(function(enterPressed)
				Set(object, propertyData, ToValue(textBox.Text,"Color3"),isAttribute)
				local value = getProperty(object,propertyName,isAttribute)
				colorBox.BackgroundColor3 = value
				textBox.Text = ToString(value, "Color3")
			end)

			local function update()
				local value = getProperty(object,propertyName,isAttribute)
				colorBox.BackgroundColor3 = value
				textBox.Text = ToString(value, "Color3")
			end

			update()

			if(not isAttribute) then
				object.Changed:connect(function(property)
					if (property == propertyName) then
						update()
					end
				end)
			else
				object:GetAttributeChangedSignal(propertyName):Connect(update);
			end

			return frame
		end

		Controls["Enum"] = function(object, propertyData, readOnly)
			local propertyName = propertyData["Name"]
			local propertyType = propertyData["ValueType"]

			local enumName = object[propertyName].Name

			local enumNames = {}
			for _,enum in pairs(Enum[tostring(propertyType)]:GetEnumItems()) do
				table.insert(enumNames, enum.Name)
			end

			local dropdown, propertyLabel = CreateDropDown(enumNames, enumName, readOnly, function(value)
				Set(object, propertyData, value)
			end)
			--dropdown.Parent = frame

			local function update()
				local value = object[propertyName].Name
				propertyLabel.Text = tostring(value)
			end

			update()

			object.Changed:connect(function(property)
				if (property == propertyName) then
					update()
				end
			end)


			return dropdown
		end

		Controls["Object"] = function(object, propertyData, readOnly)
			local propertyName = propertyData["Name"]
			local propertyType = propertyData["ValueType"]

			local box = CreateObject(readOnly,function()end)
			box.Size = UDim2.new(1, -2 * Styles.Margin, 1, 0)
			box.Position = UDim2.new(0, Styles.Margin, 0, 0)

			local function update()
				if AwaitingObjectObj == object then
					if AwaitingObjectValue == true then
						box.Text = "Select an Object"
						return
					end
				end
				local value = object[propertyName]
				box.Text = ToString(value, propertyType)
			end

			if not readOnly then
				box.MouseButton1Click:connect(function()
					if AwaitingObjectValue then
						AwaitingObjectValue = false
						update()
						return
					end
					AwaitingObjectValue = true
					AwaitingObjectObj = object
					AwaitingObjectProp = propertyData
					box.Text = "Select an Object"
				end)

				box.Cancel.Visible = true
				box.Cancel.MouseButton1Click:connect(function()
					object[propertyName] = nil
				end)
			end

			update()

			object.Changed:connect(function(property)
				if (property == propertyName) then
					update()
				end
			end)

			if object:IsA("ObjectValue") then
				object.Changed:connect(function(val)
					update()
				end)
			end

			return box
		end

		function GetControl(object, propertyData, readOnly,attr)
			local propertyType = propertyData["ValueType"]
			local control = nil

			if Controls[propertyType] then
				control = Controls[propertyType](object, propertyData, readOnly,attr)
			elseif RbxApi.IsEnum(propertyType) then
				control = Controls["Enum"](object, propertyData, readOnly,attr)
			elseif RbxApi.Classes[propertyType] then
				control = Controls["Object"](object, propertyData, readOnly,attr)
			else
				control = Controls["default"](object, propertyData, readOnly,attr)
			end
			return control
		end
		-- Permissions

		function CanEditObject(object)
			local player = Players.LocalPlayer
			local character = player.Character
			return Permissions.CanEdit
		end

		function CanEditProperty(object,propertyData)
			local tags = propertyData["tags"]
			for _,name in pairs(tags) do
				if name == "readonly" then
					return false
				end
			end
			return CanEditObject(object)
		end

		--RbxApi
		local function PropertyIsHidden(propertyData)
			local tags = propertyData["tags"]
			for _,name in pairs(tags) do
				local name = name:lower()
				if name == "deprecated"
					or name == "hidden"
					or name == "writeonly" then
					return true
				end
			end
			return false
		end

		function Set(object, propertyData, value,attribute)
			local propertyName = propertyData["Name"]
			local propertyType = propertyData["ValueType"]

			if value == nil then return end

			for i,v in pairs(GetSelection()) do
				if CanEditProperty(v,propertyData) then
					if(not attribute) then
						pcall(function()
							--print("Setting " .. propertyName .. " to " .. tostring(value))
							v[propertyName] = value
						end)
					else
						pcall(function()
							v:SetAttribute(propertyName,value)
						end)
					end
				end
			end
		end

		function CreateRow(object, propertyData, isAlternateRow,isAttribute)
			local propertyName = propertyData["Name"]
			local propertyType = propertyData["ValueType"]
			local propertyValue = not isAttribute and object[propertyName] or object:GetAttribute(propertyName)
			--rowValue, rowValueType, isAlternate
			local backColor = Row.BackgroundColor;
			if (isAlternateRow) then
				backColor = Row.BackgroundColorAlternate
			end

			local readOnly = not CanEditProperty(object, propertyData)
			--if propertyType == "Instance" or propertyName == "Parent" then readOnly = true end

			local rowFrame = Instance.new("Frame")
			rowFrame.Size = UDim2.new(1,0,0,Row.Height)
			rowFrame.BackgroundTransparency = 1
			rowFrame.Name = 'Row'

			local propertyLabelFrame = CreateCell()
			propertyLabelFrame.Parent = rowFrame
			propertyLabelFrame.ClipsDescendants = true

			local propertyLabel = CreateLabel(readOnly)
			propertyLabel.Text = propertyName
			propertyLabel.Size = UDim2.new(1, -1 * Row.TitleMarginLeft, 1, 0)
			propertyLabel.Position = UDim2.new(0, Row.TitleMarginLeft, 0, 0)
			propertyLabel.Parent = propertyLabelFrame

			local propertyValueFrame = CreateCell()
			propertyValueFrame.Size = UDim2.new(0.5, -1, 1, 0)
			propertyValueFrame.Position = UDim2.new(0.5, 0, 0, 0)
			propertyValueFrame.Parent = rowFrame

			local control = GetControl(object, propertyData, readOnly, isAttribute)
			control.Parent = propertyValueFrame

			rowFrame.MouseEnter:connect(function()
				propertyLabelFrame.BackgroundColor3 = Row.BackgroundColorMouseover
				propertyValueFrame.BackgroundColor3 = Row.BackgroundColorMouseover
			end)
			rowFrame.MouseLeave:connect(function()
				propertyLabelFrame.BackgroundColor3 = backColor
				propertyValueFrame.BackgroundColor3 = backColor
			end)
			rowFrame.InputEnded:connect(function(input)
				if input.UserInputType.Name == 'MouseButton1' and UIS:IsKeyDown'LeftControl' then
					if	input.Position.X > rowFrame.AbsolutePosition.X and
						input.Position.Y > rowFrame.AbsolutePosition.Y and
						input.Position.X < rowFrame.AbsolutePosition.X + rowFrame.AbsoluteSize.X and
						input.Position.Y < rowFrame.AbsolutePosition.Y + rowFrame.AbsoluteSize.Y then 
						local s,e = pcall(setclipboard, tostring(object[propertyName]))
					end
				end
			end)

			propertyLabelFrame.BackgroundColor3 = backColor
			propertyValueFrame.BackgroundColor3 = backColor

			return rowFrame
		end

		function ClearPropertiesList()
			for _,instance in pairs(ContentFrame:GetChildren()) do
				instance:Destroy()
			end
		end

		local selection = Gui:FindFirstChild("Selection", 1)

		local getObjectFrom = function(a)
			for i = 1,#a do
				return a[i]["object"];
			end
		end

		local scroller = PropertiesFrame:WaitForChild("AttributesFrame"):WaitForChild("Scroller");
		local list  = {};
		local tb = scroller.Parent:WaitForChild("Header"):WaitForChild("TextBox");

		local search = function()
			local q = tb.Text;
			for name,frame in pairs(list) do
				if(q == "") then
					frame.Visible = true;
				else
					frame.Visible = (name:sub(1,#q) == q)
				end
			end 
			local acs = scroller.UIListLayout.AbsoluteContentSize
			scroller.CanvasSize = UDim2.fromOffset(acs.X,acs.Y);
		end

		tb:GetPropertyChangedSignal("Text"):Connect(search)

		function displayProperties(props)
			for _,v in pairs(scroller:GetChildren()) do
				if(v:IsA("Frame")) then
					v:Destroy();
				end
			end
			for i,v in pairs(props) do
				pcall(function()
					local a = CreateRow(v.object, v.propertyData, ((numRows % 2) == 0))
					a.Position = UDim2.new(0,0,0,numRows*Row.Height)
					a.Parent = ContentFrame
					numRows = numRows + 1
				end)
			end
			local object = getObjectFrom(props);
			local success,attributes = pcall(function()
				return object:GetAttributes();
			end)
			local filter = function(a)
				return(a == "boolean" and "bool" or a)
			end
			if(attributes and success) then
				list = {};
				for name,attribute in pairs(attributes) do
					local a = CreateRow(object, {
						["ValueType"] = filter(typeof(attribute)),
						["Name"] = name,
						["tags"] = {}
					}, ((numRows % 2) == 0),true)
					a.Parent = scroller;
					a.Name = name
					list[name] = a;
				end
				local acs = scroller.UIListLayout.AbsoluteContentSize
				scroller.CanvasSize = UDim2.fromOffset(acs.X,acs.Y);
				search()
			end
		end

		function checkForDupe(prop,props)
			for i,v in pairs(props) do
				if v.propertyData.Name == prop.Name and v.propertyData.ValueType == prop.ValueType then
					return true
				end
			end
			return false
		end

		function sortProps(t)
			table.sort(t, 
				function(x,y) return x.propertyData.Name < y.propertyData.Name
				end)
		end

		function showProperties(obj)
			ClearPropertiesList()
			if obj == nil then return end
			local propHolder = {}
			local foundProps = {}
			numRows = 0
			for _,nextObj in pairs(obj) do
				if not foundProps[nextObj.className] then
					foundProps[nextObj.className] = true
					for i,v in pairs(RbxApi.GetProperties(nextObj.className)) do
						local suc, err = pcall(function()
							if not (PropertyIsHidden(v)) and not checkForDupe(v,propHolder) then
								if string.find(string.lower(v.Name),string.lower(propertiesSearch.Text)) or not searchingProperties() then
									table.insert(propHolder,{propertyData = v, object = nextObj})
								end
							end
						end)
				--[[if not suc then 
					warn("Problem getting the value of property " .. v.Name .. " | " .. err)
				end	--]]
					end
				end
			end
			sortProps(propHolder)
			displayProperties(propHolder,obj)
			ContentFrame.Size = UDim2.new(1, 0, 0, numRows * Row.Height)
			scrollBar.ScrollIndex = 0
			scrollBar.TotalSpace = numRows * Row.Height
			scrollBar.Update()
		end

		----------------------------------------------------------------
		-----------------------SCROLLBAR STUFF--------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		local ScrollBarWidth = 16

		local ScrollStyles = {
			Background      = Color3.fromRGB(43, 43, 43);
			Border          = Color3.fromRGB(20, 20, 20);
			Selected        = Color3.fromRGB(5, 102, 141);
			BorderSelected  = Color3.fromRGB(2, 128, 144);
			Text            = Color3.fromRGB(245, 245, 245);
			TextDisabled    = Color3.fromRGB(188, 188, 188);
			TextSelected    = Color3.fromRGB(255, 255, 255);
			Button          = Color3.fromRGB(33, 33, 33);
			ButtonBorder    = Color3.fromRGB(133, 133, 133);
			ButtonSelected  = Color3.fromRGB(0, 168, 150);
			Field           = Color3.fromRGB(43, 43, 43);
			FieldBorder     = Color3.fromRGB(50, 50, 50);
			TitleBackground = Color3.fromRGB(11, 11, 11);
		}
		do
			local ZIndexLock = {}
			function SetZIndex(object,z)
				if not ZIndexLock[object] then
					ZIndexLock[object] = true
					if object:IsA'GuiObject' then
						object.ZIndex = z
					end
					local children = object:GetChildren()
					for i = 1,#children do
						SetZIndex(children[i],z)
					end
					ZIndexLock[object] = nil
				end
			end
		end
		function SetZIndexOnChanged(object)
			return object.Changed:connect(function(p)
				if p == "ZIndex" then
					SetZIndex(object,object.ZIndex)
				end
			end)
		end
		function Create(ty,data)
			local obj
			if type(ty) == 'string' then
				obj = Instance.new(ty)
			else
				obj = ty
			end
			for k, v in pairs(data) do
				if type(k) == 'number' then
					v.Parent = obj
				else
					obj[k] = v
				end
			end
			return obj
		end
		-- returns the ascendant ScreenGui of an object
		function GetScreen(screen)
			if screen == nil then return nil end
			while not screen:IsA("ScreenGui") do
				screen = screen.Parent
				if screen == nil then return nil end
			end
			return screen
		end
		-- AutoButtonColor doesn't always reset properly
		function ResetButtonColor(button)
			local active = button.Active
			button.Active = not active
			button.Active = active
		end

		function ArrowGraphic(size,dir,scaled,template)
			local Frame = Create('Frame',{
				Name = "Arrow Graphic";
				BorderSizePixel = 0;
				Size = UDim2.new(0,size,0,size);
				Transparency = 1;
			})
			if not template then
				template = Instance.new("Frame")
				template.BorderSizePixel = 0
			end

			template.BackgroundColor3 = Color3.new(1, 1, 1);

			local transform
			if dir == nil or dir == 'Up' then
				function transform(p,s) return p,s end
			elseif dir == 'Down' then
				function transform(p,s) return UDim2.new(0,p.X.Offset,0,size-p.Y.Offset-1),s end
			elseif dir == 'Left' then
				function transform(p,s) return UDim2.new(0,p.Y.Offset,0,p.X.Offset),UDim2.new(0,s.Y.Offset,0,s.X.Offset) end
			elseif dir == 'Right' then
				function transform(p,s) return UDim2.new(0,size-p.Y.Offset-1,0,p.X.Offset),UDim2.new(0,s.Y.Offset,0,s.X.Offset) end
			end

			local scale
			if scaled then
				function scale(p,s) return UDim2.new(p.X.Offset/size,0,p.Y.Offset/size,0),UDim2.new(s.X.Offset/size,0,s.Y.Offset/size,0) end
			else
				function scale(p,s) return p,s end
			end

			local o = math.floor(size/4)
			if size%2 == 0 then
				local n = size/2-1
				for i = 0,n do
					local t = template:Clone()
					local p,s = scale(transform(
						UDim2.new(0,n-i,0,o+i),
						UDim2.new(0,(i+1)*2,0,1)
						))
					t.Position = p
					t.Size = s
					t.Parent = Frame
				end
			else
				local n = (size-1)/2
				for i = 0,n do
					local t = template:Clone()
					local p,s = scale(transform(
						UDim2.new(0,n-i,0,o+i),
						UDim2.new(0,i*2+1,0,1)
						))
					t.Position = p
					t.Size = s
					t.Parent = Frame
				end
			end
			if size%4 > 1 then
				local t = template:Clone()
				local p,s = scale(transform(
					UDim2.new(0,0,0,size-o-1),
					UDim2.new(0,size,0,1)
					))
				t.Position = p
				t.Size = s
				t.Parent = Frame
			end

			for i,v in pairs(Frame:GetChildren()) do
				v.BackgroundColor3 = Color3.new(1, 1, 1);
			end

			return Frame
		end

		function GripGraphic(size,dir,spacing,scaled,template)
			local Frame = Create('Frame',{
				Name = "Grip Graphic";
				BorderSizePixel = 0;
				Size = UDim2.new(0,size.x,0,size.y);
				Transparency = 1;
			})
			if not template then
				template = Instance.new("Frame")
				template.BorderSizePixel = 0
			end

			spacing = spacing or 2

			local scale
			if scaled then
				function scale(p) return UDim2.new(p.X.Offset/size.x,0,p.Y.Offset/size.y,0) end
			else
				function scale(p) return p end
			end

			if dir == 'Vertical' then
				for i=0,size.x-1,spacing do
					local t = template:Clone()
					t.Size = scale(UDim2.new(0,1,0,size.y))
					t.Position = scale(UDim2.new(0,i,0,0))
					t.Parent = Frame
				end
			elseif dir == nil or dir == 'Horizontal' then
				for i=0,size.y-1,spacing do
					local t = template:Clone()
					t.Size = scale(UDim2.new(0,size.x,0,1))
					t.Position = scale(UDim2.new(0,0,0,i))
					t.Parent = Frame
				end
			end

			return Frame
		end

		do
			local mt = {
				__index = {
					GetScrollPercent = function(self)
						return self.ScrollIndex/(self.TotalSpace-self.VisibleSpace)
					end;
					CanScrollDown = function(self)
						return self.ScrollIndex + self.VisibleSpace < self.TotalSpace
					end;
					CanScrollUp = function(self)
						return self.ScrollIndex > 0
					end;
					ScrollDown = function(self)
						self.ScrollIndex = self.ScrollIndex + self.PageIncrement
						self:Update()
					end;
					ScrollUp = function(self)
						self.ScrollIndex = self.ScrollIndex - self.PageIncrement
						self:Update()
					end;
					ScrollTo = function(self,index)
						self.ScrollIndex = index
						self:Update()
					end;
					SetScrollPercent = function(self,percent)
						self.ScrollIndex = math.floor((self.TotalSpace - self.VisibleSpace)*percent + 0.5)
						self:Update()
					end;
				};
			}
			mt.__index.CanScrollRight = mt.__index.CanScrollDown
			mt.__index.CanScrollLeft = mt.__index.CanScrollUp
			mt.__index.ScrollLeft = mt.__index.ScrollUp
			mt.__index.ScrollRight = mt.__index.ScrollDown

			function ScrollBar(horizontal)
				-- create row scroll bar
				local ScrollFrame = Create('Frame',{
					Name = "ScrollFrame";
					Position = horizontal and UDim2.new(0,0,1,-ScrollBarWidth) or UDim2.new(1,-ScrollBarWidth,0,0);
					Size = horizontal and UDim2.new(1,0,0,ScrollBarWidth) or UDim2.new(0,ScrollBarWidth,1,0);
					BackgroundTransparency = 1;
					Create('ImageButton',{
						Name = "ScrollDown";
						Position = horizontal and UDim2.new(1,-ScrollBarWidth,0,0) or UDim2.new(0,0,1,-ScrollBarWidth);
						Size = UDim2.new(0, ScrollBarWidth, 0, ScrollBarWidth);
						BackgroundColor3 = ScrollStyles.Button;
						BorderColor3 = ScrollStyles.Border;
						ImageColor3 = Styles.White;
						--BorderSizePixel = 0;
					});
					Create('ImageButton',{
						Name = "ScrollUp";
						Size = UDim2.new(0, ScrollBarWidth, 0, ScrollBarWidth);
						BackgroundColor3 = ScrollStyles.Button;
						BorderColor3 = ScrollStyles.Border;
						ImageColor3 = Styles.White;
						--BorderSizePixel = 0;
					});
					Create('ImageButton',{
						Name = "ScrollBar";
						Size = horizontal and UDim2.new(1,-ScrollBarWidth*2,1,0) or UDim2.new(1,0,1,-ScrollBarWidth*2);
						Position = horizontal and UDim2.new(0,ScrollBarWidth,0,0) or UDim2.new(0,0,0,ScrollBarWidth);
						AutoButtonColor = false;
						BackgroundColor3 = Color3.new(1/4, 1/4, 1/4);
						BorderColor3 = ScrollStyles.Border;
						--BorderSizePixel = 0;
						Create('ImageButton',{
							Name = "ScrollThumb";
							AutoButtonColor = false;
							Size = UDim2.new(0, ScrollBarWidth, 0, ScrollBarWidth);
							BackgroundColor3 = ScrollStyles.Button;
							BorderColor3 = ScrollStyles.Border;
							ImageColor3 = Styles.White;
							--BorderSizePixel = 0;
						});
					});
				})

				local graphicTemplate = Create('Frame',{
					Name="Graphic";
					BorderSizePixel = 0;
					BackgroundColor3 = Color3.new(1, 1, 1);
				})
				local graphicSize = ScrollBarWidth/2

				local ScrollDownFrame = ScrollFrame.ScrollDown
				local ScrollDownGraphic = ArrowGraphic(graphicSize,horizontal and 'Right' or 'Down',true,graphicTemplate)
				ScrollDownGraphic.Position = UDim2.new(0.5,-graphicSize/2,0.5,-graphicSize/2)
				ScrollDownGraphic.Parent = ScrollDownFrame
				local ScrollUpFrame = ScrollFrame.ScrollUp
				local ScrollUpGraphic = ArrowGraphic(graphicSize,horizontal and 'Left' or 'Up',true,graphicTemplate)
				ScrollUpGraphic.Position = UDim2.new(0.5,-graphicSize/2,0.5,-graphicSize/2)
				ScrollUpGraphic.Parent = ScrollUpFrame
				local ScrollBarFrame = ScrollFrame.ScrollBar
				local ScrollThumbFrame = ScrollBarFrame.ScrollThumb
				do
					local size = ScrollBarWidth*3/8
					local Decal = GripGraphic(Vector2.new(size,size),horizontal and 'Vertical' or 'Horizontal',2,graphicTemplate)
					Decal.Position = UDim2.new(0.5,-size/2,0.5,-size/2)
					Decal.Parent = ScrollThumbFrame
				end

				local MouseDrag = Create('ImageButton',{
					Name = "MouseDrag";
					Position = UDim2.new(-0.25,0,-0.25,0);
					Size = UDim2.new(1.5,0,1.5,0);
					Transparency = 1;
					AutoButtonColor = false;
					Active = true;
					ZIndex = 10;
				})

				local Class = setmetatable({
					GUI = ScrollFrame;
					ScrollIndex = 0;
					VisibleSpace = 0;
					TotalSpace = 0;
					PageIncrement = 1;
				},mt)

				local UpdateScrollThumb
				if horizontal then
					function UpdateScrollThumb()
						ScrollThumbFrame.Size = UDim2.new(Class.VisibleSpace/Class.TotalSpace,0,0,ScrollBarWidth)
						if ScrollThumbFrame.AbsoluteSize.x < ScrollBarWidth then
							ScrollThumbFrame.Size = UDim2.new(0,ScrollBarWidth,0,ScrollBarWidth)
						end
						local barSize = ScrollBarFrame.AbsoluteSize.x
						ScrollThumbFrame.Position = UDim2.new(Class:GetScrollPercent()*(barSize - ScrollThumbFrame.AbsoluteSize.x)/barSize,0,0,0)
					end
				else
					function UpdateScrollThumb()
						ScrollThumbFrame.Size = UDim2.new(0,ScrollBarWidth,Class.VisibleSpace/Class.TotalSpace,0)
						if ScrollThumbFrame.AbsoluteSize.y < ScrollBarWidth then
							ScrollThumbFrame.Size = UDim2.new(0,ScrollBarWidth,0,ScrollBarWidth)
						end
						local barSize = ScrollBarFrame.AbsoluteSize.y
						ScrollThumbFrame.Position = UDim2.new(0,0,Class:GetScrollPercent()*(barSize - ScrollThumbFrame.AbsoluteSize.y)/barSize,0)
					end
				end

				local lastDown
				local lastUp
				local scrollStyle = {BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=0}
				local scrollStyle_ds = {BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=0.7}

				local function Update()
					local t = Class.TotalSpace
					local v = Class.VisibleSpace
					local s = Class.ScrollIndex
					if v <= t then
						if s > 0 then
							if s + v > t then
								Class.ScrollIndex = t - v
							end
						else
							Class.ScrollIndex = 0
						end
					else
						Class.ScrollIndex = 0
					end

					if Class.UpdateCallback then
						if Class.UpdateCallback(Class) == false then
							return
						end
					end

					local down = Class:CanScrollDown()
					local up = Class:CanScrollUp()
					if down ~= lastDown then
						lastDown = down
						ScrollDownFrame.Active = down
						ScrollDownFrame.AutoButtonColor = down
						local children = ScrollDownGraphic:GetChildren()
						local style = down and scrollStyle or scrollStyle_ds
						for i = 1,#children do
							Create(children[i],style)
						end
					end
					if up ~= lastUp then
						lastUp = up
						ScrollUpFrame.Active = up
						ScrollUpFrame.AutoButtonColor = up
						local children = ScrollUpGraphic:GetChildren()
						local style = up and scrollStyle or scrollStyle_ds
						for i = 1,#children do
							Create(children[i],style)
						end
					end
					ScrollThumbFrame.Visible = down or up
					UpdateScrollThumb()
				end
				Class.Update = Update

				SetZIndexOnChanged(ScrollFrame)

				local scrollEventID = 0
				ScrollDownFrame.MouseButton1Down:connect(function()
					scrollEventID = tick()
					local current = scrollEventID
					local up_con
					up_con = MouseDrag.MouseButton1Up:connect(function()
						scrollEventID = tick()
						MouseDrag.Parent = nil
						ResetButtonColor(ScrollDownFrame)
						up_con:disconnect(); drag = nil
					end)
					MouseDrag.Parent = GetScreen(ScrollFrame)
					Class:ScrollDown()
					wait(0.2) -- delay before auto scroll
					while scrollEventID == current do
						Class:ScrollDown()
						if not Class:CanScrollDown() then break end
						wait()
					end
				end)

				ScrollDownFrame.MouseButton1Up:connect(function()
					scrollEventID = tick()
				end)

				ScrollUpFrame.MouseButton1Down:connect(function()
					scrollEventID = tick()
					local current = scrollEventID
					local up_con
					up_con = MouseDrag.MouseButton1Up:connect(function()
						scrollEventID = tick()
						MouseDrag.Parent = nil
						ResetButtonColor(ScrollUpFrame)
						up_con:disconnect(); drag = nil
					end)
					MouseDrag.Parent = GetScreen(ScrollFrame)
					Class:ScrollUp()
					wait(0.2)
					while scrollEventID == current do
						Class:ScrollUp()
						if not Class:CanScrollUp() then break end
						wait()
					end
				end)

				ScrollUpFrame.MouseButton1Up:connect(function()
					scrollEventID = tick()
				end)

				if horizontal then
					ScrollBarFrame.MouseButton1Down:connect(function(x,y)
						scrollEventID = tick()
						local current = scrollEventID
						local up_con
						up_con = MouseDrag.MouseButton1Up:connect(function()
							scrollEventID = tick()
							MouseDrag.Parent = nil
							ResetButtonColor(ScrollUpFrame)
							up_con:disconnect(); drag = nil
						end)
						MouseDrag.Parent = GetScreen(ScrollFrame)
						if x > ScrollThumbFrame.AbsolutePosition.x then
							Class:ScrollTo(Class.ScrollIndex + Class.VisibleSpace)
							wait(0.2)
							while scrollEventID == current do
								if x < ScrollThumbFrame.AbsolutePosition.x + ScrollThumbFrame.AbsoluteSize.x then break end
								Class:ScrollTo(Class.ScrollIndex + Class.VisibleSpace)
								wait()
							end
						else
							Class:ScrollTo(Class.ScrollIndex - Class.VisibleSpace)
							wait(0.2)
							while scrollEventID == current do
								if x > ScrollThumbFrame.AbsolutePosition.x then break end
								Class:ScrollTo(Class.ScrollIndex - Class.VisibleSpace)
								wait()
							end
						end
					end)
				else
					ScrollBarFrame.MouseButton1Down:connect(function(x,y)
						scrollEventID = tick()
						local current = scrollEventID
						local up_con
						up_con = MouseDrag.MouseButton1Up:connect(function()
							scrollEventID = tick()
							MouseDrag.Parent = nil
							ResetButtonColor(ScrollUpFrame)
							up_con:disconnect(); drag = nil
						end)
						MouseDrag.Parent = GetScreen(ScrollFrame)
						if y > ScrollThumbFrame.AbsolutePosition.y then
							Class:ScrollTo(Class.ScrollIndex + Class.VisibleSpace)
							wait(0.2)
							while scrollEventID == current do
								if y < ScrollThumbFrame.AbsolutePosition.y + ScrollThumbFrame.AbsoluteSize.y then break end
								Class:ScrollTo(Class.ScrollIndex + Class.VisibleSpace)
								wait()
							end
						else
							Class:ScrollTo(Class.ScrollIndex - Class.VisibleSpace)
							wait(0.2)
							while scrollEventID == current do
								if y > ScrollThumbFrame.AbsolutePosition.y then break end
								Class:ScrollTo(Class.ScrollIndex - Class.VisibleSpace)
								wait()
							end
						end
					end)
				end

				if horizontal then
					ScrollThumbFrame.MouseButton1Down:connect(function(x,y)
						scrollEventID = tick()
						local mouse_offset = x - ScrollThumbFrame.AbsolutePosition.x
						local drag_con
						local up_con
						drag_con = MouseDrag.MouseMoved:connect(function(x,y)
							local bar_abs_pos = ScrollBarFrame.AbsolutePosition.x
							local bar_drag = ScrollBarFrame.AbsoluteSize.x - ScrollThumbFrame.AbsoluteSize.x
							local bar_abs_one = bar_abs_pos + bar_drag
							x = x - mouse_offset
							x = x < bar_abs_pos and bar_abs_pos or x > bar_abs_one and bar_abs_one or x
							x = x - bar_abs_pos
							Class:SetScrollPercent(x/(bar_drag))
						end)
						up_con = MouseDrag.MouseButton1Up:connect(function()
							scrollEventID = tick()
							MouseDrag.Parent = nil
							ResetButtonColor(ScrollThumbFrame)
							drag_con:disconnect(); drag_con = nil
							up_con:disconnect(); drag = nil
						end)
						MouseDrag.Parent = GetScreen(ScrollFrame)
					end)
				else
					ScrollThumbFrame.MouseButton1Down:connect(function(x,y)
						scrollEventID = tick()
						local mouse_offset = y - ScrollThumbFrame.AbsolutePosition.y
						local drag_con
						local up_con
						drag_con = MouseDrag.MouseMoved:connect(function(x,y)
							local bar_abs_pos = ScrollBarFrame.AbsolutePosition.y
							local bar_drag = ScrollBarFrame.AbsoluteSize.y - ScrollThumbFrame.AbsoluteSize.y
							local bar_abs_one = bar_abs_pos + bar_drag
							y = y - mouse_offset
							y = y < bar_abs_pos and bar_abs_pos or y > bar_abs_one and bar_abs_one or y
							y = y - bar_abs_pos
							Class:SetScrollPercent(y/(bar_drag))
						end)
						up_con = MouseDrag.MouseButton1Up:connect(function()
							scrollEventID = tick()
							MouseDrag.Parent = nil
							ResetButtonColor(ScrollThumbFrame)
							drag_con:disconnect(); drag_con = nil
							up_con:disconnect(); drag = nil
						end)
						MouseDrag.Parent = GetScreen(ScrollFrame)
					end)
				end

				function Class:Destroy()
					ScrollFrame:Destroy()
					MouseDrag:Destroy()
					for k in pairs(Class) do
						Class[k] = nil
					end
					setmetatable(Class,nil)
				end

				Update()

				return Class
			end
		end

		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------

		local MainFrame = Instance.new("Frame")
		MainFrame.Name = "MainFrame"
		MainFrame.Size = UDim2.new(1, -1 * ScrollBarWidth, 1, 0)
		MainFrame.Position = UDim2.new(0, 0, 0, 0)
		MainFrame.BackgroundTransparency = 1
		MainFrame.ClipsDescendants = true
		MainFrame.Parent = PropertiesFrame

		ContentFrame = Instance.new("Frame")
		ContentFrame.Name = "ContentFrame"
		ContentFrame.Size = UDim2.new(1, 0, 0, 0)
		ContentFrame.BackgroundTransparency = 1
		ContentFrame.Parent = MainFrame

		scrollBar = ScrollBar(false)
		scrollBar.PageIncrement = 1
		Create(scrollBar.GUI,{
			Position = UDim2.new(1,-ScrollBarWidth,0,0);
			Size = UDim2.new(0,ScrollBarWidth,1,0);
			Parent = PropertiesFrame;
		})

		scrollBarH = ScrollBar(true)
		scrollBarH.PageIncrement = ScrollBarWidth
		Create(scrollBarH.GUI,{
			Position = UDim2.new(0,0,1,-ScrollBarWidth);
			Size = UDim2.new(1,-ScrollBarWidth,0,ScrollBarWidth);
			Visible = false;
			Parent = PropertiesFrame;
		})

		do
			local listEntries = {}
			local nameConnLookup = {}

			function scrollBar.UpdateCallback(self)
				scrollBar.TotalSpace = ContentFrame.AbsoluteSize.Y
				scrollBar.VisibleSpace = MainFrame.AbsoluteSize.Y
				ContentFrame.Position = UDim2.new(ContentFrame.Position.X.Scale,ContentFrame.Position.X.Offset,0,-1*scrollBar.ScrollIndex)
			end

			function scrollBarH.UpdateCallback(self)

			end

			MainFrame.Changed:connect(function(p)
				if p == 'AbsoluteSize' then
					scrollBarH.VisibleSpace = math.ceil(MainFrame.AbsoluteSize.x)
					scrollBarH:Update()
					scrollBar.VisibleSpace = math.ceil(MainFrame.AbsoluteSize.y)
					scrollBar:Update()
				end
			end)

			local wheelAmount = Row.Height
			PropertiesFrame.MouseWheelForward:connect(function()
				if UIS:IsKeyDown'LeftShift' then
					if scrollBarH.VisibleSpace - 1 > wheelAmount then
						scrollBarH:ScrollTo(scrollBarH.ScrollIndex - wheelAmount)
					else
						scrollBarH:ScrollTo(scrollBarH.ScrollIndex - scrollBarH.VisibleSpace)
					end
				else
					if scrollBar.VisibleSpace - 1 > wheelAmount then
						scrollBar:ScrollTo(scrollBar.ScrollIndex - wheelAmount)
					else
						scrollBar:ScrollTo(scrollBar.ScrollIndex - scrollBar.VisibleSpace)
					end
				end
			end)
			PropertiesFrame.MouseWheelBackward:connect(function()
				if UIS:IsKeyDown'LeftShift' then
					if scrollBarH.VisibleSpace - 1 > wheelAmount then
						scrollBarH:ScrollTo(scrollBarH.ScrollIndex + wheelAmount)
					else
						scrollBarH:ScrollTo(scrollBarH.ScrollIndex + scrollBarH.VisibleSpace)
					end
				else
					if scrollBar.VisibleSpace - 1 > wheelAmount then
						scrollBar:ScrollTo(scrollBar.ScrollIndex + wheelAmount)
					else
						scrollBar:ScrollTo(scrollBar.ScrollIndex + scrollBar.VisibleSpace)
					end
				end
			end)
		end

		scrollBar.VisibleSpace = math.ceil(MainFrame.AbsoluteSize.y)
		scrollBar:Update()

		showProperties(GetSelection())

		bindSelectionChanged.Event:connect(function()
			showProperties(GetSelection())
		end)

		bindSetAwait.Event:connect(function(obj)
			if AwaitingObjectValue then
				AwaitingObjectValue = false
				local mySel = obj
				if mySel then
					pcall(function()
						Set(AwaitingObjectObj, AwaitingObjectProp, mySel)
					end)
				end
			end
		end)

		propertiesSearch.Changed:connect(function(prop)
			if prop == "Text" then
				showProperties(GetSelection())
			end
		end)

		bindGetApi.OnInvoke = function()
			return RbxApi
		end

		bindGetAwait.OnInvoke = function()
			return AwaitingObjectValue
		end
	end)

	spawn(function() -- Idk2
		-- initial states
		local Option = {
			-- can modify object parents in the hierarchy
			Modifiable = false;
			-- can select objects
			Selectable = true;
		}

		print = function(...)
			local Args = {...}
			local consoleFunc = printconsole or writeconsole 

			if consoleFunc then
				consoleFunc(
					unpack(
						Args
					)
				)
			end
		end

		-- MERELY

		Option.Modifiable = true

		-- END MERELY

		-- general size of GUI objects, in pixels
		local GUI_SIZE = 16
		-- padding between items within each entry
		local ENTRY_PADDING = 1
		-- padding between each entry
		local ENTRY_MARGIN = 1

		local explorerPanel = DEX_W:WaitForChild("ExplorerPanel")
		local Input = game:GetService("UserInputService")
		local HoldingCtrl = false
		local HoldingShift = false

		local DexOutput = Instance.new("Folder")
		DexOutput.Name = "Output"
		local DexOutputMain = Instance.new("ScreenGui", DexOutput)
		DexOutputMain.Name = "Dex Output"

		if(not game:GetService("RunService"):IsStudio()) then
			function print(...)
				local Obj = Instance.new("Dialog")
				Obj.Parent = DexOutputMain
				Obj.Name = ""
				for i,v in pairs({...}) do
					Obj.Name = Obj.Name .. tostring(v) .. " "
				end
			end
		end

		explorerPanel:WaitForChild("GetPrint").OnInvoke = function()
			return print
		end

--[[

# Explorer Panel

A GUI panel that displays the game hierarchy.


## Selection Bindables

- `Function GetSelection ( )`

	Returns an array of objects representing the objects currently
	selected in the panel.

- `Function SetSelection ( Objects selection )`

	Sets the objects that are selected in the panel. `selection` is an array
	of objects.

- `Event SelectionChanged ( )`

	Fired after the selection changes.


## Option Bindables

- `Function GetOption ( string optionName )`

	If `optionName` is given, returns the value of that option. Otherwise,
	returns a table of options and their current values.

- `Function SetOption ( string optionName, bool value )`

	Sets `optionName` to `value`.

	Options:

	- Modifiable

		Whether objects can be modified by the panel.

		Note that modifying objects depends on being able to select them. If
		Selectable is false, then Actions will not be available. Reparenting
		is still possible, but only for the dragged object.

	- Selectable

		Whether objects can be selected.

		If Modifiable is false, then left-clicking will perform a drag
		selection.

## Updates

- 2013-09-18
	- Fixed explorer icons to match studio explorer.

- 2013-09-14
	- Added GetOption and SetOption bindables.
		- Option: Modifiable; sets whether objects can be modified by the panel.
		- Option: Selectable; sets whether objects can be selected.
	- Slight modification to left-click selection behavior.
	- Improved layout and scaling.

- 2013-09-13
	- Added drag to reparent objects.
		- Left-click to select/deselect object.
		- Left-click and drag unselected object to reparent single object.
		- Left-click and drag selected object to move reparent entire selection.
		- Right-click while dragging to cancel.

- 2013-09-11
	- Added explorer panel header with actions.
		- Added Cut action.
		- Added Copy action.
		- Added Paste action.
		- Added Delete action.
	- Added drag selection.
		- Left-click: Add to selection on drag.
		- Right-click: Add to or remove from selection on drag.
	- Ensured SelectionChanged fires only when the selection actually changes.
	- Added documentation and change log.
	- Fixed thread issue.

- 2013-09-09
	- Added basic multi-selection.
		- Left-click to set selection.
		- Right-click to add to or remove from selection.
	- Removed "Selection" ObjectValue.
		- Added GetSelection BindableFunction.
		- Added SetSelection BindableFunction.
		- Added SelectionChanged BindableEvent.
	- Changed font to SourceSans.

- 2013-08-31
	- Improved GUI sizing based off of `GUI_SIZE` constant.
	- Automatic font size detection.

- 2013-08-27
	- Initial explorer panel.


## Todo

- Sorting
	- by ExplorerOrder
	- by children
	- by name
- Drag objects to reparent

]]

		local ENTRY_SIZE = GUI_SIZE + ENTRY_PADDING*2
		local ENTRY_BOUND = ENTRY_SIZE + ENTRY_MARGIN
		local HEADER_SIZE = ENTRY_SIZE*2

		local FONT = 'SourceSans'
		local FONT_SIZE do
			local size = {8,9,10,11,12,14,18,24,36,48}
			local s
			local n = math.huge
			for i = 1,#size do
				if size[i] <= GUI_SIZE then
					FONT_SIZE = i - 1
				end
			end
		end

		local GuiColor = {
			Background      = Color3.fromRGB(43, 43, 43);
			Border          = Color3.fromRGB(20, 20, 20);
			Selected        = Color3.fromRGB(5, 102, 141);
			BorderSelected  = Color3.fromRGB(2, 128, 144);
			Text            = Color3.fromRGB(245, 245, 245);
			TextDisabled    = Color3.fromRGB(188, 188, 188);
			TextSelected    = Color3.fromRGB(255, 255, 255);
			Button          = Color3.fromRGB(33, 33, 33);
			ButtonBorder    = Color3.fromRGB(133, 133, 133);
			ButtonSelected  = Color3.fromRGB(0, 168, 150);
			Field           = Color3.fromRGB(43, 43, 43);
			FieldBorder     = Color3.fromRGB(50, 50, 50);
			TitleBackground = Color3.fromRGB(11, 11, 11);
		}

--[[
local GuiColor = {
	Background      = Color3.new(233/255, 233/255, 233/255);
	Border          = Color3.new(149/255, 149/255, 149/255);
	Selected        = Color3.new( 96/255, 140/255, 211/255);
	BorderSelected  = Color3.new( 86/255, 125/255, 188/255);
	Text            = Color3.new(  0/255,   0/255,   0/255);
	TextDisabled    = Color3.new(128/255, 128/255, 128/255);
	TextSelected    = Color3.new(255/255, 255/255, 255/255);
	Button          = Color3.new(221/255, 221/255, 221/255);
	ButtonBorder    = Color3.new(149/255, 149/255, 149/255);
	ButtonSelected  = Color3.new(255/255,   0/255,   0/255);
	Field           = Color3.new(255/255, 255/255, 255/255);
	FieldBorder     = Color3.new(191/255, 191/255, 191/255);
	TitleBackground = Color3.new(178/255, 178/255, 178/255);
}
]]

		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		---- Icon map constants

		local MAP_ID = 483448923

		-- Indices based on implementation of Icon function.
		local ACTION_CUT         	 = 160
		local ACTION_COPY        	 = 161
		local ACTION_PASTE       	 = 162
		local ACTION_DELETE      	 = 163
		local ACTION_SORT        	 = 164
		local ACTION_CUT_OVER    	 = 174
		local ACTION_COPY_OVER   	 = 175
		local ACTION_PASTE_OVER  	 = 176
		local ACTION_DELETE_OVER	 = 177
		local ACTION_SORT_OVER  	 = 178
		local ACTION_EDITQUICKACCESS = 190
		local ACTION_FREEZE 		 = 188
		local ACTION_STARRED 		 = 189
		local ACTION_ADDSTAR 		 = 184
		local ACTION_ADDSTAR_OVER 	 = 187

		local NODE_COLLAPSED      = 165
		local NODE_EXPANDED       = 166
		local NODE_COLLAPSED_OVER = 179
		local NODE_EXPANDED_OVER  = 180

		local listOf = {
			ACTION_CUT,ACTION_COPY,ACTION_PASTE,ACTION_DELETE,ACTION_SORT,ACTION_CUT_OVER,ACTION_COPY_OVER,
			ACTION_PASTE_OVER,ACTION_DELETE_OVER,ACTION_SORT_OVER,ACTION_EDITQUICKACCESS,ACTION_FREEZE,ACTION_STARRED,
			ACTION_ADDSTAR,ACTION_ADDSTAR_OVER,NODE_COLLAPSED,NODE_EXPANDED,NODE_COLLAPSED_OVER,NODE_EXPANDED_OVER
		}

		local ExplorerIndex = {
			["Accessory"] = 32;
			["Accoutrement"] = 32;
			["AdService"] = 73;
			["Animation"] = 60;
			["AnimationController"] = 60;
			["AnimationTrack"] = 60;
			["Animator"] = 60;
			["ArcHandles"] = 56;
			["AssetService"] = 72;
			["Attachment"] = 34;
			["Backpack"] = 20;
			["BadgeService"] = 75;
			["BallSocketConstraint"] = 89;
			["BillboardGui"] = 64;
			["BinaryStringValue"] = 4;
			["BindableEvent"] = 67;
			["BindableFunction"] = 66;
			["BlockMesh"] = 8;
			["BloomEffect"] = 90;
			["BlurEffect"] = 90;
			["BodyAngularVelocity"] = 14;
			["BodyForce"] = 14;
			["BodyGyro"] = 14;
			["BodyPosition"] = 14;
			["BodyThrust"] = 14;
			["BodyVelocity"] = 14;
			["BoolValue"] = 4;
			["BoxHandleAdornment"] = 54;
			["BrickColorValue"] = 4;
			["Camera"] = 5;
			["CFrameValue"] = 4;
			["CharacterMesh"] = 60;
			["Chat"] = 33;
			["ClickDetector"] = 41;
			["CollectionService"] = 30;
			["Color3Value"] = 4;
			["ColorCorrectionEffect"] = 90;
			["ConeHandleAdornment"] = 54;
			["Configuration"] = 58;
			["ContentProvider"] = 72;
			["ContextActionService"] = 41;
			["CoreGui"] = 46;
			["CoreScript"] = 18;
			["CornerWedgePart"] = 1;
			["CustomEvent"] = 4;
			["CustomEventReceiver"] = 4;
			["CylinderHandleAdornment"] = 54;
			["CylinderMesh"] = 8;
			["CylindricalConstraint"] = 89;
			["Debris"] = 30;
			["Decal"] = 7;
			["Dialog"] = 62;
			["DialogChoice"] = 63;
			["DoubleConstrainedValue"] = 4;
			["Explosion"] = 36;
			["FileMesh"] = 8;
			["Fire"] = 61;
			["Flag"] = 38;
			["FlagStand"] = 39;
			["FloorWire"] = 4;
			["Folder"] = 70;
			["ForceField"] = 37;
			["Frame"] = 48;
			["GamePassService"] = 19;
			["Glue"] = 34;
			["GuiButton"] = 52;
			["GuiMain"] = 47;
			["GuiService"] = 47;
			["Handles"] = 53;
			["HapticService"] = 84;
			["Hat"] = 45;
			["HingeConstraint"] = 89;
			["Hint"] = 33;
			["HopperBin"] = 22;
			["HttpService"] = 76;
			["Humanoid"] = 9;
			["ImageButton"] = 52;
			["ImageLabel"] = 49;
			["InsertService"] = 72;
			["IntConstrainedValue"] = 4;
			["IntValue"] = 4;
			["JointInstance"] = 34;
			["JointsService"] = 34;
			["Keyframe"] = 60;
			["KeyframeSequence"] = 60;
			["KeyframeSequenceProvider"] = 60;
			["Lighting"] = 13;
			["LineHandleAdornment"] = 54;
			["LocalScript"] = 18;
			["LogService"] = 87;
			["MarketplaceService"] = 46;
			["Message"] = 33;
			["Model"] = 2;
			["ModuleScript"] = 71;
			["Motor"] = 34;
			["Motor6D"] = 34;
			["MoveToConstraint"] = 89;
			["NegateOperation"] = 78;
			["NetworkClient"] = 16;
			["NetworkReplicator"] = 29;
			["NetworkServer"] = 15;
			["NumberValue"] = 4;
			["ObjectValue"] = 4;
			["Pants"] = 44;
			["ParallelRampPart"] = 1;
			["Part"] = 1;
			["ParticleEmitter"] = 69;
			["PartPairLasso"] = 57;
			["PathfindingService"] = 37;
			["Platform"] = 35;
			["Player"] = 12;
			["PlayerGui"] = 46;
			["Players"] = 21;
			["PlayerScripts"] = 82;
			["PointLight"] = 13;
			["PointsService"] = 83;
			["Pose"] = 60;
			["PrismaticConstraint"] = 89;
			["PrismPart"] = 1;
			["PyramidPart"] = 1;
			["RayValue"] = 4;
			["ReflectionMetadata"] = 86;
			["ReflectionMetadataCallbacks"] = 86;
			["ReflectionMetadataClass"] = 86;
			["ReflectionMetadataClasses"] = 86;
			["ReflectionMetadataEnum"] = 86;
			["ReflectionMetadataEnumItem"] = 86;
			["ReflectionMetadataEnums"] = 86;
			["ReflectionMetadataEvents"] = 86;
			["ReflectionMetadataFunctions"] = 86;
			["ReflectionMetadataMember"] = 86;
			["ReflectionMetadataProperties"] = 86;
			["ReflectionMetadataYieldFunctions"] = 86;
			["RemoteEvent"] = 80;
			["RemoteFunction"] = 79;
			["ReplicatedFirst"] = 72;
			["ReplicatedStorage"] = 72;
			["RightAngleRampPart"] = 1;
			["RocketPropulsion"] = 14;
			["RodConstraint"] = 89;
			["RopeConstraint"] = 89;
			["Rotate"] = 34;
			["RotateP"] = 34;
			["RotateV"] = 34;
			["RunService"] = 66;
			["ScreenGui"] = 47;
			["Script"] = 6;
			["ScrollingFrame"] = 48;
			["Seat"] = 35;
			["Selection"] = 55;
			["SelectionBox"] = 54;
			["SelectionPartLasso"] = 57;
			["SelectionPointLasso"] = 57;
			["SelectionSphere"] = 54;
			["ServerScriptService"] = 0;
			["Shirt"] = 43;
			["ShirtGraphic"] = 40;
			["SkateboardPlatform"] = 35;
			["Sky"] = 28;
			["SlidingBallConstraint"] = 89;
			["Smoke"] = 59;
			["Snap"] = 34;
			["Sound"] = 11;
			["SoundService"] = 31;
			["Sparkles"] = 42;
			["SpawnLocation"] = 25;
			["SpecialMesh"] = 8;
			["SphereHandleAdornment"] = 54;
			["SpotLight"] = 13;
			["SpringConstraint"] = 89;
			["StarterCharacterScripts"] = 82;
			["StarterGear"] = 20;
			["StarterGui"] = 46;
			["StarterPack"] = 20;
			["StarterPlayer"] = 88;
			["StarterPlayerScripts"] = 82;
			["Status"] = 2;
			["StringValue"] = 4;
			["SunRaysEffect"] = 90;
			["SurfaceGui"] = 64;
			["SurfaceLight"] = 13;
			["SurfaceSelection"] = 55;
			["Team"] = 24;
			["Teams"] = 23;
			["TeleportService"] = 81;
			["Terrain"] = 65;
			["TerrainRegion"] = 65;
			["TestService"] = 68;
			["TextBox"] = 51;
			["TextButton"] = 51;
			["TextLabel"] = 50;
			["Texture"] = 10;
			["TextureTrail"] = 4;
			["Tool"] = 17;
			["TouchTransmitter"] = 37;
			["TrussPart"] = 1;
			["UnionOperation"] = 77;
			["UserInputService"] = 84;
			["Vector3Value"] = 4;
			["VehicleSeat"] = 35;
			["VelocityMotor"] = 34;
			["WedgePart"] = 1;
			["Weld"] = 34;
			["Workspace"] = 19;
		}

		local ClassIndex = {
			["BindableFunction"] = 66,
			["BindableEvent"] = 67,
			["TouchTransmitter"] = 37,
			["ForceField"] = 37,
			["Plugin"] = 86,
			["Hat"] = 45,
			["Accessory"] = 32,
			["Attachment"] = 81,
			["WrapTarget"] = 127,
			["WrapLayer"] = 126,
			["Bone"] = 114,
			["Constraint"] = 86,
			["BallSocketConstraint"] = 86,
			["RopeConstraint"] = 89,
			["RodConstraint"] = 90,
			["SpringConstraint"] = 91,
			["TorsionSpringConstraint"] = 125,
			["WeldConstraint"] = 94,
			["NoCollisionConstraint"] = 105,
			["RigidConstraint"] = 135,
			["HingeConstraint"] = 87,
			["UniversalConstraint"] = 123,
			["SlidingBallConstraint"] = 88,
			["PrismaticConstraint"] = 88,
			["CylindricalConstraint"] = 95,
			["AlignOrientation"] = 100,
			["AlignPosition"] = 99,
			["VectorForce"] = 102,
			["LineForce"] = 101,
			["Torque"] = 103,
			["AngularVelocity"] = 103,
			["Plane"] = 134,
			["LinearVelocity"] = 132,
			["Weld"] = 34,
			["Snap"] = 34,
			["ClickDetector"] = 41,
			["ProximityPrompt"] = 124,
			["Smoke"] = 59,
			["Trail"] = 93,
			["Beam"] = 96,
			["SurfaceAppearance"] = 10,
			["ParticleEmitter"] = 80,
			["Sparkles"] = 42,
			["Explosion"] = 36,
			["Fire"] = 61,
			["Seat"] = 35,
			["Platform"] = 35,
			["SkateboardPlatform"] = 35,
			["VehicleSeat"] = 35,
			["Tool"] = 17,
			["Flag"] = 38,
			["FlagStand"] = 39,
			["Decal"] = 7,
			["JointInstance"] = 34,
			["Message"] = 33,
			["Hint"] = 33,
			["IntValue"] = 4,
			["RayValue"] = 4,
			["IntConstrainedValue"] = 4,
			["DoubleConstrainedValue"] = 4,
			["BoolValue"] = 4,
			["CustomEvent"] = 4,
			["CustomEventReceiver"] = 4,
			["FloorWire"] = 4,
			["NumberValue"] = 4,
			["StringValue"] = 4,
			["Vector3Value"] = 4,
			["CFrameValue"] = 4,
			["Color3Value"] = 4,
			["BrickColorValue"] = 4,
			["ValueBase"] = 4,
			["ObjectValue"] = 4,
			["SpecialMesh"] = 8,
			["BlockMesh"] = 8,
			["CylinderMesh"] = 8,
			["Texture"] = 10,
			["Sound"] = 11,
			["Speaker"] = 11,
			["VoiceSource"] = 11,
			["EchoSoundEffect"] = 84,
			["FlangeSoundEffect"] = 84,
			["DistortionSoundEffect"] = 84,
			["PitchShiftSoundEffect"] = 84,
			["ChannelSelectorSoundEffect"] = 84,
			["ChorusSoundEffect"] = 84,
			["TremoloSoundEffect"] = 84,
			["ReverbSoundEffect"] = 84,
			["EqualizerSoundEffect"] = 84,
			["CompressorSoundEffect"] = 84,
			["SoundGroup"] = 85,
			["SoundService"] = 31,
			["Backpack"] = 20,
			["StarterPack"] = 20,
			["StarterPlayer"] = 79,
			["StarterGear"] = 20,
			["CoreGui"] = 46,
			["CorePackages"] = 20,
			["RobloxPluginGuiService"] = 46,
			["PluginGuiService"] = 46,
			["PluginDebugService"] = 46,
			["UIListLayout"] = 26,
			["UIGridLayout"] = 26,
			["UIPageLayout"] = 26,
			["UITableLayout"] = 26,
			["UISizeConstraint"] = 26,
			["UITextSizeConstraint"] = 26,
			["UIAspectRatioConstraint"] = 26,
			["UIScale"] = 26,
			["UIPadding"] = 26,
			["UIGradient"] = 26,
			["UICorner"] = 26,
			["UIStroke"] = 26,
			["StarterGui"] = 46,
			["Chat"] = 33,
			["ChatService"] = 33,
			["VoiceChatService"] = 136,
			["LocalizationTable"] = 97,
			["LocalizationService"] = 92,
			["MarketplaceService"] = 46,
			["Atmosphere"] = 28,
			["Clouds"] = 28,
			["MaterialVariant"] = 130,
			["MaterialService"] = 131,
			["Sky"] = 28,
			["ColorCorrectionEffect"] = 83,
			["BloomEffect"] = 83,
			["BlurEffect"] = 83,
			["Highlight"] = 133,
			["DepthOfFieldEffect"] = 83,
			["SunRaysEffect"] = 83,
			["Humanoid"] = 9,
			["Shirt"] = 43,
			["Pants"] = 44,
			["ShirtGraphic"] = 40,
			["PackageLink"] = 98,
			["BodyGyro"] = 14,
			["BodyPosition"] = 14,
			["RocketPropulsion"] = 14,
			["BodyVelocity"] = 14,
			["BodyAngularVelocity"] = 14,
			["BodyForce"] = 14,
			["BodyThrust"] = 14,
			["Teams"] = 23,
			["Team"] = 24,
			["SpawnLocation"] = 25,
			["NetworkClient"] = 16,
			["NetworkServer"] = 15,
			["Script"] = 6,
			["LocalScript"] = 18,
			["RenderingTest"] = 5,
			["NetworkReplicator"] = 29,
			["Model"] = 2,
			["Status"] = 2,
			["HopperBin"] = 22,
			["Camera"] = 5,
			["Players"] = 21,
			["ReplicatedStorage"] = 70,
			["ReplicatedFirst"] = 70,
			["ServerStorage"] = 69,
			["ServerScriptService"] = 71,
			["ReplicatedScriptService"] = 70,
			["Lighting"] = 13,
			["TestService"] = 68,
			["Debris"] = 30,
			["Accoutrement"] = 32,
			["Player"] = 12,
			["Workspace"] = 19,
			["Part"] = 1,
			["TrussPart"] = 1,
			["WedgePart"] = 1,
			["PrismPart"] = 1,
			["PyramidPart"] = 1,
			["ParallelRampPart"] = 1,
			["RightAngleRampPart"] = 1,
			["CornerWedgePart"] = 1,
			["PlayerGui"] = 46,
			["PlayerScripts"] = 78,
			["StandalonePluginScripts"] = 78,
			["StarterPlayerScripts"] = 78,
			["StarterCharacterScripts"] = 78,
			["GuiMain"] = 47,
			["ScreenGui"] = 47,
			["BillboardGui"] = 64,
			["SurfaceGui"] = 64,
			["Frame"] = 48,
			["ScrollingFrame"] = 48,
			["ImageLabel"] = 49,
			["VideoFrame"] = 120,
			["CanvasGroup"] = 48,
			["TextLabel"] = 50,
			["TextButton"] = 51,
			["TextBox"] = 51,
			["GuiButton"] = 52,
			["ViewportFrame"] = 52,
			["ImageButton"] = 52,
			["Handles"] = 53,
			["ArcHandles"] = 56,
			["SelectionBox"] = 54,
			["SelectionSphere"] = 54,
			["SurfaceSelection"] = 55,
			["PathfindingModifier"] = 128,
			["PathfindingLink"] = 137,
			["Configuration"] = 58,
			["HumanoidDescription"] = 104,
			["Folder"] = 77,
			["WorldModel"] = 19,
			["Motor6D"] = 106,
			["BoxHandleAdornment"] = 111,
			["ConeHandleAdornment"] = 110,
			["CylinderHandleAdornment"] = 109,
			["SphereHandleAdornment"] = 112,
			["LineHandleAdornment"] = 107,
			["ImageHandleAdornment"] = 108,
			["SelectionPartLasso"] = 57,
			["SelectionPointLasso"] = 57,
			["PartPairLasso"] = 57,
			["PoseBase"] = 60,
			["Pose"] = 60,
			["NumberPose"] = 60,
			["KeyframeMarker"] = 60,
			["Keyframe"] = 60,
			["Animation"] = 60,
			["AnimationTrack"] = 60,
			["AnimationController"] = 60,
			["Animator"] = 60,
			["FaceControls"] = 129,
			["CharacterMesh"] = 60,
			["Dialog"] = 62,
			["DialogChoice"] = 63,
			["UnionOperation"] = 73,
			["NegateOperation"] = 72,
			["MeshPart"] = 73,
			["Terrain"] = 65,
			["Light"] = 13,
			["PointLight"] = 13,
			["SpotLight"] = 13,
			["SurfaceLight"] = 13,
			["RemoteFunction"] = 74,
			["RemoteEvent"] = 75,
			["TerrainRegion"] = 65,
			["ModuleScript"] = 76,
		}

		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------

		function Create(ty,data)
			local obj
			if type(ty) == 'string' then
				obj = Instance.new(ty)
			else
				obj = ty
			end
			for k, v in pairs(data) do
				if type(k) == 'number' then
					v.Parent = obj
				else
					obj[k] = v
				end
			end
			return obj
		end

		local barActive = false
		local activeOptions = {}

		function createDDown(dBut, callback,...)
			if barActive then
				for i,v in pairs(activeOptions) do
					v:Destroy()
				end
				activeOptions = {}
				barActive = false
				return
			else
				barActive = true
			end
			local slots = {...}
			local base = dBut
			for i,v in pairs(slots) do
				local newOption = base:Clone()
				newOption.ZIndex = 5
				newOption.Name = "Option "..tostring(i)
				newOption.Parent = base.Parent.Parent.Parent
				newOption.BackgroundTransparency = 0
				newOption.ZIndex = 2
				table.insert(activeOptions,newOption)
				newOption.Position = UDim2.new(-0.4, dBut.Position.X.Offset, dBut.Position.Y.Scale, dBut.Position.Y.Offset + (#activeOptions * dBut.Size.Y.Offset))
				newOption.Text = slots[i]
				newOption.MouseButton1Down:connect(function()
					dBut.Text = slots[i]
					callback(slots[i])
					for i,v in pairs(activeOptions) do
						v:Destroy()
					end
					activeOptions = {}
					barActive = false
				end)
			end
		end

		-- Connects a function to an event such that it fires asynchronously
		function Connect(event,func)
			return event:connect(function(...)
				local a = {...}
				spawn(function() func(unpack(a)) end)
			end)
		end

		-- returns the ascendant ScreenGui of an object
		function GetScreen(screen)
			if screen == nil then return nil end
			while not screen:IsA("ScreenGui") do
				screen = screen.Parent
				if screen == nil then return nil end
			end
			return screen
		end

		do
			local ZIndexLock = {}
			-- Sets the ZIndex of an object and its descendants. Objects are locked so
			-- that SetZIndexOnChanged doesn't spawn multiple threads that set the
			-- ZIndex of the same object.
			function SetZIndex(object,z)
				if not ZIndexLock[object] then
					ZIndexLock[object] = true
					if object:IsA'GuiObject' then
						object.ZIndex = z
					end
					local children = object:GetChildren()
					for i = 1,#children do
						SetZIndex(children[i],z)
					end
					ZIndexLock[object] = nil
				end
			end

			function SetZIndexOnChanged(object)
				return object.Changed:connect(function(p)
					if p == "ZIndex" then
						SetZIndex(object,object.ZIndex)
					end
				end)
			end
		end

		---- IconMap ----
		-- Image size: 256px x 256px
		-- Icon size: 16px x 16px
		-- Padding between each icon: 2px
		-- Padding around image edge: 1px
		-- Total icons: 14 x 14 (196)

		local find = function(n)
			for a,i in pairs(ExplorerIndex) do
				if(i == n) then
					return a;
				end
			end
		end

		local Icon do
			local iconMap = 'http://www.roblox.com/asset/?id=' .. MAP_ID
			game:GetService('ContentProvider'):Preload(iconMap)
			local iconDehash do
				-- 14 x 14, 0-based input, 0-based output
				local f=math.floor
				function iconDehash(h)
					return f(h/14%14),f(h%14)
				end
			end



			function Icon(IconFrame, index, obj ,zIndex, UseOldIcon)
				local isNodeThing = table.find(listOf, index) ~= nil;
				local class;
				local class2;
				if(not isNodeThing) then
					class = find(index);
					if(not class) then
						warn(index)
					end
				end

				local CLASS_MAP_ID = "rbxasset://textures/ClassImages.PNG"
				local row,col = iconDehash(index)
				local mapSize = Vector2.new(256, 256)
				local pad, border = 2, 1
				local iconSize = 16

				local class = 'Frame'
				if type(IconFrame) == 'string' then
					class = IconFrame
					class2 = IconFrame
					IconFrame = nil
				end

				if not IconFrame then
					IconFrame = Create(class,{
						Name = "Icon";
						BackgroundTransparency = 1;
						ClipsDescendants = true;
						Create('ImageLabel',{
							Name = "IconMap";
							Active = false;
							BackgroundTransparency = 1;
							Image = iconMap;
							Size = UDim2.new(mapSize.x/iconSize,0,mapSize.y/iconSize,0),
						});
					})
				end

				IconFrame.IconMap.Position = UDim2.new(-col - (pad*(col+1) + border)/iconSize,0,-row - (pad*(row+1) + border)/iconSize,0);
				if (ClassIndex[class] and not isNodeThing and not UseOldIcon) then
					if(obj) then
						class = obj.ClassName;
					end


					local index2 = ClassIndex[class] or 0

					IconFrame.IconMap.BackgroundTransparency = 1;
					IconFrame.IconMap.Image = CLASS_MAP_ID;
					IconFrame.IconMap.ImageRectSize = Vector2.new(16, 16);
					IconFrame.IconMap.ImageRectOffset = Vector2.new(index2 * 16, 0);
					IconFrame.IconMap.Size = UDim2.new(1, 0, 1, 0);
					IconFrame.IconMap.Position = UDim2.new(0, 0, 0, 0)

					if(zIndex) then
						IconFrame.IconMap.ZIndex = zIndex;
					end

					return IconFrame
				else
					IconFrame.ClipsDescendants = true;
					IconFrame.IconMap.ImageTransparency = 0;
				end
				return IconFrame
			end
		end

		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		---- ScrollBar
		do
			-- AutoButtonColor doesn't always reset properly
			local function ResetButtonColor(button)
				local active = button.Active
				button.Active = not active
				button.Active = active
			end

			local function ArrowGraphic(size,dir,scaled,template)
				local Frame = Create('Frame',{
					Name = "Arrow Graphic";
					BorderSizePixel = 0;
					Size = UDim2.new(0,size,0,size);
					Transparency = 1;
				})
				if not template then
					template = Instance.new("Frame")
					template.BorderSizePixel = 0
				end

				template.BackgroundColor3 = Color3.new(1, 1, 1);

				local transform
				if dir == nil or dir == 'Up' then
					function transform(p,s) return p,s end
				elseif dir == 'Down' then
					function transform(p,s) return UDim2.new(0,p.X.Offset,0,size-p.Y.Offset-1),s end
				elseif dir == 'Left' then
					function transform(p,s) return UDim2.new(0,p.Y.Offset,0,p.X.Offset),UDim2.new(0,s.Y.Offset,0,s.X.Offset) end
				elseif dir == 'Right' then
					function transform(p,s) return UDim2.new(0,size-p.Y.Offset-1,0,p.X.Offset),UDim2.new(0,s.Y.Offset,0,s.X.Offset) end
				end

				local scale
				if scaled then
					function scale(p,s) return UDim2.new(p.X.Offset/size,0,p.Y.Offset/size,0),UDim2.new(s.X.Offset/size,0,s.Y.Offset/size,0) end
				else
					function scale(p,s) return p,s end
				end

				local o = math.floor(size/4)
				if size%2 == 0 then
					local n = size/2-1
					for i = 0,n do
						local t = template:Clone()
						local p,s = scale(transform(
							UDim2.new(0,n-i,0,o+i),
							UDim2.new(0,(i+1)*2,0,1)
							))
						t.Position = p
						t.Size = s
						t.Parent = Frame
					end
				else
					local n = (size-1)/2
					for i = 0,n do
						local t = template:Clone()
						local p,s = scale(transform(
							UDim2.new(0,n-i,0,o+i),
							UDim2.new(0,i*2+1,0,1)
							))
						t.Position = p
						t.Size = s
						t.Parent = Frame
					end
				end
				if size%4 > 1 then
					local t = template:Clone()
					local p,s = scale(transform(
						UDim2.new(0,0,0,size-o-1),
						UDim2.new(0,size,0,1)
						))
					t.Position = p
					t.Size = s
					t.Parent = Frame
				end

				for i,v in pairs(Frame:GetChildren()) do
					v.BackgroundColor3 = Color3.new(1, 1, 1);
				end

				return Frame
			end


			local function GripGraphic(size,dir,spacing,scaled,template)
				local Frame = Create('Frame',{
					Name = "Grip Graphic";
					BorderSizePixel = 0;
					Size = UDim2.new(0,size.x,0,size.y);
					Transparency = 1;
				})
				if not template then
					template = Instance.new("Frame")
					template.BorderSizePixel = 0
				end

				spacing = spacing or 2

				local scale
				if scaled then
					function scale(p) return UDim2.new(p.X.Offset/size.x,0,p.Y.Offset/size.y,0) end
				else
					function scale(p) return p end
				end

				if dir == 'Vertical' then
					for i=0,size.x-1,spacing do
						local t = template:Clone()
						t.Size = scale(UDim2.new(0,1,0,size.y))
						t.Position = scale(UDim2.new(0,i,0,0))
						t.Parent = Frame
					end
				elseif dir == nil or dir == 'Horizontal' then
					for i=0,size.y-1,spacing do
						local t = template:Clone()
						t.Size = scale(UDim2.new(0,size.x,0,1))
						t.Position = scale(UDim2.new(0,0,0,i))
						t.Parent = Frame
					end
				end

				return Frame
			end

			local mt = {
				__index = {
					GetScrollPercent = function(self)
						return self.ScrollIndex/(self.TotalSpace-self.VisibleSpace)
					end;
					CanScrollDown = function(self)
						return self.ScrollIndex + self.VisibleSpace < self.TotalSpace
					end;
					CanScrollUp = function(self)
						return self.ScrollIndex > 0
					end;
					ScrollDown = function(self)
						self.ScrollIndex = self.ScrollIndex + self.PageIncrement
						self:Update()
					end;
					ScrollUp = function(self)
						self.ScrollIndex = self.ScrollIndex - self.PageIncrement
						self:Update()
					end;
					ScrollTo = function(self,index)
						self.ScrollIndex = index
						self:Update()
					end;
					SetScrollPercent = function(self,percent)
						self.ScrollIndex = math.floor((self.TotalSpace - self.VisibleSpace)*percent + 0.5)
						self:Update()
					end;
				};
			}
			mt.__index.CanScrollRight = mt.__index.CanScrollDown
			mt.__index.CanScrollLeft = mt.__index.CanScrollUp
			mt.__index.ScrollLeft = mt.__index.ScrollUp
			mt.__index.ScrollRight = mt.__index.ScrollDown

			function ScrollBar(horizontal)
				-- create row scroll bar
				local ScrollFrame = Create('Frame',{
					Name = "ScrollFrame";
					BorderSizePixel = 0;
					Position = horizontal and UDim2.new(0,0,1,-GUI_SIZE) or UDim2.new(1,-GUI_SIZE,0,0);
					Size = horizontal and UDim2.new(1,0,0,GUI_SIZE) or UDim2.new(0,GUI_SIZE,1,0);
					BackgroundTransparency = 1;
					Create('ImageButton',{
						Name = "ScrollDown";
						Position = horizontal and UDim2.new(1,-GUI_SIZE,0,0) or UDim2.new(0,0,1,-GUI_SIZE);
						Size = UDim2.new(0, GUI_SIZE, 0, GUI_SIZE);
						BackgroundColor3 = GuiColor.Button;
						BorderColor3 = GuiColor.Border;
						--BorderSizePixel = 0;
					});
					Create('ImageButton',{
						Name = "ScrollUp";
						Size = UDim2.new(0, GUI_SIZE, 0, GUI_SIZE);
						BackgroundColor3 = GuiColor.Button;
						BorderColor3 = GuiColor.Border;
						--BorderSizePixel = 0;
					});
					Create('ImageButton',{
						Name = "ScrollBar";
						Size = horizontal and UDim2.new(1,-GUI_SIZE*2,1,0) or UDim2.new(1,0,1,-GUI_SIZE*2);
						Position = horizontal and UDim2.new(0,GUI_SIZE,0,0) or UDim2.new(0,0,0,GUI_SIZE);
						AutoButtonColor = false;
						BackgroundColor3 = Color3.new(1/4, 1/4, 1/4);
						BorderColor3 = GuiColor.Border;
						--BorderSizePixel = 0;
						Create('ImageButton',{
							Name = "ScrollThumb";
							AutoButtonColor = false;
							Size = UDim2.new(0, GUI_SIZE, 0, GUI_SIZE);
							BackgroundColor3 = GuiColor.Button;
							BorderColor3 = GuiColor.Border;
							--BorderSizePixel = 0;
						});
					});
				})

				local graphicTemplate = Create('Frame',{
					Name="Graphic";
					BorderSizePixel = 0;
					BackgroundColor3 = GuiColor.Border;
				})
				local graphicSize = GUI_SIZE/2

				local ScrollDownFrame = ScrollFrame.ScrollDown
				local ScrollDownGraphic = ArrowGraphic(graphicSize,horizontal and 'Right' or 'Down',true,graphicTemplate)
				ScrollDownGraphic.Position = UDim2.new(0.5,-graphicSize/2,0.5,-graphicSize/2)
				ScrollDownGraphic.Parent = ScrollDownFrame
				local ScrollUpFrame = ScrollFrame.ScrollUp
				local ScrollUpGraphic = ArrowGraphic(graphicSize,horizontal and 'Left' or 'Up',true,graphicTemplate)
				ScrollUpGraphic.Position = UDim2.new(0.5,-graphicSize/2,0.5,-graphicSize/2)
				ScrollUpGraphic.Parent = ScrollUpFrame
				local ScrollBarFrame = ScrollFrame.ScrollBar
				local ScrollThumbFrame = ScrollBarFrame.ScrollThumb
				do
					local size = GUI_SIZE*3/8
					local Decal = GripGraphic(Vector2.new(size,size),horizontal and 'Vertical' or 'Horizontal',2,graphicTemplate)
					Decal.Position = UDim2.new(0.5,-size/2,0.5,-size/2)
					Decal.Parent = ScrollThumbFrame
				end

				local Class = setmetatable({
					GUI = ScrollFrame;
					ScrollIndex = 0;
					VisibleSpace = 0;
					TotalSpace = 0;
					PageIncrement = 1;
				},mt)

				local UpdateScrollThumb
				if horizontal then
					function UpdateScrollThumb()
						ScrollThumbFrame.Size = UDim2.new(Class.VisibleSpace/Class.TotalSpace,0,0,GUI_SIZE)
						if ScrollThumbFrame.AbsoluteSize.x < GUI_SIZE then
							ScrollThumbFrame.Size = UDim2.new(0,GUI_SIZE,0,GUI_SIZE)
						end
						local barSize = ScrollBarFrame.AbsoluteSize.x
						ScrollThumbFrame.Position = UDim2.new(Class:GetScrollPercent()*(barSize - ScrollThumbFrame.AbsoluteSize.x)/barSize,0,0,0)
					end
				else
					function UpdateScrollThumb()
						ScrollThumbFrame.Size = UDim2.new(0,GUI_SIZE,Class.VisibleSpace/Class.TotalSpace,0)
						if ScrollThumbFrame.AbsoluteSize.y < GUI_SIZE then
							ScrollThumbFrame.Size = UDim2.new(0,GUI_SIZE,0,GUI_SIZE)
						end
						local barSize = ScrollBarFrame.AbsoluteSize.y
						ScrollThumbFrame.Position = UDim2.new(0,0,Class:GetScrollPercent()*(barSize - ScrollThumbFrame.AbsoluteSize.y)/barSize,0)
					end
				end

				local lastDown
				local lastUp
				local scrollStyle = {BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=0}
				local scrollStyle_ds = {BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=0.7}

				local function Update()
					local t = Class.TotalSpace
					local v = Class.VisibleSpace
					local s = Class.ScrollIndex
					if v <= t then
						if s > 0 then
							if s + v > t then
								Class.ScrollIndex = t - v
							end
						else
							Class.ScrollIndex = 0
						end
					else
						Class.ScrollIndex = 0
					end

					if Class.UpdateCallback then
						if Class.UpdateCallback(Class) == false then
							return
						end
					end

					local down = Class:CanScrollDown()
					local up = Class:CanScrollUp()
					if down ~= lastDown then
						lastDown = down
						ScrollDownFrame.Active = down
						ScrollDownFrame.AutoButtonColor = down
						local children = ScrollDownGraphic:GetChildren()
						local style = down and scrollStyle or scrollStyle_ds
						for i = 1,#children do
							Create(children[i],style)
						end
					end
					if up ~= lastUp then
						lastUp = up
						ScrollUpFrame.Active = up
						ScrollUpFrame.AutoButtonColor = up
						local children = ScrollUpGraphic:GetChildren()
						local style = up and scrollStyle or scrollStyle_ds
						for i = 1,#children do
							Create(children[i],style)
						end
					end
					ScrollThumbFrame.Visible = down or up
					UpdateScrollThumb()
				end
				Class.Update = Update

				SetZIndexOnChanged(ScrollFrame)

				local MouseDrag = Create('ImageButton',{
					Name = "MouseDrag";
					Position = UDim2.new(-0.25,0,-0.25,0);
					Size = UDim2.new(1.5,0,1.5,0);
					Transparency = 1;
					AutoButtonColor = false;
					Active = true;
					ZIndex = 10;
				})

				local scrollEventID = 0
				ScrollDownFrame.MouseButton1Down:connect(function()
					scrollEventID = tick()
					local current = scrollEventID
					local up_con
					up_con = MouseDrag.MouseButton1Up:connect(function()
						scrollEventID = tick()
						MouseDrag.Parent = nil
						ResetButtonColor(ScrollDownFrame)
						up_con:disconnect(); drag = nil
					end)
					MouseDrag.Parent = GetScreen(ScrollFrame)
					Class:ScrollDown()
					wait(0.2) -- delay before auto scroll
					while scrollEventID == current do
						Class:ScrollDown()
						if not Class:CanScrollDown() then break end
						wait()
					end
				end)

				ScrollDownFrame.MouseButton1Up:connect(function()
					scrollEventID = tick()
				end)

				ScrollUpFrame.MouseButton1Down:connect(function()
					scrollEventID = tick()
					local current = scrollEventID
					local up_con
					up_con = MouseDrag.MouseButton1Up:connect(function()
						scrollEventID = tick()
						MouseDrag.Parent = nil
						ResetButtonColor(ScrollUpFrame)
						up_con:disconnect(); drag = nil
					end)
					MouseDrag.Parent = GetScreen(ScrollFrame)
					Class:ScrollUp()
					wait(0.2)
					while scrollEventID == current do
						Class:ScrollUp()
						if not Class:CanScrollUp() then break end
						wait()
					end
				end)

				ScrollUpFrame.MouseButton1Up:connect(function()
					scrollEventID = tick()
				end)

				if horizontal then
					ScrollBarFrame.MouseButton1Down:connect(function(x,y)
						scrollEventID = tick()
						local current = scrollEventID
						local up_con
						up_con = MouseDrag.MouseButton1Up:connect(function()
							scrollEventID = tick()
							MouseDrag.Parent = nil
							ResetButtonColor(ScrollUpFrame)
							up_con:disconnect(); drag = nil
						end)
						MouseDrag.Parent = GetScreen(ScrollFrame)
						if x > ScrollThumbFrame.AbsolutePosition.x then
							Class:ScrollTo(Class.ScrollIndex + Class.VisibleSpace)
							wait(0.2)
							while scrollEventID == current do
								if x < ScrollThumbFrame.AbsolutePosition.x + ScrollThumbFrame.AbsoluteSize.x then break end
								Class:ScrollTo(Class.ScrollIndex + Class.VisibleSpace)
								wait()
							end
						else
							Class:ScrollTo(Class.ScrollIndex - Class.VisibleSpace)
							wait(0.2)
							while scrollEventID == current do
								if x > ScrollThumbFrame.AbsolutePosition.x then break end
								Class:ScrollTo(Class.ScrollIndex - Class.VisibleSpace)
								wait()
							end
						end
					end)
				else
					ScrollBarFrame.MouseButton1Down:connect(function(x,y)
						scrollEventID = tick()
						local current = scrollEventID
						local up_con
						up_con = MouseDrag.MouseButton1Up:connect(function()
							scrollEventID = tick()
							MouseDrag.Parent = nil
							ResetButtonColor(ScrollUpFrame)
							up_con:disconnect(); drag = nil
						end)
						MouseDrag.Parent = GetScreen(ScrollFrame)
						if y > ScrollThumbFrame.AbsolutePosition.y then
							Class:ScrollTo(Class.ScrollIndex + Class.VisibleSpace)
							wait(0.2)
							while scrollEventID == current do
								if y < ScrollThumbFrame.AbsolutePosition.y + ScrollThumbFrame.AbsoluteSize.y then break end
								Class:ScrollTo(Class.ScrollIndex + Class.VisibleSpace)
								wait()
							end
						else
							Class:ScrollTo(Class.ScrollIndex - Class.VisibleSpace)
							wait(0.2)
							while scrollEventID == current do
								if y > ScrollThumbFrame.AbsolutePosition.y then break end
								Class:ScrollTo(Class.ScrollIndex - Class.VisibleSpace)
								wait()
							end
						end
					end)
				end

				if horizontal then
					ScrollThumbFrame.MouseButton1Down:connect(function(x,y)
						scrollEventID = tick()
						local mouse_offset = x - ScrollThumbFrame.AbsolutePosition.x
						local drag_con
						local up_con
						drag_con = MouseDrag.MouseMoved:connect(function(x,y)
							local bar_abs_pos = ScrollBarFrame.AbsolutePosition.x
							local bar_drag = ScrollBarFrame.AbsoluteSize.x - ScrollThumbFrame.AbsoluteSize.x
							local bar_abs_one = bar_abs_pos + bar_drag
							x = x - mouse_offset
							x = x < bar_abs_pos and bar_abs_pos or x > bar_abs_one and bar_abs_one or x
							x = x - bar_abs_pos
							Class:SetScrollPercent(x/(bar_drag))
						end)
						up_con = MouseDrag.MouseButton1Up:connect(function()
							scrollEventID = tick()
							MouseDrag.Parent = nil
							ResetButtonColor(ScrollThumbFrame)
							drag_con:disconnect(); drag_con = nil
							up_con:disconnect(); drag = nil
						end)
						MouseDrag.Parent = GetScreen(ScrollFrame)
					end)
				else
					ScrollThumbFrame.MouseButton1Down:connect(function(x,y)
						scrollEventID = tick()
						local mouse_offset = y - ScrollThumbFrame.AbsolutePosition.y
						local drag_con
						local up_con
						drag_con = MouseDrag.MouseMoved:connect(function(x,y)
							local bar_abs_pos = ScrollBarFrame.AbsolutePosition.y
							local bar_drag = ScrollBarFrame.AbsoluteSize.y - ScrollThumbFrame.AbsoluteSize.y
							local bar_abs_one = bar_abs_pos + bar_drag
							y = y - mouse_offset
							y = y < bar_abs_pos and bar_abs_pos or y > bar_abs_one and bar_abs_one or y
							y = y - bar_abs_pos
							Class:SetScrollPercent(y/(bar_drag))
						end)
						up_con = MouseDrag.MouseButton1Up:connect(function()
							scrollEventID = tick()
							MouseDrag.Parent = nil
							ResetButtonColor(ScrollThumbFrame)
							drag_con:disconnect(); drag_con = nil
							up_con:disconnect(); drag = nil
						end)
						MouseDrag.Parent = GetScreen(ScrollFrame)
					end)
				end

				function Class:Destroy()
					ScrollFrame:Destroy()
					MouseDrag:Destroy()
					for k in pairs(Class) do
						Class[k] = nil
					end
					setmetatable(Class,nil)
				end

				Update()

				return Class
			end
		end

		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		---- Explorer panel

		Create(explorerPanel,{
			BackgroundColor3 = GuiColor.Field;
			BorderColor3 = GuiColor.Border;
			Active = true;
		})

		local SettingsRemote = explorerPanel.Parent:WaitForChild("SettingsPanel"):WaitForChild("GetSetting")
		local GetApiRemote = explorerPanel.Parent:WaitForChild("PropertiesFrame"):WaitForChild("GetApi")
		local GetAwaitRemote = explorerPanel.Parent:WaitForChild("PropertiesFrame"):WaitForChild("GetAwaiting")
		local bindSetAwaiting = explorerPanel.Parent:WaitForChild("PropertiesFrame"):WaitForChild("SetAwaiting")

		local SaveInstanceWindow = explorerPanel.Parent:WaitForChild("SaveInstance")
		local ConfirmationWindow = explorerPanel.Parent:WaitForChild("Confirmation")
		local CautionWindow = explorerPanel.Parent:WaitForChild("Caution")
		local TableCautionWindow = explorerPanel.Parent:WaitForChild("TableCaution")

		local RemoteWindow = explorerPanel.Parent:WaitForChild("CallRemote")

		local ScriptEditor = explorerPanel.Parent:WaitForChild("ScriptEditor")
		local ScriptEditorEvent = ScriptEditor:WaitForChild("OpenScript")

		local CurrentSaveInstanceWindow
		local CurrentRemoteWindow

		local lastSelectedNode

		local DexStorage
		local DexStorageMain
		local DexStorageEnabled

		if saveinstance then DexStorageEnabled = true end

		local _decompile = decompile;

		function decompile(s, ...)
			if SettingsRemote:Invoke'UseNewDecompiler' then
				return _decompile(s, 'new');
			else
				return _decompile(s, 'legacy');
			end 
		end

		if DexStorageEnabled then
			DexStorage = Instance.new("Folder")
			DexStorage.Name = "Dex"
			DexStorageMain = Instance.new("Folder",DexStorage)
			DexStorageMain.Name = "DexStorage"
		end

		local RunningScriptsStorage
		local RunningScriptsStorageMain
		local RunningScriptsStorageEnabled

		if getscripts then RunningScriptsStorageEnabled = true end

		if RunningScriptsStorageEnabled then
			RunningScriptsStorage = Instance.new("Folder")
			RunningScriptsStorage.Name = "Dex Internal Storage"
			RunningScriptsStorageMain = Instance.new("Folder", RunningScriptsStorage)
			RunningScriptsStorageMain.Name = "Running Scripts"
		end

		local LoadedModulesStorage
		local LoadedModulesStorageMain
		local LoadedModulesStorageEnabled

		if getloadedmodules then LoadedModulesStorageEnabled = true end

		if LoadedModulesStorageEnabled then
			LoadedModulesStorage = Instance.new("Folder")
			LoadedModulesStorage.Name = "Dex Internal Storage"
			LoadedModulesStorageMain = Instance.new("Folder", LoadedModulesStorage)
			LoadedModulesStorageMain.Name = "Loaded Modules"
		end

		local NilStorage
		local NilStorageMain
		local NilStorageEnabled

		if getnilinstances then NilStorageEnabled = true end

		if NilStorageEnabled then
			NilStorage = Instance.new("Folder")
			NilStorage.Name = "Dex Internal Storage"
			NilStorageMain = Instance.new("Folder",NilStorage)
			NilStorageMain.Name = "Nil Instances"
		end

		local listFrame = Create('Frame',{
			Name = "List";
			BorderSizePixel = 0;
			BackgroundTransparency = 1;
			ClipsDescendants = true;
			Position = UDim2.new(0,0,0,HEADER_SIZE);
			Size = UDim2.new(1,-GUI_SIZE,1,-HEADER_SIZE);
			Parent = explorerPanel;
		})

		local scrollBar = ScrollBar(false)
		scrollBar.PageIncrement = 1
		Create(scrollBar.GUI,{
			Position = UDim2.new(1,-GUI_SIZE,0,HEADER_SIZE);
			Size = UDim2.new(0,GUI_SIZE,1,-HEADER_SIZE);
			Parent = explorerPanel;
		})

		local scrollBarH = ScrollBar(true)
		scrollBarH.PageIncrement = GUI_SIZE
		Create(scrollBarH.GUI,{
			Position = UDim2.new(0,0,1,-GUI_SIZE);
			Size = UDim2.new(1,-GUI_SIZE,0,GUI_SIZE);
			Visible = false;
			Parent = explorerPanel;
		})

		local headerFrame = Create('Frame',{
			Name = "Header";
			BorderSizePixel = 0;
			BackgroundColor3 = GuiColor.Background;
			BorderColor3 = GuiColor.Border;
			Position = UDim2.new(0,0,0,0);
			Size = UDim2.new(1,0,0,HEADER_SIZE);
			Parent = explorerPanel;
			Create('TextLabel',{
				Text = "Explorer";
				BackgroundTransparency = 1;
				TextColor3 = GuiColor.Text;
				TextXAlignment = 'Left';
				Font = FONT;
				FontSize = FONT_SIZE;
				Position = UDim2.new(0,4,0,0);
				Size = UDim2.new(1,-4,0.5,0);
			});
		})

		local explorerFilter = 	Create('TextBox',{
			Text = "Filter Workspace";
			BackgroundTransparency = 0.8;
			TextColor3 = GuiColor.Text;
			TextXAlignment = 'Left';
			Font = FONT;
			FontSize = FONT_SIZE;
			Position = UDim2.new(0,4,0.5,0);
			Size = UDim2.new(1,-8,0.5,-2);
		});
		explorerFilter.Parent = headerFrame

		SetZIndexOnChanged(explorerPanel)

		local function CreateColor3(r, g, b) return Color3.new(r/255,g/255,b/255) end

		local Styles = {
			Font = Enum.Font.Arial;
			Margin = 5;
			Black = CreateColor3(0,0,0);
			Black2 = CreateColor3(24, 24, 24);
			White = CreateColor3(244,244,244);
			Hover = CreateColor3(2, 128, 144);
			Hover2 = CreateColor3(5, 102, 141);
		}

		local Row = {
			Font = Styles.Font;
			FontSize = Enum.FontSize.Size14;
			TextXAlignment = Enum.TextXAlignment.Left;
			TextColor = Styles.White;
			TextColorOver = Styles.White;
			TextLockedColor = CreateColor3(155,155,155);
			Height = 24;
			BorderColor = CreateColor3(216/4,216/4,216/4);
			BackgroundColor = Styles.Black2;
			BackgroundColorAlternate = CreateColor3(32, 32, 32);
			BackgroundColorMouseover = CreateColor3(40, 40, 40);
			TitleMarginLeft = 15;
		}

		local DropDown = {
			Font = Styles.Font;
			FontSize = Enum.FontSize.Size14;
			TextColor = CreateColor3(255,255,255);
			TextColorOver = Styles.White;
			TextXAlignment = Enum.TextXAlignment.Left;
			Height = 20;
			BackColor = Styles.Black2;
			BackColorOver = Styles.Hover2;
			BorderColor = CreateColor3(45,45,45);
			BorderSizePixel = 2;
			ArrowColor = CreateColor3(160/2,160/2,160/2);
			ArrowColorOver = Styles.Hover;
		}

		local BrickColors = {
			BoxSize = 13;
			BorderSizePixel = 1;
			BorderColor = CreateColor3(160/3,160/3,160/3);
			FrameColor = CreateColor3(160/3,160/3,160/3);
			Size = 20;
			Padding = 4;
			ColorsPerRow = 8;
			OuterBorder = 1;
			OuterBorderColor = Styles.Black;
		}

		local currentRightClickMenu
		local CurrentInsertObjectWindow
		local CurrentFunctionCallerWindow

		local RbxApi

		function ClassCanCreate(IName)
			local success,err = pcall(function() Instance.new(IName) end)
			if err then
				return false
			else
				return true
			end
		end

		function GetClasses()
			if RbxApi == nil then return {} end
			local classTable = {}
			for i,v in pairs(RbxApi.Classes) do
				if ClassCanCreate(v.Name) then
					table.insert(classTable,v.Name)
				end
			end
			return classTable
		end

		local function sortAlphabetic(t, property)
			table.sort(t, 
				function(x,y) return x[property] < y[property]
				end)
		end

		local function FunctionIsHidden(functionData)
			local tags = functionData["tags"]
			for _,name in pairs(tags) do
				if name == "deprecated"
					or name == "hidden"
					or name == "writeonly" then
					return true
				end
			end
			return false
		end

		local function GetAllFunctions(className)
			local class = RbxApi.Classes[className]
			local functions = {}

			if not class then return functions end

			while class do
				if class.Name == "Instance" then break end
				for _,nextFunction in pairs(class.Functions) do
					if not FunctionIsHidden(nextFunction) then
						table.insert(functions, nextFunction)
					end
				end
				class = RbxApi.Classes[class.Superclass]
			end

			sortAlphabetic(functions, "Name")

			return functions
		end

		function GetFunctions()
			if RbxApi == nil then return {} end
			local List = SelectionVar():Get()

			if #List == 0 then return end

			local MyObject = List[1]

			local functionTable = {}
			for i,v in pairs(GetAllFunctions(MyObject.ClassName)) do
				table.insert(functionTable,v)
			end
			return functionTable
		end

		function CreateInsertObjectMenu(choices, currentChoice, readOnly, onClick)
			local mouse = game:GetService("Players").LocalPlayer:GetMouse()
			local totalSize = explorerPanel.Parent.AbsoluteSize.y
			if #choices == 0 then return end

			table.sort(choices, function(a,b) return a < b end)

			local frame = Instance.new("Frame")	
			frame.Name = "InsertObject"
			frame.Size = UDim2.new(0, 200, 1, 0)
			frame.BackgroundTransparency = 1
			frame.Active = true

			local menu = nil
			local arrow = nil
			local expanded = false
			local margin = DropDown.BorderSizePixel;

	--[[
	local button = Instance.new("TextButton")
	button.Font = Row.Font
	button.FontSize = Row.FontSize
	button.TextXAlignment = Row.TextXAlignment
	button.BackgroundTransparency = 1
	button.TextColor3 = Row.TextColor
	if readOnly then
		button.TextColor3 = Row.TextLockedColor
	end
	button.Text = currentChoice
	button.Size = UDim2.new(1, -2 * Styles.Margin, 1, 0)
	button.Position = UDim2.new(0, Styles.Margin, 0, 0)
	button.Parent = frame
	--]]

			local function hideMenu()
				expanded = false
				--showArrow(DropDown.ArrowColor)
				if frame then 
					--frame:Destroy()
					CurrentInsertObjectWindow.Visible = false
				end
			end

			local function showMenu()
				expanded = true
				menu = Instance.new("ScrollingFrame")
				menu.Size = UDim2.new(0,200,1,0)
				menu.CanvasSize = UDim2.new(0, 200, 0, #choices * DropDown.Height)
				menu.Position = UDim2.new(0, margin, 0, 0)
				menu.BackgroundTransparency = 0
				menu.BackgroundColor3 = DropDown.BackColor
				menu.BorderColor3 = DropDown.BorderColor
				menu.BorderSizePixel = DropDown.BorderSizePixel
				menu.TopImage = "rbxasset://textures/blackBkg_square.png"
				menu.MidImage = "rbxasset://textures/blackBkg_square.png"
				menu.BottomImage = "rbxasset://textures/blackBkg_square.png"
				menu.Active = true
				menu.ZIndex = 5
				menu.Parent = frame


				local function choice(name)
					onClick(name)
					hideMenu()
				end

				for i,name in pairs(choices) do
					local option = CreateRightClickMenuItem(name, function()
						choice(name)
					end,1)
					option.Size = UDim2.new(1, 0, 0, 20)
					option.Position = UDim2.new(0, 0, 0, (i - 1) * DropDown.Height)
					option.ZIndex = menu.ZIndex
					option.Parent = menu
				end
			end


			showMenu()


			return frame
		end

		function CreateFunctionCallerMenu(choices, currentChoice, readOnly, onClick)
			local mouse = game:GetService("Players").LocalPlayer:GetMouse()
			local totalSize = explorerPanel.Parent.AbsoluteSize.y
			if #choices == 0 then return end

			table.sort(choices, function(a,b) return a.Name < b.Name end)

			local frame = Instance.new("Frame")	
			frame.Name = "InsertObject"
			frame.Size = UDim2.new(0, 200, 1, 0)
			frame.BackgroundTransparency = 1
			frame.Active = true

			local menu = nil
			local arrow = nil
			local expanded = false
			local margin = DropDown.BorderSizePixel;

			local function hideMenu()
				expanded = false
				--showArrow(DropDown.ArrowColor)
				if frame then 
					--frame:Destroy()
					CurrentInsertObjectWindow.Visible = false
				end
			end

			local function showMenu()
				expanded = true
				menu = Instance.new("ScrollingFrame")
				menu.Size = UDim2.new(0,300,1,0)
				menu.CanvasSize = UDim2.new(0, 300, 0, #choices * DropDown.Height)
				menu.Position = UDim2.new(0, margin, 0, 0)
				menu.BackgroundTransparency = 0
				menu.BackgroundColor3 = DropDown.BackColor
				menu.BorderColor3 = DropDown.BorderColor
				menu.BorderSizePixel = DropDown.BorderSizePixel
				menu.TopImage = "rbxasset://textures/blackBkg_square.png"
				menu.MidImage = "rbxasset://textures/blackBkg_square.png"
				menu.BottomImage = "rbxasset://textures/blackBkg_square.png"
				menu.Active = true
				menu.ZIndex = 5
				menu.Parent = frame

				--local parentFrameHeight = script.Parent.List.Size.Y.Offset
				--local rowHeight = mouse.Y
				--if (rowHeight + menu.Size.Y.Offset) > parentFrameHeight then
				--	menu.Position = UDim2.new(0, margin, 0, -1 * (#choices * DropDown.Height) - margin)
				--end

				local function GetParameters(functionData)
					local paraString = ""
					paraString = paraString.."("
					for i,v in pairs(functionData.Arguments) do
						paraString = paraString..v.Type.." "..v.Name
						if i < #functionData.Arguments then
							paraString = paraString..", "
						end
					end
					paraString = paraString..")"
					return paraString
				end

				local function choice(name)
					onClick(name)
					hideMenu()
				end

				for i,name in pairs(choices) do
					local option = CreateRightClickMenuItem(name.ReturnType.." "..name.Name..GetParameters(name), function()
						choice(name)
					end,2)
					option.Size = UDim2.new(1, 0, 0, 20)
					option.Position = UDim2.new(0, 0, 0, (i - 1) * DropDown.Height)
					option.ZIndex = menu.ZIndex
					option.Parent = menu
				end
			end


			showMenu()


			return frame
		end

		function CreateInsertObject()
			if not CurrentInsertObjectWindow then return end
			CurrentInsertObjectWindow.Visible = true
			if currentRightClickMenu and CurrentInsertObjectWindow.Visible then
				CurrentInsertObjectWindow.Position = UDim2.new(0,currentRightClickMenu.Position.X.Offset-currentRightClickMenu.Size.X.Offset-2,0,0)
			end
			if CurrentInsertObjectWindow.Visible then
				CurrentInsertObjectWindow.Parent = explorerPanel.Parent
			end
		end

		function CreateFunctionCaller(oh)
			if CurrentFunctionCallerWindow then
				CurrentFunctionCallerWindow:Destroy()
				CurrentFunctionCallerWindow = nil
			end
			CurrentFunctionCallerWindow = CreateFunctionCallerMenu(
				GetFunctions(),
				"",
				false,
				function(option)
					CurrentFunctionCallerWindow:Destroy()
					CurrentFunctionCallerWindow = nil
					local list = SelectionVar():Get()
					for i,v in pairs(list) do
						pcall(function() print("Function called.", pcall(function() v[option.Name](v) end)) end)
					end

					DestroyRightClick()
				end
			)
			if currentRightClickMenu and CurrentFunctionCallerWindow then
				CurrentFunctionCallerWindow.Position = UDim2.new(0,currentRightClickMenu.Position.X.Offset-currentRightClickMenu.Size.X.Offset*1.5-2,0,0)
			end
			if CurrentFunctionCallerWindow then
				CurrentFunctionCallerWindow.Parent = explorerPanel.Parent
			end
		end

		local a = {}
		local n = function(c)
			a[c] = a[c] or {ClassName = c}
			return a[c]
		end
		function CreateRightClickMenuItem(text, onClick, insObj)
			local button = Instance.new("TextButton")
			button.Font = DropDown.Font
			button.FontSize = DropDown.FontSize
			button.TextColor3 = DropDown.TextColor
			button.TextXAlignment = DropDown.TextXAlignment
			button.BackgroundColor3 = DropDown.BackColor
			button.AutoButtonColor = false
			button.BorderSizePixel = 0
			button.Active = true
			button.Text = text

			if insObj == 1 then
				local newIcon = Icon(nil,ExplorerIndex[text] or 0,(n(button.Text)),20)
				newIcon.Position = UDim2.new(0,0,0,2)
				newIcon.Size = UDim2.new(0,16,0,16)
				newIcon.IconMap.ZIndex = 5
				newIcon.Parent = button
				button.Text = "     "..button.Text
			elseif insObj == 2 then
				button.FontSize = Enum.FontSize.Size11
			end

			button.MouseEnter:connect(function()
				button.TextColor3 = DropDown.TextColorOver
				button.BackgroundColor3 = DropDown.BackColorOver
				if not insObj and CurrentInsertObjectWindow then
					if CurrentInsertObjectWindow.Visible == false and button.Text == "Insert Object" then
						CreateInsertObject()
					elseif CurrentInsertObjectWindow.Visible and button.Text ~= "Insert Object" then
						CurrentInsertObjectWindow.Visible = false
					end
				end
				if not insObj then
					if CurrentFunctionCallerWindow and button.Text ~= "Call Function" then
						CurrentFunctionCallerWindow:Destroy()
						CurrentFunctionCallerWindow = nil
					elseif button.Text == "Call Function" then
						CreateFunctionCaller()
					end
				end
			end)
			button.MouseLeave:connect(function()
				button.TextColor3 = DropDown.TextColor
				button.BackgroundColor3 = DropDown.BackColor
			end)
			button.MouseButton1Click:connect(function()
				button.TextColor3 = DropDown.TextColor
				button.BackgroundColor3 = DropDown.BackColor
				onClick(text)
			end)	
			return button
		end

		function CreateRightClickMenu(choices, currentChoice, readOnly, onClick)
			local mouse = game:GetService("Players").LocalPlayer:GetMouse()

			local frame = Instance.new("Frame")	
			frame.Name = "DropDown"
			frame.Size = UDim2.new(0, 200, 1, 0)
			frame.BackgroundTransparency = 1
			frame.Active = true

			local menu = nil
			local arrow = nil
			local expanded = false
			local margin = DropDown.BorderSizePixel;

	--[[
	local button = Instance.new("TextButton")
	button.Font = Row.Font
	button.FontSize = Row.FontSize
	button.TextXAlignment = Row.TextXAlignment
	button.BackgroundTransparency = 1
	button.TextColor3 = Row.TextColor
	if readOnly then
		button.TextColor3 = Row.TextLockedColor
	end
	button.Text = currentChoice
	button.Size = UDim2.new(1, -2 * Styles.Margin, 1, 0)
	button.Position = UDim2.new(0, Styles.Margin, 0, 0)
	button.Parent = frame
	--]]

			local function hideMenu()
				expanded = false
				--showArrow(DropDown.ArrowColor)
				if frame then 
					frame:Destroy()
					DestroyRightClick()
				end
			end

			local function showMenu()
				expanded = true
				menu = Instance.new("Frame")
				menu.Size = UDim2.new(0, 200, 0, #choices * DropDown.Height)
				menu.Position = UDim2.new(0, margin, 0, 5)
				menu.BackgroundTransparency = 0
				menu.BackgroundColor3 = DropDown.BackColor
				menu.BorderColor3 = DropDown.BorderColor
				menu.BorderSizePixel = DropDown.BorderSizePixel
				menu.Active = true
				menu.ZIndex = 5
				menu.Parent = frame



				local function choice(name)
					onClick(name)
					hideMenu()
				end

				for i,name in pairs(choices) do
					local option = CreateRightClickMenuItem(name, function()
						choice(name)
					end)
					option.Size = UDim2.new(1, 0, 0, 20)
					option.Position = UDim2.new(0, 0, 0, (i - 1) * DropDown.Height)
					option.ZIndex = menu.ZIndex
					option.Parent = menu
				end
			end


			showMenu()


			return frame
		end

		function checkMouseInGui(gui)
			if gui == nil then return false end
			local plrMouse = game:GetService("Players").LocalPlayer:GetMouse()
			local guiPosition = gui.AbsolutePosition
			local guiSize = gui.AbsoluteSize	

			if plrMouse.X >= guiPosition.x and plrMouse.X <= guiPosition.x + guiSize.x and plrMouse.Y >= guiPosition.y and plrMouse.Y <= guiPosition.y + guiSize.y then
				return true
			else
				return false
			end
		end

		local clipboard = {}
		local function delete(o)
			o.Parent = nil
		end

		local getTextWidth do
			local text = Create('TextLabel',{
				Name = "TextWidth";
				TextXAlignment = 'Left';
				TextYAlignment = 'Center';
				Font = FONT;
				FontSize = FONT_SIZE;
				Text = "";
				Position = UDim2.new(0,0,0,0);
				Size = UDim2.new(1,0,1,0);
				Visible = false;
				Parent = explorerPanel;
			})
			function getTextWidth(s)
				text.Text = s
				return text.TextBounds.x
			end
		end

		local nameScanned = false
		-- Holds the game tree converted to a list.
		local TreeList = {}
		-- Matches objects to their tree node representation.
		local NodeLookup = {}

		local nodeWidth = 0

		local QuickButtons = {}

		function filteringWorkspace()
			if explorerFilter.Text ~= "" and explorerFilter.Text ~= "Filter Workspace" then
				return true
			end
			return false
		end

		function lookForAName(obj,name)
			for i,v in pairs(obj:GetChildren()) do
				if string.find(string.lower(v.Name),string.lower(name)) then nameScanned = true end
				lookForAName(v,name)
			end
		end

		function scanName(obj)
			nameScanned = false
			if string.find(string.lower(obj.Name),string.lower(explorerFilter.Text)) then
				nameScanned = true
			else
				lookForAName(obj,explorerFilter.Text)
			end
			return nameScanned
		end

		function updateActions()
			for i,v in pairs(QuickButtons) do
				if v.Cond() then
					v.Toggle(true)
				else
					v.Toggle(false)
				end
			end
		end

		local updateList,rawUpdateList,updateScroll,rawUpdateSize do
			local function r(t)
				for i = 1,#t do
					if not filteringWorkspace() or scanName(t[i].Object) then
						TreeList[#TreeList+1] = t[i]

						local w = (t[i].Depth)*(2+ENTRY_PADDING+GUI_SIZE) + 2 + ENTRY_SIZE + 4 + getTextWidth(t[i].Object.Name) + 4
						if w > nodeWidth then
							nodeWidth = w
						end
						if t[i].Expanded or filteringWorkspace() then
							r(t[i])
						end
					end
				end
			end

			function rawUpdateSize()
				scrollBarH.TotalSpace = nodeWidth
				scrollBarH.VisibleSpace = listFrame.AbsoluteSize.x
				scrollBarH:Update()
				local visible = scrollBarH:CanScrollDown() or scrollBarH:CanScrollUp()
				scrollBarH.GUI.Visible = visible

				listFrame.Size = UDim2.new(1,-GUI_SIZE,1,-GUI_SIZE*(visible and 1 or 0) - HEADER_SIZE)

				scrollBar.VisibleSpace = math.ceil(listFrame.AbsoluteSize.y/ENTRY_BOUND)
				scrollBar.GUI.Size = UDim2.new(0,GUI_SIZE,1,-GUI_SIZE*(visible and 1 or 0) - HEADER_SIZE)

				scrollBar.TotalSpace = #TreeList+1
				scrollBar:Update()
			end

			function rawUpdateList()
				-- Clear then repopulate the entire list. It appears to be fast enough.
				TreeList = {}
				nodeWidth = 0
				r(NodeLookup[workspace.Parent])
				r(NodeLookup[DexOutput])
				if DexStorageEnabled then
					r(NodeLookup[DexStorage])
				end
				if NilStorageEnabled then
					r(NodeLookup[NilStorage])
				end
				if RunningScriptsStorageEnabled then
					r(NodeLookup[RunningScriptsStorage])
				end
				if LoadedModulesStorageEnabled then
					r(NodeLookup[LoadedModulesStorage])
				end
				rawUpdateSize()
				updateActions()
			end

			-- Adding or removing large models will cause many updates to occur. We
			-- can reduce the number of updates by creating a delay, then dropping any
			-- updates that occur during the delay.
			local updatingList = false
			function updateList()
				if updatingList or filteringWorkspace() then return end
				updatingList = true
				task.wait(0.5)
				updatingList = false
				rawUpdateList()
			end

			local updatingScroll = false
			function updateScroll()
				if updatingScroll then return end
				updatingScroll = true
				task.wait(0.5)
				updatingScroll = false
				scrollBar:Update()
			end
		end

		local Selection do
			local bindGetSelection = explorerPanel:FindFirstChild("GetSelection")
			if not bindGetSelection then
				bindGetSelection = Create('BindableFunction',{Name = "GetSelection"})
				bindGetSelection.Parent = explorerPanel
			end

			local bindSetSelection = explorerPanel:FindFirstChild("SetSelection")
			if not bindSetSelection then
				bindSetSelection = Create('BindableFunction',{Name = "SetSelection"})
				bindSetSelection.Parent = explorerPanel
			end

			local bindSelectionChanged = explorerPanel:FindFirstChild("SelectionChanged")
			if not bindSelectionChanged then
				bindSelectionChanged = Create('BindableEvent',{Name = "SelectionChanged"})
				bindSelectionChanged.Parent = explorerPanel
			end

			local SelectionList = {}
			local SelectionSet = {}
			local Updates = true
			Selection = {
				Selected = SelectionSet;
				List = SelectionList;
			}

			local function addObject(object)
				-- list update
				local lupdate = false
				-- scroll update
				local supdate = false

				if not SelectionSet[object] then
					local node = NodeLookup[object]
					if node then
						table.insert(SelectionList,object)
						SelectionSet[object] = true
						node.Selected = true

						-- expand all ancestors so that selected node becomes visible
						node = node.Parent
						while node do
							if not node.Expanded then
								node.Expanded = true
								lupdate = true
							end
							node = node.Parent
						end
						supdate = true
					end
				end
				return lupdate,supdate
			end

			function Selection:Set(objects, scrolltoobject)
				local lupdate = false
				local supdate = false

				if #SelectionList > 0 then
					for i = 1,#SelectionList do
						local object = SelectionList[i]
						local node = NodeLookup[object]
						if node then
							node.Selected = false
							SelectionSet[object] = nil
						end
					end

					SelectionList = {}
					Selection.List = SelectionList
					supdate = true
				end

				for i = 1,#objects do
					local l,s = addObject(objects[i])
					lupdate = l or lupdate
					supdate = s or supdate
				end

				if lupdate then
					rawUpdateList()
					supdate = true
				elseif supdate then
					scrollBar:Update()
				end

				if supdate then
					if scrolltoobject then
						for i = 1, scrollBar.TotalSpace do
							local node = TreeList[i]
							if node.Object == objects[1] then
								scrollBar.ScrollIndex = (i - (scrollBar.VisibleSpace - 4))
								break
							end
						end
					end
					
					bindSelectionChanged:Fire()
					updateActions()
				end
			end

			function Selection:Add(object)
				local l,s = addObject(object)
				if l then
					rawUpdateList()
					if Updates then
						bindSelectionChanged:Fire()
						updateActions()
					end
				elseif s then
					scrollBar:Update()
					if Updates then
						bindSelectionChanged:Fire()
						updateActions()
					end
				end
			end

			function Selection:StopUpdates()
				Updates = false
			end

			function Selection:ResumeUpdates()
				Updates = true
				bindSelectionChanged:Fire()
				updateActions()
			end

			function Selection:Remove(object,noupdate)
				if SelectionSet[object] then
					local node = NodeLookup[object]
					if node then
						node.Selected = false
						SelectionSet[object] = nil
						for i = 1,#SelectionList do
							if SelectionList[i] == object then
								table.remove(SelectionList,i)
								break
							end
						end

						if not noupdate then
							scrollBar:Update()
						end
						bindSelectionChanged:Fire()
						updateActions()
					end
				end
			end

			function Selection:Get()
				local list = {}
				for i = 1,#SelectionList do
					list[i] = SelectionList[i]
				end
				return list
			end

			bindSetSelection.OnInvoke = function(v1, v2)
				Selection:Set(v1, v2)
			end

			bindGetSelection.OnInvoke = function()
				return Selection:Get()
			end
		end

		function CreateCaution(title,msg)
			local newCaution = CautionWindow
			newCaution.Visible = true
			newCaution.Title.Text = title
			newCaution.MainWindow.Desc.Text = msg
			newCaution.MainWindow.Ok.MouseButton1Up:connect(function()
				newCaution.Visible = false
			end)
		end

		function CreateTableCaution(title,msg)
			if type(msg) ~= "table" then return CreateCaution(title,tostring(msg)) end
			local newCaution = TableCautionWindow:Clone()
			newCaution.Title.Text = title

			local TableList = newCaution.MainWindow.TableResults
			local TableTemplate = newCaution.MainWindow.TableTemplate

			for i,v in pairs(msg) do
				local newResult = TableTemplate:Clone()
				newResult.Type.Text = type(v)
				newResult.Value.Text = tostring(v)
				newResult.Position = UDim2.new(0,0,0,#TableList:GetChildren() * 20)
				newResult.Parent = TableList
				TableList.CanvasSize = UDim2.new(0,0,0,#TableList:GetChildren() * 20)
				newResult.Visible = true
			end
			newCaution.Parent = explorerPanel.Parent
			newCaution.Visible = true
			newCaution.MainWindow.Ok.MouseButton1Up:connect(function()
				newCaution:Destroy()
			end)
		end

		local function Split(str, delimiter)
			local start = 1
			local t = {}
			while true do
				local pos = string.find (str, delimiter, start, true)
				if not pos then
					break
				end
				table.insert (t, string.sub (str, start, pos - 1))
				start = pos + string.len (delimiter)
			end
			table.insert (t, string.sub (str, start))
			return t
		end

		local function ToValue(value,type)
			if type == "Vector2" then
				local list = Split(value,",")
				if #list < 2 then return nil end
				local x = tonumber(list[1]) or 0
				local y = tonumber(list[2]) or 0
				return Vector2.new(x,y)
			elseif type == "Vector3" then
				local list = Split(value,",")
				if #list < 3 then return nil end
				local x = tonumber(list[1]) or 0
				local y = tonumber(list[2]) or 0
				local z = tonumber(list[3]) or 0
				return Vector3.new(x,y,z)
			elseif type == "Color3" then
				local list = Split(value,",")
				if #list < 3 then return nil end
				local r = tonumber(list[1]) or 0
				local g = tonumber(list[2]) or 0
				local b = tonumber(list[3]) or 0
				return Color3.new(r/255,g/255, b/255)
			elseif type == "UDim2" then
				local list = Split(string.gsub(string.gsub(value, "{", ""),"}",""),",")
				if #list < 4 then return nil end
				local xScale = tonumber(list[1]) or 0
				local xOffset = tonumber(list[2]) or 0
				local yScale = tonumber(list[3]) or 0
				local yOffset = tonumber(list[4]) or 0
				return UDim2.new(xScale, xOffset, yScale, yOffset)
			elseif type == "Number" then
				return tonumber(value)
			elseif type == "String" then
				return value
			elseif type == "NumberRange" then
				local list = Split(value,",")
				if #list == 1 then
					if tonumber(list[1]) == nil then return nil end
					local newVal = tonumber(list[1]) or 0
					return NumberRange.new(newVal)
				end
				if #list < 2 then return nil end
				local x = tonumber(list[1]) or 0
				local y = tonumber(list[2]) or 0
				return NumberRange.new(x,y)
			elseif type == "Script" then
				local success,err = ypcall(function()
					_G.D_E_X_DONOTUSETHISPLEASE = nil
					loadstring(
						"_G.D_E_X_DONOTUSETHISPLEASE = "..value
					)()
					return _G.D_E_X_DONOTUSETHISPLEASE
				end)
				if err then
					return nil
				end
			else
				return nil
			end
		end

		local function ToPropValue(value,type)
			if type == "Vector2" then
				local list = Split(value,",")
				if #list < 2 then return nil end
				local x = tonumber(list[1]) or 0
				local y = tonumber(list[2]) or 0
				return Vector2.new(x,y)
			elseif type == "Vector3" then
				local list = Split(value,",")
				if #list < 3 then return nil end
				local x = tonumber(list[1]) or 0
				local y = tonumber(list[2]) or 0
				local z = tonumber(list[3]) or 0
				return Vector3.new(x,y,z)
			elseif type == "Color3" then
				local list = Split(value,",")
				if #list < 3 then return nil end
				local r = tonumber(list[1]) or 0
				local g = tonumber(list[2]) or 0
				local b = tonumber(list[3]) or 0
				return Color3.new(r/255,g/255, b/255)
			elseif type == "UDim2" then
				local list = Split(string.gsub(string.gsub(value, "{", ""),"}",""),",")
				if #list < 4 then return nil end
				local xScale = tonumber(list[1]) or 0
				local xOffset = tonumber(list[2]) or 0
				local yScale = tonumber(list[3]) or 0
				local yOffset = tonumber(list[4]) or 0
				return UDim2.new(xScale, xOffset, yScale, yOffset)
			elseif type == "Content" then
				return value
			elseif type == "float" or type == "int" or type == "double" then
				return tonumber(value)
			elseif type == "string" then
				return value
			elseif type == "NumberRange" then
				local list = Split(value,",")
				if #list == 1 then
					if tonumber(list[1]) == nil then return nil end
					local newVal = tonumber(list[1]) or 0
					return NumberRange.new(newVal)
				end
				if #list < 2 then return nil end
				local x = tonumber(list[1]) or 0
				local y = tonumber(list[2]) or 0
				return NumberRange.new(x,y)
			elseif string.sub(value,1,4) == "Enum" then
				local getEnum = value
				while true do
					local x,y = string.find(getEnum,".")
					if y then
						getEnum = string.sub(getEnum,y+1)
					else
						break
					end
				end
				print(getEnum)
				return getEnum
			else
				return nil
			end
		end

		function PromptRemoteCaller(inst)
			if CurrentRemoteWindow then
				CurrentRemoteWindow:Destroy()
				CurrentRemoteWindow = nil
			end
			CurrentRemoteWindow = RemoteWindow:Clone()
			CurrentRemoteWindow.Parent = explorerPanel.Parent
			CurrentRemoteWindow.Visible = true

			local displayValues = false

			local ArgumentList = CurrentRemoteWindow.MainWindow.Arguments
			local ArgumentTemplate = CurrentRemoteWindow.MainWindow.ArgumentTemplate

			if inst:IsA("RemoteEvent") then
				CurrentRemoteWindow.Title.Text = "Fire Event"
				CurrentRemoteWindow.MainWindow.Ok.Text = "Fire"
				CurrentRemoteWindow.MainWindow.DisplayReturned.Visible = false
				CurrentRemoteWindow.MainWindow.Desc2.Visible = false
			end

			local newArgument = ArgumentTemplate:Clone()
			newArgument.Parent = ArgumentList
			newArgument.Visible = true
			newArgument.Type.MouseButton1Down:connect(function()
				createDDown(newArgument.Type,function(choice)
					newArgument.Type.Text = choice
				end,"Script","Number","String","Color3","Vector3","Vector2","UDim2","NumberRange")
			end)

			CurrentRemoteWindow.MainWindow.Ok.MouseButton1Up:connect(function()
				if CurrentRemoteWindow and inst.Parent ~= nil then
					local MyArguments = {}
					for i,v in pairs(ArgumentList:GetChildren()) do
						table.insert(MyArguments,ToValue(v.Value.Text,v.Type.Text))
					end
					if inst:IsA("RemoteFunction") then
						if displayValues then
							spawn(function()
								local myResults = inst:InvokeServer(unpack(MyArguments))
								if myResults then
									CreateTableCaution("Remote Caller",myResults)
								else
									CreateCaution("Remote Caller","This remote did not return anything.")
								end
							end)
						else
							spawn(function()
								inst:InvokeServer(unpack(MyArguments))
							end)
						end
					else
						inst:FireServer(unpack(MyArguments))
					end
					CurrentRemoteWindow:Destroy()
					CurrentRemoteWindow = nil
				end
			end)

			CurrentRemoteWindow.MainWindow.Add.MouseButton1Up:connect(function()
				if CurrentRemoteWindow then
					local newArgument = ArgumentTemplate:Clone()
					newArgument.Position = UDim2.new(0,0,0,#ArgumentList:GetChildren() * 20)
					newArgument.Parent = ArgumentList
					ArgumentList.CanvasSize = UDim2.new(0,0,0,#ArgumentList:GetChildren() * 20)
					newArgument.Visible = true
					newArgument.Type.MouseButton1Down:connect(function()
						createDDown(newArgument.Type,function(choice)
							newArgument.Type.Text = choice
						end,"Script","Number","String","Color3","Vector3","Vector2","UDim2","NumberRange")
					end)
				end
			end)

			CurrentRemoteWindow.MainWindow.Subtract.MouseButton1Up:connect(function()
				if CurrentRemoteWindow then
					if #ArgumentList:GetChildren() > 1 then
						ArgumentList:GetChildren()[#ArgumentList:GetChildren()]:Destroy()
						ArgumentList.CanvasSize = UDim2.new(0,0,0,#ArgumentList:GetChildren() * 20)
					end
				end
			end)

			CurrentRemoteWindow.MainWindow.Cancel.MouseButton1Up:connect(function()
				if CurrentRemoteWindow then
					CurrentRemoteWindow:Destroy()
					CurrentRemoteWindow = nil
				end
			end)

			CurrentRemoteWindow.MainWindow.DisplayReturned.MouseButton1Up:connect(function()
				if displayValues then
					displayValues = false
					CurrentRemoteWindow.MainWindow.DisplayReturned.enabled.Visible = false
				else
					displayValues = true
					CurrentRemoteWindow.MainWindow.DisplayReturned.enabled.Visible = true
				end
			end)
		end

		function PromptSaveInstance(inst)
			if not SaveInstance and not _G.SaveInstance then CreateCaution("SaveInstance Missing","You do not have the SaveInstance function installed. Please go to RaspberryPi's thread to retrieve it.") return end
			if CurrentSaveInstanceWindow then
				CurrentSaveInstanceWindow:Destroy()
				CurrentSaveInstanceWindow = nil
				if explorerPanel.Parent:FindFirstChild("SaveInstanceOverwriteCaution") then
					explorerPanel.Parent.SaveInstanceOverwriteCaution:Destroy()
				end
			end
			CurrentSaveInstanceWindow = SaveInstanceWindow:Clone()
			CurrentSaveInstanceWindow.Parent = explorerPanel.Parent
			CurrentSaveInstanceWindow.Visible = true

			local filename = CurrentSaveInstanceWindow.MainWindow.FileName
			local saveObjects = true
			local overwriteCaution = false

			CurrentSaveInstanceWindow.MainWindow.Save.MouseButton1Up:connect(function()
		--[[if readfile and getelysianpath then
			if readfile(getelysianpath()..filename.Text..".rbxmx") then
				if not overwriteCaution then
					overwriteCaution = true
					local newCaution = ConfirmationWindow:Clone()
					newCaution.Name = "SaveInstanceOverwriteCaution"
					newCaution.MainWindow.Desc.Text = "The file, "..filename.Text..".rbxmx, already exists. Overwrite?"
					newCaution.Parent = explorerPanel.Parent
					newCaution.Visible = true
					newCaution.MainWindow.Yes.MouseButton1Up:connect(function()
						ypcall(function()
							SaveInstance(inst,filename.Text..".rbxmx",not saveObjects)
						end)
						overwriteCaution = false
						newCaution:Destroy()
						if CurrentSaveInstanceWindow then
							CurrentSaveInstanceWindow:Destroy()
							CurrentSaveInstanceWindow = nil
						end
					end)
					newCaution.MainWindow.No.MouseButton1Up:connect(function()
						overwriteCaution = false
						newCaution:Destroy()
					end)
				end
			else
				ypcall(function()
					SaveInstance(inst,filename.Text..".rbxmx",not saveObjects)
				end)
				if CurrentSaveInstanceWindow then
					CurrentSaveInstanceWindow:Destroy()
					CurrentSaveInstanceWindow = nil
					if explorerPanel.Parent:FindFirstChild("SaveInstanceOverwriteCaution") then
						explorerPanel.Parent.SaveInstanceOverwriteCaution:Destroy()
					end
				end
			end
		else
			ypcall(function()
				if SaveInstance then
					SaveInstance(inst,filename.Text..".rbxmx",not saveObjects)
				else
					_G.SaveInstance(inst,filename.Text,not saveObjects)
				end
			end)
			if CurrentSaveInstanceWindow then
				CurrentSaveInstanceWindow:Destroy()
				CurrentSaveInstanceWindow = nil
				if explorerPanel.Parent:FindFirstChild("SaveInstanceOverwriteCaution") then
					explorerPanel.Parent.SaveInstanceOverwriteCaution:Destroy()
				end
			end
		end]]
			end)
			CurrentSaveInstanceWindow.MainWindow.Cancel.MouseButton1Up:connect(function()
				if CurrentSaveInstanceWindow then
					CurrentSaveInstanceWindow:Destroy()
					CurrentSaveInstanceWindow = nil
					if explorerPanel.Parent:FindFirstChild("SaveInstanceOverwriteCaution") then
						explorerPanel.Parent.SaveInstanceOverwriteCaution:Destroy()
					end
				end
			end)
			CurrentSaveInstanceWindow.MainWindow.SaveObjects.MouseButton1Up:connect(function()
				if saveObjects then
					saveObjects = false
					CurrentSaveInstanceWindow.MainWindow.SaveObjects.enabled.Visible = false
				else
					saveObjects = true
					CurrentSaveInstanceWindow.MainWindow.SaveObjects.enabled.Visible = true
				end
			end)
		end

		function DestroyRightClick()
			if currentRightClickMenu then
				currentRightClickMenu:Destroy()
				currentRightClickMenu = nil
			end
			if CurrentInsertObjectWindow and CurrentInsertObjectWindow.Visible then
				CurrentInsertObjectWindow.Visible = false
			end
		end

		local tabChar = "    "

		local function getSmaller(a, b, notLast)
			local aByte = a:byte() or -1
			local bByte = b:byte() or -1
			if aByte == bByte then
				if notLast and #a == 1 and #b == 1 then
					return -1
				elseif #b == 1 then
					return false
				elseif #a == 1 then
					return true
				else
					return getSmaller(a:sub(2), b:sub(2), notLast)
				end
			else
				return aByte < bByte
			end
		end

		local function parseData(obj, numTabs, isKey, overflow, noTables, forceDict)
			local objType = typeof(obj)
			local objStr = tostring(obj)
			if objType == "table" then
				if noTables then
					return objStr
				end
				local isCyclic = overflow[obj]
				overflow[obj] = true
				local out = {}
				local nextIndex = 1
				local isDict = false
				local hasTables = false
				local data = {}

				for key, val in next, obj do
					if not hasTables and typeof(val) == "table" then
						hasTables = true
					end

					if not isDict and key ~= nextIndex then
						isDict = true
					else
						nextIndex = nextIndex + 1
					end

					data[#data+1] = {key, val}
				end

				if isDict or hasTables or forceDict then
					out[#out+1] = (isCyclic and "Cyclic " or "") .. "{"
					table.sort(data, function(a, b)
						local aType = typeof(a[2])
						local bType = typeof(b[2])
						if bType == "string" and aType ~= "string" then
							return false
						end
						local res = getSmaller(aType, bType, true)
						if res == -1 then
							return getSmaller(tostring(a[1]), tostring(b[1]))
						else
							return res
						end
					end)
					for i = 1, #data do
						local arr = data[i]
						local nowKey = arr[1]
						local nowVal = arr[2]
						local parseKey = parseData(nowKey, numTabs+1, true, overflow, isCyclic)
						local parseVal = parseData(nowVal, numTabs+1, false, overflow, isCyclic)
						if isDict then
							local nowValType = typeof(nowVal)
							local preStr = ""
							local postStr = ""
							if i > 1 and (nowValType == "table" or typeof(data[i-1][2]) ~= nowValType) then
								preStr = "\n"
							end
							if i < #data and nowValType == "table" and typeof(data[i+1][2]) ~= "table" and typeof(data[i+1][2]) == nowValType then
								postStr = "\n"
							end
							out[#out+1] = preStr .. string.rep(tabChar, numTabs+1) .. parseKey .. " = " .. parseVal .. ";" .. postStr
						else
							out[#out+1] = string.rep(tabChar, numTabs+1) .. parseVal .. ";"
						end
					end
					out[#out+1] = string.rep(tabChar, numTabs) .. "}"
				else
					local data2 = {}
					for i = 1, #data do
						local arr = data[i]
						local nowVal = arr[2]
						local parseVal = parseData(nowVal, 0, false, overflow, isCyclic)
						data2[#data2+1] = parseVal
					end
					out[#out+1] = "{" .. table.concat(data2, ", ") .. "}"
				end

				return table.concat(out, "\n")
			else
				local returnVal = nil
				if (objType == "string" or objType == "Content") and (not isKey or tonumber(obj:sub(1, 1))) then
					local retVal = '"' .. objStr .. '"'
					if isKey then
						retVal = "[" .. retVal .. "]"
					end
					returnVal = retVal
				elseif objType == "EnumItem" then
					returnVal = "Enum." .. tostring(obj.EnumType) .. "." .. obj.Name
				elseif objType == "Enum" then
					returnVal = "Enum." .. objStr
				elseif objType == "Instance" then
					returnVal = obj.Parent and obj:GetFullName() or obj.ClassName
				elseif objType == "CFrame" then
					returnVal = "CFrame.new(" .. objStr .. ")"
				elseif objType == "Vector3" then
					returnVal = "Vector3.new(" .. objStr .. ")"
				elseif objType == "Vector2" then
					returnVal = "Vector2.new(" .. objStr .. ")"
				elseif objType == "UDim2" then
					returnVal = "UDim2.new(" .. objStr:gsub("[{}]", "") .. ")"
				elseif objType == "BrickColor" then
					returnVal = "BrickColor.new(\"" .. objStr .. "\")"
				elseif objType == "Color3" then
					returnVal = "Color3.new(" .. objStr .. ")"
				elseif objType == "NumberRange" then
					returnVal = "NumberRange.new(" .. objStr:gsub("^%s*(.-)%s*$", "%1"):gsub(" ", ", ") .. ")"
				elseif objType == "PhysicalProperties" then
					returnVal = "PhysicalProperties.new(" .. objStr .. ")"
				else
					returnVal = objStr
				end
				return returnVal
			end
		end

		function tableToString(t)
			local success, result = pcall(function()
				return parseData(t, 0, false, {}, nil, false)
			end)
			return success and result or 'error';
		end

		local HasSpecial = function(string)
			return (string:match("%c") or string:match("%s") or string:match("%p")) ~= nil
		end

		local GetPath = function(Instance) -- ripped from some random script
			local Obj = Instance
			local string = {}
			local temp = {}
			local error = false

			while Obj ~= game do
				if Obj == nil then
					error = true
					break
				end
				table.insert(temp, Obj.Parent == game and Obj.ClassName or tostring(Obj))
				Obj = Obj.Parent
			end

			table.insert(string, "game:GetService(\"" .. temp[#temp] .. "\")")

			for i = #temp - 1, 1, -1 do
				table.insert(string, HasSpecial(temp[i]) and "[\"" .. temp[i] .. "\"]" or "." .. temp[i])
			end

			return (error and "nil -- Path contained an invalid instance" or table.concat(string, ""))
		end

		function rightClickMenu(sObj)
			local mouse = game:GetService("Players").LocalPlayer:GetMouse()

			local extra = ((sObj == RunningScriptsStorageMain or sObj == LoadedModulesStorageMain or sObj == NilStorageMain) and 'Refresh Instances' or nil)

			currentRightClickMenu = CreateRightClickMenu(
				{
					'Cut',
					'Copy',
					'Paste Into',
					'Duplicate',
					'Delete',
					-- 'Group',
					-- 'Ungroup',
					'Select Children',
					'Teleport To',
					-- 'Insert Part',
					'Insert Object',
					'View Script',
					'Save Script',
					-- 'Save Instance',
					'Copy Path',
					'Call Function',
					'Call Remote',
					extra
				},
				"",
				false,
				function(option)
					if option == "Cut" then
						if not Option.Modifiable then return end
						clipboard = {}
						local list = Selection.List
						local cut = {}
						for i = 1,#list do
							local obj = list[i]:Clone()
							if obj then
								table.insert(clipboard,obj)
								table.insert(cut,list[i])
							end
						end
						for i = 1,#cut do
							pcall(delete,cut[i])
						end
						updateActions()
					elseif option == "Copy" then
						if not Option.Modifiable then return end
						clipboard = {}
						local list = Selection.List
						for i = 1,#list do
							table.insert(clipboard,list[i]:Clone())
						end
						updateActions()
					elseif option == "Paste Into" then
						if not Option.Modifiable then return end
						local parent = Selection.List[1] or workspace
						for i = 1,#clipboard do
							clipboard[i]:Clone().Parent = parent
						end
					elseif option == "Duplicate" then
						if not Option.Modifiable then return end
						local list = Selection:Get()
						for i = 1,#list do
							list[i]:Clone().Parent = Selection.List[1].Parent or workspace
						end
					elseif option == "Delete" then
						if not Option.Modifiable then return end
						local list = Selection:Get()
						for i = 1,#list do
							pcall(delete,list[i])
						end
						Selection:Set({})
					elseif option == "Group" then
						if not Option.Modifiable then return end
						local newModel = Instance.new("Model")
						local list = Selection:Get()
						newModel.Parent = Selection.List[1].Parent or workspace
						for i = 1,#list do
							list[i].Parent = newModel
						end
						Selection:Set({})
					elseif option == "Ungroup" then
						if not Option.Modifiable then return end
						local ungrouped = {}
						local list = Selection:Get()
						for i = 1,#list do
							if list[i]:IsA("Model") then
								for i2,v2 in pairs(list[i]:GetChildren()) do
									v2.Parent = list[i].Parent or workspace
									table.insert(ungrouped,v2)
								end		
								pcall(delete,list[i])			
							end
						end
						Selection:Set({})
						if SettingsRemote:Invoke("SelectUngrouped") then
							for i,v in pairs(ungrouped) do
								Selection:Add(v)
							end
						end
					elseif option == "Select Children" then
						if not Option.Modifiable then return end
						local list = Selection:Get()
						Selection:Set({})
						Selection:StopUpdates()
						for i = 1,#list do
							for i2,v2 in pairs(list[i]:GetChildren()) do
								Selection:Add(v2)
							end
						end
						Selection:ResumeUpdates()
					elseif option == "Teleport To" then
						if not Option.Modifiable then return end
						local list = Selection:Get()
						for i = 1,#list do
							if list[i]:IsA("BasePart") then
								pcall(function()
									game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = list[i].CFrame * CFrame.new(0, 3, 0);
								end)
								break
							end
						end
					elseif option == "Insert Part" then
						if not Option.Modifiable then return end
						local insertedParts = {}
						local list = Selection:Get()
						for i = 1,#list do
							pcall(function()
								local newPart = Instance.new("Part")
								newPart.Parent = list[i]
								newPart.CFrame = CFrame.new(game:GetService("Players").LocalPlayer.Character.Head.Position) + Vector3.new(0,3,0)
								table.insert(insertedParts,newPart)
							end)
						end
					elseif option == "Save Instance" then
						if not Option.Modifiable then return end
						local list = Selection:Get()
						if #list == 1 then
							list[1].Archivable = true
							ypcall(function()PromptSaveInstance(list[1]:Clone())end)
						elseif #list > 1 then
							local newModel = Instance.new("Model")
							newModel.Name = "SavedInstances"
							for i = 1,#list do
								ypcall(function()
									list[i].Archivable = true
									list[i]:Clone().Parent = newModel
								end)
							end
							PromptSaveInstance(newModel)
						end
					elseif option == 'Copy Path' then
						if not Option.Modifiable then return end
						local list = Selection:Get()
						local paths = {};
						for i = 1,#list do
							paths[#paths + 1] = GetPath(list[i]);
						end
						if #paths > 1 then
							setclipboard(tableToString(paths))
						elseif #paths == 1 then
							setclipboard(paths[1])
						end
					elseif option == "Call Remote" then
						if not Option.Modifiable then return end
						local list = Selection:Get()
						for i = 1,#list do
							if list[i]:IsA("RemoteFunction") or list[i]:IsA("RemoteEvent") then
								PromptRemoteCaller(list[i])
								break
							end
						end
					elseif option == "View Script" then
						if not Option.Modifiable then return end
						local list = Selection:Get()
						for i = 1,#list do
							if list[i]:IsA("LocalScript") or list[i]:IsA("ModuleScript") then
								ScriptEditorEvent:Fire(list[i])
							end
						end
					elseif option == "Save Script" then
						if not Option.Modifiable then return end
						local list = Selection:Get()
						for i = 1,#list do
							if list[i]:IsA("LocalScript") or list[i]:IsA("ModuleScript") then
								writefile(game.PlaceId .. '_' .. list[i].Name:gsub('%W', '') .. '_' .. math.random(100000, 999999) .. '.lua', decompile(list[i]));
							end
						end
					elseif option == 'Refresh Instances' then
						if sObj == NilStorageMain then
							for i, v in pairs(getnilinstances()) do
								if v ~= DexOutput and v ~= DexOutputMain and v ~= DexStorage and v ~= DexStorageMain and v ~= RunningScriptsStorage and v ~= RunningScriptsStorageMain and v ~= LoadedModulesStorage and v ~= LoadedModulesStorageMain and v ~= NilStorage and v ~= NilStorageMain then
									pcall(function()
										v:clone().Parent = NilStorageMain;
									end)
								end
							end
						elseif sObj == RunningScriptsStorageMain then
							for i,v in pairs(getscripts()) do
								if v ~= RunningScriptsStorage and v ~= LoadedModulesStorage and v ~= DexStorage and v ~= UpvalueStorage then
									if (v:IsA'LocalScript' or v:IsA'ModuleScript' or v:IsA'Script') then
										v.Archivable = true;
										local ls = v:clone()
										if v:IsA'LocalScript' or v:IsA'Script' then ls.Disabled = true; end
										ls.Parent = RunningScriptsStorageMain
									end
								end
							end
						elseif sObj == LoadedModulesStorageMain then
							for i,v in pairs(getloadedmodules()) do
								if v ~= RunningScriptsStorage and v ~= LoadedModulesStorage and v ~= DexStorage and v ~= UpvalueStorage then
									if (v:IsA'LocalScript' or v:IsA'ModuleScript' or v:IsA'Script') then
										v.Archivable = true;
										local ls = v:clone()
										if v:IsA'LocalScript' or v:IsA'Script' then ls.Disabled = true; end
										ls.Parent = LoadedModulesStorageMain
									end
								end
							end
						end
					end
				end)
			currentRightClickMenu.Parent = explorerPanel.Parent
			currentRightClickMenu.Position = UDim2.new(0,mouse.X,0,mouse.Y)
			if currentRightClickMenu.AbsolutePosition.X + currentRightClickMenu.AbsoluteSize.X > explorerPanel.AbsolutePosition.X + explorerPanel.AbsoluteSize.X then
				currentRightClickMenu.Position = UDim2.new(0, explorerPanel.AbsolutePosition.X + explorerPanel.AbsoluteSize.X - currentRightClickMenu.AbsoluteSize.X, 0, mouse.Y)
			end
		end

		local function cancelReparentDrag()end
		local function cancelSelectDrag()end
		do
			local listEntries = {}
			local nameConnLookup = {}

			local mouseDrag = Create('ImageButton',{
				Name = "MouseDrag";
				Position = UDim2.new(-0.25,0,-0.25,0);
				Size = UDim2.new(1.5,0,1.5,0);
				Transparency = 1;
				AutoButtonColor = false;
				Active = true;
				ZIndex = 10;
			})
			local function dragSelect(last,add,button)
				local connDrag
				local conUp

				conDrag = mouseDrag.MouseMoved:connect(function(x,y)
					local pos = Vector2.new(x,y) - listFrame.AbsolutePosition
					local size = listFrame.AbsoluteSize
					if pos.x < 0 or pos.x > size.x or pos.y < 0 or pos.y > size.y then return end

					local i = math.ceil(pos.y/ENTRY_BOUND) + scrollBar.ScrollIndex
					-- Mouse may have made a large step, so interpolate between the
					-- last index and the current.
					for n = i<last and i or last, i>last and i or last do
						local node = TreeList[n]
						if node then
							if add then
								Selection:Add(node.Object)
							else
								Selection:Remove(node.Object)
							end
						end
					end
					last = i
				end)

				function cancelSelectDrag()
					mouseDrag.Parent = nil
					conDrag:disconnect()
					conUp:disconnect()
					function cancelSelectDrag()end
				end

				conUp = mouseDrag[button]:connect(cancelSelectDrag)

				mouseDrag.Parent = GetScreen(listFrame)
			end

			local function dragReparent(object,dragGhost,clickPos,ghostOffset)
				local connDrag
				local conUp
				local conUp2

				local parentIndex = nil
				local dragged = false

				local parentHighlight = Create('Frame',{
					Transparency = 1;
					Visible = false;
					Create('Frame',{
						BorderSizePixel = 0;
						BackgroundColor3 = Color3.new(0,0,0);
						BackgroundTransparency = 0.1;
						Position = UDim2.new(0,0,0,0);
						Size = UDim2.new(1,0,0,1);
					});
					Create('Frame',{
						BorderSizePixel = 0;
						BackgroundColor3 = Color3.new(0,0,0);
						BackgroundTransparency = 0.1;
						Position = UDim2.new(1,0,0,0);
						Size = UDim2.new(0,1,1,0);
					});
					Create('Frame',{
						BorderSizePixel = 0;
						BackgroundColor3 = Color3.new(0,0,0);
						BackgroundTransparency = 0.1;
						Position = UDim2.new(0,0,1,0);
						Size = UDim2.new(1,0,0,1);
					});
					Create('Frame',{
						BorderSizePixel = 0;
						BackgroundColor3 = Color3.new(0,0,0);
						BackgroundTransparency = 0.1;
						Position = UDim2.new(0,0,0,0);
						Size = UDim2.new(0,1,1,0);
					});
				})
				SetZIndex(parentHighlight,9)

				conDrag = mouseDrag.MouseMoved:connect(function(x,y)
					local dragPos = Vector2.new(x,y)
					if dragged then
						local pos = dragPos - listFrame.AbsolutePosition
						local size = listFrame.AbsoluteSize

						parentIndex = nil
						parentHighlight.Visible = false
						if pos.x >= 0 and pos.x <= size.x and pos.y >= 0 and pos.y <= size.y + ENTRY_SIZE*2 then
							local i = math.ceil(pos.y/ENTRY_BOUND-2)
							local node = TreeList[i + scrollBar.ScrollIndex]
							if node and node.Object ~= object and not object:IsAncestorOf(node.Object) then
								parentIndex = i
								local entry = listEntries[i]
								if entry then
									parentHighlight.Visible = true
									parentHighlight.Position = UDim2.new(0,1,0,entry.AbsolutePosition.y-listFrame.AbsolutePosition.y)
									parentHighlight.Size = UDim2.new(0,size.x-4,0,entry.AbsoluteSize.y)
								end
							end
						end

						dragGhost.Position = UDim2.new(0,dragPos.x+ghostOffset.x,0,dragPos.y+ghostOffset.y)
					elseif (clickPos-dragPos).magnitude > 8 then
						dragged = true
						SetZIndex(dragGhost,9)
						dragGhost.IndentFrame.Transparency = 0.25
						dragGhost.IndentFrame.EntryText.TextColor3 = GuiColor.TextSelected
						dragGhost.Position = UDim2.new(0,dragPos.x+ghostOffset.x,0,dragPos.y+ghostOffset.y)
						dragGhost.Parent = GetScreen(listFrame)
						parentHighlight.Parent = listFrame
					end
				end)

				function cancelReparentDrag()
					mouseDrag.Parent = nil
					conDrag:disconnect()
					conUp:disconnect()
					conUp2:disconnect()
					dragGhost:Destroy()
					parentHighlight:Destroy()
					function cancelReparentDrag()end
				end

				local wasSelected = Selection.Selected[object]
				if not wasSelected and Option.Selectable then
					Selection:Set({object})
				end

				conUp = mouseDrag.MouseButton1Up:connect(function()
					cancelReparentDrag()
					if dragged then
						if parentIndex then
							local parentNode = TreeList[parentIndex + scrollBar.ScrollIndex]
							if parentNode then
								parentNode.Expanded = true

								local parentObj = parentNode.Object
								local function parent(a,b)
									a.Parent = b
								end
								if Option.Selectable then
									local list = Selection.List
									for i = 1,#list do
										pcall(parent,list[i],parentObj)
									end
								else
									pcall(parent,object,parentObj)
								end
							end
						end
					else
						-- do selection click
						if wasSelected and Option.Selectable then
							Selection:Set({})
						end
					end
				end)
				conUp2 = mouseDrag.MouseButton2Down:connect(function()
					cancelReparentDrag()
				end)

				mouseDrag.Parent = GetScreen(listFrame)
			end

			local entryTemplate = Create('ImageButton',{
				Name = "Entry";
				Transparency = 1;
				AutoButtonColor = false;
				Position = UDim2.new(0,0,0,0);
				Size = UDim2.new(1,0,0,ENTRY_SIZE);
				Create('Frame',{
					Name = "IndentFrame";
					BackgroundTransparency = 1;
					BackgroundColor3 = GuiColor.Selected;
					BorderColor3 = GuiColor.BorderSelected;
					Position = UDim2.new(0,0,0,0);
					Size = UDim2.new(1,0,1,0);
					Create(Icon('ImageButton', 0, nil, nil, true),{
						Name = "Expand";
						AutoButtonColor = false;
						Position = UDim2.new(0,-GUI_SIZE,0.5,-GUI_SIZE/2);
						Size = UDim2.new(0,GUI_SIZE,0,GUI_SIZE);
					});
					Create(Icon(nil,0),{
						Name = "ExplorerIcon";
						Position = UDim2.new(0,2+ENTRY_PADDING,0.5,-GUI_SIZE/2);
						Size = UDim2.new(0,GUI_SIZE,0,GUI_SIZE);
					});
					Create('TextLabel',{
						Name = "EntryText";
						BackgroundTransparency = 1;
						TextColor3 = GuiColor.Text;
						TextXAlignment = 'Left';
						TextYAlignment = 'Center';
						Font = FONT;
						FontSize = FONT_SIZE;
						Text = "";
						Position = UDim2.new(0,2+ENTRY_SIZE+4,0,0);
						Size = UDim2.new(1,-2,1,0);
					});
				});
			})

			function scrollBar.UpdateCallback(self)
				for i = 1,self.VisibleSpace do
					local node = TreeList[i + self.ScrollIndex]
					if node then
						local entry = listEntries[i]
						if not entry then
							entry = Create(entryTemplate:Clone(),{
								Position = UDim2.new(0,2,0,ENTRY_BOUND*(i-1)+2);
								Size = UDim2.new(0,nodeWidth,0,ENTRY_SIZE);
								ZIndex = listFrame.ZIndex;
							})
							listEntries[i] = entry

							local expand = entry.IndentFrame.Expand
							expand.MouseEnter:connect(function()
								local node = TreeList[i + self.ScrollIndex]
								if #node > 0 then
									if node.Expanded then
										Icon(expand,NODE_EXPANDED_OVER, nil, nil, true)
									else
										Icon(expand,NODE_COLLAPSED_OVER, nil, nil, true)
									end
								end
							end)
							expand.MouseLeave:connect(function()
								local node = TreeList[i + self.ScrollIndex]
								if #node > 0 then
									if node.Expanded then
										Icon(expand,NODE_EXPANDED, nil, nil, true)
									else
										Icon(expand,NODE_COLLAPSED, nil, nil, true)
									end
								end
							end)
							expand.MouseButton1Down:connect(function()
								local node = TreeList[i + self.ScrollIndex]
								if #node > 0 then
									node.Expanded = not node.Expanded
									if node.Object == explorerPanel.Parent and node.Expanded then
										CreateCaution("Warning","Please be careful when editing instances inside here, this is like the System32 of Dex and modifying objects here can break Dex.")
									end
									-- use raw update so the list updates instantly
									rawUpdateList()
								end
							end)

							entry.MouseButton1Down:connect(function(x,y)
								local node = TreeList[i + self.ScrollIndex]
								DestroyRightClick()
								if GetAwaitRemote:Invoke() then
									bindSetAwaiting:Fire(node.Object)
									return
								end

								if not HoldingShift then
									lastSelectedNode = i + self.ScrollIndex
								end

								if HoldingShift and not filteringWorkspace() then
									if lastSelectedNode then
										if i + self.ScrollIndex - lastSelectedNode > 0 then
											Selection:StopUpdates()
											for i2 = 1, i + self.ScrollIndex - lastSelectedNode do
												local newNode = TreeList[lastSelectedNode + i2]
												if newNode then
													Selection:Add(newNode.Object)
												end
											end
											Selection:ResumeUpdates()
										else
											Selection:StopUpdates()
											for i2 = i + self.ScrollIndex - lastSelectedNode, 1 do
												local newNode = TreeList[lastSelectedNode + i2]
												if newNode then
													Selection:Add(newNode.Object)
												end
											end
											Selection:ResumeUpdates()
										end
									end
									return
								end

								if HoldingCtrl then
									if Selection.Selected[node.Object] then
										Selection:Remove(node.Object)
									else
										Selection:Add(node.Object)
									end
									return
								end
								if Option.Modifiable then
									local pos = Vector2.new(x,y)
									dragReparent(node.Object,entry:Clone(),pos,entry.AbsolutePosition-pos)
								elseif Option.Selectable then
									if Selection.Selected[node.Object] then
										Selection:Set({})
									else
										Selection:Set({node.Object})
									end
									dragSelect(i+self.ScrollIndex,true,'MouseButton1Up')
								end
							end)

							entry.MouseButton2Down:connect(function()
								if not Option.Selectable then return end

								DestroyRightClick()

								curSelect = entry

								local node = TreeList[i + self.ScrollIndex]

								if GetAwaitRemote:Invoke() then
									bindSetAwaiting:Fire(node.Object)
									return
								end

								if not Selection.Selected[node.Object] then
									Selection:Set({node.Object})
								end
							end)


							entry.MouseButton2Up:connect(function()
								if not Option.Selectable then return end

								local node = TreeList[i + self.ScrollIndex]

								if checkMouseInGui(curSelect) then
									rightClickMenu(node.Object)
								end
							end)

							entry.Parent = listFrame
						end

						entry.Visible = true

						local object = node.Object

						-- update expand icon
						if #node == 0 then
							entry.IndentFrame.Expand.Visible = false
						elseif node.Expanded then
							Icon(entry.IndentFrame.Expand,NODE_EXPANDED, nil, nil, true)
							entry.IndentFrame.Expand.Visible = true
						else
							Icon(entry.IndentFrame.Expand,NODE_COLLAPSED, nil, nil, true)
							entry.IndentFrame.Expand.Visible = true
						end

						-- update explorer icon
						Icon(entry.IndentFrame.ExplorerIcon,ExplorerIndex[object.ClassName] or 0,object)

						-- update indentation
						local w = (node.Depth)*(2+ENTRY_PADDING+GUI_SIZE)
						entry.IndentFrame.Position = UDim2.new(0,w,0,0)
						entry.IndentFrame.Size = UDim2.new(1,-w,1,0)

						-- update name change detection
						if nameConnLookup[entry] then
							nameConnLookup[entry]:disconnect()
						end
						local text = entry.IndentFrame.EntryText
						text.Text = object.Name
						nameConnLookup[entry] = node.Object.Changed:connect(function(p)
							if p == 'Name' then
								text.Text = object.Name
							end
						end)

						-- update selection
						entry.IndentFrame.Transparency = node.Selected and 0 or 1
						text.TextColor3 = GuiColor[node.Selected and 'TextSelected' or 'Text']

						entry.Size = UDim2.new(0,nodeWidth,0,ENTRY_SIZE)
					elseif listEntries[i] then
						listEntries[i].Visible = false
					end
				end
				for i = self.VisibleSpace+1,self.TotalSpace do
					local entry = listEntries[i]
					if entry then
						listEntries[i] = nil
						entry:Destroy()
					end
				end
			end

			function scrollBarH.UpdateCallback(self)
				for i = 1,scrollBar.VisibleSpace do
					local node = TreeList[i + scrollBar.ScrollIndex]
					if node then
						local entry = listEntries[i]
						if entry then
							entry.Position = UDim2.new(0,2 - scrollBarH.ScrollIndex,0,ENTRY_BOUND*(i-1)+2)
						end
					end
				end
			end

			Connect(listFrame.Changed,function(p)
				if p == 'AbsoluteSize' then
					rawUpdateSize()
				end
			end)

			local wheelAmount = 6
			explorerPanel.MouseWheelForward:connect(function()
				if scrollBar.VisibleSpace - 1 > wheelAmount then
					scrollBar:ScrollTo(scrollBar.ScrollIndex - wheelAmount)
				else
					scrollBar:ScrollTo(scrollBar.ScrollIndex - scrollBar.VisibleSpace)
				end
			end)
			explorerPanel.MouseWheelBackward:connect(function()
				if scrollBar.VisibleSpace - 1 > wheelAmount then
					scrollBar:ScrollTo(scrollBar.ScrollIndex + wheelAmount)
				else
					scrollBar:ScrollTo(scrollBar.ScrollIndex + scrollBar.VisibleSpace)
				end
			end)
		end

		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		---- Object detection

		-- Inserts `v` into `t` at `i`. Also sets `Index` field in `v`.
		local function insert(t,i,v)
			for n = #t,i,-1 do
				local v = t[n]
				v.Index = n+1
				t[n+1] = v
			end
			v.Index = i
			t[i] = v
		end

		-- Removes `i` from `t`. Also sets `Index` field in removed value.
		local function remove(t,i)
			local v = t[i]
			for n = i+1,#t do
				local v = t[n]
				v.Index = n-1
				t[n-1] = v
			end
			t[#t] = nil
			v.Index = 0
			return v
		end

		-- Returns how deep `o` is in the tree.
		local function depth(o)
			local d = -1
			while o do
				o = o.Parent
				d = d + 1
			end
			return d
		end


		local connLookup = {}

		-- Returns whether a node would be present in the tree list
		local function nodeIsVisible(node)
			local visible = true
			node = node.Parent
			while node and visible do
				visible = visible and node.Expanded
				node = node.Parent
			end
			return visible
		end

		-- Removes an object's tree node. Called when the object stops existing in the
		-- game tree.
		local function removeObject(object)
			local objectNode = NodeLookup[object]
			if not objectNode then
				return
			end

			local visible = nodeIsVisible(objectNode)

			Selection:Remove(object,true)

			local parent = objectNode.Parent
			remove(parent,objectNode.Index)
			NodeLookup[object] = nil
			connLookup[object]:disconnect()
			connLookup[object] = nil

			if visible then
				updateList()
			elseif nodeIsVisible(parent) then
				updateScroll()
			end
		end

		-- Moves a tree node to a new parent. Called when an existing object's parent
		-- changes.
		local function moveObject(object,parent)
			local objectNode = NodeLookup[object]
			if not objectNode then
				return
			end

			local parentNode = NodeLookup[parent]
			if not parentNode then
				return
			end

			local visible = nodeIsVisible(objectNode)

			remove(objectNode.Parent,objectNode.Index)
			objectNode.Parent = parentNode

			objectNode.Depth = depth(object)
			local function r(node,d)
				for i = 1,#node do
					node[i].Depth = d
					r(node[i],d+1)
				end
			end
			r(objectNode,objectNode.Depth+1)

			insert(parentNode,#parentNode+1,objectNode)

			if visible or nodeIsVisible(objectNode) then
				updateList()
			elseif nodeIsVisible(objectNode.Parent) then
				updateScroll()
			end
		end

		local InstanceBlacklist = {
			'Instance';
			'VRService';
			'ContextActionService';
			'AssetService';
			'TouchInputService';
			'ScriptContext';
			'FilteredSelection';
			'MeshContentProvider';
			'SolidModelContentProvider';
			'AnalyticsService';
			'RobloxReplicatedStorage';
			'GamepadService';
			'HapticService';
			'ChangeHistoryService';
			'Visit';
			'SocialService';
			'SpawnerService';
			'FriendService';
			'Geometry';
			'BadgeService';
			'PhysicsService';
			'CollectionService';
			'TeleportService';
			'HttpRbxApiService';
			'TweenService';
			'TextService';
			'NotificationService';
			'AdService';
			'CSGDictionaryService';
			'ControllerService';
			'RuntimeScriptService';
			'ScriptService';
			'MouseService';
			'KeyboardService';
			'CookiesService';
			'TimerService';
			'GamePassService';
			'KeyframeSequenceProvider';
			'NonReplicatedCSGDictionaryService';
			'GuidRegistryService';
			'PathfindingService';
			'GroupService';
		}

		for i, v in ipairs(InstanceBlacklist) do
			InstanceBlacklist[v] = true;
			InstanceBlacklist[i] = nil;
		end

		-- ScriptContext['/Libraries/LibraryRegistration/LibraryRegistration']
		-- This RobloxLocked object lets me index its properties for some reason

		local function check(object)
			return object.AncestryChanged
		end

		-- Creates a new tree node from an object. Called when an object starts
		-- existing in the game tree.
		local function addObject(object,noupdate)
			local s,e = pcall(function()
				if object.Parent == game and InstanceBlacklist[object.ClassName] or object.ClassName == '' then
					return true;
				end
			end)
			if(s) then
				if(e) then
					return;
				end
			else
				return;
			end

			if script then
				-- protect against naughty RobloxLocked objects
				local s = pcall(check,object)
				if not s then
					return
				end
			end

			local parentNode = NodeLookup[object.Parent]
			if not parentNode then
				return
			end

			local objectNode = {
				Object = object;
				Parent = parentNode;
				Index = 0;
				Expanded = false;
				Selected = false;
				Depth = depth(object);
			}

			connLookup[object] = Connect(object.AncestryChanged,function(c,p)
				if c == object then
					if p == nil then
						removeObject(c)
					else
						moveObject(c,p)
					end
				end
			end)

			NodeLookup[object] = objectNode
			insert(parentNode,#parentNode+1,objectNode)

			if not noupdate then
				if nodeIsVisible(objectNode) then
					updateList()
				elseif nodeIsVisible(objectNode.Parent) then
					updateScroll()
				end
			end
		end

		local function makeObject(obj,par)
			local newObject = Instance.new(obj.ClassName)
			for i,v in pairs(obj.Properties) do
				ypcall(function()
					local newProp
					newProp = ToPropValue(v.Value,v.Type)
					newObject[v.Name] = newProp
				end)
			end
			newObject.Parent = par
		end

		local function writeObject(obj)
			local newObject = {ClassName = obj.ClassName, Properties = {}}
			for i,v in pairs(RbxApi.GetProperties(obj.className)) do
				if v["Name"] ~= "Parent" then
					print("thispassed")
					table.insert(newObject.Properties,{Name = v["Name"], Type = v["ValueType"], Value = tostring(obj[v["Name"]])})
				end
			end
			return newObject
		end



		local dexStorageDebounce = false
		local dexStorageListeners = {}

		local function updateDexStorage()
			if dexStorageDebounce then return end
			dexStorageDebounce = true	

			wait()

			pcall(function()
				-- saveinstance("content//DexStorage.rbxm",DexStorageMain)
			end)

			updateDexStorageListeners()

			dexStorageDebounce = false
	--[[
	local success,err = ypcall(function()
		local objs = {}
		for i,v in pairs(DexStorageMain:GetChildren()) do
			table.insert(objs,writeObject(v))
		end
		writefile(getelysianpath().."DexStorage.txt",game:GetService("HttpService"):JSONEncode(objs))
		--game:GetService("CookiesService"):SetCookieValue("DexStorage",game:GetService("HttpService"):JSONEncode(objs))
	end)
	if err then
		CreateCaution("DexStorage Save Fail!","DexStorage broke! If you see this message, report to Raspberry Pi!")
	end
	print("hi")
	--]]
		end

		function updateDexStorageListeners()
			for i,v in pairs(dexStorageListeners) do
				v:Disconnect()
			end
			dexStorageListeners = {}
			for i,v in pairs(DexStorageMain:GetChildren()) do
				pcall(function()
					local ev = v.Changed:connect(updateDexStorage)
					table.insert(dexStorageListeners,ev)
				end)
			end
		end

		do
			NodeLookup[workspace.Parent] = {
				Object = workspace.Parent;
				Parent = nil;
				Index = 0;
				Expanded = true;
			}

			NodeLookup[DexOutput] = {
				Object = DexOutput;
				Parent = nil;
				Index = 0;
				Expanded = true;
			}

			if DexStorageEnabled then
				NodeLookup[DexStorage] = {
					Object = DexStorage;
					Parent = nil;
					Index = 0;
					Expanded = true;
				}
			end

			if NilStorageEnabled then
				NodeLookup[NilStorage] = {
					Object = NilStorage;
					Parent = nil;
					Index = 0;
					Expanded = true;
				}
			end

			if RunningScriptsStorageEnabled then
				NodeLookup[RunningScriptsStorage] = {
					Object = RunningScriptsStorage;
					Parent = nil;
					Index = 0;
					Expanded = true;
				}
			end

			if LoadedModulesStorageEnabled then
				NodeLookup[LoadedModulesStorage] = {
					Object = LoadedModulesStorage;
					Parent = nil;
					Index = 0;
					Expanded = true;
				}
			end

			Connect(game.DescendantAdded,addObject)
			Connect(game.DescendantRemoving,removeObject)

			Connect(DexOutput.DescendantAdded,addObject)
			Connect(DexOutput.DescendantRemoving,removeObject)

			if DexStorageEnabled then
		--[[
		if readfile(getelysianpath().."DexStorage.txt") == nil then
			writefile(getelysianpath().."DexStorage.txt","")
		end
		--]]

				Connect(DexStorage.DescendantAdded,addObject)
				Connect(DexStorage.DescendantRemoving,removeObject)

				Connect(DexStorage.DescendantAdded,updateDexStorage)
				Connect(DexStorage.DescendantRemoving,updateDexStorage)
			end

			if NilStorageEnabled then
				Connect(NilStorage.DescendantAdded,addObject)
				Connect(NilStorage.DescendantRemoving,removeObject)		

		--[[local currentTable = get_nil_instances()	
		
		spawn(function()
			while wait() do
				if #currentTable ~= #get_nil_instances() then
					currentTable = get_nil_instances()
					--NilStorageMain:ClearAllChildren()
					for i,v in pairs(get_nil_instances()) do
						if v ~= NilStorage and v ~= DexStorage then
							pcall(function()
								v.Parent = NilStorageMain
							end)
							--[ [
							local newNil = v
							newNil.Archivable = true
							newNil:Clone().Parent = NilStorageMain
							-- ] ]
						end
					end
				end
			end
		end)]]
			end
			if RunningScriptsStorageEnabled then
				Connect(RunningScriptsStorage.DescendantAdded,addObject)
				Connect(RunningScriptsStorage.DescendantRemoving,removeObject)
			end
			if LoadedModulesStorageEnabled then
				Connect(LoadedModulesStorage.DescendantAdded,addObject)
				Connect(LoadedModulesStorage.DescendantRemoving,removeObject)
			end

			local function get(o)
				return o:GetDescendants()
			end

			local function r(o)
				local s,children = pcall(get, o)
				if s then
					for i = 1,#children do
						addObject(children[i],true);
					end
				end
			end

			r(workspace.Parent)
			r(DexOutput)
			if DexStorageEnabled then
				r(DexStorage)
			end
			if NilStorageEnabled then
				r(NilStorage)
			end
			if RunningScriptsStorageEnabled then
				r(RunningScriptsStorage)
			end
			if LoadedModulesStorageEnabled then
				r(LoadedModulesStorage)
			end

			scrollBar.VisibleSpace = math.ceil(listFrame.AbsoluteSize.y/ENTRY_BOUND)
			updateList()
		end

		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		---- Actions

		local actionButtons do
			actionButtons = {}

			local totalActions = 1
			local currentActions = totalActions
			local function makeButton(icon,over,name,vis,cond)
				local buttonEnabled = false

				local button = Create(Icon('ImageButton',icon),{
					Name = name .. "Button";
					Visible = Option.Modifiable and Option.Selectable;
					Position = UDim2.new(1,-(GUI_SIZE+2)*currentActions+2,0.25,-GUI_SIZE/2);
					Size = UDim2.new(0,GUI_SIZE,0,GUI_SIZE);
					Parent = headerFrame;
				})

				local tipText = Create('TextLabel',{
					Name = name .. "Text";
					Text = name;
					Visible = false;
					BackgroundTransparency = 1;
					TextXAlignment = 'Right';
					Font = FONT;
					FontSize = FONT_SIZE;
					Position = UDim2.new(0,0,0,0);
					Size = UDim2.new(1,-(GUI_SIZE+2)*totalActions,1,0);
					Parent = headerFrame;
				})


				button.MouseEnter:connect(function()
					if buttonEnabled then
						button.BackgroundTransparency = 0.9
					end
					--Icon(button,over)
					--tipText.Visible = true
				end)
				button.MouseLeave:connect(function()
					button.BackgroundTransparency = 1
					--Icon(button,icon)
					--tipText.Visible = false
				end)

				currentActions = currentActions + 1
				actionButtons[#actionButtons+1] = {Obj = button,Cond = cond}
				QuickButtons[#actionButtons+1] = {Obj = button,Cond = cond, Toggle = function(on)
					if on then
						buttonEnabled = true
						Icon(button,over, nil, nil, true)
					else
						buttonEnabled = false
						Icon(button,icon, nil, nil, true)
					end
				end}
				return button
			end

			--local clipboard = {}
			local function delete(o)
				o.Parent = nil
			end

			makeButton(ACTION_EDITQUICKACCESS,ACTION_EDITQUICKACCESS,"Options",true,function()return true end).MouseButton1Click:connect(function()

			end)


			-- DELETE
			makeButton(ACTION_DELETE,ACTION_DELETE_OVER,"Delete",true,function() return #Selection:Get() > 0 end).MouseButton1Click:connect(function()
				if not Option.Modifiable then return end
				local list = Selection:Get()
				for i = 1,#list do
					pcall(delete,list[i])
				end
				Selection:Set({})
			end)

			-- PASTE
			makeButton(ACTION_PASTE,ACTION_PASTE_OVER,"Paste",true,function() return #Selection:Get() > 0 and #clipboard > 0 end).MouseButton1Click:connect(function()
				if not Option.Modifiable then return end
				local parent = Selection.List[1] or workspace
				for i = 1,#clipboard do
					clipboard[i]:Clone().Parent = parent
				end
			end)

			-- COPY
			makeButton(ACTION_COPY,ACTION_COPY_OVER,"Copy",true,function() return #Selection:Get() > 0 end).MouseButton1Click:connect(function()
				if not Option.Modifiable then return end
				clipboard = {}
				local list = Selection.List
				for i = 1,#list do
					table.insert(clipboard,list[i]:Clone())
				end
				updateActions()
			end)

			-- CUT
			makeButton(ACTION_CUT,ACTION_CUT_OVER,"Cut",true,function() return #Selection:Get() > 0 end).MouseButton1Click:connect(function()
				if not Option.Modifiable then return end
				clipboard = {}
				local list = Selection.List
				local cut = {}
				for i = 1,#list do
					local obj = list[i]:Clone()
					if obj then
						table.insert(clipboard,obj)
						table.insert(cut,list[i])
					end
				end
				for i = 1,#cut do
					pcall(delete,cut[i])
				end
				updateActions()
			end)

			-- FREEZE
			makeButton(ACTION_FREEZE,ACTION_FREEZE,"Freeze",true,function() return true end)

			-- ADD/REMOVE STARRED
			makeButton(ACTION_ADDSTAR,ACTION_ADDSTAR_OVER,"Star",true,function() return #Selection:Get() > 0 end)

			-- STARRED
			makeButton(ACTION_STARRED,ACTION_STARRED,"Starred",true,function() return true end)


			-- SORT
			-- local actionSort = makeButton(ACTION_SORT,ACTION_SORT_OVER,"Sort")
		end

		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		----------------------------------------------------------------
		---- Option Bindables

		do
			local optionCallback = {
				Modifiable = function(value)
					for i = 1,#actionButtons do
						actionButtons[i].Obj.Visible = value and Option.Selectable
					end
					cancelReparentDrag()
				end;
				Selectable = function(value)
					for i = 1,#actionButtons do
						actionButtons[i].Obj.Visible = value and Option.Modifiable
					end
					cancelSelectDrag()
					Selection:Set({})
				end;
			}

			local bindSetOption = explorerPanel:FindFirstChild("SetOption")
			if not bindSetOption then
				bindSetOption = Create('BindableFunction',{Name = "SetOption"})
				bindSetOption.Parent = explorerPanel
			end

			bindSetOption.OnInvoke = function(optionName,value)
				if optionCallback[optionName] then
					Option[optionName] = value
					optionCallback[optionName](value)
				end
			end

			local bindGetOption = explorerPanel:FindFirstChild("GetOption")
			if not bindGetOption then
				bindGetOption = Create('BindableFunction',{Name = "GetOption"})
				bindGetOption.Parent = explorerPanel
			end

			bindGetOption.OnInvoke = function(optionName)
				if optionName then
					return Option[optionName]
				else
					local options = {}
					for k,v in pairs(Option) do
						options[k] = v
					end
					return options
				end
			end
		end

		function SelectionVar()
			return Selection
		end

		Input.InputBegan:connect(function(key)
			if key.KeyCode == Enum.KeyCode.LeftControl then
				HoldingCtrl = true
			end
			if key.KeyCode == Enum.KeyCode.LeftShift then
				HoldingShift = true
			end
		end)

		Input.InputEnded:connect(function(key)
			if key.KeyCode == Enum.KeyCode.LeftControl then
				HoldingCtrl = false
			end
			if key.KeyCode == Enum.KeyCode.LeftShift then
				HoldingShift = false
			end
		end)

		while RbxApi == nil do
			RbxApi = GetApiRemote:Invoke()
			wait()
		end

--[[
explorerFilter.Changed:connect(function(prop)
	if prop == "Text" then
		rawUpdateList()
	end
end)
]] -- literally just free lag

		explorerFilter.FocusLost:Connect(function(EnterPressed)
			if EnterPressed then
				rawUpdateList()
			end
		end)

		CurrentInsertObjectWindow = CreateInsertObjectMenu(
			GetClasses(),
			"",
			false,
			function(option)
				CurrentInsertObjectWindow.Visible = false
				local list = SelectionVar():Get()
				for i = 1,#list do
					pcall(function() Instance.new(option,list[i]) end)
				end
				DestroyRightClick()
			end
		)
	end)

	spawn(function() -- Idk3
		local editor = Gui:WaitForChild("ScriptEditor");
		local bindable = editor:WaitForChild("OpenScript");

		local SaveScript = editor:WaitForChild("TopBar"):WaitForChild("Other"):WaitForChild('SaveScript')
		local CopyScript = editor:WaitForChild("TopBar"):WaitForChild("Other"):WaitForChild('CopyScript');
		local ClearScript = editor:WaitForChild("TopBar"):WaitForChild("Other"):WaitForChild('ClearScript');
		local CloseEditor = editor:WaitForChild("TopBar"):WaitForChild("Close");
		local FileName = editor:WaitForChild("TopBar"):WaitForChild("Other"):WaitForChild('FileName');
		local Title	= editor:WaitForChild("TopBar"):WaitForChild("title");

		local cache = {};
		local GetDebugId = game.GetDebugId;

		local dragger = {}; do
			local mouse = game:GetService("Players").LocalPlayer:GetMouse();
			local inputService = game:GetService('UserInputService');
			local heartbeat = game:GetService("RunService").Heartbeat;
			-- // credits to Ririchi / Inori for this cute drag function :)
			function dragger.new(frame)
				frame.Draggable = false;

				local s, event = pcall(function()
					return frame.MouseEnter
				end)

				if s then
					frame.Active = true;

					event:connect(function()
						local input = frame.InputBegan:connect(function(key)
							if key.UserInputType == Enum.UserInputType.MouseButton1 then
								local objectPosition = Vector2.new(mouse.X - frame.AbsolutePosition.X, mouse.Y - frame.AbsolutePosition.Y);
								while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
									pcall(function()
										frame:TweenPosition(UDim2.new(0, mouse.X - objectPosition.X + (frame.Size.X.Offset * frame.AnchorPoint.X), 0, mouse.Y - objectPosition.Y + (frame.Size.Y.Offset * frame.AnchorPoint.Y)), 'Out', 'Quad', 0.1, true);
									end)
								end
							end
						end)

						local leave;
						leave = frame.MouseLeave:connect(function()
							input:disconnect();
							leave:disconnect();
						end)
					end)
				end
			end
		end

		dragger.new(editor)

		local newline, tab = "\n", "\t"
		local TabText = (" "):rep(4)
		local min, max, floor, ceil = math.min, math.max, math.floor, math.ceil
		local sub, gsub, match, gmatch, find = string.sub, string.gsub, string.match, string.gmatch, string.find
		local toNumber = tonumber
		local udim2 = UDim2.new
		local newInst = Instance.new
		local SplitCacheResult, SplitCacheStr, SplitCacheDel
		function Split(str, del)
			if SplitCacheStr == str and SplitCacheDel == del then
				return SplitCacheResult
			end
			local res = {}
			if #del == 0 then
				for i in gmatch(str, ".") do
					res[#res + 1] = i
				end
			else
				local i = 0
				local Si = 1
				local si
				str = str .. del
				while i do
					si, Si, i = i, find(str, del, i + 1, true)
					if i == nil then
						return res
					end
					res[#res + 1] = sub(str, si + 1, Si - 1)
				end
			end
			SplitCacheResult, SplitCacheStr, SplitCacheDel = res, str, del
			return res
		end
		local Place = {}
		function Place.new(X, Y)
			return {X = X, Y = Y}
		end

		local Lexer; do
			local find, match, rep, sub = string.find, string.match, string.rep, string.sub
			local lua_builtin = {
				"assert",
				"collectgarbage",
				"error",
				"_G",
				"gcinfo",
				"getfenv",
				"getmetatable",
				"ipairs",
				"loadstring",
				"newproxy",
				"next",
				"pairs",
				"pcall",
				"print",
				"rawequal",
				"rawget",
				"rawset",
				"select",
				"setfenv",
				"setmetatable",
				"tonumber",
				"tostring",
				"type",
				"unpack",
				"_VERSION",
				"xpcall",
				"delay",
				"elapsedTime",
				"require",
				"spawn",
				"tick",
				"time",
				"typeof",
				"UserSettings",
				"wait",
				"warn",
				"game",
				"Enum",
				"script",
				"shared",
				"workspace",
				"Axes",
				"BrickColor",
				"CFrame",
				"Color3",
				"ColorSequence",
				"ColorSequenceKeypoint",
				"Faces",
				"Instance",
				"NumberRange",
				"NumberSequence",
				"NumberSequenceKeypoint",
				"PhysicalProperties",
				"Random",
				"Ray",
				"Rect",
				"Region3",
				"Region3int16",
				"TweenInfo",
				"UDim",
				"UDim2",
				"Vector2",
				"Vector3",
				"Vector3int16",
				"next",
				"os",
				"os.time",
				"os.date",
				"os.difftime",
				"debug",
				"debug.traceback",
				"debug.profilebegin",
				"debug.profileend",
				"math",
				"math.abs",
				"math.acos",
				"math.asin",
				"math.atan",
				"math.atan2",
				"math.ceil",
				"math.clamp",
				"math.cos",
				"math.cosh",
				"math.deg",
				"math.exp",
				"math.floor",
				"math.fmod",
				"math.frexp",
				"math.ldexp",
				"math.log",
				"math.log10",
				"math.max",
				"math.min",
				"math.modf",
				"math.noise",
				"math.pow",
				"math.rad",
				"math.random",
				"math.randomseed",
				"math.sign",
				"math.sin",
				"math.sinh",
				"math.sqrt",
				"math.tan",
				"math.tanh",
				"coroutine",
				"coroutine.create",
				"coroutine.resume",
				"coroutine.running",
				"coroutine.status",
				"coroutine.wrap",
				"coroutine.yield",
				"string",
				"string.byte",
				"string.char",
				"string.dump",
				"string.find",
				"string.format",
				"string.len",
				"string.lower",
				"string.match",
				"string.rep",
				"string.reverse",
				"string.sub",
				"string.upper",
				"string.gmatch",
				"string.gsub",
				"table",
				"table.concat",
				"table.insert",
				"table.remove",
				"table.sort"
			}
			local Keywords = {
				["and"] = true,
				["break"] = true,
				["do"] = true,
				["else"] = true,
				["elseif"] = true,
				["end"] = true,
				["false"] = true,
				["for"] = true,
				["function"] = true,
				["if"] = true,
				["in"] = true,
				["local"] = true,
				["nil"] = true,
				["not"] = true,
				["or"] = true,
				["repeat"] = true,
				["return"] = true,
				["then"] = true,
				["true"] = true,
				["until"] = true,
				["while"] = true;
				["self"] = true;
			}
			local Tokens = {
				Comment = 1,
				Keyword = 2,
				Number = 3,
				Operator = 4,
				String = 5,
				Identifier = 6,
				Builtin = 7,
				Symbol = 19400
			}

			local Stream; do
				local sub, newline = string.sub, "\n"
				function Stream(Input, FileName)
					local Index = 1
					local Line = 1
					local Column = 0
					FileName = FileName or "{none}"
					local cols = {}
					local function Back()
						Index = Index - 1
						local Char = sub(Input, Index, Index)
						if Char == newline then
							Line = Line - 1
							Column = cols[#cols]
							cols[#cols] = nil
						else
							Column = Column - 1
						end
					end
					local function Next()
						local Char = sub(Input, Index, Index)
						Index = Index + 1
						if Char == newline then
							Line = Line + 1
							cols[#cols + 1] = Column
							Column = 0
						else
							Column = Column + 1
						end
						return Char, {
							Index = Index,
							Line = Line,
							Column = Column,
							File = FileName
						}
					end
					local function Peek(length)
						return sub(Input, Index, Index + (length or 1) - 1)
					end
					local function EOF()
						return Index > #Input
					end
					local function Fault(Error)
						error(Error .. " (col " .. Column .. ", ln " .. Line .. ", file " .. FileName .. ")", 0)
					end
					return {
						Back = Back,
						Next = Next,
						Peek = Peek,
						EOF = EOF,
						Fault = Fault
					}
				end
			end

			local idenCheck, numCheck, opCheck = "abcdefghijklmnopqrstuvwxyz_", "0123456789", "+-*/%^#~=<>(){}[];:,."
			local blank, dot, equal, openbrak, closebrak, newline, backslash, dash, quote, apos = "", ".", "=", "[", "]", "\n", "\\", "-", "\"", "'"
			function Lexer(Code)
				local Input = Stream(Code)
				local Current, LastToken, self
				local Clone = function(Table)
					local R = {}
					for K, V in pairs(Table) do
						R[K] = V
					end
					return R
				end
				for Key, Value in pairs(Clone(Tokens)) do
					Tokens[Value] = Key
				end
				local function Check(Value, Type, Start)
					if Type == Tokens.Identifier then
						return find(idenCheck, Value:lower(), 1, true) ~= nil or not Start and find(numCheck, Value, 1, true) ~= nil
					elseif Type == Tokens.Keyword then
						if Keywords[Value] then
							return true
						end
						return false
					elseif Type == Tokens.Number then
						if Value == "." and not Start then
							return true
						end
						return find(numCheck, Value, 1, true) ~= nil
					elseif Type == Tokens.Operator then
						return find(opCheck, Value, 1, true) ~= nil
					end
				end
				local function Next()
					if Current ~= nil then
						local Token = Current
						Current = nil
						return Token
					end
					if Input.EOF() then
						return nil
					end
					local Char, DebugInfo = Input.Next()
					local Result = {
						Type = Tokens.Symbol
					}
					local sValue = Char
					for i = 0, 256 do
						local open = openbrak .. rep(equal, i) .. openbrak
						if Char .. Input.Peek(#open - 1) == open then
							self.StringDepth = i + 1
							break
						end
					end
					local resulting = false
					if 0 < self.StringDepth then
						local closer = closebrak .. rep(equal, self.StringDepth - 1) .. closebrak
						Input.Back()
						local Value = blank
						while not Input.EOF() and Input.Peek(#closer) ~= closer do
							Char, DebugInfo = Input.Next()
							Value = Value .. Char
						end
						if Input.Peek(#closer) == closer then
							for i = 1, #closer do
								Value = Value .. Input.Next()
							end
							self.StringDepth = 0
						end
						Result.Value = Value
						Result.Type = Tokens.String
						resulting = true
					elseif 0 < self.CommentDepth then
						local closer = closebrak .. rep(equal, self.CommentDepth - 1) .. closebrak
						Input.Back()
						local Value = blank
						while not Input.EOF() and Input.Peek(#closer) ~= closer do
							Char, DebugInfo = Input.Next()
							Value = Value .. Char
						end
						if Input.Peek(#closer) == closer then
							for i = 1, #closer do
								Value = Value .. Input.Next()
							end
							self.CommentDepth = 0
						end
						Result.Value = Value
						Result.Type = Tokens.Comment
						resulting = true
					end
					local skip = 1
					for i = 1, #lua_builtin do
						local k = lua_builtin[i]
						if Input.Peek(#k - 1) == sub(k, 2) and Char == sub(k, 1, 1) and skip < #k then
							Result.Type = Tokens.Builtin
							Result.Value = k
							skip = #k
							resulting = true
						end
					end
					for i = 1, skip - 1 do
						Char, DebugInfo = Input.Next()
					end
					if resulting then
					elseif Check(Char, Tokens.Identifier, true) then
						local Value = Char
						while Check(Input.Peek(), Tokens.Identifier) and not Input.EOF() do
							Value = Value .. Input.Next()
						end
						if Check(Value, Tokens.Keyword) then
							Result.Type = Tokens.Keyword
						else
							Result.Type = Tokens.Identifier
						end
						Result.Value = Value
					elseif Char == dash and Input.Peek() == dash then
						local Value = Char .. Input.Next()
						for i = 0, 256 do
							local open = openbrak .. rep(equal, i) .. openbrak
							if Input.Peek(#open) == open then
								self.CommentDepth = i + 1
								break
							end
						end
						if 0 < self.CommentDepth then
							local closer = closebrak .. rep(equal, self.CommentDepth - 1) .. closebrak
							while not Input.EOF() and Input.Peek(#closer) ~= closer do
								Char, DebugInfo = Input.Next()
								Value = Value .. Char
							end
							if Input.Peek(#closer) == closer then
								for i = 1, #closer do
									Value = Value .. Input.Next()
								end
								self.CommentDepth = 0
							end
						else
							while not Input.EOF() and not find(newline, Char, 1, true) do
								Char, DebugInfo = Input.Next()
								Value = Value .. Char
							end
						end
						Result.Value = Value
						Result.Type = Tokens.Comment
					elseif Check(Char, Tokens.Number, true) or Char == dot and Check(Input.Peek(), Tokens.Number, true) then
						local Value = Char
						while Check(Input.Peek(), Tokens.Number) and not Input.EOF() do
							Value = Value .. Input.Next()
						end
						Result.Value = Value
						Result.Type = Tokens.Number
					elseif Char == quote then
						local Escaped = false
						local String = blank
						Result.Value = quote
						while not Input.EOF() do
							local Char = Input.Next()
							Result.Value = Result.Value .. Char
							if Escaped then
								String = String .. Char
								Escaped = false
							elseif Char == backslash then
								Escaped = true
							elseif Char == quote or Char == newline then
								break
							else
								String = String .. Char
							end
						end
						Result.Type = Tokens.String
					elseif Char == apos then
						local Escaped = false
						local String = blank
						Result.Value = apos
						while not Input.EOF() do
							local Char = Input.Next()
							Result.Value = Result.Value .. Char
							if Escaped then
								String = String .. Char
								Escaped = false
							elseif Char == backslash then
								Escaped = true
							elseif Char == apos or Char == newline then
								break
							else
								String = String .. Char
							end
						end
						Result.Type = Tokens.String
					elseif Check(Char, Tokens.Operator) then
						Result.Value = Char
						Result.Type = Tokens.Operator
					else
						Result.Value = Char
					end
					Result.TypeName = Tokens[Result.Type]
					LastToken = Result
					return Result
				end
				local function Peek()
					local Result = Next()
					Current = Result
					return Result
				end
				local function EOF()
					return Peek() == nil
				end
				local function GetLast()
					return LastToken
				end
				self = {
					Next = Next,
					Peek = Peek,
					EOF = EOF,
					GetLast = GetLast,
					CommentDepth = 0,
					StringDepth = 0
				}
				return self
			end
		end

		function Place.fromIndex(CodeEditor, Index)
			local cache = CodeEditor.PlaceCache
			local fromCache
			if cache.fromIndex then
				fromCache = cache.fromIndex
			else
				fromCache = {}
				cache.fromIndex = fromCache
			end
			if fromCache[Index] then
			end
			local Content = CodeEditor.Content
			local ContentUpto = sub(Content, 1, Index)
			if Index == 0 then
				return Place.new(0, 0)
			end
			local Lines = Split(ContentUpto, newline)
			local res = Place.new(#gsub(Lines[#Lines], tab, TabText), #Lines - 1)
			fromCache[Index] = res
			return res
		end
		function Place.toIndex(CodeEditor, Place)
			local cache = CodeEditor.PlaceCache
			local toCache
			if cache.toIndex then
				toCache = cache.toIndex
			else
				toCache = {}
				cache.toIndex = toCache
			end
			local Content = CodeEditor.Content
			if Place.X == 0 and Place.Y == 0 then
				return 0
			end
			local Lines = CodeEditor.Lines
			local Index = 0
			for I = 1, Place.Y do
				Index = Index + #Lines[I] + 1
			end
			local line = Lines[Place.Y + 1]
			local roundedX = Place.X
			local ix = 0
			for i = 1, #line do
				local c = sub(line, i, i)
				local pix = ix
				if c == tab then
					ix = ix + #TabText
				else
					ix = ix + 1
				end
				if Place.X == ix then
					roundedX = i
				elseif pix < Place.X and ix > Place.X then
					if Place.X - pix < ix - Place.X then
						roundedX = i - 1
					else
						roundedX = i
					end
				end
			end
			local res = Index + min(#line, roundedX)
			toCache[Place.X .. "-$-" .. Place.Y] = res
			return res
		end
		local Selection = {}
		local Side = {Left = 1, Right = 2}
		function Selection.new(Start, End, CaretSide)
			return {
				Start = Start,
				End = End,
				Side = CaretSide
			}
		end

		local Themes = {
			Plain = {
				LineSelection = Color3.fromRGB(46, 46, 46),
				SelectionBackground = Color3.fromRGB(118, 118, 118),
				SelectionColor = Color3.fromRGB(10, 10, 10),
				SelectionGentle = Color3.fromRGB(46, 46, 46);
				Background = Color3.fromRGB(40, 41, 35),
				Comment = Color3.fromRGB(117, 113, 94),
				Keyword =  Color3.fromRGB(249, 38, 114),
				Builtin =  Color3.fromRGB(83, 220, 205),
				Number = Color3.fromRGB(174, 129, 255),
				Operator = Color3.fromRGB(182, 151, 135),
				String = Color3.fromRGB(230, 219, 116),
				Text = Color3.fromRGB(255, 255, 255);
				SelectionBackground = Color3.fromRGB(150, 150, 150),
				SelectionColor = Color3.fromRGB(0, 0, 0),
				SelectionGentle = Color3.fromRGB(65, 65, 65)
			}
		}

		local EditorLib = {}
		EditorLib.Place = Place
		EditorLib.Selection = Selection
		function EditorLib.NewTheme(Name, Theme)
			Themes[Name] = Theme
		end
		local TextCursor = {
			Image = "rbxassetid://1188942192",
			HotspotX = 3,
			HotspotY = 8,
			Size = udim2(0, 7, 0, 17)
		}
		function EditorLib.Initialize(Frame, Options)
			local themestuff = {}
			local function ThemeSet(obj, prop, val)
				themestuff[obj] = themestuff[obj] or {}
				themestuff[obj][prop] = val
			end
			local baseZIndex = Frame.ZIndex
			Options.CaretBlinkingRate = toNumber(Options.CaretBlinkingRate) or 0.25
			Options.FontSize = toNumber(Options.FontSize or Options.TextSize) or 14
			Options.CaretFocusedOpacity = toNumber(Options.CaretOpacity and Options.CaretOpacity.Focused or Options.CaretFocusedOpacity) or 1
			Options.CaretUnfocusedOpacity = toNumber(Options.CaretOpacity and Options.CaretOpacity.Unfocused or Options.CaretUnfocusedOpacity) or 0
			Options.Theme = type(Options.Theme) == "string" and Options.Theme or "Plain"
			local SizeDot = game:GetService("TextService"):GetTextSize(".", Options.FontSize, Options.Font, Vector2.new(1000, 1000))
			local SizeM = game:GetService("TextService"):GetTextSize("m", Options.FontSize, Options.Font, Vector2.new(1000, 1000))
			local SizeAV = game:GetService("TextService"):GetTextSize("AV", Options.FontSize, Options.Font, Vector2.new(1000, 1000))
			local Editor = {
				Content = "",
				Lines = {""},
				Focused = false,
				PlaceCache = {},
				Selection = Selection.new(0, 0, Side.Left),
				StartingSelection = Selection.new(0, 0, Side.Left),
				LastKeyCode = false,
				UndoStack = {},
				RedoStack = {}
			}
			local CharWidth = SizeM.X
			local CharHeight = SizeM.Y + 4
			if (SizeDot.X ~= SizeM.X or SizeDot.Y ~= SizeM.Y) and SizeAV.X ~= SizeM.X + SizeDot.X then
				return error("CodeEditor requires a monospace font with no currying", 2)
			end
			local ContentChangedEvent = newInst("BindableEvent")
			local FocusLostEvent = newInst("BindableEvent")
			local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
			local Container = newInst("Frame")
			Container.Name = "Container"
			Container.BorderSizePixel = 0
			Container.BackgroundColor3 = Themes[Options.Theme].Background
			ThemeSet(Container, "BackgroundColor3", "Background")
			Container.Size = udim2(1, 0, 1, 0)
			Container.ClipsDescendants = true
			local GutterSize = CharWidth * 4
			local TextArea = newInst("ScrollingFrame")
			TextArea.Name = "TextArea"
			TextArea.BackgroundTransparency = 1;
			TextArea.BorderSizePixel = 0
			TextArea.Size = udim2(1, -GutterSize, 1, 0)
			TextArea.Position = udim2(0, GutterSize, 0, 0)
			TextArea.ScrollBarThickness = 10;
			TextArea.ScrollBarImageTransparency = 0;
			TextArea.ScrollBarImageColor3 = Color3.fromRGB(20, 20, 20)
			TextArea.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
			TextArea.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
			TextArea.ZIndex = 3;

			local Gutter = newInst("Frame")
			Gutter.Name = "Gutter"
			Gutter.ZIndex = baseZIndex
			Gutter.BorderSizePixel = 0
			Gutter.BackgroundTransparency = 0.96
			Gutter.Size = udim2(0, GutterSize - 5, 1.5, 0)
			local GoodMouseDetector = newInst("TextButton")
			GoodMouseDetector.Text = ""
			GoodMouseDetector.BackgroundTransparency = 1
			GoodMouseDetector.Size = udim2(1, 0, 1, 0)
			GoodMouseDetector.Position = udim2(0, 0, 0, 0)
			GoodMouseDetector.Visible = false
			local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
			local Scroll = newInst("TextButton")
			Scroll.Name = "VertScroll"
			Scroll.Size = udim2(0, 10, 1, 0)
			Scroll.Position = udim2(1, -10, 0, 0)
			Scroll.BackgroundTransparency = 1
			Scroll.Text = ""
			Scroll.ZIndex = 1000
			Scroll.Parent = Container
			local ScrollBar = newInst("TextButton")
			ScrollBar.Name = "ScrollBar"
			ScrollBar.Size = udim2(1, 0, 0, 36)
			ScrollBar.Position = udim2(0, 0, 0, 0)
			ScrollBar.Text = ""
			ScrollBar.BackgroundColor3 = Themes[Options.Theme].ScrollBar or Color3.fromRGB(120, 120, 120)
			ScrollBar.BackgroundTransparency = 0.75
			ScrollBar.BorderSizePixel = 0
			ScrollBar.AutoButtonColor = false
			ScrollBar.ZIndex = 3 + baseZIndex
			ScrollBar.Parent = Scroll
			local CaretIndicator = newInst("Frame")
			CaretIndicator.Name = "CaretIndicator"
			CaretIndicator.Size = udim2(1, 0, 0, 2)
			CaretIndicator.Position = udim2(0, 0, 0, 0)
			CaretIndicator.BorderSizePixel = 0
			CaretIndicator.BackgroundColor3 = Themes[Options.Theme].Text
			ThemeSet(CaretIndicator, "BackgroundColor3", "Text")
			CaretIndicator.BackgroundTransparency = 0.29803921568627456
			CaretIndicator.ZIndex = 4 + baseZIndex
			CaretIndicator.Parent = Scroll
			local MarkersFolder = newInst("Folder", Scroll)
			local markers = {}
			local updateMarkers

			do
				local lerp = function(a, b, r)
					return a + r * (b - a)
				end
				function updateMarkers()
					MarkersFolder:ClearAllChildren()
					local ra = Themes[Options.Theme].Background.r
					local ga = Themes[Options.Theme].Background.g
					local ba = Themes[Options.Theme].Background.b
					local rb = Themes[Options.Theme].Text.r
					local gb = Themes[Options.Theme].Text.g
					local bb = Themes[Options.Theme].Text.b
					local r = lerp(ra, rb, 0.2980392156862745)
					local g = lerp(ga, gb, 0.2980392156862745)
					local b = lerp(ba, bb, 0.2980392156862745)
					local color = Color3.new(r, g, b)
					for i, v in ipairs(markers) do
						local Marker = newInst("Frame")
						Marker.BorderSizePixel = 0
						Marker.BackgroundColor3 = color
						Marker.Size = udim2(0, 4, 0, 6)
						Marker.Position = udim2(0, 4, v * CharHeight / TextArea.CanvasSize.Y.Offset, 0)
						Marker.ZIndex = 4 + baseZIndex
						Marker.Parent = MarkersFolder
					end
				end
			end
			do
				TextArea.Changed:Connect(function(property)
					if property == "CanvasSize" or property == "CanvasPosition" then
						Gutter.Position = udim2(0, 0, 0, -TextArea.CanvasPosition.Y)
					end
				end)
			end
			local ScrollBorder = newInst("Frame")
			ScrollBorder.Name = "ScrollBorder"
			ScrollBorder.Position = udim2(0, -1, 0, 0)
			ScrollBorder.Size = udim2(0, 1, 1, 0)
			ScrollBorder.BorderSizePixel = 0
			ScrollBorder.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
			ScrollBorder.Parent = Scroll
			do
				TextArea.Changed:Connect(function(property)
					if property == "CanvasSize" or property == "CanvasPosition" then
						local percent = TextArea.AbsoluteWindowSize.X / TextArea.CanvasSize.X.Offset
						ScrollBar.Size = udim2(percent, 0, 1, 0)
						local max = max(TextArea.CanvasSize.X.Offset - TextArea.AbsoluteWindowSize.X, 0)
						local percent = max == 0 and 0 or TextArea.CanvasPosition.X / max
						local x = percent * (Scroll.AbsoluteSize.X - ScrollBar.AbsoluteSize.X)
						ScrollBar.Position = udim2(0, x, 0, 0)
						Scroll.Visible = false
					end
				end)
			end
			local LineSelection = newInst("Frame")
			LineSelection.Name = "LineSelection"
			LineSelection.BackgroundColor3 = Themes[Options.Theme].Background
			ThemeSet(LineSelection, "BackgroundColor3", "Background")
			LineSelection.BorderSizePixel = 2
			LineSelection.BorderColor3 = Themes[Options.Theme].LineSelection
			ThemeSet(LineSelection, "BorderColor3", "LineSelection")
			LineSelection.Size = udim2(1, -4, 0, CharHeight - 4)
			LineSelection.Position = udim2(0, 2, 0, 2)
			LineSelection.ZIndex = -1 + baseZIndex
			LineSelection.Parent = TextArea
			LineSelection.Visible = false;

			local ErrorHighlighter = newInst("Frame")
			ErrorHighlighter.Name = "ErrorHighlighter"
			ErrorHighlighter.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
			ErrorHighlighter.BackgroundTransparency = 0.9
			ErrorHighlighter.BorderSizePixel = 0
			ErrorHighlighter.Size = udim2(1, -4, 0, CharHeight - 4)
			ErrorHighlighter.Position = udim2(0, 2, 0, 2)
			ErrorHighlighter.ZIndex = 5 + baseZIndex
			ErrorHighlighter.Visible = false
			ErrorHighlighter.Parent = TextArea
			local ErrorMessage = newInst("TextLabel")
			ErrorMessage.Name = "ErrorMessage"
			ErrorMessage.BackgroundColor3 = Themes[Options.Theme].Background:lerp(Color3.new(1, 1, 1), 0.1)
			ErrorMessage.TextColor3 = Color3.fromRGB(255, 152, 152)
			ErrorMessage.BorderSizePixel = 0
			ErrorMessage.Visible = false
			ErrorMessage.Size = udim2(0, 150, 0, CharHeight - 4)
			ErrorMessage.Position = udim2(0, 2, 0, 2)
			ErrorMessage.ZIndex = 6 + baseZIndex
			ErrorMessage.Parent = Container
			local Tokens = newInst("Frame", TextArea)
			Tokens.BackgroundTransparency = 1
			Tokens.Name = "Tokens"
			local Selection = newInst("Frame", TextArea)
			Selection.BackgroundTransparency = 1
			Selection.Name = "Selection"
			Selection.ZIndex = baseZIndex
			local TextBox = newInst("TextBox")
			TextBox.BackgroundTransparency = 1
			TextBox.Size = udim2(0, 0, 0, 0)
			TextBox.Position = udim2(-1, 0, -1, 0)
			TextBox.Text = ""
			TextBox.ShowNativeInput = false
			TextBox.MultiLine = true
			TextBox.ClearTextOnFocus = true
			local Caret = newInst("Frame")
			Caret.Name = "Caret"
			Caret.BorderSizePixel = 0

			Caret.BackgroundColor3 = Themes[Options.Theme].Text
			ThemeSet(Caret, "BackgroundColor3", "Text")
			Caret.Size = udim2(0, 2, 0, CharHeight)
			Caret.Position = udim2(0, 0, 0, 0)
			Caret.ZIndex = 100
			Caret.Visible = false;

			local selectedword
			local tokens = {}
			local function NewToken(Content, Color, Position, Parent)		
				local Token = newInst("TextLabel")
				Token.BorderSizePixel = 0
				Token.TextColor3 = Themes[Options.Theme][Color]
				Token.BackgroundTransparency = 1
				Token.BackgroundColor3 = Themes[Options.Theme].SelectionGentle
				if Content == selectedword then
					Token.BackgroundTransparency = 0
				end
				Token.Size = udim2(0, CharWidth * #Content, 0, CharHeight)
				Token.Position = udim2(0, Position.X * CharWidth, 0, Position.Y * CharHeight)
				Token.Font = Options.Font
				Token.TextSize = Options.FontSize
				Token.Text = Content
				Token.TextXAlignment = "Left"
				Token.ZIndex = baseZIndex
				Token.Parent = Parent
				tokens[#tokens + 1] = Token
			end
			local function updateselected()
				for i, v in ipairs(tokens) do
					if v.Text == selectedword then
						v.BackgroundTransparency = 0
					else
						v.BackgroundTransparency = 1
					end
				end
				markers = {}
				if selectedword and selectedword ~= "" and selectedword ~= tab then
					for LineNumber = 1, #Editor.Lines do
						local line = Editor.Lines[LineNumber]
						local Dnable = "[^A-Za-z0-9_]"
						local has = false
						if sub(line, 1, #selectedword) == selectedword then
							has = true
						elseif sub(line, #line - #selectedword + 1) == selectedword then
							has = true
						elseif line:match(Dnable .. gsub(selectedword, "%W", "%%%1") .. Dnable) then
							has = true
						end
						if has then
							markers[#markers + 1] = LineNumber - 1
						end
					end
				end
				updateMarkers()
			end
			local DrawnLines = {}
			local depth = {}
			local sdepth = {}
			local function DrawTokens()
				local LineBegin = floor(TextArea.CanvasPosition.Y / CharHeight)
				local LineEnd = ceil((TextArea.CanvasPosition.Y + TextArea.AbsoluteWindowSize.Y) / CharHeight)
				LineEnd = min(LineEnd, #Editor.Lines)
				for LineNumber = 1, LineBegin - 1 do
					if not depth[LineNumber] then
						local line = Editor.Lines[LineNumber] or ""
						if line:match("%[%=+%[") or line:match("%]%=+%]") then
							local LexerStream = Lexer(line)
							LexerStream.CommentDepth = depth[LineNumber - 1] or 0
							LexerStream.StringDepth = sdepth[LineNumber - 1] or 0
							while not LexerStream.EOF() do
								LexerStream.Next()
							end
							sdepth[LineNumber] = LexerStream.StringDepth
							depth[LineNumber] = LexerStream.CommentDepth
						else
							sdepth[LineNumber] = sdepth[LineNumber - 1] or 0
							depth[LineNumber] = depth[LineNumber - 1] or 0
						end
					end
				end
				for LineNumber = LineBegin, LineEnd do
					if not DrawnLines[LineNumber] then
						DrawnLines[LineNumber] = true
						local X, Y = 0, LineNumber - 1
						local LineLabel = newInst("TextLabel")
						LineLabel.BorderSizePixel = 0
						LineLabel.TextColor3 = Color3.fromRGB(144, 145, 139)
						LineLabel.BackgroundTransparency = 1
						LineLabel.Size = udim2(1, 0, 0, CharHeight)
						LineLabel.Position = udim2(0, 0, 0, Y * CharHeight)
						LineLabel.Font = Options.Font
						LineLabel.TextSize = Options.FontSize
						LineLabel.TextXAlignment = Enum.TextXAlignment.Right
						LineLabel.Text = LineNumber
						LineLabel.Parent = Gutter
						LineLabel.ZIndex = baseZIndex
						if Editor.Lines[Y + 1] then
							local LexerStream = Lexer(Editor.Lines[Y + 1])
							LexerStream.CommentDepth = depth[LineNumber - 1] or 0
							LexerStream.StringDepth = sdepth[LineNumber - 1] or 0
							while not LexerStream.EOF() do
								local Token = LexerStream.Next()
								local Value = Token.Value
								local TokenType = Token.TypeName
								if TokenType == "Identifier" or TokenType == "Symbol" then
									TokenType = "Text"
								end
								if (" \t\r\n"):find(Value, 1, true) == nil then
									NewToken(gsub(Value, tab, TabText), TokenType, Place.new(X, Y), Tokens)
								end
								X = X + #gsub(Value, tab, TabText)
							end
							depth[LineNumber] = LexerStream.CommentDepth
							sdepth[LineNumber] = LexerStream.StringDepth
						end
					end
				end
			end
			TextArea.Changed:Connect(function(Property)
				if Property == "CanvasPosition" or Property == "AbsoluteWindowSize" then
					DrawTokens()
				end
			end)
			local function ClearTokensAndSelection()
				depth = {}
				Tokens:ClearAllChildren()
				Selection:ClearAllChildren()
				Gutter:ClearAllChildren()
			end
			local function Write(Content, Start, End)
				local InBetween = sub(Editor.Content, Start + 1, End)
				local NoLN = find(InBetween, newline, 1, true) == nil and find(Content, newline, 1, true) == nil
				local StartPlace, EndPlace
				if NoLN then
					StartPlace, EndPlace = Place.fromIndex(Editor, Start), Place.fromIndex(Editor, End)
				end
				Editor.Content = sub(Editor.Content, 1, Start) .. Content .. sub(Editor.Content, End + 1)
				ContentChangedEvent:Fire(Editor.Content)
				Editor.PlaceCache = {}
				local CanvasWidth = TextArea.CanvasSize.X.Offset - 14
				Editor.Lines = Split(Editor.Content, newline)
				for _, Res in ipairs(Editor.Lines) do
					local width = #gsub(Res, tab, TabText) * CharWidth
					if CanvasWidth < width then
						CanvasWidth = width
					end
				end

				ClearTokensAndSelection()
				TextArea.CanvasSize = udim2(0, 3000, 0, select(2, gsub(Editor.Content, newline, "")) * CharHeight + TextArea.AbsoluteWindowSize.Y)
				DrawnLines = {}
				DrawTokens()
			end
			local function SetContent(Content)
				Editor.Content = Content
				ContentChangedEvent:Fire(Editor.Content)
				Editor.PlaceCache = {}
				Editor.Lines = Split(Editor.Content, newline)
				ClearTokensAndSelection()
				local CanvasWidth = TextArea.CanvasSize.X.Offset - 14
				for _, Res in ipairs(Editor.Lines) do
					if CanvasWidth < #Res then
						CanvasWidth = #Res * CharWidth
					end
				end
				TextArea.CanvasSize = udim2(0, 3000, 0, select(2, gsub(Editor.Content, newline, "")) * CharHeight + TextArea.AbsoluteWindowSize.Y)
				DrawnLines = {}
				DrawTokens()
			end
			local function UpdateSelection()
				Selection:ClearAllChildren()
				if Themes[Options.Theme].SelectionColor then
					Selection.ZIndex = 2 + baseZIndex
					Tokens.ZIndex = 1 + baseZIndex
				else
					Selection.ZIndex = 1 + baseZIndex
					Tokens.ZIndex = 2 + baseZIndex
				end
				if Editor.Selection.Start == Editor.Selection.End then
					LineSelection.Visible = true
					local CaretPlace = Place.fromIndex(Editor, Editor.Selection.Start)
					LineSelection.Position = UDim2.new(0, 2, 0, CharHeight * CaretPlace.Y + 2)
				else
					LineSelection.Visible = false
				end
				local Index = 0
				local Start = #gsub(sub(Editor.Content, 1, Editor.Selection.Start), tab, TabText)
				local End = #gsub(sub(Editor.Content, 1, Editor.Selection.End), tab, TabText)
				for LineNumber, Line in ipairs(Editor.Lines) do
					Line = gsub(Line, tab, TabText)
					local StartX = Start - Index
					local EndX = End - Index
					local Y = LineNumber - 1
					local GoesOverLine = false
					if StartX < 0 then
						StartX = 0
					end
					if EndX > #Line then
						GoesOverLine = true
						EndX = #Line
					end
					local Width = EndX - StartX
					if GoesOverLine then
						Width = Width + 0.5
					end
					if Width > 0 then
						local color = Themes[Options.Theme].SelectionColor
						local SelectionSegment = newInst(color and "TextLabel" or "Frame")
						SelectionSegment.BorderSizePixel = 0
						if color then
							SelectionSegment.TextColor3 = color
							SelectionSegment.Font = Options.Font
							SelectionSegment.TextSize = Options.FontSize
							SelectionSegment.Text = sub(Line, StartX + 1, EndX)
							SelectionSegment.TextXAlignment = "Left"
							SelectionSegment.ZIndex = baseZIndex
						else
							SelectionSegment.BorderSizePixel = 0
						end
						SelectionSegment.BackgroundColor3 = Themes[Options.Theme].SelectionBackground
						SelectionSegment.Size = udim2(0, CharWidth * Width, 0, CharHeight)
						SelectionSegment.Position = udim2(0, StartX * CharWidth, 0, Y * CharHeight)
						SelectionSegment.Parent = Selection
					end
					Index = Index + #Line + 1
				end
				local NewY = Caret.Position.Y.Offset
				local MinBoundsY = TextArea.CanvasPosition.Y
				local MaxBoundsY = TextArea.CanvasPosition.Y + TextArea.AbsoluteWindowSize.Y - CharHeight
				if NewY < MinBoundsY then
					TextArea.CanvasPosition = Vector2.new(0, NewY)
				end
				if NewY > MaxBoundsY then
					TextArea.CanvasPosition = Vector2.new(0, NewY - TextArea.AbsoluteWindowSize.Y + CharHeight)
				end
			end
			TextBox.Parent = TextArea
			Caret.Parent = TextArea
			TextArea.Parent = Container
			Gutter.Parent = Container
			Container.Parent = Frame
			local function updateCaret(CaretPlace)
				Caret.Position = udim2(0, CaretPlace.X * CharWidth, 0, CaretPlace.Y * CharHeight)
				local percent = CaretPlace.Y * CharHeight / TextArea.CanvasSize.Y.Offset
				CaretIndicator.Position = udim2(0, 0, percent, -1)
			end
			local PressedKey, WorkingKey, LeftShift, RightShift, Shift, LeftCtrl, RightCtrl, Ctrl
			local UIS = game:GetService("UserInputService")
			local MovementTimeout = tick()
			local BeginSelect, MoveCaret
			local function SetVisibility(Visible)
				Editor.Visible = Visible
			end
			local function selectWord()
				local Index = Editor.Selection.Start
				if Editor.Selection.Side == Side.Right then
					Index = Editor.Selection.End
				end
				local code = Editor.Content
				local left = max(Index - 1, 0)
				local right = min(Index + 1, #code)
				local Dable = "[A-Za-z0-9_]"
				while left ~= 0 and match(sub(code, left + 1, left + 1), Dable) do
					left = left - 1
				end
				while right ~= #code and match(sub(code, right, right), Dable) do
					right = right + 1
				end
				if not match(sub(code, left + 1, left + 1), Dable) then
					left = left + 1
				end
				if not match(sub(code, right, right), Dable) then
					right = right - 1
				end
				if left < right then
					Editor.Selection.Start = left
					Editor.Selection.End = right
				else
					Editor.Selection.Start = Index
					Editor.Selection.End = Index
				end
			end
			local settledAt
			local lastClick = 0
			local lastCaretPos = 0
			local function PushToUndoStack()
				Editor.UndoStack[#Editor.UndoStack + 1] = {
					Content = Editor.Content,
					Selection = {
						Start = Editor.Selection.Start,
						End = Editor.Selection.End,
						Side = Editor.Selection.Side
					},
					LastKeyCode = false
				}
				if #Editor.RedoStack > 0 then
					Editor.RedoStack = {}
				end
			end
			local function Undo()
				if #Editor.UndoStack > 1 then
					local Thing = Editor.UndoStack[#Editor.UndoStack - 1]
					for Key, Value in pairs(Thing) do
						Editor[Key] = Value
					end
					Editor.SetContent(Thing.Content)
					Editor.RedoStack[#Editor.RedoStack + 1] = Editor.UndoStack[#Editor.UndoStack]
					Editor.UndoStack[#Editor.UndoStack] = nil
				end
			end
			local function Redo()
				if #Editor.RedoStack > 0 then
					local Thing = Editor.RedoStack[#Editor.RedoStack]
					for Key, Value in pairs(Thing) do
						Editor[Key] = Value
					end
					Editor.SetContent(Thing.Content)
					Editor.UndoStack[#Editor.UndoStack + 1] = Thing
					Editor.RedoStack[#Editor.RedoStack] = nil
				end
			end
			Mouse.Move:Connect(function()
				if BeginSelect then
					local Index = GetIndexAtMouse()
					if type(BeginSelect) == "number" then
						BeginSelect = {BeginSelect, BeginSelect}
					end
					Editor.Selection.Start = min(BeginSelect[1], Index)
					Editor.Selection.End = max(BeginSelect[2], Index)
					if Editor.Selection.Start ~= Editor.Selection.End then
						if Editor.Selection.Start == Index then
							Editor.Selection.Side = Side.Left
						else
							Editor.Selection.Side = Side.Right
						end
					end
					if BeginSelect[3] then
						selectWord()
						Editor.Selection.Start = min(BeginSelect[1], Editor.Selection.Start)
						Editor.Selection.End = max(BeginSelect[2], Editor.Selection.End)
					end
					local Ind = Editor.Selection.Start
					if Editor.Selection.Side == Side.Right then
						Ind = Editor.Selection.End
					end
					local CaretPlace = Place.fromIndex(Editor, Ind)
					updateCaret(CaretPlace)
					UpdateSelection()
				end
			end)
			TextBox.Focused:Connect(function()
				Editor.Focused = true
			end)
			TextBox.FocusLost:Connect(function()
				Editor.Focused = false
				FocusLostEvent:Fire()
				PressedKey = nil
				WorkingKey = nil
			end)
			function MoveCaret(Amount)
				local Direction = Amount < 0 and -1 or 1
				if Amount < 0 then
					Amount = -Amount
				end
				for Index = 1, Amount do
					if Direction == -1 then
						local Start = Editor.Selection.Start
						local End = Editor.Selection.End
						if Shift then
							if Start == End then
								if Start > 0 then
									Editor.Selection.Start = Start - 1
									Editor.Selection.Side = Side.Left
								end
							elseif Editor.Selection.Side == Side.Left then
								if Start > 0 then
									Editor.Selection.Start = Start - 1
								end
							elseif Editor.Selection.Side == Side.Right then
								Editor.Selection.End = End - 1
							end
						elseif Start ~= End then
							Editor.Selection.End = Start
						elseif Start > 0 then
							Editor.Selection.Start = Start - 1
							Editor.Selection.End = End - 1
						end
					elseif Direction == 1 then
						local Start = Editor.Selection.Start
						local End = Editor.Selection.End
						if Shift then
							if Start == End then
								if Start < #Editor.Content then
									Editor.Selection.End = End + 1
									Editor.Selection.Side = Side.Right
								end
							elseif Editor.Selection.Side == Side.Left then
								Editor.Selection.Start = Start + 1
							elseif Editor.Selection.Side == Side.Right and End < #Editor.Content then
								Editor.Selection.End = End + 1
							end
						elseif Start ~= End then
							Editor.Selection.Start = End
						elseif Start < #Editor.Content then
							Editor.Selection.Start = Start + 1
							Editor.Selection.End = End + 1
						end
					end
				end
			end
			local LastKeyCode
			local function ProcessInput(Type, Data)
				MovementTimeout = tick() + 0.25
				if Type == "Control+Key" then
					LastKeyCode = nil
				elseif Type == "KeyPress" then
					local Dat = Data
					if Dat == Enum.KeyCode.Up then
						Dat = Enum.KeyCode.Down
					end
					if LastKeyCode ~= Dat then
						Editor.StartingSelection.Start = Editor.Selection.Start
						Editor.StartingSelection.End = Editor.Selection.End
						Editor.StartingSelection.Side = Editor.Selection.Side
					end
					LastKeyCode = Dat
				elseif Type == "StringInput" then
					local Start = Editor.Selection.Start
					local End = Editor.Selection.End
					if Data == newline then
						local CaretPlaceInd = Editor.Selection.Start
						if Editor.Selection.Side == Side.Right then
							CaretPlaceInd = Editor.Selection.End
						end
						local CaretPlace = Place.fromIndex(Editor, CaretPlaceInd)
						local CaretLine = Editor.Lines
						CaretLine = CaretLine[CaretPlace.Y + 1]
						CaretLine = sub(CaretLine, 1, CaretPlace.X)
						local TabAmount = 0
						while sub(CaretLine, TabAmount + 1, TabAmount + 1) == tab do
							TabAmount = TabAmount + 1
						end
						Data = Data .. tab:rep(TabAmount)
						local SpTabAmount = 0
						while CaretLine:sub(SpTabAmount + 1, SpTabAmount + 1) == " " do
							SpTabAmount = SpTabAmount + 1
						end
						Data = Data .. gsub((" "):rep(SpTabAmount), TabText, tab)
						Write(Data, Start, End)
						Editor.Selection.Start = Start + #Data
						Editor.Selection.End = Editor.Selection.Start
						PushToUndoStack()
					elseif Data == tab and Editor.Selection.Start ~= Editor.Selection.End then
						local lstart = Place.fromIndex(Editor, Editor.Selection.Start)
						local lend = Place.fromIndex(Editor, Editor.Selection.End)
						local changes = 0
						local change1 = 0
						for i = lstart.Y + 1, lend.Y + 1 do
							local line = Editor.Lines[i]
							local change = 0
							if Shift then
								if sub(line, 1, 1) == tab then
									line = sub(line, 2)
									change = -1
								end
							else
								line = tab .. line
								change = 1
							end
							changes = changes + change
							if i == lstart.Y + 1 then
								change1 = change
							end
							Editor.Lines[i] = line
						end
						SetContent(table.concat(Editor.Lines, newline))
						Editor.Selection.Start = Editor.Selection.Start + change1
						Editor.Selection.End = Editor.Selection.End + changes
						PushToUndoStack()
					else
						Write(Data, Start, End)
						Editor.Selection.Start = Start + #Data
						Editor.Selection.End = Editor.Selection.Start
						PushToUndoStack()
					end
				end
				local CaretPlaceInd = Editor.Selection.Start
				if Editor.Selection.Side == Side.Right then
					CaretPlaceInd = Editor.Selection.End
				end
				local CaretPlace = Place.fromIndex(Editor, CaretPlaceInd)
				updateCaret(CaretPlace)
				UpdateSelection()
			end
			TextBox:GetPropertyChangedSignal("Text"):Connect(function()
				if TextBox.Text ~= "" then
					ProcessInput("StringInput", (gsub(TextBox.Text, "\r", "")))
					TextBox.Text = ""
					--TextBox:CaptureFocus()
				end
			end)
			UIS.InputBegan:Connect(function(Input)
				if UIS:GetFocusedTextBox() == TextBox and Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
					local KeyCode = Input.KeyCode
					if KeyCode == Enum.KeyCode.LeftShift then
						LeftShift = true
						Shift = true
					elseif KeyCode == Enum.KeyCode.RightShift then
						RightShift = true
						Shift = true
					elseif KeyCode == Enum.KeyCode.LeftControl then
						LeftCtrl = true
						Ctrl = true
					elseif KeyCode == Enum.KeyCode.RightControl then
						RightCtrl = true
						Ctrl = true
					else
						PressedKey = KeyCode
						ProcessInput(not (not Ctrl or Shift) and "Control+Key" or "KeyPress", KeyCode)
						local UniqueID = newproxy(false)
						WorkingKey = UniqueID
						wait(0.25)
						if WorkingKey == UniqueID then
							WorkingKey = true
						end
					end
				end
			end)
			UIS.InputEnded:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 then
					BeginSelect = nil
				end
				if Input.KeyCode == Enum.KeyCode.LeftShift then
					LeftShift = false
				end
				if Input.KeyCode == Enum.KeyCode.RightShift then
					RightShift = false
				end
				if Input.KeyCode == Enum.KeyCode.LeftControl then
					LeftCtrl = false
				end
				if Input.KeyCode == Enum.KeyCode.RightControl then
					RightCtrl = false
				end
				Shift = LeftShift or RightShift
				Ctrl = LeftCtrl or RightCtrl
				if PressedKey == Input.KeyCode then
					PressedKey = nil
					WorkingKey = nil
				end
			end)
			local Count = 0
			game:GetService("RunService").Heartbeat:Connect(function()
				if Count == 0 and WorkingKey == true then
					ProcessInput(not (not Ctrl or Shift) and "Control+Key" or "KeyPress", PressedKey)
				end
				Count = (Count + 1) % 2
			end)
			Editor.Write = Write
			Editor.SetContent = SetContent
			Editor.SetVisibility = SetVisibility
			Editor.PushToUndoStack = PushToUndoStack
			Editor.Undo = Undo
			Editor.Redo = Redo
			function Editor.UpdateTheme(theme)
				for obj, v in pairs(themestuff) do
					for key, value in pairs(v) do
						obj[key] = Themes[theme][value]
					end
				end
				Options.Theme = theme
				ClearTokensAndSelection()
				updateMarkers()
			end
			function Editor.HighlightError(Visible, Line, Msg)
				if Visible then
					ErrorHighlighter.Position = udim2(0, 2, 0, CharHeight * Line + 2 - CharHeight)
					ErrorMessage.Text = "Line " .. Line .. " - " .. Msg
					ErrorMessage.Size = udim2(0, ErrorMessage.TextBounds.X + 15, 0, ErrorMessage.TextBounds.Y + 8)
				else
					ErrorMessage.Visible = false
				end
				ErrorHighlighter.Visible = Visible
			end
			Editor.ContentChanged = ContentChangedEvent.Event
			Editor.FocusLost = FocusLostEvent.Event
			TextArea.CanvasPosition = Vector2.new(0, 0);
			return Editor, TextBox, ClearTokensAndSelection, TextArea;
		end

		local ScriptEditor, EditorGrid, Clear, TxtArea = EditorLib.Initialize(editor:FindFirstChild("Editor"), {
			Font = Enum.Font.Code,
			TextSize = 16;
			Language = "Lua",
			CaretBlinkingRate = 0.5
		})

		local function openScript(o)
			EditorGrid.Text = "";
			local id = GetDebugId(o);

			if cache[id] then
				ScriptEditor.SetContent(cache[id])
			else
				local decompiled = decompile(o);
				cache[id] = decompiled;
				game:GetService("RunService").Heartbeat:wait();
				ScriptEditor.SetContent(cache[id])
			end

			Title.Text = "[Script Viewer] Viewing: " .. o.Name;
		end

		bindable.Event:connect(function(object)
			editor.Visible = true;
			openScript(object)
		end)

		SaveScript.MouseButton1Click:connect(function()
			if ScriptEditor.Content ~= "" then
				local fileName = FileName.Text;
				if fileName == "File Name" or FileName == "" then
					fileName = "LocalScript_" .. math.random(1, 5000)
				end

				fileName = fileName .. ".lua";
				writefile(fileName, ScriptEditor.Content);
			end
		end)

		CopyScript.MouseButton1Click:connect(function()
			local txt = ScriptEditor.Content;
			if Clipboard then
				Clipboard.set(txt)
			else
				setclipboard(txt)
			end
		end)

		ClearScript.MouseButton1Click:connect(function()
			--EditorGrid.Text = "";
			ScriptEditor.SetContent("")
			TxtArea.CanvasPosition = Vector2.new(0, 0);
			Title.Text = "[Script Viewer]";
			Clear();
		end)

		CloseEditor.MouseButton1Click:connect(function()
			editor.Visible = false;
		end)
	end)

	Gui.Parent = game:GetService("CoreGui")
end)
