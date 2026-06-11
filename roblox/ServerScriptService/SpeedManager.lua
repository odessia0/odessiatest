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

		-- Sync initial speed
		humanoid.WalkSpeed = 16 + speedStat.Value

		-- Update WalkSpeed when Speed stat changes
		local connection
		connection = speedStat.Changed:Connect(function(newValue)
			if humanoid and humanoid.Parent then
				humanoid.WalkSpeed = 16 + newValue
			else
				connection:Disconnect()
			end
		end)

		-- Logic to increase speed when running
		task.spawn(function()
			while character.Parent and humanoid and humanoid.Parent do
				if humanoid.MoveDirection.Magnitude > 0 then
					speedStat.Value = speedStat.Value + 1
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
