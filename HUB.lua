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


-- ========================================
-- Save Settings System
-- ========================================

local HttpService = game:GetService("HttpService")

local FolderName = "青龙脚本 Hub"
local FileName = "Settings.json"

local FullPath = FolderName .. "/" .. FileName


if makefolder and not isfolder(FolderName) then
    makefolder(FolderName)
end


_G.SaveData = _G.SaveData or {}



function SaveSettings()

    if not writefile then
        return false
    end


    local success = pcall(function()

        local json =
        HttpService:JSONEncode(_G.SaveData)


        writefile(
            FullPath,
            json
        )

    end)


    return success

end




function LoadSettings()

    if not (isfile and isfile(FullPath)) then
        return false
    end


    local success,result =
    pcall(function()


        local content =
        readfile(FullPath)


        return HttpService:JSONDecode(content)


    end)



    if success and result then

        _G.SaveData = result

        return true

    end


    return false

end




function GetSetting(name,default)

    if _G.SaveData[name] ~= nil then

        return _G.SaveData[name]

    end


    return default

end



LoadSettings()

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


-- ========================================
-- Auto Farm Nearest + Tween + Kill
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

                local DungeonShared =
                ReplicatedStorage:FindFirstChild("DungeonShared")


                if DungeonShared then

                    local ReturnToHub =
                    DungeonShared:FindFirstChild("ReturnToHub")


                    if ReturnToHub then

                        ReturnToHub:FireServer()

                    end

                end

            end)

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

