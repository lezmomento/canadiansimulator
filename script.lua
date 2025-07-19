local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- use this skidded script for maple state sim and copies of can sim
-- don't recommend using this for the original game as its exploited enough
local Window = Rayfield:CreateWindow({
    Name = "canadian sim larp destroy 14.88",
    Icon = 0,
    LoadingTitle = "Loading canadian sim larp destroy 14.88",
    LoadingSubtitle = "by SkidLabs",
    Theme = "Ocean",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "CSLarpDestroyer"
    },
    Discord = {
        Enabled = true,
        Invite = "jqAGuECSTG",
        RememberJoins = false
    },
    KeySystem = true,
    KeySettings = {
        Title = "Enter the Key",
        Subtitle = "Canadian Sim Larp Destroyer 14.88", 
        Note = "Key in Discord: /S8BTTbXN8H",
        FileName = "Key",
        SaveKey = false,
        GrabKeyFromSite = true,
        Key = {"ANTILARPACTION"}
    }
})

-- Tabs
local PlayerTab = Window:CreateTab("Player", "user")
local ModsTab = Window:CreateTab("Mods", "wand")
local ESPTab = Window:CreateTab("ESP", "eye")
local TeleportTab = Window:CreateTab("Teleport", "compass")
local RageTab = Window:CreateTab("Rage", "user")

-- Sections
PlayerTab:CreateSection("Player Features")
ModsTab:CreateSection("Gun Modifications")
ESPTab:CreateSection("Visuals / ESP")
TeleportTab:CreateSection("Teleportation Features")
RageTab:CreateSection("Rage Features")

------------------------------------------------------------------
-- PLAYER FEATURES
------------------------------------------------------------------

local Camera = workspace.CurrentCamera
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local TargetFOV = Camera.FieldOfView
local LockFOV = false
local fullbrightEnabled = false

local FullbrightSettings = {
    Ambient = Color3.fromRGB(255, 255, 255),
    Brightness = 1,
    ClockTime = 12,
    FogEnd = 100000,
    GlobalShadows = false,
    OutdoorAmbient = Color3.fromRGB(255, 255, 255),
}

PlayerTab:CreateSlider({
    Name = "Change FOV",
    Range = {50, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = TargetFOV,
    Callback = function(Value)
        TargetFOV = Value
        if LockFOV then
            Camera.FieldOfView = TargetFOV
        end
    end,
})

PlayerTab:CreateToggle({
    Name = "Lock FOV (to not reset)",
    CurrentValue = false,
    Callback = function(Value)
        LockFOV = Value
        if LockFOV then
            Camera.FieldOfView = TargetFOV
        end
    end,
})

Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if LockFOV and Camera.FieldOfView ~= TargetFOV then
        Camera.FieldOfView = TargetFOV
    end
end)

local function applyFullbright()
    for property, value in pairs(FullbrightSettings) do
        Lighting[property] = value
    end
end

PlayerTab:CreateToggle({
    Name = "Enable Fullbright",
    CurrentValue = false,
    Callback = function(Value)
        fullbrightEnabled = Value
        if fullbrightEnabled then
            RunService.RenderStepped:Connect(function()
                if fullbrightEnabled then
                    applyFullbright()
                end
            end)
            Rayfield:Notify({Title = "Fullbright Enabled", Content = "Map is now bright!", Duration = 5, Image = "sun"})
        else
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
            Lighting.GlobalShadows = true
            Rayfield:Notify({Title = "Fullbright Disabled", Content = "Map lighting reset.", Duration = 5, Image = "moon"})
        end
    end,
})

PlayerTab:CreateButton({
    Name = "Instant Hotwire (lag upon executing)",
    Callback = function()
        for _, model in ipairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("aiy", true) then
                local aiyPart = model:FindFirstChild("aiy", true)
                if aiyPart:IsA("BasePart") then
                    local repairPoint = aiyPart:FindFirstChild("RepairPoint")
                    if repairPoint and repairPoint:IsA("Attachment") then
                        for _, child in ipairs(repairPoint:GetChildren()) do
                            if child:IsA("ProximityPrompt") then
                                child.HoldDuration = 0
                            end
                        end
                    end
                end
            end
        end

        Rayfield:Notify({Title = "Instant Hotwire Activated", Content = "All vehicles' hotwires are now instant!", Duration = 5, Image = "zap"})
    end,
})


------------------------------------------------------------------
-- MODS (GUN MODIFICATIONS)
------------------------------------------------------------------

local ImportantZeroValues = {}
local player = game.Players.LocalPlayer

ModsTab:CreateButton({
    Name = "Infinite Ammo",
    Callback = function()
        local character = workspace:WaitForChild(player.Name)
        local ammoFolder = character:WaitForChild("PlayerAmmoAmount")
        for _, ammoValue in ipairs(ammoFolder:GetChildren()) do
            if ammoValue:IsA("NumberValue") then
                ammoValue.Value = math.huge
            end
        end
        Rayfield:Notify({Title = "Infinite Ammo", Content = "Your ammo is now infinite!", Duration = 5, Image = "infinity"})
    end,
})

ModsTab:CreateButton({
    Name = "Infinite Weapon Stored Ammo",
    Callback = function()
        local backpack = player.Backpack
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:FindFirstChild("GunValues") and tool.GunValues:FindFirstChild("YAmmmoPerMagazine") then
                tool.GunValues.YAmmmoPerMagazine.Value = 99999
            end
        end
        Rayfield:Notify({Title = "Stored Ammo Infinite", Content = "Weapons now have infinite stored ammo!", Duration = 5, Image = "box"})
    end,
})

local function setupZeroRecoil()
    local character = workspace:WaitForChild(player.Name)

    local function scanGun(tool)
        local gunValues = tool:FindFirstChild("GunValues")
        if gunValues then
            local recoilValues = gunValues:FindFirstChild("RecoilValues")
            if recoilValues then
                for _, child in ipairs(recoilValues:GetChildren()) do
                    if (child.Name == "Accuracy" or child.Name == "Recoil") and (child:IsA("IntValue") or child:IsA("NumberValue")) then
                        table.insert(ImportantZeroValues, child)
                        child.Value = 0
                    end
                end
            end
            local spreadValue = gunValues:FindFirstChild("SpreadValue")
            if spreadValue and (spreadValue:IsA("IntValue") or spreadValue:IsA("NumberValue")) then
                table.insert(ImportantZeroValues, spreadValue)
                spreadValue.Value = 0
            end
        end
    end

    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            scanGun(tool)
        end
    end

    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            scanGun(child)
        end
    end)

    RunService.RenderStepped:Connect(function()
        for _, val in ipairs(ImportantZeroValues) do
            if val.Value ~= 0 then
                val.Value = 0
            end
        end
    end)
end

ModsTab:CreateButton({
    Name = "Activate Zero Recoil + Accuracy",
    Callback = function()
        setupZeroRecoil()
        Rayfield:Notify({Title = "Zero Recoil", Content = "Accuracy is locked!", Duration = 5, Image = "crosshair"})
    end,
})

ModsTab:CreateButton({
    Name = "Infinite Fire (Single-Shot Weapons)",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = workspace:WaitForChild(player.Name)
        local RunService = game:GetService("RunService")
        local allReadyToFireValues = {}

        local function scanGun(tool)
            local gunValues = tool:FindFirstChild("GunValues")
            if gunValues then
                for _, child in ipairs(gunValues:GetChildren()) do
                    if child:IsA("BoolValue") and string.find(child.Name, "ReadyToFire") then
                        table.insert(allReadyToFireValues, child)
                        child.Value = true
                    end
                end
            end
        end

        for _, tool in ipairs(character:GetChildren()) do
            if tool:IsA("Tool") then
                scanGun(tool)
            end
        end

        character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                scanGun(child)
            end
        end)

        RunService.RenderStepped:Connect(function()
            for _, boolVal in ipairs(allReadyToFireValues) do
                if boolVal and boolVal.Parent and not boolVal.Value then
                    boolVal.Value = true
                end
            end
        end)

        Rayfield:Notify({
            Title = "Infinite Fire Activated",
            Content = "All single-shot weapons will instantly fire now!",
            Duration = 5,
            Image = "zap"
        })
    end,
})

------------------------------------------------------------------
-- ESP FEATURES
------------------------------------------------------------------
ESPTab:CreateButton({
    Name = "Highlight Tools", 
    Callback = function()
        -- Get all children of the workspace
        local folder = game.Workspace:GetChildren()

        -- Iterate through the children
        for _, object in ipairs(folder) do
            -- Check if the object is a Tool
            if object:IsA("Tool") then
                -- Create a new Highlight instance
                local highlight = Instance.new("Highlight")
                highlight.Parent = object

                -- Customize the highlight (optional)
                highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- Example: red highlight
                highlight.FillTransparency = 0.5  -- Adjust transparency (0 is solid, 1 is fully transparent)
                highlight.OutlineTransparency = 0  -- Outline visibility (0 is solid, 1 is fully transparent)
                highlight.Enabled = true  -- Make sure the highlight is enabled
            end
        end
    end
})
------------------------------------------------------------------
-- TELEPORTATION FEATURES
------------------------------------------------------------------

local deathPosition = nil

local player = game.Players.LocalPlayer

player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        local root = character:FindFirstChild("HumanoidRootPart")
        if root then
            deathPosition = root.Position
        end
    end)
end)

TeleportTab:CreateButton({
    Name = "Teleport To Death Position",
    Callback = function()
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and deathPosition then
            character:MoveTo(deathPosition)
            Rayfield:Notify({Title = "Teleport Success", Content = "Teleported to death location.", Duration = 5, Image = "map-pin"})
        else
            Rayfield:Notify({Title = "Teleport Failed", Content = "No saved death position!", Duration = 5, Image = "alert-circle"})
        end
    end,
})

TeleportTab:CreateButton({
    Name = "Teleport to Gun Store",
    Callback = function()
        local gunStore = game.Workspace:FindFirstChild("GunStore")
        if gunStore and gunStore:FindFirstChildWhichIsA("BasePart") then
            local part = gunStore:FindFirstChildWhichIsA("BasePart")
            player.Character:MoveTo(part.Position)
            Rayfield:Notify({Title = "Teleported", Content = "Teleported to Gun Store!", Duration = 5, Image = "map-pin"})
        else
            Rayfield:Notify({Title = "Teleport Failed", Content = "GunStore not found or no valid part!", Duration = 5, Image = "alert-circle"})
        end
    end,
})

------------------------------------------------------------------
-- RAGE FEATURES
------------------------------------------------------------------

local victimName = ""
local SavedPos = nil
local lp = game.Players.LocalPlayer

local function findPlayerByName(str)
	str = str:lower()
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player.DisplayName:lower():sub(1, #str) == str or player.Name:lower():sub(1, #str) == str then
			return player
		end
	end
	return nil
end

local Input = RageTab:CreateInput({
	Name = "Victim Username",
	PlaceholderText = "Enter victims username or display",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		victimName = Text
	end,
})

local Button = RageTab:CreateButton({
	Name = "Fling Victim",
	Callback = function()
		local target = findPlayerByName(victimName)
		if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
			Rayfield:Notify({
				Title = "Invalid Target",
				Content = "No player found with that name.",
				Duration = 4
			})
			return
		end

		local thrust = Instance.new("BodyThrust")
		thrust.Force = Vector3.new(9999, 9999, 9999)
		thrust.Name = "FlingForce"
		thrust.Parent = lp.Character.HumanoidRootPart

		local connection
		connection = game:GetService("RunService").Heartbeat:Connect(function()
			if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
				lp.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
				thrust.Location = target.Character.HumanoidRootPart.Position
			else
				connection:Disconnect()
			end
		end)

		if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
			SavedPos = lp.Character.HumanoidRootPart.Position
		end
	end,
})

-- Create the button
RageTab:CreateButton({
    Name = "Buy Everything",
    Callback = function()
        local count = 0

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("RemoteEvent") and obj.Name == "BuyEventyer" then
                obj:FireServer()
                count += 1
            end
        end

        Rayfield:Notify({
            Title = "Done!",
            Content = "Fired " .. count .. " BuyEventyer RemoteEvents.",
            Duration = 5,
        })
    end,
})