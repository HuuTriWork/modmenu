local ToDisable = {
    Textures = true,
    VisualEffects = true,
    Parts = true,
    Particles = true,
    Sky = true,
    Shadows = true,  -- New setting
    Terrain = true   -- New setting
}

local ToEnable = {
    FullBright = false,
    LowGraphics = true  -- New setting
}

local Stuff = {}

local function OptimizeTerrain()
    if not ToDisable.Terrain then return end
    
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        -- Modern alternative that works in all versions
        pcall(function()
            terrain.Decoration = false  -- Try older property first
        end)
        
        pcall(function()
            terrain.DecorationLayers = Enum.TerrainDecorationLayer.None  -- Try newer property
        end)
        
        -- These water properties should work in all versions
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
    end
end

-- Function to disable shadows
local function DisableShadows()
    if not ToDisable.Shadows then return end
    
    for _, v in next, game:GetDescendants() do
        if v:IsA("BasePart") then
            v.CastShadow = false
            table.insert(Stuff, 1, v)
        end
    end
end

-- Main optimization loop
for _, v in next, game:GetDescendants() do
    if ToDisable.Parts then
        if v:IsA("Part") or v:IsA("Union") or v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            if ToEnable.LowGraphics then
                v.Reflectance = 0
                v.Transparency = v.Transparency > 0.5 and v.Transparency or 0
            end
            table.insert(Stuff, 1, v)
        end
    end
    
    if ToDisable.Particles then
        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
            v.Enabled = false
            table.insert(Stuff, 1, v)
        end
    end
    
    if ToDisable.VisualEffects then
        if v:IsA("PostEffect") then  -- Covers all post-processing effects
            v.Enabled = false
            table.insert(Stuff, 1, v)
        end
    end
    
    if ToDisable.Textures then
        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("SurfaceAppearance") then
            if v:IsA("Decal") then
                v.Texture = ""
            elseif v:IsA("Texture") then
                v.TextureID = ""
            elseif v:IsA("SurfaceAppearance") then
                v.ColorMap = ""
                v.MetalnessMap = ""
                v.NormalMap = ""
                v.RoughnessMap = ""
            end
            table.insert(Stuff, 1, v)
        end
    end
    
    if ToDisable.Sky then
        if v:IsA("Sky") then
            v.Parent = nil
            table.insert(Stuff, 1, v)
        end
    end
end

-- Run additional optimizations
DisableShadows()
OptimizeTerrain()

-- Optimize lighting
if ToEnable.LowGraphics then
    local lighting = game:GetService("Lighting")
    lighting.GlobalShadows = false
    lighting.FogEnd = 100000
end

game:GetService("TestService"):Message("Advanced Anti-Lag System : Successfully optimized "..#Stuff.." assets. Settings :")

for i, v in next, ToDisable do
    print(tostring(i)..": "..tostring(v))
end

for i, v in next, ToEnable do
    print(tostring(i)..": "..tostring(v))
end

if ToEnable.FullBright then
    local Lighting = game:GetService("Lighting")
    
    Lighting.FogEnd = math.huge
    Lighting.FogStart = math.huge
    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    Lighting.Brightness = 5
    Lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
    Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end

-- Anti-AFK system
local VirtualUser = game:GetService('VirtualUser')
game:GetService('Players').LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function CreateElement(className, properties)
    local element = Instance.new(className)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    return element
end

local function ShowNotification(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 3
    })
end

local Cheats = {
    NoClip = {
        Enabled = false,
        Toggle = function(self)
            self.Enabled = not self.Enabled
            local character = LocalPlayer.Character
            if not character then return end
            
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = not self.Enabled
                end
            end
            ShowNotification("NO-CLIP", self.Enabled and "Enabled" or "Disabled")
        end,
        Run = function(self)
            RunService.Stepped:Connect(function()
                if self.Enabled and LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    },
    
    GodMode = {
        Enabled = false,
        Toggle = function(self)
            self.Enabled = not self.Enabled
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid.MaxHealth = self.Enabled and math.huge or 100
                character.Humanoid.Health = self.Enabled and math.huge or 100
            end
            ShowNotification("GOD MODE", self.Enabled and "Enabled" or "Disabled")
        end
    },
    
    Heal = {
        Execute = function(self)
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid.Health = character.Humanoid.MaxHealth
                ShowNotification("HEAL", "Health restored to full!")
            end
        end
    },
    
    AntiAFK = {
        Enabled = true,
        Toggle = function(self)
            self.Enabled = not self.Enabled
            ShowNotification("ANTI-AFK", self.Enabled and "Enabled" or "Disabled")
        end
    },
    
    AntiLag = {
        Enabled = false,
        Toggle = function(self)
            self.Enabled = not self.Enabled
            if self.Enabled then
                -- Apply anti-lag optimizations
                for _, v in next, game:GetDescendants() do
                    if ToDisable.Parts then
                        if v:IsA("Part") or v:IsA("Union") or v:IsA("BasePart") then
                            v.Material = Enum.Material.SmoothPlastic
                            if ToEnable.LowGraphics then
                                v.Reflectance = 0
                                v.Transparency = v.Transparency > 0.5 and v.Transparency or 0
                            end
                        end
                    end
                    
                    if ToDisable.Particles then
                        if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Explosion") or v:IsA("Sparkles") or v:IsA("Fire") then
                            v.Enabled = false
                        end
                    end
                    
                    if ToDisable.VisualEffects then
                        if v:IsA("PostEffect") then
                            v.Enabled = false
                        end
                    end
                    
                    if ToDisable.Textures then
                        if v:IsA("Decal") or v:IsA("Texture") or v:IsA("SurfaceAppearance") then
                            if v:IsA("Decal") then
                                v.Texture = ""
                            elseif v:IsA("Texture") then
                                v.TextureID = ""
                            elseif v:IsA("SurfaceAppearance") then
                                v.ColorMap = ""
                                v.MetalnessMap = ""
                                v.NormalMap = ""
                                v.RoughnessMap = ""
                            end
                        end
                    end
                    
                    if ToDisable.Sky then
                        if v:IsA("Sky") then
                            v.Parent = nil
                        end
                    end
                end
                
                DisableShadows()
                OptimizeTerrain()
                
                if ToEnable.LowGraphics then
                    local lighting = game:GetService("Lighting")
                    lighting.GlobalShadows = false
                    lighting.FogEnd = 100000
                end
                
                ShowNotification("ANTI-LAG", "Enabled - Game optimized")
            else
                ShowNotification("ANTI-LAG", "Disabled - Some optimizations may persist")
            end
        end
    }
}

Cheats.NoClip:Run()

local DarkCyberGUI = CreateElement("ScreenGui", {
    Name = "MOD BY HUU TRI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = game.CoreGui
})

local MainFrame = CreateElement("Frame", {
    Name = "MainFrame",
    Size = UDim2.new(0, 300, 0, 350),  -- Increased height for new buttons
    Position = UDim2.new(0.5, -150, 0.5, -175), 
    BackgroundColor3 = Color3.fromRGB(30, 30, 35),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Parent = DarkCyberGUI
})

local DropShadow = CreateElement("ImageLabel", {
    Name = "DropShadow",
    Size = UDim2.new(1, 10, 1, 10),
    Position = UDim2.new(0, -5, 0, -5),
    BackgroundTransparency = 1,
    Image = "rbxassetid://1316045217",
    ImageColor3 = Color3.new(0, 0, 0),
    ImageTransparency = 0.8,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(10, 10, 118, 118),
    Parent = MainFrame
})

local TitleBar = CreateElement("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 30),  
    BackgroundColor3 = Color3.fromRGB(25, 25, 30),
    BorderSizePixel = 0,
    Parent = MainFrame
})

local TitleGradient = CreateElement("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 120, 200)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 80, 200))
    }),
    Rotation = 90,
    Parent = TitleBar
})

local TitleLabel = CreateElement("TextLabel", {
    Name = "TitleLabel",
    Size = UDim2.new(0.8, 0, 1, 0),
    Position = UDim2.new(0.1, 0, 0, 0),
    Text = "MOD BY HUU TRI",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 14,  
    BackgroundTransparency = 1,
    Parent = TitleBar
})

local CloseButton = CreateElement("TextButton", {
    Name = "CloseButton",
    Size = UDim2.new(0, 30, 0, 30),  
    Position = UDim2.new(1, -30, 0, 0),
    Text = "×",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    TextSize = 20,  
    BackgroundColor3 = Color3.fromRGB(200, 50, 50),
    BorderSizePixel = 0,
    Parent = TitleBar
})

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 70, 70)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 50, 50)}):Play()
end)

CloseButton.MouseButton1Click:Connect(function()
    DarkCyberGUI:Destroy()
end)

local ContentFrame = CreateElement("Frame", {
    Name = "ContentFrame",
    Size = UDim2.new(1, -20, 1, -50), 
    Position = UDim2.new(0, 10, 0, 40), 
    BackgroundTransparency = 1,
    Parent = MainFrame
})

local function CreateStyledButton(name, text, position)
    local button = CreateElement("TextButton", {
        Name = name,
        Size = UDim2.new(1, 0, 0, 40),  
        Position = position,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,  
        BackgroundColor3 = Color3.fromRGB(50, 50, 60),
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Parent = ContentFrame
    })

    local corner = CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 6),
        Parent = button
    })

    local stroke = CreateElement("UIStroke", {
        Color = Color3.fromRGB(80, 80, 90),
        Thickness = 2,
        Parent = button
    })

    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 70, 80)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(100, 100, 120)}):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 80, 90)}):Play()
    end)

    return button
end

local NoClipButton = CreateStyledButton("NoClipButton", "NO-CLIP: OFF", UDim2.new(0, 0, 0, 0))
local GodModeButton = CreateStyledButton("GodModeButton", "GOD MODE: OFF", UDim2.new(0, 0, 0, 50))  
local HealButton = CreateStyledButton("HealButton", "HEAL FULL HP", UDim2.new(0, 0, 0, 100))
local AntiAFKButton = CreateStyledButton("AntiAFKButton", "ANTI-AFK: ON", UDim2.new(0, 0, 0, 150))
local AntiLagButton = CreateStyledButton("AntiLagButton", "ANTI-LAG: OFF", UDim2.new(0, 0, 0, 200))  -- New Anti-Lag button

local function UpdateButtonAppearance(button, enabled)
    if button.Name == "HealButton" then return end 
    
    button.Text = button.Name:gsub("Button", ""):upper() .. ": " .. (enabled and "ON" or "OFF")
    button.BackgroundColor3 = enabled and Color3.fromRGB(60, 120, 60) or Color3.fromRGB(50, 50, 60)
    
    if enabled then
        button.UIStroke.Color = Color3.fromRGB(100, 180, 100)
    else
        button.UIStroke.Color = Color3.fromRGB(80, 80, 90)
    end
end

NoClipButton.MouseButton1Click:Connect(function()
    Cheats.NoClip:Toggle()
    UpdateButtonAppearance(NoClipButton, Cheats.NoClip.Enabled)
end)

GodModeButton.MouseButton1Click:Connect(function()
    Cheats.GodMode:Toggle()
    UpdateButtonAppearance(GodModeButton, Cheats.GodMode.Enabled)
end)

HealButton.MouseButton1Click:Connect(function()
    Cheats.Heal:Execute()
    
    TweenService:Create(HealButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 150, 80)}):Play()
    TweenService:Create(HealButton.UIStroke, TweenInfo.new(0.1), {Color = Color3.fromRGB(120, 220, 120)}):Play()
    
    task.wait(0.1)
    
    TweenService:Create(HealButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(50, 50, 60)}):Play()
    TweenService:Create(HealButton.UIStroke, TweenInfo.new(0.3), {Color = Color3.fromRGB(80, 80, 90)}):Play()
end)

AntiAFKButton.MouseButton1Click:Connect(function()
    Cheats.AntiAFK:Toggle()
    UpdateButtonAppearance(AntiAFKButton, Cheats.AntiAFK.Enabled)
end)

AntiLagButton.MouseButton1Click:Connect(function()
    Cheats.AntiLag:Toggle()
    UpdateButtonAppearance(AntiLagButton, Cheats.AntiLag.Enabled)
end)

UpdateButtonAppearance(NoClipButton, Cheats.NoClip.Enabled)
UpdateButtonAppearance(GodModeButton, Cheats.GodMode.Enabled)
UpdateButtonAppearance(AntiAFKButton, Cheats.AntiAFK.Enabled)
UpdateButtonAppearance(AntiLagButton, Cheats.AntiLag.Enabled)

MainFrame.Size = UDim2.new(0, 300, 0, 0)  
MainFrame.Position = UDim2.new(0.5, -150, 0.5, 0)  
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 300, 0, 350), Position = UDim2.new(0.5, -150, 0.5, -175)}):Play()

warn("MOD BY HUU TRI :D")
