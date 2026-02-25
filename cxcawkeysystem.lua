-- // cx.farm DEBUG Loader //
-- Use this to fix Premium/Free detection

local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "cx.farm"
Junkie.identifier = "1002723"
Junkie.provider = "cx.key"

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

while not Players.LocalPlayer do task.wait() end
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer.UserId or LocalPlayer.UserId == 0 do task.wait() end

local uiParent = LocalPlayer:FindFirstChild("PlayerGui") or CoreGui

pcall(function() if CoreGui:FindFirstChild("CX_KEY_SYSTEM") then CoreGui.CX_KEY_SYSTEM:Destroy() end end)

local Theme = {
    Background = Color3.fromRGB(20, 20, 20), Sidebar = Color3.fromRGB(28, 28, 28), Element = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(160, 160, 160), Accent = Color3.fromRGB(255, 170, 0), -- Orange for Debug
    Danger = Color3.fromRGB(235, 65, 65), Success = Color3.fromRGB(65, 235, 100), Stroke = Color3.fromRGB(50, 50, 50)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CX_KEY_SYSTEM"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = uiParent

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 220)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -110)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Theme.Stroke
MainStroke.Thickness = 1.5

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Theme.Sidebar
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Text = "  cx.farm DEBUGGER"
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Theme.Accent
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -40, 0, 30)
KeyBox.Position = UDim2.new(0, 20, 0, 85)
KeyBox.BackgroundColor3 = Theme.Element
KeyBox.Text = ""
KeyBox.PlaceholderText = "Paste Premium Key Here"
KeyBox.TextColor3 = Theme.Text
KeyBox.Font = Enum.Font.GothamMedium
KeyBox.TextSize = 13
KeyBox.Parent = MainFrame
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 6)

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(1, -40, 0, 40)
VerifyBtn.Position = UDim2.new(0, 20, 0, 140)
VerifyBtn.BackgroundColor3 = Theme.Accent
VerifyBtn.Text = "Check Key Level"
VerifyBtn.TextColor3 = Theme.Background
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 13
VerifyBtn.Parent = MainFrame
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(1, 0, 0, 20)
StatusLbl.Position = UDim2.new(0, 0, 1, -25)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "Open F9 Console after clicking..."
StatusLbl.TextColor3 = Theme.SubText
StatusLbl.Font = Enum.Font.GothamMedium
StatusLbl.TextSize = 12
StatusLbl.Parent = MainFrame

VerifyBtn.MouseButton1Click:Connect(function()
    local keyInput = KeyBox.Text:gsub("%s+", "")
    StatusLbl.Text = "Checking Junkie API..."
    
    task.spawn(function()
        local result = Junkie.check_key(keyInput)
        
        print("\n[CX DEBUG] FULL JUNKIE RESPONSE:")
        if type(result) == "table" then
            for k, v in pairs(result) do
                print(">> " .. tostring(k) .. ": " .. tostring(v))
            end
        else
            print(">> Result is not a table! It is: " .. tostring(result))
        end
        print("--------------------------------\n")
        
        if result and result.valid then
            -- Attempt to find the level
            local level = result.level or result.key_level or result.tier or "N/A"
            StatusLbl.Text = "VALID! Detected Level: " .. tostring(level)
            StatusLbl.TextColor3 = Theme.Success
            
            if tonumber(level) and tonumber(level) >= 2 then
                print("[CX DEBUG] ROUTING -> PREMIUM SCRIPT")
            else
                print("[CX DEBUG] ROUTING -> FREE SCRIPT")
            end
        else
            StatusLbl.Text = "Invalid Key"
            StatusLbl.TextColor3 = Theme.Danger
        end
    end)
end)
