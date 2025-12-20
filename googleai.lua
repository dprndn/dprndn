-- Settings
local CARPET_NAME = "Flying Carpet"
local waypoints = {}
local currentIndex = 1

-- Service Setup
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- UI Main Components
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
local AddBtn = Instance.new("TextButton", Frame)
local ScrollFrame = Instance.new("ScrollingFrame", Frame)
local UIList = Instance.new("UIListLayout", ScrollFrame)
local Status = Instance.new("TextLabel", Frame)

-- Frame Styling
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0.5, -125, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Active = true
Frame.Draggable = true

AddBtn.Size = UDim2.new(0.9, 0, 0, 40)
AddBtn.Position = UDim2.new(0.05, 0, 0, 10)
AddBtn.Text = "Add Waypoint (P)"
AddBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
AddBtn.TextColor3 = Color3.new(1,1,1)

ScrollFrame.Size = UDim2.new(0.9, 0, 0, 180)
ScrollFrame.Position = UDim2.new(0.05, 0, 0, 60)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.BackgroundTransparency = 1

UIList.Padding = UDim.new(0, 5)

Status.Size = UDim2.new(1, 0, 0, 40)
Status.Position = UDim2.new(0, 0, 0, 250)
Status.Text = "F to Teleport | P to Save"
Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
Status.BackgroundTransparency = 1

-- Functions
local function updateList()
    -- Clear current visual list
    for _, item in pairs(ScrollFrame:GetChildren()) do
        if item:IsA("Frame") then item:Destroy() end
    end
    
    -- Rebuild list from waypoints table
    for i, cf in ipairs(waypoints) do
        local entry = Instance.new("Frame", ScrollFrame)
        entry.Size = UDim2.new(1, 0, 0, 30)
        entry.BackgroundTransparency = 0.8
        
        local label = Instance.new("TextLabel", entry)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Text = "Waypoint " .. i
        label.TextColor3 = Color3.new(1,1,1)
        label.BackgroundTransparency = 1
        
        local del = Instance.new("TextButton", entry)
        del.Size = UDim2.new(0.2, 0, 0.8, 0)
        del.Position = UDim2.new(0.75, 0, 0.1, 0)
        del.Text = "X"
        del.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        del.MouseButton1Click:Connect(function()
            table.remove(waypoints, i)
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

local function teleportNext()
    local char = game.Players.LocalPlayer.Character
    if #waypoints == 0 then return end
    
    if not char:FindFirstChild(CARPET_NAME) then
        Status.Text = "HOLD CARPET TO RUN!"
        return
    end

    char:PivotTo(waypoints[currentIndex])
    currentIndex = (currentIndex % #waypoints) + 1
    Status.Text = "At Waypoint #" .. (currentIndex == 1 and #waypoints or currentIndex-1)
end

-- Input Listeners
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.P then
        addWaypoint()
    elseif input.KeyCode == Enum.KeyCode.F then
        teleportNext()
    end
end)

AddBtn.MouseButton1Click:Connect(addWaypoint)
