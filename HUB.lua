local HttpService = Services.HttpService
local FolderName = "青龙脚本 Hub"
local FileName = "Settings.json"
local FullPath = FolderName .. "/" .. FileName

if makefolder and not isfolder(FolderName) then 
    makefolder(FolderName) 
end

_G.SaveData = _G.SaveData or {}

function SaveSettings()
    if not writefile then return false end
    local success = pcall(function()
        local json = HttpService:JSONEncode(_G.SaveData)
        writefile(FullPath, json)
    end)
    return success
end

function LoadSettings()
    if not (isfile and isfile(FullPath)) then return false end
    local success, result = pcall(function()
        local content = readfile(FullPath)
        return HttpService:JSONDecode(content)
    end)
    if success and result then 
        _G.SaveData = result
        return true
    end
    return false
end

function GetSetting(name, default)
    return _G.SaveData[name] ~= nil and _G.SaveData[name] or default
end

LoadSettings()
-- Dungeon Hub
-- PlaceId: 73902483975735
-- ========================================

repeat task.wait() until game:IsLoaded()


local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local plr = Players.LocalPlayer


-- ========================================
-- Dungeon Check
-- ========================================

local placeId = game.PlaceId

local Dungeon = (placeId == 73902483975735)


if not Dungeon then

    warn("Not Dungeon:", placeId)

    return

end


print("Dungeon Loaded:", placeId)



-- ========================================
-- Services
-- ========================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
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


-- ========================================
-- Floating Button
-- ========================================

pcall(function()
    game.CoreGui.DungeonControlGUI:Destroy()
end)


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DungeonControlGUI"
screenGui.Parent = game.CoreGui


local imageButton = Instance.new("ImageButton")

imageButton.Size = UDim2.new(0,35,0,35)

imageButton.Position =
    UDim2.new(0.15,0,0.15,0)

imageButton.Image =
    "rbxassetid://114476175638281"

imageButton.BackgroundTransparency = 1

imageButton.Parent = screenGui



local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0,8)
uiCorner.Parent = imageButton



local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(255,0,0)
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

            if input.UserInputState == Enum.UserInputState.End then

                dragging = false

            end

        end)

    end

end)



imageButton.InputChanged:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseMovement then

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


    if isOpen then

        Library:Minimize(false)

    else

        Library:Minimize(true)

    end

end)
-- ========================================
-- Tabs
-- ========================================

local Main = Library:MakeTab({

    Title = "Dungeon",

    Icon = "rbxassetid://7040410130"

})

local Setting = Library:MakeTab({
    Title = "Setting & UI",
    Icon = "rbxassetid://7734053495"
})


-- ========================================
-- Dungeon Info
-- ========================================

Main:AddSection({"Dungeon Info"});


Main:AddParagraph({

    "Dungeon Info",

    "PlaceID: "..tostring(placeId).."\nDungeon Hub Loaded"

})



-- ========================================
-- Bring Mobs Dungeon
-- ========================================

Main:AddSection({"Bring Mobs"})


local ScanRadius = 1000
local MaxBring = 5



local function GetLocalCharacterRoot()

    local Char =
        plr.Character or plr.CharacterAdded:Wait()

    return Char:FindFirstChild("HumanoidRootPart")

end



local function GetEnemiesFolder()

    return workspace:FindFirstChild("Enemies")

end



local function GetMobsInRadius(Position,Radius)

    local Folder = GetEnemiesFolder()

    if not Folder then
        return {}
    end


    local Mobs = {}


    for _,Mob in pairs(Folder:GetChildren()) do


        local Humanoid =
            Mob:FindFirstChild("Humanoid")


        local Root =
            Mob:FindFirstChild("HumanoidRootPart")



        if Humanoid
        and Root
        and Humanoid.Health > 0 then


            if (Root.Position - Position).Magnitude <= Radius then

                table.insert(Mobs,Mob)

            end

        end

    end


    return Mobs

end



local BringThread



Main:AddToggle({

    Name = "Bring Mobs Dungeon",

    Default = false,


    Callback = function(Value)


        _G.BringMobsDungeon = Value



        if Value then


            BringThread = task.spawn(function()


                while _G.BringMobsDungeon do


                    task.wait(0.2)



                    local Root =
                        GetLocalCharacterRoot()



                    if Root then


                        local Mobs =
                            GetMobsInRadius(
                                Root.Position,
                                ScanRadius
                            )



                        for i = 1, math.min(#Mobs,MaxBring) do



                            local MobRoot =
                                Mobs[i]:FindFirstChild("HumanoidRootPart")



                            if MobRoot then


                                MobRoot.CFrame =
                                    Root.CFrame *
                                    CFrame.new(
                                        math.random(-5,5),
                                        0,
                                        math.random(-5,5)
                                    )


                            end

                        end

                    end


                end


            end)


        else


            _G.BringMobsDungeon = false


            if BringThread then

                task.cancel(BringThread)

                BringThread = nil

            end


        end


    end

})
-- ========================================
-- Auto Farm Dungeon
-- ========================================

Main:AddSection({"Auto Farm"})


local FarmThread



local function GetBestEnemy()

    local Folder = workspace:FindFirstChild("Enemies")

    if not Folder then
        return nil
    end


    local Root = GetLocalCharacterRoot()

    if not Root then
        return nil
    end


    local Target = nil
    local Distance = math.huge



    for _,Enemy in pairs(Folder:GetChildren()) do


        local Humanoid =
            Enemy:FindFirstChild("Humanoid")


        local EnemyRoot =
            Enemy:FindFirstChild("HumanoidRootPart")



        if Humanoid
        and EnemyRoot
        and Humanoid.Health > 0 then



            local Dist =
                (EnemyRoot.Position - Root.Position).Magnitude



            if Dist < Distance then

                Distance = Dist

                Target = Enemy

            end


        end

    end


    return Target

end





Main:AddToggle({

    Name = "Auto Farm Dungeon",

    Default = false,


    Callback = function(Value)


        _G.AutoFarmDungeon = Value



        if Value then


            FarmThread = task.spawn(function()



                while _G.AutoFarmDungeon do



                    task.wait(0.3)



                    local Target =
                        GetBestEnemy()



                    local MyRoot =
                        GetLocalCharacterRoot()



                    if Target
                    and MyRoot then



                        local EnemyRoot =
                            Target:FindFirstChild("HumanoidRootPart")



                        local Humanoid =
                            Target:FindFirstChild("Humanoid")



                        if EnemyRoot
                        and Humanoid
                        and Humanoid.Health > 0 then



                            MyRoot.CFrame =
                                EnemyRoot.CFrame *
                                CFrame.new(0,20,0)



                        end


                    end



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


Setting:AddSection({"Cài đặt"});
Setting:AddButton({
    Name = "Salvar Config UI",
    Description = "",
    Default= true, 
    Callback = function()
        -- Verifica se a função existe antes de chamar
        if SaveSettings then
            SaveSettings()
            
            -- Notificação Universal (Funciona sem a lib Fluent)
            game.StarterGui:SetCore("SendNotification", {
                Title = "青龙脚本Hub",
                Text = "Done",
                Duration = 5
            })
        else
            warn("Erro!")
        end
    end
})

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
    Description = "Bật độ nhả cao của bạn",
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
Setting:AddToggle({
	Name = "Auto Active Haki",
	Description = "tự động kích hoạt haki",
	-- 1. Carrega o estado salvo
	Default = GetSetting("AutoHaki_Save", true),
	Callback = function(I)
		Boud = I
        -- 2. Salva
        _G.SaveData["AutoHaki_Save"] = I
        SaveSettings()
	end,
})
spawn(function()
	while wait(Sec) do
		pcall(function()
			if Boud then
				local I = { "HasBuso", "Buso" };
				if not plr.Character:FindFirstChild(I[1]) then
					replicated.Remotes.CommF_:InvokeServer(I[2]);
				end;
			end;
		end);
	end;
end);
Setting:AddToggle({
	Name = "Auto Active V3",
	Description = "tự động dùng tộc v3",
	-- 1. Carrega o estado salvo
	Default = GetSetting("AutoActiveV3_Save", false),
	Callback = function(I)
		_G.RaceClickAutov3 = I
        
        -- 2. Guarda na tabela de salvamento
        _G.SaveData["AutoActiveV3_Save"] = I
        
        -- 3. Salva no arquivo Settings.json
        SaveSettings()
	end,
})

Setting:AddToggle({
	Name = "Auto Active V4",
	Description = "tự động dùng tộc v4",
	-- 1. Carrega o estado salvo
	Default = GetSetting("AutoActiveV4_Save", false),
	Callback = function(I)
		_G.RaceClickAutov4 = I
        
        -- 2. Guarda na tabela de salvamento
        _G.SaveData["AutoActiveV4_Save"] = I
        
        -- 3. Salva no arquivo Settings.json
        SaveSettings()
	end,
})

spawn(function()
	while wait(.2) do
		pcall(function()
			if _G.RaceClickAutov3 then
				repeat
					replicated.Remotes.CommE:FireServer("ActivateAbility");
					wait(30);
				until not _G.RaceClickAutov3;
			end;
		end);
	end;
end);
spawn(function()
	while wait(.2) do
		pcall(function()
			if _G.RaceClickAutov4 then
				if plr.Character:FindFirstChild("RaceEnergy") then
					if (plr.Character:FindFirstChild("RaceEnergy")).Value == 1 then
						Useskills("nil", "Y");
					end;
				end;
			end;
		end);
	end;
end);
Setting:AddToggle({
    Name = "Nhảy cao vô hạn",
    Default = true,
    Callback = function(Value)
        _G.InfiniteJump = Value
    end
})
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfiniteJump then
        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)