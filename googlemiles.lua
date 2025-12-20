-- Configuration
local CARPET_NAME = "Flying Carpet"
local FILE_NAME = "adren111_Waypoints.json"
local waypoints = {}
local isRunning = true
local isTeleporting = false

-- Services
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Logic: File Handling (Save/Load to Executor Workspace)
local function saveData()
    local data = {}
    for _, cf in ipairs(waypoints) do
        table.insert(data, {cf.X, cf.Y, cf.Z})
    end
    writefile(FILE_NAME, HttpService:JSONEncode(data))
end

local function loadData()
    if isfile(FILE_NAME) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(FILE_NAME)) end)
        if success then
            waypoints = {}
            for _, pos in ipairs(data) do
                table.insert(waypoints, CFrame.new(pos[1], pos[2], pos[3]))
            end
        end
    end
end

-- UI Construction
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local TopBar = Instance.new("Frame", MainFrame)
local TitleLabel = Instance.new("TextLabel", TopBar)
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

-- UPDATED TITLE: adren111
TitleLabel.Size = UDim2.new(0.6, 0, 1, 0)
TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)
TitleLabel.Text = "adren111"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16

-- BLUE NUKE BUTTON
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

ScrollFrame.Size = UDim2.new(0.9, 0, 0, 160)
ScrollFrame.Position = UDim2.new(0.05, 0, 0, 100)
ScrollFrame.BackgroundTransparency = 0.9
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
UIList.Padding = UDim.new(0, 5)

Status.Size = UDim2.new(1, 0, 0, 35)
Status.Position = UDim2.new(0, 0, 0, 270)
Status.Text = "P: Save | F: Run Once | X: Nuke"
Status.TextColor3 = Color3.new(1, 1, 1)
Status.BackgroundTransparency = 1

-- UI List Update
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
        del.MouseButton1Click:Connect(function()
            table.remove(waypoints, i)
            saveData()
            updateUIList()
        end)
    end
end

local function addWaypoint()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        table.insert(waypoints, char.HumanoidRootPart.CFrame)
        saveData()
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

-- Initialize
loadData()
updateUIList()

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
