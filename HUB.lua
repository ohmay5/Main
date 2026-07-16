-- Dungeon Hub
-- PlaceId: 73902483975735
-- ========================================

repeat task.wait() until game:IsLoaded()


-- ========================================
-- Services
-- ========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")


local plr = Players.LocalPlayer


_G.SaveData = _G.SaveData or {}


-- ========================================
-- Character System
-- ========================================

local HumanoidRootPart
local humanoid


local function UpdateCharacter()

    local Character = plr.Character or plr.CharacterAdded:Wait()

    HumanoidRootPart =
        Character:WaitForChild("HumanoidRootPart")

    humanoid =
        Character:WaitForChild("Humanoid")

end


UpdateCharacter()


plr.CharacterAdded:Connect(function()

    task.wait(1)

    UpdateCharacter()

end)



-- ========================================
-- Dungeon Check
-- ========================================

local placeId = game.PlaceId


local DungeonID = 73902483975735


if placeId ~= DungeonID then

    warn("Not Dungeon:", placeId)

    return

end


print("Dungeon Loaded:",placeId)



-- ========================================
-- Workspace Objects
-- ========================================

local Enemies


task.spawn(function()

    pcall(function()

        Enemies =
            workspace:WaitForChild("Enemies",10)

    end)

end)



-- ========================================
-- Load UI
-- ========================================

local Library = loadstring(game:HttpGet(
"https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/xRedzLib.lua.txt"
))():MakeWindow({

    Title = "青龙脚本 | Dungeon Hub",

    SubTitle = "Dungeon",

    SaveFolder = "Dungeon_Settings.json"

})


print("UI Loaded")
-- ========================================
-- Floating Button
-- ========================================

pcall(function()
    game.CoreGui.DungeonControlGUI:Destroy()
end)


local screenGui = Instance.new("ScreenGui")

screenGui.Name = "DungeonControlGUI"

screenGui.ResetOnSpawn = false

screenGui.Parent = game.CoreGui



local imageButton = Instance.new("ImageButton")


imageButton.Size =
    UDim2.new(0,35,0,35)


imageButton.Position =
    UDim2.new(0.15,0,0.15,0)


imageButton.Image =
    "rbxassetid://114476175638281"


imageButton.BackgroundTransparency = 1


imageButton.Parent = screenGui



local uiCorner = Instance.new("UICorner")

uiCorner.CornerRadius =
    UDim.new(0,8)

uiCorner.Parent = imageButton



local uiStroke = Instance.new("UIStroke")

uiStroke.Thickness = 2

uiStroke.Color =
    Color3.fromRGB(255,0,0)

uiStroke.Parent = imageButton



-- ========================================
-- Drag Button
-- ========================================

local dragging = false

local dragStart

local startPos

local dragInput



imageButton.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then


        dragging = true

        dragStart = input.Position

        startPos = imageButton.Position



        input.Changed:Connect(function()

            if input.UserInputState ==
                Enum.UserInputState.End then

                dragging = false

            end

        end)

    end

end)



imageButton.InputChanged:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.Touch

    or input.UserInputType ==
        Enum.UserInputType.MouseMovement then


        dragInput = input

    end

end)



UserInputService.InputChanged:Connect(function(input)

    if dragging and input == dragInput then


        local delta =
            input.Position - dragStart



        imageButton.Position =
            UDim2.new(

                startPos.X.Scale,

                startPos.X.Offset + delta.X,


                startPos.Y.Scale,

                startPos.Y.Offset + delta.Y

            )


    end

end)



-- ========================================
-- Minimize
-- ========================================

local isOpen = true



imageButton.MouseButton1Click:Connect(function()


    isOpen = not isOpen



    pcall(function()


        if isOpen then

            Library:Minimize(false)

        else

            Library:Minimize(true)

        end


    end)


end)




-- ========================================
-- Tabs
-- ========================================


local Main =
Library:MakeTab({

    Name = "Dungeon",

    Icon = "rbxassetid://7040410130"

})



local Setting =
Library:MakeTab({

    Name = "Setting & UI",

    Icon = "rbxassetid://7734053495"

})



print("Tabs Loaded")

-- ========================================
-- Dungeon Info
-- ========================================

Main:AddSection({"Dungeon Info"})


Main:AddParagraph({

    "Dungeon Info",

    "PlaceID: "..tostring(placeId)
    .."\nDungeon Hub Loaded"

})



-- ========================================
-- Bring Mobs + Auto Farm
-- ========================================

local FarmThread = nil


local ScanRadius = 1000

local MaxBring = 8


local BringHeight = -8

local BringDistance = 10

local FarmHeight = 20



-- Lấy nhân vật hiện tại

local function GetRoot()

    local Char = plr.Character

    if not Char then
        return nil
    end


    return Char:FindFirstChild("HumanoidRootPart")

end



-- Lấy danh sách quái

local function GetEnemies()

    local Folder =
        workspace:FindFirstChild("Enemies")


    if not Folder then

        return {}

    end


    return Folder:GetChildren()

end



-- Tìm quái gần nhất

local function GetNearestEnemy()


    local Root = GetRoot()


    if not Root then

        return nil

    end



    local Target = nil

    local Distance = math.huge



    for _,Mob in pairs(GetEnemies()) do


        local Hum =
            Mob:FindFirstChild("Humanoid")


        local MobRoot =
            Mob:FindFirstChild("HumanoidRootPart")



        if Hum
        and MobRoot
        and Hum.Health > 0 then



            local Dist =
            (MobRoot.Position - Root.Position).Magnitude



            if Dist < Distance then


                Distance = Dist

                Target = Mob


            end

        end

    end



    return Target

end




-- Gom quái xung quanh,
-- không kéo dính người chơi

local function BringMobs()


    local Root = GetRoot()


    if not Root then

        return

    end



    local Count = 0



    for _,Mob in pairs(GetEnemies()) do



        if Count >= MaxBring then

            break

        end



        local Hum =
            Mob:FindFirstChild("Humanoid")


        local MobRoot =
            Mob:FindFirstChild("HumanoidRootPart")



        if Hum
        and MobRoot
        and Hum.Health > 0 then



            local Distance =
            (MobRoot.Position - Root.Position).Magnitude



            if Distance <= ScanRadius then


                Count += 1



                MobRoot.CFrame =
                Root.CFrame *
                CFrame.new(

                    (Count-1)*4-10,

                    BringHeight,

                    -BringDistance

                )



                pcall(function()

                    MobRoot.Velocity =
                    Vector3.zero


                    MobRoot.RotVelocity =
                    Vector3.zero

                end)


            end


        end


    end


end




Main:AddToggle({

    Name = "Auto Farm Dungeon",

    Default = false,


    Callback = function(Value)


        _G.AutoFarmDungeon = Value



        if Value then



            if FarmThread then

                task.cancel(FarmThread)

            end




            FarmThread =
            task.spawn(function()



                while _G.AutoFarmDungeon do


                    task.wait(0.25)



                    pcall(function()



                        local Root =
                        GetRoot()



                        if not Root then

                            return

                        end



                        BringMobs()



                        local Enemy =
                        GetNearestEnemy()



                        if Enemy then



                            local EnemyRoot =
                            Enemy:FindFirstChild(
                            "HumanoidRootPart"
                            )


                            local Hum =
                            Enemy:FindFirstChild(
                            "Humanoid"
                            )



                            if EnemyRoot
                            and Hum
                            and Hum.Health > 0 then



                                Root.CFrame =
                                EnemyRoot.CFrame *
                                CFrame.new(
                                    0,
                                    FarmHeight,
                                    0
                                )



                                -- nếu có hàm Attack bên ngoài

                                if typeof(Attack)
                                =="function" then

                                    Attack()

                                end


                            end


                        end



                    end)



                end



            end)



        else



            _G.AutoFarmDungeon = false



            if FarmThread then

                task.cancel(FarmThread)

                FarmThread = nil

            end



        end


    end

})


print("Auto Farm Loaded")
-- ========================================
-- Auto Attack Dungeon
-- ========================================


_G.AutoAttackMonDungeon = false
_G.AutoNextFloor = false
_G.AutoReturnToHub = false



local function GetHighestFloor()

    local highest = 0
    local floor = nil


    local DungeonMap =
    workspace:FindFirstChild("Map")
    and workspace.Map:FindFirstChild("Dungeon")


    if not DungeonMap then
        return nil
    end



    for _,v in pairs(DungeonMap:GetChildren()) do


        local num = tonumber(v.Name)


        if num and num > highest then

            highest = num

            floor = v

        end


    end



    return floor

end




local function GetCurrentFloor()


    local highest = 0



    local DungeonMap =
    workspace:FindFirstChild("Map")
    and workspace.Map:FindFirstChild("Dungeon")



    if not DungeonMap then
        return nil
    end



    for _,v in pairs(DungeonMap:GetChildren()) do


        local num = tonumber(v.Name)


        if num and num > highest then

            highest = num

        end

    end



    return DungeonMap:FindFirstChild(
        tostring(highest-1)
    )


end





Main:AddToggle({

    Name = "Auto Attack Mon",

    Default = false,


    Callback = function(state)


        _G.AutoAttackMonDungeon = state



        if typeof(StopTween)=="function" then

            StopTween(state)

        end


    end

})





task.spawn(function()


while task.wait(0.5) do



    if _G.AutoAttackMonDungeon then



        pcall(function()



            local Root =
            GetRoot()



            if not Root then

                return

            end



            for _,v in pairs(GetEnemies()) do



                local Hum =
                v:FindFirstChild("Humanoid")


                local MobRoot =
                v:FindFirstChild(
                "HumanoidRootPart"
                )



                if Hum
                and MobRoot
                and Hum.Health > 0 then



                    if typeof(NonBlockAttackTarget)
                    =="function" then



                        NonBlockAttackTarget(

                            v,

                            false,

                            function()

                                return
                                _G.AutoAttackMonDungeon

                            end

                        )


                    elseif typeof(Attack)
                    =="function" then


                        Attack()


                    end



                end


            end



        end)


    end


end


end)






-- ========================================
-- Auto Next Floor
-- ========================================


Main:AddToggle({

    Name = "Auto Next Floor",

    Default = false,


    Callback = function(state)

        _G.AutoNextFloor = state

    end

})



task.spawn(function()


while task.wait(1) do


    if _G.AutoNextFloor then


        pcall(function()



            local Floor =
            GetCurrentFloor()



            local Root =
            GetRoot()



            if Floor
            and Root
            and Floor:FindFirstChild(
            "ExitTeleporter"
            ) then



                local Tele =
                Floor.ExitTeleporter:FindFirstChild(
                "Root"
                )



                if Tele then


                    firetouchinterest(
                        Tele,
                        Root,
                        0
                    )


                    firetouchinterest(
                        Tele,
                        Root,
                        1
                    )


                end


            end



        end)


    end


end


end)





-- ========================================
-- Auto Return Hub
-- ========================================


Main:AddToggle({

    Name = "Auto Return To Hub",

    Default = false,


    Callback = function(state)

        _G.AutoReturnToHub = state

    end

})




task.spawn(function()


while task.wait(3) do



    if _G.AutoReturnToHub then



        pcall(function()



            local Remote =
            ReplicatedStorage
            :FindFirstChild("DungeonShared")



            if Remote
            and Remote:FindFirstChild(
            "ReturnToHub"
            ) then



                Remote.ReturnToHub:
                FireServer()


            end



        end)



    end



end


end)

Main:AddToggle({
    Name = "Kill aura",
    Default = false,
    Callback = function(Value)
        _G.KillH = Value
    end
})

-- Sử dụng task.spawn để chạy mượt mà và tối ưu hơn spawn() cũ
task.spawn(function()
    while true do 
        task.wait(Sec) -- Dùng task.wait thay cho wait vì nó chính xác hơn
        
        if _G.KillH then
            -- Set SimulationRadius một lần ở ngoài vòng lặp để tránh làm nặng game
            pcall(function()
                sethiddenproperty(plr, "SimulationRadius", math.huge)
            end)
            
            -- Quét qua toàn bộ danh sách quái vật cùng một lúc
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                -- Nếu trong lúc đang quét mà bạn tắt Toggle thì dừng vòng lặp ngay lập tức
                if not _G.KillH then break end 
                
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    -- Chỉ xử lý những con quái còn sống
                    if v.Humanoid.Health > 0 and v.Parent then
                        pcall(function()
                            v.HumanoidRootPart.CanCollide = false
                            v:BreakJoints()
                            v.Humanoid.Health = 0
                        end)
                    end
                end
            end
        end
    end
end)

print("Dungeon Floor System Loaded")
-- ========================================
-- SETTING
-- ========================================

Setting:AddSection({"Cài đặt"})



-- ========================================
-- WalkSpeed / JumpPower
-- ========================================


-- ========================================
-- WalkSpeed / JumpPower FIX
-- ========================================

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local plr = Players.LocalPlayer
local humanoid = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") or nil

plr.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
end)

local SpeedEnabled = false
local JumpEnabled = false

local desiredSpeed = 16
local desiredJump = 50

local function protectSpeed()
    if humanoid then
        humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if SpeedEnabled and humanoid.WalkSpeed ~= desiredSpeed then
                humanoid.WalkSpeed = desiredSpeed
            end
        end)
    end
end

local function applyStats()
    if humanoid then
        if SpeedEnabled then humanoid.WalkSpeed = desiredSpeed end
        if JumpEnabled then humanoid.JumpPower = desiredJump end
    end
end

RunService.Heartbeat:Connect(function()
    if humanoid then
        if SpeedEnabled and humanoid.WalkSpeed ~= desiredSpeed then
            humanoid.WalkSpeed = desiredSpeed
        end
        if JumpEnabled and humanoid.JumpPower ~= desiredJump then
            humanoid.JumpPower = desiredJump
        end
    end
end)

plr.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    protectSpeed()
end)

protectSpeed()

-- Toggle para WalkSpeed
Setting:AddToggle({
	Name  = "Set WalkSpeed",
    Description = "Bật tốc độ chạy của bạn",
    Default = true,
    Callback = function(Value)
        SpeedEnabled = Value
        applyStats()
    end
})
-- Input para definir valor da WalkSpeed 
Setting:AddSlider({
    Name = "WalkSpeed Value",
    Description = "Kéo để chọn tốc độ",
    Default = _G.SaveData["WalkSpeed_Save"] or 16, -- Đọc giá trị lưu, mặc định 16
    Min = 20,
    Max = 500, -- Bạn có thể chỉnh Max tùy ý
    Rounding = 0, -- Làm tròn số
    Callback = function(Value)
        desiredSpeed = Value
        _G.SaveData["WalkSpeed_Save"] = Value -- Lưu trạng thái
        if SaveSettings then SaveSettings() end -- Tự động lưu
        applyStats() -- Áp dụng tốc độ
    end
})

-- Toggle para JumpPower
Setting:AddToggle({
	Name  = "Set JumpPower",
    Description = "Bật độ nhảy cao của bạn",
    Default = true,
    Callback = function(Value)
        JumpEnabled = Value
        applyStats()
    end
})
Setting:AddSlider({
    Name = "JumpPower Value",
    Description = "Kéo để chọn độ cao nhảy",
    Default = _G.SaveData["JumpPower_Save"] or 50, -- Đọc giá trị lưu, mặc định 50
    Min = 50,
    Max = 900, -- Bạn có thể điều chỉnh mức tối đa tùy ý
    Rounding = 0,
    Callback = function(Value)
        desiredJump = Value
        _G.SaveData["JumpPower_Save"] = Value -- Lưu trạng thái
        if SaveSettings then SaveSettings() end -- Tự động lưu
        applyStats() -- Áp dụng thay đổi
    end
})




-- ========================================
-- Auto Haki
-- ========================================


_G.AutoHaki = false



Setting:AddToggle({

    Name = "Auto Active Haki",

    Description =
    "Tự động bật haki",


    Default = false,


    Callback = function(Value)


        _G.AutoHaki = Value


    end

})





task.spawn(function()


while task.wait(1) do


    if _G.AutoHaki then


        pcall(function()


            local Char =
            plr.Character


            if Char
            and not Char:FindFirstChild(
            "HasBuso"
            ) then



                local Remote =
                ReplicatedStorage
                :FindFirstChild(
                "Remotes"
                )



                if Remote
                and Remote:FindFirstChild(
                "CommF_"
                ) then



                    Remote.CommF_:
                    InvokeServer(
                    "Buso"
                    )


                end


            end


        end)


    end


end


end)






-- ========================================
-- Auto V3
-- ========================================


_G.RaceClickAutov3 = false



Setting:AddToggle({

    Name = "Auto Active V3",

    Default = false,


    Callback = function(Value)


        _G.RaceClickAutov3 = Value


    end

})





task.spawn(function()


while task.wait(1) do


    if _G.RaceClickAutov3 then


        pcall(function()


            if ReplicatedStorage
            :FindFirstChild("Remotes") then


                local CommE =
                ReplicatedStorage.Remotes
                :FindFirstChild("CommE")


                if CommE then

                    CommE:FireServer(
                    "ActivateAbility"
                    )

                end


            end


        end)


    end


end


end)






-- ========================================
-- Auto V4
-- ========================================


_G.RaceClickAutov4 = false



Setting:AddToggle({

    Name = "Auto Active V4",

    Default = false,


    Callback = function(Value)


        _G.RaceClickAutov4 = Value


    end

})






task.spawn(function()


while task.wait(0.5) do


    if _G.RaceClickAutov4 then


        pcall(function()


            local Char =
            plr.Character



            local Energy =
            Char
            and Char:FindFirstChild(
            "RaceEnergy"
            )



            if Energy
            and Energy.Value >= 1 then


                if typeof(Useskills)
                =="function" then


                    Useskills(
                    "nil",
                    "Y"
                    )


                end


            end


        end)


    end


end


end)






-- ========================================
-- Infinite Jump
-- ========================================


_G.InfiniteJump = false



Setting:AddToggle({

    Name = "Nhảy cao vô hạn",

    Default = false,


    Callback = function(Value)


        _G.InfiniteJump = Value


    end

})





UserInputService.JumpRequest:Connect(function()


    if _G.InfiniteJump then



        pcall(function()



            local Char =
            plr.Character



            local Hum =
            Char
            and Char:FindFirstChildOfClass(
            "Humanoid"
            )



            if Hum then


                Hum:ChangeState(
                Enum.HumanoidStateType.Jumping
                )


            end



        end)



    end


end)



print("Setting Loaded")
-- ========================================
-- Load Attach
-- ========================================


pcall(function()

    loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/attach.txt"
    ))()

end)




-- ========================================
-- Final Check
-- ========================================


task.spawn(function()


    while task.wait(5) do


        pcall(function()



            -- cập nhật lại Character nếu respawn


            local Char =
            plr.Character



            if Char then


                local Root =
                Char:FindFirstChild(
                "HumanoidRootPart"
                )



                if Root then

                    HumanoidRootPart =
                    Root

                end



            end



            -- cập nhật Enemies nếu bị load lại


            if not Enemies
            or not Enemies.Parent then


                Enemies =
                workspace:FindFirstChild(
                "Enemies"
                )


            end



        end)


    end


end)




print("============================")

print("Dungeon Hub Loaded Successfully")

print("PlaceID:",placeId)

print("============================")
