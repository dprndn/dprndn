-- Settings
local CARPET_NAME = "Flying Carpet"
local waypoints = {}
local isRunning = true
local isTeleporting = false

-- Services
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- UI Main Components
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local TopBar = Instance.new("Frame", Frame)
local AddBtn = Instance.new("TextButton", Frame)
local CloseBtn = Instance.new("TextButton", TopBar)
local ScrollFrame = Instance.new("ScrollingFrame", Frame)
local UIList = Instance.new("UIListLayout", ScrollFrame)
local Status = Instance.new("TextLabel", Frame)

-- Frame Styling
Frame.Size = UDim2.new(0, 250, 0, 320)
Frame.Position = UDim2.new(0.5, -125, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TopBar.BorderSizePixel = 0

-- BLUE NUKE BUTTON
CloseBtn.Size = UDim2.new(0, 70, 0, 35)
CloseBtn.Position = UDim2.new(1, -70, 0, 0)
CloseBtn.Text = "X NUKE"
CloseBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.SourceSansBold

AddBtn.Size = UDim2.new(0.9, 0, 0, 40)
AddBtn.Position = UDim2.new(0.05, 0, 0, 45)
AddBtn.Text = "Add Waypoint (P)"
AddBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
AddBtn.TextColor3 = Color3.new(1,1,1)

-- SCROLLING LIST FIX (AutomaticCanvasSize)
ScrollFrame.Size = UDim2.new(0.9, 0, 0, 130)
ScrollFrame.Position = UDim2.new(0.05, 0, 0, 95)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y -- Crucial fix
UIList.Padding = UDim.new(0, 5)

Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0, 260)
Status.Text = "P: Add | F: TP Sequence | X: Nuke"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

-- Logic functions
local function updateList()
    -- Clear current display
    for _, item in pairs(ScrollFrame:GetChildren()) do
        if item:IsA("Frame") then item:Destroy() end
    end
    -- Rebuild from waypoints table
    for i, _ in ipairs(waypoints) do
        local entry = Instance.new("Frame", ScrollFrame)
        entry.Size = UDim2.new(1, -10, 0, 30) -- Adjusted for scrollbar
        entry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        local label = Instance.new("TextLabel", entry)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Text = "Point " .. i
        label.TextColor3 = Color3.new(1,1,1)
        label.BackgroundTransparency = 1
        
        local del = Instance.new("TextButton", entry)
        del.Size = UDim2.new(0, 30, 0, 24)
        del.Position = UDim2.new(1, -35, 0, 3)
        del.Text = "X"
        del.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        del.MouseButton1Click:Connect(function()
            table.remove(waypoints, i)
            updateList()
        end)
    end
end

-- Teleport Sequence
local function runSequence()
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
        task.wait(0.1) 
    end
    isTeleporting = false
    Status.Text = "F: TP Again | X: Nuke"
end

-- Keybinds
UIS.InputBegan:Connect(function(input, processed)
    if processed or not isRunning then return end
    if input.KeyCode == Enum.KeyCode.P then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            table.insert(waypoints, char.HumanoidRootPart.CFrame)
            updateList()
        end
    elseif input.KeyCode == Enum.KeyCode.F then
        runSequence()
    elseif input.KeyCode == Enum.KeyCode.X then
        isRunning = false
        ScreenGui:Destroy()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    isRunning = false
    ScreenGui:Destroy()
end)
