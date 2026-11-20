local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Liquid Glass palette: clear glass, high-contrast English labels, low eye-strain
local THEME = {
	GlassMain = Color3.fromRGB(11, 17, 29),
	GlassMainAlpha = 0.36,
	GlassCard = Color3.fromRGB(20, 31, 50),
	GlassCardAlpha = 0.36,
	GlassHover = Color3.fromRGB(30, 46, 74),
	GlassHoverAlpha = 0.28,
	AccentCyan = Color3.fromRGB(0, 214, 255),
	AccentBlue = Color3.fromRGB(64, 156, 255),
	AccentGreen = Color3.fromRGB(46, 224, 152),
	AccentRed = Color3.fromRGB(235, 78, 92),
	StrokeSoft = Color3.fromRGB(125, 226, 255),
	StrokeAlpha = 0.48,
	TextBright = Color3.fromRGB(244, 249, 255),
	TextMuted = Color3.fromRGB(196, 212, 234),
	TextDark = Color3.fromRGB(10, 16, 28),
}

local function getGuiParent()
	local ok, res = pcall(function()
		return CoreGui
	end)
	if ok and res then
		return res
	end
	local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
	return playerGui
end

local PGui = getGuiParent()
if not PGui then
	return
end

-- Remove old GUI instances if re-executed
for _, name in ipairs({ "ThaiMionElite_LiquidGlass", "ThaiMionElite_BannerGui" }) do
	local old = PGui:FindFirstChild(name)
	if old then
		pcall(function()
			old:Destroy()
		end)
	end
end

local function addCorner(inst, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = inst
	return c
end

local function addStroke(inst, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or THEME.StrokeSoft
	s.Thickness = thickness or 1.2
	s.Transparency = transparency or THEME.StrokeAlpha
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = inst
	return s
end

local function makeDraggable(dragHandle, targetFrame)
	local dragging = false
	local dragInput = nil
	local dragStart = nil
	local startPos = nil

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType.Touch == input.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = targetFrame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType.Touch == input.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			targetFrame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThaiMionElite_LiquidGlass"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PGui

local BannerGui = Instance.new("ScreenGui")
BannerGui.Name = "ThaiMionElite_BannerGui"
BannerGui.ResetOnSpawn = false
BannerGui.DisplayOrder = 50
BannerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BannerGui.Parent = PGui

local function showSuccessBanner(titleText, subText)
	local banner = Instance.new("Frame")
	banner.Size = UDim2.new(0, 310, 0, 52)
	banner.Position = UDim2.new(0.5, -155, 0, -70)
	banner.BackgroundColor3 = THEME.GlassMain
	banner.BackgroundTransparency = 0.25
	banner.BorderSizePixel = 0
	banner.Parent = BannerGui
	addCorner(banner, 12)
	addStroke(banner, THEME.AccentGreen, 1.3, 0.25)

	local accentBar = Instance.new("Frame")
	accentBar.Size = UDim2.new(0, 4, 0.68, 0)
	accentBar.Position = UDim2.new(0, 10, 0.16, 0)
	accentBar.BackgroundColor3 = THEME.AccentGreen
	accentBar.BorderSizePixel = 0
	accentBar.Parent = banner
	addCorner(accentBar, 4)

	local mainLbl = Instance.new("TextLabel")
	mainLbl.Size = UDim2.new(1, -28, 0, 22)
	mainLbl.Position = UDim2.new(0, 22, 0, 6)
	mainLbl.BackgroundTransparency = 1
	mainLbl.Text = titleText or "Loaded Successfully"
	mainLbl.TextColor3 = THEME.TextBright
	mainLbl.TextSize = 14
	mainLbl.Font = Enum.Font.GothamBold
	mainLbl.TextXAlignment = Enum.TextXAlignment.Left
	mainLbl.Parent = banner

	local subLbl = Instance.new("TextLabel")
	subLbl.Size = UDim2.new(1, -28, 0, 16)
	subLbl.Position = UDim2.new(0, 22, 0, 28)
	subLbl.BackgroundTransparency = 1
	subLbl.Text = subText or "THAIMION ELITE is ready"
	subLbl.TextColor3 = THEME.TextMuted
	subLbl.TextSize = 11
	subLbl.Font = Enum.Font.GothamMedium
	subLbl.TextXAlignment = Enum.TextXAlignment.Left
	subLbl.Parent = banner

	local slideIn = TweenService:Create(banner, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, -155, 0, 14)
	})
	slideIn:Play()
	slideIn.Completed:Wait()

	task.wait(2.2)

	local slideOut = TweenService:Create(banner, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, -155, 0, -70)
	})
	slideOut:Play()
	slideOut.Completed:Wait()
	banner:Destroy()
end

-- Main Glass Window (hidden until loader finishes 100%)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 450, 0, 315)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -157)
MainFrame.BackgroundColor3 = THEME.GlassMain
MainFrame.BackgroundTransparency = THEME.GlassMainAlpha
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
addCorner(MainFrame, 14)
addStroke(MainFrame, THEME.StrokeSoft, 1.35, THEME.StrokeAlpha)

-- Top subtle glass sheen strip
local sheenStrip = Instance.new("Frame")
sheenStrip.Size = UDim2.new(1, -24, 0, 1)
sheenStrip.Position = UDim2.new(0, 12, 0, 1)
sheenStrip.BackgroundColor3 = THEME.TextBright
sheenStrip.BackgroundTransparency = 0.72
sheenStrip.BorderSizePixel = 0
sheenStrip.Parent = MainFrame

-- Title Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame
makeDraggable(TopBar, MainFrame)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -110, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "THAIMION ELITE"
TitleLabel.TextColor3 = THEME.TextBright
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TopBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 28, 0, 24)
MinBtn.Position = UDim2.new(1, -68, 0.5, -12)
MinBtn.BackgroundColor3 = THEME.GlassCard
MinBtn.BackgroundTransparency = 0.35
MinBtn.Text = "-"
MinBtn.TextColor3 = THEME.TextBright
MinBtn.TextSize = 15
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = TopBar
addCorner(MinBtn, 6)
addStroke(MinBtn, THEME.StrokeSoft, 1, 0.55)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 24)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -12)
CloseBtn.BackgroundColor3 = THEME.AccentRed
CloseBtn.BackgroundTransparency = 0.25
CloseBtn.Text = "X"
CloseBtn.TextColor3 = THEME.TextBright
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = TopBar
addCorner(CloseBtn, 6)
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -24, 0, 32)
TabBar.Position = UDim2.new(0, 12, 0, 42)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TabLayout.Padding = UDim.new(0, 10)
TabLayout.Parent = TabBar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -24, 1, -84)
ContentArea.Position = UDim2.new(0, 12, 0, 78)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local pages = {}
local tabButtons = {}

local function createPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name .. "Page"
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.ScrollBarThickness = 3
	page.ScrollBarImageColor3 = THEME.AccentCyan
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.Visible = false
	page.Parent = ContentArea

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 7)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = page

	pages[name] = page
	return page
end

local function createTabButton(name, order)
	local btn = Instance.new("TextButton")
	btn.Name = name .. "Tab"
	btn.LayoutOrder = order
	btn.Size = UDim2.new(0.31, 0, 1, 0)
	btn.BackgroundColor3 = THEME.GlassCard
	btn.BackgroundTransparency = THEME.GlassCardAlpha
	btn.Text = name
	btn.TextColor3 = THEME.TextMuted
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	btn.Parent = TabBar
	addCorner(btn, 8)
	addStroke(btn, THEME.StrokeSoft, 1, 0.55)
	tabButtons[name] = btn
	return btn
end

local function selectTab(name)
	for k, p in pairs(pages) do
		p.Visible = (k == name)
	end
	for k, b in pairs(tabButtons) do
		local active = (k == name)
		b.BackgroundColor3 = active and THEME.AccentBlue or THEME.GlassCard
		b.BackgroundTransparency = active and 0.22 or THEME.GlassCardAlpha
		b.TextColor3 = active and THEME.TextBright or THEME.TextMuted
	end
end

for idx, tabName in ipairs({ "Main", "Teleport", "Lag Tool TM" }) do
	createPage(tabName)
	local b = createTabButton(tabName, idx)
	b.MouseButton1Click:Connect(function()
		selectTab(tabName)
	end)
end

local function makeToggleRow(parent, labelPrefix, initialState, onToggle)
	local state = initialState and true or false
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.BackgroundColor3 = state and THEME.AccentBlue or THEME.GlassCard
	btn.BackgroundTransparency = state and 0.26 or THEME.GlassCardAlpha
	btn.TextColor3 = state and THEME.TextBright or THEME.TextMuted
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamBold
	btn.Parent = parent
	addCorner(btn, 8)
	addStroke(btn, THEME.StrokeSoft, 1, state and 0.25 or 0.5)

	local function refresh()
		btn.Text = labelPrefix .. ": " .. (state and "ON" or "OFF")
		btn.BackgroundColor3 = state and THEME.AccentBlue or THEME.GlassCard
		btn.BackgroundTransparency = state and 0.26 or THEME.GlassCardAlpha
		btn.TextColor3 = state and THEME.TextBright or THEME.TextMuted
	end
	refresh()

	btn.MouseButton1Click:Connect(function()
		state = not state
		refresh()
		if onToggle then
			onToggle(state)
		end
	end)

	return btn, function(val)
		state = val and true or false
		refresh()
	end
end

local function makeSliderCard(parent, titlePrefix, minVal, maxVal, defaultVal, unitSuffix, onChanged)
	local currentVal = math.clamp(defaultVal, minVal, maxVal)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 44)
	card.BackgroundColor3 = THEME.GlassCard
	card.BackgroundTransparency = THEME.GlassCardAlpha
	card.Parent = parent
	addCorner(card, 8)
	addStroke(card, THEME.StrokeSoft, 1, 0.52)

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1, -16, 0, 18)
	titleLbl.Position = UDim2.new(0, 8, 0, 3)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = titlePrefix .. ": " .. tostring(currentVal) .. (unitSuffix or "")
	titleLbl.TextColor3 = THEME.TextBright
	titleLbl.TextSize = 11
	titleLbl.Font = Enum.Font.GothamMedium
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = card

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, -16, 0, 6)
	track.Position = UDim2.new(0, 8, 0, 28)
	track.BackgroundColor3 = THEME.GlassMain
	track.BackgroundTransparency = 0.25
	track.Parent = card
	addCorner(track, 3)

	local ratio = (currentVal - minVal) / math.max(1, (maxVal - minVal))
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(ratio, 0, 1, 0)
	fill.BackgroundColor3 = THEME.AccentCyan
	fill.Parent = track
	addCorner(fill, 3)

	local sliding = false
	local function updateFromX(posX)
		local r = math.clamp((posX - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
		currentVal = math.floor(minVal + r * (maxVal - minVal) + 0.5)
		fill.Size = UDim2.new((currentVal - minVal) / math.max(1, (maxVal - minVal)), 0, 1, 0)
		titleLbl.Text = titlePrefix .. ": " .. tostring(currentVal) .. (unitSuffix or "")
		if onChanged then
			onChanged(currentVal)
		end
	end

	track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType.Touch == input.UserInputType.Touch then
			sliding = true
			updateFromX(input.Position.X)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType.Touch == input.UserInputType.Touch) then
			updateFromX(input.Position.X)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType.Touch == input.UserInputType.Touch then
			sliding = false
		end
	end)
end

-- Populate Main tab
local speedValue = 50
local noclipEnabled = false
local antiFallEnabled = false

makeToggleRow(pages.Main, "Speed", false, function(on)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = on and speedValue or 16
	end
end)

makeSliderCard(pages.Main, "WalkSpeed Value", 16, 150, speedValue, "", function(v)
	speedValue = v
end)

makeToggleRow(pages.Main, "Noclip", false, function(on)
	noclipEnabled = on
end)

makeToggleRow(pages.Main, "Anti-Fall", false, function(on)
	antiFallEnabled = on
end)

makeToggleRow(pages.Main, "Aim Head (FOV)", false, nil)
makeToggleRow(pages.Main, "Wallbang", false, nil)
makeToggleRow(pages.Main, "ESP Rainbow & Name", false, nil)

-- Populate Teleport tab
makeToggleRow(pages.Teleport, "Activate TP Button", false, nil)
makeToggleRow(pages.Teleport, "Stick Front", false, nil)
makeToggleRow(pages.Teleport, "Fling Target", false, nil)

-- Populate Lag Tool TM tab (full English)
local flingRange = 65
local pullRange = 55
local setters = {}

local _, setSpam = makeToggleRow(pages["Lag Tool TM"], "Spam Heavy Remz", false, nil)
setters.spam = setSpam

makeSliderCard(pages["Lag Tool TM"], "Fling Range", 10, 200, flingRange, " studs", function(v)
	flingRange = v
end)

makeSliderCard(pages["Lag Tool TM"], "Pull Range", 10, 200, pullRange, " studs", function(v)
	pullRange = v
end)

local _, setProps = makeToggleRow(pages["Lag Tool TM"], "Fling Props", false, nil)
setters.props = setProps

local _, setOrbit = makeToggleRow(pages["Lag Tool TM"], "Pull Orbit", false, nil)
setters.orbit = setOrbit

local resetBtn = Instance.new("TextButton")
resetBtn.Size = UDim2.new(1, 0, 0, 32)
resetBtn.BackgroundColor3 = THEME.GlassCard
resetBtn.BackgroundTransparency = THEME.GlassCardAlpha
resetBtn.Text = "Restore / Reset State"
resetBtn.TextColor3 = THEME.AccentCyan
resetBtn.TextSize = 12
resetBtn.Font = Enum.Font.GothamBold
resetBtn.Parent = pages["Lag Tool TM"]
addCorner(resetBtn, 8)
addStroke(resetBtn, THEME.AccentCyan, 1, 0.45)

resetBtn.MouseButton1Click:Connect(function()
	for _, fn in pairs(setters) do
		fn(false)
	end
end)

RunService.Stepped:Connect(function()
	if noclipEnabled and LocalPlayer.Character then
		for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	TabBar.Visible = not minimized
	ContentArea.Visible = not minimized
	MainFrame.Size = minimized and UDim2.new(0, 450, 0, 42) or UDim2.new(0, 450, 0, 315)
end)

CloseBtn.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

selectTab("Main")
local LoaderOverlay = Instance.new("Frame")
LoaderOverlay.Name = "LoaderOverlay"
LoaderOverlay.Size = UDim2.new(0, 320, 0, 96)
LoaderOverlay.Position = UDim2.new(0.5, -160, 0.5, -48)
LoaderOverlay.BackgroundColor3 = THEME.GlassMain
LoaderOverlay.BackgroundTransparency = 0.25
LoaderOverlay.BorderSizePixel = 0
LoaderOverlay.Parent = ScreenGui
addCorner(LoaderOverlay, 12)
addStroke(LoaderOverlay, THEME.StrokeSoft, 1.3, 0.35)

local LoaderTitle = Instance.new("TextLabel")
LoaderTitle.Size = UDim2.new(1, -24, 0, 22)
LoaderTitle.Position = UDim2.new(0, 12, 0, 10)
LoaderTitle.BackgroundTransparency = 1
LoaderTitle.Text = "Loading THAIMION ELITE..."
LoaderTitle.TextColor3 = THEME.TextBright
LoaderTitle.TextSize = 13
LoaderTitle.Font = Enum.Font.GothamBold
LoaderTitle.TextXAlignment = Enum.TextXAlignment.Left
LoaderTitle.Parent = LoaderOverlay

local PercentText = Instance.new("TextLabel")
PercentText.Size = UDim2.new(0, 56, 0, 22)
PercentText.Position = UDim2.new(1, -68, 0, 10)
PercentText.BackgroundTransparency = 1
PercentText.Text = "0%"
PercentText.TextColor3 = THEME.AccentCyan
PercentText.TextSize = 13
PercentText.Font = Enum.Font.GothamBold
PercentText.TextXAlignment = Enum.TextXAlignment.Right
PercentText.Parent = LoaderOverlay

local BarBg = Instance.new("Frame")
BarBg.Size = UDim2.new(1, -24, 0, 10)
BarBg.Position = UDim2.new(0, 12, 0, 52)
BarBg.BackgroundColor3 = THEME.GlassCard
BarBg.BackgroundTransparency = 0.3
BarBg.Parent = LoaderOverlay
addCorner(BarBg, 5)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = THEME.AccentCyan
BarFill.Parent = BarBg
addCorner(BarFill, 5)

task.spawn(function()
	local tween = TweenService:Create(
		BarFill,
		TweenInfo.new(1.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{ Size = UDim2.new(1, 0, 1, 0) }
	)

	local stepConn = RunService.RenderStepped:Connect(function()
		local pct = math.clamp(math.floor(BarFill.Size.X.Scale * 100 + 0.5), 0, 100)
		PercentText.Text = tostring(pct) .. "%"
	end)

	tween:Play()
	tween.Completed:Wait()

	if stepConn then
		stepConn:Disconnect()
	end

	-- Lock at 100% briefly before hiding loader and showing banner
	BarFill.Size = UDim2.new(1, 0, 1, 0)
	PercentText.Text = "100%"
	task.wait(0.25)

	LoaderOverlay:Destroy()
	MainFrame.Visible = true
	task.wait(0.1)
	showSuccessBanner("Loaded Successfully", "THAIMION ELITE is ready")
end)
