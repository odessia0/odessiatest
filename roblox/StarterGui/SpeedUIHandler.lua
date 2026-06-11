-- StarterGui/SpeedGui.lua
-- Note: In Roblox Studio, place this inside a LocalScript inside a ScreenGui in StarterGui

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats")
local speedStat = leaderstats:WaitForChild("Speed")

-- Create UI elements via script for easy copy-pasting
local screenGui = script.Parent -- Assuming script is inside the ScreenGui
if not screenGui:IsA("ScreenGui") then
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "SpeedGui"
	screenGui.Parent = player:WaitForChild("PlayerGui")
end

local textLabel = Instance.new("TextLabel")
textLabel.Name = "SpeedLabel"
textLabel.Size = UDim2.new(0, 200, 0, 50)
textLabel.Position = UDim2.new(0.5, -100, 0, 20) -- Top middle
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textLabel.BackgroundTransparency = 0.5
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = true
textLabel.Font = Enum.Font.SourceSansBold
textLabel.Text = "Speed: " .. speedStat.Value
textLabel.Parent = screenGui

-- UI Corner for styling
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = textLabel

-- Update UI when speed changes
speedStat.Changed:Connect(function(newValue)
	textLabel.Text = "Speed: " .. newValue
end)
