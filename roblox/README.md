# How to Test the Roblox Running Game

Follow these steps to set up the game in Roblox Studio:

## 1. Create a New Baseplate
- Open Roblox Studio and create a new project using the **Baseplate** template.

## 2. Set up the Speed Manager (Server Script)
1. In the **Explorer** window, find **ServerScriptService**.
2. Right-click **ServerScriptService**, hover over **Insert Object**, and select **Script**.
3. Name the script `SpeedManager`.
4. Copy the content from `roblox/ServerScriptService/SpeedManager.lua` and paste it into this new script.

## 3. Set up the Speed UI (Local Script)
1. In the **Explorer** window, find **StarterGui**.
2. Right-click **StarterGui**, hover over **Insert Object**, and select **ScreenGui**.
3. Name the ScreenGui `SpeedGui`.
4. Right-click the new `SpeedGui`, hover over **Insert Object**, and select **LocalScript**.
5. Name the LocalScript `SpeedUIHandler`.
6. Copy the content from `roblox/StarterGui/SpeedUIHandler.lua` and paste it into this new LocalScript.

## 4. Run the Game
1. Click the **Play** button (or press `F5`) in Roblox Studio.
2. Your character should spawn with a "Speed" stat of 1 in the leaderboard.
3. Start running! You should see your Speed increase every second in the top-middle UI and in the leaderboard.
4. Notice that as your Speed stat increases, your character's physical movement speed also increases.

## Troubleshooting
- If the UI doesn't appear, make sure the `SpeedUIHandler` is a **LocalScript** inside a **ScreenGui** inside **StarterGui**.
- If the speed doesn't increase, check the **Output** window (View -> Output) for any errors.
