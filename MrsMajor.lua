--[[                                !!!  Disclaimer  !!!                                
        Please put to mind that the text's are just for mimic purposes, of course, an executor's sandbox will be good enough to not cause real malware.
        This project is only to annoy people or scare/prank them, whatever you want.
        Bios related stuff are just for sarcasm and for mimicking the malware's original text, Thank you.
]]

repeat wait() until game:IsLoaded()

local MrsMajor = {}
MrsMajor.__index = MrsMajor

--[[                               Config                               ]]

local CONFIG = {
    TIMER_DURATION = 60 * 4, -- change this if your attention span is cooked
    MAX_CLONES = 15,
    CLONE_SPAWN_RATE = 0.1,
    MUSIC_ID = getcustomasset("Thresh, the Chain Warden.mp3"),
    IMAGE_ASSETS = {
        MAIN_IMAGE = getcustomasset("the doll.png"),
        CURSORS = {
            [1] = "rbxassetid://74222497463243", -- don't mind these, they are just some test stuff
            [2] = "rbxassetid://103270247049302",
            [3] = "rbxassetid://93617289070802",
            [4] = "rbxassetid://119891570354418",
            [5] = "rbxassetid://128845143090746"
        }
    },

    COLORS = {
        BLOOD_RED = Color3.fromRGB(255, 0, 0),
        WHITE = Color3.fromRGB(255, 255, 255),
        BLACK = Color3.fromRGB(0, 0, 0),
        GRAY = Color3.fromRGB(80, 80, 80),
        LIGHT_GRAY = Color3.fromRGB(200, 200, 200)
    },

    DEATH_TEXT = [[
A problem has been detected and Roblox has been frozen to prevent damage to your executor.

TROJANS_NEVER_JOKES_RESPECT_THE_TROJANS

If this is the first time you have seen this screen, you are infected by MrsMajor.lua and you broke rules. It is unacceptable. However, your executor won't be able to get its files because workspace is missing..

If problems continue, contact the virus owner or disable your executor memory. Jk second way won't work. Do not waste your time. Every time you boot up your executor, this screen will appear. these are fake technical information:

*** STOP: 0x00D1 (0x00C, 0x002, 0x00, 0xF86B5A89)

Address F86B5A89 base at F86B5000, DateStamp 3dd9919eb ***

Beginning dump of physical memory..

Physical memory dump complete.

Roblox can't function, CoreGui is missing. Fix your executor. Eh, if it's possible.
]]
}

local KeyCodes = {}

for _, keyCode in ipairs(Enum.KeyCode:GetEnumItems()) do
    table.insert(KeyCodes, keyCode)
end

--[[                               Services                               ]]

local Players = game:GetService("Players")
local lplr = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

--[[                               Construction                               ]]

function MrsMajor.new()
    local self = setmetatable({}, MrsMajor)
    self.player = Players.LocalPlayer
    self.gui = nil
    self.connections = {}
    self.clones = {}
    self.timeLeft = CONFIG.TIMER_DURATION
    self.tickState = 0
    self.bloodFrame = nil
    self.countdown = nil
    self.mainImage = nil
    self.rulesWindow = nil
    self.redBackground = nil
    
    return self
end

--[[                               Utility Handler                              ]]

function MrsMajor:GRS(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local symbols = "!@#$%^&*()_+-=[]{}|;:,.<>?/~`"

    local all_chars = chars .. symbols
    
    local result = ""
    for i = 1, length do
        local rand_index = math.random(1, #all_chars)
        result = result .. all_chars:sub(rand_index, rand_index)
    end

    return result
end

function MrsMajor:CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

local globalDragging = false
local currentDragConnection = nil

function MrsMajor:MakeDraggable(obj, handle)
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    local inputChangedConnection
    
    local function update(input)
        local delta = input.Position - dragStart
        handle.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    local function stopDragging()
        dragging = false
        globalDragging = false
        if inputChangedConnection then
            inputChangedConnection:Disconnect()
            inputChangedConnection = nil
        end
        currentDragConnection = nil
    end
    
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if globalDragging then
                return
            end
            
            dragging = true
            globalDragging = true
            dragStart = input.Position
            startPos = handle.Position

            inputChangedConnection = UserInputService.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    update(input)
                end
            end)

            currentDragConnection = inputChangedConnection
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    stopDragging()
                end
            end)
        end
    end)
    
    obj.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
end

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and globalDragging then
        globalDragging = false
        if currentDragConnection then
            currentDragConnection:Disconnect()
            currentDragConnection = nil
        end
    end
end)

function MrsMajor:PlayTick()
    self.tickState = 1 - self.tickState
end

function MrsMajor:FormatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local secs = seconds % 60
    return string.format("%d:%02d", minutes, secs)
end

-- [[                               UI Handler                               ]]

function MrsMajor:CreateMainGUI()
    self.gui = self:CreateInstance("ScreenGui", {
        Parent = self.player:WaitForChild("PlayerGui"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    })
    return self.gui
end

function MrsMajor:CreateBloodMeter()
    local blood = self:CreateInstance("Frame", {
        Name = "Blood",
        Parent = self.gui,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0.417, 0, 0.139, 0),
        Size = UDim2.new(0, 100, 0, 442)
    })
    
    self:CreateInstance("UIStroke", {
        Name = "TheStroke",
        Parent = blood,
        Color = Color3.fromRGB(204, 0, 0),
        Thickness = 1.5
    })
    
    self:CreateInstance("TextLabel", {
        Parent = blood,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, -0.113, 0),
        Size = UDim2.new(0, 100, 0, 50),
        Font = Enum.Font.SourceSans,
        Text = "Blood\nLeft:",
        TextColor3 = CONFIG.COLORS.BLOOD_RED,
        TextScaled = true
    })
    
    self.bloodFrame = self:CreateInstance("Frame", {
        Parent = blood,
        AnchorPoint = Vector2.new(0, 1),
        BackgroundColor3 = CONFIG.COLORS.BLOOD_RED,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1.005, 0),
        Size = UDim2.new(0, 100, 0, 445)
    })
end

function MrsMajor:CreateMainWindow()
    local sound = self:CreateInstance("Sound", {
        Name = "Warden",
        Parent = self.gui,
        SoundId = CONFIG.MUSIC_ID,
        Volume = 2,
        Looped = true
    })

    local window = self:CreateInstance("Frame", {
        Name = "Window",
        Parent = self.gui,
        BackgroundColor3 = CONFIG.COLORS.WHITE,
        BorderSizePixel = 0,
        Position = UDim2.new(0.558, 0, 0.112, 0),
        Size = UDim2.new(0, 355, 0, 470)
    })
    
    self:MakeDraggable(window, window)
    local xButton = self:CreateInstance("Frame", {
        Name = "XButton",
        Parent = window,
        BackgroundColor3 = CONFIG.COLORS.BLOOD_RED,
        BorderSizePixel = 0,
        Position = UDim2.new(0.921, 0, 0, 0),
        Size = UDim2.new(0, 28, 0, 27)
    })
    
    self:CreateInstance("TextButton", {
        Parent = xButton,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.SourceSans,
        Text = "x",
        TextColor3 = CONFIG.COLORS.BLACK,
        TextSize = 14
    })
    
    local timer = self:CreateInstance("Frame", {
        Name = "Timer",
        Parent = window,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.928, 0),
        Size = UDim2.new(0, 100, 0, 34),
        ZIndex = 3
    })
    
    self:CreateInstance("UIStroke", {
        Name = "TheStroke",
        Parent = timer,
        Color = Color3.fromRGB(255, 0, 4),
        Thickness = 1
    })
    self.countdown = self:CreateInstance("TextLabel", {
        Name = "Countdown",
        Parent = timer,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Enum.Font.Jura,
        Text = self:FormatTime(self.timeLeft),
        TextColor3 = CONFIG.COLORS.BLOOD_RED,
        TextScaled = true
    })
    
    local imageContainer = self:CreateInstance("Frame", {
        Parent = window,
        BackgroundColor3 = CONFIG.COLORS.BLACK,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.057, 0),
        Size = UDim2.new(0, 355, 0, 443),
        ClipsDescendants = true
    })
    
    self.mainImage = self:CreateInstance("ImageLabel", {
        Name = "MainImage",
        Parent = imageContainer,
        Image = CONFIG.IMAGE_ASSETS.MAIN_IMAGE,
        Size = UDim2.new(1, 100, 1, 100),
        Position = UDim2.new(0, -50, 0, -50),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })
    sound:Play()
end

function MrsMajor:CreateRulesWindow()
    self.rulesWindow = self:CreateInstance("Frame", {
        Name = "Rules",
        Parent = self.gui,
        BackgroundColor3 = CONFIG.COLORS.GRAY,
        BorderSizePixel = 0,
        Position = UDim2.new(0.294, 0, 0.209, 0),
        Size = UDim2.new(0, 617, 0, 352),
        Visible = false
    })

    local header = self:CreateInstance("Frame", {
        Parent = self.rulesWindow,
        BackgroundColor3 = CONFIG.COLORS.WHITE,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 24)
    })

    self:MakeDraggable(header, self.rulesWindow)

    self:CreateInstance("TextLabel", {
        Parent = header,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 75, 1, 0),
        Font = Enum.Font.SourceSans,
        Text = "Rules",
        TextColor3 = CONFIG.COLORS.BLACK,
        TextSize = 17
    })
    
    self:CreateInstance("TextLabel", {
        Parent = header,
        BackgroundColor3 = CONFIG.COLORS.WHITE,
        BorderSizePixel = 0,
        Position = UDim2.new(0.94, 0, 0, 0),
        Size = UDim2.new(0, 37, 1, 0),
        Font = Enum.Font.Gotham,
        Text = "x",
        TextColor3 = Color3.fromRGB(180, 180, 180),
        TextScaled = true
    })
    
    self:CreateInstance("TextLabel", {
        Parent = self.rulesWindow,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.068, 0),
        Size = UDim2.new(1, 0, 0, 60),
        Font = Enum.Font.SourceSans,
        Text = 'Your computer has been infected by MrsMajor Roblox Edition.\n\nIf you don\'t attend by the rules, your executor will be "Trash"',
        TextColor3 = CONFIG.COLORS.WHITE,
        TextScaled = true
    })
    
    self:CreateInstance("Frame", {
        Parent = self.rulesWindow,
        BackgroundColor3 = Color3.fromRGB(175, 175, 175),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.273, 0),
        Size = UDim2.new(1, 0, 0, 1)
    })
    
    self:CreateInstance("TextLabel", {
        Parent = self.rulesWindow,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.273, 0),
        Size = UDim2.new(1, 0, 0.727, 0),
        Font = Enum.Font.SourceSans,
        Text = "\t+If timer runs out, your workspace files will be deleted.\n\t+If you attempt to kill any process, your GPU will die.\n\t+Do NOT delete any virus GUI.\n\t+Do NOT run Dex, Infinite Yield, or any script.\n\t+Do NOT try to leave.\n\t+Do NOT try to bypass dex or Anti Virus, etc.. Or your workspace files will be deleted..",
        TextColor3 = CONFIG.COLORS.LIGHT_GRAY,
        TextSize = 21,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top
    })
end


function MrsMajor:CreateRedBackground()
    self.redBackground = self:CreateInstance("Frame", {
        Name = "RedBackground",
        Parent = self.gui,
        BackgroundColor3 = CONFIG.COLORS.BLOOD_RED,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 0
    })
    local deathText = CONFIG and CONFIG.DEATH_TEXT or ""

    self.RSOD = self:CreateInstance("TextLabel", {
        Name = "RSOD",
        Parent = self.redBackground,
        Text = deathText,
        BackgroundTransparency = 1,
        TextTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextWrapped = true,
        TextScaled = true,
        TextXAlignment = "Left",
        Size = UDim2.new(1, 0, 1, 0)
    })
end

function MrsMajor:CreateCursor()
    local cursor = self:CreateInstance("ImageLabel", {
        Name = "Cursor",
        Parent = self.gui,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(0, 32, 0, 32),
        Image = "rbxassetid://74222497463243"
    })
end

-- [[                               Animations & Timer                               ]]

function MrsMajor:StartImageAnimation()
    local time = 0
    local baseX, baseY = -50, -50
    
    local connection = RunService.Heartbeat:Connect(function(dt)
        time = time + dt
        
        local waveX = math.sin(time * 3.5) * 25 + math.noise(time * math.random(1, 2)) * math.random(1, 5)
        local waveY = math.cos(time * 2.9) * 22 + math.noise(time * math.random(1, 8)) * math.random(1, 5)
        local waveZ = math.sin(time * 4.3) * 12 + math.noise(time * math.random(1, 4)) * math.random(1, 5)
        
        local finalX = waveX + (waveZ * 0.6)
        local finalY = waveY + (math.cos(time * 3.8) * 8)
        
        if self.mainImage then
            self.mainImage.Position = UDim2.new(0, baseX + finalX, 0, baseY + finalY)
        end
    end)
    
    table.insert(self.connections, connection)
end

function MrsMajor:StartTimer()
    local connection = task.spawn(function()
        while self.timeLeft > 0 do
            task.wait(1)
            self.timeLeft = self.timeLeft - 1
            
            if self.countdown then
                self.countdown.Text = self:FormatTime(self.timeLeft)
            end
            
            if self.bloodFrame then
                local height = 445 * (self.timeLeft / CONFIG.TIMER_DURATION)
                self.bloodFrame.Size = UDim2.new(0, 100, 0, height)
            end
        end
        
        self:OnTimerExpired()
    end)
    
    table.insert(self.connections, connection)
end

function MrsMajor:StartCloneSpawning()
    local connection = task.spawn(function()
        local screenSize = workspace.CurrentCamera.ViewportSize
        
        while true do
            pcall(function()
                if #self.clones >= CONFIG.MAX_CLONES then
                    local oldClone = table.remove(self.clones, 1)
                    if oldClone then oldClone:Destroy() end
                end
                
                local clone = self:CreateInstance("ImageLabel", {
                    Parent = self.gui,
                    Image = CONFIG.IMAGE_ASSETS.MAIN_IMAGE,
                    Size = UDim2.new(0, 165, 0, 222),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = -5
                })
                
                local maxX = screenSize.X - 155
                local maxY = screenSize.Y - 222
                clone.Position = UDim2.new(0, math.random(0, maxX), 0, math.random(0, maxY))
                
                table.insert(self.clones, clone)
            end)
            
            task.wait(CONFIG.CLONE_SPAWN_RATE)
        end
    end)
    
    table.insert(self.connections, connection)
end

-- [[                               Control Handler                               ]]

function MrsMajor:ShowRules()
    if self.rulesWindow then
        self.rulesWindow.Visible = true
    end
end

function MrsMajor:FullScreen(t)
    if t == "VIM" then
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.F11, false, game)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.F11, false, game)
    elseif t == "keypress" then
        keypress(0x7A)
        keyrelease(0x7A)
    end
end

function MrsMajor:ForceFullScreen()
    local connection = RunService.Heartbeat:Connect(function()
        local GameSettings = UserSettings().GameSettings
        if GameSettings:InFullScreen() == false then
            MrsMajor:FullScreen("VIM")
        else
            return
        end
    end)
    table.insert(self.connections, connection)
end

function MrsMajor:RandomClickLoop()
    local connection = RunService.Heartbeat:Connect(function()
        local GameSettings = UserSettings().GameSettings
        if GameSettings:InFullScreen() == true then
            mousemoverel(math.random(-512, 512), math.random(-512, 512))
            if math.random(0, 1) == 1 then mouse1click() else mouse2click() end
            local hahafunny = KeyCodes[math.random(1, #KeyCodes)]
            if math.random(0, 1) == 1 then game:GetService("VirtualInputManager"):SendKeyEvent(true, hahafunny, false, game) else game:GetService("VirtualInputManager"):SendKeyEvent(false, hahafunny, false, game) end
        end
    end)
    table.insert(self.connections, connection)
end

function MrsMajor:HideRules()
    if self.rulesWindow then
        self.rulesWindow.Visible = false
    end
end

function MrsMajor:OnTimerExpired()
    lplr.PlayerGui:ClearAllChildren()
    game.CoreGui:ClearAllChildren()

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RSOD.exe"
    screenGui.Parent = lplr.PlayerGui
    screenGui.IgnoreGuiInset = true
    
    local redBackground = Instance.new("Frame")
    redBackground.Name = "RedBackground"
    redBackground.Size = UDim2.new(1, 0, 1, 0)
    redBackground.Position = UDim2.new(0, 0, 0, 0)
    redBackground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    redBackground.BackgroundTransparency = 0
    redBackground.Parent = screenGui
    
    local msg = Instance.new("TextLabel")
    msg.Name = "RSOD"
    msg.Parent = redBackground
    msg.Text = CONFIG.DEATH_TEXT
    msg.Font = Enum.Font.Code
    msg.BackgroundTransparency = 1
    msg.TextTransparency = 0
    msg.TextColor3 = Color3.fromRGB(255, 255, 255)
    msg.TextWrapped = true
    msg.TextScaled = true
    msg.TextXAlignment = "Left"
    msg.Size = UDim2.new(1, 0, 1, 0)
    
    self.redBackground = redBackground
    self.RSOD = msg
    writefile("RSOD", "done")
end

function MrsMajor:Initialize()
    self:CreateMainGUI()
    self:CreateBloodMeter()
    self:CreateMainWindow()
    self:CreateRulesWindow()
    self:ShowRules()
    self:CreateRedBackground()
    self:CreateCursor()
end

function MrsMajor:Start()
    self:Initialize()
    self:StartImageAnimation()
    self:StartTimer()
    self:StartCloneSpawning()
    self:ForceFullScreen()
    self:RandomClickLoop()
end

function MrsMajor:Cleanup()
    for _, connection in pairs(self.connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif typeof(connection) == "thread" then
            task.cancel(connection)
        end
    end
    
    for _, clone in pairs(self.clones) do
         if clone then clone:Destroy() end   
    end
    
    if self.gui then
        self.gui:Destroy()
    end
    
    UserInputService.MouseIconEnabled = true
    self.connections = {}
    self.clones = {}
end

-- [[                               Initialization                               ]]


MrsMajor.new():Start()
