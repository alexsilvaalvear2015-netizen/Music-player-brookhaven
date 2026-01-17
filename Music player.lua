-- BROOKHAVEN CAR MUSIC GUI
-- By ChatGPT for Alex

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "CarMusicGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- BOTON +
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 50, 0, 50)
toggle.Position = UDim2.new(0, 20, 0.5, -25)
toggle.BackgroundColor3 = Color3.fromRGB(130,130,130)
toggle.Text = "+"
toggle.TextSize = 28
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Parent = gui
toggle.Active = true
toggle.Draggable = true

-- MENU
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 230)
frame.Position = UDim2.new(0, 80, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Visible = false
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- TITULO
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "BROOKHAVEN MUSIC"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.Parent = frame

-- ID BOX
local box = Instance.new("TextBox")
box.Size = UDim2.new(0.9, 0, 0, 35)
box.Position = UDim2.new(0.05, 0, 0, 45)
box.PlaceholderText = "ID de música"
box.Text = ""
box.TextSize = 16
box.BackgroundColor3 = Color3.fromRGB(70,70,70)
box.TextColor3 = Color3.new(1,1,1)
box.Parent = frame

-- PLAY
local play = Instance.new("TextButton")
play.Size = UDim2.new(0.42, 0, 0, 35)
play.Position = UDim2.new(0.05, 0, 0, 90)
play.Text = "PLAY"
play.TextSize = 16
play.BackgroundColor3 = Color3.fromRGB(90,90,90)
play.TextColor3 = Color3.new(1,1,1)
play.Parent = frame

-- STOP
local stop = Instance.new("TextButton")
stop.Size = UDim2.new(0.42, 0, 0, 35)
stop.Position = UDim2.new(0.53, 0, 0, 90)
stop.Text = "STOP"
stop.TextSize = 16
stop.BackgroundColor3 = Color3.fromRGB(130,60,60)
stop.TextColor3 = Color3.new(1,1,1)
stop.Parent = frame

-- VOLUMEN TEXTO
local volText = Instance.new("TextLabel")
volText.Size = UDim2.new(1, 0, 0, 25)
volText.Position = UDim2.new(0, 0, 0, 135)
volText.BackgroundTransparency = 1
volText.Text = "VOLUMEN"
volText.TextColor3 = Color3.new(1,1,1)
volText.TextSize = 14
volText.Parent = frame

-- SLIDER
local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(0.9, 0, 0, 10)
sliderBg.Position = UDim2.new(0.05, 0, 0, 165)
sliderBg.BackgroundColor3 = Color3.fromRGB(80,80,80)
sliderBg.Parent = frame

local slider = Instance.new("Frame")
slider.Size = UDim2.new(0.5, 0, 1, 0)
slider.BackgroundColor3 = Color3.fromRGB(160,160,160)
slider.Parent = sliderBg

-- FUNCIONES
local dragging = false
local currentSound

toggle.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

local function getCarSound()
	local char = player.Character
	if not char then return nil end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or not hum.SeatPart then return nil end

	local seat = hum.SeatPart
	local vehicle = seat:FindFirstAncestorOfClass("Model")
	if not vehicle then return nil end

	local sound = vehicle:FindFirstChild("CarMusic", true)
	if not sound then
		sound = Instance.new("Sound")
		sound.Name = "CarMusic"
		sound.Volume = 5
		sound.Looped = true
		sound.RollOffMaxDistance = 300
		sound.Parent = seat
	end
	return sound
end

play.MouseButton1Click:Connect(function()
	local sound = getCarSound()
	if not sound then return end
	sound.SoundId = "rbxassetid://" .. box.Text
	sound:Play()
	currentSound = sound
end)

stop.MouseButton1Click:Connect(function()
	if currentSound then
		currentSound:Stop()
	end
end)

sliderBg.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
	end
end)

sliderBg.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(i)
	if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local pos = math.clamp(
			(i.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X,
			0, 1
		)
		slider.Size = UDim2.new(pos, 0, 1, 0)
		if currentSound then
			currentSound.Volume = pos * 10
		end
	end
end)
