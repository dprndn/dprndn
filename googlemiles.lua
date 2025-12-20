-- Configuration
local CARPET_NAME = "Flying Carpet"
local waypoints = {}
local isRunning = true
local isTeleporting = false

-- Services
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- UI Main Construction
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local TopBar = Instance.new("Frame", MainFrame)
local TitleLabel = Instance.new("TextLabel", TopBar) -- The title label
local AddBtn = Instance.new("TextButton", MainFrame)
local NukeBtn = Instance.new("TextButton", TopBar)
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
local UIList = Instance.new("UIListLayout", ScrollFrame)
local Status = Instance.new("TextLabel", MainFrame)

-- Main Frame Styling
MainFrame.Size = UDim2.new(0, 260, 0, 340)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TopBar.BorderSizePixel = 0

-- "adren111" Title
TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)
TitleLabel.Text = "adren111"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.RichText = true -- Ensure symbols display correctly

-- THE BLUE NUKE BUTTON (Text changed back to "X")
NukeBtn.Size = UDim2.new(0, 40, 0, 35)
NukeBtn.Position = UDim2.new(1, -40, 0, 0)
NukeBtn.Text = "X"
NukeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
NukeBtn.TextColor3 = Color3.new(1, 1, 1)
NukeBtn.Font = Enum.Font.SourceSansBold

AddBtn.Size = UDim2.new(0.9, 0, 0, 45)
AddBtn.Position = UDim2.new(0.05, 0, 0, 45)
AddBtn.Text = "ADD POINT (P)"
AddBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 60)
AddBtn.TextColor3 = Color3.new(1, 1, 1)
AddBtn.Font = Enum.Font.SourceSansBold

ScrollFrame.Size = UDim2.new(0.9, 0, 0, 160)
ScrollFrame.Position = UDim2.new(0.05, 0, 0, 100)
ScrollFrame.BackgroundTransparency = 0.9
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.ScrollBarThickness = 4
UIList.Padding = UDim.new(0, 5)

Status.Size = UDim2.new(1, 0, 0, 35)
Status.Position = UDim2.new(0, 0, 0, 270)
Status.Text = "P: Save | F: Run Once | X: Nuke"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

-- Functions
local function updateUIList()
    for _, item in pairs(ScrollFrame:GetChildren()) do
        if item:IsA("Frame") then item:Destroy() end
    end
    for i, _ in ipairs(waypoints) do
        local entry = Instance.new("Frame", ScrollFrame)
        entry.Size = UDim2.new(1, -5, 0, 35)
        entry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        local label = Instance.new("TextLabel", entry)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0.05, 0, 0, 0)
        label.Text = "Waypoint " .. i
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.BackgroundTransparency = 1
        local del = Instance.new("TextButton", entry)
        del.Size = UDim2.new(0, 30, 0, 24)
        del.Position = UDim2.new(1, -35, 0, 3)
        del.Text = "X"
        del.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        del.TextColor3 = Color3.new(1, 1, 1)
        del.MouseButton1Click:Connect(function()
            table.remove(waypoints, i)
            updateUIList()
        end)
    end
end

local function addWaypoint()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        table.insert(waypoints, char.HumanoidRootPart.CFrame)
        updateUIList()
    end
end

local function runSequence()
    if isTeleporting or #waypoints == 0 then return end
    local char = game.Players.LocalPlayer.Character
    if not char:FindFirstChild(CARPET_NAME) then return end
    isTeleporting = true
    for i = 1, #waypoints do
        if not char:FindFirstChild(CARPET_NAME) then break end
        char:PivotTo(waypoints[i])
        task.wait(0.1) 
    end
    isTeleporting = false
end

local function nuke()
    isRunning = false
    ScreenGui:Destroy()
end

AddBtn.MouseButton1Click:Connect(addWaypoint)
NukeBtn.MouseButton1Click:Connect(nuke)

UIS.InputBegan:Connect(function(input, processed)
    if processed or not isRunning then return end
    if input.KeyCode == Enum.KeyCode.P then
        addWaypoint()
    elseif input.KeyCode == Enum.KeyCode.F then
        runSequence()
    elseif input.KeyCode == Enum.KeyCode.X then
        nuke()
    end
end)
