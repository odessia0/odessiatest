# How to Test the Roblox Running Game

Follow these steps to set up the game in Roblox Studio:

## 1. Create a New Baseplate
- Open Roblox Studio and create a new project using the **Baseplate** template.

## 2. Set up the Speed Manager (Server Script)
1. In the **Explorer** window, find **ServerScriptService**.
2. Right-click **ServerScriptService**, hover over **Insert Object**, and select **Script**.
3. Name the script `SpeedManager`.
4. Copy the content from `roblox/ServerScriptService/SpeedManager.lua` and paste it into this new script.
5. Create another script in **ServerScriptService** and name it `WorldGenerator`.
6. Copy the content from `roblox/ServerScriptService/WorldGenerator.lua` and paste it into the `WorldGenerator` script.

## 3. Set up the Speed UI (Local Script)
1. In the **Explorer** window, find **StarterGui**.
2. Right-click **StarterGui**, hover over **Insert Object**, and select **LocalScript**.
3. Name the LocalScript `SpeedUIHandler`.
4. Copy the content from `roblox/StarterGui/SpeedUIHandler.lua` and paste it into this new LocalScript.
*(Note: This script will automatically create a ScreenGui if it's placed directly in StarterGui, or you can place it inside a ScreenGui you've created.)*

## 4. Run the Game
1. Click the **Play** button (or press `F5`) in Roblox Studio.
2. Your character should spawn with a "Speed" stat of 1 in the leaderboard.
3. Start running! You should see your Speed increase every second in the top-middle UI and in the leaderboard.
4. Notice that as your Speed stat increases, your character's physical movement speed also increases.

## Troubleshooting
- If the UI doesn't appear, make sure the `SpeedUIHandler` is a **LocalScript** inside a **ScreenGui** inside **StarterGui**.
- If the speed doesn't increase, check the **Output** window (View -> Output) for any errors.
