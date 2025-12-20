-- Settings
local CARPET_NAME = "Flying Carpet"
local waypoints = {}
local currentIndex = 1
local isRunning = true

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

-- Main Frame Styling
Frame.Size = UDim2.new(0, 260, 0, 320)
Frame.Position = UDim2.new(0.5, -130, 0.5, -160)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

-- Top Bar
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TopBar.BorderSizePixel = 0

-- Close Button (Click or Press X)
CloseBtn.Size = UDim2.new(0, 80, 0, 35)
CloseBtn.Position = UDim2.new(1, -80, 0, 0)
CloseBtn.Text = "CLOSE (X)"
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.SourceSansBold

AddBtn.Size = UDim2.new(0.9, 0, 0, 45)
AddBtn.Position = UDim2.new(0.05, 0, 0, 45)
AddBtn.Text = "ADD WAYPOINT (P)"
AddBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
AddBtn.TextColor3 = Color3.new(1,1,1)
AddBtn.Font = Enum.Font.SourceSansBold

ScrollFrame.Size = UDim2.new(0.9, 0, 0, 140)
ScrollFrame.Position = UDim2.new(0.05, 0, 0, 100)
ScrollFrame.BackgroundTransparency = 0.9
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
UIList.Padding = UDim.new(0, 5)

Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0, 260)
Status.Text = "P to Add | X to Exit"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

-- Function to Destroy Script
local function shutdown()
    isRunning = false
    ScreenGui:Destroy()
end

local function updateList()
    for _, item in pairs(ScrollFrame:GetChildren()) do
        if item:IsA("Frame") then item:Destroy() end
    end
    for i, cf in ipairs(waypoints) do
        local entry = Instance.new("Frame", ScrollFrame)
        entry.Size = UDim2.new(1, 0, 0, 35)
        entry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        local label = Instance.new("TextLabel", entry)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Text = "Point " .. i
        label.TextColor3 = Color3.new(1,1,1)
        label.BackgroundTransparency = 1
        
        local del = Instance.new("TextButton", entry)
        del.Size = UDim2.new(0, 30, 0, 30)
        del.Position = UDim2.new(1, -35, 0, 2.5)
        del.Text = "X"
        del.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        del.MouseButton1Click:Connect(function()
            table.remove(waypoints, i)
            updateList()
        end)
    end
end

-- Input Handling (P to add, X to close)
UIS.InputBegan:Connect(function(input, processed)
    if processed or not isRunning then return end
    
    if input.KeyCode == Enum.KeyCode.P then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            table.insert(waypoints, char.HumanoidRootPart.CFrame)
            updateList()
        end
    elseif input.KeyCode == Enum.KeyCode.X then
        shutdown()
    end
end)

CloseBtn.MouseButton1Click:Connect(shutdown)

-- Auto-TP Loop
task.spawn(function()
    while isRunning do
        task.wait(0.05) -- Very fast TP
        if #waypoints > 0 then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild(CARPET_NAME) then
                char:PivotTo(waypoints[currentIndex])
                currentIndex = (currentIndex % #waypoints) + 1
                Status.Text = "LOOPING..."
                Status.TextColor3 = Color3.new(0, 1, 0)
            else
                Status.Text = "HOLD CARPET"
                Status.TextColor3 = Color3.new(1, 0.5, 0)
            end
        end
    end
end)
