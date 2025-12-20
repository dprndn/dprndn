-- Settings
local CARPET_NAME = "Flying Carpet"
local waypoints = {}
local isRunning = true
local isTeleporting = false -- Safety debounce

-- Services
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- UI Construction
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local AddBtn = Instance.new("TextButton", Frame)
local CloseBtn = Instance.new("TextButton", Frame)
local Status = Instance.new("TextLabel", Frame)

-- Minimalist UI Styling
Frame.Size = UDim2.new(0, 220, 0, 150)
Frame.Position = UDim2.new(0.5, -110, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -25, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.new(1,1,1)

AddBtn.Size = UDim2.new(0.8, 0, 0, 40)
AddBtn.Position = UDim2.new(0.1, 0, 0, 40)
AddBtn.Text = "Add Point (P)"
AddBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 250)
AddBtn.TextColor3 = Color3.new(1,1,1)

Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0, 90)
Status.Text = "P: Add | F: TP Once"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

-- THE ONLY FUNCTION THAT TELEPORTS
local function startOneTimeSequence()
    if isTeleporting or #waypoints == 0 then return end
    
    local char = game.Players.LocalPlayer.Character
    if not char:FindFirstChild(CARPET_NAME) then
        Status.Text = "Hold Carpet + Press F"
        return 
    end

    isTeleporting = true
    Status.Text = "Moving..."

    -- This loop ONLY goes through the list once
    for i = 1, #waypoints do
        if not char:FindFirstChild(CARPET_NAME) then break end -- Stop if carpet dropped
        char:PivotTo(waypoints[i])
        task.wait(0.05) 
    end

    Status.Text = "Done. Press F to redo."
    isTeleporting = false
end

-- Input Listeners
UIS.InputBegan:Connect(function(input, processed)
    if processed or not isRunning then return end
    
    if input.KeyCode == Enum.KeyCode.P then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            table.insert(waypoints, char.HumanoidRootPart.CFrame)
            Status.Text = "Saved Point #" .. #waypoints
        end
    elseif input.KeyCode == Enum.KeyCode.F then
        startOneTimeSequence() -- ONLY runs when F is tapped
    elseif input.KeyCode == Enum.KeyCode.X then
        isRunning = false
        ScreenGui:Destroy()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    isRunning = false
    ScreenGui:Destroy()
end)
