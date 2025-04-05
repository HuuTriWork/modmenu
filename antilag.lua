local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local Terrain = workspace:FindFirstChildOfClass("Terrain")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local HiddenBees = {}
local Optimized = false
local FPSEnabled = false

local Settings = {
    HideBees = true, 
    RemoveMap = true,
    NoParticles = true, 
    UltraMode = true, 
    Shadows = false 
}

local function SuperOptimize()
    if Optimized then return end

    if Terrain and Settings.RemoveMap then
        Terrain:Clear()
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 1
    end

    Lighting.GlobalShadows = Settings.Shadows
    Lighting.FogEnd = 9e9
    Lighting.Brightness = 2

    if Settings.UltraMode then
        settings().Rendering.QualityLevel = 1
        RunService:Set3dRenderingEnabled(false)
        setfpscap(300)
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if Settings.HideBees and obj:IsA("Model") and obj.Name:find("Bee") then
            for _, part in ipairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    part.CanCollide = false
                end
            end
            table.insert(HiddenBees, obj)
        elseif Settings.NoParticles and obj:IsA("ParticleEmitter") then
            obj.Enabled = false
        end
    end

    workspace.DescendantAdded:Connect(function(obj)
        if Settings.HideBees and obj:IsA("Model") and obj.Name:find("Bee") then
            task.defer(function()
                for _, part in ipairs(obj:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                    end
                end
            end)
        elseif Settings.NoParticles and obj:IsA("ParticleEmitter") then
            obj.Enabled = false
        end
    end)

    Optimized = true
end

local function ShowFPS()
    if FPSEnabled then return end

    local FPSFrame = Instance.new("Frame")
    FPSFrame.Size = UDim2.new(0, 80, 0, 30)
    FPSFrame.Position = UDim2.new(0, 10, 0, 10)
    FPSFrame.BackgroundTransparency = 0.8
    FPSFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    FPSFrame.Parent = game:GetService("CoreGui")

    local FPSText = Instance.new("TextLabel")
    FPSText.Size = UDim2.new(1, 0, 1, 0)
    FPSText.Text = "FPS: 0"
    FPSText.TextColor3 = Color3.new(1, 1, 1)
    FPSText.Font = Enum.Font.Code
    FPSText.BackgroundTransparency = 1
    FPSText.Parent = FPSFrame

    local lastUpdate = tick()
    RunService.Heartbeat:Connect(function()
        if tick() - lastUpdate >= 0.5 then
            local fps = math.floor(1 / Stats.PerformanceStats.Ping:GetValue())
            FPSText.Text = "FPS: " .. fps
            lastUpdate = tick()
        end
    end)

    FPSEnabled = true
end

local function CreateMiniGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "OptimizerMiniGUI"
    ScreenGui.Parent = game:GetService("CoreGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 120, 0, 80)
    MainFrame.Position = UDim2.new(0, 10, 0, 50)
    MainFrame.BackgroundTransparency = 0.8
    MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local OptimizeBtn = Instance.new("TextButton")
    OptimizeBtn.Text = Optimized and "GIẢM LAG: ON" : "GIẢM LAG: OFF"
    OptimizeBtn.Size = UDim2.new(0.9, 0, 0, 30)
    OptimizeBtn.Position = UDim2.new(0.05, 0, 0, 10)
    OptimizeBtn.BackgroundColor3 = Optimized and Color3.new(0, 0.5, 0) or Color3.new(0.5, 0, 0)
    OptimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    OptimizeBtn.Font = Enum.Font.Gotham
    OptimizeBtn.Parent = MainFrame

    OptimizeBtn.MouseButton1Click:Connect(function()
        Optimized = not Optimized
        OptimizeBtn.Text = Optimized and "GIẢM LAG: ON" : "GIẢM LAG: OFF"
        OptimizeBtn.BackgroundColor3 = Optimized and Color3.new(0, 0.5, 0) or Color3.new(0.5, 0, 0)
        if Optimized then
            SuperOptimize()
        end
    end)

    local FPSBtn = Instance.new("TextButton")
    FPSBtn.Text = "HIỆN FPS"
    FPSBtn.Size = UDim2.new(0.9, 0, 0, 30)
    FPSBtn.Position = UDim2.new(0.05, 0, 0, 45)
    FPSBtn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.5)
    FPSBtn.TextColor3 = Color3.new(1, 1, 1)
    FPSBtn.Font = Enum.Font.Gotham
    FPSBtn.Parent = MainFrame

    FPSBtn.MouseButton1Click:Connect(function()
        ShowFPS()
    end)
end

CreateMiniGUI()
SuperOptimize() 
warn("MOD BY HUU TRI <3")
