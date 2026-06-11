-- StarterGui/SpeedGui.lua
-- Note: In Roblox Studio, place this inside a LocalScript inside a ScreenGui in StarterGui

local Players = game:GetService("Players")
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

local textLabel = screenGui:FindFirstChild("SpeedLabel") or Instance.new("TextLabel")
textLabel.Name = "SpeedLabel"
textLabel.Size = UDim2.new(0, 200, 0, 50)
textLabel.Position = UDim2.new(0.5, -100, 0, 20) -- Top middle
textLabel.AnchorPoint = Vector2.new(0.5, 0)
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textLabel.BackgroundTransparency = 0.5
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = true
textLabel.Font = Enum.Font.SourceSansBold
textLabel.Text = "Speed: " .. speedStat.Value
textLabel.Parent = screenGui

-- UI Corner for styling
if not textLabel:FindFirstChildWhichIsA("UICorner") then
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = textLabel
end

-- Update UI when speed changes
speedStat.Changed:Connect(function(newValue)
	textLabel.Text = "Speed: " .. newValue
end)
