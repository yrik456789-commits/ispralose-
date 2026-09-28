-- ======================================================
-- Isparlose Hub | Visuals, ESP, Misc & Config System (v3.2 fix)
-- Script Language: Luau (Roblox)
-- ======================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Главный конфиг
local Config = {
    OutlineESP = false,
    OutlineTeammates = false,
    
    BoxESP = false,
    BoxTeammates = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    ShowHP = true,
    ShowWeapon = true,
    
    ArrowsESP = false,
    ArrowEnemies = true,
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

    AntiMolotov = false,
    Noclip = false
}

local SavedConfigs = {}
local SelectedConfigName = nil

-- Родительский GUI
local ParentGui = CoreGui
pcall(function() if not CoreGui then end end)
if not ParentGui then ParentGui = LocalPlayer:WaitForChild("PlayerGui") end

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
-- 1. УВЕДОМЛЕНИЯ ОБ ОШИБКАХ
----------------------------------------------------
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Name = "NotificationFrame"
NotificationFrame.Size = UDim2.new(0, 220, 0, 40)
NotificationFrame.Position = UDim2.new(0.5, -110, 0.15, 0)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(220, 40, 50)
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Visible = false
NotificationFrame.ZIndex = 100
NotificationFrame.Parent = ScreenGui

local NotifCorner = Instance.new("UICorner")
NotifCorner.CornerRadius = UDim.new(0, 8)
NotifCorner.Parent = NotificationFrame

local NotifText = Instance.new("TextLabel")
NotifText.Size = UDim2.new(1, 0, 1, 0)
NotifText.BackgroundTransparency = 1
NotifText.Font = Enum.Font.GothamBold
NotifText.TextSize = 13
NotifText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotifText.Text = "нету текста"
NotifText.ZIndex = 101
NotifText.Parent = NotificationFrame

local function showErrorNotification(msg)
    NotifText.Text = msg or "нету текста"
    NotificationFrame.BackgroundTransparency = 0
    NotifText.TextTransparency = 0
    NotificationFrame.Visible = true
    
    task.spawn(function()
        task.wait(1.8)
        TweenService:Create(NotificationFrame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
        TweenService:Create(NotifText, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
        task.wait(0.4)
        NotificationFrame.Visible = false
    end)
end

----------------------------------------------------
-- 2. ИНТРО (v3.2 fix)
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
IntroTitle.Position = UDim2.new(0, 0, 0.30, 0)
IntroTitle.BackgroundTransparency = 1
IntroTitle.Text = "I S P A R L O S E  v3.2 (fix)"
IntroTitle.Font = Enum.Font.GothamBold
IntroTitle.TextSize = 28
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
-- 3. ГЛАВНОЕ МЕНЮ
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
TopbarTitle.Size = UDim2.new(0, 280, 1, 0)
TopbarTitle.BackgroundTransparency = 1
TopbarTitle.Text = "ISPARLOSE  |  HUB v3.2 (fix)"
TopbarTitle.Font = Enum.Font.GothamBold
TopbarTitle.TextSize = 13
TopbarTitle.TextColor3 = Color3.fromRGB(240, 240, 250)
TopbarTitle.TextXAlignment = Enum.TextXAlignment.Left
TopbarTitle.Parent = Topbar

-- Перетаскивание меню
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

-- Sidebar & Content
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

-- Вкладки
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

local ConfigScroll = Instance.new("ScrollingFrame")
ConfigScroll.Size = UDim2.new(1, -20, 1, -20)
ConfigScroll.Position = UDim2.new(0, 10, 0, 10)
ConfigScroll.BackgroundTransparency = 1
ConfigScroll.BorderSizePixel = 0
ConfigScroll.ScrollBarThickness = 3
ConfigScroll.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
ConfigScroll.CanvasSize = UDim2.new(0, 0, 0, 420)
ConfigScroll.Visible = false
ConfigScroll.Parent = ContentPanel

local ConfigLayout = Instance.new("UIListLayout")
ConfigLayout.SortOrder = Enum.SortOrder.LayoutOrder
ConfigLayout.Padding = UDim.new(0, 8)
ConfigLayout.Parent = ConfigScroll

-- Кнопки в сайдбаре
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

local TabConfigBtn = Instance.new("TextButton")
TabConfigBtn.Size = UDim2.new(1, -20, 0, 36)
TabConfigBtn.Position = UDim2.new(0, 10, 0, 98)
TabConfigBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
TabConfigBtn.Text = "  CONFIG"
TabConfigBtn.Font = Enum.Font.GothamBold
TabConfigBtn.TextSize = 11
TabConfigBtn.TextColor3 = Color3.fromRGB(140, 140, 160)
TabConfigBtn.TextXAlignment = Enum.TextXAlignment.Left
TabConfigBtn.AutoButtonColor = false
TabConfigBtn.Parent = Sidebar

local TabConfigCorner = Instance.new("UICorner")
TabConfigCorner.CornerRadius = UDim.new(0, 6)
TabConfigCorner.Parent = TabConfigBtn

local function switchTab(activeTab)
    VisualsScroll.Visible = (activeTab == "Visuals")
    MiscScroll.Visible = (activeTab == "Misc")
    ConfigScroll.Visible = (activeTab == "Config")
    
    TabVisualsBtn.BackgroundColor3 = (activeTab == "Visuals") and Color3.fromRGB(24, 24, 32) or Color3.fromRGB(16, 16, 22)
    TabVisualsBtn.TextColor3 = (activeTab == "Visuals") and Color3.fromRGB(110, 86, 207) or Color3.fromRGB(140, 140, 160)
    
    TabMiscBtn.BackgroundColor3 = (activeTab == "Misc") and Color3.fromRGB(24, 24, 32) or Color3.fromRGB(16, 16, 22)
    TabMiscBtn.TextColor3 = (activeTab == "Misc") and Color3.fromRGB(110, 86, 207) or Color3.fromRGB(140, 140, 160)
    
    TabConfigBtn.BackgroundColor3 = (activeTab == "Config") and Color3.fromRGB(24, 24, 32) or Color3.fromRGB(16, 16, 22)
    TabConfigBtn.TextColor3 = (activeTab == "Config") and Color3.fromRGB(110, 86, 207) or Color3.fromRGB(140, 140, 160)
end

TabVisualsBtn.MouseButton1Click:Connect(function() switchTab("Visuals") end)
TabMiscBtn.MouseButton1Click:Connect(function() switchTab("Misc") end)
TabConfigBtn.MouseButton1Click:Connect(function() switchTab("Config") end)

----------------------------------------------------
-- КОМПОНЕНТЫ ИНТЕРФЕЙСА
----------------------------------------------------
local RegisteredToggles = {}

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

local function createToggle(parent, text, configKey, callback)
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
    
    local defaultState = Config[configKey] or false
    
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
    local function updateVisuals(newState)
        state = newState
        Config[configKey] = newState
        local targetBg = state and Color3.fromRGB(110, 86, 207) or Color3.fromRGB(40, 40, 52)
        local targetDotPos = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = targetBg}):Play()
        TweenService:Create(switchDot, TweenInfo.new(0.2), {Position = targetDotPos}):Play()
        callback(state)
    end
    
    switchBg.MouseButton1Click:Connect(function()
        updateVisuals(not state)
    end)
    
    RegisteredToggles[configKey] = updateVisuals
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
    
    btn.MouseButton1Click:Connect(function() callback(btn) end)
    return card
end

----------------------------------------------------
-- НАПОЛНЕНИЕ ВКЛАДОК
----------------------------------------------------
-- Visuals
createSection(VisualsScroll, "1. Outline ESP")
createToggle(VisualsScroll, "Enable Outline ESP", "OutlineESP", function() end)
createToggle(VisualsScroll, "   └─ Show Teammates Outline", "OutlineTeammates", function() end)

createSection(VisualsScroll, "2. Boxes ESP")
createToggle(VisualsScroll, "Enable Boxes ESP", "BoxESP", function() end)
createToggle(VisualsScroll, "   └─ Show Teammates Boxes", "BoxTeammates", function() end)
createToggle(VisualsScroll, "   └─ Show HP Bar (Left Green->Red)", "ShowHP", function() end)
createToggle(VisualsScroll, "   └─ Show Weapon Name (Bottom)", "ShowWeapon", function() end)

createSection(VisualsScroll, "3. Directional Arrows")
createToggle(VisualsScroll, "Enable Offscreen Arrows", "ArrowsESP", function() end)
createToggle(VisualsScroll, "   └─ Show Enemies Arrows", "ArrowEnemies", function() end)

createSection(VisualsScroll, "4. Bullet Tracers")
createToggle(VisualsScroll, "Enable Bullet Tracers", "BulletTracers", function() end)
createButton(VisualsScroll, "   └─ Tracer Color: [ Neon Cyan ]", function(btn)
    Config.TracerColorIndex = Config.TracerColorIndex % #Config.TracerColors + 1
    btn.Text = "   └─ Tracer Color: [ " .. Config.TracerColorNames[Config.TracerColorIndex] .. " ]"
end)

-- Misc
createSection(MiscScroll, "1. Player Modifications")
createToggle(MiscScroll, "No Molotov Damage", "AntiMolotov", function() end)
createToggle(MiscScroll, "Noclip", "Noclip", function() end)

----------------------------------------------------
-- 4. ОПЦИИ И ОКНО КОНФИГОВ (CONFIG SYSTEM)
----------------------------------------------------
-- Модальное окно "Сохранить конфиг"
local SaveModal = Instance.new("Frame")
SaveModal.Name = "SaveModal"
SaveModal.Size = UDim2.new(0, 320, 0, 150)
SaveModal.Position = UDim2.new(0.5, -160, 0.5, -75)
SaveModal.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
SaveModal.BorderSizePixel = 0
SaveModal.Visible = false
SaveModal.ZIndex = 50
SaveModal.Parent = ScreenGui

local ModalCorner = Instance.new("UICorner")
ModalCorner.CornerRadius = UDim.new(0, 10)
ModalCorner.Parent = SaveModal

local ModalStroke = Instance.new("UIStroke")
ModalStroke.Color = Color3.fromRGB(110, 86, 207)
ModalStroke.Thickness = 1.5
ModalStroke.Parent = SaveModal

local ModalTitle = Instance.new("TextLabel")
ModalTitle.Size = UDim2.new(1, 0, 0, 30)
ModalTitle.Position = UDim2.new(0, 0, 0, 10)
ModalTitle.BackgroundTransparency = 1
ModalTitle.Text = "Введите название конфига"
ModalTitle.Font = Enum.Font.GothamBold
ModalTitle.TextSize = 13
ModalTitle.TextColor3 = Color3.fromRGB(240, 240, 250)
ModalTitle.ZIndex = 51
ModalTitle.Parent = SaveModal

local ConfigInput = Instance.new("TextBox")
ConfigInput.Size = UDim2.new(0.86, 0, 0, 32)
ConfigInput.Position = UDim2.new(0.07, 0, 0.35, 0)
ConfigInput.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
ConfigInput.BorderSizePixel = 0
ConfigInput.Font = Enum.Font.GothamMedium
ConfigInput.TextSize = 12
ConfigInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ConfigInput.PlaceholderText = "Название конфига..."
ConfigInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
ConfigInput.Text = ""
ConfigInput.ZIndex = 51
ConfigInput.Parent = SaveModal

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 6)
InputCorner.Parent = ConfigInput

-- Кнопки Отмена (слева) и ОК (справа)
local CancelBtn = Instance.new("TextButton")
CancelBtn.Size = UDim2.new(0.38, 0, 0, 32)
CancelBtn.Position = UDim2.new(0.08, 0, 0.68, 0)
CancelBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
CancelBtn.Text = "Отмена"
CancelBtn.Font = Enum.Font.GothamBold
CancelBtn.TextSize = 12
CancelBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
CancelBtn.ZIndex = 51
CancelBtn.Parent = SaveModal

local CancelCorner = Instance.new("UICorner")
CancelCorner.CornerRadius = UDim.new(0, 6)
CancelCorner.Parent = CancelBtn

local OkBtn = Instance.new("TextButton")
OkBtn.Size = UDim2.new(0.38, 0, 0, 32)
OkBtn.Position = UDim2.new(0.54, 0, 0.68, 0)
OkBtn.BackgroundColor3 = Color3.fromRGB(110, 86, 207)
OkBtn.Text = "ОК"
OkBtn.Font = Enum.Font.GothamBold
OkBtn.TextSize = 12
OkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OkBtn.ZIndex = 51
OkBtn.Parent = SaveModal

local OkCorner = Instance.new("UICorner")
OkCorner.CornerRadius = UDim.new(0, 6)
OkCorner.Parent = OkBtn

-- Контейнер подвкладки сохраненных конфигов
local ConfigListFrame = Instance.new("Frame")
ConfigListFrame.Size = UDim2.new(1, 0, 0, 140)
ConfigListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
ConfigListFrame.BorderSizePixel = 0
ConfigListFrame.Parent = ConfigScroll

local ConfigListCorner = Instance.new("UICorner")
ConfigListCorner.CornerRadius = UDim.new(0, 6)
ConfigListCorner.Parent = ConfigListFrame

local ConfigListScroll = Instance.new("ScrollingFrame")
ConfigListScroll.Size = UDim2.new(1, -10, 1, -10)
ConfigListScroll.Position = UDim2.new(0, 5, 0, 5)
ConfigListScroll.BackgroundTransparency = 1
ConfigListScroll.BorderSizePixel = 0
ConfigListScroll.ScrollBarThickness = 3
ConfigListScroll.Parent = ConfigListFrame

local ConfigListLayout = Instance.new("UIListLayout")
ConfigListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ConfigListLayout.Padding = UDim.new(0, 4)
ConfigListLayout.Parent = ConfigListScroll

local SelectedLabel = Instance.new("TextLabel")
SelectedLabel.Size = UDim2.new(1, 0, 0, 20)
SelectedLabel.BackgroundTransparency = 1
SelectedLabel.Font = Enum.Font.GothamMedium
SelectedLabel.TextSize = 11
SelectedLabel.TextColor3 = Color3.fromRGB(160, 160, 180)
SelectedLabel.Text = "Выбран конфиг: [ Ничего ]"
SelectedLabel.TextXAlignment = Enum.TextXAlignment.Left
SelectedLabel.Parent = ConfigScroll

local function refreshConfigListUI()
    for _, child in ipairs(ConfigListScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for name, _ in pairs(SavedConfigs) do
        local itemBtn = Instance.new("TextButton")
        itemBtn.Size = UDim2.new(1, 0, 0, 28)
        itemBtn.BackgroundColor3 = (SelectedConfigName == name) and Color3.fromRGB(110, 86, 207) or Color3.fromRGB(28, 28, 38)
        itemBtn.Text = "   " .. name
        itemBtn.Font = Enum.Font.GothamMedium
        itemBtn.TextSize = 11
        itemBtn.TextColor3 = Color3.fromRGB(240, 240, 250)
        itemBtn.TextXAlignment = Enum.TextXAlignment.Left
        itemBtn.Parent = ConfigListScroll
        
        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 4)
        itemCorner.Parent = itemBtn
        
        itemBtn.MouseButton1Click:Connect(function()
            SelectedConfigName = name
            SelectedLabel.Text = "Выбран конфиг: [ " .. name .. " ]"
            refreshConfigListUI()
        end)
    end
end

createSection(ConfigScroll, "1. Config Management")
createButton(ConfigScroll, "Сохранить конфиг", function()
    ConfigInput.Text = ""
    SaveModal.Visible = true
end)

createButton(ConfigScroll, "Загрузить конфиг", function()
    if not SelectedConfigName or not SavedConfigs[SelectedConfigName] then
        showErrorNotification("Выберите конфиг!")
        return
    end
    
    local data = SavedConfigs[SelectedConfigName]
    for key, value in pairs(data) do
        if Config[key] ~= nil then
            Config[key] = value
            if RegisteredToggles[key] then
                RegisteredToggles[key](value)
            end
        end
    end
end)

createSection(ConfigScroll, "2. Сохраненные конфиги")

-- Логика модального окна сохранения
CancelBtn.MouseButton1Click:Connect(function()
    SaveModal.Visible = false
end)

OkBtn.MouseButton1Click:Connect(function()
    local text = ConfigInput.Text:gsub("%s+", "")
    if text == "" then
        showErrorNotification("нету текста")
    else
        local cfgData = {}
        for k, v in pairs(Config) do
            if type(v) ~= "table" then
                cfgData[k] = v
            end
        end
        SavedConfigs[ConfigInput.Text] = cfgData
        SelectedConfigName = ConfigInput.Text
        SelectedLabel.Text = "Выбран конфиг: [ " .. ConfigInput.Text .. " ]"
        refreshConfigListUI()
        SaveModal.Visible = false
    end
end)

----------------------------------------------------
-- 5. ИНТРО АНИМАЦИЯ
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
-- 6. ВСПОМОГАТЕЛЬНЫЕ ПРОВЕРКИ
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
    return "Primary / Knife"
end

local function isHoldingKnife(char)
    if not char then return false end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool then
        local name = tool.Name:lower()
        if name:find("knife") or name:find("blade") or name:find("sword") or name:find("machete") or name:find("karambit") or name:find("melee") or name:find("bayonet") or name:find("dagger") then
            return true
        end
    end
    return false
end

local function isMouseOverUI()
    if UserInputService:GetFocusedTextBox() then return true end
    local mousePos = UserInputService:GetMouseLocation()
    
    if MainFrame.Visible then
        local pos, size = MainFrame.AbsolutePosition, MainFrame.AbsoluteSize
        if mousePos.X >= pos.X and mousePos.X <= pos.X + size.X and mousePos.Y >= pos.Y and mousePos.Y <= pos.Y + size.Y then
            return true
        end
    end
    if SaveModal.Visible then
        local pos, size = SaveModal.AbsolutePosition, SaveModal.AbsoluteSize
        if mousePos.X >= pos.X and mousePos.X <= pos.X + size.X and mousePos.Y >= pos.Y and mousePos.Y <= pos.Y + size.Y then
            return true
        end
    end
    return false
end

----------------------------------------------------
-- 7. ТРЕЙСЕРЫ ПУЛЬ (ЗАЖИМ, ФИЛЬТР МАГАЗИНА И НОЖА)
----------------------------------------------------
local activeTracer = nil
local activeTracerConn = nil
local isLmbDown = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isLmbDown = true
        if gameProcessed then return end
        if not Config.BulletTracers then return end
        if isMouseOverUI() then return end
        
        local char = LocalPlayer.Character
        if not char or isHoldingKnife(char) then return end
        
        local mouse = LocalPlayer:GetMouse()
        local targetPos = mouse.Hit and mouse.Hit.Position
        if not targetPos then return end
        
        if activeTracer then activeTracer:Destroy() activeTracer = nil end
        if activeTracerConn then activeTracerConn:Disconnect() activeTracerConn = nil end
        
        local tracerPart = Instance.new("Part")
        tracerPart.Name = "IsparloseTracer"
        tracerPart.Anchored = true
        tracerPart.CanCollide = false
        tracerPart.Material = Enum.Material.Neon
        tracerPart.Color = Config.TracerColors[Config.TracerColorIndex]
        tracerPart.Transparency = 0.1
        tracerPart.Parent = workspace
        activeTracer = tracerPart
        
        local function updateTracer()
            if not isLmbDown or not activeTracer or not activeTracer.Parent then return end
            local curChar = LocalPlayer.Character
            if not curChar or isHoldingKnife(curChar) or isMouseOverUI() then
                return
            end
            
            local muzzlePos
            local tool = curChar:FindFirstChildOfClass("Tool")
            if tool and tool:FindFirstChild("Handle") then
                muzzlePos = tool.Handle.Position
            elseif curChar:FindFirstChild("RightHand") then
                muzzlePos = curChar.RightHand.Position
            elseif curChar:FindFirstChild("Right Arm") then
                muzzlePos = curChar["Right Arm"].Position
            else
                muzzlePos = Camera.CFrame.Position - Vector3.new(0, 0.4, 0)
            end
            
            local curTarget = mouse.Hit and mouse.Hit.Position or targetPos
            local dist = (curTarget - muzzlePos).Magnitude
            if dist > 0.5 then
                activeTracer.Size = Vector3.new(0.12, 0.12, dist)
                activeTracer.CFrame = CFrame.new(muzzlePos:Lerp(curTarget, 0.5), curTarget)
            end
        end
        
        updateTracer()
        activeTracerConn = RunService.RenderStepped:Connect(updateTracer)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isLmbDown = false
        if activeTracerConn then
            activeTracerConn:Disconnect()
            activeTracerConn = nil
        end
        if activeTracer then
            local tracerToFade = activeTracer
            activeTracer = nil
            local fadeTween = TweenService:Create(tracerToFade, TweenInfo.new(0.35, Enum.EasingStyle.Linear), {
                Transparency = 1,
                Size = Vector3.new(0.01, 0.01, tracerToFade.Size.Z)
            })
            fadeTween:Play()
            task.delay(0.36, function()
                if tracerToFade then tracerToFade:Destroy() end
            end)
        end
    end
end)

----------------------------------------------------
-- 8. ЛОГИКА MISC (NO MOLOTOV & NOCLIP)
----------------------------------------------------
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
-- 9. РАСЧЕТ ИДЕАЛЬНОГО 3D BOUNDING BOX
----------------------------------------------------
local function getCharacterBoxBounds(char)
    if not char then return nil end
    local cf, size = char:GetBoundingBox()
    
    local halfX = size.X / 2
    local halfY = size.Y / 2
    local halfZ = size.Z / 2
    
    local corners = {
        cf * Vector3.new(-halfX,  halfY, -halfZ),
        cf * Vector3.new( halfX,  halfY, -halfZ),
        cf * Vector3.new(-halfX, -halfY, -halfZ),
        cf * Vector3.new( halfX, -halfY, -halfZ),
        cf * Vector3.new(-halfX,  halfY,  halfZ),
        cf * Vector3.new( halfX,  halfY,  halfZ),
        cf * Vector3.new(-halfX, -halfY,  halfZ),
        cf * Vector3.new( halfX, -halfY,  halfZ),
    }
    
    local minX, minY = math.huge, math.huge
    local maxX, maxY = -math.huge, -math.huge
    local anyOnScreen = false
    
    for _, cornerPos in ipairs(corners) do
        local screenPos, onScreen = Camera:WorldToViewportPoint(cornerPos)
        if screenPos.Z > 0 then
            anyOnScreen = true
            minX = math.min(minX, screenPos.X)
            minY = math.min(minY, screenPos.Y)
            maxX = math.max(maxX, screenPos.X)
            maxY = math.max(maxY, screenPos.Y)
        end
    end
    
    if anyOnScreen and minX < maxX and minY < maxY then
        return minX, minY, maxX - minX, maxY - minY
    end
    return nil
end

----------------------------------------------------
-- 10. РЕНДЕР КАЖДОГО КАДРА (ESP)
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
                hl.FillColor = isTeam and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(255, 50, 50)
                hl.OutlineColor = isTeam and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(255, 100, 100)
            else
                local hl = char:FindFirstChild("IsparloseHighlight")
                if hl then hl:Destroy() end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    updateHighlights()
    
    local viewportSize = Camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not espElements[player] then createEspBox(player) end
            
            local elements = espElements[player]
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local isTeam = isTeammate(player)
            local isAlive = char and hum and hrp and hum.Health > 0
            
            if isAlive then
                -- BOX ESP
                if Config.BoxESP and (not isTeam or Config.BoxTeammates) then
                    local x, y, w, h = getCharacterBoxBounds(char)
                    if x and y and w and h then
                        elements.Box.Position = UDim2.new(0, x, 0, y)
                        elements.Box.Size = UDim2.new(0, w, 0, h)
                        elements.Box.Visible = true
                        elements.Outline.Color = isTeam and Color3.fromRGB(0, 200, 255) or Config.BoxColor
                        
                        if Config.ShowHP then
                            elements.HpBg.Visible = true
                            local hpPct = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                            elements.HpFill.Size = UDim2.new(1, 0, hpPct, 0)
                            elements.HpFill.Position = UDim2.new(0, 0, 1 - hpPct, 0)
                            elements.HpFill.BackgroundColor3 = Color3.fromRGB(0, 255, 100):Lerp(Color3.fromRGB(255, 50, 50), 1 - hpPct)
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
                
                -- ARROWS ESP
                if Config.ArrowsESP and (isTeam or Config.ArrowEnemies) then
                    local camCFrame = Camera.CFrame
                    local targetPos = hrp.Position
                    local dir = (targetPos - camCFrame.Position).Unit
                    local dotFwd = camCFrame.LookVector:Dot(dir)
                    local dotRight = camCFrame.RightVector:Dot(dir)
                    
                    local angle = math.atan2(dotRight, dotFwd)
                    local radius = Config.ArrowRadius
                    
                    local arrowX = screenCenter.X + math.sin(angle) * radius
                    local arrowY = screenCenter.Y - math.cos(angle) * radius
                    
                    elements.Arrow.Position = UDim2.new(0, arrowX, 0, arrowY)
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
