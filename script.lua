-- FREE SEED HUB - Made by: @SkibidiScript
-- Designed to be executed with a script executor in Grow a Garden

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- Save/load inventory
local filename = "free_seed_hub_data.json"
local function saveData(data)
    writefile(filename, HttpService:JSONEncode(data))
end
local function loadData()
    if isfile(filename) then
        return HttpService:JSONDecode(readfile(filename))
    else
        return {}
    end
end

local inventory = loadData()

-- Rainbow text function
local function rainbowify(textLabel)
    coroutine.wrap(function()
        local hue = 0
        while true do
            textLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
            hue = (hue + 0.01) % 1
            task.wait(0.05)
        end
    end)()
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "FreeSeedHub"
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 250)
Main.Position = UDim2.new(0.5, -150, 0.5, -125)
Main.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Main.BorderSizePixel = 3
Main.Active = true
Main.Draggable = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 16)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "FREE SEED HUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.FredokaOne

local SeedLabel = Instance.new("TextLabel", Main)
SeedLabel.Position = UDim2.new(0, 10, 0, 40)
SeedLabel.Size = UDim2.new(0, 100, 0, 30)
SeedLabel.Text = "SEED NAME:"
SeedLabel.TextColor3 = Color3.new(1, 1, 1)
SeedLabel.BackgroundTransparency = 1
SeedLabel.Font = Enum.Font.FredokaOne
SeedLabel.TextScaled = true

local SeedBox = Instance.new("TextBox", Main)
SeedBox.Position = UDim2.new(0, 120, 0, 40)
SeedBox.Size = UDim2.new(0, 160, 0, 30)
SeedBox.PlaceholderText = "Candy Blossom, etc"
SeedBox.Font = Enum.Font.FredokaOne
SeedBox.TextScaled = true

local AmountLabel = Instance.new("TextLabel", Main)
AmountLabel.Position = UDim2.new(0, 10, 0, 80)
AmountLabel.Size = UDim2.new(0, 100, 0, 30)
AmountLabel.Text = "AMOUNT:"
AmountLabel.TextColor3 = Color3.new(1, 1, 1)
AmountLabel.BackgroundTransparency = 1
AmountLabel.Font = Enum.Font.FredokaOne
AmountLabel.TextScaled = true

local AmountBox = Instance.new("TextBox", Main)
AmountBox.Position = UDim2.new(0, 120, 0, 80)
AmountBox.Size = UDim2.new(0, 160, 0, 30)
AmountBox.PlaceholderText = "10, 25, 100..."
AmountBox.Font = Enum.Font.FredokaOne
AmountBox.TextScaled = true
AmountBox.Text = ""

local GetButton = Instance.new("TextButton", Main)
GetButton.Position = UDim2.new(0.5, -100, 0, 130)
GetButton.Size = UDim2.new(0, 200, 0, 40)
GetButton.Text = "GET"
GetButton.TextScaled = true
GetButton.Font = Enum.Font.FredokaOne
GetButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

local MadeBy = Instance.new("TextLabel", Main)
MadeBy.Position = UDim2.new(0, 0, 1, -30)
MadeBy.Size = UDim2.new(1, 0, 0, 30)
MadeBy.Text = "MADE BY: @SkibidiScript"
MadeBy.TextScaled = true
MadeBy.Font = Enum.Font.FredokaOne
MadeBy.BackgroundTransparency = 1
rainbowify(MadeBy)

-- Seed Giver Logic
GetButton.MouseButton1Click:Connect(function()
    local seedName = SeedBox.Text
    local amount = tonumber(AmountBox.Text)

    if not seedName or seedName == "" or not amount or amount <= 0 then
        warn("Please enter a valid seed name and amount")
        return
    end

    GetButton.Text = "WAITING 10S..."
    GetButton.Active = false
    task.wait(10)
    GetButton.Text = "GET"
    GetButton.Active = true

    -- Try to find the RemoteEvent
    local remote = ReplicatedStorage:FindFirstChild("RemoteEvent") or ReplicatedStorage:FindFirstChildWhichIsA("RemoteEvent")
    if remote then
        for i = 1, amount do
            remote:FireServer(seedName)
            task.wait(0.1)
        end
        inventory[seedName] = (inventory[seedName] or 0) + amount
        saveData(inventory)
    else
        warn("RemoteEvent not found. Cannot give seeds.")
    end
end)

-- Auto-load previous inventory (optional feature, can show it in chat)
for seed, amt in pairs(inventory) do
    print("[FREE SEED HUB] Loaded:", seed, amt)
end
