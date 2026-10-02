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
local ok, result = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
local v15 = not ok
if not v15 then
    v15 = not result
end
if v15 then
    warn("⚠ Failed to load WindUI! Running script without GUI interface.")

    if t1.ENGINE_ENABLED then
        u9 = true
        task.spawn(v12)
    end

    return
end
local _UDim2 = UDim2
local CreateWindow = result.CreateWindow
local v18 = _UDim2.fromOffset(580, 460)
local v19 = CreateWindow(result, {
	Title = "ABA Auto Quest Farm",
	Icon = "swords",
	Author = "Standalone",
	Folder = "ABAQuestFarm",
	Size = v18,
	Transparent = true,
	Theme = "Dark",
	SideBarWidth = 160
})
local v20 = v19:Tab({
	Title = "Main Setup",
	Icon = "home"
})
local v21 = v19:Tab({
	Title = "Combat Settings",
	Icon = "sword"
})
local MAIN_USERNAME = t1.MAIN_USERNAME
v20:Input({
	Title = "Main Username",
	Desc = "Enter the exact username of your Main account",
	Value = MAIN_USERNAME,
	Placeholder = "Username...",
	Callback = function(p4)
    t1.MAIN_USERNAME = p4
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)
end
})
local str = tostring(t1.SELECTED_QUEST_SLOT)

v20:Input({
	Title = "Quest Slot Number",
	Desc = "Target quest slot number (1 to 6)",
	Value = str,
	Placeholder = "4",
	Callback = function(p5)
    local num = tonumber(p5)

    if num then
        t1.SELECTED_QUEST_SLOT = num
        pcall(function()
            if not isfolder or not writefile then
                return
            end

            if not isfolder("abaquestfarm") then
                makefolder("abaquestfarm")
            end

            writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
        end)
    end
end
})
local Toggle = v20.Toggle
local AUTO_REFRESH_QUESTS = t1.AUTO_REFRESH_QUESTS
Toggle(v20, {
	Title = "Auto Refresh Quests",
	Desc = "Enable instant quest refresh glitch",
	Value = AUTO_REFRESH_QUESTS,
	Callback = function(p6)
    t1.AUTO_REFRESH_QUESTS = p6
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)
end
})
local str2 = tostring(t1.GLITCH_QUEST_1)

v20:Input({
	Title = "Glitch Quest Slot 1 Number",
	Desc = "First quest slot number for glitching (e.g. 1)",
	Value = str2,
	Placeholder = "1",
	Callback = function(p7)
    local num = tonumber(p7)

    if num then
        t1.GLITCH_QUEST_1 = num
        pcall(function()
            if not isfolder or not writefile then
                return
            end

            if not isfolder("abaquestfarm") then
                makefolder("abaquestfarm")
            end

            writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
        end)
    end
end
})
local str3 = tostring(t1.GLITCH_QUEST_2)

v20:Input({
	Title = "Glitch Quest Slot 2 Number",
	Desc = "Second quest slot number for glitching (e.g. 2)",
	Value = str3,
	Placeholder = "2",
	Callback = function(p8)
    local num = tonumber(p8)

    if num then
        t1.GLITCH_QUEST_2 = num
        pcall(function()
            if not isfolder or not writefile then
                return
            end

            if not isfolder("abaquestfarm") then
                makefolder("abaquestfarm")
            end

            writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
        end)
    end
end
})
local PRIVATE_SERVER = t1.PRIVATE_SERVER
v20:Input({
	Title = "Private Server Code",
	Desc = "Optional private server code to join automatically",
	Value = PRIVATE_SERVER,
	Placeholder = "Code here...",
	Callback = function(p9)
    t1.PRIVATE_SERVER = p9
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)
end
})
local ENGINE_ENABLED = t1.ENGINE_ENABLED
local v30 = v20:Toggle({
	Title = "Start / Stop Engine",
	Desc = "Unified toggle to start and stop the farming engine",
	Value = ENGINE_ENABLED,
	Callback = function(p10)
    t1.ENGINE_ENABLED = p10
    u9 = p10
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)

    if p10 then
        print("🚀 Farming Engine STARTED via UI toggle.")
        task.spawn(v12)

        return
    end

    print("🛑 Farming Engine STOPPED via UI toggle.")
end
})
local AUTO_HIDE_UI = t1.AUTO_HIDE_UI
v20:Toggle({
	Title = "Auto Hide UI on Start",
	Desc = "Hides UI automatically when the script executes",
	Value = AUTO_HIDE_UI,
	Callback = function(p11)
    t1.AUTO_HIDE_UI = p11
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)
end
})
local TOGGLE_UI_KEY = t1.TOGGLE_UI_KEY
v20:Keybind({
	Title = "Menu Toggle Key",
	Desc = "Key to open or close the UI menu",
	Value = TOGGLE_UI_KEY,
	Callback = function(p12)
    local str4 = tostring(p12)

    if typeof(p12) == "EnumItem" then
        str4 = p12.Name
    end

    t1.TOGGLE_UI_KEY = str4
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)
end
})
local TOGGLE_ENGINE_KEY = t1.TOGGLE_ENGINE_KEY
v20:Keybind({
	Title = "Engine Start/Stop Key",
	Desc = "Key to start or stop the farming engine",
	Value = TOGGLE_ENGINE_KEY,
	Callback = function(p13)
    local str5 = tostring(p13)

    if typeof(p13) == "EnumItem" then
        str5 = p13.Name
    end

    t1.TOGGLE_ENGINE_KEY = str5
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)
end
})
local AUTO_M1 = t1.AUTO_M1
v21:Toggle({
	Title = "Auto M1 Attacks",
	Desc = "Enable auto attacking",
	Value = AUTO_M1,
	Callback = function(p14)
    t1.AUTO_M1 = p14
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)
end
})
local AUTO_SKILLS = t1.AUTO_SKILLS
v21:Toggle({
	Title = "Auto Skills",
	Desc = "Enable automatic skill spamming",
	Value = AUTO_SKILLS,
	Callback = function(p15)
    t1.AUTO_SKILLS = p15
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)
end
})
local SKILL_1 = t1.SKILL_1
v21:Toggle({
	Title = "Use Skill 1",
	Value = SKILL_1,
	Callback = function(p16)
    t1.SKILL_1 = p16
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)
end
})
local Toggle2 = v21.Toggle
local SKILL_2 = t1.SKILL_2
Toggle2(v21, {
	Title = "Use Skill 2",
	Value = SKILL_2,
	Callback = function(p17)
    t1.SKILL_2 = p17
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)
end
})
local Toggle3 = v21.Toggle
local SKILL_3 = t1.SKILL_3
Toggle3(v21, {
	Title = "Use Skill 3",
	Value = SKILL_3,
	Callback = function(p18)
    t1.SKILL_3 = p18
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)
end
})
local SKILL_4 = t1.SKILL_4
v21:Toggle({
	Title = "Use Skill 4",
	Value = SKILL_4,
	Callback = function(p19)
    t1.SKILL_4 = p19
    pcall(function()
        if not isfolder or not writefile then
            return
        end

        if not isfolder("abaquestfarm") then
            makefolder("abaquestfarm")
        end

        writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
    end)
end
})
local function v42()
    if not v19 then
        return
    end

    if type(v19.Toggle) == "function" then
        pcall(function()
            v19:Toggle()
        end)

        return
    end

    local v74 = gethui and gethui()

    if not v74 then
        v74 = game:GetService("CoreGui")

        if not v74 then
            v74 = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        end
    end

    if v74 then
        local _ipairs = ipairs
        for _, v77 in _ipairs(v74:GetChildren()) do
            local v78 = v77:IsA("ScreenGui")

            if v78 then
                v78 = v77.Name:find("WindUI")

                if not v78 then
                    v78 = v77.Name == "ABAQuestFarm"
                end
            end

            if v78 then
                v77.Enabled = not v77.Enabled
            end
        end
    end
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end

    local function v81(p20)
        if not p20 then
            return false
        end

        local v111 = input.KeyCode ~= Enum.KeyCode.Unknown

        if v111 then
            v111 = p20 == input.KeyCode.Name
        end

        if v111 then
            return true
        end

        return false
    end

    if v81(t1.TOGGLE_ENGINE_KEY) then
        t1.ENGINE_ENABLED = not t1.ENGINE_ENABLED
        u9 = t1.ENGINE_ENABLED
        pcall(function()
            if not isfolder or not writefile then
                return
            end

            if not isfolder("abaquestfarm") then
                makefolder("abaquestfarm")
            end

            writefile("abaquestfarm/config.json", HttpService:JSONEncode(t1))
        end)

        local v82 = v30

        if v82 then
            v82 = type(v30.Set) == "function"
        end

        if v82 then
            v30:Set(t1.ENGINE_ENABLED)
        end

        if u9 then
            print("🟢 Farming Engine STARTED via hotkey [" .. tostring(t1.TOGGLE_ENGINE_KEY) .. "]")
            task.spawn(v12)

            return
        end

        print("🔴 Farming Engine STOPPED via hotkey [" .. tostring(t1.TOGGLE_ENGINE_KEY) .. "]")

        return
    end

    if v81(t1.TOGGLE_UI_KEY) then
        v42()
        print("👁 UI Visibility toggled via hotkey [" .. tostring(t1.TOGGLE_UI_KEY) .. "]")
    end
end)

if t1.AUTO_HIDE_UI then
    task.spawn(function()
        task.wait(0.6)
        v42()
        print("👁 UI automatically hidden on launch.")
    end)
end
if t1.ENGINE_ENABLED then
    u9 = true
    task.spawn(v12)
end
