if game.CoreGui:FindFirstChild("FreeSeedHub") then
    game.CoreGui:FindFirstChild("FreeSeedHub"):Destroy()
end

local HttpService = game:GetService("HttpService")

local function saveInventory(data)
    writefile("FreeSeedHubData.json", HttpService:JSONEncode(data))
end

local function loadInventory()
    if isfile("FreeSeedHubData.json") then
        return HttpService:JSONDecode(readfile("FreeSeedHubData.json"))
    else
        return {}
    end
end

local inventory = loadInventory()

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FreeSeedHub"

local Frame = Instance.new("Frame", ScreenGui)
Frame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Frame.Size = UDim2.new(0, 300, 0, 300)
Frame.Position = UDim2.new(0.5, -150, 0.5, -150)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 15)

-- Title
local Title = Instance.new("TextLabel", Frame)
Title.Text = "FREE SEED HUB"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.FredokaOne
Title.TextScaled = true

-- Seed Name Input
local SeedNameLabel = Instance.new("TextLabel", Frame)
SeedNameLabel.Text = "SEED NAME:"
SeedNameLabel.Size = UDim2.new(1, -20, 0, 25)
SeedNameLabel.Position = UDim2.new(0, 10, 0, 50)
SeedNameLabel.BackgroundTransparency = 1
SeedNameLabel.Font = Enum.Font.FredokaOne
SeedNameLabel.TextColor3 = Color3.new(1, 1, 1)
SeedNameLabel.TextScaled = true

local SeedNameBox = Instance.new("TextBox", Frame)
SeedNameBox.PlaceholderText = "Text"
SeedNameBox.Size = UDim2.new(1, -20, 0, 25)
SeedNameBox.Position = UDim2.new(0, 10, 0, 80)
SeedNameBox.Font = Enum.Font.SourceSans
SeedNameBox.TextScaled = true

-- Amount Input
local AmountLabel = Instance.new("TextLabel", Frame)
AmountLabel.Text = "Amount:"
AmountLabel.Size = UDim2.new(1, -20, 0, 25)
AmountLabel.Position = UDim2.new(0, 10, 0, 115)
AmountLabel.BackgroundTransparency = 1
AmountLabel.Font = Enum.Font.FredokaOne
AmountLabel.TextColor3 = Color3.new(1, 1, 1)
AmountLabel.TextScaled = true

local AmountBox = Instance.new("TextBox", Frame)
AmountBox.PlaceholderText = "Text"
AmountBox.Size = UDim2.new(1, -20, 0, 25)
AmountBox.Position = UDim2.new(0, 10, 0, 145)
AmountBox.Font = Enum.Font.SourceSans
AmountBox.TextScaled = true

-- Get Button
local GetButton = Instance.new("TextButton", Frame)
GetButton.Text = "Get"
GetButton.Size = UDim2.new(1, -20, 0, 35)
GetButton.Position = UDim2.new(0, 10, 0, 185)
GetButton.Font = Enum.Font.FredokaOne
GetButton.TextScaled = true
GetButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
local GetUICorner = Instance.new("UICorner", GetButton)
GetUICorner.CornerRadius = UDim.new(0, 10)

-- Rainbow Credit Label
local Credit = Instance.new("TextLabel", Frame)
Credit.Text = "MADE BY: @SkibidiScript"
Credit.Size = UDim2.new(1, -20, 0, 25)
Credit.Position = UDim2.new(0, 10, 1, -30)
Credit.BackgroundTransparency = 1
Credit.Font = Enum.Font.FredokaOne
Credit.TextScaled = true

-- Rainbow Effect
task.spawn(function()
    while true do
        for hue = 0, 1, 0.01 do
            Credit.TextColor3 = Color3.fromHSV(hue, 1, 1)
            task.wait(0.05)
        end
    end
end)

-- Button Logic
GetButton.MouseButton1Click:Connect(function()
    local seed = SeedNameBox.Text
    local amount = tonumber(AmountBox.Text)

    if seed == "" or not amount then
        GetButton.Text = "Invalid Input"
        wait(1)
        GetButton.Text = "Get"
        return
    end

    GetButton.Text = "Processing..."
    wait(10)

    inventory[seed] = (inventory[seed] or 0) + amount
    saveInventory(inventory)

    GetButton.Text = "Done!"
    wait(2)
    GetButton.Text = "Get"
end)
