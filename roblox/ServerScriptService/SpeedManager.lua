-- ServerScriptService/SpeedManager.lua

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Setup RemoteEvent for trail color changes
-- Setup RemoteEvents
local changeTrailColorEvent = Instance.new("RemoteEvent")
changeTrailColorEvent.Name = "ChangeTrailColor"
changeTrailColorEvent.Parent = ReplicatedStorage

local rebirthRequestEvent = Instance.new("RemoteEvent")
rebirthRequestEvent.Name = "RebirthRequest"
rebirthRequestEvent.Parent = ReplicatedStorage

local playerTrailColors = {} -- Store preferred colors

local function setupPlayer(player)
	-- Create leaderstats
	local leaderstats = player:FindFirstChild("leaderstats") or Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local speedStat = leaderstats:FindFirstChild("Speed") or Instance.new("NumberValue")
	speedStat.Name = "Speed"
	if not speedStat:IsA("NumberValue") then
		speedStat:Destroy()
		speedStat = Instance.new("NumberValue")
		speedStat.Name = "Speed"
	end

	local rebirthsStat = leaderstats:FindFirstChild("Rebirths") or Instance.new("IntValue")
	rebirthsStat.Name = "Rebirths"
	rebirthsStat.Parent = leaderstats

	-- Only set starting value if it's new
	if speedStat.Value == 0 then
		speedStat.Value = 1
	end
	speedStat.Parent = leaderstats

	local function onCharacterAdded(character)
		local humanoid = character:WaitForChild("Humanoid")
		local rootPart = character:WaitForChild("HumanoidRootPart")

		-- Create a Trail for the player
		local trail = Instance.new("Trail")
		trail.Name = "SpeedTrail"
		trail.Enabled = false
		trail.Lifetime = 0.5
		trail.Transparency = NumberSequence.new(0.5, 1)
		trail.WidthScale = NumberSequence.new(1, 0)
		trail.Color = ColorSequence.new(Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 85, 0))

		-- Create attachments for the trail
		local attachment0 = Instance.new("Attachment")
		attachment0.Name = "TrailAttachment0"
		attachment0.Position = Vector3.new(0, 1, 0)
		attachment0.Parent = rootPart

		local attachment1 = Instance.new("Attachment")
		attachment1.Name = "TrailAttachment1"
		attachment1.Position = Vector3.new(0, -1, 0)
		attachment1.Parent = rootPart

		trail.Attachment0 = attachment0
		trail.Attachment1 = attachment1
		trail.Parent = rootPart

		-- Sync initial speed
		humanoid.WalkSpeed = 16 + speedStat.Value

		-- Set preferred color if exists
		if playerTrailColors[player.UserId] then
			trail.Color = playerTrailColors[player.UserId]
		end

		-- Update WalkSpeed when Speed stat changes
		local connection
		connection = speedStat.Changed:Connect(function(newValue)
			if humanoid and humanoid.Parent then
				humanoid.WalkSpeed = 16 + math.floor(newValue)
				trail.Lifetime = 0.5 + (newValue / 1000)
			else
				connection:Disconnect()
			end
		end)

		-- Logic to increase speed when running and toggle trail
		task.spawn(function()
			while character.Parent and humanoid and humanoid.Parent do
				if humanoid.MoveDirection.Magnitude > 0 then
					-- Multiplier: 1.5x per rebirth (1x base if 0 rebirths)
					local multiplier = math.max(1, rebirthsStat.Value * 1.5)
					speedStat.Value = speedStat.Value + multiplier
					trail.Enabled = true
				else
					trail.Enabled = false
				end
				task.wait(1)
			end
		end)
	end

	if player.Character then
		onCharacterAdded(player.Character)
	end
	player.CharacterAdded:Connect(onCharacterAdded)
end

-- Handle players already in the server
for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(setupPlayer, player)
end

-- Handle new players
Players.PlayerAdded:Connect(setupPlayer)

-- Handle rebirth requests
rebirthRequestEvent.OnServerEvent:Connect(function(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then return end

	local speedStat = leaderstats:FindFirstChild("Speed")
	local rebirthsStat = leaderstats:FindFirstChild("Rebirths")
	if not speedStat or not rebirthsStat then return end

	local requirement = (rebirthsStat.Value + 1) * 50

	if speedStat.Value >= requirement then
		-- Apply rebirth
		rebirthsStat.Value = rebirthsStat.Value + 1
		speedStat.Value = 1

		-- Teleport player to spawn (reset character)
		player:LoadCharacter()
	end
end)

-- Handle trail color change requests
changeTrailColorEvent.OnServerEvent:Connect(function(player, color)
	if typeof(color) == "Color3" then
		playerTrailColors[player.UserId] = ColorSequence.new(color)

		-- Update current trail if character exists
		local character = player.Character
		if character then
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			if rootPart then
				local trail = rootPart:FindFirstChild("SpeedTrail")
				if trail then
					trail.Color = ColorSequence.new(color)
				end
			end
		end
	end
end)
