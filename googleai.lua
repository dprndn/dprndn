-- Configuration
local CARPET_NAME = "Flying Carpet"
local waypoints = {}
local isRunning = true
local isTeleporting = false

-- Services
local UIS = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- UI Construction
local ScreenGui = Instance.new("ScreenGui", CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local TopBar = Instance.new("Frame", MainFrame)
local AddBtn = Instance.new("TextButton", MainFrame)
local NukeBtn = Instance.new("TextButton", TopBar) -- Blue Corner Button
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
local UIList = Instance.new("UIListLayout", ScrollFrame)
local Status = Instance.new("TextLabel", MainFrame)

-- Styling
MainFrame.Size = UDim2.new(0, 250, 0, 320)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Active = true
MainFrame.Draggable = true

TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TopBar.BorderSizePixel = 0

NukeBtn.Size = UDim2.new(0, 80, 0, 35)
NukeBtn.Position = UDim2.new(1, -80, 0, 0)
NukeBtn.Text = "X NUKE"
NukeBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255) -- Bright Blue
NukeBtn.TextColor3 = Color3.new(1, 1, 1)
NukeBtn.Font = Enum.Font.SourceSansBold

AddBtn.Size = UDim2.new(0.9, 0, 0, 45)
AddBtn.Position = UDim2.new(0.05, 0, 0, 45)
AddBtn.Text = "ADD POINT (P)"
AddBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 60)
AddBtn.TextColor3 = Color3.new(1, 1, 1)

ScrollFrame.Size = UDim2.new(0.9, 0, 0, 140)
ScrollFrame.Position = UDim2.new(0.05, 0, 0, 100)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
UIList.Padding = UDim.new(0, 5)

Status.Size = UDim2.new(1, 0, 0, 35)
Status.Position = UDim2.new(0, 0, 0, 260)
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
        entry.Size = UDim2.new(1, 0, 0, 35)
        entry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        
        local label = Instance.new("TextLabel", entry)
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Text = "Point " .. i
        label.TextColor3 = Color3.new(1, 1, 1)
        label.BackgroundTransparency = 1
        
        local del = Instance.new("TextButton", entry)
        del.Size = UDim2.new(0, 30, 0, 30)
        del.Position = UDim2.new(1, -35, 0, 2.5)
        del.Text = "X"
        del.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        del.MouseButton1Click:Connect(function()
            table.remove(waypoints, i)
            updateUIList()
        end)
    end
end

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
    Status.Text = "Done! Press F to retry."
end

-- Keybinds & Nuke
UIS.InputBegan:Connect(function(input, processed)
    if processed or not isRunning then return end
    if input.KeyCode == Enum.KeyCode.P then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            table.insert(waypoints, char.HumanoidRootPart.CFrame)
            updateUIList()
        end
    elseif input.KeyCode == Enum.KeyCode.F then
        runOnce()
    elseif input.KeyCode == Enum.KeyCode.X then
        isRunning = false
        ScreenGui:Destroy()
    end
end)

NukeBtn.MouseButton1Click:Connect(function()
    isRunning = false
    ScreenGui:Destroy()
end)
