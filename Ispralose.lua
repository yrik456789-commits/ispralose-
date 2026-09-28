-- ======================================================
-- Isparlose Hub | Advanced Visuals, ESP & Misc (v3.0)
-- ======================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Конфигурация
local Config = {
    -- Visuals / ESP
    OutlineESP = false,
    OutlineTeammates = false,
    
    BoxESP = false,
    BoxTeammates = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    ShowHP = true,
    ShowWeapon = true,
    
    ArrowsESP = false,
    ArrowEnemies = true, -- Подвкладка стрелочек на противников
    ArrowColor = Color3.fromRGB(50, 50, 55),
    ArrowRadius = 180,
    
    BulletTracers = false,
    TracerColorIndex = 1,
    TracerColors = {
        Color3.fromRGB(0, 255, 255),   -- Cyan
        Color3.fromRGB(255, 50, 50),   -- Red
        Color3.fromRGB(50, 255, 100),  -- Green
        Color3.fromRGB(180, 50, 255),  -- Purple
        Color3.fromRGB(255, 220, 0)    -- Yellow
    },
    TracerColorNames = {"Neon Cyan", "Neon Red", "Neon Green", "Neon Purple", "Neon Yellow"},

    -- Misc
    AntiMolotov = false,
    Noclip = false
}

-- Выбор родителя (CoreGui / PlayerGui)
local ParentGui = CoreGui
pcall(function()
    if not CoreGui then end
end)
if not ParentGui then
    ParentGui = LocalPlayer:WaitForChild("PlayerGui")
end

if ParentGui:FindFirstChild("IsparloseGui") then
    ParentGui.IsparloseGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IsparloseGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = ParentGui

local UI_SIZE = UDim2.new(0, 560, 0, 380)
local UI_POS = UDim2.new(0.5, -280, 0.5, -190)

----------------------------------------------------
-- 1. ИНТРО (INTRO FRAME)
----------------------------------------------------
local IntroFrame = Instance.new("Frame")
IntroFrame.Name = "IntroFrame"
IntroFrame.Size = UI_SIZE
IntroFrame.Position = UI_POS
IntroFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
IntroFrame.BorderSizePixel = 0
IntroFrame.ClipsDescendants = true
IntroFrame.Parent = ScreenGui

local IntroCorner = Instance.new("UICorner")
IntroCorner.CornerRadius = UDim.new(0, 10)
IntroCorner.Parent = IntroFrame

local IntroStroke = Instance.new("UIStroke")
IntroStroke.Color = Color3.fromRGB(110, 86, 207)
IntroStroke.Thickness = 1.5
IntroStroke.Transparency = 0.2
IntroStroke.Parent = IntroFrame

local IntroTitle = Instance.new("TextLabel")
IntroTitle.Size = UDim2.new(1, 0, 0, 60)
IntroTitle.Position = UDim2.new(0, 0, 0.33, 0)
IntroTitle.BackgroundTransparency = 1
IntroTitle.Text = "I S P A R L O S E"
IntroTitle.Font = Enum.Font.GothamBold
IntroTitle.TextSize = 34
IntroTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
IntroTitle.TextTransparency = 1
IntroTitle.Parent = IntroFrame

local IntroSub = Instance.new("TextLabel")
IntroSub.Size = UDim2.new(1, 0, 0, 20)
IntroSub.Position = UDim2.new(0, 0, 0.50, 0)
IntroSub.BackgroundTransparency = 1
IntroSub.Text = "INITIALIZING SYSTEM..."
IntroSub.Font = Enum.Font.GothamMedium
IntroSub.TextSize = 12
IntroSub.TextColor3 = Color3.fromRGB(160, 160, 180)
IntroSub.TextTransparency = 1
IntroSub.Parent = IntroFrame

local ProgressBarBg = Instance.new("Frame")
ProgressBarBg.Size = UDim2.new(0.6, 0, 0, 4)
ProgressBarBg.Position = UDim2.new(0.2, 0, 0.65, 0)
ProgressBarBg.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ProgressBarBg.BorderSizePixel = 0
ProgressBarBg.BackgroundTransparency = 1
ProgressBarBg.Parent = IntroFrame

local ProgressBarBgCorner = Instance.new("UICorner")
ProgressBarBgCorner.CornerRadius = UDim.new(1, 0)
ProgressBarBgCorner.Parent = ProgressBarBg

local ProgressBarFill = Instance.new("Frame")
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
ProgressBarFill.BackgroundColor3 = Color3.fromRGB(110, 86, 207)
ProgressBarFill.BorderSizePixel = 0
ProgressBarFill.Parent = ProgressBarBg

local ProgressBarFillCorner = Instance.new("UICorner")
ProgressBarFillCorner.CornerRadius = UDim.new(1, 0)
ProgressBarFillCorner.Parent = ProgressBarFill

----------------------------------------------------
-- 2. ГЛАВНОЕ МЕНЮ (MAIN FRAME)
----------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UI_SIZE
MainFrame.Position = UI_POS
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 60)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Topbar
local Topbar = Instance.new("Frame")
Topbar.Size = UDim2.new(1, 0, 0, 40)
Topbar.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
Topbar.BorderSizePixel = 0
Topbar.Parent = MainFrame

local TopbarCorner = Instance.new("UICorner")
TopbarCorner.CornerRadius = UDim.new(0, 10)
TopbarCorner.Parent = Topbar

local TopbarTitle = Instance.new("TextLabel")
TopbarTitle.Position = UDim2.new(0, 15, 0, 0)
TopbarTitle.Size = UDim2.new(0, 250, 1, 0)
TopbarTitle.BackgroundTransparency = 1
TopbarTitle.Text = "ISPARLOSE  |  HUB"
TopbarTitle.Font = Enum.Font.GothamBold
TopbarTitle.TextSize = 13
TopbarTitle.TextColor3 = Color3.fromRGB(240, 240, 250)
TopbarTitle.TextXAlignment = Enum.TextXAlignment.Left
TopbarTitle.Parent = Topbar

-- Dragging
local dragging, dragInput, dragStart, startPos
Topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
Topbar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Sidebar & Tabs
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 17)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(0, 1, 1, -40)
Divider.Position = UDim2.new(0, 140, 0, 40)
Divider.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Divider.BorderSizePixel = 0
Divider.Parent = MainFrame

local ContentPanel = Instance.new("Frame")
ContentPanel.Size = UDim2.new(1, -141, 1, -40)
ContentPanel.Position = UDim2.new(0, 141, 0, 40)
ContentPanel.BackgroundTransparency = 1
ContentPanel.Parent = MainFrame

-- Scrolling Frames
local VisualsScroll = Instance.new("ScrollingFrame")
VisualsScroll.Size = UDim2.new(1, -20, 1, -20)
VisualsScroll.Position = UDim2.new(0, 10, 0, 10)
VisualsScroll.BackgroundTransparency = 1
VisualsScroll.BorderSizePixel = 0
VisualsScroll.ScrollBarThickness = 3
VisualsScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
VisualsScroll.CanvasSize = UDim2.new(0, 0, 0, 560)
VisualsScroll.Visible = true
VisualsScroll.Parent = ContentPanel

local VisualsLayout = Instance.new("UIListLayout")
VisualsLayout.SortOrder = Enum.SortOrder.LayoutOrder
VisualsLayout.Padding = UDim.new(0, 8)
VisualsLayout.Parent = VisualsScroll

local MiscScroll = Instance.new("ScrollingFrame")
MiscScroll.Size = UDim2.new(1, -20, 1, -20)
MiscScroll.Position = UDim2.new(0, 10, 0, 10)
MiscScroll.BackgroundTransparency = 1
MiscScroll.BorderSizePixel = 0
MiscScroll.ScrollBarThickness = 3
MiscScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
MiscScroll.CanvasSize = UDim2.new(0, 0, 0, 300)
MiscScroll.Visible = false
MiscScroll.Parent = ContentPanel

local MiscLayout = Instance.new("UIListLayout")
MiscLayout.SortOrder = Enum.SortOrder.LayoutOrder
MiscLayout.Padding = UDim.new(0, 8)
MiscLayout.Parent = MiscScroll

-- Кнопки вкладок
local TabVisualsBtn = Instance.new("TextButton")
TabVisualsBtn.Size = UDim2.new(1, -20, 0, 36)
TabVisualsBtn.Position = UDim2.new(0, 10, 0, 10)
TabVisualsBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
TabVisualsBtn.Text = "  VISUALS / ESP"
TabVisualsBtn.Font = Enum.Font.GothamBold
TabVisualsBtn.TextSize = 11
TabVisualsBtn.TextColor3 = Color3.fromRGB(110, 86, 207)
TabVisualsBtn.TextXAlignment = Enum.TextXAlignment.Left
TabVisualsBtn.AutoButtonColor = false
TabVisualsBtn.Parent = Sidebar

local TabVisualsCorner = Instance.new("UICorner")
TabVisualsCorner.CornerRadius = UDim.new(0, 6)
TabVisualsCorner.Parent = TabVisualsBtn

local TabMiscBtn = Instance.new("TextButton")
TabMiscBtn.Size = UDim2.new(1, -20, 0, 36)
TabMiscBtn.Position = UDim2.new(0, 10, 0, 54)
TabMiscBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
TabMiscBtn.Text = "  MISC"
TabMiscBtn.Font = Enum.Font.GothamBold
TabMiscBtn.TextSize = 11
TabMiscBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
TabMiscBtn.TextXAlignment = Enum.TextXAlignment.Left
TabMiscBtn.AutoButtonColor = false
TabMiscBtn.Parent = Sidebar

local TabMiscCorner = Instance.new("UICorner")
TabMiscCorner.CornerRadius = UDim.new(0, 6)
TabMiscCorner.Parent = TabMiscBtn

TabVisualsBtn.MouseButton1Click:Connect(function()
    VisualsScroll.Visible = true
    MiscScroll.Visible = false
    TabVisualsBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    TabVisualsBtn.TextColor3 = Color3.fromRGB(110, 86, 207)
    TabMiscBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    TabMiscBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
end)

TabMiscBtn.MouseButton1Click:Connect(function()
    VisualsScroll.Visible = false
    MiscScroll.Visible = true
    TabMiscBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    TabMiscBtn.TextColor3 = Color3.fromRGB(110, 86, 207)
    TabVisualsBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
    TabVisualsBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
end)

----------------------------------------------------
-- КОМПОНЕНТЫ ИНТЕРФЕЙСА
----------------------------------------------------
local function createSection(parent, titleText)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, 0, 0, 24)
    section.BackgroundTransparency = 1
    section.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = string.upper(titleText)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11
    label.TextColor3 = Color3.fromRGB(110, 86, 207)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = section
    
    return section
end

local function createToggle(parent, text, defaultState, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 36)
    card.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    card.BorderSizePixel = 0
    card.Parent = parent
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(220, 220, 230)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card
    
    local switchBg = Instance.new("TextButton")
    switchBg.Size = UDim2.new(0, 36, 0, 18)
    switchBg.Position = UDim2.new(1, -46, 0.5, -9)
    switchBg.BackgroundColor3 = defaultState and Color3.fromRGB(110, 86, 207) or Color3.fromRGB(40, 40, 52)
    switchBg.Text = ""
    switchBg.AutoButtonColor = false
    switchBg.Parent = card
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBg
    
    local switchDot = Instance.new("Frame")
    switchDot.Size = UDim2.new(0, 12, 0, 12)
    switchDot.Position = defaultState and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
    switchDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    switchDot.BorderSizePixel = 0
    switchDot.Parent = switchBg
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = switchDot
    
    local state = defaultState
    switchBg.MouseButton1Click:Connect(function()
        state = not state
        local targetBg = state and Color3.fromRGB(110, 86, 207) or Color3.fromRGB(40, 40, 52)
        local targetDotPos = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetBg}):Play()
        TweenService:Create(switchDot, TweenInfo.new(0.2), {Position = targetDotPos}):Play()
        
        callback(state)
    end)
    
    return card
end

local function createButton(parent, text, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 36)
    card.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
    card.BorderSizePixel = 0
    card.Parent = parent
    
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = card
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(220, 220, 230)
    btn.Parent = card
    
    btn.MouseButton1Click:Connect(function()
        callback(btn)
    end)
    
    return card
end

----------------------------------------------------
-- НАПОЛНЕНИЕ ВКЛАДОК
----------------------------------------------------
-- Visuals Tab
createSection(VisualsScroll, "1. Outline ESP")
createToggle(VisualsScroll, "Enable Outline ESP", Config.OutlineESP, function(val) Config.OutlineESP = val end)
createToggle(VisualsScroll, "   └─ Show Teammates Outline", Config.OutlineTeammates, function(val) Config.OutlineTeammates = val end)

createSection(VisualsScroll, "2. Boxes ESP")
createToggle(VisualsScroll, "Enable Boxes ESP", Config.BoxESP, function(val) Config.BoxESP = val end)
createToggle(VisualsScroll, "   └─ Show Teammates Boxes", Config.BoxTeammates, function(val) Config.BoxTeammates = val end)
createToggle(VisualsScroll, "   └─ Show HP Bar (Left Green->Red)", Config.ShowHP, function(val) Config.ShowHP = val end)
createToggle(VisualsScroll, "   └─ Show Weapon Name (Bottom)", Config.ShowWeapon, function(val) Config.ShowWeapon = val end)

createSection(VisualsScroll, "3. Directional Arrows")
createToggle(VisualsScroll, "Enable Offscreen Arrows", Config.ArrowsESP, function(val) Config.ArrowsESP = val end)
createToggle(VisualsScroll, "   └─ Show Enemies Arrows", Config.ArrowEnemies, function(val) Config.ArrowEnemies = val end)

createSection(VisualsScroll, "4. Bullet Tracers")
createToggle(VisualsScroll, "Enable Bullet Tracers", Config.BulletTracers, function(val) Config.BulletTracers = val end)
createButton(VisualsScroll, "   └─ Tracer Color: [ Neon Cyan ]", function(btn)
    Config.TracerColorIndex = Config.TracerColorIndex % #Config.TracerColors + 1
    btn.Text = "   └─ Tracer Color: [ " .. Config.TracerColorNames[Config.TracerColorIndex] .. " ]"
end)

-- Misc Tab
createSection(MiscScroll, "1. Player Modifications")
createToggle(MiscScroll, "No Molotov Damage", Config.AntiMolotov, function(val) Config.AntiMolotov = val end)
createToggle(MiscScroll, "Noclip", Config.Noclip, function(val) Config.Noclip = val end)

----------------------------------------------------
-- 3. ИНТРО АНИМАЦИЯ
----------------------------------------------------
task.spawn(function()
    TweenService:Create(IntroTitle, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    task.wait(0.3)
    TweenService:Create(IntroSub, TweenInfo.new(0.8), {TextTransparency = 0}):Play()
    TweenService:Create(ProgressBarBg, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
    
    TweenService:Create(ProgressBarFill, TweenInfo.new(1.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    task.wait(1.5)
    
    TweenService:Create(IntroTitle, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(IntroSub, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(ProgressBarBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(ProgressBarFill, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    task.wait(0.3)
    
    IntroFrame:Destroy()
    
    MainFrame.Visible = true
    MainFrame.BackgroundTransparency = 1
    MainFrame.Size = UDim2.new(0, 540, 0, 360)
    MainFrame.Position = UDim2.new(0.5, -270, 0.5, -180)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UI_SIZE,
        Position = UI_POS,
        BackgroundTransparency = 0
    }):Play()
end)

----------------------------------------------------
-- 4. ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
----------------------------------------------------
local EspFolder = Instance.new("Folder")
EspFolder.Name = "IsparloseESP"
EspFolder.Parent = ScreenGui

local function isTeammate(player)
    if not player or player == LocalPlayer then return false end
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team == player.Team
    end
    return false
end

local function getEquippedWeaponName(player)
    local char = player.Character
    if not char then return "None" end
    
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then return tool.Name end
    
    local equippedVal = char:FindFirstChild("EquippedWeapon") or char:FindFirstChild("EquippedTool") or char:FindFirstChild("CurrentWeapon")
    if equippedVal then
        if equippedVal:IsA("StringValue") or equippedVal:IsA("ObjectValue") then
            return tostring(equippedVal.Value)
        end
    end
    
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child.Name ~= "Head" then
            if child:FindFirstChildOfClass("BasePart") or child:FindFirstChildOfClass("MeshPart") then
                return child.Name
            end
        end
    end
    
    return "Primary / Knife"
end

----------------------------------------------------
-- 5. ТРЕЙСЕРЫ ПУЛЬ С АДАПТАЦИЕЙ ПОД ПИНГ
----------------------------------------------------
local function createTracer(fromPos, toPos)
    if not Config.BulletTracers then return end
    
    -- Расчет текущего пинга
    local ping = 0.04
    pcall(function()
        ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    end)
    
    local distance = (toPos - fromPos).Magnitude
    local tracerPart = Instance.new("Part")
    tracerPart.Name = "IsparloseTracer"
    tracerPart.Anchored = true
    tracerPart.CanCollide = false
    tracerPart.Material = Enum.Material.Neon
    tracerPart.Color = Config.TracerColors[Config.TracerColorIndex]
    tracerPart.Transparency = 0.1
    tracerPart.Size = Vector3.new(0.12, 0.12, distance)
    
    -- Позиционирование 3D-линии
    tracerPart.CFrame = CFrame.new(fromPos:Lerp(toPos, 0.5), toPos)
    tracerPart.Parent = workspace
    
    -- Плавное угасание с учетом пинга
    local duration = 0.35 + math.clamp(ping, 0, 0.3)
    TweenService:Create(tracerPart, TweenInfo.new(duration), {
        Transparency = 1,
        Size = Vector3.new(0.01, 0.01, distance)
    }):Play()
    
    task.delay(duration + 0.05, function()
        tracerPart:Destroy()
    end)
end

-- Отслеживание выстрела
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Config.BulletTracers then
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildOfClass("Tool")
            if tool or char:FindFirstChild("EquippedWeapon") then
                local mouse = LocalPlayer:GetMouse()
                local muzzlePos = Camera.CFrame.Position - Vector3.new(0, 0.4, 0)
                if char:FindFirstChild("HumanoidRootPart") then
                    muzzlePos = char.HumanoidRootPart.Position + (Camera.CFrame.LookVector * 2)
                end
                createTracer(muzzlePos, mouse.Hit.Position)
            end
        end
    end
end)

----------------------------------------------------
-- 6. ЛОГИКА MISC (NO MOLOTOV & NOCLIP)
----------------------------------------------------
-- No Molotov Damage
RunService.Heartbeat:Connect(function()
    if Config.AntiMolotov then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("TouchTransmitter") and obj.Parent then
                local pName = obj.Parent.Name:lower()
                if pName:find("fire") or pName:find("molotov") or pName:find("flame") or pName:find("ignite") then
                    obj.Parent.CanTouch = false
                end
            end
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if Config.Noclip and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

----------------------------------------------------
-- 7. МЕНЕДЖЕР ESP И ОБНОВЛЕНИЕ КАДРА
----------------------------------------------------
local espElements = {}

local function createEspBox(player)
    local boxFrame = Instance.new("Frame")
    boxFrame.Name = "Box_" .. player.Name
    boxFrame.BackgroundTransparency = 1
    boxFrame.BorderSizePixel = 0
    boxFrame.Visible = false
    boxFrame.Parent = EspFolder

    local boxOutline = Instance.new("UIStroke")
    boxOutline.Color = Color3.fromRGB(255, 255, 255)
    boxOutline.Thickness = 1.5
    boxOutline.Parent = boxFrame

    -- Полоска HP
    local hpBg = Instance.new("Frame")
    hpBg.Name = "HpBg"
    hpBg.Size = UDim2.new(0, 3, 1, 0)
    hpBg.Position = UDim2.new(0, -6, 0, 0)
    hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    hpBg.BorderSizePixel = 0
    hpBg.Parent = boxFrame

    local hpFill = Instance.new("Frame")
    hpFill.Name = "HpFill"
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.Position = UDim2.new(0, 0, 0, 0)
    hpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBg

    -- Оружие
    local weaponLabel = Instance.new("TextLabel")
    weaponLabel.Name = "WeaponLabel"
    weaponLabel.Size = UDim2.new(1, 40, 0, 14)
    weaponLabel.Position = UDim2.new(0, -20, 1, 3)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Font = Enum.Font.GothamBold
    weaponLabel.TextSize = 10
    weaponLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    weaponLabel.TextStrokeTransparency = 0.3
    weaponLabel.Text = ""
    weaponLabel.Parent = boxFrame

    -- Объемная перевернутая стрелочка
    local arrow = Instance.new("ImageLabel")
    arrow.Name = "Arrow_" .. player.Name
    arrow.Size = UDim2.new(0, 34, 0, 34)
    arrow.AnchorPoint = Vector2.new(0.5, 0.5)
    arrow.BackgroundTransparency = 1
    arrow.Image = "rbxassetid://6034818372"
    arrow.ImageColor3 = Config.ArrowColor
    arrow.Visible = false
    arrow.Parent = EspFolder

    local arrowStroke = Instance.new("UIStroke")
    arrowStroke.Color = Color3.fromRGB(15, 15, 20)
    arrowStroke.Thickness = 1.2
    arrowStroke.Parent = arrow

    espElements[player] = {
        Box = boxFrame,
        Outline = boxOutline,
        HpBg = hpBg,
        HpFill = hpFill,
        Weapon = weaponLabel,
        Arrow = arrow
    }
end

local function removeEspBox(player)
    if espElements[player] then
        if espElements[player].Box then espElements[player].Box:Destroy() end
        if espElements[player].Arrow then espElements[player].Arrow:Destroy() end
        espElements[player] = nil
    end
end

Players.PlayerRemoving:Connect(removeEspBox)

local function updateHighlights()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            local isTeam = isTeammate(player)
            
            local shouldShow = Config.OutlineESP and hum and hum.Health > 0 and (not isTeam or Config.OutlineTeammates)
            
            if shouldShow then
                local hl = char:FindFirstChild("IsparloseHighlight")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "IsparloseHighlight"
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.FillTransparency = 0.6
                    hl.OutlineTransparency = 0.1
                    hl.Parent = char
                end
                
                if isTeam then
                    hl.FillColor = Color3.fromRGB(0, 200, 255)
                    hl.OutlineColor = Color3.fromRGB(0, 255, 255)
                else
                    hl.FillColor = Color3.fromRGB(255, 50, 50)
                    hl.OutlineColor = Color3.fromRGB(255, 100, 100)
                end
            else
                local hl = char:FindFirstChild("IsparloseHighlight")
                if hl then hl:Destroy() end
            end
        end
    end
end

-- Рендер кадра
RunService.RenderStepped:Connect(function()
    updateHighlights()
    
    local viewportSize = Camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not espElements[player] then
                createEspBox(player)
            end
            
            local elements = espElements[player]
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local head = char and char:FindFirstChild("Head")
            local isTeam = isTeammate(player)
            
            local isAlive = char and hum and hrp and head and hum.Health > 0
            
            if isAlive then
                -- ФИКСИРОВАННЫЙ BOX ESP (Точная привязка к телу при поворотах камеры)
                local showBox = Config.BoxESP and (not isTeam or Config.BoxTeammates)
                
                if showBox then
                    local headWorldPos = head.Position + Vector3.new(0, 0.6, 0)
                    local feetWorldPos = hrp.Position - Vector3.new(0, 3.0, 0)
                    
                    local headPos, headOnScreen = Camera:WorldToViewportPoint(headWorldPos)
                    local feetPos, feetOnScreen = Camera:WorldToViewportPoint(feetWorldPos)
                    
                    if headPos.Z > 0 then
                        local height = math.abs(feetPos.Y - headPos.Y)
                        local width = height * 0.62
                        
                        elements.Box.Position = UDim2.new(0, headPos.X - (width / 2), 0, headPos.Y)
                        elements.Box.Size = UDim2.new(0, width, 0, height)
                        elements.Box.Visible = true
                        
                        elements.Outline.Color = isTeam and Color3.fromRGB(0, 200, 255) or Config.BoxColor
                        
                        if Config.ShowHP then
                            elements.HpBg.Visible = true
                            local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            elements.HpFill.Size = UDim2.new(1, 0, healthPercent, 0)
                            elements.HpFill.Position = UDim2.new(0, 0, 1 - healthPercent, 0)
                            elements.HpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100):Lerp(Color3.fromRGB(255, 50, 50), 1 - healthPercent)
                        else
                            elements.HpBg.Visible = false
                        end
                        
                        if Config.ShowWeapon then
                            elements.Weapon.Visible = true
                            elements.Weapon.Text = getEquippedWeaponName(player)
                        else
                            elements.Weapon.Visible = false
                        end
                    else
                        elements.Box.Visible = false
                    end
                else
                    elements.Box.Visible = false
                end
                
                -- ПЕРЕВЕРНУТЫЕ ОБЪЕМНЫЕ СТРЕЛКИ НА ПРОТИВНИКОВ
                local showArrow = Config.ArrowsESP and (isTeam or Config.ArrowEnemies)
                
                if showArrow then
                    local camCFrame = Camera.CFrame
                    local targetPos = hrp.Position
                    
                    local dir = (targetPos - camCFrame.Position).Unit
                    local look = camCFrame.LookVector
                    local right = camCFrame.RightVector
                    
                    local dotFwd = look:Dot(dir)
                    local dotRight = right:Dot(dir)
                    
                    local angle = math.atan2(dotRight, dotFwd)
                    local radius = Config.ArrowRadius
                    
                    local arrowX = screenCenter.X + math.sin(angle) * radius
                    local arrowY = screenCenter.Y - math.cos(angle) * radius
                    
                    elements.Arrow.Position = UDim2.new(0, arrowX, 0, arrowY)
                    -- Поворот перевернут (+180 градусов), чтобы стрелочка указывала на цель
                    elements.Arrow.Rotation = math.deg(angle) + 180
                    elements.Arrow.ImageColor3 = isTeam and Color3.fromRGB(0, 180, 255) or Config.ArrowColor
                    elements.Arrow.Visible = true
                else
                    elements.Arrow.Visible = false
                end
            else
                elements.Box.Visible = false
                elements.Arrow.Visible = false
            end
        end
    end
end)
