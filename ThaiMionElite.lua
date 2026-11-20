local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local function getGuiParent()
	local ok, res = pcall(function() return gethui and gethui() end)
	if ok and res then return res end
	local ok2, res2 = pcall(function() return CoreGui end)
	if ok2 and res2 then return res2 end
	return LocalPlayer:WaitForChild("PlayerGui")
end

local PGui = getGuiParent()

pcall(function()
	for _, name in ipairs({ "ThaiMionEliteGui", "ThaiMionFloatTPGui", "ThaiMionNotifyGui" }) do
		if PGui:FindFirstChild(name) then PGui[name]:Destroy() end
	end
end)

local function round(obj, rad)
	Instance.new("UICorner", obj).CornerRadius = rad or UDim.new(0, 12)
end

local function glassStroke(obj, color, thick, trans)
	local s = Instance.new("UIStroke", obj)
	s.Color = color or Color3.fromRGB(185, 225, 255)
	s.Thickness = thick or 1.6
	s.Transparency = trans or 0.25
	return s
end

local function glassGrad(obj, c1, c2, rot)
	local g = Instance.new("UIGradient", obj)
	g.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, c1 or Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, c2 or Color3.fromRGB(145, 185, 255)),
	})
	g.Rotation = rot or 35
	return g
end

local function makeDrag(handle, target)
	local dragging, dragStart, startPos = false, nil, nil
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType.Touch) then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

local notifyGui = Instance.new("ScreenGui", PGui)
notifyGui.Name = "ThaiMionNotifyGui"
notifyGui.ResetOnSpawn = false
notifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local notifyBanner = Instance.new("Frame", notifyGui)
notifyBanner.Size = UDim2.new(0, 270, 0, 42)
notifyBanner.Position = UDim2.new(0.5, -135, 0, -60)
notifyBanner.BackgroundColor3 = Color3.fromRGB(20, 26, 42)
notifyBanner.BackgroundTransparency = 0.18
notifyBanner.BorderSizePixel = 0
round(notifyBanner, UDim.new(1, 0))
local nStroke = glassStroke(notifyBanner, Color3.fromRGB(110, 245, 200), 1.8, 0.15)
glassGrad(notifyBanner, Color3.fromRGB(255, 255, 255), Color3.fromRGB(130, 210, 255), 25)

local notifyText = Instance.new("TextLabel", notifyBanner)
notifyText.Size = UDim2.new(1, -20, 1, 0)
notifyText.Position = UDim2.new(0, 10, 0, 0)
notifyText.BackgroundTransparency = 1
notifyText.Text = "Đã Load Thành Công"
notifyText.TextColor3 = Color3.fromRGB(150, 255, 210)
notifyText.TextSize = 13
notifyText.Font = Enum.Font.GothamBlack

local function showTopBanner(msg)
	notifyText.Text = msg or "Đã Load Thành Công"
	notifyBanner.Position = UDim2.new(0.5, -135, 0, -60)
	notifyBanner.BackgroundTransparency = 0.18
	notifyText.TextTransparency = 0
	nStroke.Transparency = 0.15
	TweenService:Create(notifyBanner, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -135, 0, 14)
	}):Play()
	task.delay(2.8, function()
		if not notifyBanner or not notifyBanner.Parent then return end
		TweenService:Create(notifyBanner, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, -135, 0, -60),
			BackgroundTransparency = 1
		}):Play()
		TweenService:Create(notifyText, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
		TweenService:Create(nStroke, TweenInfo.new(0.35), { Transparency = 1 }):Play()
	end)
end

local screenGui = Instance.new("ScreenGui", PGui)
screenGui.Name = "ThaiMionEliteGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local floatTpGui = Instance.new("ScreenGui", PGui)
floatTpGui.Name = "ThaiMionFloatTPGui"
floatTpGui.ResetOnSpawn = false
floatTpGui.Enabled = false

local floatTpBtn = Instance.new("TextButton", floatTpGui)
floatTpBtn.Name = "ThaiMionFloatTPBtn"
floatTpBtn.Size = UDim2.new(0, 62, 0, 62)
floatTpBtn.Position = UDim2.new(1, -92, 0.52, 0)
floatTpBtn.BackgroundColor3 = Color3.fromRGB(24, 30, 46)
floatTpBtn.BackgroundTransparency = 0.2
floatTpBtn.BorderSizePixel = 0
floatTpBtn.Text = "TP TM"
floatTpBtn.TextColor3 = Color3.fromRGB(120, 235, 255)
floatTpBtn.TextSize = 13
floatTpBtn.Font = Enum.Font.GothamBlack
round(floatTpBtn, UDim.new(1, 0))
glassStroke(floatTpBtn, Color3.fromRGB(120, 235, 255), 2, 0.15)
glassGrad(floatTpBtn, Color3.fromRGB(255, 255, 255), Color3.fromRGB(120, 200, 255), 35)

local loadFrame = Instance.new("Frame", screenGui)
loadFrame.Size = UDim2.new(0, 320, 0, 74)
loadFrame.Position = UDim2.new(0.5, -160, 0.5, -37)
loadFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 34)
loadFrame.BackgroundTransparency = 0.2
loadFrame.BorderSizePixel = 0
round(loadFrame, UDim.new(0, 14))
glassStroke(loadFrame, Color3.fromRGB(120, 255, 205), 1.8, 0.18)
glassGrad(loadFrame, Color3.fromRGB(255, 255, 255), Color3.fromRGB(140, 210, 255), 30)

local loadTitle = Instance.new("TextLabel", loadFrame)
loadTitle.Size = UDim2.new(1, -20, 0, 28)
loadTitle.Position = UDim2.new(0, 10, 0, 8)
loadTitle.BackgroundTransparency = 1
loadTitle.Text = "@ThaiMion Loading: 0%"
loadTitle.TextColor3 = Color3.fromRGB(240, 248, 255)
loadTitle.TextSize = 14
loadTitle.Font = Enum.Font.GothamBold

local barBg = Instance.new("Frame", loadFrame)
barBg.Size = UDim2.new(1, -24, 0, 14)
barBg.Position = UDim2.new(0, 12, 0, 44)
barBg.BackgroundColor3 = Color3.fromRGB(32, 38, 56)
barBg.BackgroundTransparency = 0.25
barBg.BorderSizePixel = 0
round(barBg, UDim.new(1, 0))

local barFill = Instance.new("Frame", barBg)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(55, 240, 175)
barFill.BorderSizePixel = 0
round(barFill, UDim.new(1, 0))

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 370, 0, 326)
mainFrame.Position = UDim2.new(0.5, -185, 0.5, -163)
mainFrame.BackgroundColor3 = Color3.fromRGB(16, 20, 32)
mainFrame.BackgroundTransparency = 0.22
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.ClipsDescendants = true
round(mainFrame, UDim.new(0, 16))
local mainStroke = glassStroke(mainFrame, Color3.fromRGB(170, 145, 255), 2, 0.15)
glassGrad(mainFrame, Color3.fromRGB(255, 255, 255), Color3.fromRGB(155, 190, 255), 35)

local miniFrame = Instance.new("Frame", screenGui)
miniFrame.Size = UDim2.new(0, 185, 0, 38)
miniFrame.Position = UDim2.new(0.03, 0, 0.16, 0)
miniFrame.BackgroundColor3 = Color3.fromRGB(18, 22, 36)
miniFrame.BackgroundTransparency = 0.22
miniFrame.BorderSizePixel = 0
miniFrame.Visible = false
round(miniFrame, UDim.new(1, 0))
local miniStroke = glassStroke(miniFrame, Color3.fromRGB(170, 145, 255), 1.8, 0.15)
glassGrad(miniFrame, Color3.fromRGB(255, 255, 255), Color3.fromRGB(155, 190, 255), 35)

local miniLabel = Instance.new("TextLabel", miniFrame)
miniLabel.Size = UDim2.new(1, -44, 1, 0)
miniLabel.Position = UDim2.new(0, 14, 0, 0)
miniLabel.BackgroundTransparency = 1
miniLabel.Text = "THAIMION ELITE"
miniLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
miniLabel.TextSize = 12
miniLabel.Font = Enum.Font.GothamBlack
miniLabel.TextXAlignment = Enum.TextXAlignment.Left

local expandBtn = Instance.new("TextButton", miniFrame)
expandBtn.Size = UDim2.new(0, 28, 0, 28)
expandBtn.Position = UDim2.new(1, -33, 0.5, -14)
expandBtn.BackgroundColor3 = Color3.fromRGB(36, 44, 66)
expandBtn.BackgroundTransparency = 0.22
expandBtn.BorderSizePixel = 0
expandBtn.Text = "+"
expandBtn.TextColor3 = Color3.fromRGB(120, 255, 185)
expandBtn.TextSize = 16
expandBtn.Font = Enum.Font.GothamBold
round(expandBtn, UDim.new(1, 0))
glassStroke(expandBtn, Color3.fromRGB(140, 240, 210), 1.2, 0.25)

local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 38)
topBar.BackgroundColor3 = Color3.fromRGB(24, 30, 46)
topBar.BackgroundTransparency = 0.25
topBar.BorderSizePixel = 0

local titleLbl = Instance.new("TextLabel", topBar)
titleLbl.Size = UDim2.new(1, -80, 1, 0)
titleLbl.Position = UDim2.new(0, 14, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "THAIMION ELITE"
titleLbl.TextColor3 = Color3.fromRGB(245, 248, 255)
titleLbl.TextSize = 14
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", topBar)
minBtn.Size = UDim2.new(0, 28, 0, 26)
minBtn.Position = UDim2.new(1, -68, 0.5, -13)
minBtn.BackgroundColor3 = Color3.fromRGB(40, 46, 66)
minBtn.BackgroundTransparency = 0.25
minBtn.BorderSizePixel = 0
minBtn.Text = "-"
minBtn.TextColor3 = Color3.fromRGB(255, 228, 120)
minBtn.TextSize = 16
minBtn.Font = Enum.Font.GothamBold
round(minBtn, UDim.new(0, 8))
glassStroke(minBtn, Color3.fromRGB(255, 228, 120), 1.1, 0.3)

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 28, 0, 26)
closeBtn.Position = UDim2.new(1, -35, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(66, 28, 38)
closeBtn.BackgroundTransparency = 0.25
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 115, 125)
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
round(closeBtn, UDim.new(0, 8))
glassStroke(closeBtn, Color3.fromRGB(255, 115, 125), 1.1, 0.3)

makeDrag(floatTpBtn, floatTpBtn)
makeDrag(topBar, mainFrame)
makeDrag(miniFrame, miniFrame)

getgenv().ThaiMionP1 = {
	PGui = PGui,
	notifyGui = notifyGui,
	showTopBanner = showTopBanner,
	screenGui = screenGui,
	floatTpGui = floatTpGui,
	floatTpBtn = floatTpBtn,
	loadFrame = loadFrame,
	loadTitle = loadTitle,
	barFill = barFill,
	mainFrame = mainFrame,
	mainStroke = mainStroke,
	miniFrame = miniFrame,
	miniStroke = miniStroke,
	expandBtn = expandBtn,
	minBtn = minBtn,
	closeBtn = closeBtn,
	round = round,
	glassStroke = glassStroke,
}

print("[+] Part 1/4 Loaded!")
local p1 = getgenv().ThaiMionP1
local screenGui = p1.screenGui
local floatTpGui = p1.floatTpGui
local floatTpBtn = p1.floatTpBtn
local loadFrame = p1.loadFrame
local loadTitle = p1.loadTitle
local barFill = p1.barFill
local mainFrame = p1.mainFrame
local mainStroke = p1.mainStroke
local miniFrame = p1.miniFrame
local miniStroke = p1.miniStroke
local round = p1.round
local glassStroke = p1.glassStroke

local tabBar = Instance.new("Frame", mainFrame)
tabBar.Size = UDim2.new(1, -16, 0, 30)
tabBar.Position = UDim2.new(0, 8, 0, 44)
tabBar.BackgroundTransparency = 1

local function makeTabBtn(text, xScale, wScale)
	local b = Instance.new("TextButton", tabBar)
	b.Size = UDim2.new(wScale, -4, 1, 0)
	b.Position = UDim2.new(xScale, 2, 0, 0)
	b.BackgroundColor3 = Color3.fromRGB(26, 32, 48)
	b.BackgroundTransparency = 0.28
	b.BorderSizePixel = 0
	b.Text = text
	b.TextColor3 = Color3.fromRGB(215, 225, 245)
	b.TextSize = 12
	b.Font = Enum.Font.GothamBold
	round(b, UDim.new(1, 0))
	glassStroke(b, Color3.fromRGB(165, 200, 255), 1.1, 0.45)
	return b
end

local tabMainBtn = makeTabBtn("Main", 0, 0.333)
local tabTpBtn = makeTabBtn("Teleport", 0.333, 0.333)
local tabLagBtn = makeTabBtn("Lag Tool TM", 0.666, 0.334)

local function makePage()
	local p = Instance.new("Frame", mainFrame)
	p.Size = UDim2.new(1, -16, 1, -82)
	p.Position = UDim2.new(0, 8, 0, 78)
	p.BackgroundTransparency = 1
	p.Visible = false
	return p
end

local pageMain = makePage()
local pageTp = makePage()
local pageLag = makePage()
pageMain.Visible = true

local function switchTab(activeBtn, activePage)
	for _, b in ipairs({ tabMainBtn, tabTpBtn, tabLagBtn }) do
		b.BackgroundColor3 = Color3.fromRGB(26, 32, 48)
		b.BackgroundTransparency = 0.28
		b.TextColor3 = Color3.fromRGB(190, 200, 225)
	end
	for _, pg in ipairs({ pageMain, pageTp, pageLag }) do
		pg.Visible = false
	end
	activeBtn.BackgroundColor3 = Color3.fromRGB(68, 52, 128)
	activeBtn.BackgroundTransparency = 0.16
	activeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	activePage.Visible = true
end

switchTab(tabMainBtn, pageMain)
tabMainBtn.MouseButton1Click:Connect(function() switchTab(tabMainBtn, pageMain) end)
tabTpBtn.MouseButton1Click:Connect(function() switchTab(tabTpBtn, pageTp) end)
tabLagBtn.MouseButton1Click:Connect(function() switchTab(tabLagBtn, pageLag) end)

local speedRow = Instance.new("Frame", pageMain)
speedRow.Size = UDim2.new(1, 0, 0, 30)
speedRow.BackgroundTransparency = 1

local speedToggle = Instance.new("TextButton", speedRow)
speedToggle.Size = UDim2.new(0.68, -4, 1, 0)
speedToggle.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
speedToggle.BackgroundTransparency = 0.28
speedToggle.BorderSizePixel = 0
speedToggle.Text = "Speed: OFF"
speedToggle.TextColor3 = Color3.fromRGB(255, 115, 125)
speedToggle.TextSize = 12
speedToggle.Font = Enum.Font.GothamBold
round(speedToggle, UDim.new(1, 0))
glassStroke(speedToggle, Color3.fromRGB(165, 200, 255), 1.1, 0.4)

local speedBox = Instance.new("TextBox", speedRow)
speedBox.Size = UDim2.new(0.32, 0, 1, 0)
speedBox.Position = UDim2.new(0.68, 0, 0, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(28, 34, 52)
speedBox.BackgroundTransparency = 0.25
speedBox.BorderSizePixel = 0
speedBox.Text = "50"
speedBox.TextColor3 = Color3.fromRGB(150, 235, 255)
speedBox.TextSize = 12
speedBox.Font = Enum.Font.GothamBold
round(speedBox, UDim.new(1, 0))
glassStroke(speedBox, Color3.fromRGB(150, 235, 255), 1.1, 0.35)

local function makeMainToggle(text, yPos)
	local btn = Instance.new("TextButton", pageMain)
	btn.Size = UDim2.new(1, 0, 0, 28)
	btn.Position = UDim2.new(0, 0, 0, yPos)
	btn.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
	btn.BackgroundTransparency = 0.28
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 115, 125)
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	round(btn, UDim.new(1, 0))
	glassStroke(btn, Color3.fromRGB(165, 200, 255), 1.1, 0.4)
	return btn
end

local noclipToggle = makeMainToggle("Noclip: OFF", 35)
local antiFallToggle = makeMainToggle("Anti-Fall: OFF", 68)

local aimRow = Instance.new("Frame", pageMain)
aimRow.Size = UDim2.new(1, 0, 0, 28)
aimRow.Position = UDim2.new(0, 0, 0, 101)
aimRow.BackgroundTransparency = 1

local aimToggle = Instance.new("TextButton", aimRow)
aimToggle.Size = UDim2.new(0.5, -3, 1, 0)
aimToggle.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
aimToggle.BackgroundTransparency = 0.28
aimToggle.BorderSizePixel = 0
aimToggle.Text = "Aim Head (FOV): OFF"
aimToggle.TextColor3 = Color3.fromRGB(255, 115, 125)
aimToggle.TextSize = 11
aimToggle.Font = Enum.Font.GothamBold
round(aimToggle, UDim.new(1, 0))
glassStroke(aimToggle, Color3.fromRGB(165, 200, 255), 1.1, 0.4)

local wallbangToggle = Instance.new("TextButton", aimRow)
wallbangToggle.Size = UDim2.new(0.5, -3, 1, 0)
wallbangToggle.Position = UDim2.new(0.5, 3, 0, 0)
wallbangToggle.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
wallbangToggle.BackgroundTransparency = 0.28
wallbangToggle.BorderSizePixel = 0
wallbangToggle.Text = "Wallbang: OFF"
wallbangToggle.TextColor3 = Color3.fromRGB(255, 115, 125)
wallbangToggle.TextSize = 11
wallbangToggle.Font = Enum.Font.GothamBold
round(wallbangToggle, UDim.new(1, 0))
glassStroke(wallbangToggle, Color3.fromRGB(165, 200, 255), 1.1, 0.4)

local espToggle = makeMainToggle("ESP Rainbow & Name: OFF", 134)

local activateTpBtn = Instance.new("TextButton", pageTp)
activateTpBtn.Size = UDim2.new(1, 0, 0, 26)
activateTpBtn.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
activateTpBtn.BackgroundTransparency = 0.28
activateTpBtn.BorderSizePixel = 0
activateTpBtn.Text = "Activate TP Button: OFF"
activateTpBtn.TextColor3 = Color3.fromRGB(210, 230, 255)
activateTpBtn.TextSize = 12
activateTpBtn.Font = Enum.Font.GothamBold
round(activateTpBtn, UDim.new(1, 0))
glassStroke(activateTpBtn, Color3.fromRGB(165, 200, 255), 1.1, 0.4)

local playerScroller = Instance.new("ScrollingFrame", pageTp)
playerScroller.Size = UDim2.new(1, 0, 0, 126)
playerScroller.Position = UDim2.new(0, 0, 0, 32)
playerScroller.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
playerScroller.BackgroundTransparency = 0.25
playerScroller.BorderSizePixel = 0
playerScroller.ScrollBarThickness = 4
playerScroller.CanvasSize = UDim2.new(0, 0, 0, 0)
round(playerScroller, UDim.new(0, 10))
glassStroke(playerScroller, Color3.fromRGB(150, 190, 255), 1.1, 0.45)
Instance.new("UIListLayout", playerScroller).Padding = UDim.new(0, 3)

local stickRow = Instance.new("Frame", pageTp)
stickRow.Size = UDim2.new(1, 0, 0, 28)
stickRow.Position = UDim2.new(0, 0, 0, 164)
stickRow.BackgroundTransparency = 1

local stickToggle = Instance.new("TextButton", stickRow)
stickToggle.Size = UDim2.new(0.5, -3, 1, 0)
stickToggle.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
stickToggle.BackgroundTransparency = 0.28
stickToggle.BorderSizePixel = 0
stickToggle.Text = "Stick Front: OFF"
stickToggle.TextColor3 = Color3.fromRGB(255, 115, 125)
stickToggle.TextSize = 11
stickToggle.Font = Enum.Font.GothamBold
round(stickToggle, UDim.new(1, 0))
glassStroke(stickToggle, Color3.fromRGB(165, 200, 255), 1.1, 0.4)

local flingToggle = Instance.new("TextButton", stickRow)
flingToggle.Size = UDim2.new(0.5, -3, 1, 0)
flingToggle.Position = UDim2.new(0.5, 3, 0, 0)
flingToggle.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
flingToggle.BackgroundTransparency = 0.28
flingToggle.BorderSizePixel = 0
flingToggle.Text = "Fling Target: OFF"
flingToggle.TextColor3 = Color3.fromRGB(255, 115, 125)
flingToggle.TextSize = 11
flingToggle.Font = Enum.Font.GothamBold
round(flingToggle, UDim.new(1, 0))
glassStroke(flingToggle, Color3.fromRGB(165, 200, 255), 1.1, 0.4)

local lagRow = Instance.new("Frame", pageLag)
lagRow.Size = UDim2.new(1, 0, 0, 26)
lagRow.BackgroundTransparency = 1

local lagToggle = Instance.new("TextButton", lagRow)
lagToggle.Size = UDim2.new(0.7, -4, 1, 0)
lagToggle.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
lagToggle.BackgroundTransparency = 0.28
lagToggle.BorderSizePixel = 0
lagToggle.Text = "Spam Heavy Items: OFF"
lagToggle.TextColor3 = Color3.fromRGB(255, 115, 125)
lagToggle.TextSize = 11
lagToggle.Font = Enum.Font.GothamBold
round(lagToggle, UDim.new(1, 0))
glassStroke(lagToggle, Color3.fromRGB(165, 200, 255), 1.1, 0.4)

local lagBox = Instance.new("TextBox", lagRow)
lagBox.Size = UDim2.new(0.3, 0, 1, 0)
lagBox.Position = UDim2.new(0.7, 0, 0, 0)
lagBox.BackgroundColor3 = Color3.fromRGB(28, 34, 52)
lagBox.BackgroundTransparency = 0.25
lagBox.BorderSizePixel = 0
lagBox.Text = "15"
lagBox.TextColor3 = Color3.fromRGB(150, 235, 255)
lagBox.TextSize = 12
lagBox.Font = Enum.Font.GothamBold
round(lagBox, UDim.new(1, 0))
glassStroke(lagBox, Color3.fromRGB(150, 235, 255), 1.1, 0.35)

local function makeSlider(parent, yPos, defaultVal, prefixText, fillColor)
	local card = Instance.new("Frame", parent)
	card.Size = UDim2.new(1, 0, 0, 38)
	card.Position = UDim2.new(0, 0, 0, yPos)
	card.BackgroundColor3 = Color3.fromRGB(22, 26, 40)
	card.BackgroundTransparency = 0.24
	card.BorderSizePixel = 0
	round(card, UDim.new(0, 10))
	glassStroke(card, Color3.fromRGB(155, 205, 255), 1.1, 0.4)

	local lbl = Instance.new("TextLabel", card)
	lbl.Size = UDim2.new(1, -16, 0, 15)
	lbl.Position = UDim2.new(0, 8, 0, 2)
	lbl.BackgroundTransparency = 1
	lbl.Text = prefixText .. tostring(defaultVal) .. " studs"
	lbl.TextColor3 = Color3.fromRGB(150, 235, 255)
	lbl.TextSize = 10
	lbl.Font = Enum.Font.GothamBold
	lbl.TextXAlignment = Enum.TextXAlignment.Left

	local track = Instance.new("Frame", card)
	track.Size = UDim2.new(1, -16, 0, 8)
	track.Position = UDim2.new(0, 8, 0, 22)
	track.BackgroundColor3 = Color3.fromRGB(38, 44, 64)
	track.BackgroundTransparency = 0.2
	track.BorderSizePixel = 0
	round(track, UDim.new(1, 0))

	local fill = Instance.new("Frame", track)
	fill.Size = UDim2.new(0.23, 0, 1, 0)
	fill.BackgroundColor3 = fillColor or Color3.fromRGB(60, 235, 175)
	fill.BorderSizePixel = 0
	round(fill, UDim.new(1, 0))

	local knob = Instance.new("Frame", track)
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = UDim2.new(0.23, -7, 0.5, -7)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	round(knob, UDim.new(1, 0))

	local hitBtn = Instance.new("TextButton", track)
	hitBtn.Size = UDim2.new(1, 0, 1, 10)
	hitBtn.Position = UDim2.new(0, 0, 0, -5)
	hitBtn.BackgroundTransparency = 1
	hitBtn.Text = ""

	return { lbl = lbl, fill = fill, knob = knob, track = track, hitBtn = hitBtn }
end

local flingSlider = makeSlider(pageLag, 30, 65, "Phạm vi Fling đồ: ", Color3.fromRGB(60, 235, 175))
local pullSlider = makeSlider(pageLag, 72, 55, "Phạm vi Hút vòng tròn: ", Color3.fromRGB(115, 205, 255))

local propRow = Instance.new("Frame", pageLag)
propRow.Size = UDim2.new(1, 0, 0, 26)
propRow.Position = UDim2.new(0, 0, 0, 114)
propRow.BackgroundTransparency = 1

local antiLagClientBtn = Instance.new("TextButton", propRow)
antiLagClientBtn.Size = UDim2.new(0.5, -3, 1, 0)
antiLagClientBtn.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
antiLagClientBtn.BackgroundTransparency = 0.28
antiLagClientBtn.BorderSizePixel = 0
antiLagClientBtn.Text = "Fling Props: OFF"
antiLagClientBtn.TextColor3 = Color3.fromRGB(255, 115, 125)
antiLagClientBtn.TextSize = 11
antiLagClientBtn.Font = Enum.Font.GothamBold
round(antiLagClientBtn, UDim.new(1, 0))
glassStroke(antiLagClientBtn, Color3.fromRGB(165, 200, 255), 1.1, 0.4)

local pullCircleBtn = Instance.new("TextButton", propRow)
pullCircleBtn.Size = UDim2.new(0.5, -3, 1, 0)
pullCircleBtn.Position = UDim2.new(0.5, 3, 0, 0)
pullCircleBtn.BackgroundColor3 = Color3.fromRGB(28, 32, 48)
pullCircleBtn.BackgroundTransparency = 0.28
pullCircleBtn.BorderSizePixel = 0
pullCircleBtn.Text = "Hút Vòng Tròn: OFF"
pullCircleBtn.TextColor3 = Color3.fromRGB(255, 115, 125)
pullCircleBtn.TextSize = 11
pullCircleBtn.Font = Enum.Font.GothamBold
round(pullCircleBtn, UDim.new(1, 0))
glassStroke(pullCircleBtn, Color3.fromRGB(165, 200, 255), 1.1, 0.4)

local resetBtn = Instance.new("TextButton", pageLag)
resetBtn.Size = UDim2.new(1, 0, 0, 26)
resetBtn.Position = UDim2.new(0, 0, 0, 144)
resetBtn.BackgroundColor3 = Color3.fromRGB(46, 28, 38)
resetBtn.BackgroundTransparency = 0.24
resetBtn.BorderSizePixel = 0
resetBtn.Text = "Restore / Reset State"
resetBtn.TextColor3 = Color3.fromRGB(255, 210, 115)
resetBtn.TextSize = 11
resetBtn.Font = Enum.Font.GothamBold
round(resetBtn, UDim.new(1, 0))
glassStroke(resetBtn, Color3.fromRGB(255, 210, 115), 1.1, 0.35)

getgenv().ThaiMionP2 = {
	playerScroller = playerScroller,
	activateTpBtn = activateTpBtn,
	stickToggle = stickToggle,
	flingToggle = flingToggle,
	lagToggle = lagToggle,
	lagBox = lagBox,
	flingSlider = flingSlider,
	pullSlider = pullSlider,
	antiLagClientBtn = antiLagClientBtn,
	pullCircleBtn = pullCircleBtn,
	resetBtn = resetBtn,
	mainRefs = {
		speedToggle = speedToggle,
		speedBox = speedBox,
		noclipToggle = noclipToggle,
		antiFallToggle = antiFallToggle,
		aimToggle = aimToggle,
		wallbangToggle = wallbangToggle,
		espToggle = espToggle,
	}
}

p1.minBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
	miniFrame.Visible = true
end)

p1.expandBtn.MouseButton1Click:Connect(function()
	miniFrame.Visible = false
	mainFrame.Visible = true
end)

p1.closeBtn.MouseButton1Click:Connect(function()
	pcall(function() resetBtn:Activate() end)
	pcall(function() floatTpGui:Destroy() end)
	pcall(function() p1.notifyGui:Destroy() end)
	pcall(function() screenGui:Destroy() end)
end)

task.spawn(function()
	local hue = 0
	while screenGui.Parent do
		hue = (hue + 0.004) % 1
		local col = Color3.fromHSV(hue, 0.85, 1)
		mainStroke.Color = col
		miniStroke.Color = col
		task.wait(0.03)
	end
end)

task.spawn(function()
	for i = 1, 100 do
		if not loadFrame.Parent then return end
		barFill.Size = UDim2.new(i / 100, 0, 1, 0)
		loadTitle.Text = "@ThaiMion Loading: " .. tostring(i) .. "%"
		task.wait(0.012)
	end
	loadFrame.Visible = false
	mainFrame.Visible = true
	if p1.showTopBanner then p1.showTopBanner("Đã Load Thành Công") end
end)

print("[+] Part 2/4 Loaded!")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local p2 = getgenv().ThaiMionP2 or {}
local refs = p2.mainRefs or {}

local speedEnabled, noclipEnabled, antiFallEnabled = false, false, false
local aimEnabled, wallbangEnabled, espEnabled = false, false, false
local FOV_RADIUS = 135
local espObjects = {}

local function stylePill(btn, isOn, onText, offText)
	if not btn then return end
	btn.Text = isOn and onText or offText
	btn.TextColor3 = isOn and Color3.fromRGB(120, 255, 190) or Color3.fromRGB(255, 115, 125)
	btn.BackgroundColor3 = isOn and Color3.fromRGB(22, 68, 52) or Color3.fromRGB(28, 32, 48)
	btn.BackgroundTransparency = isOn and 0.16 or 0.28
end

local fovCircle = Drawing and Drawing.new("Circle")
if fovCircle then
	fovCircle.Visible = false
	fovCircle.Thickness = 1.6
	fovCircle.NumSides = 64
	fovCircle.Radius = FOV_RADIUS
	fovCircle.Filled = false
	fovCircle.Color = Color3.fromRGB(245, 248, 255)
end

local function clearEspForPlayer(plr)
	local data = espObjects[plr]
	if data then
		if data.highlight then pcall(function() data.highlight:Destroy() end) end
		if data.billboard then pcall(function() data.billboard:Destroy() end) end
		espObjects[plr] = nil
	end
end

local function clearAllEsp()
	for plr in pairs(espObjects) do clearEspForPlayer(plr) end
end

local function ensureEspForPlayer(plr)
	if not espEnabled or plr == LocalPlayer then return end
	local char = plr.Character
	local head = char and char:FindFirstChild("Head")
	if not char or not head then return end

	if not espObjects[plr] then
		local hl = Instance.new("Highlight", char)
		hl.Name = "ThaiMionHL"
		hl.FillTransparency = 0.65
		hl.OutlineTransparency = 0
		hl.DepthMode = Enum.HighlightTargetDepthMode.AlwaysOnTop
		hl.Adornee = char

		local bb = Instance.new("BillboardGui", head)
		bb.Name = "ThaiMionNameTag"
		bb.Size = UDim2.new(0, 140, 0, 24)
		bb.StudsOffset = Vector3.new(0, 2.4, 0)
		bb.AlwaysOnTop = true
		bb.Adornee = head

		local lbl = Instance.new("TextLabel", bb)
		lbl.Size = UDim2.new(1, 0, 1, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = plr.DisplayName ~= "" and plr.DisplayName or plr.Name
		lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
		lbl.TextStrokeTransparency = 0.25
		lbl.TextSize = 13
		lbl.Font = Enum.Font.GothamBold

		espObjects[plr] = { highlight = hl, billboard = bb, label = lbl }
	else
		espObjects[plr].highlight.Adornee = char
		espObjects[plr].highlight.Parent = char
		espObjects[plr].billboard.Adornee = head
		espObjects[plr].billboard.Parent = head
	end
end

local function hasLineOfSight(fromPos, targetPart)
	if wallbangEnabled then return true end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { LocalPlayer.Character, targetPart and targetPart.Parent }
	return Workspace:Raycast(fromPos, targetPart.Position - fromPos, params) == nil
end

local function getClosestHeadInFov()
	local viewportCenter = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5)
	local bestPart, bestDist = nil, FOV_RADIUS
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			local head = plr.Character:FindFirstChild("Head") or plr.Character:FindFirstChild("HumanoidRootPart")
			if hum and hum.Health > 0 and head then
				local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
				if onScreen and screenPos.Z > 0 then
					local d = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
					if d <= bestDist and hasLineOfSight(Camera.CFrame.Position, head) then
						bestDist = d
						bestPart = head
					end
				end
			end
		end
	end
	return bestPart
end

if refs.speedToggle then refs.speedToggle.MouseButton1Click:Connect(function() speedEnabled = not speedEnabled; stylePill(refs.speedToggle, speedEnabled, "Speed: ON", "Speed: OFF") end) end
if refs.noclipToggle then refs.noclipToggle.MouseButton1Click:Connect(function() noclipEnabled = not noclipEnabled; stylePill(refs.noclipToggle, noclipEnabled, "Noclip: ON", "Noclip: OFF") end) end
if refs.antiFallToggle then refs.antiFallToggle.MouseButton1Click:Connect(function() antiFallEnabled = not antiFallEnabled; stylePill(refs.antiFallToggle, antiFallEnabled, "Anti-Fall: ON", "Anti-Fall: OFF") end) end
if refs.aimToggle then refs.aimToggle.MouseButton1Click:Connect(function() aimEnabled = not aimEnabled; stylePill(refs.aimToggle, aimEnabled, "Aim Head (FOV): ON", "Aim Head (FOV): OFF") end) end
if refs.wallbangToggle then refs.wallbangToggle.MouseButton1Click:Connect(function() wallbangEnabled = not wallbangEnabled; stylePill(refs.wallbangToggle, wallbangEnabled, "Wallbang: ON", "Wallbang: OFF") end) end
if refs.espToggle then
	refs.espToggle.MouseButton1Click:Connect(function()
		espEnabled = not espEnabled
		stylePill(refs.espToggle, espEnabled, "ESP Rainbow & Name: ON", "ESP Rainbow & Name: OFF")
		if not espEnabled then clearAllEsp() end
	end)
end
Players.PlayerRemoving:Connect(clearEspForPlayer)

RunService.Stepped:Connect(function()
	local char = LocalPlayer.Character
	if not char or not noclipEnabled then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then part.CanCollide = false end
	end
end)

RunService.RenderStepped:Connect(function()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")

	if speedEnabled and hum then
		local spd = tonumber(refs.speedBox and refs.speedBox.Text) or 50
		hum.WalkSpeed = math.clamp(spd, 16, 250)
	end

	if antiFallEnabled and root then
		local fallen = root.Position.Y < -85 or (hum and hum:GetState() == Enum.HumanoidStateType.FallingDown)
		if fallen then
			pcall(function()
				root.AssemblyLinearVelocity = Vector3.zero
				root.Velocity = Vector3.zero
				if hum then
					hum:ChangeState(Enum.HumanoidStateType.GettingUp)
					hum:ChangeState(Enum.HumanoidStateType.Running)
				end
				if root.Position.Y < -85 then
					root.CFrame = CFrame.new(root.Position.X, 25, root.Position.Z)
				end
			end)
		end
	end

	if fovCircle then
		fovCircle.Visible = aimEnabled
		if aimEnabled then
			fovCircle.Position = Vector2.new(Camera.ViewportSize.X * 0.5, Camera.ViewportSize.Y * 0.5)
			fovCircle.Radius = FOV_RADIUS
		end
	end

	if aimEnabled then
		local targetPart = getClosestHeadInFov()
		if targetPart then
			Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPart.Position)
		end
	end

	if espEnabled then
		local hue = (tick() * 0.35) % 1
		local col = Color3.fromHSV(hue, 0.9, 1)
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				ensureEspForPlayer(plr)
				local data = espObjects[plr]
				if data then
					data.highlight.FillColor = col
					data.highlight.OutlineColor = col
					data.label.TextColor3 = col
				end
			end
		end
	end
end)

getgenv().ThaiMionResetMain = function()
	speedEnabled, noclipEnabled, antiFallEnabled = false, false, false
	aimEnabled, wallbangEnabled, espEnabled = false, false, false
	clearAllEsp()
	if fovCircle then fovCircle.Visible = false end
	stylePill(refs.speedToggle, false, "Speed: ON", "Speed: OFF")
	stylePill(refs.noclipToggle, false, "Noclip: ON", "Noclip: OFF")
	stylePill(refs.antiFallToggle, false, "Anti-Fall: ON", "Anti-Fall: OFF")
	stylePill(refs.aimToggle, false, "Aim Head (FOV): ON", "Aim Head (FOV): OFF")
	stylePill(refs.wallbangToggle, false, "Wallbang: ON", "Wallbang: OFF")
	stylePill(refs.espToggle, false, "ESP Rainbow & Name: ON", "ESP Rainbow & Name: OFF")
	local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if hum and hum.WalkSpeed > 24 then hum.WalkSpeed = 16 end
end

print("[+] Part 3/4 Loaded!")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local p1 = getgenv().ThaiMionP1 or {}
local p2 = getgenv().ThaiMionP2 or {}
local scroller = p2.playerScroller
local round = p1.round or function(o, r) Instance.new("UICorner", o).CornerRadius = r or UDim.new(0, 12) end

local function stylePill(btn, isOn, onText, offText)
	if not btn then return end
	btn.Text = isOn and onText or offText
	btn.TextColor3 = isOn and Color3.fromRGB(120, 255, 190) or Color3.fromRGB(255, 115, 125)
	btn.BackgroundColor3 = isOn and Color3.fromRGB(22, 68, 52) or Color3.fromRGB(28, 32, 48)
	btn.BackgroundTransparency = isOn and 0.16 or 0.28
end

local selectedTarget = nil
local playerButtons = {}
local stickEnabled = false
local stickHopToken = 0
local tpBtnActive = false
local propFlingEnabled = false
local pullCircleEnabled = false
local propFlingRadius = 65
local pullCircleRadius = 55

local function bindSlider(sObj, minV, maxV, prefix, defaultVal, onVal)
	if not sObj then return end
	local function apply(val)
		local clamped = math.clamp(math.floor(val + 0.5), minV, maxV)
		local ratio = (clamped - minV) / (maxV - minV)
		sObj.fill.Size = UDim2.new(ratio, 0, 1, 0)
		sObj.knob.Position = UDim2.new(ratio, -7, 0.5, -7)
		sObj.lbl.Text = prefix .. tostring(clamped) .. " studs"
		onVal(clamped)
	end
	apply(defaultVal)

	local sliding = false
	local function updateFromInput(input)
		local absX = sObj.track.AbsolutePosition.X
		local absW = math.max(sObj.track.AbsoluteSize.X, 1)
		local ratio = math.clamp((input.Position.X - absX) / absW, 0, 1)
		apply(minV + ratio * (maxV - minV))
	end
	sObj.hitBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliding = true
			updateFromInput(input)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateFromInput(input)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliding = false
		end
	end)
end

bindSlider(p2.flingSlider, 10, 250, "Phạm vi Fling đồ: ", 65, function(v)
	propFlingRadius = v
	if propFlingEnabled and p2.antiLagClientBtn then
		p2.antiLagClientBtn.Text = "Fling Props (" .. tostring(v) .. "): ON"
	end
end)

bindSlider(p2.pullSlider, 10, 200, "Phạm vi Hút vòng tròn: ", 55, function(v)
	pullCircleRadius = v
	if pullCircleEnabled and p2.pullCircleBtn then
		p2.pullCircleBtn.Text = "Hút Vòng (" .. tostring(v) .. "): ON"
	end
end)

local function zeroPhysics(root)
	if not root then return end
	pcall(function()
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		root.Velocity = Vector3.zero
		root.RotVelocity = Vector3.zero
	end)
end

local function restoreMovement(char)
	if not char then return end
	pcall(function()
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then
				p.Anchored = false
				p.CanCollide = true
			end
		end
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then zeroPhysics(root) end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.PlatformStand = false
			if hum.WalkSpeed <= 0 then hum.WalkSpeed = 16 end
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			hum:ChangeState(Enum.HumanoidStateType.Running)
		end
	end)
end

local function setCharCombatMode(char, state)
	if not char then return end
	pcall(function()
		for _, p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then
				p.Anchored = false
				p.CanCollide = not state
			end
		end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum and state then hum.PlatformStand = false end
	end)
end

local function isPlayerPart(part)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character and part:IsDescendantOf(plr.Character) then
			return true
		end
	end
	return false
end

local function isValidProp(part)
	if not part or not part:IsA("BasePart") then return false end
	if part.Anchored or isPlayerPart(part) or part == Camera.CameraSubject then return false end
	if part.Name == "HumanoidRootPart" or part.Name == "Head" then return false end
	return true
end

local function flingPartAway(part, originPos)
	if not isValidProp(part) then return end
	local delta = part.Position - originPos
	local dist = delta.Magnitude
	if dist > propFlingRadius then return end
	local dir = dist > 0.01 and delta.Unit or Vector3.new(1, 0.3, 0).Unit
	local launchVel = (dir * 260) + Vector3.new(0, 140, 0)
	local spinVel = Vector3.new(math.random(-80, 80), math.random(-80, 80), math.random(-80, 80))
	pcall(function()
		part.CanCollide = true
		part.AssemblyLinearVelocity = launchVel
		part.AssemblyAngularVelocity = spinVel
		part.Velocity = launchVel
		part.RotVelocity = spinVel
	end)
end

local function flingNearbyProps(originPos)
	if not originPos then return end
	pcall(function()
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				flingPartAway(obj, originPos)
			end
		end
	end)
end

local orbitAngle = 0
local function pullPropsIntoCircle(centerPos, dt)
	if not centerPos then return end
	orbitAngle = (orbitAngle + (dt or 0.016) * 3.2) % (math.pi * 2)
	local candidates = {}
	pcall(function()
		for _, obj in ipairs(workspace:GetDescendants()) do
			if isValidProp(obj) and (obj.Position - centerPos).Magnitude <= pullCircleRadius then
				table.insert(candidates, obj)
			end
		end
	end)
	local total = #candidates
	if total == 0 then return end
	local ringRadius = math.clamp(4.5 + (total * 0.14), 4.5, 13)
	for idx, part in ipairs(candidates) do
		local theta = orbitAngle + ((idx - 1) / total) * (math.pi * 2)
		local ringTarget = centerPos + Vector3.new(math.cos(theta) * ringRadius, 1.5 + ((idx % 3) * 0.65), math.sin(theta) * ringRadius)
		local vel = ((ringTarget - part.Position) * 12) + (Vector3.new(-math.sin(theta), 0, math.cos(theta)) * 18)
		pcall(function()
			part.CanCollide = false
			part.AssemblyLinearVelocity = vel
			part.Velocity = vel
		end)
	end
end

getgenv().ThaiMionP4A = {
	p1 = p1,
	p2 = p2,
	scroller = scroller,
	round = round,
	stylePill = stylePill,
	zeroPhysics = zeroPhysics,
	restoreMovement = restoreMovement,
	setCharCombatMode = setCharCombatMode,
	flingNearbyProps = flingNearbyProps,
	pullPropsIntoCircle = pullPropsIntoCircle,
	getState = function()
		return {
			selectedTarget = selectedTarget,
			stickEnabled = stickEnabled,
			stickHopToken = stickHopToken,
			tpBtnActive = tpBtnActive,
			propFlingEnabled = propFlingEnabled,
			pullCircleEnabled = pullCircleEnabled,
		}
	end,
	setTarget = function(t) selectedTarget = t end,
	setStickFlag = function(v) stickEnabled = v end,
	nextStickToken = function() stickHopToken += 1; return stickHopToken end,
	setTpFlag = function(v) tpBtnActive = v end,
	setPropFlingFlag = function(v) propFlingEnabled = v end,
	setPullCircleFlag = function(v) pullCircleEnabled = v end,
	getPropRadius = function() return propFlingRadius end,
	getPullRadius = function() return pullCircleRadius end,
}

print("[+] Part 4A/4 Loaded!")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local p4a = getgenv().ThaiMionP4A
local p1 = p4a.p1
local p2 = p4a.p2
local scroller = p4a.scroller
local round = p4a.round
local stylePill = p4a.stylePill
local zeroPhysics = p4a.zeroPhysics
local restoreMovement = p4a.restoreMovement
local setCharCombatMode = p4a.setCharCombatMode
local flingNearbyProps = p4a.flingNearbyProps
local pullPropsIntoCircle = p4a.pullPropsIntoCircle

local playerButtons = {}

local function getTargetAnchor(targetPlr)
	local char = targetPlr and targetPlr.Character
	return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))
end

local function getFrontCFrame(tr)
	local frontPos = (tr.CFrame * CFrame.new(0, 0.45, -3.4)).Position
	return CFrame.lookAt(frontPos, Vector3.new(tr.Position.X, frontPos.Y, tr.Position.Z))
end

local function placeCharAtCFrame(char, root, cf)
	if not char or not root then return end
	pcall(function()
		root.Anchored = false
		zeroPhysics(root)
		if char.PrimaryPart then char:PivotTo(cf) else root.CFrame = cf end
		zeroPhysics(root)
	end)
end

local function refreshSelectionUI()
	local target = p4a.getState().selectedTarget
	for plr, btn in pairs(playerButtons) do
		if btn and btn.Parent then
			local isSel = (target == plr)
			btn.BackgroundColor3 = isSel and Color3.fromRGB(26, 76, 56) or Color3.fromRGB(24, 28, 44)
			btn.Text = (isSel and "  [x] " or "  [ ] ") .. plr.Name
		end
	end
end

local function setStickState(state)
	local st = p4a.getState()
	if state and not st.selectedTarget then
		p4a.setStickFlag(false)
		stylePill(p2.stickToggle, false, "Stick Front: ON", "Stick Front: OFF")
		return
	end
	p4a.setStickFlag(state)
	local myToken = p4a.nextStickToken()
	stylePill(p2.stickToggle, state, "Stick Front: ON", "Stick Front: OFF")

	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not state then
		restoreMovement(char)
	elseif char and root and st.selectedTarget then
		setCharCombatMode(char, true)
		task.spawn(function()
			if myToken ~= p4a.getState().stickHopToken or not p4a.getState().stickEnabled then return end
			local tr = getTargetAnchor(p4a.getState().selectedTarget)
			if tr then
				local goalCf = getFrontCFrame(tr)
				local dist = (root.Position - goalCf.Position).Magnitude
				if dist > 110 then
					local steps = math.clamp(math.ceil(dist / 85), 2, 10)
					for i = 1, steps do
						if not p4a.getState().stickEnabled or myToken ~= p4a.getState().stickHopToken then return end
						local curChar = LocalPlayer.Character
						local curRoot = curChar and curChar:FindFirstChild("HumanoidRootPart")
						local curTr = getTargetAnchor(p4a.getState().selectedTarget)
						if not curChar or not curRoot or not curTr then return end
						local curGoal = getFrontCFrame(curTr)
						local hopPos = curRoot.Position:Lerp(curGoal.Position, i / steps) + Vector3.new(0, 1.4, 0)
						placeCharAtCFrame(curChar, curRoot, CFrame.lookAt(hopPos, Vector3.new(curTr.Position.X, hopPos.Y, curTr.Position.Z)))
						task.wait(0.03)
					end
				end
				if p4a.getState().stickEnabled and myToken == p4a.getState().stickHopToken then
					local curChar = LocalPlayer.Character
					local curRoot = curChar and curChar:FindFirstChild("HumanoidRootPart")
					local curTr = getTargetAnchor(p4a.getState().selectedTarget)
					if curChar and curRoot and curTr then
						placeCharAtCFrame(curChar, curRoot, getFrontCFrame(curTr))
					end
				end
			end
		end)
	end
end

local function updateCanvas()
	if not scroller then return end
	local count = 0
	for _, btn in pairs(playerButtons) do
		if btn and btn.Parent then count += 1 end
	end
	scroller.CanvasSize = UDim2.new(0, 0, 0, count * 29)
end

local function addPlayerBtn(p)
	if p == LocalPlayer or not scroller or playerButtons[p] then return end
	local btn = Instance.new("TextButton", scroller)
	btn.Size = UDim2.new(1, -4, 0, 26)
	btn.BackgroundColor3 = Color3.fromRGB(24, 28, 44)
	btn.BackgroundTransparency = 0.22
	btn.BorderSizePixel = 0
	btn.Text = "  [ ] " .. p.Name
	btn.TextColor3 = Color3.fromRGB(235, 240, 255)
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	btn.TextXAlignment = Enum.TextXAlignment.Left
	round(btn, UDim.new(1, 0))
	btn.MouseButton1Click:Connect(function()
		local cur = p4a.getState().selectedTarget
		if cur == p then
			p4a.setTarget(nil)
			if p4a.getState().stickEnabled then setStickState(false) end
		else
			p4a.setTarget(p)
			if p4a.getState().stickEnabled then setStickState(true) end
		end
		refreshSelectionUI()
	end)
	playerButtons[p] = btn
	updateCanvas()
end

for _, p in ipairs(Players:GetPlayers()) do addPlayerBtn(p) end
Players.PlayerAdded:Connect(addPlayerBtn)

local function setTpButtonState(state)
	p4a.setTpFlag(state)
	if p2.activateTpBtn then
		p2.activateTpBtn.Text = state and "Activate TP Button: ON" or "Activate TP Button: OFF"
		p2.activateTpBtn.TextColor3 = state and Color3.fromRGB(120, 255, 190) or Color3.fromRGB(210, 230, 255)
		p2.activateTpBtn.BackgroundColor3 = state and Color3.fromRGB(22, 68, 52) or Color3.fromRGB(28, 32, 48)
		p2.activateTpBtn.BackgroundTransparency = state and 0.16 or 0.28
	end
	if p1.floatTpGui then p1.floatTpGui.Enabled = state end
end

if p2.activateTpBtn then
	p2.activateTpBtn.MouseButton1Click:Connect(function() setTpButtonState(not p4a.getState().tpBtnActive) end)
end

if p1.floatTpBtn then
	p1.floatTpBtn.MouseButton1Click:Connect(function()
		local char = LocalPlayer.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not char or not root then return end
		local origin = Camera.CFrame.Position
		local dir = Camera.CFrame.LookVector
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = { char }
		local hit = workspace:Raycast(origin, dir * 500, params)
		local destPos = hit and (hit.Position + Vector3.new(0, 3, 0)) or (origin + dir * 85)
		local lookFlat = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
		local destCf = lookFlat.Magnitude > 0.001 and CFrame.lookAt(destPos, destPos + lookFlat.Unit) or CFrame.new(destPos)
		placeCharAtCFrame(char, root, destCf)
	end)
end

local flingEnabled = false
local savedOriginCFrame = nil
local flingConn = nil
local snapTimer = 0
local SNAP_INTERVAL = 7

local function stopFling(returnOrigin)
	flingEnabled = false
	snapTimer = 0
	if flingConn then flingConn:Disconnect(); flingConn = nil end
	stylePill(p2.flingToggle, false, "Fling Target: ON", "Fling Target: OFF")
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	restoreMovement(char)
	if root and returnOrigin and savedOriginCFrame then
		pcall(function()
			root.CFrame = savedOriginCFrame + Vector3.new(0, 1.5, 0)
			zeroPhysics(root)
		end)
	end
	savedOriginCFrame = nil
end

Players.PlayerRemoving:Connect(function(plr)
	if p4a.getState().selectedTarget == plr then
		p4a.setTarget(nil)
		if p4a.getState().stickEnabled then setStickState(false) end
		if flingEnabled then stopFling(true) end
	end
	if playerButtons[plr] then
		playerButtons[plr]:Destroy()
		playerButtons[plr] = nil
		updateCanvas()
	end
end)

if p2.stickToggle then
	p2.stickToggle.MouseButton1Click:Connect(function()
		if not p4a.getState().stickEnabled then
			if not p4a.getState().selectedTarget then return end
			setStickState(true)
		else
			setStickState(false)
		end
	end)
end

if p2.flingToggle then
	p2.flingToggle.MouseButton1Click:Connect(function()
		local target = p4a.getState().selectedTarget
		if not flingEnabled then
			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not root or not target then return end
			savedOriginCFrame = root.CFrame
			flingEnabled = true
			snapTimer = 0
			stylePill(p2.flingToggle, true, "Fling Target: ON", "Fling Target: OFF")
			local flingAngle = 0
			flingConn = RunService.Heartbeat:Connect(function(dt)
				if not flingEnabled then return end
				local curTarget = p4a.getState().selectedTarget
				local myChar = LocalPlayer.Character
				local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
				if not myRoot or not curTarget or not curTarget.Parent then
					stopFling(true)
					return
				end
				setCharCombatMode(myChar, true)
				snapTimer += dt
				if snapTimer >= SNAP_INTERVAL then
					snapTimer = 0
					if savedOriginCFrame then
						pcall(function()
							zeroPhysics(myRoot)
							myRoot.CFrame = savedOriginCFrame + Vector3.new(0, 1.5, 0)
						end)
					end
					return
				end
				local tChar = curTarget.Character
				local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
				if tRoot then
					flingAngle = (flingAngle + (dt * 95)) % (math.pi * 2)
					local hitPos = tRoot.Position + Vector3.new(math.cos(flingAngle) * 0.55, 0.35, math.sin(flingAngle) * 0.55)
					local slamVel = Vector3.new(999999, 999999, 999999)
					local slamAng = Vector3.new(0, 999999, 0)
					pcall(function()
						myRoot.CFrame = CFrame.new(hitPos) * CFrame.Angles(0, flingAngle, 0)
						myRoot.Velocity = slamVel
						myRoot.RotVelocity = slamAng
						myRoot.AssemblyLinearVelocity = slamVel
						myRoot.AssemblyAngularVelocity = slamAng
					end)
				end
			end)
		else
			stopFling(true)
		end
	end)
end

local function collectHeavyGameItems()
	local items = {}
	local keywords = { "car", "vehicle", "truck", "bus", "boat", "heli", "plane", "bike", "tank", "spawn", "item", "crate", "prop", "object", "part", "xe", "oto", "tau", "maybay" }
	for _, rootObj in ipairs({ ReplicatedStorage, workspace }) do
		local ok, desc = pcall(function() return rootObj:GetDescendants() end)
		if ok and desc then
			for _, obj in ipairs(desc) do
				if obj:IsA("Model") or obj:IsA("Tool") or obj:IsA("Folder") or obj:IsA("StringValue") or obj:IsA("ObjectValue") then
					local lowerName = string.lower(obj.Name)
					for _, kw in ipairs(keywords) do
						if string.find(lowerName, kw, 1, true) then
							table.insert(items, obj)
							break
						end
					end
				end
				if #items >= 40 then break end
			end
		end
		if #items >= 40 then break end
	end
	return items
end

local function collectRemotes()
	local remotes = {}
	local priorityKeywords = { "spawn", "vehicle", "car", "truck", "summon", "create", "item", "drop", "prop", "buy", "load" }
	for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
		if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
			local score = 0
			local lowerName = string.lower(obj.Name)
			for _, kw in ipairs(priorityKeywords) do
				if string.find(lowerName, kw, 1, true) then score += 10 end
			end
			table.insert(remotes, { obj = obj, score = score })
		end
	end
	table.sort(remotes, function(a, b) return a.score > b.score end)
	local out = {}
	for i = 1, math.min(#remotes, 18) do table.insert(out, remotes[i].obj) end
	return out
end

local function collectFarSpreadCFrames(myRoot)
	local list = {}
	local myPos = myRoot and myRoot.Position or Vector3.zero
	local farOffsets = {
		Vector3.new(150, 5, 150), Vector3.new(-165, 5, 145), Vector3.new(170, 5, -155), Vector3.new(-180, 5, -170),
		Vector3.new(0, 10, 210), Vector3.new(215, 10, 0), Vector3.new(-210, 10, 0), Vector3.new(0, 10, -210),
	}
	for _, off in ipairs(farOffsets) do
		local candidate = myPos + off
		if (candidate - myPos).Magnitude >= 120 then table.insert(list, CFrame.new(candidate)) end
	end
	return list
end

local function fireRemoteSafe(remote, payload, targetCf)
	pcall(function()
		if remote:IsA("RemoteEvent") then
			remote:FireServer(payload, targetCf)
			remote:FireServer(payload.Name or payload, targetCf)
			remote:FireServer(payload)
		elseif remote:IsA("RemoteFunction") then
			task.spawn(function()
				pcall(function()
					remote:InvokeServer(payload, targetCf)
					remote:InvokeServer(payload.Name or payload, targetCf)
				end)
			end)
		end
	end)
end

local isLagging = false
if p2.lagToggle then
	p2.lagToggle.MouseButton1Click:Connect(function()
		isLagging = not isLagging
		stylePill(p2.lagToggle, isLagging, "Spam Heavy Items: ON", "Spam Heavy Items: OFF")
		local intensity = math.clamp(tonumber(p2.lagBox and p2.lagBox.Text) or 15, 1, 35)
		task.spawn(function()
			while isLagging do
				local remotes = collectRemotes()
				local heavyItems = collectHeavyGameItems()
				local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
				local spreadList = collectFarSpreadCFrames(root)
				for burst = 1, intensity do
					if not isLagging then break end
					for _, remote in ipairs(remotes) do
						if not isLagging then break end
						local chosenCf = spreadList[((burst + _) % #spreadList) + 1]
						if #heavyItems > 0 then
							for idx = 1, math.min(#heavyItems, 6) do
								local item = heavyItems[((burst + idx - 2) % #heavyItems) + 1]
								fireRemoteSafe(remote, item, chosenCf)
							end
						else
							fireRemoteSafe(remote, "Vehicle", chosenCf)
							fireRemoteSafe(remote, "Truck", chosenCf)
							fireRemoteSafe(remote, "SpawnVehicle", chosenCf)
						end
						task.wait(0.03)
					end
					task.wait(0.1)
				end
				task.wait(0.25)
			end
		end)
	end)
end

if p2.antiLagClientBtn then
	p2.antiLagClientBtn.MouseButton1Click:Connect(function()
		local nextState = not p4a.getState().propFlingEnabled
		p4a.setPropFlingFlag(nextState)
		stylePill(p2.antiLagClientBtn, nextState, "Fling Props (" .. tostring(p4a.getPropRadius()) .. "): ON", "Fling Props: OFF")
		if nextState then
			local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if root then flingNearbyProps(root.Position) end
		end
	end)
end

if p2.pullCircleBtn then
	p2.pullCircleBtn.MouseButton1Click:Connect(function()
		local nextState = not p4a.getState().pullCircleEnabled
		p4a.setPullCircleFlag(nextState)
		stylePill(p2.pullCircleBtn, nextState, "Hút Vòng (" .. tostring(p4a.getPullRadius()) .. "): ON", "Hút Vòng Tròn: OFF")
	end)
end

if p2.resetBtn then
	p2.resetBtn.MouseButton1Click:Connect(function()
		isLagging = false
		p4a.setPropFlingFlag(false)
		p4a.setPullCircleFlag(false)
		p4a.setTarget(nil)
		refreshSelectionUI()
		setTpButtonState(false)
		if p4a.getState().stickEnabled then setStickState(false) end
		if flingEnabled then stopFling(true) end
		if getgenv().ThaiMionResetMain then getgenv().ThaiMionResetMain() end
		stylePill(p2.lagToggle, false, "Spam Heavy Items: ON", "Spam Heavy Items: OFF")
		stylePill(p2.antiLagClientBtn, false, "Fling Props: ON", "Fling Props: OFF")
		stylePill(p2.pullCircleBtn, false, "Hút Vòng Tròn: ON", "Hút Vòng Tròn: OFF")
	end)
end

RunService.Heartbeat:Connect(function(dt)
	local st = p4a.getState()
	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if st.propFlingEnabled and root then flingNearbyProps(root.Position) end
	if st.pullCircleEnabled and root then pullPropsIntoCircle(root.Position, dt) end
	if st.stickEnabled and st.selectedTarget and root then
		local mrChar = LocalPlayer.Character
		local tr = getTargetAnchor(st.selectedTarget)
		if mrChar and tr then
			setCharCombatMode(mrChar, true)
			local goalCf = getFrontCFrame(tr)
			if (root.Position - goalCf.Position).Magnitude <= 115 then
				placeCharAtCFrame(mrChar, root, goalCf)
			end
		end
	end
end)

print("[+] Part 4B/4 Loaded!")
