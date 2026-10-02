-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")

repeat
    task.wait()
until Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local vector3 = Vector3.new(0, 0, -3)
local t1 = {
	MAIN_USERNAME = "",
	SELECTED_QUEST_SLOT = 4,
	AUTO_REFRESH_QUESTS = true,
	GLITCH_QUEST_1 = 1,
	GLITCH_QUEST_2 = 2,
	REQUIRED_PLAYERS = 2,
	TP_DELAY = 3,
	PRIVATE_SERVER = "",
	PRIVATE_SERVER_DELAY = 3,
	M1_CLICK_DELAY = 0.2,
	M1_HOLD_DURATION = 0.05,
	ALT_TP_INTERVAL = 0.5,
	ALT_TP_OFFSET = vector3,
	AUTO_SKILLS = false,
	SKILL_1 = true,
	SKILL_2 = true,
	SKILL_3 = true,
	SKILL_4 = true,
	SKILL_DELAY = 0.5,
	AUTO_M1 = true,
	ENGINE_ENABLED = false,
	AUTO_HIDE_UI = true,
	TOGGLE_UI_KEY = "L",
	TOGGLE_ENGINE_KEY = "R"
}
pcall(function()
    if not isfile or not readfile then
        return
    end

    if isfile("abaquestfarm/config.json") then
        local data = HttpService:JSONDecode(readfile("abaquestfarm/config.json"))

        if type(data) == "table" then
            for k, v in pairs(data) do
                local v48 = k

                if t1[v48] ~= nil then
                    t1[v48] = v
                end
            end

            print("⚙\239\184\143 Configuration successfully loaded from workspace!")
        end
    end
end)

local u9 = (t1.ENGINE_ENABLED == true)
local lastEngineStart = 0
local function v10(p1)
    local n1 = 0

    while n1 < p1 and u9 do
        task.wait(0.1)
        n1 += 0.1
    end
end
local function u11(p2)
    local num = tonumber(p2)

    if num then
        return "Q" .. tostring(num)
    end

    return tostring(p2)
end
local function v12()
    if tick() - lastEngineStart < 2 then
        return
    end
    lastEngineStart = tick()

    
    local v51 = t1.MAIN_USERNAME == ""

    if not v51 then
        v51 = t1.MAIN_USERNAME == "EnterMainUsernameHere"
    end

    if v51 then
        warn("⚠ Auto Farm aborted: Please set your MAIN_USERNAME in the UI!")

        return
    end

    if string.lower(LocalPlayer.Name) == string.lower(t1.MAIN_USERNAME) then
        print("🟢 MAIN account detected and active: " .. LocalPlayer.Name)
        task.spawn(function()
            if not game:IsLoaded() then
                game.Loaded:Wait()
            end

            if not u9 then
                return
            end

            local QuestStuff = ReplicatedStorage:WaitForChild("QuestStuff", 999)
            local ReplicatedStats = LocalPlayer:WaitForChild("ReplicatedStats", 10)
            local v85 = ReplicatedStats and ReplicatedStats:WaitForChild("DailyQuest", 10)

            if not QuestStuff or not v85 then
                return
            end

            local v86 = false
            local u87 = false
            local s1 = "Kills"
            local n2 = 3
            local s2 = ""
            local v91 = u11(t1.SELECTED_QUEST_SLOT)
            local v92 = u11(t1.GLITCH_QUEST_1)
            local v93 = u11(t1.GLITCH_QUEST_2)
            local n3 = 0

            while true do
                local v95 = not v86

                if v95 then
                    v95 = u9 and n3 < 5
                end

                if not v95 then
                    break
                end

                n3 += 1

                if t1.AUTO_REFRESH_QUESTS and n3 == 1 then
                    for _ = 1, 4 do
                        if not u9 then
                            return
                        end

                        QuestStuff:FireServer("Take", v92)
                        task.wait(0.05)
                        QuestStuff:FireServer("Take", v93)
                        task.wait(0.05)
                    end

                    task.wait(0.1)
                end

                if not u9 then
                    return
                end

                QuestStuff:FireServer("Take", v91)
                task.wait(0.4)
                QuestStuff:FireServer("Close")

                local s3 = ""

                for _ = 1, 25 do
                    if not u9 then
                        return
                    end

                    local Value = v85.Value

                    if Value then
                        Value = v85.Value ~= ""
                    end

                    if Value then
                        s3 = tostring(v85.Value)

                        break
                    end

                    task.wait(0.1)
                end

                if s3 ~= "" then
                    local ok, result = pcall(function()
                        return HttpService:JSONDecode(s3)
                    end)

                    if ok then
                        ok = type(result) == "table"
                    end

                    if ok then
                        local v102 = result[v91]

                        if v102 and v102.Requirements then
                            s2 = v102.Requirements.Character or ""

                            if v102.Requirements.Combo then
                                s1 = "Combo"
                                n2 = tonumber(v102.Requirements.Combo) or 0
                            elseif v102.Requirements.Damage then
                                s1 = "Damage"
                                n2 = tonumber(v102.Requirements.Damage) or 0
                            elseif v102.Requirements.Points then
                                s1 = "Points"
                                n2 = tonumber(v102.Requirements.Points) or 0
                            elseif v102.Requirements.Kills then
                                s1 = "Kills"
                                n2 = tonumber(v102.Requirements.Kills) or 0
                            end

                            local Description = v102.Description

                            if Description then
                                Description = v102.Description:lower():find("mode")

                                if not Description then
                                    Description = v102.Description:lower():find("awaken")
                                end
                            end

                            if Description then
                                s1 = "ModeKills"
                            end

                            v86 = true
                        end
                    end
                end

                if not v86 then
                    print("⚠\239\184\143 Quest data sync delayed, retrying... (Attempt " .. n3 .. "/5)")
                    task.wait(0.8)
                end
            end

            if not v86 or not u9 then
                warn("❌ Failed to load quest data after multiple attempts.")

                return
            end

            print(string.format("🎯 Target Loaded | Mode: %s | Target: %d | Character: '%s'", s1, n2, s2))

            local v104 = s2

            if v104 then
                v104 = s2 ~= "" and u9
            end

            if v104 then
                pcall(function()
                    local Backpack = LocalPlayer:WaitForChild("Backpack", 10)
                    local v113 = Backpack and Backpack:WaitForChild("Input", 10)

                    if v113 then
                        v113:FireServer("CharacterButton", s2)
                        task.wait(0.05)
                        v113:FireServer("ClickPlay")
                    end
                end)
            end

            if v86 then
                v86 = #Players:GetPlayers() >= t1.REQUIRED_PLAYERS and u9
            end

            if v86 then
                task.spawn(function()
                    local leaderstats = LocalPlayer:WaitForChild("leaderstats", 10)
                    local v116 = leaderstats
                    if v116 then
                        v116 = leaderstats:FindFirstChild("Kills")

                        if v116 then
                            v116 = tonumber(leaderstats.Kills.Value)
                        end
                    end
                    local u117 = v116 or 0
                    local v118 = leaderstats
                    if v118 then
                        v118 = leaderstats:FindFirstChild("Damage")

                        if v118 then
                            v118 = tonumber(leaderstats.Damage.Value)
                        end
                    end
                    local v119 = leaderstats
                    local v120 = v118 or 0
                    if v119 then
                        v119 = leaderstats:FindFirstChild("Points")

                        if v119 then
                            v119 = tonumber(leaderstats.Points.Value)
                        end
                    end
                    local v121 = v119 or 0
                    local v122 = u117
                    local v123 = s1 == "Kills"
                    if not v123 then
                        v123 = s1 == "ModeKills"
                    end
                    local u124 = v122 + (v123 and n2 or 0)
                    local v125 = v120 + (s1 == "Damage" and n2 or 0)
                    local v126 = s1 == "Points" and n2
                    local v127 = LocalPlayer
                    local v128 = v121 + (v126 or 0)
                    v127.CharacterAdded:Connect(function()
                        local v158 = not u87

                        if v158 then
                            v158 = leaderstats and u9
                        end

                        if v158 then
                            task.wait(0.5)

                            local Kills = leaderstats:FindFirstChild("Kills")

                            if Kills then
                                Kills = tonumber(leaderstats.Kills.Value)
                            end

                            u117 = Kills or 0

                            local v160 = u117
                            local v161 = s1 == "Kills"

                            if not v161 then
                                v161 = s1 == "ModeKills"
                            end

                            u124 = v160 + (v161 and n2 or 0)
                        end
                    end)
                    while u9 and not u87 do
                        local v129 = false
                        local leaderstats2 = LocalPlayer:FindFirstChild("leaderstats")

                        if leaderstats2 and n2 > 0 then
                            local v131 = s1 == "Kills"

                            if not v131 then
                                v131 = s1 == "ModeKills"
                            end

                            if v131 then
                                local Kills = leaderstats2:FindFirstChild("Kills")

                                if Kills then
                                    Kills = tonumber(leaderstats2.Kills.Value)
                                end

                                local v133 = u124
                                local v134 = Kills or 0

                                v129 = v133 <= v134

                                if v129 then
                                    v129 = v134 > u117
                                end
                            elseif s1 == "Damage" then
                                local Damage = leaderstats2:FindFirstChild("Damage")

                                if Damage then
                                    Damage = tonumber(leaderstats2.Damage.Value)
                                end

                                local v136 = Damage or 0

                                v129 = v125 <= v136 and v120 < v136
                            elseif s1 == "Points" then
                                local Points = leaderstats2:FindFirstChild("Points")

                                if Points then
                                    Points = tonumber(leaderstats2.Points.Value)
                                end

                                local v138 = Points or 0

                                v129 = v128 <= v138 and v121 < v138
                            end
                        end

                        if v129 and not u87 then
                            u87 = true
                            print("✅ Quest goal achieved via Leaderstats!")
                            v10((math.max(0, 1 + t1.TP_DELAY)))

                            if u9 then
                                local Train = ReplicatedStorage:WaitForChild("Train", 10)

                                if Train then
                                    Train:FireServer()
                                end
                            end

                            break
                        end

                        task.wait(0.2)
                    end
                end)
                task.spawn(function()
                    print("⚔ Combat Loop ACTIVE for mode: " .. s1)

                    local t2 = {
						Enum.KeyCode.One,
						Enum.KeyCode.Two,
						Enum.KeyCode.Three,
						Enum.KeyCode.Four
					}
                    local n4 = 1
                    local v142 = n4

                    while u9 and not u87 do
                        if s1 == "ModeKills" then
                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.G, false, game)
                            task.wait(0.02)
                            n4 = VirtualInputManager
                            n4:SendKeyEvent(false, Enum.KeyCode.G, false, game)
                        end

                        if s1 == "Combo" then
                            n4 = LocalPlayer

                            local Stats = n4:FindFirstChild("Stats")
                            local v144 = Stats and Stats:FindFirstChild("Combo")

                            if v144 then
                                v144 = tonumber(v144.Value)
                            end

                            local v145 = v144 or 0

                            if v145 >= n2 then
                                print("🛑 Combo target reached (" .. v145 .. "). Holding for drop...")
                                v10(6)

                                if not u87 and u9 then
                                    u87 = true
                                    v10((math.max(0, 1 + t1.TP_DELAY)))

                                    if not u9 then
                                        return
                                    end

                                    local Train = ReplicatedStorage:WaitForChild("Train", 10)

                                    if not Train then
                                        return
                                    end

                                    Train:FireServer()

                                    return
                                end
                            end
                        end

                        if not u87 and u9 then
                            if t1.AUTO_SKILLS then
                                local v147 = false

                                for i = 1, 4 do
                                    if not u9 or u87 then
                                        break
                                    end

                                    local v149 = (v142 + i - 2) % 4 + 1

                                    if ({
										function()
                                        return t1.SKILL_1
                                    end,
										function()
                                        return t1.SKILL_2
                                    end,
										function()
                                        return t1.SKILL_3
                                    end,
										function()
                                        return t1.SKILL_4
                                    end
									})[v149]() then
                                        VirtualInputManager:SendKeyEvent(true, t2[v149], false, game)
                                        task.wait(0.05)
                                        VirtualInputManager:SendKeyEvent(false, t2[v149], false, game)
                                        v142 = v149 % 4 + 1
                                        v147 = true
                                        task.wait(t1.SKILL_DELAY)

                                        break
                                    end
                                end

                                if not v147 then
                                    task.wait(0.2)
                                end
                            end

                            local v150 = not u87

                            if v150 then
                                v150 = u9

                                if v150 then
                                    v150 = t1.AUTO_M1
                                end
                            end

                            if v150 then
                                local v151 = VirtualInputManager

                                v151:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                                task.wait(t1.M1_HOLD_DURATION)
                                v151:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                            end

                            task.wait(t1.M1_CLICK_DELAY)
                        end
                    end
                end)
            end

            task.spawn(function()
                if #Players:GetPlayers() > 1 then
                    return
                end

                if getgenv()._ABA_Currently_In_PS then
                    return
                end

                v10(t1.PRIVATE_SERVER_DELAY)

                if not u9 then
                    return
                end

                getgenv()._ABA_Currently_In_PS = true

                local PS = ReplicatedStorage:WaitForChild("PS", 10)
                local v153 = PS

                if PS then
                    v153 = t1.PRIVATE_SERVER ~= ""

                    if v153 then
                        v153 = t1.PRIVATE_SERVER ~= "Enter PS Code (Optional)"
                    end
                end

                if v153 then
                    PS:FireServer("join", t1.PRIVATE_SERVER)
                end
            end)
        end)

        return
    end

    print("🔵 ALT detected and active: " .. LocalPlayer.Name)
    task.spawn(function()
        pcall(function()
            if getconnections then
                for _, v in pairs(getconnections(LocalPlayer.Idled)) do
                    local v156 = v

                    pcall(function()
                        v156:Disable()
                    end)
                    pcall(function()
                        v156:Disconnect()
                    end)
                end
            end

            local v157 = getgenv and getgenv() or _G

            if v157._AIO_AntiAfkConnection then
                pcall(function()
                    v157._AIO_AntiAfkConnection:Disconnect()
                end)
            end

            v157._AIO_AntiAfkConnection = LocalPlayer.Idled:Connect(function()
                local VirtualInputManager2 = Instance.new("VirtualInputManager")

                VirtualInputManager2:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                VirtualInputManager2:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                VirtualInputManager2:Destroy()
            end)
        end)
    end)

    local function v52(p3)
        if p3 then
            local Character = p3.Character

            if Character then
                Character = p3.Character:FindFirstChild("HumanoidRootPart")
            end

            p3 = Character
        end

        return p3
    end

    task.spawn(function()
        while u9 do
            local t1MAIN_USERNAME = Players:FindFirstChild(t1.MAIN_USERNAME)

            if t1MAIN_USERNAME and t1MAIN_USERNAME ~= LocalPlayer then
                local v108 = v52(LocalPlayer)
                local v109 = v52(t1MAIN_USERNAME)

                if v108 and v109 then
                    v108.CFrame = v109.CFrame * CFrame.new(t1.ALT_TP_OFFSET)
                    v108.AssemblyLinearVelocity = Vector3.zero
                end
            end

            v10(t1.ALT_TP_INTERVAL)
        end
    end)
end
-- ===================================================================
--   LARP AROI HUB  |  Custom UI (ไม่ใช้ library ภายนอก)
-- ===================================================================
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local function saveConfig()
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        local data = {}
        for k, v in pairs(t1) do
            local tv = type(v)
            if tv == "string" or tv == "number" or tv == "boolean" then
                data[k] = v
            end
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(data))
    end)
end

local function buildUI()
    local THEME = {
        bg = Color3.fromRGB(6, 13, 27),
        panel = Color3.fromRGB(10, 21, 40),
        card = Color3.fromRGB(14, 29, 53),
        line = Color3.fromRGB(26, 50, 86),
        accent = Color3.fromRGB(47, 155, 255),
        accent2 = Color3.fromRGB(0, 229, 255),
        deep = Color3.fromRGB(0, 98, 255),
        text = Color3.fromRGB(230, 244, 255),
        sub = Color3.fromRGB(116, 150, 186),
        off = Color3.fromRGB(32, 50, 78),
        danger = Color3.fromRGB(255, 82, 104),
        good = Color3.fromRGB(70, 255, 170)
    }
    local WHITE = Color3.new(1, 1, 1)
    local Font = Enum.Font

    -- ---------- helpers ----------
    local function new(class, props, kids)
        local inst = Instance.new(class)
        local parent
        for k, v in pairs(props or {}) do
            if k == "Parent" then
                parent = v
            else
                inst[k] = v
            end
        end
        for _, kid in ipairs(kids or {}) do
            kid.Parent = inst
        end
        if parent then
            inst.Parent = parent
        end
        return inst
    end

    local function corner(r)
        return new("UICorner", {CornerRadius = UDim.new(0, r)})
    end

    local function stroke(color, thickness, transparency)
        return new("UIStroke", {
            Color = color,
            Thickness = thickness or 1,
            Transparency = transparency or 0,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
    end

    local function tween(obj, time, props)
        TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
    end

    local orderCounter = 0
    local function nextOrder()
        orderCounter += 1
        return orderCounter
    end

    local listening = false

    -- ---------- screen gui ----------
    local guiParent = (gethui and gethui()) or CoreGui
    pcall(function()
        local old = guiParent:FindFirstChild("ABAQuestFarm")
        if old then
            old:Destroy()
        end
    end)

    local gui = new("ScreenGui", {
        Name = "ABAQuestFarm",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    local okParent = pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        end
        gui.Parent = guiParent
    end)
    if not okParent or not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- ---------- main window ----------
    local main = new("Frame", {
        Name = "Main",
        Size = UDim2.fromOffset(540, 400),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0,
        Parent = gui
    }, {
        corner(16),
        new("UIGradient", {
            Color = ColorSequence.new(Color3.fromRGB(8, 18, 36), Color3.fromRGB(5, 10, 22)),
            Rotation = 90
        })
    })
    local uiScale = new("UIScale", {Scale = 1, Parent = main})

    -- กรอบเรืองแสงวิ่งวน
    local glow = stroke(WHITE, 2, 0)
    glow.Parent = main
    local glowGrad = new("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, THEME.accent2),
            ColorSequenceKeypoint.new(0.35, THEME.deep),
            ColorSequenceKeypoint.new(0.65, Color3.fromRGB(10, 30, 70)),
            ColorSequenceKeypoint.new(1, THEME.accent2)
        }),
        Parent = glow
    })
    task.spawn(function()
        local r = 0
        while gui.Parent do
            r = (r + 2) % 360
            glowGrad.Rotation = r
            task.wait(0.03)
        end
    end)

    -- ---------- header ----------
    local header = new("Frame", {
        Name = "Header",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 54),
        Parent = main
    })

    local logo = new("Frame", {
        Position = UDim2.fromOffset(14, 10),
        Size = UDim2.fromOffset(34, 34),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0,
        Parent = header
    }, {
        corner(10),
        new("UIGradient", {Color = ColorSequence.new(THEME.accent2, THEME.deep), Rotation = 45})
    })
    new("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "L",
        Font = Font.GothamBlack,
        TextSize = 20,
        TextColor3 = WHITE,
        Parent = logo
    })

    new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(58, 6),
        Size = UDim2.fromOffset(240, 22),
        Text = "LARP AROI HUB",
        Font = Font.GothamBlack,
        TextSize = 19,
        TextColor3 = WHITE,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    }, {
        new("UIGradient", {Color = ColorSequence.new(THEME.accent2, THEME.accent)})
    })
    new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(58, 29),
        Size = UDim2.fromOffset(240, 14),
        Text = "ABA Quest Farm  •  Azure Edition",
        Font = Font.Gotham,
        TextSize = 11,
        TextColor3 = THEME.sub,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = header
    })

    -- status pill
    local pill = new("Frame", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -52, 0.5, 0),
        Size = UDim2.fromOffset(98, 26),
        BackgroundColor3 = THEME.card,
        BorderSizePixel = 0,
        Parent = header
    }, {corner(13), stroke(THEME.line, 1, 0)})
    local dot = new("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 11, 0.5, 0),
        Size = UDim2.fromOffset(8, 8),
        BackgroundColor3 = THEME.sub,
        BorderSizePixel = 0,
        Parent = pill
    }, {corner(4)})
    local statusText = new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(26, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Text = "IDLE",
        Font = Font.GothamBold,
        TextSize = 11,
        TextColor3 = THEME.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = pill
    })

    local closeBtn = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -14, 0.5, 0),
        Size = UDim2.fromOffset(28, 28),
        BackgroundColor3 = THEME.card,
        BorderSizePixel = 0,
        Text = "X",
        Font = Font.GothamBold,
        TextSize = 12,
        TextColor3 = THEME.sub,
        AutoButtonColor = false,
        Parent = header
    }, {corner(8)})
    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, 0.15, {BackgroundColor3 = THEME.danger, TextColor3 = WHITE})
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, 0.15, {BackgroundColor3 = THEME.card, TextColor3 = THEME.sub})
    end)

    -- ---------- drag ----------
    local function makeDraggable(handle, target)
        local dragging, dragStart, startPos = false, nil, nil
        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = target.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local d = input.Position - dragStart
                target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end
    makeDraggable(header, main)

    -- ---------- tabs ----------
    local tabBar = new("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 54),
        Size = UDim2.new(1, -24, 0, 32),
        Parent = main
    }, {
        new("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
    })
    new("Frame", {
        Position = UDim2.fromOffset(12, 88),
        Size = UDim2.new(1, -24, 0, 1),
        BackgroundColor3 = THEME.line,
        BorderSizePixel = 0,
        Parent = main
    })

    local tabs = {}
    local function selectTab(name)
        for n, t in pairs(tabs) do
            local active = (n == name)
            t.page.Visible = active
            tween(t.btn, 0.15, {TextColor3 = active and THEME.accent2 or THEME.sub})
            tween(t.bar, 0.2, {Size = active and UDim2.new(1, -16, 0, 2) or UDim2.new(0, 0, 0, 2)})
        end
    end

    local function addTab(name)
        local page = new("ScrollingFrame", {
            Name = name,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(12, 96),
            Size = UDim2.new(1, -24, 1, -124),
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = THEME.accent,
            Visible = false,
            Parent = main
        }, {
            new("UIListLayout", {Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}),
            new("UIPadding", {PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 6)})
        })

        local btn = new("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(96, 32),
            Text = name,
            Font = Font.GothamBold,
            TextSize = 12,
            TextColor3 = THEME.sub,
            LayoutOrder = nextOrder(),
            Parent = tabBar
        })
        local bar = new("Frame", {
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, 0),
            Size = UDim2.new(0, 0, 0, 2),
            BackgroundColor3 = WHITE,
            BorderSizePixel = 0,
            Parent = btn
        }, {
            corner(1),
            new("UIGradient", {Color = ColorSequence.new(THEME.accent2, THEME.deep)})
        })

        tabs[name] = {page = page, btn = btn, bar = bar}
        btn.MouseButton1Click:Connect(function()
            selectTab(name)
        end)
        return page
    end

    -- ---------- footer ----------
    local footer = new("TextLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 16, 1, -6),
        Size = UDim2.new(1, -32, 0, 14),
        Text = "",
        Font = Font.Gotham,
        TextSize = 10,
        TextColor3 = THEME.sub,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = main
    })

    -- ---------- components ----------
    local function makeCard(parent, title, desc, height)
        height = height or (desc and 52 or 44)
        local card = new("Frame", {
            Size = UDim2.new(1, 0, 0, height),
            BackgroundColor3 = THEME.card,
            BorderSizePixel = 0,
            LayoutOrder = nextOrder(),
            Parent = parent
        }, {corner(10), stroke(THEME.line, 1, 0)})

        new("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(14, desc and 8 or 0),
            Size = UDim2.new(1, -190, 0, desc and 20 or height),
            Text = title,
            Font = Font.GothamBold,
            TextSize = 13,
            TextColor3 = THEME.text,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = card
        })
        if desc then
            new("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(14, 28),
                Size = UDim2.new(1, -190, 0, 16),
                Text = desc,
                Font = Font.Gotham,
                TextSize = 11,
                TextColor3 = THEME.sub,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = card
            })
        end
        return card
    end

    local function addToggle(parent, title, desc, value, callback)
        local card = makeCard(parent, title, desc)
        local cardStroke = card:FindFirstChildOfClass("UIStroke")
        local state = value and true or false

        local track = new("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(44, 22),
            BackgroundColor3 = state and THEME.accent or THEME.off,
            BorderSizePixel = 0,
            Parent = card
        }, {corner(11)})
        local knob = new("Frame", {
            AnchorPoint = Vector2.new(0, 0.5),
            Position = state and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
            Size = UDim2.fromOffset(16, 16),
            BackgroundColor3 = WHITE,
            BorderSizePixel = 0,
            Parent = track
        }, {corner(8)})
        local btn = new("TextButton", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            Parent = card
        })

        local function render()
            tween(track, 0.18, {BackgroundColor3 = state and THEME.accent or THEME.off})
            tween(knob, 0.18, {Position = state and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 4, 0.5, 0)})
        end

        btn.MouseEnter:Connect(function()
            tween(cardStroke, 0.15, {Color = THEME.accent})
        end)
        btn.MouseLeave:Connect(function()
            tween(cardStroke, 0.15, {Color = THEME.line})
        end)
        btn.MouseButton1Click:Connect(function()
            state = not state
            render()
            callback(state)
        end)

        return {
            Set = function(v)
                state = v and true or false
                render()
            end
        }
    end

    local function addInput(parent, title, desc, value, placeholder, callback)
        local card = makeCard(parent, title, desc)
        local boxStroke = stroke(THEME.line, 1, 0)
        local box = new("TextBox", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(150, 28),
            BackgroundColor3 = THEME.bg,
            BorderSizePixel = 0,
            Text = tostring(value or ""),
            PlaceholderText = placeholder or "",
            PlaceholderColor3 = THEME.sub,
            TextColor3 = THEME.text,
            Font = Font.Gotham,
            TextSize = 12,
            ClearTextOnFocus = false,
            Parent = card
        }, {corner(8), boxStroke})

        box.Focused:Connect(function()
            tween(boxStroke, 0.15, {Color = THEME.accent2})
        end)
        box.FocusLost:Connect(function()
            tween(boxStroke, 0.15, {Color = THEME.line})
            callback(box.Text)
        end)
        return box
    end

    local refreshAll -- forward declaration

    local function addKeybind(parent, title, desc, value, callback)
        local card = makeCard(parent, title, desc)
        local current = tostring(value or "None")
        local btn = new("TextButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(84, 28),
            BackgroundColor3 = THEME.bg,
            BorderSizePixel = 0,
            Text = current,
            Font = Font.GothamBold,
            TextSize = 12,
            TextColor3 = THEME.accent2,
            AutoButtonColor = false,
            Parent = card
        }, {corner(8), stroke(THEME.accent, 1, 0.3)})

        btn.MouseButton1Click:Connect(function()
            if listening then
                return
            end
            listening = true
            btn.Text = "..."
            local conn
            conn = UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    conn:Disconnect()
                    if input.KeyCode ~= Enum.KeyCode.Escape then
                        current = input.KeyCode.Name
                        callback(current)
                    end
                    btn.Text = current
                    task.delay(0.2, function()
                        listening = false
                    end)
                end
            end)
        end)
        return btn
    end

    local function addSkillChips(parent)
        local card = makeCard(parent, "Skill Selection", "เลือกสกิลที่จะให้ใช้อัตโนมัติ", 52)
        local holder = new("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            Size = UDim2.fromOffset(176, 28),
            BackgroundTransparency = 1,
            Parent = card
        }, {
            new("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        })

        for i = 1, 4 do
            local key = "SKILL_" .. i
            local chip = new("TextButton", {
                Size = UDim2.fromOffset(38, 28),
                BackgroundColor3 = t1[key] and THEME.accent or THEME.off,
                BorderSizePixel = 0,
                Text = tostring(i),
                Font = Font.GothamBlack,
                TextSize = 13,
                TextColor3 = t1[key] and WHITE or THEME.sub,
                AutoButtonColor = false,
                LayoutOrder = i,
                Parent = holder
            }, {corner(8)})
            chip.MouseButton1Click:Connect(function()
                t1[key] = not t1[key]
                saveConfig()
                tween(chip, 0.15, {
                    BackgroundColor3 = t1[key] and THEME.accent or THEME.off,
                    TextColor3 = t1[key] and WHITE or THEME.sub
                })
            end)
        end
    end

    -- ---------- pages ----------
    local mainPage = addTab("MAIN")
    local combatPage = addTab("COMBAT")
    local settingsPage = addTab("SETTINGS")

    -- hero (engine control)
    local hero = new("Frame", {
        Size = UDim2.new(1, 0, 0, 76),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0,
        LayoutOrder = nextOrder(),
        Parent = mainPage
    }, {
        corner(12),
        new("UIGradient", {
            Color = ColorSequence.new(Color3.fromRGB(16, 70, 135), Color3.fromRGB(9, 22, 46)),
            Rotation = 0
        }),
        stroke(THEME.accent, 1, 0.4)
    })
    new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(16, 14),
        Size = UDim2.new(1, -170, 0, 22),
        Text = "FARMING ENGINE",
        Font = Font.GothamBlack,
        TextSize = 17,
        TextColor3 = WHITE,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = hero
    })
    local heroSub = new("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(16, 40),
        Size = UDim2.new(1, -170, 0, 16),
        Text = "",
        Font = Font.Gotham,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(160, 200, 240),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = hero
    })
    local heroBtn = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -16, 0.5, 0),
        Size = UDim2.fromOffset(120, 42),
        BackgroundColor3 = THEME.accent,
        BorderSizePixel = 0,
        Text = "START",
        Font = Font.GothamBlack,
        TextSize = 15,
        TextColor3 = WHITE,
        AutoButtonColor = false,
        Parent = hero
    }, {corner(11)})

    local engineToggle -- reserved

    local function refreshEngine()
        local on = t1.ENGINE_ENABLED == true
        heroBtn.Text = on and "STOP" or "START"
        tween(heroBtn, 0.2, {BackgroundColor3 = on and THEME.danger or THEME.accent})
        heroSub.Text = (on and "กำลังทำงาน" or "พร้อมทำงาน") .. "  •  Hotkey [" .. tostring(t1.TOGGLE_ENGINE_KEY) .. "]"
        statusText.Text = on and "FARMING" or "IDLE"
        tween(dot, 0.2, {BackgroundColor3 = on and THEME.good or THEME.sub})
        footer.Text = "กด [" .. tostring(t1.TOGGLE_UI_KEY) .. "] เพื่อเปิด/ปิดเมนู   •   Larp Aroi Hub"
    end
    refreshAll = refreshEngine

    local function setEngine(on)
        t1.ENGINE_ENABLED = on
        u9 = on
        saveConfig()
        refreshEngine()

        if on then
            print("🚀 Farming Engine STARTED")
            task.spawn(v12)
        else
            print("🛑 Farming Engine STOPPED")
        end
    end

    heroBtn.MouseButton1Click:Connect(function()
        setEngine(not (t1.ENGINE_ENABLED == true))
    end)

    -- MAIN tab
    addInput(mainPage, "Main Username", "ชื่อผู้เล่นของอัคหลัก (ต้องตรงเป๊ะ)", t1.MAIN_USERNAME, "Username...", function(v)
        t1.MAIN_USERNAME = v
        saveConfig()
    end)
    addInput(mainPage, "Quest Slot Number", "ช่องเควสที่ต้องการ (1 - 6)", tostring(t1.SELECTED_QUEST_SLOT), "4", function(v)
        local num = tonumber(v)
        if num then
            t1.SELECTED_QUEST_SLOT = num
            saveConfig()
        end
    end)
    addToggle(mainPage, "Auto Refresh Quests", "เปิดกลิตช์รีเฟรชเควสทันที", t1.AUTO_REFRESH_QUESTS, function(v)
        t1.AUTO_REFRESH_QUESTS = v
        saveConfig()
    end)
    addInput(mainPage, "Glitch Quest Slot 1", "ช่องเควสแรกสำหรับกลิตช์ (เช่น 1)", tostring(t1.GLITCH_QUEST_1), "1", function(v)
        local num = tonumber(v)
        if num then
            t1.GLITCH_QUEST_1 = num
            saveConfig()
        end
    end)
    addInput(mainPage, "Glitch Quest Slot 2", "ช่องเควสที่สองสำหรับกลิตช์ (เช่น 2)", tostring(t1.GLITCH_QUEST_2), "2", function(v)
        local num = tonumber(v)
        if num then
            t1.GLITCH_QUEST_2 = num
            saveConfig()
        end
    end)
    addInput(mainPage, "Private Server Code", "โค้ดไพรเวทเซิร์ฟ (ไม่ใส่ก็ได้)", t1.PRIVATE_SERVER, "Code here...", function(v)
        t1.PRIVATE_SERVER = v
        saveConfig()
    end)

    -- COMBAT tab
    addToggle(combatPage, "Auto M1 Attacks", "เปิดโจมตีธรรมดาอัตโนมัติ", t1.AUTO_M1, function(v)
        t1.AUTO_M1 = v
        saveConfig()
    end)
    addToggle(combatPage, "Auto Skills", "เปิดกดสกิลอัตโนมัติ", t1.AUTO_SKILLS, function(v)
        t1.AUTO_SKILLS = v
        saveConfig()
    end)
    addSkillChips(combatPage)

    -- SETTINGS tab
    addKeybind(settingsPage, "Menu Toggle Key", "ปุ่มเปิด/ปิดเมนู", t1.TOGGLE_UI_KEY, function(v)
        t1.TOGGLE_UI_KEY = v
        saveConfig()
        refreshAll()
    end)
    addKeybind(settingsPage, "Engine Start/Stop Key", "ปุ่มเริ่ม/หยุดฟาร์ม", t1.TOGGLE_ENGINE_KEY, function(v)
        t1.TOGGLE_ENGINE_KEY = v
        saveConfig()
        refreshAll()
    end)
    addToggle(settingsPage, "Auto Hide UI on Start", "ซ่อนเมนูอัตโนมัติตอนรันสคริปต์", t1.AUTO_HIDE_UI, function(v)
        t1.AUTO_HIDE_UI = v
        saveConfig()
    end)

    -- ---------- open / close ----------
    local menuOpen = true
    local floatBtn

    local function setMenu(show)
        menuOpen = show
        if show then
            main.Visible = true
            uiScale.Scale = 0.9
            TweenService:Create(uiScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        else
            tween(uiScale, 0.12, {Scale = 0.9})
            task.delay(0.13, function()
                if not menuOpen then
                    main.Visible = false
                end
            end)
        end
    end

    closeBtn.MouseButton1Click:Connect(function()
        setMenu(false)
    end)

    -- ปุ่มลอยเล็กๆ สำหรับเปิดเมนูกลับ (ใช้บนมือถือได้)
    floatBtn = new("TextButton", {
        Name = "LarpFloat",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 12, 0.5, 0),
        Size = UDim2.fromOffset(44, 44),
        BackgroundColor3 = WHITE,
        BorderSizePixel = 0,
        Text = "L",
        Font = Font.GothamBlack,
        TextSize = 22,
        TextColor3 = WHITE,
        AutoButtonColor = false,
        Parent = gui
    }, {
        corner(22),
        new("UIGradient", {Color = ColorSequence.new(THEME.accent2, THEME.deep), Rotation = 45}),
        stroke(THEME.accent2, 2, 0.2)
    })
    floatBtn.MouseButton1Click:Connect(function()
        setMenu(not menuOpen)
    end)

    -- ---------- hotkeys ----------
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or listening then
            return
        end
        if input.KeyCode == Enum.KeyCode.Unknown then
            return
        end

        local name = input.KeyCode.Name
        if name == t1.TOGGLE_ENGINE_KEY then
            setEngine(not (t1.ENGINE_ENABLED == true))
            return
        end
        if name == t1.TOGGLE_UI_KEY then
            setMenu(not menuOpen)
        end
    end)

    -- ---------- init ----------
    selectTab("MAIN")
    refreshEngine()

    if t1.AUTO_HIDE_UI then
        task.delay(0.6, function()
            setMenu(false)
            print("👁 UI automatically hidden on launch.")
        end)
    end
end

local uiOk, uiErr = pcall(buildUI)
if not uiOk then
    warn("⚠ Larp Aroi Hub UI failed: " .. tostring(uiErr))
end

if t1.ENGINE_ENABLED then
    u9 = true
    task.spawn(v12)
end
