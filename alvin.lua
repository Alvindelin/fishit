--// Fishing System + Modern UI (Roblox Luau)
--// by ChatGPT (untuk tugas belajar, bukan exploit)

-- Create UI programmatically
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FishingUI"

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 220)
mainFrame.Position = UDim2.new(0.5, -160, 0.7, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.05
mainFrame.AnchorPoint = Vector2.new(0, 0)
mainFrame.Parent = gui
mainFrame.ClipsDescendants = true

-- Shadow (soft effect)
local shadow = Instance.new("ImageLabel")
shadow.Image = "rbxassetid://4483362458"
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.Position = UDim2.new(0, -10, 0, -10)
shadow.BackgroundTransparency = 1
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.85
shadow.ZIndex = 0
shadow.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Text = "🎣 Fishing System"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(40, 40, 40)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 20, 0, 15)
title.Size = UDim2.new(1, -40, 0, 30)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- Status label
local status = Instance.new("TextLabel")
status.Text = "Ready to fish..."
status.Font = Enum.Font.Gotham
status.TextSize = 18
status.TextColor3 = Color3.fromRGB(70, 70, 70)
status.BackgroundTransparency = 1
status.Position = UDim2.new(0, 20, 0, 55)
status.Size = UDim2.new(1, -40, 0, 25)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = mainFrame

-- Progress bar (visual feedback)
local progressBarBG = Instance.new("Frame")
progressBarBG.Size = UDim2.new(1, -40, 0, 12)
progressBarBG.Position = UDim2.new(0, 20, 0, 90)
progressBarBG.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
progressBarBG.BorderSizePixel = 0
progressBarBG.Parent = mainFrame

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBG

-- Cast Button
local castButton = Instance.new("TextButton")
castButton.Text = "CAST 🎯"
castButton.Font = Enum.Font.GothamBold
castButton.TextSize = 20
castButton.TextColor3 = Color3.fromRGB(255, 255, 255)
castButton.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
castButton.Size = UDim2.new(0, 130, 0, 45)
castButton.Position = UDim2.new(0.5, -65, 1, -65)
castButton.Parent = mainFrame
castButton.AutoButtonColor = true
castButton.BorderSizePixel = 0
castButton.ZIndex = 2
castButton.ClipsDescendants = true
castButton.Active = true

-- Corner rounding
for _, v in pairs({mainFrame, castButton, progressBarBG, progressBar}) do
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = v
end

--// FISHING LOGIC

local isCasting = false
local hasBite = false

-- Trigger Bite Event (for integration with other scripts)
local BiteEvent = Instance.new("BindableEvent")
BiteEvent.Name = "BiteEvent"
BiteEvent.Parent = script

-- Function to handle casting
local function Cast()
	if isCasting then return end
	isCasting = true
	hasBite = false
	status.Text = "🎣 Casting..."
	progressBar:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.1, true)
	task.wait(0.2) -- short animation
	status.Text = "🌊 Waiting for fish..."
end

-- Function to handle catching (instant)
local function Catch()
	if not isCasting then
		status.Text = "You need to cast first!"
		return
	end

	if hasBite then
		status.Text = "🐟 Fish caught instantly!"
		progressBar:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quad", 0.2, true)
	else
		status.Text = "❌ No bite yet."
	end

	isCasting = false
	task.wait(0.5)
	progressBar:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Quad", 0.2, true)
end

-- Simulate Bite Event (for testing or can be fired externally)
local function TriggerBite()
	if isCasting then
		hasBite = true
		status.Text = "🐟 Bite detected!"
		BiteEvent:Fire()
	end
end

-- Button behavior
castButton.MouseButton1Click:Connect(function()
	Cast()

	-- Optional auto test bite (simulate fish instantly biting)
	task.wait(0.5)
	TriggerBite()
end)

-- When fish bites → instantly catch (no delay)
BiteEvent.Event:Connect(function()
	Catch()
end)
