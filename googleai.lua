-- Settings
local CARPET_NAME = "Flying Carpet" -- Change to match your specific carpet name
local waypoints = {}
local isRunning = true
local tpDebounce = false -- Prevents the script from starting twice at once

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

-- UI Styling
Frame.Size = UDim2.new(0, 260, 0, 320)
Frame.Position = UDim2.new(0.5, -130, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TopBar.BorderSizePixel = 0

CloseBtn.Size = UDim2.new(0, 80, 0, 35)
CloseBtn.Position = UDim2.new(1, -80, 0, 0)
CloseBtn.Text = "CLOSE (X)"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.SourceSansBold

AddBtn.Size = UDim2.new(0.9, 0, 0, 45)
AddBtn.Position = UDim2.new(0.05, 0, 0, 45)
AddBtn.Text = "ADD WAYPOINT (P)"
AddBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
AddBtn.TextColor3 = Color3.new(1,1,1)

ScrollFrame.Size = UDim2.new(0.9, 0, 0, 140)
ScrollFrame.Position = UDim2.new(0.05, 0, 0, 100)
ScrollFrame.BackgroundTransparency = 0.9
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
UIList.Padding = UDim.new(0, 5)

Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0, 260)
Status.Text = "P: Add | F: TP Sequence | X: Exit"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

-- Logic Functions
local function updateList()
    for _, item in pairs(ScrollFrame:GetChildren()) do
        if item:IsA("Frame") then item:Destroy() end
    end
    for i, _ in ipairs(waypoints) do
        local entry = Instance.new("Frame", ScrollFrame)
        entry.Size = UDim2.new(1, 0, 0, 35)
        entry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        local label = Instance.new("TextLabel", entry)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "Point " .. i
        label.TextColor3 = Color3.new(1,1,1)
        label.BackgroundTransparency = 1
    end
end

-- Teleport Sequence (Runs ONLY once per press)
local function runOneTimeSequence()
    local char = game.Players.LocalPlayer.Character
    
    -- Check if already running or no waypoints
    if tpDebounce or #waypoints == 0 then return end
    
    -- Check if holding carpet
    if not char or not char:FindFirstChild(CARPET_NAME) then
        Status.Text = "HOLD CARPET TO RUN!"
        Status.TextColor3 = Color3.new(1, 0, 0)
        return
    end

    tpDebounce = true -- Start debounce
    Status.Text = "Sequence Started..."
    Status.TextColor3 = Color3.new(0, 1, 0)

    -- Teleport through list one time
    for i = 1, #waypoints do
        -- Continuous check: stop if carpet is unequipped mid-sequence
        if not char:FindFirstChild(CARPET_NAME) then
            Status.Text = "PAUSED: CARPET DROPPED"
            break 
        end
        
        char:PivotTo(waypoints[i])
        task.wait(0.05) -- Speed of teleport between points
    end

    Status.Text = "Sequence Finished!"
    Status.TextColor3 = Color3.new(1, 1, 1)
    tpDebounce = false -- Reset debounce so it can be run again
end

-- Input Bindings
UIS.InputBegan:Connect(function(input, processed)
    if processed or not isRunning then return end
    
    if input.KeyCode == Enum.KeyCode.P then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            table.insert(waypoints, char.HumanoidRootPart.CFrame)
            updateList()
            Status.Text = "Added Waypoint #" .. #waypoints
        end
    elseif input.KeyCode == Enum.KeyCode.F then
        runOneTimeSequence()
    elseif input.KeyCode == Enum.KeyCode.X then
        isRunning = false
        ScreenGui:Destroy()
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    isRunning = false
    ScreenGui:Destroy()
end)
