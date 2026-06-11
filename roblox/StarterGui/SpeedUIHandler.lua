-- StarterGui/SpeedGui.lua
-- Note: In Roblox Studio, place this inside a LocalScript inside a ScreenGui in StarterGui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Better waiting for leaderstats and Speed stat
local leaderstats = player:WaitForChild("leaderstats", 10)
if not leaderstats then
	warn("SpeedUIHandler: Timed out waiting for leaderstats")
	return
end

local speedStat = leaderstats:WaitForChild("Speed", 10)
if not speedStat then
	warn("SpeedUIHandler: Timed out waiting for Speed stat")
	return
end

-- Create UI elements via script for easy copy-pasting
local screenGui = script:FindFirstAncestorWhichIsA("ScreenGui")
if not screenGui then
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SpeedGui"
	screenGui.Parent = player:WaitForChild("PlayerGui")
	screenGui.ResetOnSpawn = false
end

local container = screenGui:FindFirstChild("MainContainer") or Instance.new("Frame")
container.Name = "MainContainer"
container.Size = UDim2.new(0, 220, 0, 60)
container.Position = UDim2.new(0.5, 0, 0, 20)
container.AnchorPoint = Vector2.new(0.5, 0)
container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
container.BorderSizePixel = 0
container.Parent = screenGui

local uiCorner = container:FindFirstChildWhichIsA("UICorner") or Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = container

local uiGradient = container:FindFirstChildWhichIsA("UIGradient") or Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 85, 0)), -- Vibrant Orange
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 170, 0))  -- Golden Yellow
})
uiGradient.Rotation = 45
uiGradient.Parent = container

local textLabel = container:FindFirstChild("SpeedLabel") or Instance.new("TextLabel")
textLabel.Name = "SpeedLabel"
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = true
textLabel.Font = Enum.Font.FredokaOne -- More "gamey" font
textLabel.Text = "⚡ SPEED: " .. speedStat.Value
textLabel.Parent = container

local uiStroke = textLabel:FindFirstChildWhichIsA("UIStroke") or Instance.new("UIStroke")
uiStroke.Thickness = 2.5
uiStroke.Transparency = 0.2
uiStroke.Color = Color3.fromRGB(0, 0, 0)
uiStroke.Parent = textLabel

-- Pulse effect when speed increases
local function pulseUI()
	local originalSize = UDim2.new(0, 220, 0, 60)
	local targetSize = UDim2.new(0, 240, 0, 70)

	local pulseIn = TweenService:Create(container, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize})
	local pulseOut = TweenService:Create(container, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = originalSize})

	pulseIn:Play()
	pulseIn.Completed:Connect(function()
		pulseOut:Play()
	end)
end

-- Update UI when speed changes
speedStat.Changed:Connect(function(newValue)
	textLabel.Text = "⚡ SPEED: " .. newValue
	pulseUI()
end)
