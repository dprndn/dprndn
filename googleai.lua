-- Configuration
local CARPET_NAME = "Flying Carpet" -- The exact name of the carpet tool
local waypoints = {}

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
local Title = Instance.new("TextLabel", MainFrame)
local SaveBtn = Instance.new("TextButton", MainFrame)
local TeleBtn = Instance.new("TextButton", MainFrame)
local Status = Instance.new("TextLabel", MainFrame)

-- Modern Dark Styling
MainFrame.Size = UDim2.new(0, 200, 0, 180)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Allows you to move the menu around

Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Carpet Teleport"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold

SaveBtn.Size = UDim2.new(0.8, 0, 0, 35)
SaveBtn.Position = UDim2.new(0.1, 0, 0, 50)
SaveBtn.Text = "Save Waypoint"
SaveBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 60)

TeleBtn.Size = UDim2.new(0.8, 0, 0, 35)
TeleBtn.Position = UDim2.new(0.1, 0, 0, 95)
TeleBtn.Text = "Teleport to Waypoint"
TeleBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 220)

Status.Size = UDim2.new(1, 0, 0, 30)
Status.Position = UDim2.new(0, 0, 0, 140)
Status.Text = "No Waypoint Saved"
Status.TextColor3 = Color3.new(0.8, 0.8, 0.8)
Status.BackgroundTransparency = 1

-- Logic Functions
SaveBtn.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        waypoints["Last"] = char.HumanoidRootPart.CFrame
        Status.Text = "Waypoint Saved!"
        Status.TextColor3 = Color3.new(0, 1, 0)
    end
end)

TeleBtn.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if not char:FindFirstChild(CARPET_NAME) then
        Status.Text = "Hold Carpet First!"
        Status.TextColor3 = Color3.new(1, 0, 0)
        return
    end

    if waypoints["Last"] then
        char:PivotTo(waypoints["Last"]) -- Modern teleport method
        Status.Text = "Teleported!"
        Status.TextColor3 = Color3.new(0, 1, 1)
    else
        Status.Text = "Save a spot first!"
    end
end)
