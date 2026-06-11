-- ServerScriptService/SpeedManager.lua

local Players = game:GetService("Players")

local function setupPlayer(player)
	-- Create leaderstats
	local leaderstats = player:FindFirstChild("leaderstats") or Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local speedStat = leaderstats:FindFirstChild("Speed") or Instance.new("IntValue")
	speedStat.Name = "Speed"
	if not speedStat:IsA("IntValue") then
		speedStat:Destroy()
		speedStat = Instance.new("IntValue")
		speedStat.Name = "Speed"
	end

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

		-- Update WalkSpeed when Speed stat changes
		local connection
		connection = speedStat.Changed:Connect(function(newValue)
			if humanoid and humanoid.Parent then
				humanoid.WalkSpeed = 16 + newValue
				trail.Lifetime = 0.5 + (newValue / 1000) -- Trail gets longer as player gets faster
			else
				connection:Disconnect()
			end
		end)

		-- Logic to increase speed when running and toggle trail
		task.spawn(function()
			while character.Parent and humanoid and humanoid.Parent do
				if humanoid.MoveDirection.Magnitude > 0 then
					speedStat.Value = speedStat.Value + 1
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
