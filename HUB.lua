
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

Main:AddSection({"Dungeon Info"})


Main:AddParagraph({

    "Dungeon Info",

    "PlaceID: "..tostring(placeId).."\nDungeon Hub Loaded"

})



-- ========================================
-- Bring Mobs Dungeon
-- ========================================

local FarmThread

local ScanRadius = 1000
local MaxBring = 8

local BringHeight = -8
local BringDistance = 10
local FarmHeight = 20



local function GetRoot()

    local Char = plr.Character

    if not Char then
        return nil
    end

    return Char:FindFirstChild("HumanoidRootPart")

end



local function GetEnemies()

    local Folder = workspace:FindFirstChild("Enemies")

    if not Folder then
        return {}
    end

    return Folder:GetChildren()

end



local function GetNearestEnemy()

    local Root = GetRoot()

    if not Root then
        return nil
    end


    local Target
    local Distance = math.huge


    for _,Mob in pairs(GetEnemies()) do


        local Hum = Mob:FindFirstChild("Humanoid")
        local MobRoot = Mob:FindFirstChild("HumanoidRootPart")


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


        local Hum = Mob:FindFirstChild("Humanoid")
        local MobRoot = Mob:FindFirstChild("HumanoidRootPart")


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
                        (Count - 1) * 4 - 10,
                        BringHeight,
                        -BringDistance
                    )


                MobRoot.Velocity = Vector3.zero
                MobRoot.RotVelocity = Vector3.zero


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



            FarmThread = task.spawn(function()


                while _G.AutoFarmDungeon do


                    task.wait(0.25)



                    pcall(function()



                        local Root = GetRoot()

                        if not Root then
                            return
                        end



                        -- gom quái xuống dưới trước mặt

                        BringMobs()



                        -- chọn quái đánh

                        local Enemy =
                            GetNearestEnemy()



                        if Enemy then



                            local EnemyRoot =
                                Enemy:FindFirstChild("HumanoidRootPart")



                            local Hum =
                                Enemy:FindFirstChild("Humanoid")



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



                                if typeof(Attack) == "function" then
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
Main:AddToggle({
		Title = "Auto Attack Mon",
		Default = false,
		Callback = function(state)
			_G.AutoAttackMonDungeon = state
			StopTween(_G.AutoAttackMonDungeon)
		end
	})
	function getHighestFloor()
		local highest = 0
		local highestFloor = nil

		for _, v in pairs(workspace.Map.Dungeon:GetChildren()) do
			local num = tonumber(v.Name)
			if num and num > highest then
				highest = num
				highestFloor = v
			end
		end

		return highestFloor
	end
	function getCurrentFloor()
		local highest = 0

		for _, v in pairs(workspace.Map.Dungeon:GetChildren()) do
			local num = tonumber(v.Name)
			if num and num > highest then
				highest = num
			end
		end

		local targetFloor = tostring(highest - 1)
		return workspace.Map.Dungeon:FindFirstChild(targetFloor)
	end

	spawn(function()
		while wait() do
			if _G.AutoAttackMonDungeon then
				pcall(function()
					if (HumanoidRootPart.Position - getHighestFloor().Root.Position).Magnitude < 2000 then
						for _, v in pairs(Enemies:GetChildren()) do
							if v:FindFirstChild("Humanoid")
							and v:FindFirstChild("HumanoidRootPart")
							and v.Humanoid.Health > 0
							and not string.find(v.Name, "Blank Buddy")
							and (HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude <= 3000 then
								if string.find(v.Name, "PropHitboxPlaceholder") then
									NonBlockAttackTarget(v, false, function()
										return _G.AutoAttackMonDungeon
									end)
								elseif v:GetAttribute("IsBoss") == true then
									NonBlockAttackTarget(v, false, function()
										return _G.AutoAttackMonDungeon
									end)
								else
									NonBlockAttackTarget(v, false, function()
										return _G.AutoAttackMonDungeon
									end)
								end
							end
						end
					else
						if _G.AutoNextFloor then
							firetouchinterest(getCurrentFloor().ExitTeleporter.Root, HumanoidRootPart, 0);
							firetouchinterest(getCurrentFloor().ExitTeleporter.Root, HumanoidRootPart, 1);
							wait(0.5)
						end
					end
				end)
			end
		end
	end)
Main:AddToggle({
		Title = "Auto Next Floor",
		
		Default = false,
		Callback = function(state)
			_G.AutoNextFloor = state
		end
	})
Main:AddToggle({
		Title = "Auto Return To Hub",
		
		Default = false,
		Callback = function(state)
			_G.AutoReturnToHub = state
		end
	})
	spawn(function()
		while wait() do
			if _G.AutoReturnToHub then
				pcall(function()
					ReplicatedStorage:WaitForChild("DungeonShared"):WaitForChild("ReturnToHub"):FireServer()
					wait(2)
				end)
			end
		end
	end)
end

Setting:AddSection({"Cài đặt"});


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

loadstring(game:HttpGet("https://raw.githubusercontent.com/ohmay5/Main/refs/heads/main/attach.txt"))()