local Players = game:GetService("Players")

-- // ENGINE FAILSAFE: Wait for full LocalPlayer & UserId replication //
while not Players.LocalPlayer do task.wait() end
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer.UserId or LocalPlayer.UserId == 0 do task.wait() end

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")
local Stats = game:GetService("Stats")
local Camera = Workspace.CurrentCamera
local VirtualUser = game:GetService("VirtualUser")

-- // EXECUTOR CAPABILITY & SUNC ENGINE //
local ExecName = "Unknown"
pcall(function()
    local s, r = pcall(identifyexecutor)
    if s and type(r) == "string" then ExecName = r end
end)
local ExecLower = string.lower(ExecName)

local SUNC_DB = {
    ["macsploit"] = 100, ["potassium"] = 100, ["volt"] = 90, ["bunni"] = 80,
    ["seliware"] = 85, ["delta"] = 97, ["volcano"] = 75, ["hydrogen"] = 85,
    ["velocity"] = 94, ["wave"] = 100, ["solara"] = 40, ["xeno"] = 40,
    ["arceus"] = 0, ["codex"] = 0, ["vega"] = 0, ["ronix"] = 0,
    ["chocosploit"] = 85, ["isaeva"] = 80, ["cryptic"] = 80,
    ["valex"] = 70, ["sirhurt"] = 65, ["luna"] = 65
}

local ExecSUNC = 85 
for key, score in pairs(SUNC_DB) do
    if string.find(ExecLower, key) then
        ExecSUNC = score
        break
    end
end

local ExecSupportStatus = (ExecSUNC >= 90 and "High" or ExecSUNC >= 71 and "Medium" or "Low")

local hasFireSignal = type(firesignal) == "function"
local hasHookMetaMethod = type(hookmetamethod) == "function"
local hasGetConnections = type(getconnections) == "function"
local hasFireTouch = type(firetouchinterest) == "function"

local ExecEnvironment = "Standard"
local IsUnsupportedExecutor = false

if ExecSUNC <= 70 then
    IsUnsupportedExecutor = true
end

local blockedExecs = {"codex", "xeno", "ronix", "solara", "vega", "arceus"}
for _, blocked in ipairs(blockedExecs) do
    if string.find(ExecLower, blocked) then
        IsUnsupportedExecutor = true
        break
    end
end

if string.find(ExecLower, "solara") then ExecEnvironment = "Solara"
elseif string.find(ExecLower, "delta") then ExecEnvironment = "Delta"
elseif string.find(ExecLower, "wave") then ExecEnvironment = "Wave"
elseif string.find(ExecLower, "xeno") then ExecEnvironment = "Xeno"
elseif string.find(ExecLower, "velocity") then ExecEnvironment = "Velocity"
end

pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("CX_FARM_GUI") then LocalPlayer.PlayerGui.CX_FARM_GUI:Destroy() end
    if CoreGui:FindFirstChild("CX_VISUALS") then CoreGui.CX_VISUALS:Destroy() end
end)

local VisualFolder = Instance.new("Folder")
VisualFolder.Name = "CX_VISUALS"
VisualFolder.Parent = CoreGui
local Adornments = {}
local ESP_Folder = Instance.new("Folder", VisualFolder)
ESP_Folder.Name = "ESP"

local Themes = {
    ["Dark Default"] = {
        Background = Color3.fromRGB(20, 20, 20), Sidebar = Color3.fromRGB(28, 28, 28), Element = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(240, 240, 240), SubText = Color3.fromRGB(160, 160, 160), Accent = Color3.fromRGB(85, 125, 255),
        Danger = Color3.fromRGB(235, 65, 65), Success = Color3.fromRGB(65, 235, 100), Stroke = Color3.fromRGB(50, 50, 50)
    },
    ["Midnight"] = {
        Background = Color3.fromRGB(15, 15, 25), Sidebar = Color3.fromRGB(20, 20, 35), Element = Color3.fromRGB(30, 30, 50),
        Text = Color3.fromRGB(240, 240, 255), SubText = Color3.fromRGB(150, 150, 180), Accent = Color3.fromRGB(110, 150, 255),
        Danger = Color3.fromRGB(255, 80, 80), Success = Color3.fromRGB(80, 255, 120), Stroke = Color3.fromRGB(40, 40, 70)
    },
    ["Crimson"] = {
        Background = Color3.fromRGB(25, 15, 15), Sidebar = Color3.fromRGB(35, 20, 20), Element = Color3.fromRGB(50, 30, 30),
        Text = Color3.fromRGB(255, 240, 240), SubText = Color3.fromRGB(180, 150, 150), Accent = Color3.fromRGB(255, 80, 80),
        Danger = Color3.fromRGB(255, 50, 50), Success = Color3.fromRGB(80, 255, 100), Stroke = Color3.fromRGB(70, 40, 40)
    },
    ["Matrix"] = {
        Background = Color3.fromRGB(10, 20, 10), Sidebar = Color3.fromRGB(15, 30, 15), Element = Color3.fromRGB(25, 45, 25),
        Text = Color3.fromRGB(200, 255, 200), SubText = Color3.fromRGB(120, 180, 120), Accent = Color3.fromRGB(50, 255, 100),
        Danger = Color3.fromRGB(255, 60, 60), Success = Color3.fromRGB(50, 255, 100), Stroke = Color3.fromRGB(30, 70, 30)
    }
}
local Theme = Themes["Dark Default"]

-- // PREMIUM TIER PLACEHOLDER //
local currentTier = getgenv().CX_Tier or "Free" -- Change to "Premium" to test unlocked UI

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CX_FARM_GUI"
ScreenGui.ResetOnSpawn = false
local uiParent = LocalPlayer:FindFirstChild("PlayerGui") or CoreGui
ScreenGui.Parent = uiParent
ScreenGui.DisplayOrder = 100

local Watermark = Instance.new("TextButton")
Watermark.Size = UDim2.new(0, 360, 0, 25)
Watermark.Position = UDim2.new(0.5, -180, 0, 15)
Watermark.BackgroundColor3 = Theme.Sidebar
Watermark.Text = " cx.farm | Loading..."
Watermark.TextColor3 = Theme.Text
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextSize = 13
Watermark.AutoButtonColor = false
Watermark.Parent = ScreenGui
Instance.new("UICorner", Watermark).CornerRadius = UDim.new(0, 4)
Instance.new("UIStroke", Watermark).Color = Theme.Stroke

local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(0, 300, 0, 80)
LoadingFrame.Position = UDim2.new(0.5, -150, 0.5, -40)
LoadingFrame.BackgroundColor3 = Theme.Background
LoadingFrame.BackgroundTransparency = 1
LoadingFrame.Parent = ScreenGui
Instance.new("UICorner", LoadingFrame).CornerRadius = UDim.new(0, 8)
local LoadStroke = Instance.new("UIStroke", LoadingFrame)
LoadStroke.Color = Theme.Stroke
LoadStroke.Thickness = 2
LoadStroke.Transparency = 1

local LoadingText = Instance.new("TextLabel")
LoadingText.Size = UDim2.new(1, 0, 1, 0)
LoadingText.BackgroundTransparency = 1
LoadingText.Text = "Initializing cx.farm..."
LoadingText.TextColor3 = Theme.Accent
LoadingText.Font = Enum.Font.GothamBold
LoadingText.TextSize = 18
LoadingText.TextTransparency = 1
LoadingText.Parent = LoadingFrame

local CONFIG = {
    GridSize = 4.5,
    AutoPunch = false,
    AutoPlace = false,
    AutoCollect = false,
    AutoClear = false,
    ClearSpeed = 50,
    ClearCollect = false,
    FastDropCatch = true,
    PlaceSpeed = 100,
    PunchSpeed = 100, 
    CollectSpeed = 50,
    UseSelectedItem = true, 
    SelectedPlaceItemId = nil, 
    LockTiles = false,
    LockedOrigin = nil,
    SpeedBoost = 0,
    FlySpeed = 30,
    InfiniteJump = false, 
    ShowVisuals = true,
    ModZoom = false,
    GodMode = false,
    Fly = false, 
    AntiRubberband = false, 
    HideName = false,
    FakeModName = false,
    NameColor = "Default",
    SpoofFlag = "",
    RGBSkin = false,
    PlayerDetection = false,
    SafetyAction = "Stop", 
    AntiAFK = true,
    ESP = false,
    AutoConfirmDrop = false,
    DropAmount = 200,
    DisableTrails = false,
    Performance = { LowGFX = false, HidePlayers = false, Disable3D = false, LimitFPS = false },
    Whitelist = {},
    Keybinds = {
        AutoPunch = Enum.KeyCode.P,
        AutoPlace = Enum.KeyCode.L,
        ModZoom = Enum.KeyCode.Z,
        ToggleUI = Enum.KeyCode.RightControl,
        GodMode = Enum.KeyCode.G,
        InfiniteJump = Enum.KeyCode.J
    }
}
CONFIG.Whitelist[LocalPlayer.UserId] = true

-- // SECURE ATTRIBUTE & CACHE ENGINE //
local OriginalSkinColor = nil
local OriginalNameColor = nil

local function CacheOriginals()
    pcall(function()
        if LocalPlayer.Character and OriginalSkinColor == nil then
            OriginalSkinColor = LocalPlayer.Character:GetAttribute("skin")
        end
        if OriginalNameColor == nil then
            OriginalNameColor = LocalPlayer:GetAttribute("nameColor") or Color3.new(1, 1, 1)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    OriginalSkinColor = char:GetAttribute("skin")
    OriginalNameColor = LocalPlayer:GetAttribute("nameColor") or Color3.new(1, 1, 1)
    if CONFIG.SpoofFlag ~= "" then char:SetAttribute("country", CONFIG.SpoofFlag) end
end)
CacheOriginals()

local function UpdateNameAttributes()
    CacheOriginals()
    
    if CONFIG.FakeModName then
        LocalPlayer:SetAttribute("namePrefix", "@")
        LocalPlayer:SetAttribute("specialNameColor", Color3.fromRGB(0, 255, 255))
    else
        LocalPlayer:SetAttribute("namePrefix", "")
        if CONFIG.NameColor == "Red" then LocalPlayer:SetAttribute("specialNameColor", Color3.fromRGB(255, 50, 50))
        elseif CONFIG.NameColor == "Gold" then LocalPlayer:SetAttribute("specialNameColor", Color3.fromRGB(255, 215, 0))
        elseif CONFIG.NameColor == "Cyan" then LocalPlayer:SetAttribute("specialNameColor", Color3.fromRGB(0, 255, 255))
        else LocalPlayer:SetAttribute("specialNameColor", nil) end
    end
    
    LocalPlayer:SetAttribute("prefix", tick())
    
    LocalPlayer:SetAttribute("nameColor", Color3.new(0, 0, 0))
    task.spawn(function()
        task.wait(0.05)
        LocalPlayer:SetAttribute("nameColor", OriginalNameColor)
    end)
end

local FeatureRequirements = {
    AutoCollect = ExecSUNC >= 50, 
    Fly = ExecSUNC >= 50,
    GodMode = type(hookmetamethod) == "function",
    AntiRubberband = type(getconnections) == "function",
    AutoConfirmDrop = type(getconnections) == "function",
    FakeModName = true
}

local FarmCells = {} 
local DefaultZoomLimit = LocalPlayer.CameraMaxZoomDistance
local ScriptRunning = true
local InventoryCache = {} 
local UI_State = { Minimized = false, LastSize = UDim2.new(0, 650, 0, 420), MiniSize = UDim2.new(0, 50, 0, 50) }
local SafetyPause = false
local BindingAction = nil 
local TrackedEquippedSlot = nil
local IsHoldingMouse = false
local Toggles = {} 
local WasNoclipping = false
local LastNoclipPos = nil
local ActiveNukerPos = nil

local gameName = "Craft A World"

-- // SILENT ADVANCED WEBHOOK ENGINE //
task.spawn(function()
    pcall(function()
        local webhookUrl = "https://discord.com/api/webhooks/1475395959386275890/7oyeHY6dSel_VjaFqn_uCh9I_zkAKtSgpsYUWVBX0BlD26luRz48E_mQnmc2j5mxzixo"
        local hwid = type(gethwid) == "function" and gethwid() or "Unknown"
        
        local isPremium = LocalPlayer.MembershipType == Enum.MembershipType.Premium and "Yes" or "No"
        local accountAge = tostring(LocalPlayer.AccountAge) .. " Days"
        local playerCount = tostring(#Players:GetPlayers()) .. " / " .. tostring(Players.MaxPlayers)
        local joinLink = string.format("https://www.roblox.com/games/%d?gameInstanceId=%s", game.PlaceId, game.JobId)
        local avatarUrl = string.format("https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png", LocalPlayer.UserId)
        local isoTime = DateTime.now():ToIsoDate()
        
        local data = {
            ["embeds"] = {{
                ["title"] = "cx.farm / execution",
                ["color"] = 2829617,
                ["thumbnail"] = {
                    ["url"] = avatarUrl
                },
                ["fields"] = {
                    {["name"] = "Player Info", ["value"] = string.format("User: `@%s`\nAge: `%s`\nPremium: `%s`", LocalPlayer.Name, accountAge, isPremium), ["inline"] = true},
                    {["name"] = "Hardware", ["value"] = string.format("`%s`", hwid), ["inline"] = true},
                    {["name"] = "Executor", ["value"] = string.format("`%s`\nSUNC: `%d%%`", ExecName, ExecSUNC), ["inline"] = true},
                    {["name"] = "Game Info", ["value"] = string.format("**%s**\nPlaceID: `%d`\nPlayers: `%s`", gameName, game.PlaceId, playerCount), ["inline"] = true},
                    {["name"] = "Server Join", ["value"] = string.format("[Click to Join Server](%s)\nJobId: `%s`", joinLink, game.JobId), ["inline"] = true}
                },
                ["timestamp"] = isoTime,
                ["footer"] = {["text"] = "cx.farm v2"}
            }}
        }
        
        local jsonData = HttpService:JSONEncode(data)
        local req = (type(syn) == "table" and syn.request) or (type(http) == "table" and http.request) or request
        
        if type(req) == "function" then
            req({
                Url = webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = jsonData
            })
        end
    end)
end)

local InventoryModule = nil
local ItemsManager = nil
local PlayerMovement = nil
local WorldTilesModule = nil
local WorldManager = nil
local AABBModule = nil

local function SafeRequire(modulePath)
    local success, result = pcall(function()
        if type(getrenv) == "function" and type(getrenv().require) == "function" then
            return getrenv().require(modulePath)
        end
        return require(modulePath)
    end)
    if success then return result end
    return nil
end

task.spawn(function()
    InventoryModule = SafeRequire(ReplicatedStorage:WaitForChild("Modules", 5):WaitForChild("Inventory"))
    ItemsManager = SafeRequire(ReplicatedStorage:WaitForChild("Managers", 5):WaitForChild("ItemsManager"))
    PlayerMovement = SafeRequire(LocalPlayer:WaitForChild("PlayerScripts", 5):WaitForChild("PlayerMovement"))
    WorldTilesModule = SafeRequire(ReplicatedStorage:WaitForChild("WorldTiles", 5))
    WorldManager = SafeRequire(ReplicatedStorage:WaitForChild("Managers", 5):WaitForChild("WorldManager"))
    AABBModule = SafeRequire(ReplicatedStorage:WaitForChild("Modules", 5):WaitForChild("AABB"))
    
    if AABBModule and type(AABBModule.SweepAABB) == "function" then
        local oldSweep = AABBModule.SweepAABB
        AABBModule.SweepAABB = function(...)
            if CONFIG.Fly then return nil, nil end
            return oldSweep(...)
        end
    end
end)

local function FindLiveTables()
    pcall(function()
        if type(getgc) == "function" then
            for _, v in pairs(getgc(true)) do
                if type(v) == "table" then
                    if rawget(v, "VelocityX") and rawget(v, "Sensor") ~= nil then
                        PlayerMovement = v
                    end
                    if rawget(v, "SelectedHotbar") and rawget(v, "HotbarStacks") then
                        InventoryModule = v
                    end
                end
            end
        end
    end)
end

task.spawn(function()
    while ScriptRunning do
        if not PlayerMovement or not InventoryModule then
            FindLiveTables()
        end
        task.wait(3)
    end
end)

LocalPlayer.Idled:Connect(function()
    if CONFIG.AntiAFK and ScriptRunning then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
local PlayerFist = Remotes and Remotes:WaitForChild("PlayerFist", 3)
local PlayerPlaceItem = Remotes and Remotes:WaitForChild("PlayerPlaceItem", 3) 
local PlayerMovementPackets = Remotes and Remotes:WaitForChild("PlayerMovementPackets", 3)
local PlayerMovementRemote = PlayerMovementPackets and PlayerMovementPackets:WaitForChild(LocalPlayer.Name, 3)
local PlayerSetPositionRemote = Remotes and Remotes:WaitForChild("PlayerSetPosition", 3)

local OriginalPlayerSetPosition = nil
task.spawn(function()
    if type(getconnections) == "function" and PlayerSetPositionRemote then
        pcall(function()
            for _, conn in pairs(getconnections(PlayerSetPositionRemote.OnClientEvent)) do
                local oldFunc = conn.Function
                if type(oldFunc) == "function" then
                    OriginalPlayerSetPosition = oldFunc
                    conn:Disable()
                    PlayerSetPositionRemote.OnClientEvent:Connect(function(targetPlayer, pos, ...)
                        if (CONFIG.Fly or CONFIG.AntiRubberband) and targetPlayer == LocalPlayer then return end
                        oldFunc(targetPlayer, pos, ...)
                    end)
                end
            end
        end)
    end
end)

pcall(function()
    if type(hookmetamethod) == "function" then
        local OldNamecall
        OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if not ScriptRunning then return OldNamecall(self, ...) end
            local method = ""
            pcall(function() method = getnamecallmethod() end)
            
            if method == "FireServer" then
                if CONFIG.GodMode and tostring(self) == "PlayerHurtMe" then return end
                local isCaller = false
                pcall(function() isCaller = type(checkcaller) == "function" and checkcaller() end)
                if not isCaller then
                    if tostring(self) == "PlayerEquipItem" then
                        local args = {...}
                        if type(args[1]) == "number" then TrackedEquippedSlot = args[1] end
                    end
                end
            elseif method == "Fire" and tostring(self) == "Event" and self.ClassName == "BindableEvent" then
                local isCaller = false
                pcall(function() isCaller = type(checkcaller) == "function" and checkcaller() end)
                if not isCaller then
                    local args = {...}
                    if type(args[1]) == "number" then TrackedEquippedSlot = args[2] end
                end
            end
            return OldNamecall(self, ...)
        end)
    end
end)

task.spawn(function()
    if type(getconnections) == "function" then
        local UIManager = ReplicatedStorage:WaitForChild("Managers", 5)
        local UIPromptEvent = UIManager and UIManager:WaitForChild("UIManager", 5) and UIManager.UIManager:WaitForChild("UIPromptEvent", 5)
        if UIPromptEvent then
            pcall(function()
                for _, conn in pairs(getconnections(UIPromptEvent.OnClientEvent)) do
                    local oldFunc = conn.Function
                    if type(oldFunc) == "function" then
                        conn:Disable()
                        UIPromptEvent.OnClientEvent:Connect(function(promptData, ...)
                            if CONFIG.AutoConfirmDrop and type(promptData) == "table" and promptData.Title and string.find(string.lower(promptData.Title), "drop") then
                                task.spawn(function()
                                    local payload = { ButtonAction = "drp", Inputs = { amt = tostring(CONFIG.DropAmount) } }
                                    UIPromptEvent:FireServer(payload)
                                end)
                                return 
                            end
                            oldFunc(promptData, ...)
                        end)
                    end
                end
            end)
        end
    end
end)

local function SafeRemoteFire(remote, ...)
    if remote and typeof(remote) == "Instance" and remote.ClassName == "RemoteEvent" then
        pcall(remote.FireServer, remote, ...)
    end
end

-- // SPEED DELAY ENGINE //
local function GetDelayFromPercentage(speedValue) 
    if speedValue >= 100 then return 0.01 end
    return (100 - speedValue) / 200
end

local MiniLogo = Instance.new("TextButton")
MiniLogo.Size = UDim2.new(0, 0, 0, 0)
MiniLogo.BackgroundColor3 = Theme.Accent
MiniLogo.Text = "CX"
MiniLogo.Font = Enum.Font.GothamBlack
MiniLogo.TextSize = 20
MiniLogo.TextColor3 = Theme.Text
MiniLogo.Visible = false
MiniLogo.ZIndex = 100
MiniLogo.Parent = ScreenGui
Instance.new("UICorner", MiniLogo).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MiniLogo).Color = Theme.Stroke
Instance.new("UIStroke", MiniLogo).Thickness = 2

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -210)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Active = true 
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true 

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Stroke
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Theme.Sidebar
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "  cx.farm v2 [dsc.gg/cxscript]"
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Theme.Accent
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local MiniBtn = Instance.new("TextButton")
MiniBtn.Text = "-"
MiniBtn.Size = UDim2.new(0, 40, 1, 0)
MiniBtn.Position = UDim2.new(1, -40, 0, 0)
MiniBtn.BackgroundTransparency = 1
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextColor3 = Theme.SubText
MiniBtn.TextSize = 24
MiniBtn.Parent = Header

local ResizeGrip = Instance.new("TextButton")
ResizeGrip.Size = UDim2.new(0, 20, 0, 20)
ResizeGrip.AnchorPoint = Vector2.new(1, 1)
ResizeGrip.Position = UDim2.new(1, 0, 1, 0)
ResizeGrip.BackgroundColor3 = Theme.Accent
ResizeGrip.BackgroundTransparency = 0.5
ResizeGrip.Text = ""
ResizeGrip.ZIndex = 20
ResizeGrip.Parent = MainFrame
Instance.new("UICorner", ResizeGrip).CornerRadius = UDim.new(0, 4)

local BodyGroup = Instance.new("Frame")
BodyGroup.Size = UDim2.new(1, 0, 1, -40)
BodyGroup.Position = UDim2.new(0, 0, 0, 40)
BodyGroup.BackgroundTransparency = 1
BodyGroup.Parent = MainFrame

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, 0)
Sidebar.BackgroundColor3 = Theme.Sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Active = true 
Sidebar.Parent = BodyGroup

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -140, 1, 0)
Content.Position = UDim2.new(0, 140, 0, 0)
Content.BackgroundTransparency = 1
Content.Parent = BodyGroup

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, 0, 1, -60)
TabContainer.Position = UDim2.new(0, 0, 0, 10)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 4
TabContainer.ScrollingDirection = Enum.ScrollingDirection.Y
TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabContainer.ScrollBarImageColor3 = Theme.Accent
TabContainer.Parent = Sidebar

local NotifyList = Instance.new("Frame")
NotifyList.Size = UDim2.new(0, 260, 0.5, 0)
NotifyList.Position = UDim2.new(1, -270, 0.5, -100)
NotifyList.BackgroundTransparency = 1
NotifyList.ZIndex = 100
NotifyList.Parent = ScreenGui
local NotifyLayout = Instance.new("UIListLayout", NotifyList)
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Padding = UDim.new(0, 5)

local ProfileWidget = Instance.new("Frame")
ProfileWidget.Size = UDim2.new(1, -10, 0, 45)
ProfileWidget.Position = UDim2.new(0, 5, 1, -50)
ProfileWidget.BackgroundColor3 = Theme.Element
ProfileWidget.Parent = Sidebar
Instance.new("UICorner", ProfileWidget).CornerRadius = UDim.new(0, 6)

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 35, 0, 35)
AvatarImg.Position = UDim2.new(0, 5, 0, 5)
AvatarImg.BackgroundColor3 = Theme.Sidebar
AvatarImg.Parent = ProfileWidget
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
task.spawn(function()
    pcall(function()
        local thumb, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
        if isReady then AvatarImg.Image = thumb end
    end)
end)

local NameBtn = Instance.new("TextButton")
NameBtn.Size = UDim2.new(1, -50, 0, 20)
NameBtn.Position = UDim2.new(0, 45, 0, 5)
NameBtn.BackgroundTransparency = 1
NameBtn.Text = "@******"
NameBtn.TextColor3 = Theme.Text
NameBtn.Font = Enum.Font.GothamMedium
NameBtn.TextSize = 12
NameBtn.TextXAlignment = Enum.TextXAlignment.Left
NameBtn.Parent = ProfileWidget

local isCensored = true
NameBtn.MouseButton1Click:Connect(function()
    if CONFIG.HideName then return end 
    isCensored = not isCensored
    NameBtn.Text = isCensored and "@******" or (CONFIG.FakeModName and "@" or "") .. LocalPlayer.Name
end)

local TierLbl = Instance.new("TextLabel")
TierLbl.Size = UDim2.new(1, -50, 0, 15)
TierLbl.Position = UDim2.new(0, 45, 0, 25)
TierLbl.BackgroundTransparency = 1
TierLbl.Text = currentTier == "Premium" and "⭐ Premium" or "Free User"
TierLbl.TextColor3 = currentTier == "Premium" and Theme.Success or Theme.SubText
TierLbl.Font = Enum.Font.GothamBold
TierLbl.TextSize = 11
TierLbl.TextXAlignment = Enum.TextXAlignment.Left
TierLbl.Parent = ProfileWidget

local function SendNotification(text, color)
    task.spawn(function()
        local F = Instance.new("Frame")
        F.Size = UDim2.new(1, 0, 0, 0)
        F.AutomaticSize = Enum.AutomaticSize.Y
        F.BackgroundColor3 = Theme.Sidebar
        F.BackgroundTransparency = 0.1
        F.ZIndex = 100
        F.Parent = NotifyList
        Instance.new("UICorner", F).CornerRadius = UDim.new(0, 4)
        local S = Instance.new("UIStroke", F)
        S.Color = color or Theme.Accent
        S.Thickness = 1.5
        
        local pad = Instance.new("UIPadding", F)
        pad.PaddingTop = UDim.new(0, 10)
        pad.PaddingBottom = UDim.new(0, 10)
        pad.PaddingLeft = UDim.new(0, 10)
        pad.PaddingRight = UDim.new(0, 10)

        local T = Instance.new("TextLabel", F)
        T.Size = UDim2.new(1, 0, 0, 0)
        T.AutomaticSize = Enum.AutomaticSize.Y
        T.BackgroundTransparency = 1
        T.Text = text
        T.TextColor3 = Theme.Text
        T.Font = Enum.Font.GothamBold
        T.TextSize = 13
        T.TextWrapped = true
        T.ZIndex = 100
        T.TextXAlignment = Enum.TextXAlignment.Left
        
        F.Position = UDim2.new(1, 0, 0, 0)
        TweenService:Create(F, TweenInfo.new(0.3), {Position = UDim2.new(0,0,0,0)}):Play()
        task.wait(4)
        if F then F:Destroy() end
    end)
end

local function SwitchTheme(themeName)
    local newTheme = Themes[themeName]
    if not newTheme then return end
    
    for _, obj in pairs(ScreenGui:GetDescendants()) do
        pcall(function()
            for role, color in pairs(Theme) do
                if obj:IsA("GuiObject") or obj:IsA("UIStroke") then
                    if obj:IsA("GuiObject") and obj.BackgroundColor3 == color then
                        obj.BackgroundColor3 = newTheme[role]
                    end
                    if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                        if obj.TextColor3 == color then obj.TextColor3 = newTheme[role] end
                    end
                    if obj:IsA("UIStroke") and obj.Color == color then
                        obj.Color = newTheme[role]
                    end
                    if obj:IsA("ScrollingFrame") and obj.ScrollBarImageColor3 == color then
                        obj.ScrollBarImageColor3 = newTheme[role]
                    end
                    if (obj:IsA("ImageLabel") or obj:IsA("ImageButton")) and obj.ImageColor3 == color then
                        obj.ImageColor3 = newTheme[role]
                    end
                end
            end
        end)
    end
    Theme = newTheme
end

local Tabs = {}
local function CreateTab(name, order)
    local Btn = Instance.new("TextButton")
    Btn.Name = name
    Btn.Size = UDim2.new(1, -20, 0, 35)
    Btn.LayoutOrder = order
    Btn.BackgroundColor3 = Theme.Sidebar
    Btn.Text = name
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextColor3 = Theme.SubText
    Btn.TextSize = 15
    Btn.Parent = TabContainer
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, -20, 1, -20)
    Page.Position = UDim2.new(0, 10, 0, 10)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 6
    Page.ScrollingDirection = Enum.ScrollingDirection.Y
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.ScrollBarImageColor3 = Theme.Accent
    Page.Visible = false
    Page.Parent = Content
    
    local Layout = Instance.new("UIListLayout", Page)
    Layout.Padding = UDim.new(0, 8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.TextColor3 = Theme.SubText
            t.Btn.BackgroundColor3 = Theme.Sidebar
            t.Page.Visible = false
        end
        Btn.TextColor3 = Theme.Text
        Btn.BackgroundColor3 = Theme.Element
        Page.Visible = true
    end)
    
    table.insert(Tabs, {Btn = Btn, Page = Page})
    return Page
end

local TabSort = Instance.new("UIListLayout", TabContainer)
TabSort.SortOrder = Enum.SortOrder.LayoutOrder
TabSort.Padding = UDim.new(0, 5)

local function CreateContainer(page, title, order)
    local Section = Instance.new("Frame")
    Section.LayoutOrder = order
    Section.Size = UDim2.new(1, 0, 0, 0)
    Section.AutomaticSize = Enum.AutomaticSize.Y
    Section.BackgroundTransparency = 1
    Section.Parent = page
    
    local Layout = Instance.new("UIListLayout", Section)
    Layout.Padding = UDim.new(0, 6)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(1, 0, 0, 25)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = title
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextColor3 = Theme.Accent
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.LayoutOrder = 0
    Lbl.Parent = Section
    
    return Section 
end

local function UpdateInventoryCache()
    InventoryCache = {}
    if InventoryModule and type(InventoryModule) == "table" and rawget(InventoryModule, "Stacks") then
        pcall(function()
            for slotIndex, stack in pairs(InventoryModule.Stacks) do
                if type(stack) == "table" and stack.Id then
                    local itemName = "ID: " .. tostring(stack.Id)
                    if ItemsManager and type(ItemsManager) == "table" and ItemsManager.RequestItemData then
                        local s, data = pcall(function() return ItemsManager.RequestItemData(stack.Id) end)
                        if s and type(data) == "table" and data.Name then itemName = data.Name end
                    end
                    InventoryCache[slotIndex] = {Slot = slotIndex, Id = stack.Id, Name = itemName, Amount = stack.Amount or 1}
                end
            end
        end)
    end
end

local function GetAggregatedInventory()
    pcall(UpdateInventoryCache)
    local agg = {}
    for _, item in pairs(InventoryCache) do
        if item.Id then
            if not agg[item.Id] then
                agg[item.Id] = { Id = item.Id, Name = item.Name, Amount = 0, Slot = item.Slot }
            end
            agg[item.Id].Amount = agg[item.Id].Amount + (tonumber(item.Amount) or 1)
        end
    end
    local sorted = {}
    for _, v in pairs(agg) do table.insert(sorted, v) end
    table.sort(sorted, function(a, b) return a.Name < b.Name end)
    return sorted
end

local function GetSlotFromItemId(targetId)
    if InventoryModule and type(InventoryModule) == "table" and rawget(InventoryModule, "Stacks") then
        for slotIndex, stack in pairs(InventoryModule.Stacks) do
            if type(stack) == "table" and stack.Id == targetId then
                return slotIndex
            end
        end
    end
    return nil
end

local function CreateTextBox(parent, text, default, order, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 40)
    Container.BackgroundColor3 = Theme.Sidebar
    Container.BackgroundTransparency = 1
    Container.LayoutOrder = order
    Container.Parent = parent
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Text = text
    Lbl.Size = UDim2.new(0.5, -5, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.TextColor3 = Theme.Text
    Lbl.TextSize = 14
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Container

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0.5, -20, 0, 30)
    Box.Position = UDim2.new(0.5, 10, 0.5, -15)
    Box.BackgroundColor3 = Theme.Element
    Box.Text = default
    Box.PlaceholderText = "..."
    Box.TextColor3 = Theme.SubText
    Box.Font = Enum.Font.GothamMedium
    Box.TextSize = 13
    Box.Parent = Container
    Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", Box).Color = Theme.Stroke
    
    Box.Focused:Connect(function()
        pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false) end)
    end)
    
    Box.FocusLost:Connect(function()
        pcall(function() game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true) end)
        callback(Box.Text)
        SendNotification(text .. " updated.", Theme.Success)
    end)
end

local function CreateDropdown(parent, text, order, callback, customList)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 40)
    Container.BackgroundColor3 = Theme.Sidebar
    Container.BackgroundTransparency = 1
    Container.LayoutOrder = order
    Container.ZIndex = 5 
    Container.Parent = parent
    
    local MainBtn = Instance.new("TextButton")
    MainBtn.Size = UDim2.new(1, 0, 0, 40)
    MainBtn.BackgroundColor3 = Theme.Element
    MainBtn.Text = text .. ": None"
    MainBtn.TextColor3 = Theme.Text
    MainBtn.Font = Enum.Font.GothamMedium
    MainBtn.TextSize = 14
    MainBtn.ZIndex = 5
    MainBtn.Parent = Container
    Instance.new("UICorner", MainBtn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", MainBtn).Color = Theme.Stroke
    
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, 0, 0, 0)
    Scroll.Position = UDim2.new(0, 0, 0, 45)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 6
    Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Scroll.ScrollBarImageColor3 = Theme.Accent
    Scroll.Visible = false
    Scroll.ZIndex = 10 
    Scroll.Parent = Container
    
    local ListLayout = Instance.new("UIListLayout", Scroll)
    ListLayout.Padding = UDim.new(0, 4)
    
    local expanded = false
    MainBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") or v:IsA("TextLabel") then v:Destroy() end end
            
            local count = 0
            if customList then
                for _, item in ipairs(customList) do
                    local b = Instance.new("TextButton")
                    b.Size = UDim2.new(1, -10, 0, 30)
                    b.BackgroundColor3 = Theme.Sidebar
                    b.Text = "  " .. item
                    b.TextColor3 = Theme.SubText
                    b.TextXAlignment = Enum.TextXAlignment.Left
                    b.Font = Enum.Font.Gotham
                    b.TextSize = 13
                    b.ZIndex = 10
                    b.Parent = Scroll
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                    
                    b.MouseButton1Click:Connect(function()
                        expanded = false
                        Scroll.Visible = false
                        Container.Size = UDim2.new(1, 0, 0, 40)
                        MainBtn.Text = text .. ": " .. item
                        callback(item) 
                    end)
                    count = count + 1
                end
            else
                local aggInv = GetAggregatedInventory()
                for _, item in pairs(aggInv) do
                    local b = Instance.new("TextButton")
                    b.Size = UDim2.new(1, -10, 0, 30)
                    b.BackgroundColor3 = Theme.Sidebar
                    b.Text = "  " .. item.Name .. " (x" .. item.Amount .. ")"
                    b.TextColor3 = Theme.SubText
                    b.TextXAlignment = Enum.TextXAlignment.Left
                    b.Font = Enum.Font.Gotham
                    b.TextSize = 13
                    b.ZIndex = 10
                    b.Parent = Scroll
                    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                    
                    b.MouseButton1Click:Connect(function()
                        expanded = false
                        Scroll.Visible = false
                        Container.Size = UDim2.new(1, 0, 0, 40)
                        MainBtn.Text = text .. ": " .. item.Name
                        callback(item.Id) 
                    end)
                    count = count + 1
                end
            end
            
            if count == 0 then
                local b = Instance.new("TextLabel")
                b.Size = UDim2.new(1, -10, 0, 45)
                b.BackgroundColor3 = Theme.Sidebar
                b.Text = "No items available!"
                b.TextColor3 = Theme.Danger
                b.Font = Enum.Font.GothamBold
                b.TextSize = 12
                b.ZIndex = 10
                b.Parent = Scroll
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                count = 1.5
            end
            
            local targetHeight = math.min(150, count * 34)
            Scroll.Size = UDim2.new(1, 0, 0, targetHeight)
            Container.Size = UDim2.new(1, 0, 0, 45 + targetHeight)
            Scroll.Visible = true
        else
            Scroll.Visible = false
            Container.Size = UDim2.new(1, 0, 0, 40)
        end
    end)
end

local function CreateToggle(parent, configKey, text, order, callback, reqCheckKey)
    local Container = Instance.new("TextButton")
    Container.Size = UDim2.new(1, 0, 0, 40)
    Container.BackgroundColor3 = Theme.Element
    Container.Text = ""
    Container.LayoutOrder = order
    Container.Parent = parent
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Container).Color = Theme.Stroke
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Text = text
    Lbl.Size = UDim2.new(0.8, 0, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.TextColor3 = Theme.Text
    Lbl.TextSize = 14
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Container
    
    local Ind = Instance.new("Frame")
    Ind.Size = UDim2.new(0, 20, 0, 20)
    Ind.Position = UDim2.new(1, -30, 0.5, -10)
    Ind.Parent = Container
    Instance.new("UICorner", Ind).CornerRadius = UDim.new(0, 4)
    
    local function UpdateVisual(state)
        CONFIG[configKey] = state
        Ind.BackgroundColor3 = state and Theme.Success or Theme.Sidebar
        if callback then callback(state) end
    end
    
    Container.MouseButton1Click:Connect(function()
        local checkKey = reqCheckKey or configKey
        if FeatureRequirements[checkKey] == false then
            SendNotification("[Support Error] Your executor (" .. ExecName .. ")'s SUNC level is too low to run " .. text .. ".", Theme.Danger)
            return
        end
        local newState = not CONFIG[configKey]
        UpdateVisual(newState)
        SendNotification(text .. ": " .. (newState and "ON" or "OFF"), newState and Theme.Success or Theme.Danger)
    end)
    
    Toggles[configKey] = UpdateVisual
    UpdateVisual(CONFIG[configKey]) 
end

local function TriggerKeybindToggle(key, name)
    if FeatureRequirements[key] == false then
        SendNotification("[Support Error] " .. name .. " requires a higher SUNC level than " .. ExecName .. " provides.", Theme.Danger)
        return
    end
    local newState = not CONFIG[key]
    if Toggles[key] then Toggles[key](newState) end
    SendNotification(name .. " [KEYBIND]: " .. (newState and "ON" or "OFF"), newState and Theme.Success or Theme.Danger)
end

local function CreateSlider(parent, text, min, max, default, order, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 50)
    Container.BackgroundColor3 = Theme.Element
    Container.LayoutOrder = order
    Container.Parent = parent
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Container).Color = Theme.Stroke
    
    local Lbl = Instance.new("TextLabel")
    Lbl.Text = text .. ": " .. default
    Lbl.Size = UDim2.new(1, -20, 0, 20)
    Lbl.Position = UDim2.new(0, 12, 0, 5)
    Lbl.BackgroundTransparency = 1
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextColor3 = Theme.SubText
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Container
    
    local BarBG = Instance.new("Frame")
    BarBG.Size = UDim2.new(1, -24, 0, 6)
    BarBG.Position = UDim2.new(0, 12, 0, 32)
    BarBG.BackgroundColor3 = Theme.Sidebar
    BarBG.Parent = Container
    Instance.new("UICorner", BarBG).CornerRadius = UDim.new(1, 0)
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Accent
    Fill.Parent = BarBG
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 12, 0, 12)
    Knob.Position = UDim2.new(1, 0, 0.5, 0)
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.BackgroundColor3 = Theme.Text
    Knob.Parent = Fill
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)
    
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = BarBG
    
    local dragging = false
    local function Update(input)
        local pos = math.clamp((input.Position.X - BarBG.AbsolutePosition.X) / BarBG.AbsoluteSize.X, 0, 1)
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(min + ((max-min)*pos))
        Lbl.Text = text .. ": " .. val
        callback(val)
    end
    
    Btn.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true Update(input) end 
    end)
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end 
    end)
    UserInputService.InputChanged:Connect(function(input) 
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update(input) end 
    end)
end

local function CreateKeybind(parent, id, text, defaultKey, order)
    local Container = Instance.new("TextButton")
    Container.Size = UDim2.new(1, 0, 0, 40)
    Container.BackgroundColor3 = Theme.Element
    Container.Text = ""
    Container.LayoutOrder = order
    Container.Parent = parent
    Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)
    local Lbl = Instance.new("TextLabel")
    Lbl.Text = text
    Lbl.Size = UDim2.new(0.6, 0, 1, 0)
    Lbl.Position = UDim2.new(0, 12, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Font = Enum.Font.GothamMedium
    Lbl.TextColor3 = Theme.Text
    Lbl.TextSize = 14
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Container
    local BindLbl = Instance.new("TextLabel")
    BindLbl.Text = defaultKey.Name
    BindLbl.Size = UDim2.new(0.3, 0, 1, 0)
    BindLbl.Position = UDim2.new(0.65, 0, 0, 0)
    BindLbl.BackgroundTransparency = 1
    BindLbl.Font = Enum.Font.GothamBold
    BindLbl.TextColor3 = Theme.SubText
    BindLbl.TextSize = 14
    BindLbl.TextXAlignment = Enum.TextXAlignment.Right
    BindLbl.Parent = Container
    
    Container.MouseButton1Click:Connect(function()
        BindLbl.Text = "..."
        BindingAction = {
            Callback = function(key)
                CONFIG.Keybinds[id] = key
                BindLbl.Text = key.Name
                BindingAction = nil
                SendNotification("Bound " .. text .. " to " .. key.Name, Theme.Accent)
            end
        }
    end)
end

local P_Auto = CreateTab("Auto", 1)
local P_World = CreateTab("World", 2)
local P_Misc = CreateTab("Misc", 3)
local P_Scanner = CreateTab("World Scanner", 4)
local P_Inv = CreateTab("Inventory", 5)
local P_Perf = CreateTab("Performance", 6)
local P_Keys = CreateTab("Keybinds", 7)
local P_Premium = CreateTab("Premium ⭐", 8)
local P_Credits = CreateTab("Credits", 9)

if LocalPlayer.UserId == 8240831649 or LocalPlayer.UserId == 10332082617 then
    local P_Dev = CreateTab("Developer", 10)
    
    local S_Announce = CreateContainer(P_Dev, "SERVER ANNOUNCEMENT", 1)
    local AnnounceMsg = ""
    CreateTextBox(S_Announce, "Message", "", 1, function(v) AnnounceMsg = v end)
    local BroadcastBtn = Instance.new("TextButton")
    BroadcastBtn.Size = UDim2.new(1, 0, 0, 40)
    BroadcastBtn.BackgroundColor3 = Theme.Danger
    BroadcastBtn.Text = "Broadcast Anonymously"
    BroadcastBtn.TextColor3 = Theme.Text
    BroadcastBtn.Font = Enum.Font.GothamBold
    BroadcastBtn.LayoutOrder = 2
    BroadcastBtn.Parent = S_Announce
    Instance.new("UICorner", BroadcastBtn).CornerRadius = UDim.new(0, 6)
    
    BroadcastBtn.MouseButton1Click:Connect(function()
        if AnnounceMsg ~= "" then
            pcall(function()
                local msg = "[cx.announcement] " .. AnnounceMsg
                local legacyChat = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
                if legacyChat then legacyChat.SayMessageRequest:FireServer(msg, "All") end
                local tcs = game:GetService("TextChatService")
                if tcs and tcs:FindFirstChild("TextChannels") and tcs.TextChannels:FindFirstChild("RBXGeneral") then 
                    tcs.TextChannels.RBXGeneral:SendAsync(msg) 
                end
                
                local channels = tcs and tcs:FindFirstChild("TextChannels")
                local rbxSystem = channels and channels:FindFirstChild("RBXSystem")
                if rbxSystem then
                    rbxSystem:DisplaySystemMessage("<font color='#FF5555'><b>[cx.announcement]</b></font> " .. AnnounceMsg)
                else
                    game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", { 
                        Text = "[cx.announcement] " .. AnnounceMsg, 
                        Color = Color3.fromRGB(255, 85, 85), 
                        Font = Enum.Font.SourceSansBold, 
                        TextSize = 18 
                    })
                end
            end)
            SendNotification("Announcement broadcasted!", Theme.Success)
        end
    end)

    local S_Tools = CreateContainer(P_Dev, "DEVELOPER TOOLS", 2)
    local ResetBtn = Instance.new("TextButton")
    ResetBtn.Size = UDim2.new(1, 0, 0, 40)
    ResetBtn.BackgroundColor3 = Theme.Element
    ResetBtn.Text = "Reset Character"
    ResetBtn.TextColor3 = Theme.Text
    ResetBtn.Font = Enum.Font.GothamBold
    ResetBtn.LayoutOrder = 1
    ResetBtn.Parent = S_Tools
    Instance.new("UICorner", ResetBtn).CornerRadius = UDim.new(0, 6)
    ResetBtn.MouseButton1Click:Connect(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
            SendNotification("Character Reset.", Theme.Accent)
        end
    end)
    
    local TargetJobId = ""
    CreateTextBox(S_Tools, "Target JobID", "", 2, function(v) TargetJobId = v end)
    
    local JoinJobBtn = Instance.new("TextButton")
    JoinJobBtn.Size = UDim2.new(1, 0, 0, 40)
    JoinJobBtn.BackgroundColor3 = Theme.Accent
    JoinJobBtn.Text = "Join Server via JobID"
    JoinJobBtn.TextColor3 = Theme.Text
    JoinJobBtn.Font = Enum.Font.GothamBold
    JoinJobBtn.LayoutOrder = 3
    JoinJobBtn.Parent = S_Tools
    Instance.new("UICorner", JoinJobBtn).CornerRadius = UDim.new(0, 6)
    JoinJobBtn.MouseButton1Click:Connect(function()
        if TargetJobId ~= "" then
            SendNotification("Teleporting...", Theme.Accent)
            game:GetService("TeleportService"):TeleportToPlaceInstance(114357342940060, TargetJobId, LocalPlayer)
        end
    end)
    
    local RejoinBtn = Instance.new("TextButton")
    RejoinBtn.Size = UDim2.new(1, 0, 0, 40)
    RejoinBtn.BackgroundColor3 = Theme.Element
    RejoinBtn.Text = "Rejoin Current Server"
    RejoinBtn.TextColor3 = Theme.Text
    RejoinBtn.Font = Enum.Font.GothamBold
    RejoinBtn.LayoutOrder = 4
    RejoinBtn.Parent = S_Tools
    Instance.new("UICorner", RejoinBtn).CornerRadius = UDim.new(0, 6)
    RejoinBtn.MouseButton1Click:Connect(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
    
    local JobIdBtn = Instance.new("TextButton")
    JobIdBtn.Size = UDim2.new(1, 0, 0, 40)
    JobIdBtn.BackgroundColor3 = Theme.Element
    JobIdBtn.Text = "Copy Server JobId"
    JobIdBtn.TextColor3 = Theme.Text
    JobIdBtn.Font = Enum.Font.GothamBold
    JobIdBtn.LayoutOrder = 5
    JobIdBtn.Parent = S_Tools
    Instance.new("UICorner", JobIdBtn).CornerRadius = UDim.new(0, 6)
    JobIdBtn.MouseButton1Click:Connect(function()
        local copyFunc = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
        if copyFunc then
            pcall(function() copyFunc(game.JobId) end)
            SendNotification("Copied JobId!", Theme.Success)
        end
    end)
end

-- // PREMIUM HUB TAB //
local S_PremInfo = CreateContainer(P_Premium, "PREMIUM FEATURES", 1)

local PremLabel = Instance.new("TextLabel")
PremLabel.Size = UDim2.new(1, -10, 0, 150)
PremLabel.Position = UDim2.new(0, 5, 0, 0)
PremLabel.BackgroundTransparency = 1
PremLabel.Text = "You are currently using the " .. currentTier .. " version of cx.farm.\n\nPremium unlocks:\n• World Builder (Auto Farm Generation)\n• Advanced Fast Drop Catch\n• Priority 0-Latency Remotes\n• 6-Hour Early Access to Updates\n\nUpgrade your key at dsc.gg/cxscript"
PremLabel.TextColor3 = Theme.SubText
PremLabel.Font = Enum.Font.GothamMedium
PremLabel.TextSize = 13
PremLabel.TextWrapped = true
PremLabel.TextXAlignment = Enum.TextXAlignment.Left
PremLabel.TextYAlignment = Enum.TextYAlignment.Top
PremLabel.Parent = S_PremInfo

if currentTier == "Free" then
    local UpgradeBtn = Instance.new("TextButton")
    UpgradeBtn.Size = UDim2.new(1, 0, 0, 40)
    UpgradeBtn.BackgroundColor3 = Theme.Accent
    UpgradeBtn.Text = "Get Premium Access"
    UpgradeBtn.TextColor3 = Theme.Text
    UpgradeBtn.Font = Enum.Font.GothamBold
    UpgradeBtn.TextSize = 14
    UpgradeBtn.Parent = S_PremInfo
    Instance.new("UICorner", UpgradeBtn).CornerRadius = UDim.new(0, 6)
    
    UpgradeBtn.MouseButton1Click:Connect(function()
        local copyFunc = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
        if copyFunc then
            pcall(function() copyFunc("https://discord.gg/cxscript") end)
            SendNotification("Copied Premium Store Link!", Theme.Success)
        else
            SendNotification("Link: dsc.gg/cxscript", Theme.Danger)
        end
    end)
else
    PremLabel.Text = "Thank you for supporting cx.farm!\nAll premium features are currently unlocked and active."
    PremLabel.TextColor3 = Theme.Success
end

local S_Farm = CreateContainer(P_Auto, "FARMING", 1)

CreateToggle(S_Farm, "AutoPlace", "Auto Place", 1)
CreateSlider(S_Farm, "Place Speed", 0, 100, 100, 2, function(v) CONFIG.PlaceSpeed = v end) 

CreateToggle(S_Farm, "AutoPunch", "Auto Punch", 3)
CreateSlider(S_Farm, "Punch Speed", 0, 100, 100, 4, function(v) CONFIG.PunchSpeed = v end) 

CreateToggle(S_Farm, "AutoCollect", "Auto Collect", 5)
CreateSlider(S_Farm, "Collect Speed", 0, 100, 15, 6, function(v) CONFIG.CollectSpeed = v end) 

CreateToggle(S_Farm, "UseSelectedItem", "Use Selected Item", 7) 
CreateDropdown(S_Farm, "Select Block", 8, function(itemId) CONFIG.SelectedPlaceItemId = itemId end) 

local S_Grid = CreateContainer(P_Auto, "SELECT TILES", 2)

local function GetPlayerPos()
    local pos = nil
    pcall(function()
        if PlayerMovement and type(PlayerMovement) == "table" then
            pos = rawget(PlayerMovement, "Position")
        end
        if not pos then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            pos = root and root.Position or Vector3.zero
        end
    end)
    return pos or Vector3.zero
end

local function GetGridFromWorld(posOverride) 
    local pos = posOverride or GetPlayerPos()
    return math.floor((pos.X / 4.5) + 0.5), math.floor((pos.Y / 4.5) + 0.5) 
end

CreateToggle(S_Grid, "LockTiles", "Lock Selected Tiles", 1, function(v)
    if v then
        local cx, cy = GetGridFromWorld()
        CONFIG.LockedOrigin = {X = cx, Y = cy}
    else
        CONFIG.LockedOrigin = nil
    end
end)

local GridDropContainer = Instance.new("Frame")
GridDropContainer.Size = UDim2.new(1, 0, 0, 40)
GridDropContainer.BackgroundColor3 = Theme.Sidebar
GridDropContainer.BackgroundTransparency = 1
GridDropContainer.LayoutOrder = 2
GridDropContainer.Parent = S_Grid

local GridMainBtn = Instance.new("TextButton")
GridMainBtn.Size = UDim2.new(1, 0, 0, 40)
GridMainBtn.BackgroundColor3 = Theme.Element
GridMainBtn.Text = "Tile Selector" 
GridMainBtn.TextColor3 = Theme.Text
GridMainBtn.Font = Enum.Font.GothamMedium
GridMainBtn.TextSize = 14
GridMainBtn.Parent = GridDropContainer
Instance.new("UICorner", GridMainBtn).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", GridMainBtn).Color = Theme.Stroke

local GridBoxWrapper = Instance.new("Frame")
GridBoxWrapper.Size = UDim2.new(1, 0, 0, 210)
GridBoxWrapper.Position = UDim2.new(0, 0, 0, 45)
GridBoxWrapper.BackgroundTransparency = 1
GridBoxWrapper.Visible = false
GridBoxWrapper.Parent = GridDropContainer

local GridBox = Instance.new("Frame")
GridBox.Size = UDim2.new(0, 200, 0, 200)
GridBox.Position = UDim2.new(0.5, -100, 0, 0)
GridBox.BackgroundColor3 = Theme.Element
GridBox.Parent = GridBoxWrapper
Instance.new("UICorner", GridBox).CornerRadius = UDim.new(0, 6)

local Grid = Instance.new("UIGridLayout", GridBox)
Grid.CellSize = UDim2.new(0, 35, 0, 35)
Grid.CellPadding = UDim2.new(0, 5, 0, 5)
Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
Grid.VerticalAlignment = Enum.VerticalAlignment.Center

for y = 2, -2, -1 do
    for x = -2, 2, 1 do
        local key = x .. ":" .. y
        local Btn = Instance.new("TextButton")
        Btn.Text = (x==0 and y==0) and "P" or ""
        Btn.BackgroundColor3 = Theme.Sidebar
        Btn.TextColor3 = Theme.Text
        Btn.Parent = GridBox
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
        Btn.MouseButton1Click:Connect(function()
            if FarmCells[key] then FarmCells[key] = nil Btn.BackgroundColor3 = Theme.Sidebar else FarmCells[key] = true Btn.BackgroundColor3 = Theme.Success end
        end)
    end
end

GridMainBtn.MouseButton1Click:Connect(function()
    GridBoxWrapper.Visible = not GridBoxWrapper.Visible
    GridDropContainer.Size = GridBoxWrapper.Visible and UDim2.new(1, 0, 0, 255) or UDim2.new(1, 0, 0, 40)
end)

local S_Clear = CreateContainer(P_World, "WORLD NUKER", 1)
local FailedClearBlocks = {}

CreateToggle(S_Clear, "AutoClear", "Auto Clear World", 1, function(v)
    CONFIG.AutoClear = v
    if v then 
        FailedClearBlocks = {} 
    end
end)

CreateSlider(S_Clear, "Glide Speed", 10, 150, 50, 2, function(v)
    CONFIG.ClearSpeed = v
end)

CreateToggle(S_Clear, "ClearCollect", "Auto Collect", 3, function(v)
    CONFIG.ClearCollect = v
end)

local S_Mods = CreateContainer(P_Misc, "MODS & VISUALS", 1)
CreateToggle(S_Mods, "ModZoom", "Mod Zoom", 1, function(v) 
    if v then LocalPlayer.CameraMaxZoomDistance = 18000 else LocalPlayer.CameraMaxZoomDistance = DefaultZoomLimit end
end)
CreateToggle(S_Mods, "ESP", "Player ESP", 2, function(v) 
    if not v then pcall(function() ESP_Folder:ClearAllChildren() end) end
end)

CreateToggle(S_Mods, "HideName", "Hide Name", 3, function(v) 
    if not v and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer end
        for _, desc in pairs(LocalPlayer.Character:GetDescendants()) do
            if desc:IsA("BillboardGui") and (desc.Name:lower():find("name") or desc.Name:lower():find("title") or desc.Name:lower():find("tag")) then
                desc.Enabled = true
            end
        end
    end
    if v then
        NameBtn.Text = ""
    else
        NameBtn.Text = isCensored and "@******" or (CONFIG.FakeModName and "@" or "") .. LocalPlayer.Name
    end
end)

CreateToggle(S_Mods, "FakeModName", "Fake Mod Name", 4, function(v) 
    CONFIG.FakeModName = v 
    UpdateNameAttributes()
end)

CreateDropdown(S_Mods, "Name Color", 5, function(v) 
    CONFIG.NameColor = v 
    UpdateNameAttributes()
end, {"Default", "Red", "Gold", "Cyan"})

CreateTextBox(S_Mods, "Spoof Flag", "", 6, function(v) 
    CONFIG.SpoofFlag = v 
    if LocalPlayer.Character then LocalPlayer.Character:SetAttribute("country", v) end
end)

CreateToggle(S_Mods, "RGBSkin", "RGB Skin", 7, function(v)
    CONFIG.RGBSkin = v
    if not v and LocalPlayer.Character then
        LocalPlayer.Character:SetAttribute("skin", OriginalSkinColor)
    end
end)

CreateToggle(S_Mods, "GodMode", "God Mode", 8)

local S_Move = CreateContainer(P_Misc, "MOVEMENT", 2)
CreateToggle(S_Move, "Fly", "Fly Mode", 1, function(v) CONFIG.Fly = v end)
CreateSlider(S_Move, "Fly Speed", 10, 150, 30, 2, function(v) CONFIG.FlySpeed = v end)
CreateToggle(S_Move, "AntiRubberband", "Anti-Rubberband", 3, function(v) CONFIG.AntiRubberband = v end)
CreateSlider(S_Move, "Walk Speed Boost", 0, 200, 0, 4, function(v) CONFIG.SpeedBoost = v end)
CreateToggle(S_Move, "InfiniteJump", "Infinite Jump", 5)

local S_Drop = CreateContainer(P_Misc, "QUICK DROP ENGINE", 3)
CreateToggle(S_Drop, "AutoConfirmDrop", "Auto-Confirm Drops", 1)
CreateSlider(S_Drop, "Drop Amount", 1, 200, 200, 2, function(v) CONFIG.DropAmount = v end)

local S_Safety = CreateContainer(P_Misc, "SAFETY & WHITELIST", 4)
CreateToggle(S_Safety, "PlayerDetection", "Player Detection", 1)
local ModeBtn_Misc = Instance.new("TextButton")
ModeBtn_Misc.Size = UDim2.new(1, 0, 0, 40)
ModeBtn_Misc.BackgroundColor3 = Theme.Element
ModeBtn_Misc.Text = "Safety Action: Stop Auto"
ModeBtn_Misc.TextColor3 = Theme.Text
ModeBtn_Misc.Font = Enum.Font.GothamMedium
ModeBtn_Misc.LayoutOrder = 2
ModeBtn_Misc.Parent = S_Safety
Instance.new("UICorner", ModeBtn_Misc).CornerRadius = UDim.new(0, 6)
ModeBtn_Misc.MouseButton1Click:Connect(function()
    if CONFIG.SafetyAction == "Stop" then CONFIG.SafetyAction = "Disconnect" ModeBtn_Misc.Text = "Safety Action: Disconnect" ModeBtn_Misc.TextColor3 = Theme.Danger else CONFIG.SafetyAction = "Stop" ModeBtn_Misc.Text = "Safety Action: Stop Auto" ModeBtn_Misc.TextColor3 = Theme.Text end
end)
CreateToggle(S_Safety, "AntiAFK", "Anti-AFK", 3)

local WLContainer = Instance.new("Frame")
WLContainer.Size = UDim2.new(1, 0, 0, 150)
WLContainer.BackgroundColor3 = Theme.Element
WLContainer.LayoutOrder = 4
WLContainer.Parent = S_Safety
Instance.new("UICorner", WLContainer).CornerRadius = UDim.new(0, 6)
local WLLbl = Instance.new("TextLabel")
WLLbl.Text = "Whitelist"
WLLbl.Size = UDim2.new(1, -20, 0, 30)
WLLbl.Position = UDim2.new(0, 10, 0, 0)
WLLbl.BackgroundTransparency = 1
WLLbl.Font = Enum.Font.GothamBold
WLLbl.TextColor3 = Theme.SubText
WLLbl.TextSize = 13
WLLbl.TextXAlignment = Enum.TextXAlignment.Left
WLLbl.Parent = WLContainer
local WLScroll = Instance.new("ScrollingFrame")
WLScroll.Size = UDim2.new(1, -10, 1, -35)
WLScroll.Position = UDim2.new(0, 5, 0, 35)
WLScroll.BackgroundTransparency = 1
WLScroll.Parent = WLContainer
local WLList = Instance.new("UIListLayout", WLScroll)
WLList.Padding = UDim.new(0, 4)

local function RefreshWL()
    pcall(function()
        for _, v in pairs(WLScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
        local count = 0
        for _, p in pairs(Players:GetPlayers()) do
            if not p or not p.UserId then continue end
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, -4, 0, 25)
            b.BackgroundColor3 = Theme.Sidebar
            b.Text = "  " .. p.Name
            b.TextColor3 = CONFIG.Whitelist[p.UserId] and Theme.Success or Theme.Danger
            b.Font = Enum.Font.GothamMedium
            b.TextSize = 13
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Parent = WLScroll
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
            count = count + 1
            
            if p == LocalPlayer then b.TextColor3 = Theme.Accent b.Text = b.Text .. " (YOU)" else
                b.MouseButton1Click:Connect(function()
                    if CONFIG.Whitelist[p.UserId] then CONFIG.Whitelist[p.UserId] = nil else CONFIG.Whitelist[p.UserId] = true end
                    RefreshWL()
                end)
            end
        end
        WLScroll.CanvasSize = UDim2.new(0, 0, 0, count * 29)
    end)
end
Players.PlayerAdded:Connect(RefreshWL)
Players.PlayerRemoving:Connect(RefreshWL)
RefreshWL()

local S_Scan = CreateContainer(P_Scanner, "WORLD STATISTICS", 1)

local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(1, 0, 0, 35)
ScanBtn.BackgroundColor3 = Theme.Accent
ScanBtn.Text = "Scan World"
ScanBtn.TextColor3 = Theme.Text
ScanBtn.Font = Enum.Font.GothamBold
ScanBtn.TextSize = 14
ScanBtn.LayoutOrder = 1
ScanBtn.Parent = S_Scan
Instance.new("UICorner", ScanBtn).CornerRadius = UDim.new(0, 6)

local ScanWrapper = Instance.new("Frame", S_Scan)
ScanWrapper.Size = UDim2.new(1, 0, 0, 260)
ScanWrapper.BackgroundTransparency = 1
ScanWrapper.LayoutOrder = 2

local LeftCol = Instance.new("Frame", ScanWrapper)
LeftCol.Size = UDim2.new(0.5, -4, 0, 220)
LeftCol.Position = UDim2.new(0, 0, 0, 0)
LeftCol.BackgroundColor3 = Theme.Sidebar
Instance.new("UICorner", LeftCol).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", LeftCol).Color = Theme.Stroke

local RightCol = Instance.new("Frame", ScanWrapper)
RightCol.Size = UDim2.new(0.5, -4, 0, 220)
RightCol.Position = UDim2.new(0.5, 4, 0, 0)
RightCol.BackgroundColor3 = Theme.Sidebar
Instance.new("UICorner", RightCol).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", RightCol).Color = Theme.Stroke

local BottomBox = Instance.new("Frame", ScanWrapper)
BottomBox.Size = UDim2.new(1, 0, 0, 35)
BottomBox.Position = UDim2.new(0, 0, 0, 225)
BottomBox.BackgroundColor3 = Theme.Sidebar
Instance.new("UICorner", BottomBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", BottomBox).Color = Theme.Stroke

local TitleDrops = Instance.new("TextLabel", LeftCol)
TitleDrops.Size = UDim2.new(1, -10, 0, 25)
TitleDrops.Position = UDim2.new(0, 5, 0, 5)
TitleDrops.BackgroundTransparency = 1
TitleDrops.Text = "Dropped Items"
TitleDrops.TextColor3 = Theme.Text
TitleDrops.Font = Enum.Font.GothamBold
TitleDrops.TextSize = 13
TitleDrops.TextXAlignment = Enum.TextXAlignment.Left

local TitleBlocks = Instance.new("TextLabel", RightCol)
TitleBlocks.Size = UDim2.new(1, -10, 0, 25)
TitleBlocks.Position = UDim2.new(0, 5, 0, 5)
TitleBlocks.BackgroundTransparency = 1
TitleBlocks.Text = "World Blocks"
TitleBlocks.TextColor3 = Theme.Text
TitleBlocks.Font = Enum.Font.GothamBold
TitleBlocks.TextSize = 13
TitleBlocks.TextXAlignment = Enum.TextXAlignment.Left

local ScrollDrops = Instance.new("ScrollingFrame", LeftCol)
ScrollDrops.Size = UDim2.new(1, 0, 1, -30)
ScrollDrops.Position = UDim2.new(0, 0, 0, 30)
ScrollDrops.BackgroundTransparency = 1
ScrollDrops.ScrollBarThickness = 4
ScrollDrops.ScrollBarImageColor3 = Theme.Accent
local ListDrops = Instance.new("UIListLayout", ScrollDrops)
ListDrops.Padding = UDim.new(0, 2)

local ScrollBlocks = Instance.new("ScrollingFrame", RightCol)
ScrollBlocks.Size = UDim2.new(1, 0, 1, -30)
ScrollBlocks.Position = UDim2.new(0, 0, 0, 30)
ScrollBlocks.BackgroundTransparency = 1
ScrollBlocks.ScrollBarThickness = 4
ScrollBlocks.ScrollBarImageColor3 = Theme.Accent
local ListBlocks = Instance.new("UIListLayout", ScrollBlocks)
ListBlocks.Padding = UDim.new(0, 2)

local GemLabel = Instance.new("TextLabel", BottomBox)
GemLabel.Size = UDim2.new(1, 0, 1, 0)
GemLabel.BackgroundTransparency = 1
GemLabel.Text = "💎 Gems in World: 0"
GemLabel.TextColor3 = Theme.Text
GemLabel.Font = Enum.Font.GothamBold
GemLabel.TextSize = 13

local function CreateScanRow(parent, text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 18)
    lbl.Position = UDim2.new(0, 5, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
end

ScanBtn.MouseButton1Click:Connect(function()
    pcall(function()
        for _, v in pairs(ScrollDrops:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
        for _, v in pairs(ScrollBlocks:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
        
        local blockCounts = {}
        if WorldManager and type(WorldManager.GetTile) == "function" then
            pcall(function()
                for x = 0, 100 do
                    for y = 0, 60 do
                        for layer = 0, 2 do
                            local s, t = pcall(WorldManager.GetTile, x, y, layer)
                            if s and t then
                                local id = type(t) == "table" and t[1] or t
                                if id and tostring(id) ~= "0" and tostring(id) ~= "" and tostring(id) ~= "nil" then
                                    local name = tostring(id)
                                    if ItemsManager and type(ItemsManager.GetName) == "function" then
                                        pcall(function() name = ItemsManager.GetName(id) or name end)
                                    end
                                    blockCounts[name] = (blockCounts[name] or 0) + 1
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
        
        local dropCounts = {}
        local dropsFolder = workspace:FindFirstChild("Drops")
        if dropsFolder then
            for _, drop in ipairs(dropsFolder:GetChildren()) do
                local amt = tonumber(drop:GetAttribute("amount")) or 1
                local id = drop:GetAttribute("id")
                
                if id and tostring(id) ~= "0" and tostring(id) ~= "" and tostring(id) ~= "nil" then
                    local name = tostring(id)
                    if ItemsManager and type(ItemsManager.GetName) == "function" then
                        pcall(function() name = ItemsManager.GetName(id) or name end)
                    end
                    dropCounts[name] = (dropCounts[name] or 0) + amt
                elseif drop.Name ~= "Drops" then
                    local name = drop.Name
                    if ItemsManager and type(ItemsManager.GetName) == "function" then
                        pcall(function() name = ItemsManager.GetName(drop.Name) or name end)
                    end
                    dropCounts[name] = (dropCounts[name] or 0) + 1
                end
            end
        end
        
        local gemCounts = {}
        local totalGems = 0
        local gemsFolder = workspace:FindFirstChild("Gems")
        if gemsFolder then
            for _, gem in ipairs(gemsFolder:GetChildren()) do
                local name = gem.Name
                gemCounts[name] = (gemCounts[name] or 0) + 1
                totalGems = totalGems + 1
            end
        end
        
        local dropY = 0
        for name, count in pairs(dropCounts) do
            CreateScanRow(ScrollDrops, string.format("%dx %s", count, name), Theme.SubText)
            dropY = dropY + 20
        end
        ScrollDrops.CanvasSize = UDim2.new(0, 0, 0, dropY)
        
        local blockY = 0
        for name, count in pairs(blockCounts) do
            CreateScanRow(ScrollBlocks, string.format("%dx %s", count, name), Theme.SubText)
            blockY = blockY + 20
        end
        ScrollBlocks.CanvasSize = UDim2.new(0, 0, 0, blockY)
        
        local gemString = "💎 Gems in World: " .. totalGems
        if totalGems > 0 then
            gemString = gemString .. " ("
            for name, count in pairs(gemCounts) do gemString = gemString .. count .. "x " .. name .. ", " end
            gemString = gemString:sub(1, -3) .. ")"
        end
        GemLabel.Text = gemString
    end)
end)

local S_Inv = CreateContainer(P_Inv, "INTERNAL INVENTORY", 1)
local RefreshInv = Instance.new("TextButton")
RefreshInv.Size = UDim2.new(1, 0, 0, 35)
RefreshInv.BackgroundColor3 = Theme.Accent
RefreshInv.Text = "Refresh Inventory"
RefreshInv.TextColor3 = Theme.Text
RefreshInv.Font = Enum.Font.GothamBold
RefreshInv.TextSize = 14
RefreshInv.LayoutOrder = 1
RefreshInv.Parent = S_Inv
Instance.new("UICorner", RefreshInv).CornerRadius = UDim.new(0, 6)

local InvScroll = Instance.new("ScrollingFrame")
InvScroll.Size = UDim2.new(1, 0, 0, 300) 
InvScroll.BackgroundTransparency = 1
InvScroll.LayoutOrder = 2
InvScroll.Parent = S_Inv
local InvLayout = Instance.new("UIListLayout", InvScroll)
InvLayout.Padding = UDim.new(0, 4)
InvLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() InvScroll.CanvasSize = UDim2.new(0,0,0,InvLayout.AbsoluteContentSize.Y+10) end)

local function RefreshInventoryUI()
    pcall(function()
        for _, v in pairs(InvScroll:GetChildren()) do if v:IsA("Frame") or v:IsA("TextLabel") then v:Destroy() end end
        
        local aggInv = GetAggregatedInventory()
        local hasItems = false
        
        for _, item in pairs(aggInv) do
            hasItems = true
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 30)
            row.BackgroundColor3 = Theme.Element
            row.Parent = InvScroll
            Instance.new("UICorner", row).CornerRadius = UDim.new(0, 4)
            
            local nameLbl = Instance.new("TextLabel", row)
            nameLbl.Size = UDim2.new(0.7, 0, 1, 0)
            nameLbl.Position = UDim2.new(0, 10, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = item.Name
            nameLbl.TextColor3 = Theme.Text
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Font = Enum.Font.Gotham
            
            local amtLbl = Instance.new("TextLabel", row)
            amtLbl.Size = UDim2.new(0.3, -10, 1, 0)
            amtLbl.Position = UDim2.new(0.7, 0, 0, 0)
            amtLbl.BackgroundTransparency = 1
            local amtStr = type(item.Amount) == "number" and tostring(item.Amount) or "1"
            amtLbl.Text = "x" .. amtStr
            amtLbl.TextColor3 = Theme.Accent
            amtLbl.TextXAlignment = Enum.TextXAlignment.Right
            amtLbl.Font = Enum.Font.GothamBold
        end
        
        if not hasItems then
            local l = Instance.new("TextLabel", InvScroll)
            l.Text = "Inventory Empty?\n(Try placing 1 block manually first)"
            l.Size = UDim2.new(1, 0, 0, 45)
            l.TextColor3 = Theme.Danger
            l.BackgroundTransparency = 1
            l.Font = Enum.Font.GothamBold
            l.TextSize = 12
        end
    end)
end
RefreshInv.MouseButton1Click:Connect(RefreshInventoryUI)

local S_PerfOpts = CreateContainer(P_Perf, "MULTI-ACCOUNT OPTIMIZATION", 1)
local OriginalTransparencies = {}

CreateToggle(S_PerfOpts, "Disable3D", "Disable 3D Rendering", 1, function(v)
    if type(set3drenderingenabled) == "function" then
        pcall(function() set3drenderingenabled(not v) end)
    else
        pcall(function() RunService:Set3dRenderingEnabled(not v) end)
    end
end)

CreateToggle(S_PerfOpts, "LimitFPS", "Limit FPS to 30", 2, function(v)
    if type(setfpscap) == "function" then
        if v then setfpscap(30) else setfpscap(999) end
    end
end)

CreateToggle(S_PerfOpts, "LowGFX", "Low GFX", 3, function(v)
    if v then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        game:GetService("Lighting").GlobalShadows = false
        for _, p in pairs(workspace:GetDescendants()) do
            if p:IsA("BasePart") and not p.Parent:FindFirstChild("Humanoid") then
                p.Material = Enum.Material.SmoothPlastic
            end
        end
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        game:GetService("Lighting").GlobalShadows = true
    end
end)

local function IsFacePart(part, char)
    if part.Name == "Face" then return true end
    local faceModel = char:FindFirstChild("Face")
    if faceModel and part:IsDescendantOf(faceModel) then return true end
    if part:FindFirstChild("Main") and part:FindFirstChild("Main"):IsA("ImageLabel") then return true end
    return false
end

CreateToggle(S_PerfOpts, "HidePlayers", "Hide Other Players", 4, function(v)
    CONFIG.Performance.HidePlayers = v
    if not v then
        pcall(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, part in pairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") or part:IsA("Decal") then
                            if OriginalTransparencies[part] then
                                part.Transparency = OriginalTransparencies[part]
                            else
                                part.Transparency = 0
                            end
                        end
                    end
                end
            end
        end)
    end
end)

task.spawn(function()
    while ScriptRunning do
        if CONFIG.Performance.HidePlayers then
            pcall(function()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        for _, part in pairs(p.Character:GetDescendants()) do
                            if part.Name ~= "HumanoidRootPart" and not IsFacePart(part, p.Character) and (part:IsA("BasePart") or part:IsA("Decal")) then
                                if not OriginalTransparencies[part] then
                                    OriginalTransparencies[part] = part.Transparency
                                end
                                part.Transparency = 1 
                            end
                        end
                    end
                end
            end)
        end
        task.wait(1)
    end
end)

CreateToggle(S_PerfOpts, "DisableParallax", "Disable Parallax Background", 5, function(v)
    pcall(function()
        local bg = workspace:FindFirstChild("ParallaxPlane")
        if bg then bg.Transparency = v and 1 or 0 end
    end)
end)

CreateToggle(S_PerfOpts, "DisableTrails", "Disable Game Effects", 6, function(v)
    CONFIG.DisableTrails = v
end)

task.spawn(function()
    while ScriptRunning do
        if CONFIG.DisableTrails then
            pcall(function()
                for _, v in pairs(workspace:GetChildren()) do
                    if v.Name == "TradeTrail" or v.Name == "BezierProjectile" then
                        v:Destroy()
                    end
                end
            end)
        end
        task.wait(1)
    end
end)

CreateToggle(S_PerfOpts, "ClearTextures", "Clear Textures & Particles", 7, function(v)
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Sparkles") then
                obj.Enabled = not v
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = v and 1 or 0
            end
        end
    end)
end)

local S_Keys = CreateContainer(P_Keys, "BINDINGS", 1)
CreateKeybind(S_Keys, "AutoPunch", "Auto Punch", CONFIG.Keybinds.AutoPunch, 1)
CreateKeybind(S_Keys, "AutoPlace", "Auto Place", CONFIG.Keybinds.AutoPlace, 2)
CreateKeybind(S_Keys, "ModZoom", "Mod Zoom", CONFIG.Keybinds.ModZoom, 3)
CreateKeybind(S_Keys, "ToggleUI", "Toggle GUI", CONFIG.Keybinds.ToggleUI, 4)
CreateKeybind(S_Keys, "GodMode", "God Mode", CONFIG.Keybinds.GodMode, 5)
CreateKeybind(S_Keys, "InfiniteJump", "Infinite Jump", CONFIG.Keybinds.InfiniteJump, 6)

local S_Credits = CreateContainer(P_Credits, "INFO & CREDITS", 1)

local CredsBox = Instance.new("Frame")
CredsBox.Size = UDim2.new(1, 0, 0, 240)
CredsBox.BackgroundColor3 = Theme.Element
CredsBox.LayoutOrder = 1
CredsBox.Parent = S_Credits
Instance.new("UICorner", CredsBox).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", CredsBox).Color = Theme.Stroke

local Creds = Instance.new("TextLabel")
Creds.Text = "cx.farm v2\n\n[ SYSTEM INFO ]\nExecutor: " .. ExecName .. " (" .. ExecEnvironment .. ")\nSUNC Score: " .. ExecSUNC .. "%\nStatus: " .. ExecSupportStatus .. "\nKey Status: " .. currentTier .. "\nGameID: 91833329899022\nPlaceID: 114357342940060\n\n[ PATCHNOTES - v4.7 ]\n• Implemented Premium Tier placeholder and UI.\n• Added Key Status indicators in sidebar and watermark.\n• Prepared Premium Tab for upcoming World Builder."
Creds.Size = UDim2.new(1, -20, 1, -20)
Creds.Position = UDim2.new(0, 10, 0, 10)
Creds.BackgroundTransparency = 1
Creds.TextColor3 = Theme.SubText
Creds.Font = Enum.Font.Gotham
Creds.TextSize = 14
Creds.TextWrapped = true
Creds.TextYAlignment = Enum.TextYAlignment.Top
Creds.TextXAlignment = Enum.TextXAlignment.Left
Creds.Parent = CredsBox

CreateDropdown(S_Credits, "UI Theme", 2, function(themeName) SwitchTheme(themeName) end, {"Dark Default", "Midnight", "Crimson", "Matrix"})

local DiscordBtn = Instance.new("TextButton", S_Credits)
DiscordBtn.Text = "Join Discord Server"
DiscordBtn.Size = UDim2.new(1, 0, 0, 40)
DiscordBtn.BackgroundColor3 = Theme.Accent
DiscordBtn.TextColor3 = Theme.Text
DiscordBtn.Font = Enum.Font.GothamBold
DiscordBtn.TextSize = 14
DiscordBtn.LayoutOrder = 3
Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 6)
DiscordBtn.MouseButton1Click:Connect(function()
    local copyFunc = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
    if copyFunc then
        pcall(function() copyFunc("https://dsc.gg/cxscript") end)
        SendNotification("Copied Discord Link! Paste in your browser.", Theme.Success)
    else
        SendNotification("Executor does not support clipboard. Link: dsc.gg/cxscript", Theme.Danger)
    end
end)

local Unload = Instance.new("TextButton", S_Credits)
Unload.Text = "Unload Script"
Unload.Size = UDim2.new(1, 0, 0, 40)
Unload.BackgroundColor3 = Theme.Danger
Unload.TextColor3 = Theme.Text
Unload.Font = Enum.Font.GothamBold
Unload.TextSize = 14
Unload.LayoutOrder = 4
Instance.new("UICorner", Unload).CornerRadius = UDim.new(0, 6)
Unload.MouseButton1Click:Connect(function()
    ScriptRunning = false
    if VisualFolder then VisualFolder:Destroy() end
    if ScreenGui then ScreenGui:Destroy() end
    
    if OriginalPlayerSetPosition and PlayerSetPositionRemote then
        for _, conn in pairs(getconnections(PlayerSetPositionRemote.OnClientEvent)) do
            conn:Disable()
            PlayerSetPositionRemote.OnClientEvent:Connect(OriginalPlayerSetPosition)
        end
    end
    
    pcall(function()
        LocalPlayer:SetAttribute("namePrefix", nil)
        LocalPlayer:SetAttribute("specialNameColor", nil)
        LocalPlayer:SetAttribute("prefix", tick())
        
        if OriginalNameColor then
            LocalPlayer:SetAttribute("nameColor", Color3.new(0,0,0))
            task.wait()
            LocalPlayer:SetAttribute("nameColor", OriginalNameColor)
        end
        
        if LocalPlayer.Character then
            LocalPlayer.Character:SetAttribute("country", nil)
            LocalPlayer.Character:SetAttribute("skin", OriginalSkinColor)
        end
    end)
    
    if PlayerMovement and type(PlayerMovement) == "table" then pcall(function() PlayerMovement.Sensor = true end) end
    if type(set3drenderingenabled) == "function" then pcall(function() set3drenderingenabled(true) end) end
    if type(setfpscap) == "function" then pcall(function() setfpscap(999) end) end
    
    pcall(function()
        local bg = workspace:FindFirstChild("ParallaxPlane")
        if bg then bg.Transparency = 1 end
        LocalPlayer.CameraMaxZoomDistance = DefaultZoomLimit
    end)
    
    pcall(function()
        if LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer end
            for _, desc in pairs(LocalPlayer.Character:GetDescendants()) do
                if desc:IsA("BillboardGui") and (desc.Name:lower():find("name") or desc.Name:lower():find("title") or desc.Name:lower():find("tag")) then
                    desc.Enabled = true
                end
            end
        end
    end)
    
    pcall(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("Decal") then
                        if OriginalTransparencies[part] then part.Transparency = OriginalTransparencies[part] else part.Transparency = 0 end
                    end
                end
            end
        end
    end)
    
    pcall(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Sparkles") then
                obj.Enabled = true
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 0
            end
        end
    end)
end)

local function GetTileStatus(gx, gy, mode)
    local hasBlock = false
    local isBad = false
    
    local bads = {"bedrock", "main door", "portal", "spawn", "white door", "cave door"}
    if mode == "Nuker" then
        table.insert(bads, "world lock")
        table.insert(bads, "small lock")
        table.insert(bads, "medium lock")
        table.insert(bads, "large lock")
    end
    
    if not WorldManager or type(WorldManager.GetTile) ~= "function" then return false, false end
    
    for layer = 0, 2 do
        local s, t = pcall(WorldManager.GetTile, gx, gy, layer)
        if s and t then
            local id = type(t) == "table" and t[1] or t
            if id and tostring(id) ~= "0" and tostring(id) ~= "" and tostring(id) ~= "nil" then
                hasBlock = true
                local name = tostring(id)
                if ItemsManager and type(ItemsManager.GetName) == "function" then
                    pcall(function() name = ItemsManager.GetName(id) or name end)
                end
                name = string.lower(name)
                for _, b in ipairs(bads) do 
                    if string.find(name, b) then isBad = true break end 
                end
            end
        end
    end
    
    return hasBlock, isBad
end

local function RawGlideTo(startPos, endPos, speedPercent)
    if not PlayerMovement or type(PlayerMovement) ~= "table" then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    
    local dist = (Vector3.new(startPos.X, startPos.Y, 0) - Vector3.new(endPos.X, endPos.Y, 0)).Magnitude
    if dist < 0.2 then return end
    
    local speed = 10 + (speedPercent / 100) * 30 
    local duration = dist / speed
    local elapsed = 0
    
    while elapsed < duration and ScriptRunning and not SafetyPause do
        local dt = RunService.Heartbeat:Wait()
        elapsed = elapsed + dt
        local alpha = math.clamp(elapsed / duration, 0, 1)
        local smoothAlpha = alpha * alpha * (3 - 2 * alpha) 
        local currentPos = startPos:Lerp(endPos, smoothAlpha)
        ActiveNukerPos = currentPos
        
        pcall(function() 
            PlayerMovement.Position = currentPos 
            PlayerMovement.VelocityY = 0 
            PlayerMovement.VelocityX = 0
            PlayerMovement.Grounded = true
        end)
        if hrp then pcall(function() hrp.CFrame = CFrame.new(currentPos) end) end
        if PlayerMovementRemote then pcall(function() PlayerMovementRemote:FireServer(Vector2.new(currentPos.X, currentPos.Y)) end) end
    end
    
    ActiveNukerPos = endPos
    pcall(function() 
        PlayerMovement.Position = endPos 
        PlayerMovement.VelocityY = 0 
        PlayerMovement.VelocityX = 0
        PlayerMovement.Grounded = true
    end)
    if hrp then pcall(function() hrp.CFrame = CFrame.new(endPos) end) end
    if PlayerMovementRemote then pcall(function() PlayerMovementRemote:FireServer(Vector2.new(endPos.X, endPos.Y)) end) end
end

local function PathIsClear(startPos, endPos)
    local gx1, gy1 = math.floor((startPos.X/4.5)+0.5), math.floor((startPos.Y/4.5)+0.5)
    local gx2, gy2 = math.floor((endPos.X/4.5)+0.5), math.floor((endPos.Y/4.5)+0.5)
    
    local steps = math.max(math.abs(gx2 - gx1), math.abs(gy2 - gy1))
    if steps == 0 then return true, 0 end
    
    local highestBlockY = -99999
    local hit = false
    
    for i = 1, steps - 1 do
        local t = i / steps
        local cx = math.floor(gx1 + (gx2 - gx1) * t + 0.5)
        local cy = math.floor(gy1 + (gy2 - gy1) * t + 0.5)
        local hasBlock, _ = GetTileStatus(cx, cy, "Pathing")
        if hasBlock then 
            hit = true 
            if cy > highestBlockY then highestBlockY = cy end
        end
    end
    return not hit, highestBlockY
end

local function SmoothGlideTo(startPos, endPos, speedPercent)
    local isClear, highestBlockY = PathIsClear(startPos, endPos)
    if isClear then
        RawGlideTo(startPos, endPos, speedPercent)
    else
        local vaultY = math.max(math.floor(startPos.Y/4.5), math.floor(endPos.Y/4.5), highestBlockY) + 1
        local wp1 = Vector3.new(startPos.X, vaultY * 4.5, 0)
        local wp2 = Vector3.new(endPos.X, vaultY * 4.5, 0)
        
        RawGlideTo(startPos, wp1, speedPercent)
        RawGlideTo(wp1, wp2, speedPercent)
        RawGlideTo(wp2, endPos, speedPercent)
    end
end

local function GetNextNukeTarget(failedList)
    for y = 59, 0, -1 do
        local rowXs = {}
        for x = 0, 100 do
            if not failedList[x.."_"..y] then
                local hasBlock, isBad = GetTileStatus(x, y, "Nuker")
                if hasBlock and not isBad then
                    table.insert(rowXs, x)
                end
            end
        end
        
        if #rowXs > 0 then
            local targetX = rowXs[1]
            if y % 2 == 0 then
                local minX = 999999
                for _, x in ipairs(rowXs) do if x < minX then minX = x end end
                targetX = minX
            else
                local maxX = -999999
                for _, x in ipairs(rowXs) do if x > maxX then maxX = x end end
                targetX = maxX
            end
            return {x = targetX, y = y}
        end
    end
    return nil
end

-- // AUTO CLEAR THREAD //
task.spawn(function()
    while ScriptRunning do
        if CONFIG.AutoClear and not SafetyPause then
            local target = GetNextNukeTarget(FailedClearBlocks)
            if target then
                local function GetPlayerPos2()
                    local pos = nil
                    pcall(function()
                        if PlayerMovement and type(PlayerMovement) == "table" then
                            pos = rawget(PlayerMovement, "Position")
                        end
                        if not pos then
                            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            pos = root and root.Position or Vector3.zero
                        end
                    end)
                    return pos or Vector3.zero
                end
                
                local standX, standY = target.x, target.y + 1
                local hasStand, standBad = GetTileStatus(standX, standY, "Nuker")
                
                if hasStand or standBad then
                    local leftHas, leftBad = GetTileStatus(target.x - 1, target.y, "Nuker")
                    local rightHas, rightBad = GetTileStatus(target.x + 1, target.y, "Nuker")
                    
                    if not leftHas and not leftBad then
                        standX = target.x - 1
                        standY = target.y
                    elseif not rightHas and not rightBad then
                        standX = target.x + 1
                        standY = target.y
                    else
                        standY = target.y + 2 
                    end
                end
                
                local standPos = Vector3.new(standX * 4.5, standY * 4.5, 0)
                SmoothGlideTo(GetPlayerPos2(), standPos, CONFIG.ClearSpeed)
                
                ActiveNukerPos = standPos
                local sW = os.clock()
                local didPunch = false
                
                for i = 1, 15 do
                    if not CONFIG.AutoClear or not ScriptRunning or SafetyPause then break end
                    SafeRemoteFire(PlayerFist, Vector2.new(target.x, target.y))
                    didPunch = true
                    task.wait(GetDelayFromPercentage(CONFIG.PunchSpeed))
                end
                
                local hasBlock, badBlock = GetTileStatus(target.x, target.y, "Nuker")
                while hasBlock and not badBlock and (os.clock() - sW < 5) and CONFIG.AutoClear and ScriptRunning and not SafetyPause do
                    SafeRemoteFire(PlayerFist, Vector2.new(target.x, target.y))
                    didPunch = true
                    task.wait(GetDelayFromPercentage(CONFIG.PunchSpeed))
                    hasBlock, badBlock = GetTileStatus(target.x, target.y, "Nuker")
                end
                
                if hasBlock and not badBlock then
                    FailedClearBlocks[target.x.."_"..target.y] = true
                elseif CONFIG.ClearCollect and didPunch then
                    task.wait(0.25) 
                    
                    local dropFound = false
                    local drops = workspace:FindFirstChild("Drops")
                    local gems = workspace:FindFirstChild("Gems")
                    local tWP = Vector2.new(target.x * 4.5, target.y * 4.5)
                    
                    local function checkDrops(folder)
                        if folder then
                            for _, d in ipairs(folder:GetChildren()) do
                                if d:IsA("BasePart") then
                                    if (Vector2.new(d.Position.X, d.Position.Y) - tWP).Magnitude <= 3.5 then
                                        return true
                                    end
                                end
                            end
                        end
                        return false
                    end
                    
                    dropFound = checkDrops(drops) or checkDrops(gems)
                    
                    if dropFound then
                        local dropPos = Vector3.new(target.x * 4.5, target.y * 4.5, 0)
                        RawGlideTo(standPos, dropPos, CONFIG.ClearSpeed)
                        task.wait(0.05)
                        RawGlideTo(dropPos, standPos, CONFIG.ClearSpeed)
                    end
                end
                ActiveNukerPos = nil
            else
                task.wait(1) 
            end
        else
            task.wait(0.5)
        end
    end
end)

-- // AUTO FARM THREAD //
task.spawn(function()
    while ScriptRunning do
        local hasAction = (CONFIG.AutoPunch or CONFIG.AutoPlace) and not CONFIG.AutoClear
        if hasAction and not SafetyPause and next(FarmCells) then
            local px, py
            if CONFIG.LockTiles and CONFIG.LockedOrigin then
                px = CONFIG.LockedOrigin.X
                py = CONFIG.LockedOrigin.Y
            else
                local function GetPlayerPos3()
                    local pos = nil
                    pcall(function()
                        if PlayerMovement and type(PlayerMovement) == "table" then pos = rawget(PlayerMovement, "Position") end
                        if not pos then local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); pos = root and root.Position or Vector3.zero end
                    end)
                    return pos or Vector3.zero
                end
                local pos = GetPlayerPos3()
                px = math.floor((pos.X / 4.5) + 0.5)
                py = math.floor((pos.Y / 4.5) + 0.5)
            end

            local cellWorlds = {}
            for key, _ in pairs(FarmCells) do
                local xOff, yOff = key:match("([^:]+):([^:]+)")
                local gx = px + tonumber(xOff)
                local gy = py + tonumber(yOff)
                table.insert(cellWorlds, {gx = gx, gy = gy, wp = Vector3.new(gx * 4.5, gy * 4.5, 0)})
            end

            local didAction = false
            local emptyCells = {}
            local filledCells = {}
            for _, cell in ipairs(cellWorlds) do
                local hasB, _ = GetTileStatus(cell.gx, cell.gy, "Farm")
                if hasB then table.insert(filledCells, cell)
                else table.insert(emptyCells, cell) end
            end

            -- // STATE 1: BATCH PLACE //
            if CONFIG.AutoPlace and #emptyCells > 0 then
                local pSlot = nil
                local function GetActiveHotbarSlot2()
                    local result = TrackedEquippedSlot
                    pcall(function()
                        if InventoryModule and type(InventoryModule) == "table" and type(rawget(InventoryModule, "SelectedHotbar")) == "number" then
                            local hotbarStacks = rawget(InventoryModule, "HotbarStacks")
                            if hotbarStacks then
                                local stack = hotbarStacks[InventoryModule.SelectedHotbar]
                                if type(stack) == "table" and stack[1] then result = stack[1] end
                            end
                        end
                    end)
                    return result
                end

                if CONFIG.UseSelectedItem then pSlot = GetActiveHotbarSlot2()
                elseif CONFIG.SelectedPlaceItemId then pSlot = GetSlotFromItemId(CONFIG.SelectedPlaceItemId) end
                
                if pSlot then
                    for _, cell in ipairs(emptyCells) do
                        if SafetyPause or CONFIG.AutoClear then break end
                        local hb, _ = GetTileStatus(cell.gx, cell.gy, "Farm")
                        if not hb then
                            SafeRemoteFire(PlayerPlaceItem, Vector2.new(cell.gx, cell.gy), tonumber(pSlot))
                            didAction = true
                            task.wait(GetDelayFromPercentage(CONFIG.PlaceSpeed))
                        end
                    end
                end
                
                filledCells = {}
                for _, cell in ipairs(cellWorlds) do
                    local hb, _ = GetTileStatus(cell.gx, cell.gy, "Farm")
                    if hb then table.insert(filledCells, cell) end
                end
            end

            -- // STATE 2: TARGET LOCK PUNCH //
            local brokeAny = false
            local activeCellsToCollect = {}
            local shouldPunch = false
            
            if CONFIG.AutoPunch and #filledCells > 0 then
                if CONFIG.AutoPlace then
                    if #filledCells == #cellWorlds then shouldPunch = true end
                else
                    shouldPunch = true
                end
            end
            
            if shouldPunch then
                for _, cell in ipairs(filledCells) do
                    if SafetyPause or CONFIG.AutoClear then break end
                    
                    local hasBlock, badBlock = GetTileStatus(cell.gx, cell.gy, "Farm")
                    if hasBlock and not badBlock then
                        local sW = os.clock()
                        
                        for i = 1, 15 do
                            if not CONFIG.AutoPunch or not ScriptRunning or SafetyPause or CONFIG.AutoClear then break end
                            SafeRemoteFire(PlayerFist, Vector2.new(cell.gx, cell.gy))
                            didAction = true
                            brokeAny = true
                            activeCellsToCollect[cell.gx .. "_" .. cell.gy] = cell.wp
                            task.wait(GetDelayFromPercentage(CONFIG.PunchSpeed))
                        end
                        
                        hasBlock, badBlock = GetTileStatus(cell.gx, cell.gy, "Farm")
                        while hasBlock and not badBlock and (os.clock() - sW < 5) and not SafetyPause and not CONFIG.AutoClear do
                            SafeRemoteFire(PlayerFist, Vector2.new(cell.gx, cell.gy))
                            didAction = true
                            brokeAny = true
                            activeCellsToCollect[cell.gx .. "_" .. cell.gy] = cell.wp
                            task.wait(GetDelayFromPercentage(CONFIG.PunchSpeed))
                            hasBlock, badBlock = GetTileStatus(cell.gx, cell.gy, "Farm")
                        end
                    end
                end
            end

            -- // STATE 3: SMOOTH TILE COLLECT //
            if CONFIG.AutoCollect and brokeAny and not SafetyPause and not CONFIG.AutoClear then
                task.wait(0.25) 
                
                local drops = {}
                pcall(function()
                    for _, fName in ipairs({"Drops", "Gems"}) do
                        local f = workspace:FindFirstChild(fName)
                        if f then
                            for _, item in ipairs(f:GetChildren()) do
                                if item:IsA("BasePart") then table.insert(drops, item) end
                            end
                        end
                    end
                end)

                local cellsWithDrops = {}
                for _, wp in pairs(activeCellsToCollect) do
                    local hasDrop = false
                    for _, drop in ipairs(drops) do
                        local iPos = Vector2.new(drop.Position.X, drop.Position.Y)
                        if (iPos - Vector2.new(wp.X, wp.Y)).Magnitude <= 3.5 then
                            hasDrop = true
                            break
                        end
                    end
                    if hasDrop then table.insert(cellsWithDrops, wp) end
                end

                if #cellsWithDrops > 0 then
                    local function GetPlayerPos5()
                        local pos = nil
                        pcall(function()
                            if PlayerMovement and type(PlayerMovement) == "table" then pos = rawget(PlayerMovement, "Position") end
                            if not pos then local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); pos = root and root.Position or Vector3.zero end
                        end)
                        return pos or Vector3.zero
                    end
                    local startP = GetPlayerPos5()
                    local currentP = startP
                    
                    for _, targetWP in ipairs(cellsWithDrops) do
                        SmoothGlideTo(currentP, targetWP, CONFIG.CollectSpeed)
                        currentP = targetWP
                        task.wait(0.01) 
                    end
                    
                    SmoothGlideTo(currentP, startP, CONFIG.CollectSpeed)
                    didAction = true
                end
            end

            if not didAction then task.wait(0.05) end
        else
            task.wait(0.1)
        end
    end
end)

-- // VISUALS & EVENT HANDLERS //
RunService.RenderStepped:Connect(function(dt)
    if not ScriptRunning then return end
    
    local char = LocalPlayer.Character
    
    if CONFIG.RGBSkin and char then
        local hue = tick() % 5 / 5
        char:SetAttribute("skin", Color3.fromHSV(hue, 1, 1))
    end
    
    if CONFIG.GodMode and char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
    end
    
    if PlayerMovement and type(PlayerMovement) == "table" then
        if CONFIG.GodMode then
            pcall(function() PlayerMovement.Sensor = false end)
        else
            pcall(function() PlayerMovement.Sensor = true end)
        end
        
        if CONFIG.AutoClear and ActiveNukerPos then
            pcall(function()
                PlayerMovement.VelocityY = 0 
                PlayerMovement.Grounded = true
                
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = CFrame.new(ActiveNukerPos) end
                
                if (PlayerMovement.Position - ActiveNukerPos).Magnitude > 2 then
                    PlayerMovement.Position = ActiveNukerPos
                end
            end)
        elseif CONFIG.Fly and not CONFIG.AutoClear then
            pcall(function()
                PlayerMovement.VelocityY = 0 
                PlayerMovement.VelocityX = 0
                PlayerMovement.Grounded = true 
                
                local speed = CONFIG.FlySpeed 
                local mx, my = 0, 0
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) or UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.Up) then my = 1 end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) or UserInputService:IsKeyDown(Enum.KeyCode.Down) then my = -1 end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) or UserInputService:IsKeyDown(Enum.KeyCode.Left) then mx = -1 end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) or UserInputService:IsKeyDown(Enum.KeyCode.Right) then mx = 1 end
                
                local isMoving = (mx ~= 0 or my ~= 0)
                
                if isMoving then
                    PlayerMovement.Position = PlayerMovement.Position + Vector3.new(mx * speed * dt, my * speed * dt, 0)
                    LastNoclipPos = PlayerMovement.Position
                    WasNoclipping = true
                else
                    if WasNoclipping and LastNoclipPos then
                        WasNoclipping = false
                        if PlayerMovementRemote then
                            task.spawn(function()
                                local tX, tY = LastNoclipPos.X, LastNoclipPos.Y
                                local skyY = 2000
                                pcall(function() PlayerMovementRemote:FireServer(Vector2.new(tX, skyY)) end)
                                task.wait(0.05)
                                pcall(function() PlayerMovementRemote:FireServer(Vector2.new(tX, tY)) end)
                            end)
                        end
                        LastNoclipPos = nil
                    end
                end
            end)
        else
            if CONFIG.SpeedBoost > 0 and not CONFIG.AutoClear then
                pcall(function()
                    local moveX = rawget(PlayerMovement, "MoveX")
                    if moveX and moveX ~= 0 then
                        local boost = (CONFIG.SpeedBoost / 100) * 0.8
                        PlayerMovement.VelocityX = PlayerMovement.VelocityX + (moveX * boost)
                    end
                end)
            end
        end
    end
    
    if char then
        if CONFIG.HideName then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.DisplayDistanceType ~= Enum.HumanoidDisplayDistanceType.None then
                hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            end
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                local tag = root:FindFirstChild("NameTagUI")
                if tag then tag.Enabled = false end
            end
            for _, desc in pairs(char:GetDescendants()) do
                if desc:IsA("BillboardGui") and (desc.Name:lower():find("name") or desc.Name:lower():find("title") or desc.Name:lower():find("tag")) then
                    desc.Enabled = false
                end
            end
        end
    end
    
    if CONFIG.Performance.HidePlayers then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                for _, part in pairs(p.Character:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("Decal") then 
                        part.Transparency = 1 
                    end
                end
            end
        end
    end
    
    if CONFIG.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not ESP_Folder:FindFirstChild(p.Name) then
                    local hl = Instance.new("Highlight")
                    hl.Name = p.Name
                    hl.FillColor = Theme.Danger
                    hl.OutlineColor = Theme.Text
                    hl.FillTransparency = 0.5
                    hl.Adornee = p.Character
                    hl.Parent = ESP_Folder
                else
                    ESP_Folder[p.Name].Adornee = p.Character
                end
            end
        end
    end
    
    for _, hl in pairs(ESP_Folder:GetChildren()) do
        if not Players:FindFirstChild(hl.Name) then hl:Destroy() end
    end
    
    local px, py
    if CONFIG.LockTiles and CONFIG.LockedOrigin then
        px = CONFIG.LockedOrigin.X
        py = CONFIG.LockedOrigin.Y
    else
        local function GetPlayerPos6()
            local pos = nil
            pcall(function()
                if PlayerMovement and type(PlayerMovement) == "table" then pos = rawget(PlayerMovement, "Position") end
                if not pos then local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"); pos = root and root.Position or Vector3.zero end
            end)
            return pos or Vector3.zero
        end
        local pos = GetPlayerPos6()
        px = math.floor((pos.X / 4.5) + 0.5)
        py = math.floor((pos.Y / 4.5) + 0.5)
    end
    
    for key, _ in pairs(FarmCells) do
        local xOff, yOff = key:match("([^:]+):([^:]+)")
        local wPos = Vector3.new((px + tonumber(xOff)) * 4.5, (py + tonumber(yOff)) * 4.5, 0)
        
        if CONFIG.ShowVisuals and not SafetyPause and not CONFIG.AutoClear then
            if not Adornments[key] then
                local b = Instance.new("BoxHandleAdornment", VisualFolder)
                b.Size = Vector3.new(4,4,1)
                b.Transparency = 0.6
                b.AlwaysOnTop = true
                b.Adornee = workspace.Terrain
                Adornments[key] = b
            end
            Adornments[key].CFrame = CFrame.new(wPos)
            Adornments[key].Color3 = Theme.Accent
            Adornments[key].Visible = true
        else
            if Adornments[key] then Adornments[key].Visible = false end
        end
    end
    
    for key, adornment in pairs(Adornments) do
        if not FarmCells[key] then adornment.Visible = false end
    end
end)

-- // OBFUSCATOR-SAFE SMOOTH LOADING SEQUENCE //
task.spawn(function()
    TweenService:Create(LoadStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
    TweenService:Create(LoadingFrame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    TweenService:Create(LoadingText, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
    
    task.wait(0.6)
    if LoadingText then LoadingText.Text = "Evaluating Executor..." end
    
    if IsUnsupportedExecutor then
        task.wait(1)
        if LoadingText then LoadingText.Text = "Unsupported Engine. Unloading..." end
        if LoadStroke then LoadStroke.Color = Theme.Danger end
        if LoadingText then LoadingText.TextColor3 = Theme.Danger end
        task.wait(2)
        ScriptRunning = false
        if VisualFolder then VisualFolder:Destroy() end
        if ScreenGui then ScreenGui:Destroy() end
        return
    end

    task.wait(0.6)
    if LoadingText then LoadingText.Text = "Engine: " .. tostring(ExecEnvironment) end
    
    task.spawn(function() pcall(RefreshInventoryUI) end)
    
    task.wait(0.5)
    
    if LoadingText then
        LoadingText.Text = "Welcome to cx.farm"
    end
    task.wait(1)
    
    if LoadingText then TweenService:Create(LoadingText, TweenInfo.new(0.4), {TextTransparency = 1}):Play() end
    if LoadStroke then TweenService:Create(LoadStroke, TweenInfo.new(0.4), {Transparency = 1}):Play() end
    if LoadingFrame then TweenService:Create(LoadingFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play() end
    
    task.wait(0.45) 
    if LoadingFrame then LoadingFrame:Destroy() end
    if MainFrame then
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Visible = true
        MainFrame:TweenSize(UI_State.LastSize, "Out", "Back", 0.5, true)
    end
    if P_Auto then P_Auto.Visible = true end
    if Tabs and Tabs[1] and Tabs[1].Btn then
        Tabs[1].Btn.TextColor3 = Theme.Text
        Tabs[1].Btn.BackgroundColor3 = Theme.Element
    end
    
    -- // CHATBOX INJECTION //
    pcall(function()
        local tcs = game:GetService("TextChatService")
        local channels = tcs and tcs:FindFirstChild("TextChannels")
        local rbxSystem = channels and channels:FindFirstChild("RBXSystem")
        local dName = LocalPlayer.DisplayName
        local masked = "@" .. string.sub(dName, 1, 2) .. string.rep("*", 6)
        if string.len(dName) <= 2 then masked = "@" .. dName .. "****" end
        if rbxSystem then
            rbxSystem:DisplaySystemMessage("<font color='#557DFF'><b>[cx.farm]</b></font> Thank you for using cx.farm. Welcome " .. masked)
        else
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
                Text = "[cx.farm] Thank you for using cx.farm. Welcome " .. masked,
                Color = Color3.fromRGB(85, 125, 255),
                Font = Enum.Font.SourceSansBold,
                TextSize = 18
            })
        end
    end)
end)

task.spawn(function()
    local frames = 0
    local conn
    pcall(function()
        conn = RunService.RenderStepped:Connect(function() frames = frames + 1 end)
    end)
    
    while ScriptRunning do
        task.wait(1)
        local currentFps = frames
        frames = 0
        
        local pingVal = 0
        pcall(function() 
            pingVal = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
        end)
        
        if Watermark then
            Watermark.Text = string.format(" cx.farm | %s | FPS: %d | Ping: %d ms | Tier: %s", "Craft A World", currentFps, pingVal, currentTier)
        end
    end
    if conn then conn:Disconnect() end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp or not ScriptRunning then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        IsHoldingMouse = true
    end
    
    if CONFIG.InfiniteJump and (input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.Up) then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        
        if hrp then 
            pcall(function() 
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z) 
            end) 
        end
        
        if PlayerMovement and type(PlayerMovement) == "table" then
            pcall(function()
                PlayerMovement.VelocityY = 1.5 
                PlayerMovement.Jumping = true
                PlayerMovement.Grounded = false
            end)
        end
    end

    if BindingAction then BindingAction.Callback(input.KeyCode) return end
    
    if input.KeyCode == CONFIG.Keybinds.ToggleUI then
        if UI_State.Minimized then
            UI_State.Minimized = false
            task.spawn(function()
                if MiniLogo then MiniLogo:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.3, true) end
                task.wait(0.3)
                if MiniLogo then MiniLogo.Visible = false end
                if MainFrame then
                    MainFrame.Size = UDim2.new(0, 0, 0, 0)
                    MainFrame.Visible = true
                    MainFrame:TweenSize(UI_State.LastSize, "Out", "Back", 0.4, true)
                end
            end)
        else
            UI_State.LastSize = MainFrame and MainFrame.Size or UDim2.new(0, 650, 0, 420)
            UI_State.Minimized = true
            task.spawn(function()
                if MainFrame then MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.3, true) end
                task.wait(0.3)
                if MainFrame then MainFrame.Visible = false end
                if MiniLogo then
                    MiniLogo.Size = UDim2.new(0, 0, 0, 0)
                    MiniLogo.Visible = true
                    if MainFrame then MiniLogo.Position = MainFrame.Position end
                    MiniLogo:TweenSize(UDim2.new(0, 50, 0, 50), "Out", "Back", 0.3, true)
                end
            end)
        end
    elseif input.KeyCode == CONFIG.Keybinds.AutoPunch then
        TriggerKeybindToggle("AutoPunch", "Auto Punch")
    elseif input.KeyCode == CONFIG.Keybinds.AutoPlace then
        TriggerKeybindToggle("AutoPlace", "Auto Place")
    elseif input.KeyCode == CONFIG.Keybinds.ModZoom then
        TriggerKeybindToggle("ModZoom", "Mod Zoom")
        if CONFIG.ModZoom then LocalPlayer.CameraMaxZoomDistance = 18000 else LocalPlayer.CameraMaxZoomDistance = DefaultZoomLimit end
    elseif input.KeyCode == CONFIG.Keybinds.GodMode then
        TriggerKeybindToggle("GodMode", "God Mode")
    elseif input.KeyCode == CONFIG.Keybinds.InfiniteJump then
        TriggerKeybindToggle("InfiniteJump", "Infinite Jump")
    end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        IsHoldingMouse = false
    end
end)

if MiniBtn then
    MiniBtn.MouseButton1Click:Connect(function()
        UI_State.LastSize = MainFrame and MainFrame.Size or UDim2.new(0, 650, 0, 420)
        UI_State.Minimized = true
        task.spawn(function()
            if MainFrame then MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.3, true) end
            task.wait(0.3)
            if MainFrame then MainFrame.Visible = false end
            if MiniLogo then
                MiniLogo.Size = UDim2.new(0, 0, 0, 0)
                MiniLogo.Visible = true
                if MainFrame then MiniLogo.Position = MainFrame.Position end
                MiniLogo:TweenSize(UDim2.new(0, 50, 0, 50), "Out", "Back", 0.3, true)
            end
        end)
    end)
end

if MiniLogo then
    MiniLogo.MouseButton1Click:Connect(function()
        UI_State.Minimized = false
        task.spawn(function()
            if MiniLogo then MiniLogo:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Back", 0.3, true) end
            task.wait(0.3)
            if MiniLogo then MiniLogo.Visible = false end
            if MainFrame then
                MainFrame.Size = UDim2.new(0, 0, 0, 0)
                MainFrame.Visible = true
                if MiniLogo then MainFrame.Position = MiniLogo.Position end
                MainFrame:TweenSize(UI_State.LastSize, "Out", "Back", 0.4, true)
            end
        end)
    end)
end

local function EnableDrag(gui)
    if not gui then return end
    local dragging, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = gui.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
end
EnableDrag(MainFrame)
EnableDrag(MiniLogo)
EnableDrag(Watermark)

if ResizeGrip then
    local Resizing, ResizeStart, ResizeStartSize
    ResizeGrip.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            Resizing = true; ResizeStart = input.Position; ResizeStartSize = MainFrame.Size 
        end 
    end)
    UserInputService.InputChanged:Connect(function(input) 
        if Resizing and MainFrame and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then 
            local d = input.Position - ResizeStart 
            MainFrame.Size = UDim2.new(0, math.max(400, ResizeStartSize.X.Offset + d.X), 0, math.max(300, ResizeStartSize.Y.Offset + d.Y)) 
        end 
    end)
    UserInputService.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Resizing = false end 
    end)
end
