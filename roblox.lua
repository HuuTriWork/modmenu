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
        end
    },
    
    Heal = {
        Execute = function(self)
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid.Health = character.Humanoid.MaxHealth
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
    Size = UDim2.new(0, 300, 0, 250),  
    Position = UDim2.new(0.5, -150, 0.5, -125), 
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

UpdateButtonAppearance(NoClipButton, Cheats.NoClip.Enabled)
UpdateButtonAppearance(GodModeButton, Cheats.GodMode.Enabled)

MainFrame.Size = UDim2.new(0, 300, 0, 0)  
MainFrame.Position = UDim2.new(0.5, -150, 0.5, 0)  
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Size = UDim2.new(0, 300, 0, 250), Position = UDim2.new(0.5, -150, 0.5, -125)}):Play()

warn("MOD BY HUU TRI :D")
