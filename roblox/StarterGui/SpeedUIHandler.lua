-- StarterGui/SpeedGui.lua
-- Note: In Roblox Studio, place this inside a LocalScript inside a ScreenGui in StarterGui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local changeTrailColorEvent = ReplicatedStorage:WaitForChild("ChangeTrailColor")
local rebirthRequestEvent = ReplicatedStorage:WaitForChild("RebirthRequest")

-- Better waiting for leaderstats and Stats
local leaderstats = player:WaitForChild("leaderstats", 10)
if not leaderstats then
	warn("SpeedUIHandler: Timed out waiting for leaderstats")
	return
end

local speedStat = leaderstats:WaitForChild("Speed", 10)
local rebirthsStat = leaderstats:WaitForChild("Rebirths", 10)

if not speedStat or not rebirthsStat then
	warn("SpeedUIHandler: Timed out waiting for stats")
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
textLabel.Text = "⚡ SPEED: " .. math.floor(speedStat.Value)
textLabel.Parent = container

local uiStroke = textLabel:FindFirstChildWhichIsA("UIStroke") or Instance.new("UIStroke")
uiStroke.Thickness = 2.5
uiStroke.Transparency = 0.2
uiStroke.Color = Color3.fromRGB(0, 0, 0)
uiStroke.Parent = textLabel

-- Market Data
local TRAILS = {
	{name = "Orange (Default)", color = Color3.fromRGB(255, 85, 0), cost = 0},
	{name = "Blue Bolt", color = Color3.fromRGB(0, 170, 255), cost = 100},
	{name = "Green Ghost", color = Color3.fromRGB(85, 255, 127), cost = 500},
	{name = "Purple Power", color = Color3.fromRGB(170, 0, 255), cost = 1000},
	{name = "Red Rush", color = Color3.fromRGB(255, 0, 0), cost = 2500},
}

-- Effect: +Lightning Pop-up
local function createLightningPopUp()
	local multiplier = math.max(1, rebirthsStat.Value * 1.5)

	local popUp = Instance.new("TextLabel")
	popUp.Name = "PopUp"
	popUp.Size = UDim2.new(0, 60, 0, 60)
	-- Randomize position near the center top
	local randomX = 0.5 + (math.random(-12, 12) / 100)
	local randomY = 0.1 + (math.random(-5, 5) / 100)
	popUp.Position = UDim2.new(randomX, 0, randomY, 0)
	popUp.BackgroundTransparency = 1
	popUp.Text = "+" .. multiplier .. " ⚡"
	popUp.TextColor3 = Color3.fromRGB(255, 255, 0)
	popUp.TextScaled = true
	popUp.Font = Enum.Font.FredokaOne
	popUp.Parent = screenGui

	local uiStroke = Instance.new("UIStroke")
	uiStroke.Thickness = 2
	uiStroke.Parent = popUp

	local moveUp = TweenService:Create(popUp, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = popUp.Position - UDim2.new(0, 0, 0.05, 0),
		TextTransparency = 1
	})

	moveUp:Play()
	moveUp.Completed:Connect(function()
		popUp:Destroy()
	end)
end

-- Side Buttons
local function createSideButton(name, text, color, pos)
	local btn = screenGui:FindFirstChild(name) or Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 100, 0, 40)
	btn.Position = pos
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.FredokaOne
	btn.TextScaled = true
	btn.Parent = screenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Parent = btn

	return btn
end

local marketBtn = createSideButton("MarketBtn", "MARKET", Color3.fromRGB(0, 170, 255), UDim2.new(0, 20, 0.5, -45))
local rebirthBtn = createSideButton("RebirthBtn", "REBIRTH", Color3.fromRGB(170, 0, 255), UDim2.new(0, 20, 0.5, 5))

-- Market UI
local marketFrame = screenGui:FindFirstChild("MarketFrame") or Instance.new("Frame")
marketFrame.Name = "MarketFrame"
marketFrame.Size = UDim2.new(0, 300, 0, 400)
marketFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
marketFrame.AnchorPoint = Vector2.new(0.5, 0.5)
marketFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
marketFrame.Visible = false
marketFrame.Parent = screenGui

local marketCorner = Instance.new("UICorner")
marketCorner.CornerRadius = UDim.new(0, 15)
marketCorner.Parent = marketFrame

local marketTitle = Instance.new("TextLabel")
marketTitle.Size = UDim2.new(1, 0, 0, 50)
marketTitle.BackgroundTransparency = 1
marketTitle.Text = "TRAIL SHOP"
marketTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
marketTitle.Font = Enum.Font.FredokaOne
marketTitle.TextSize = 24
marketTitle.Parent = marketFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.FredokaOne
closeBtn.Parent = marketFrame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 5)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -70)
scroll.Position = UDim2.new(0, 10, 0, 60)
scroll.BackgroundTransparency = 1
scroll.CanvasSize = UDim2.new(0, 0, 0, #TRAILS * 60)
scroll.ScrollBarThickness = 5
scroll.Parent = marketFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.Parent = scroll

for _, data in ipairs(TRAILS) do
	local item = Instance.new("Frame")
	item.Size = UDim2.new(1, -10, 0, 50)
	item.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	item.Parent = scroll
	Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0.6, 0, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = data.name .. "\n(Req: " .. data.cost .. ")"
	title.TextColor3 = data.color
	title.Font = Enum.Font.FredokaOne
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = item

	local buyBtn = Instance.new("TextButton")
	buyBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
	buyBtn.Position = UDim2.new(0.65, 0, 0.15, 0)
	buyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	buyBtn.Text = "EQUIP"
	buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyBtn.Font = Enum.Font.FredokaOne
	buyBtn.TextScaled = true
	buyBtn.Parent = item
	Instance.new("UICorner", buyBtn).CornerRadius = UDim.new(0, 5)

	buyBtn.MouseButton1Click:Connect(function()
		if speedStat.Value >= data.cost then
			changeTrailColorEvent:FireServer(data.color)
			marketFrame.Visible = false
		else
			buyBtn.Text = "LOCKED"
			task.wait(1)
			buyBtn.Text = "EQUIP"
		end
	end)
end

-- Rebirth UI
local rebirthFrame = screenGui:FindFirstChild("RebirthFrame") or Instance.new("Frame")
rebirthFrame.Name = "RebirthFrame"
rebirthFrame.Size = UDim2.new(0, 300, 0, 250)
rebirthFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
rebirthFrame.AnchorPoint = Vector2.new(0.5, 0.5)
rebirthFrame.BackgroundColor3 = Color3.fromRGB(85, 0, 127) -- Purple
rebirthFrame.Visible = false
rebirthFrame.Parent = screenGui

Instance.new("UICorner", rebirthFrame).CornerRadius = UDim.new(0, 15)

local rebirthTitle = Instance.new("TextLabel")
rebirthTitle.Size = UDim2.new(1, 0, 0, 50)
rebirthTitle.BackgroundTransparency = 1
rebirthTitle.Text = "REBIRTH"
rebirthTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
rebirthTitle.Font = Enum.Font.FredokaOne
rebirthTitle.TextSize = 28
rebirthTitle.Parent = rebirthFrame

local rebirthInfo = Instance.new("TextLabel")
rebirthInfo.Size = UDim2.new(1, -20, 0, 80)
rebirthInfo.Position = UDim2.new(0, 10, 0, 60)
rebirthInfo.BackgroundTransparency = 1
rebirthInfo.Text = "Reset stats for 1.5x Multiplier!\nCost: 50 Speed"
rebirthInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
rebirthInfo.Font = Enum.Font.FredokaOne
rebirthInfo.TextSize = 18
rebirthInfo.Parent = rebirthFrame

local confirmRebirthBtn = Instance.new("TextButton")
confirmRebirthBtn.Size = UDim2.new(0, 200, 0, 50)
confirmRebirthBtn.Position = UDim2.new(0.5, -100, 0, 160)
confirmRebirthBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
confirmRebirthBtn.Text = "REBIRTH!"
confirmRebirthBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmRebirthBtn.Font = Enum.Font.FredokaOne
confirmRebirthBtn.TextSize = 24
confirmRebirthBtn.Parent = rebirthFrame
Instance.new("UICorner", confirmRebirthBtn).CornerRadius = UDim.new(0, 10)

local closeRebirthBtn = Instance.new("TextButton")
closeRebirthBtn.Size = UDim2.new(0, 30, 0, 30)
closeRebirthBtn.Position = UDim2.new(1, -35, 0, 5)
closeRebirthBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeRebirthBtn.Text = "X"
closeRebirthBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeRebirthBtn.Font = Enum.Font.FredokaOne
closeRebirthBtn.Parent = rebirthFrame
Instance.new("UICorner", closeRebirthBtn).CornerRadius = UDim.new(0, 5)

local function updateRebirthUI()
	local req = (rebirthsStat.Value + 1) * 50
	local mult = (rebirthsStat.Value + 1) * 1.5
	rebirthInfo.Text = "Reset stats for " .. mult .. "x Multiplier!\nCost: " .. req .. " Speed"

	if speedStat.Value >= req then
		confirmRebirthBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
	else
		confirmRebirthBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	end
end

-- Toggle Panels
marketBtn.MouseButton1Click:Connect(function()
	marketFrame.Visible = not marketFrame.Visible
	rebirthFrame.Visible = false
end)

rebirthBtn.MouseButton1Click:Connect(function()
	rebirthFrame.Visible = not rebirthFrame.Visible
	marketFrame.Visible = false
	if rebirthFrame.Visible then
		updateRebirthUI()
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	marketFrame.Visible = false
end)

closeRebirthBtn.MouseButton1Click:Connect(function()
	rebirthFrame.Visible = false
end)

confirmRebirthBtn.MouseButton1Click:Connect(function()
	local req = (rebirthsStat.Value + 1) * 50
	if speedStat.Value >= req then
		rebirthRequestEvent:FireServer()
		rebirthFrame.Visible = false
	else
		confirmRebirthBtn.Text = "NOT ENOUGH SPEED"
		task.wait(1)
		confirmRebirthBtn.Text = "REBIRTH!"
	end
end)

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
	textLabel.Text = "⚡ SPEED: " .. math.floor(newValue)
	pulseUI()
	createLightningPopUp()
	if rebirthFrame.Visible then
		updateRebirthUI()
	end
end)

rebirthsStat.Changed:Connect(function()
	if rebirthFrame.Visible then
		updateRebirthUI()
	end
end)
