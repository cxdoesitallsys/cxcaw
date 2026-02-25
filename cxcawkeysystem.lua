local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "cx.farm"
Junkie.identifier = "1002723"
Junkie.provider = "cx.key"

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

while not Players.LocalPlayer do task.wait() end
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer.UserId or LocalPlayer.UserId == 0 do task.wait() end

local uiParent = LocalPlayer:FindFirstChild("PlayerGui") or CoreGui

pcall(function()
    if CoreGui:FindFirstChild("CX_KEY_SYSTEM") then
        CoreGui.CX_KEY_SYSTEM:Destroy()
    end
end)

local Theme = {
    Background = Color3.fromRGB(20, 20, 20),
    Sidebar = Color3.fromRGB(28, 28, 28),
    Element = Color3.fromRGB(40, 40, 40),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(160, 160, 160),
    Accent = Color3.fromRGB(85, 125, 255),
    Danger = Color3.fromRGB(235, 65, 65),
    Success = Color3.fromRGB(65, 235, 100),
    Stroke = Color3.fromRGB(50, 50, 50)
}

local function hasFileSystemSupport()
    return pcall(function() return type(writefile) == "function" and type(readfile) == "function" end)
end
local fileSystemSupported = hasFileSystemSupport()

local function saveKey(key)
    if not fileSystemSupported then return false end
    return pcall(function() writefile("cx_farm_key.txt", key) end)
end

local function loadKey()
    if not fileSystemSupported then return nil end
    local s, r = pcall(function() return readfile("cx_farm_key.txt") end)
    return s and r or nil
end

local function deleteKey()
    if not fileSystemSupported then return false end
    return pcall(function() delfile("cx_farm_key.txt") end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CX_KEY_SYSTEM"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = uiParent
ScreenGui.DisplayOrder = 105

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
Header.Active = true 
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 10)
HeaderFix.Position = UDim2.new(0, 0, 1, -10)
HeaderFix.BackgroundColor3 = Theme.Sidebar
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

local Title = Instance.new("TextLabel")
Title.Text = "  cx.farm v2 | Authentication"
Title.Size = UDim2.new(1, -20, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Theme.Accent
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
RunService.Heartbeat:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local Desc = Instance.new("TextLabel")
Desc.Text = "Welcome to cx.farm. Please enter your access key below."
Desc.Size = UDim2.new(1, 0, 0, 20)
Desc.Position = UDim2.new(0, 0, 0, 55)
Desc.BackgroundTransparency = 1
Desc.Font = Enum.Font.GothamMedium
Desc.TextColor3 = Theme.SubText
Desc.TextSize = 13
Desc.TextXAlignment = Enum.TextXAlignment.Center
Desc.Parent = MainFrame

local KeyBoxContainer = Instance.new("Frame")
KeyBoxContainer.Size = UDim2.new(1, -40, 0, 40)
KeyBoxContainer.Position = UDim2.new(0, 20, 0, 85)
KeyBoxContainer.BackgroundColor3 = Theme.Element
KeyBoxContainer.Parent = MainFrame
Instance.new("UICorner", KeyBoxContainer).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", KeyBoxContainer).Color = Theme.Stroke

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -20, 1, 0)
KeyBox.Position = UDim2.new(0, 10, 0, 0)
KeyBox.BackgroundTransparency = 1
KeyBox.Text = ""
KeyBox.PlaceholderText = "Paste your cx.farm key here..."
KeyBox.TextColor3 = Theme.Text
KeyBox.PlaceholderColor3 = Theme.SubText
KeyBox.Font = Enum.Font.GothamMedium
KeyBox.TextSize = 13
KeyBox.ClearTextOnFocus = false
KeyBox.TextXAlignment = Enum.TextXAlignment.Left
KeyBox.Parent = KeyBoxContainer

KeyBox.Focused:Connect(function() pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false) end) end)
KeyBox.FocusLost:Connect(function() pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true) end) end)

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0.5, -25, 0, 40)
GetKeyBtn.Position = UDim2.new(0, 20, 0, 140)
GetKeyBtn.BackgroundColor3 = Theme.Element
GetKeyBtn.Text = "Get Key"
GetKeyBtn.TextColor3 = Theme.Text
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 13
GetKeyBtn.Parent = MainFrame
Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", GetKeyBtn).Color = Theme.Stroke

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(0.5, -25, 0, 40)
VerifyBtn.Position = UDim2.new(0.5, 5, 0, 140)
VerifyBtn.BackgroundColor3 = Theme.Accent
VerifyBtn.Text = "Verify Key"
VerifyBtn.TextColor3 = Theme.Text
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.TextSize = 13
VerifyBtn.Parent = MainFrame
Instance.new("UICorner", VerifyBtn).CornerRadius = UDim.new(0, 6)

local StatusLbl = Instance.new("TextLabel")
StatusLbl.Size = UDim2.new(1, 0, 0, 20)
StatusLbl.Position = UDim2.new(0, 0, 1, -25)
StatusLbl.BackgroundTransparency = 1
StatusLbl.Text = "Awaiting input..."
StatusLbl.TextColor3 = Theme.SubText
StatusLbl.Font = Enum.Font.GothamMedium
StatusLbl.TextSize = 12
StatusLbl.Parent = MainFrame

local function UpdateStatus(msg, color)
    StatusLbl.Text = msg
    StatusLbl.TextColor3 = color
end

local function LoadMainScript(junkieResult)
    ScreenGui:Destroy()
    local keyLevel = 1
    if type(junkieResult) == "table" and junkieResult.level then
        keyLevel = tonumber(junkieResult.level) or 1
    end
    
    if keyLevel >= 2 then
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/cxdoesitallsys/cxcaw/refs/heads/main/cxcawprem.lua"))()
        end)
    else
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/cxdoesitallsys/cxcaw/refs/heads/main/cxcaw.lua"))()
        end)
    end
end

GetKeyBtn.MouseButton1Click:Connect(function()
    local link = "https://discord.gg/cxscript" 
    local copyFunc = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
    if copyFunc then
        pcall(function() copyFunc(link) end)
        UpdateStatus("Discord link copied to clipboard!", Theme.Success)
    else
        UpdateStatus("Get key at: " .. link, Theme.Accent)
    end
end)

VerifyBtn.MouseButton1Click:Connect(function()
    local keyInput = KeyBox.Text:gsub("%s+", "")
    if keyInput == "" then
        UpdateStatus("Please enter a key.", Theme.Danger)
        return
    end

    VerifyBtn.Text = "..."
    UpdateStatus("Verifying with Junkie API...", Theme.Accent)
    
    task.spawn(function()
        local result = Junkie.check_key(keyInput)
        
        if result and result.valid then
            saveKey(keyInput)
            local level = tonumber(result.level) or 1
            if level >= 2 then
                UpdateStatus("Premium Authentication Successful!", Theme.Success)
            else
                UpdateStatus("Authentication Successful!", Theme.Success)
            end
            VerifyBtn.BackgroundColor3 = Theme.Success
            VerifyBtn.Text = "Loading Hub..."
            task.wait(1)
            LoadMainScript(result)
        else
            UpdateStatus("Invalid or Expired Key.", Theme.Danger)
            VerifyBtn.BackgroundColor3 = Theme.Accent
            VerifyBtn.Text = "Verify Key"
        end
    end)
end)

task.spawn(function()
    local savedKey = loadKey()
    if savedKey and savedKey ~= "" then
        UpdateStatus("Checking saved key...", Theme.Accent)
        VerifyBtn.Text = "..."
        local result = Junkie.check_key(savedKey)
        if result and result.valid then
            local level = tonumber(result.level) or 1
            if level >= 2 then
                UpdateStatus("Premium Saved Key Authenticated!", Theme.Success)
            else
                UpdateStatus("Saved Key Authenticated!", Theme.Success)
            end
            VerifyBtn.BackgroundColor3 = Theme.Success
            VerifyBtn.Text = "Loading Hub..."
            task.wait(1)
            LoadMainScript(result)
        else
            deleteKey()
            UpdateStatus("Saved key expired. Please enter a new one.", Theme.Danger)
            VerifyBtn.Text = "Verify Key"
        end
    end
end)
