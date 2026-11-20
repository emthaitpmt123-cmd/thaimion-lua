local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Stats = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

local THEME = {
	GlassMain = Color3.fromRGB(11, 17, 29),
	GlassMainAlpha = 0.36,
	GlassCard = Color3.fromRGB(20, 31, 50),
	GlassCardAlpha = 0.36,
	AccentCyan = Color3.fromRGB(0, 214, 255),
	AccentBlue = Color3.fromRGB(64, 156, 255),
	AccentGreen = Color3.fromRGB(46, 224, 152),
	AccentRed = Color3.fromRGB(235, 78, 92),
	StrokeSoft = Color3.fromRGB(125, 226, 255),
	StrokeAlpha = 0.48,
	TextBright = Color3.fromRGB(244, 249, 255),
	TextMuted = Color3.fromRGB(196, 212, 234),
}

local function getGuiParent()
	local ok, res = pcall(function()
		return CoreGui
	end)
	if ok and res then
		return res
	end
	return LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 10)
end

local PGui = getGuiParent()
if not PGui then
	return
end

for _, name in ipairs({
	"ThaiMionElite_LiquidGlass",
	"ThaiMionElite_BannerGui",
	"ThaiMionElite_TPFloatingGui",
	"ThaiMionElite_StatsGui",
	"ThaiMionElite_TracerGui",
}) do
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

local function isTouchOrLeftClick(input)
	local t = input.UserInputType
	return t == Enum.UserInputType.Touch or t == Enum.UserInputType.MouseButton1
end

local function isTouchOrMouseMove(input)
	local t = input.UserInputType
	return t == Enum.UserInputType.Touch or t == Enum.UserInputType.MouseMovement
end

local function attachFreeDrag(handle, target, onTapCallback)
	local activeInput = nil
	local originPointer = nil
	local originTargetPos = nil
	local movedDistance = 0

	local function lockToPixelPosition()
		local absPos = target.AbsolutePosition
		target.Position = UDim2.new(0, math.floor(absPos.X + 0.5), 0, math.floor(absPos.Y + 0.5))
	end

	handle.InputBegan:Connect(function(input)
		if activeInput == nil and isTouchOrLeftClick(input) then
			lockToPixelPosition()
			activeInput = input
			originPointer = Vector2.new(input.Position.X, input.Position.Y)
			originTargetPos = target.Position
			movedDistance = 0
		end
	end)

	local function stepMove(input)
		if activeInput ~= nil and input == activeInput and isTouchOrMouseMove(input) and originPointer and originTargetPos then
			local cur = Vector2.new(input.Position.X, input.Position.Y)
			local delta = cur - originPointer
			movedDistance = math.max(movedDistance, delta.Magnitude)
			target.Position = UDim2.new(
				0,
				math.floor(originTargetPos.X.Offset + delta.X + 0.5),
				0,
				math.floor(originTargetPos.Y.Offset + delta.Y + 0.5)
			)
		end
	end

	handle.InputChanged:Connect(stepMove)
	UserInputService.InputChanged:Connect(stepMove)
	UserInputService.TouchMoved:Connect(stepMove)

	local function stepEnd(input)
		if activeInput ~= nil and input == activeInput then
			local wasTap = (movedDistance < 8)
			activeInput = nil
			originPointer = nil
			originTargetPos = nil
			if wasTap and onTapCallback then
				onTapCallback()
			end
		end
	end

	handle.InputEnded:Connect(stepEnd)
	UserInputService.InputEnded:Connect(stepEnd)
	UserInputService.TouchEnded:Connect(stepEnd)
end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ThaiMionElite_LiquidGlass"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PGui

local BannerGui = Instance.new("ScreenGui")
BannerGui.Name = "ThaiMionElite_BannerGui"
BannerGui.ResetOnSpawn = false
BannerGui.IgnoreGuiInset = true
BannerGui.DisplayOrder = 50
BannerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
BannerGui.Parent = PGui

local StatsGui = Instance.new("ScreenGui")
StatsGui.Name = "ThaiMionElite_StatsGui"
StatsGui.ResetOnSpawn = false
StatsGui.IgnoreGuiInset = true
StatsGui.DisplayOrder = 45
StatsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
StatsGui.Parent = PGui

local TopStatsBar = Instance.new("Frame")
TopStatsBar.Name = "TopStatsBar"
TopStatsBar.Size = UDim2.new(0, 256, 0, 26)
TopStatsBar.Position = UDim2.new(0, 220, 0, 10)
TopStatsBar.BackgroundColor3 = THEME.GlassMain
TopStatsBar.BackgroundTransparency = 0.28
TopStatsBar.BorderSizePixel = 0
TopStatsBar.Active = true
TopStatsBar.Visible = false
TopStatsBar.Parent = StatsGui
addCorner(TopStatsBar, 8)
addStroke(TopStatsBar, THEME.AccentCyan, 1.15, 0.35)
attachFreeDrag(TopStatsBar, TopStatsBar)

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -12, 1, 0)
StatsLabel.Position = UDim2.new(0, 6, 0, 0)
StatsLabel.BackgroundTransparency = 1
StatsLabel.Text = "FPS: 60  |  Ping: 35ms  |  Mem: 512MB"
StatsLabel.TextColor3 = THEME.TextBright
StatsLabel.TextSize = 10.5
StatsLabel.Font = Enum.Font.GothamBold
StatsLabel.TextXAlignment = Enum.TextXAlignment.Center
StatsLabel.TextTruncate = Enum.TextTruncate.AtEnd
StatsLabel.Parent = TopStatsBar

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
		Position = UDim2.new(0.5, -155, 0, 40)
	})
	slideIn:Play()
	slideIn.Completed:Wait()

	task.wait(1.8)

	local slideOut = TweenService:Create(banner, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, -155, 0, -70)
	})
	slideOut:Play()
	slideOut.Completed:Wait()
	banner:Destroy()
end

local FULL_SIZE = UDim2.new(0, 450, 0, 315)
local MINI_SIZE = UDim2.new(0, 225, 0, 38)

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = FULL_SIZE
MainFrame.Position = UDim2.new(0, 140, 0, 52)
MainFrame.BackgroundColor3 = THEME.GlassMain
MainFrame.BackgroundTransparency = THEME.GlassMainAlpha
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
addCorner(MainFrame, 14)
addStroke(MainFrame, THEME.StrokeSoft, 1.35, THEME.StrokeAlpha)

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, -66, 0, 38)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundTransparency = 1
TopBar.Active = true
TopBar.Parent = MainFrame
attachFreeDrag(TopBar, MainFrame)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -12, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "THAIMION ELITE"
TitleLabel.TextColor3 = THEME.TextBright
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
TitleLabel.Parent = TopBar

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 26, 0, 22)
MinBtn.Position = UDim2.new(1, -62, 0, 8)
MinBtn.BackgroundColor3 = THEME.GlassCard
MinBtn.BackgroundTransparency = 0.3
MinBtn.Text = "-"
MinBtn.TextColor3 = THEME.TextBright
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Parent = MainFrame
addCorner(MinBtn, 6)
addStroke(MinBtn, THEME.StrokeSoft, 1, 0.5)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 22)
CloseBtn.Position = UDim2.new(1, -32, 0, 8)
CloseBtn.BackgroundColor3 = THEME.AccentRed
CloseBtn.BackgroundTransparency = 0.25
CloseBtn.Text = "X"
CloseBtn.TextColor3 = THEME.TextBright
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = MainFrame
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
	page.ScrollingEnabled = true
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
	b.Activated:Connect(function()
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

	btn.Activated:Connect(function()
		state = not state
		refresh()
		if onToggle then
			onToggle(state)
		end
	end)

	return btn, function(val)
		state = val and true or false
		refresh()
		if onToggle then
			onToggle(state)
		end
	end
end

local function getParentScrollPage(inst)
	local cur = inst.Parent
	while cur do
		if cur:IsA("ScrollingFrame") then
			return cur
		end
		cur = cur.Parent
	end
	return nil
end

local function makeSliderCard(parent, titlePrefix, minVal, maxVal, defaultVal, unitSuffix, onChanged)
	local currentVal = math.clamp(defaultVal, minVal, maxVal)
	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, 48)
	card.BackgroundColor3 = THEME.GlassCard
	card.BackgroundTransparency = THEME.GlassCardAlpha
	card.Active = true
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

	local hitBox = Instance.new("TextButton")
	hitBox.Size = UDim2.new(1, -16, 0, 28)
	hitBox.Position = UDim2.new(0, 8, 0, 19)
	hitBox.BackgroundTransparency = 1
	hitBox.Text = ""
	hitBox.AutoButtonColor = false
	hitBox.Active = true
	hitBox.Parent = card

	local track = Instance.new("Frame")
	track.Size = UDim2.new(1, 0, 0, 8)
	track.Position = UDim2.new(0, 0, 0.5, -4)
	track.BackgroundColor3 = THEME.GlassMain
	track.BackgroundTransparency = 0.25
	track.Parent = hitBox
	addCorner(track, 4)

	local ratio = (currentVal - minVal) / math.max(1, (maxVal - minVal))
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(ratio, 0, 1, 0)
	fill.BackgroundColor3 = THEME.AccentCyan
	fill.Parent = track
	addCorner(fill, 4)

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Position = UDim2.new(ratio, 0, 0.5, 0)
	knob.BackgroundColor3 = THEME.TextBright
	knob.Parent = track
	addCorner(knob, 8)
	addStroke(knob, THEME.AccentCyan, 1.5, 0.1)

	local activeSlideInput = nil
	local parentScroll = getParentScrollPage(card)

	local function setSliderByX(posX)
		local absPos = track.AbsolutePosition.X
		local absSize = math.max(1, track.AbsoluteSize.X)
		local r = math.clamp((posX - absPos) / absSize, 0, 1)
		local nextVal = math.floor(minVal + r * (maxVal - minVal) + 0.5)
		local newRatio = (nextVal - minVal) / math.max(1, (maxVal - minVal))
		fill.Size = UDim2.new(newRatio, 0, 1, 0)
		knob.Position = UDim2.new(newRatio, 0, 0.5, 0)
		titleLbl.Text = titlePrefix .. ": " .. tostring(nextVal) .. (unitSuffix or "")
		if nextVal ~= currentVal then
			currentVal = nextVal
			if onChanged then
				onChanged(currentVal)
			end
		end
	end

	hitBox.InputBegan:Connect(function(input)
		if activeSlideInput == nil and isTouchOrLeftClick(input) then
			activeSlideInput = input
			if parentScroll then
				parentScroll.ScrollingEnabled = false
			end
			setSliderByX(input.Position.X)
		end
	end)

	local function onSlideMove(input)
		if activeSlideInput ~= nil and input == activeSlideInput and isTouchOrMouseMove(input) then
			setSliderByX(input.Position.X)
		end
	end

	hitBox.InputChanged:Connect(onSlideMove)
	UserInputService.InputChanged:Connect(onSlideMove)
	UserInputService.TouchMoved:Connect(onSlideMove)

	local function onSlideEnd(input)
		if activeSlideInput ~= nil and input == activeSlideInput then
			setSliderByX(input.Position.X)
			activeSlideInput = nil
			if parentScroll then
				parentScroll.ScrollingEnabled = true
			end
		end
	end

	hitBox.InputEnded:Connect(onSlideEnd)
	UserInputService.InputEnded:Connect(onSlideEnd)
	UserInputService.TouchEnded:Connect(onSlideEnd)
end
local speedEnabled = false
local speedValue = 50
local noclipEnabled = false
local antiFallEnabled = false
local aimHeadEnabled = false
local aimFov = 140
local wallbangEnabled = false
local espEnabled = false

local selectedTarget = nil
local tpButtonActive = false
local stickFrontEnabled = false
local flingTargetEnabled = false

local spamHeavyEnabled = false
local pullRange = 55
local pullOrbitEnabled = false

local setters = {}
local espObjects = {}
local flingSpinAngle = 0

local function clearEspForPlayer(plr)
	local data = espObjects[plr]
	if data then
		if data.highlight then pcall(function() data.highlight:Destroy() end) end
		if data.billboard then pcall(function() data.billboard:Destroy() end) end
		espObjects[plr] = nil
	end
end

local function clearAllEsp()
	for plr in pairs(espObjects) do
		clearEspForPlayer(plr)
	end
end

local TracerGui = Instance.new("ScreenGui")
TracerGui.Name = "ThaiMionElite_TracerGui"
TracerGui.ResetOnSpawn = false
TracerGui.IgnoreGuiInset = true
TracerGui.DisplayOrder = 30
TracerGui.Parent = PGui

local fovRingFrame = Instance.new("Frame")
fovRingFrame.Name = "FovRing"
fovRingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovRingFrame.Size = UDim2.new(0, aimFov * 2, 0, aimFov * 2)
fovRingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
fovRingFrame.BackgroundTransparency = 1
fovRingFrame.Visible = false
fovRingFrame.Parent = TracerGui
addCorner(fovRingFrame, 999)
addStroke(fovRingFrame, THEME.AccentGreen, 1.6, 0.15)

local FloatingTPGui = Instance.new("ScreenGui")
FloatingTPGui.Name = "ThaiMionElite_TPFloatingGui"
FloatingTPGui.ResetOnSpawn = false
FloatingTPGui.IgnoreGuiInset = true
FloatingTPGui.DisplayOrder = 40
FloatingTPGui.Parent = PGui

local function teleportAlongScreenCenter()
	local cam = Workspace.CurrentCamera
	if not cam then return end
	local myChar = LocalPlayer.Character
	local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso") or myChar:FindFirstChild("UpperTorso"))
	local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
	if not myChar or not myRoot then return end

	local viewportCenter = Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5)
	local unitRay = cam:ViewportPointToRay(viewportCenter.X, viewportCenter.Y)

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { myChar }

	local farDist = 1000
	local result = Workspace:Raycast(unitRay.Origin, unitRay.Direction * farDist, params)
	local destPos = result and (result.Position + Vector3.new(0, 2.2, 0)) or (unitRay.Origin + unitRay.Direction * farDist)

	local flatLook = Vector3.new(unitRay.Direction.X, 0, unitRay.Direction.Z)
	local finalCFrame = (flatLook.Magnitude > 0.001)
		and CFrame.lookAt(destPos, destPos + flatLook)
		or CFrame.new(destPos)

	if myHum then
		myHum.Sit = false
		myHum.PlatformStand = false
	end
	myRoot.AssemblyLinearVelocity = Vector3.zero
	myRoot.AssemblyAngularVelocity = Vector3.zero
	myRoot.CFrame = finalCFrame
	pcall(function()
		myChar:PivotTo(finalCFrame)
	end)
end

local QuickTPBtn = Instance.new("TextButton")
QuickTPBtn.Size = UDim2.new(0, 126, 0, 38)
QuickTPBtn.Position = UDim2.new(0, 560, 0, 440)
QuickTPBtn.BackgroundColor3 = THEME.AccentCyan
QuickTPBtn.BackgroundTransparency = 0.2
QuickTPBtn.Text = "TP TM"
QuickTPBtn.TextColor3 = THEME.TextBright
QuickTPBtn.TextSize = 13
QuickTPBtn.Font = Enum.Font.GothamBold
QuickTPBtn.AutoButtonColor = false
QuickTPBtn.Active = true
QuickTPBtn.ZIndex = 20
QuickTPBtn.Visible = false
QuickTPBtn.Parent = FloatingTPGui
addCorner(QuickTPBtn, 10)
addStroke(QuickTPBtn, THEME.TextBright, 1.2, 0.35)
attachFreeDrag(QuickTPBtn, QuickTPBtn, teleportAlongScreenCenter)

local function getTargetHeadOrRoot(plr)
	if not plr or not plr.Parent then
		return nil, nil
	end
	local char = plr.Character
	if not char then
		return nil, nil
	end
	local head = char:FindFirstChild("Head")
	local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChildWhichIsA("BasePart")
	return head, root
end

local _, setSpeed = makeToggleRow(pages.Main, "Speed", false, function(on)
	speedEnabled = on
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = on and speedValue or 16
	end
end)
setters.speed = setSpeed

makeSliderCard(pages.Main, "WalkSpeed Value", 16, 150, speedValue, "", function(v)
	speedValue = v
	if speedEnabled then
		local char = LocalPlayer.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = speedValue
		end
	end
end)

local _, setNoclip = makeToggleRow(pages.Main, "Noclip", false, function(on)
	noclipEnabled = on
end)
setters.noclip = setNoclip

local _, setAntiFall = makeToggleRow(pages.Main, "Anti-Fall", false, function(on)
	antiFallEnabled = on
end)
setters.antiFall = setAntiFall

local _, setAimHead = makeToggleRow(pages.Main, "Aim Head (FOV)", false, function(on)
	aimHeadEnabled = on
	fovRingFrame.Visible = on
end)
setters.aimHead = setAimHead

makeSliderCard(pages.Main, "Aim FOV Radius", 40, 350, aimFov, " px", function(v)
	aimFov = v
	fovRingFrame.Size = UDim2.new(0, aimFov * 2, 0, aimFov * 2)
end)

local _, setWallbang = makeToggleRow(pages.Main, "Wallbang", false, function(on)
	wallbangEnabled = on
end)
setters.wallbang = setWallbang

local _, setEsp = makeToggleRow(pages.Main, "ESP Rainbow & Name", false, function(on)
	espEnabled = on
	if not on then
		clearAllEsp()
	end
end)
setters.esp = setEsp

local _, setTpBtn = makeToggleRow(pages.Teleport, "Activate TP Button", false, function(on)
	tpButtonActive = on
	QuickTPBtn.Visible = on
end)
setters.tpBtn = setTpBtn

local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(1, 0, 0, 112)
playerListFrame.BackgroundColor3 = THEME.GlassCard
playerListFrame.BackgroundTransparency = THEME.GlassCardAlpha
playerListFrame.ScrollBarThickness = 3
playerListFrame.ScrollBarImageColor3 = THEME.AccentCyan
playerListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
playerListFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerListFrame.Parent = pages.Teleport
addCorner(playerListFrame, 8)
addStroke(playerListFrame, THEME.StrokeSoft, 1, 0.5)

local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 4)
playerListLayout.Parent = playerListFrame

local playerRowButtons = {}

local function updatePlayerRowVisuals()
	for plr, row in pairs(playerRowButtons) do
		if plr and plr.Parent and row and row.Parent then
			local isSel = (selectedTarget == plr)
			row.BackgroundColor3 = isSel and THEME.AccentGreen or THEME.GlassMain
			row.BackgroundTransparency = isSel and 0.25 or 0.35
			row.Text = (isSel and "[x] " or "[ ] ") .. plr.Name
		end
	end
end

local function rebuildPlayerList()
	for plr, row in pairs(playerRowButtons) do
		if row then
			pcall(function() row:Destroy() end)
		end
		playerRowButtons[plr] = nil
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local row = Instance.new("TextButton")
			row.Size = UDim2.new(1, -6, 0, 26)
			row.BackgroundColor3 = THEME.GlassMain
			row.BackgroundTransparency = 0.35
			row.Text = "[ ] " .. plr.Name
			row.TextColor3 = THEME.TextBright
			row.TextSize = 11
			row.Font = Enum.Font.GothamMedium
			row.TextXAlignment = Enum.TextXAlignment.Left
			row.Active = true
			row.Parent = playerListFrame
			addCorner(row, 6)

			row.MouseButton1Click:Connect(function()
				selectedTarget = plr
				updatePlayerRowVisuals()
			end)
			playerRowButtons[plr] = row
		end
	end
	updatePlayerRowVisuals()
end

rebuildPlayerList()
Players.PlayerAdded:Connect(rebuildPlayerList)
Players.PlayerRemoving:Connect(function(plr)
	clearEspForPlayer(plr)
	if selectedTarget == plr then
		selectedTarget = nil
	end
	rebuildPlayerList()
end)

local _, setStickFront = makeToggleRow(pages.Teleport, "Stick Front", false, function(on)
	stickFrontEnabled = on
end)
setters.stickFront = setStickFront

local _, setFlingTarget = makeToggleRow(pages.Teleport, "Fling Target", false, function(on)
	flingTargetEnabled = on
end)
setters.flingTarget = setFlingTarget

local _, setSpam = makeToggleRow(pages["Lag Tool TM"], "Spam Heavy Remz", false, function(on)
	spamHeavyEnabled = on
end)
setters.spam = setSpam

makeSliderCard(pages["Lag Tool TM"], "Pull Range", 10, 200, pullRange, " studs", function(v)
	pullRange = v
end)

local _, setOrbit = makeToggleRow(pages["Lag Tool TM"], "Pull Orbit", false, function(on)
	pullOrbitEnabled = on
end)
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

resetBtn.Activated:Connect(function()
	for _, fn in pairs(setters) do
		fn(false)
	end
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.WalkSpeed = 16
	end
end)
local function getBestTargetInFov()
	local cam = Workspace.CurrentCamera
	if not cam then return nil end
	local center = Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5)
	local bestHead = nil
	local bestDist = aimFov

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character then
			local head = plr.Character:FindFirstChild("Head")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if head and hum and hum.Health > 0 then
				local screenPos, onScreen = cam:WorldToViewportPoint(head.Position)
				if onScreen and screenPos.Z > 0 then
					local pt = Vector2.new(screenPos.X, screenPos.Y)
					local d = (pt - center).Magnitude
					if d <= bestDist then
						if not wallbangEnabled then
							local params = RaycastParams.new()
							params.FilterType = Enum.RaycastFilterType.Exclude
							params.FilterDescendantsInstances = { LocalPlayer.Character, plr.Character }
							local hit = Workspace:Raycast(cam.CFrame.Position, head.Position - cam.CFrame.Position, params)
							if hit then
								continue
							end
						end
						bestDist = d
						bestHead = head
					end
				end
			end
		end
	end
	return bestHead
end

local cachedProps = {}
local lastPropScan = 0
local lastRemoteScan = 0
local cachedRemotes = {}
local spamPulseTimer = 0
local orbitAngle = 0
local fpsCounter = 0
local fpsTimer = 0

local function isPartInAnyCharacter(part)
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character and part:IsDescendantOf(plr.Character) then
			return true
		end
	end
	return false
end

local function refreshPropCache(char)
	local list = {}
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("BasePart") and not obj.Anchored and not obj:IsDescendantOf(char) then
			if not isPartInAnyCharacter(obj) then
				table.insert(list, obj)
				if #list >= 140 then
					break
				end
			end
		end
	end
	cachedProps = list
end

local function refreshSpamRemotes()
	local list = {}
	local keywords = { "heavy", "remz", "skill", "atk", "attack", "hit", "damage", "swing", "punch", "shoot", "fire", "use" }
	for _, desc in ipairs(game:GetDescendants()) do
		if desc:IsA("RemoteEvent") or desc:IsA("RemoteFunction") then
			local lowerName = string.lower(desc.Name)
			for _, kw in ipairs(keywords) do
				if string.find(lowerName, kw, 1, true) then
					table.insert(list, desc)
					break
				end
			end
			if #list >= 40 then
				break
			end
		end
	end
	cachedRemotes = list
end

local function getPingMs()
	local pingVal = 0
	pcall(function()
		local net = Stats and Stats:FindFirstChild("Network")
		local item = net and net:FindFirstChild("ServerStatsItem") and net.ServerStatsItem:FindFirstChild("Data Ping")
		if item then
			pingVal = math.max(0, math.floor(item:GetValue() + 0.5))
		end
	end)
	return pingVal
end

local function getMemoryMb()
	local memMb = 0
	pcall(function()
		if Stats and Stats.GetTotalMemoryUsageMb then
			memMb = math.max(0, math.floor(Stats:GetTotalMemoryUsageMb() + 0.5))
		end
	end)
	return memMb
end

RunService.Stepped:Connect(function()
	if (noclipEnabled or flingTargetEnabled) and LocalPlayer.Character then
		for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

RunService.Heartbeat:Connect(function(dt)
	local now = tick()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))

	if hum and speedEnabled and hum.WalkSpeed ~= speedValue then
		hum.WalkSpeed = speedValue
	end

	if antiFallEnabled and root and root.AssemblyLinearVelocity.Y < -85 then
		root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -35, root.AssemblyLinearVelocity.Z)
	end

	if stickFrontEnabled and selectedTarget and char and root then
		local tHead, tRoot = getTargetHeadOrRoot(selectedTarget)
		local anchorPart = tHead or tRoot
		if anchorPart then
			local facePos = anchorPart.Position + anchorPart.CFrame.LookVector * 3.0
			local stickCF = CFrame.lookAt(facePos, Vector3.new(anchorPart.Position.X, facePos.Y, anchorPart.Position.Z))
			if hum then
				hum.Sit = false
				hum.PlatformStand = false
			end
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
			root.CFrame = stickCF
			pcall(function()
				char:PivotTo(stickCF)
			end)
		end
	end

	if flingTargetEnabled and selectedTarget and char and root then
		local _, tRoot = getTargetHeadOrRoot(selectedTarget)
		if tRoot then
			flingSpinAngle += dt * 45
			local contactOffset = Vector3.new(math.cos(flingSpinAngle) * 1.4, 0, math.sin(flingSpinAngle) * 1.4)
			local targetPos = tRoot.Position + contactOffset
			local flingCF = CFrame.new(targetPos) * CFrame.Angles(0, flingSpinAngle, math.rad(35))
			if hum then
				hum.Sit = false
			end
			root.CFrame = flingCF
			pcall(function()
				char:PivotTo(flingCF)
			end)
			local pushOut = (tRoot.Position - root.Position)
			if pushOut.Magnitude < 0.25 then
				pushOut = Vector3.new(math.cos(flingSpinAngle), 0.6, math.sin(flingSpinAngle))
			else
				pushOut = (pushOut.Unit + Vector3.new(0, 0.55, 0)).Unit
			end
			root.AssemblyLinearVelocity = pushOut * 145
			root.AssemblyAngularVelocity = Vector3.new(260, 420, 260)
		end
	end

	if pullOrbitEnabled and root and char then
		if now - lastPropScan >= 0.45 then
			lastPropScan = now
			refreshPropCache(char)
		end

		orbitAngle += dt * 4.5
		local handled = 0
		for i = #cachedProps, 1, -1 do
			local obj = cachedProps[i]
			if not obj or not obj.Parent or obj.Anchored then
				table.remove(cachedProps, i)
			else
				local dist = (obj.Position - root.Position).Magnitude
				if dist <= pullRange then
					pcall(function()
						obj:SetNetworkOwner(LocalPlayer)
					end)
					local offset = Vector3.new(math.cos(orbitAngle) * 8, 2.5, math.sin(orbitAngle) * 8)
					obj.AssemblyLinearVelocity = ((root.Position + offset) - obj.Position) * 12
					handled += 1
				end
				if handled >= 45 then
					break
				end
			end
		end
	end

	if spamHeavyEnabled then
		if now - lastRemoteScan >= 2.0 then
			lastRemoteScan = now
			refreshSpamRemotes()
		end
		spamPulseTimer += dt
		if spamPulseTimer >= 0.08 then
			spamPulseTimer = 0
			for _, remote in ipairs(cachedRemotes) do
				if remote and remote.Parent then
					if remote:IsA("RemoteEvent") then
						pcall(function()
							remote:FireServer()
						end)
					elseif remote:IsA("RemoteFunction") then
						task.spawn(function()
							pcall(function()
								remote:InvokeServer()
							end)
						end)
					end
				end
			end
		end
	end
end)

RunService.RenderStepped:Connect(function(dt)
	fpsCounter += 1
	fpsTimer += dt
	if fpsTimer >= 0.5 then
		local fpsNow = math.max(1, math.floor(fpsCounter / fpsTimer + 0.5))
		local pingNow = getPingMs()
		local memNow = getMemoryMb()
		StatsLabel.Text = string.format("FPS: %d  |  Ping: %dms  |  Mem: %dMB", fpsNow, pingNow, memNow)
		fpsCounter = 0
		fpsTimer = 0
	end

	local cam = Workspace.CurrentCamera
	local center = cam and Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5) or Vector2.zero

	fovRingFrame.Visible = aimHeadEnabled
	fovRingFrame.Size = UDim2.new(0, aimFov * 2, 0, aimFov * 2)
	fovRingFrame.Position = UDim2.new(0, center.X, 0, center.Y)

	if aimHeadEnabled and cam then
		local head = getBestTargetInFov()
		if head then
			cam.CFrame = CFrame.lookAt(cam.CFrame.Position, head.Position)
		end
	end

	if espEnabled then
		local hue = (tick() * 0.25) % 1
		local rainbowColor = Color3.fromHSV(hue, 0.85, 1)

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character then
				local head = plr.Character:FindFirstChild("Head")
				local hum = plr.Character:FindFirstChildOfClass("Humanoid")
				if head and hum and hum.Health > 0 then
					local data = espObjects[plr]
					if not data then
						local hl = Instance.new("Highlight")
						hl.FillTransparency = 0.7
						hl.OutlineTransparency = 0
						hl.Parent = plr.Character

						local bb = Instance.new("BillboardGui")
						bb.Size = UDim2.new(0, 140, 0, 24)
						bb.StudsOffset = Vector3.new(0, 2.4, 0)
						bb.AlwaysOnTop = true
						bb.Parent = head

						local lbl = Instance.new("TextLabel")
						lbl.Size = UDim2.new(1, 0, 1, 0)
						lbl.BackgroundTransparency = 1
						lbl.Font = Enum.Font.GothamBold
						lbl.TextSize = 12
						lbl.TextStrokeTransparency = 0.2
						lbl.Parent = bb

						data = { highlight = hl, billboard = bb, label = lbl }
						espObjects[plr] = data
					end

					data.highlight.FillColor = rainbowColor
					data.highlight.OutlineColor = rainbowColor
					data.label.TextColor3 = rainbowColor
					local distStuds = 0
					if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
						distStuds = math.floor((head.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
					end
					data.label.Text = plr.Name .. " [" .. tostring(distStuds) .. "m]"
				else
					clearEspForPlayer(plr)
				end
			end
		end
	end
end)

local minimized = false
MinBtn.Activated:Connect(function()
	minimized = not minimized
	TabBar.Visible = not minimized
	ContentArea.Visible = not minimized
	MainFrame.ClipsDescendants = minimized
	MainFrame.Size = minimized and MINI_SIZE or FULL_SIZE
	MinBtn.Text = minimized and "+" or "-"
end)

CloseBtn.Activated:Connect(function()
	clearAllEsp()
	if FloatingTPGui then
		pcall(function() FloatingTPGui:Destroy() end)
	end
	if StatsGui then
		pcall(function() StatsGui:Destroy() end)
	end
	if TracerGui then
		pcall(function() TracerGui:Destroy() end)
	end
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

	BarFill.Size = UDim2.new(1, 0, 1, 0)
	PercentText.Text = "100%"
	task.wait(0.25)

	LoaderOverlay:Destroy()
	MainFrame.Visible = true
	TopStatsBar.Visible = true
	task.wait(0.1)
	showSuccessBanner("Loaded Successfully", "THAIMION ELITE is ready")
end)
