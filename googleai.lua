-- Settings
local CARPET_NAME = "Flying Carpet"
local waypoints = {}
local isRunning = true
local isTeleporting = false

-- Services
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- UI Construction
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local TopBar = Instance.new("Frame", Frame)
local AddBtn = Instance.new("TextButton", Frame)
local CloseBtn = Instance.new("TextButton", TopBar) -- Close button in the corner
local Status = Instance.new("TextLabel", Frame)

-- Frame Styling
Frame.Size = UDim2.new(0, 220, 0, 180)
Frame.Position = UDim2.new(0.5, -110, 0.5, -90)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TopBar.BorderSizePixel = 0

-- UPDATED BLUE CLOSE BUTTON
CloseBtn.Size = UDim2.new(0, 60, 0, 30)
CloseBtn.Position = UDim2.new(1, -60, 0, 0)
CloseBtn.Text = "X CLOSE"
CloseBtn.TextSize = 10
CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Bright Blue
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.SourceSansBold

AddBtn.Size = UDim2.new(0.8, 0, 0, 40)
AddBtn.Position = UDim2.new(0.1, 0, 0, 45)
AddBtn.Text = "Add Point (P)"
AddBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AddBtn.TextColor3 = Color3.new(1,1,1)

Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0, 120)
Status.Text = "P: Add | F: Run Once | X: Exit"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

-- Teleport Logic
local function runOnce()
    if isTeleporting or #waypoints == 0 then return end
    local char = game.Players.LocalPlayer.Character
    if not char:FindFirstChild(CARPET_NAME) then
        Status.Text = "HOLD CARPET TO RUN!"
        return 
    end
    isTeleporting = true
    for i = 1, #waypoints do
        if not char:FindFirstChild(CARPET_NAME) then break end
        char:PivotTo(waypoints[i])
        task.wait(0.05) 
    end
    isTeleporting = false
end

-- Keybinds
UIS.InputBegan:Connect(function(input, processed)
    if processed or not isRunning then return end
    if input.KeyCode == Enum.KeyCode.P then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            table.insert(waypoints, char.HumanoidRootPart.CFrame)
            Status.Text = "Saved Point #" .. #waypoints
        end
    elseif input.KeyCode == Enum.KeyCode.F then
        runOnce()
    elseif input.KeyCode == Enum.KeyCode.X then
        isRunning = false
        ScreenGui:Destroy()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    isRunning = false
    ScreenGui:Destroy()
end)
