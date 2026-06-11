-- ServerScriptService/SpeedManager.lua

local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(player)
	-- Create leaderstats
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local speedStat = Instance.new("IntValue")
	speedStat.Name = "Speed"
	speedStat.Value = 1 -- Starting speed
	speedStat.Parent = leaderstats

	player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")

		-- Sync initial speed
		humanoid.WalkSpeed = 16 + speedStat.Value -- Base speed + stat

		-- Update WalkSpeed when Speed stat changes
		speedStat.Changed:Connect(function(newValue)
			if humanoid and humanoid.Parent then
				humanoid.WalkSpeed = 16 + newValue
			end
		end)

		-- Logic to increase speed when running
		task.spawn(function()
			while character.Parent do
				if humanoid.MoveDirection.Magnitude > 0 then
					speedStat.Value = speedStat.Value + 1
				end
				task.wait(1) -- Increase speed every second while moving
			end
		end)
	end)
end)
