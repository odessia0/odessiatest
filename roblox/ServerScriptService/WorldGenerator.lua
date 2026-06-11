-- ServerScriptService/WorldGenerator.lua
-- This script generates a grass terrain and some trees when the server starts.

local Terrain = workspace.Terrain

local FIELD_SIZE = 500 -- Studs
local HEIGHT_SCALE = 10 -- Max height variation
local TREE_COUNT = 20

local function generateTerrain()
	print("Generating grass field...")

	-- Clear existing terrain (optional, use with caution)
	-- Terrain:Clear()

	-- Create a large grass field with some noise for "little heights"
	local resolution = 4
	for x = -FIELD_SIZE/2, FIELD_SIZE/2, resolution do
		for z = -FIELD_SIZE/2, FIELD_SIZE/2, resolution do
			-- Use noise to create gentle hills
			local height = math.noise(x/50, z/50) * HEIGHT_SCALE

			local position = Vector3.new(x, height, z)
			local size = Vector3.new(resolution, resolution, resolution)

			Terrain:FillBlock(CFrame.new(position), size, Enum.Material.Grass)
		end
		-- Yield occasionally to prevent script timeout for large areas
		if x % 20 == 0 then task.wait() end
	end
	print("Terrain generation complete.")
end

local function createTree(position)
	local model = Instance.new("Model")
	model.Name = "Tree"

	-- Trunk
	local trunk = Instance.new("Part")
	trunk.Name = "Trunk"
	trunk.Size = Vector3.new(2, 10, 2)
	trunk.Position = position + Vector3.new(0, 5, 0)
	trunk.BrickColor = BrickColor.new("Brown")
	trunk.Material = Enum.Material.Wood
	trunk.Anchored = true
	trunk.Parent = model

	-- Leaves
	local leaves = Instance.new("Part")
	leaves.Name = "Leaves"
	leaves.Shape = Enum.PartType.Ball
	leaves.Size = Vector3.new(8, 8, 8)
	leaves.Position = trunk.Position + Vector3.new(0, 7, 0)
	leaves.BrickColor = BrickColor.new("Dark green")
	leaves.Material = Enum.Material.Grass
	leaves.Anchored = true
	leaves.Parent = model

	model.Parent = workspace
end

local function generateTrees()
	print("Planting trees...")
	local random = Random.new()

	for i = 1, TREE_COUNT do
		local x = random:NextNumber(-FIELD_SIZE/2 + 20, FIELD_SIZE/2 - 20)
		local z = random:NextNumber(-FIELD_SIZE/2 + 20, FIELD_SIZE/2 - 20)

		-- Find the surface height at this position
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		local result = workspace:Raycast(Vector3.new(x, 100, z), Vector3.new(0, -200, 0))
		if result then
			createTree(result.Position)
		end
	end
	print("Tree planting complete.")
end

-- Run generation
task.spawn(function()
	generateTerrain()
	generateTrees()
end)
