-- Settings
local CARPET_NAME = "Flying Carpet"
local waypoints = {}
local currentIndex = 1
local isRunning = true -- Controls the master loop

-- Services
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- UI Main Components
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local AddBtn = Instance.new("TextButton", Frame)
local CloseBtn = Instance.new("TextButton", Frame)
local ScrollFrame = Instance.new("ScrollingFrame", Frame)
local UIList = Instance.new("UIListLayout", ScrollFrame)
local Status = Instance.new("TextLabel", Frame)

-- Frame Styling
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0.5, -125, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Frame.Active = true
Frame.Draggable = true

-- Close Button Styling (Top Right)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.SourceSansBold

AddBtn.Size = UDim2.new(0.75, 0, 0, 40)
AddBtn.Position = UDim2.new(0.05, 0, 0, 10)
AddBtn.Text = "Add Waypoint (P)"
AddBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
AddBtn.TextColor3 = Color3.new(1,1,1)
AddBtn.Font = Enum.Font.SourceSansBold

ScrollFrame.Size = UDim2.new(0.9, 0, 0, 160)
ScrollFrame.Position = UDim2.new(0.05, 0, 0, 60)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.BackgroundTransparency = 1
UIList.Padding = UDim.new(0, 5)

Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0, 240)
Status.Text = "Add waypoints to begin Auto-TP"
Status.TextColor3 = Color3.new(1, 1, 0)
Status.BackgroundTransparency = 1

-- Logic functions
local function updateList()
    for _, item in pairs(ScrollFrame:GetChildren()) do
        if item:IsA("Frame") then item:Destroy() end
    end
    for i, cf in ipairs(waypoints) do
        local entry = Instance.new("Frame", ScrollFrame)
        entry.Size = UDim2.new(1, 0, 0, 30)
        entry.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        
        local label = Instance.new("TextLabel", entry)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Text = "Waypoint " .. i
        label.TextColor3 = Color3.new(1,1,1)
        label.BackgroundTransparency = 1
        
        local del = Instance.new("TextButton", entry)
        del.Size = UDim2.new(0.2, 0, 0.8, 0)
        del.Position = UDim2.new(0.75, 0, 0.1, 0)
        del.Text = "X"
        del.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
        del.TextColor3 = Color3.new(1,1,1)
        del.MouseButton1Click:Connect(function()
            table.remove(waypoints, i)
            if currentIndex > #waypoints then currentIndex = 1 end
            updateList()
        end)
    end
end

local function addWaypoint()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        table.insert(waypoints, char.HumanoidRootPart.CFrame)
        updateList()
    end
end

-- Close Logic
CloseBtn.MouseButton1Click:Connect(function()
    isRunning = false -- Stop the loop
    ScreenGui:Destroy() -- Remove UI
end)

-- The Auto-Loop
task.spawn(function()
    while isRunning do
        task.wait() 
        
        if #waypoints > 0 then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild(CARPET_NAME) then
                Status.Text = "AUTO-TP ACTIVE (Point " .. currentIndex .. ")"
                Status.TextColor3 = Color3.new(0, 1, 0)
                char:PivotTo(waypoints[currentIndex])
                
                currentIndex = currentIndex + 1
                if currentIndex > #waypoints then
                    currentIndex = 1
                end
            else
                Status.Text = "HOLD CARPET TO START"
                Status.TextColor3 = Color3.new(1, 0.5, 0)
            end
        end
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if processed or not isRunning then return end
    if input.KeyCode == Enum.KeyCode.P then
        addWaypoint()
    end
end)

AddBtn.MouseButton1Click:Connect(addWaypoint)
