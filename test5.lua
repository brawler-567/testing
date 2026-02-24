-- LocalScript: BattlePassUIBuilder
-- Размещение: StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--------------------------------------------------------------------------------
-- УТИЛИТЫ
--------------------------------------------------------------------------------

local function createCorner(parent, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(radius or 0.05, 0)
	corner.Parent = parent
	return corner
end

local function createStroke(parent, color, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Color3.fromRGB(255, 255, 255)
	stroke.Thickness = thickness or 1
	stroke.Transparency = transparency or 0.5
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = parent
	return stroke
end

local function createGradient(parent, colorSeq, rotation)
	local gradient = Instance.new("UIGradient")
	gradient.Color = colorSeq
	gradient.Rotation = rotation or 90
	gradient.Parent = parent
	return gradient
end

local function createPadding(parent, top, bottom, left, right)
	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(top or 0, 0)
	padding.PaddingBottom = UDim.new(bottom or 0, 0)
	padding.PaddingLeft = UDim.new(left or 0, 0)
	padding.PaddingRight = UDim.new(right or 0, 0)
	padding.Parent = parent
	return padding
end

local function createTextLabel(props)
	local label = Instance.new("TextLabel")
	label.Name = props.Name or "TextLabel"
	label.Size = props.Size or UDim2.new(1, 0, 1, 0)
	label.Position = props.Position or UDim2.new(0, 0, 0, 0)
	label.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	label.BackgroundTransparency = 1
	label.Text = props.Text or ""
	label.TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255)
	label.Font = props.Font or Enum.Font.GothamBold
	label.TextScaled = true
	label.RichText = props.RichText or false
	label.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center
	label.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
	label.ZIndex = props.ZIndex or 2
	label.Parent = props.Parent
	return label
end

local function createImageLabel(props)
	local img = Instance.new("ImageLabel")
	img.Name = props.Name or "ImageLabel"
	img.Size = props.Size or UDim2.new(1, 0, 1, 0)
	img.Position = props.Position or UDim2.new(0, 0, 0, 0)
	img.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	img.BackgroundTransparency = 1
	img.Image = props.Image or ""
	img.ImageColor3 = props.ImageColor3 or Color3.fromRGB(255, 255, 255)
	img.ImageTransparency = props.ImageTransparency or 0
	img.ScaleType = props.ScaleType or Enum.ScaleType.Fit
	img.ZIndex = props.ZIndex or 2
	img.Parent = props.Parent
	return img
end

local function createButton(props)
	local btn = Instance.new("TextButton")
	btn.Name = props.Name or "Button"
	btn.Size = props.Size or UDim2.new(1, 0, 0.1, 0)
	btn.Position = props.Position or UDim2.new(0, 0, 0.9, 0)
	btn.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	btn.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(0, 170, 255)
	btn.Text = props.Text or "CLAIM"
	btn.TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255)
	btn.Font = props.Font or Enum.Font.GothamBold
	btn.TextScaled = true
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = true
	btn.ZIndex = props.ZIndex or 3
	btn.Parent = props.Parent
	createCorner(btn, props.CornerRadius or 0.15)
	return btn
end

--------------------------------------------------------------------------------
-- ЦВЕТА
--------------------------------------------------------------------------------

local C = {
	BgDark = Color3.fromRGB(12, 12, 20),
	BgMedium = Color3.fromRGB(22, 22, 35),
	BgLight = Color3.fromRGB(32, 32, 50),
	BgCard = Color3.fromRGB(28, 28, 45),
	AccentGold = Color3.fromRGB(255, 200, 50),
	AccentBlue = Color3.fromRGB(0, 170, 255),
	AccentBlueDark = Color3.fromRGB(0, 100, 200),
	AccentPurple = Color3.fromRGB(150, 50, 255),
	AccentGreen = Color3.fromRGB(0, 200, 100),
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(180, 180, 200),
	TextMuted = Color3.fromRGB(100, 100, 130),
	PremiumGold1 = Color3.fromRGB(255, 215, 0),
	PremiumGold2 = Color3.fromRGB(255, 150, 0),
	FreeBlue1 = Color3.fromRGB(0, 150, 255),
	FreeBlue2 = Color3.fromRGB(0, 200, 255),
	Locked = Color3.fromRGB(60, 60, 80),
}

--------------------------------------------------------------------------------
-- ПОСТРОЕНИЕ
--------------------------------------------------------------------------------

local function buildBattlePassUI()
	local screenGui = playerGui:WaitForChild("MainGameGui", 30)
	if not screenGui then
		warn("[BattlePassUIBuilder]: MainGameGui не найден!")
		return
	end

	local oldBB = screenGui:FindFirstChild("BattleBass")
	if oldBB then oldBB:Destroy() end
	local oldBuy = screenGui:FindFirstChild("BuybpFrame")
	if oldBuy then oldBuy:Destroy() end
	local oldOverlay = screenGui:FindFirstChild("BuyOverlay")
	if oldOverlay then oldOverlay:Destroy() end

	---------------------------------------------------------------------------
	-- ОСНОВНОЙ ФРЕЙМ
	---------------------------------------------------------------------------
	local battleBass = Instance.new("Frame")
	battleBass.Name = "BattleBass"
	battleBass.Size = UDim2.new(0.5, 0, 0.5, 0)
	battleBass.AnchorPoint = Vector2.new(0.5, 0.5)
	battleBass.Position = UDim2.new(0.5, 0, 0.5, 0)
	battleBass.BackgroundColor3 = C.BgDark
	battleBass.BorderSizePixel = 0
	battleBass.Visible = false
	battleBass.ZIndex = 10
	battleBass.ClipsDescendants = true
	battleBass.Parent = screenGui

	createCorner(battleBass, 0.02)
	createStroke(battleBass, Color3.fromRGB(60, 50, 100), 2, 0.3)

	createGradient(battleBass, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 8, 18)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 10, 30)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 15)),
	}), 135)

	-- Декоративные блики
	for i = 1, 5 do
		local glow = Instance.new("Frame")
		glow.Name = "Glow_" .. i
		glow.Size = UDim2.new(0.15 + math.random() * 0.15, 0, 0.2 + math.random() * 0.2, 0)
		glow.Position = UDim2.new(math.random() * 0.7, 0, math.random() * 0.5, 0)
		glow.BackgroundColor3 = i % 2 == 0 and C.AccentPurple or C.AccentBlue
		glow.BackgroundTransparency = 0.93
		glow.BorderSizePixel = 0
		glow.ZIndex = 10
		glow.Parent = battleBass
		createCorner(glow, 0.5)
	end

	---------------------------------------------------------------------------
	-- ВЕРХНЯЯ ПАНЕЛЬ (Header) — 14% высоты
	---------------------------------------------------------------------------
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0.14, 0)
	header.Position = UDim2.new(0, 0, 0, 0)
	header.BackgroundColor3 = C.BgMedium
	header.BackgroundTransparency = 0.3
	header.BorderSizePixel = 0
	header.ZIndex = 15
	header.Parent = battleBass

	createGradient(header, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 15, 40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 25)),
	}), 0)

	-- Линия акцента внизу хедера
	local headerLine = Instance.new("Frame")
	headerLine.Name = "AccentLine"
	headerLine.Size = UDim2.new(1, 0, 0.03, 0)
	headerLine.Position = UDim2.new(0, 0, 0.97, 0)
	headerLine.BorderSizePixel = 0
	headerLine.ZIndex = 16
	headerLine.Parent = header

	createGradient(headerLine, ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.AccentPurple),
		ColorSequenceKeypoint.new(0.5, C.AccentGold),
		ColorSequenceKeypoint.new(1, C.AccentBlue),
	}), 0)

	-- Название сезона
	createTextLabel({
		Name = "CurrentSeason",
		Text = "⚔ SEASON 1 — SHADOW WARFARE ⚔",
		Size = UDim2.new(0.45, 0, 0.4, 0),
		Position = UDim2.new(0.02, 0, 0.1, 0),
		TextColor3 = C.AccentGold,
		Font = Enum.Font.GothamBlack,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = header,
	})

	-- Таймер сезона
	createTextLabel({
		Name = "SeasonTimer",
		Text = "29d 12h 45m remaining",
		Size = UDim2.new(0.3, 0, 0.3, 0),
		Position = UDim2.new(0.02, 0, 0.55, 0),
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = header,
	})

	-- Кнопка закрытия
	local closeBPBtn = createButton({
		Name = "CloseBPBtn",
		Size = UDim2.new(0.05, 0, 0.6, 0),
		Position = UDim2.new(0.97, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Text = "✕",
		BackgroundColor3 = Color3.fromRGB(200, 50, 50),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		CornerRadius = 0.2,
		ZIndex = 17,
		Parent = header,
	})

	closeBPBtn.MouseButton1Click:Connect(function()
		battleBass.Visible = false
		local buyFrame = screenGui:FindFirstChild("BuybpFrame")
		if buyFrame then buyFrame.Visible = false end
		local buttons = screenGui:FindFirstChild("Buttons")
		if buttons then buttons.Visible = true end
	end)

	---------------------------------------------------------------------------
	-- ТЕКУЩИЙ УРОВЕНЬ (CurrentStepFrame) — справа в хедере
	---------------------------------------------------------------------------
	local currentStepFrame = Instance.new("Frame")
	currentStepFrame.Name = "CurrentStepFrame"
	currentStepFrame.Size = UDim2.new(0.18, 0, 0.65, 0)
	currentStepFrame.Position = UDim2.new(0.9, 0, 0.5, 0)
	currentStepFrame.AnchorPoint = Vector2.new(1, 0.5)
	currentStepFrame.BackgroundColor3 = C.BgLight
	currentStepFrame.BackgroundTransparency = 0.2
	currentStepFrame.BorderSizePixel = 0
	currentStepFrame.ZIndex = 16
	currentStepFrame.Parent = battleBass
	createCorner(currentStepFrame, 0.1)
	createStroke(currentStepFrame, C.AccentGold, 2, 0.3)

	-- Звезда
	createTextLabel({
		Name = "StarIcon",
		Text = "★",
		Size = UDim2.new(0.25, 0, 0.7, 0),
		Position = UDim2.new(0.05, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.AccentGold,
		Font = Enum.Font.GothamBlack,
		ZIndex = 17,
		Parent = currentStepFrame,
	})

	-- "Step"
	createTextLabel({
		Name = "StepText",
		Text = "Step",
		Size = UDim2.new(0.45, 0, 0.3, 0),
		Position = UDim2.new(0.32, 0, 0.12, 0),
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 17,
		Parent = currentStepFrame,
	})

	-- Номер уровня
	createTextLabel({
		Name = "CurrentStep",
		Text = "1",
		Size = UDim2.new(0.4, 0, 0.5, 0),
		Position = UDim2.new(0.32, 0, 0.42, 0),
		TextColor3 = C.AccentGold,
		Font = Enum.Font.GothamBlack,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 17,
		Parent = currentStepFrame,
	})

	-- "/ 50"
	createTextLabel({
		Name = "MaxLevel",
		Text = "/ 50",
		Size = UDim2.new(0.25, 0, 0.3, 0),
		Position = UDim2.new(0.72, 0, 0.55, 0),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 17,
		Parent = currentStepFrame,
	})

	---------------------------------------------------------------------------
	-- ПРОГРЕСС БАР — 5% высоты, под хедером
	---------------------------------------------------------------------------
	local progressBar = Instance.new("Frame")
	progressBar.Name = "ProgressBar"
	progressBar.Size = UDim2.new(0.6, 0, 0.05, 0)
	progressBar.Position = UDim2.new(0.5, 0, 0.165, 0)
	progressBar.AnchorPoint = Vector2.new(0.5, 0)
	progressBar.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
	progressBar.BorderSizePixel = 0
	progressBar.ZIndex = 15
	progressBar.Parent = battleBass
	createCorner(progressBar, 0.3)
	createStroke(progressBar, Color3.fromRGB(50, 50, 80), 1, 0.4)

	-- Фон полоски
	local barBg = Instance.new("Frame")
	barBg.Name = "BarBg"
	barBg.Size = UDim2.new(0.98, 0, 0.7, 0)
	barBg.Position = UDim2.new(0.5, 0, 0.5, 0)
	barBg.AnchorPoint = Vector2.new(0.5, 0.5)
	barBg.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
	barBg.BorderSizePixel = 0
	barBg.ZIndex = 15
	barBg.ClipsDescendants = true
	barBg.Parent = progressBar
	createCorner(barBg, 0.3)

	-- Заполнение
	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.Position = UDim2.new(0, 0, 0, 0)
	fill.BackgroundColor3 = C.AccentGold
	fill.BorderSizePixel = 0
	fill.ZIndex = 16
	fill.ClipsDescendants = true
	fill.Parent = barBg
	createCorner(fill, 0.3)

	createGradient(fill, ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.AccentGold),
		ColorSequenceKeypoint.new(0.6, Color3.fromRGB(255, 170, 0)),
		ColorSequenceKeypoint.new(1, C.AccentPurple),
	}), 0)

	-- Свечение на конце
	local fillGlow = Instance.new("Frame")
	fillGlow.Name = "FillGlow"
	fillGlow.Size = UDim2.new(0.05, 0, 1.2, 0)
	fillGlow.Position = UDim2.new(1, 0, 0.5, 0)
	fillGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	fillGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 200)
	fillGlow.BackgroundTransparency = 0.5
	fillGlow.BorderSizePixel = 0
	fillGlow.ZIndex = 17
	fillGlow.Parent = fill
	createCorner(fillGlow, 0.4)

	-- XP текст
	createTextLabel({
		Name = "XPText",
		Text = "0 / 100 XP",
		Size = UDim2.new(0.8, 0, 0.8, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		ZIndex = 18,
		Parent = progressBar,
	})

	-- Иконка XP
	createTextLabel({
		Name = "XPIcon",
		Text = "✦",
		Size = UDim2.new(0.06, 0, 0.8, 0),
		Position = UDim2.new(0.02, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.AccentGold,
		Font = Enum.Font.GothamBlack,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 18,
		Parent = progressBar,
	})

	---------------------------------------------------------------------------
	-- КНОПКИ ДЕЙСТВИЙ — справа, под прогресс баром
	---------------------------------------------------------------------------
	local actionsPanel = Instance.new("Frame")
	actionsPanel.Name = "ActionsPanel"
	actionsPanel.Size = UDim2.new(0.35, 0, 0.06, 0)
	actionsPanel.Position = UDim2.new(0.98, 0, 0.16, 0)
	actionsPanel.AnchorPoint = Vector2.new(1, 0)
	actionsPanel.BackgroundTransparency = 1
	actionsPanel.BorderSizePixel = 0
	actionsPanel.ZIndex = 15
	actionsPanel.Parent = battleBass

	local actionsLayout = Instance.new("UIListLayout")
	actionsLayout.FillDirection = Enum.FillDirection.Horizontal
	actionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	actionsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	actionsLayout.Padding = UDim.new(0.03, 0)
	actionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	actionsLayout.Parent = actionsPanel

	-- Claim All
	local claimAllBtn = createButton({
		Name = "ClaimAllBtn",
		Size = UDim2.new(0.45, 0, 0.9, 0),
		Text = "✦ CLAIM ALL",
		BackgroundColor3 = C.AccentGreen,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		CornerRadius = 0.2,
		ZIndex = 16,
		Parent = actionsPanel,
	})
	claimAllBtn.LayoutOrder = 1

	createGradient(claimAllBtn, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 100)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 80)),
	}), 90)

	-- Skip Step
	local skipStepBtn = createButton({
		Name = "SkipStepBtn",
		Size = UDim2.new(0.48, 0, 0.9, 0),
		Text = "⚡ SKIP STEP",
		BackgroundColor3 = C.AccentGold,
		TextColor3 = C.BgDark,
		Font = Enum.Font.GothamBold,
		CornerRadius = 0.2,
		ZIndex = 16,
		Parent = actionsPanel,
	})
	skipStepBtn.LayoutOrder = 2

	createGradient(skipStepBtn, ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.AccentGold),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 160, 0)),
	}), 90)

	---------------------------------------------------------------------------
	-- ЛЕЙБЛЫ FREE / PREMIUM — слева
	---------------------------------------------------------------------------
	local labelsPanel = Instance.new("Frame")
	labelsPanel.Name = "LabelsPanel"
	labelsPanel.Size = UDim2.new(0.08, 0, 0.6, 0)
	labelsPanel.Position = UDim2.new(0.01, 0, 0.24, 0)
	labelsPanel.BackgroundTransparency = 1
	labelsPanel.BorderSizePixel = 0
	labelsPanel.ZIndex = 15
	labelsPanel.Parent = battleBass

	-- FREE лейбл
	local freeLabelFrame = Instance.new("Frame")
	freeLabelFrame.Name = "FreeLabelFrame"
	freeLabelFrame.Size = UDim2.new(1, 0, 0.38, 0)
	freeLabelFrame.Position = UDim2.new(0, 0, 0.1, 0)
	freeLabelFrame.BackgroundColor3 = C.BgLight
	freeLabelFrame.BackgroundTransparency = 0.3
	freeLabelFrame.BorderSizePixel = 0
	freeLabelFrame.ZIndex = 15
	freeLabelFrame.Parent = labelsPanel
	createCorner(freeLabelFrame, 0.1)
	createStroke(freeLabelFrame, C.FreeBlue1, 1.5, 0.4)

	createTextLabel({
		Name = "FreeIcon",
		Text = "🎁",
		Size = UDim2.new(0.8, 0, 0.3, 0),
		Position = UDim2.new(0.5, 0, 0.2, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Font = Enum.Font.GothamBlack,
		ZIndex = 16,
		Parent = freeLabelFrame,
	})

	createTextLabel({
		Name = "FreeText",
		Text = "FREE",
		Size = UDim2.new(0.9, 0, 0.25, 0),
		Position = UDim2.new(0.5, 0, 0.55, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = C.FreeBlue2,
		Font = Enum.Font.GothamBlack,
		ZIndex = 16,
		Parent = freeLabelFrame,
	})

	-- PREMIUM лейбл
	local premiumLabelFrame = Instance.new("Frame")
	premiumLabelFrame.Name = "PremiumLabelFrame"
	premiumLabelFrame.Size = UDim2.new(1, 0, 0.38, 0)
	premiumLabelFrame.Position = UDim2.new(0, 0, 0.55, 0)
	premiumLabelFrame.BackgroundColor3 = C.BgLight
	premiumLabelFrame.BackgroundTransparency = 0.3
	premiumLabelFrame.BorderSizePixel = 0
	premiumLabelFrame.ZIndex = 15
	premiumLabelFrame.Parent = labelsPanel
	createCorner(premiumLabelFrame, 0.1)
	createStroke(premiumLabelFrame, C.PremiumGold1, 1.5, 0.3)

	createGradient(premiumLabelFrame, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 40, 20)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 25, 15)),
	}), 90)

	createTextLabel({
		Name = "PremIcon",
		Text = "👑",
		Size = UDim2.new(0.8, 0, 0.3, 0),
		Position = UDim2.new(0.5, 0, 0.2, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Font = Enum.Font.GothamBlack,
		ZIndex = 16,
		Parent = premiumLabelFrame,
	})

	createTextLabel({
		Name = "PremText",
		Text = "PREM",
		Size = UDim2.new(0.9, 0, 0.25, 0),
		Position = UDim2.new(0.5, 0, 0.55, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = C.PremiumGold1,
		Font = Enum.Font.GothamBlack,
		ZIndex = 16,
		Parent = premiumLabelFrame,
	})

	---------------------------------------------------------------------------
	-- СКРОЛЛ ФРЕЙМ
	---------------------------------------------------------------------------
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "BattlePassMainFrame"
	mainFrame.Size = UDim2.new(0.88, 0, 0.6, 0)
	mainFrame.Position = UDim2.new(0.1, 0, 0.24, 0)
	mainFrame.BackgroundColor3 = C.BgMedium
	mainFrame.BackgroundTransparency = 0.5
	mainFrame.BorderSizePixel = 0
	mainFrame.ZIndex = 12
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = battleBass
	createCorner(mainFrame, 0.02)

	local scrollingBP = Instance.new("ScrollingFrame")
	scrollingBP.Name = "ScrollingBattlePass"
	scrollingBP.Size = UDim2.new(0.99, 0, 0.97, 0)
	scrollingBP.Position = UDim2.new(0.5, 0, 0.5, 0)
	scrollingBP.AnchorPoint = Vector2.new(0.5, 0.5)
	scrollingBP.BackgroundTransparency = 1
	scrollingBP.BorderSizePixel = 0
	scrollingBP.ScrollBarThickness = 4
	scrollingBP.ScrollBarImageColor3 = C.AccentGold
	scrollingBP.ScrollBarImageTransparency = 0.3
	scrollingBP.AutomaticCanvasSize = Enum.AutomaticSize.X
	scrollingBP.ScrollingDirection = Enum.ScrollingDirection.X
	scrollingBP.ElasticBehavior = Enum.ElasticBehavior.Always
	scrollingBP.ZIndex = 13
	scrollingBP.Parent = mainFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	listLayout.Padding = UDim.new(0.005, 0)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = scrollingBP

	createPadding(scrollingBP, 0.01, 0.01, 0.005, 0.005)

	---------------------------------------------------------------------------
	-- PassTemplate (в ReplicatedStorage)
	---------------------------------------------------------------------------
	local templatesFolder = ReplicatedStorage:FindFirstChild("Templates")
	if not templatesFolder then
		templatesFolder = Instance.new("Folder")
		templatesFolder.Name = "Templates"
		templatesFolder.Parent = ReplicatedStorage
	end

	local oldTemplate = templatesFolder:FindFirstChild("PassTemplate")
	if oldTemplate then oldTemplate:Destroy() end

	local passTemplate = Instance.new("Frame")
	passTemplate.Name = "PassTemplate"
	passTemplate.Size = UDim2.new(0.065, 0, 0.95, 0)
	passTemplate.BackgroundColor3 = C.BgCard
	passTemplate.BackgroundTransparency = 0.1
	passTemplate.BorderSizePixel = 0
	passTemplate.Visible = false
	passTemplate.ZIndex = 14
	passTemplate.Parent = templatesFolder
	createCorner(passTemplate, 0.05)
	createStroke(passTemplate, Color3.fromRGB(50, 50, 80), 1, 0.5)

	-- Верхняя полоса карточки
	local cardTopBar = Instance.new("Frame")
	cardTopBar.Name = "CardTopBar"
	cardTopBar.Size = UDim2.new(1, 0, 0.01, 0)
	cardTopBar.Position = UDim2.new(0, 0, 0, 0)
	cardTopBar.BackgroundColor3 = C.AccentGold
	cardTopBar.BackgroundTransparency = 0.3
	cardTopBar.BorderSizePixel = 0
	cardTopBar.ZIndex = 15
	cardTopBar.Parent = passTemplate
	createCorner(cardTopBar, 0.5)

	-- StepFrame (номер уровня)
	local stepFrame = Instance.new("Frame")
	stepFrame.Name = "StepFrame"
	stepFrame.Size = UDim2.new(0.8, 0, 0.1, 0)
	stepFrame.Position = UDim2.new(0.5, 0, 0.02, 0)
	stepFrame.AnchorPoint = Vector2.new(0.5, 0)
	stepFrame.BackgroundColor3 = C.BgLight
	stepFrame.BorderSizePixel = 0
	stepFrame.ZIndex = 15
	stepFrame.Parent = passTemplate
	createCorner(stepFrame, 0.2)

	createGradient(stepFrame, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(251, 255, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 179, 0)),
	}), 0)

	createTextLabel({
		Name = "Step",
		Text = "1",
		Size = UDim2.new(1, 0, 1, 0),
		TextColor3 = C.BgDark,
		Font = Enum.Font.GothamBlack,
		ZIndex = 16,
		Parent = stepFrame,
	})

	---------------------------------------------------------------------------
	-- FREE REWARD внутри карточки
	---------------------------------------------------------------------------
	local freeFrame = Instance.new("Frame")
	freeFrame.Name = "Free"
	freeFrame.Size = UDim2.new(0.88, 0, 0.36, 0)
	freeFrame.Position = UDim2.new(0.5, 0, 0.14, 0)
	freeFrame.AnchorPoint = Vector2.new(0.5, 0)
	freeFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
	freeFrame.BackgroundTransparency = 0.15
	freeFrame.BorderSizePixel = 0
	freeFrame.ZIndex = 15
	freeFrame.Parent = passTemplate
	createCorner(freeFrame, 0.08)
	createStroke(freeFrame, C.FreeBlue1, 1, 0.6)

	-- FREE бейдж
	local freeBadge = Instance.new("Frame")
	freeBadge.Name = "FreeBadge"
	freeBadge.Size = UDim2.new(0.5, 0, 0.12, 0)
	freeBadge.Position = UDim2.new(0.5, 0, 0.03, 0)
	freeBadge.AnchorPoint = Vector2.new(0.5, 0)
	freeBadge.BackgroundColor3 = C.FreeBlue1
	freeBadge.BorderSizePixel = 0
	freeBadge.ZIndex = 17
	freeBadge.Parent = freeFrame
	createCorner(freeBadge, 0.3)

	createTextLabel({
		Name = "BadgeText",
		Text = "FREE",
		Size = UDim2.new(1, 0, 1, 0),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		ZIndex = 18,
		Parent = freeBadge,
	})

	-- Иконка Free
	createImageLabel({
		Name = "RewardIconFree",
		Size = UDim2.new(0.6, 0, 0.4, 0),
		Position = UDim2.new(0.5, 0, 0.38, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = "",
		ZIndex = 16,
		Parent = freeFrame,
	})

	-- Кол-во Free
	createTextLabel({
		Name = "Amount",
		Text = "",
		Size = UDim2.new(0.9, 0, 0.13, 0),
		Position = UDim2.new(0.5, 0, 0.62, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.GothamBold,
		ZIndex = 16,
		Parent = freeFrame,
	})

	-- Кнопка Claim Free
	createButton({
		Name = "ClaimFreeBtn",
		Size = UDim2.new(0.85, 0, 0.17, 0),
		Position = UDim2.new(0.5, 0, 0.95, 0),
		AnchorPoint = Vector2.new(0.5, 1),
		Text = "LOCKED",
		BackgroundColor3 = C.Locked,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		CornerRadius = 0.2,
		ZIndex = 17,
		Parent = freeFrame,
	})

	---------------------------------------------------------------------------
	-- PREMIUM REWARD внутри карточки
	---------------------------------------------------------------------------
	local premiumFrame = Instance.new("Frame")
	premiumFrame.Name = "Premium"
	premiumFrame.Size = UDim2.new(0.88, 0, 0.36, 0)
	premiumFrame.Position = UDim2.new(0.5, 0, 0.52, 0)
	premiumFrame.AnchorPoint = Vector2.new(0.5, 0)
	premiumFrame.BackgroundColor3 = Color3.fromRGB(40, 30, 15)
	premiumFrame.BackgroundTransparency = 0.15
	premiumFrame.BorderSizePixel = 0
	premiumFrame.ZIndex = 15
	premiumFrame.Parent = passTemplate
	createCorner(premiumFrame, 0.08)
	createStroke(premiumFrame, C.PremiumGold1, 1.2, 0.4)

	createGradient(premiumFrame, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 35, 15)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 20, 10)),
	}), 90)

	-- PREMIUM бейдж
	local premBadge = Instance.new("Frame")
	premBadge.Name = "PremBadge"
	premBadge.Size = UDim2.new(0.65, 0, 0.12, 0)
	premBadge.Position = UDim2.new(0.5, 0, 0.03, 0)
	premBadge.AnchorPoint = Vector2.new(0.5, 0)
	premBadge.BackgroundColor3 = C.PremiumGold1
	premBadge.BorderSizePixel = 0
	premBadge.ZIndex = 17
	premBadge.Parent = premiumFrame
	createCorner(premBadge, 0.3)

	createTextLabel({
		Name = "BadgeText",
		Text = "👑 PREM",
		Size = UDim2.new(1, 0, 1, 0),
		TextColor3 = C.BgDark,
		Font = Enum.Font.GothamBold,
		ZIndex = 18,
		Parent = premBadge,
	})

	-- Иконка Premium
	createImageLabel({
		Name = "RewardIconPremium",
		Size = UDim2.new(0.6, 0, 0.4, 0),
		Position = UDim2.new(0.5, 0, 0.38, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = "",
		ZIndex = 16,
		Parent = premiumFrame,
	})

	-- Кол-во Premium
	createTextLabel({
		Name = "Amount",
		Text = "",
		Size = UDim2.new(0.9, 0, 0.13, 0),
		Position = UDim2.new(0.5, 0, 0.62, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		TextColor3 = C.PremiumGold1,
		Font = Enum.Font.GothamBold,
		ZIndex = 16,
		Parent = premiumFrame,
	})

	-- Кнопка Claim Premium
	createButton({
		Name = "ClaimPremiumBtn",
		Size = UDim2.new(0.85, 0, 0.17, 0),
		Position = UDim2.new(0.5, 0, 0.95, 0),
		AnchorPoint = Vector2.new(0.5, 1),
		Text = "🔒",
		BackgroundColor3 = Color3.fromRGB(150, 100, 0),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		CornerRadius = 0.2,
		ZIndex = 17,
		Parent = premiumFrame,
	})

	---------------------------------------------------------------------------
	-- START ЭЛЕМЕНТ в скролле
	---------------------------------------------------------------------------
	local startFrame = Instance.new("Frame")
	startFrame.Name = "Start"
	startFrame.Size = UDim2.new(0.045, 0, 0.95, 0)
	startFrame.BackgroundColor3 = C.BgCard
	startFrame.BackgroundTransparency = 0.3
	startFrame.BorderSizePixel = 0
	startFrame.LayoutOrder = 0
	startFrame.ZIndex = 14
	startFrame.Parent = scrollingBP
	createCorner(startFrame, 0.08)

	createTextLabel({
		Name = "StartIcon",
		Text = "🏁",
		Size = UDim2.new(0.8, 0, 0.2, 0),
		Position = UDim2.new(0.5, 0, 0.35, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Font = Enum.Font.GothamBlack,
		ZIndex = 15,
		Parent = startFrame,
	})

	createTextLabel({
		Name = "StartText",
		Text = "START",
		Size = UDim2.new(0.9, 0, 0.1, 0),
		Position = UDim2.new(0.5, 0, 0.55, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.GothamBold,
		ZIndex = 15,
		Parent = startFrame,
	})

	---------------------------------------------------------------------------
	-- НИЖНЯЯ ПАНЕЛЬ — 8% высоты
	---------------------------------------------------------------------------
	local bottomBar = Instance.new("Frame")
	bottomBar.Name = "BottomBar"
	bottomBar.Size = UDim2.new(1, 0, 0.09, 0)
	bottomBar.Position = UDim2.new(0, 0, 0.91, 0)
	bottomBar.BackgroundColor3 = C.BgMedium
	bottomBar.BackgroundTransparency = 0.3
	bottomBar.BorderSizePixel = 0
	bottomBar.ZIndex = 15
	bottomBar.Parent = battleBass

	createGradient(bottomBar, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 10, 25)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 15, 40)),
	}), 0)

	-- Верхняя линия на нижней панели
	local bottomLine = Instance.new("Frame")
	bottomLine.Size = UDim2.new(1, 0, 0.02, 0)
	bottomLine.Position = UDim2.new(0, 0, 0, 0)
	bottomLine.BorderSizePixel = 0
	bottomLine.BackgroundTransparency = 0.5
	bottomLine.ZIndex = 16
	bottomLine.Parent = bottomBar

	createGradient(bottomLine, ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.AccentBlue),
		ColorSequenceKeypoint.new(0.5, C.AccentPurple),
		ColorSequenceKeypoint.new(1, C.AccentGold),
	}), 0)

	-- Кнопка Buy Premium
	local buyPremBtn = createButton({
		Name = "OpenBuyFrameBtn",
		Size = UDim2.new(0.2, 0, 0.7, 0),
		Position = UDim2.new(0.97, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Text = "👑 BUY PREMIUM",
		BackgroundColor3 = C.PremiumGold1,
		TextColor3 = C.BgDark,
		Font = Enum.Font.GothamBlack,
		CornerRadius = 0.15,
		ZIndex = 17,
		Parent = bottomBar,
	})

	createGradient(buyPremBtn, ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.PremiumGold1),
		ColorSequenceKeypoint.new(1, C.PremiumGold2),
	}), 0)

	buyPremBtn.MouseButton1Click:Connect(function()
		local buyFrame = screenGui:FindFirstChild("BuybpFrame")
		if buyFrame then
			buyFrame.Visible = not buyFrame.Visible
		end
	end)

	-- Инфо текст
	createTextLabel({
		Name = "BottomInfo",
		Text = "Complete missions to earn XP  •  Season ends in 29 days",
		Size = UDim2.new(0.7, 0, 0.7, 0),
		Position = UDim2.new(0.02, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = bottomBar,
	})

	---------------------------------------------------------------------------
	-- ОКНО ПОКУПКИ (BuybpFrame)
	---------------------------------------------------------------------------
	local buyOverlay = Instance.new("Frame")
	buyOverlay.Name = "BuyOverlay"
	buyOverlay.Size = UDim2.new(1, 0, 1, 0)
	buyOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	buyOverlay.BackgroundTransparency = 0.5
	buyOverlay.BorderSizePixel = 0
	buyOverlay.ZIndex = 29
	buyOverlay.Visible = false
	buyOverlay.Parent = screenGui

	buyOverlay.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local buyFrame = screenGui:FindFirstChild("BuybpFrame")
			if buyFrame then buyFrame.Visible = false end
			buyOverlay.Visible = false
		end
	end)

	local buyBPFrame = Instance.new("Frame")
	buyBPFrame.Name = "BuybpFrame"
	buyBPFrame.Size = UDim2.new(0.3, 0, 0.45, 0)
	buyBPFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	buyBPFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	buyBPFrame.BackgroundColor3 = C.BgMedium
	buyBPFrame.BorderSizePixel = 0
	buyBPFrame.Visible = false
	buyBPFrame.ZIndex = 30
	buyBPFrame.Parent = screenGui
	createCorner(buyBPFrame, 0.04)
	createStroke(buyBPFrame, C.AccentGold, 2, 0.2)

	createGradient(buyBPFrame, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 25, 50)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 12, 30)),
	}), 135)

	-- Синхронизация overlay
	buyBPFrame:GetPropertyChangedSignal("Visible"):Connect(function()
		buyOverlay.Visible = buyBPFrame.Visible
	end)

	-- Заголовок покупки
	createTextLabel({
		Name = "BuyTitle",
		Text = "👑 PREMIUM BATTLE PASS",
		Size = UDim2.new(0.9, 0, 0.1, 0),
		Position = UDim2.new(0.5, 0, 0.06, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		TextColor3 = C.AccentGold,
		Font = Enum.Font.GothamBlack,
		ZIndex = 31,
		Parent = buyBPFrame,
	})

	-- Описание
	createTextLabel({
		Name = "BuyDesc",
		Text = "Unlock exclusive premium rewards,\nweapon skins, and bonus coins!",
		Size = UDim2.new(0.85, 0, 0.12, 0),
		Position = UDim2.new(0.5, 0, 0.18, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 31,
		Parent = buyBPFrame,
	})

	-- Преимущества
	local benefitsFrame = Instance.new("Frame")
	benefitsFrame.Name = "Benefits"
	benefitsFrame.Size = UDim2.new(0.85, 0, 0.3, 0)
	benefitsFrame.Position = UDim2.new(0.5, 0, 0.33, 0)
	benefitsFrame.AnchorPoint = Vector2.new(0.5, 0)
	benefitsFrame.BackgroundTransparency = 1
	benefitsFrame.ZIndex = 31
	benefitsFrame.Parent = buyBPFrame

	local benefits = {"✦ Premium reward track", "✦ Exclusive weapon skins", "✦ 2x XP boost", "✦ Special emotes"}
	for i, benefit in ipairs(benefits) do
		createTextLabel({
			Name = "Benefit_" .. i,
			Text = benefit,
			Size = UDim2.new(1, 0, 0.22, 0),
			Position = UDim2.new(0, 0, (i - 1) * 0.25, 0),
			TextColor3 = C.AccentGold,
			Font = Enum.Font.Gotham,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 32,
			Parent = benefitsFrame,
		})
	end

	-- Кнопка покупки
	local buyBtn = createButton({
		Name = "BuyBtn",
		Size = UDim2.new(0.43, 0, 0.1, 0),
		Position = UDim2.new(0.26, 0, 0.82, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Text = "799 R$",
		BackgroundColor3 = C.AccentGold,
		TextColor3 = C.BgDark,
		Font = Enum.Font.GothamBlack,
		CornerRadius = 0.15,
		ZIndex = 32,
		Parent = buyBPFrame,
	})

	createGradient(buyBtn, ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.AccentGold),
		ColorSequenceKeypoint.new(1, C.PremiumGold2),
	}), 90)

	-- Кнопка подарка
	local giftBtn = createButton({
		Name = "GiftBtn",
		Size = UDim2.new(0.43, 0, 0.1, 0),
		Position = UDim2.new(0.74, 0, 0.82, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Text = "🎁 GIFT",
		BackgroundColor3 = C.AccentBlue,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		CornerRadius = 0.15,
		ZIndex = 32,
		Parent = buyBPFrame,
	})

	createGradient(giftBtn, ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.AccentBlue),
		ColorSequenceKeypoint.new(1, C.AccentBlueDark),
	}), 90)

	-- Кнопка закрытия окна покупки
	local closeBuyBtn = createButton({
		Name = "CloseBuyBtn",
		Size = UDim2.new(0.08, 0, 0.08, 0),
		Position = UDim2.new(0.96, 0, 0.04, 0),
		AnchorPoint = Vector2.new(1, 0),
		Text = "✕",
		BackgroundColor3 = Color3.fromRGB(200, 50, 50),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		CornerRadius = 0.2,
		ZIndex = 32,
		Parent = buyBPFrame,
	})

	closeBuyBtn.MouseButton1Click:Connect(function()
		buyBPFrame.Visible = false
	end)

	---------------------------------------------------------------------------
	-- HOVER-ЭФФЕКТЫ
	---------------------------------------------------------------------------
	local function addHoverEffect(button)
		local originalSize = button.Size
		local hoverSize = UDim2.new(
			originalSize.X.Scale * 1.05, 0,
			originalSize.Y.Scale * 1.05, 0
		)
		button.MouseEnter:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = hoverSize
			}):Play()
		end)
		button.MouseLeave:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = originalSize
			}):Play()
		end)
	end

	addHoverEffect(claimAllBtn)
	addHoverEffect(skipStepBtn)
	addHoverEffect(buyBtn)
	addHoverEffect(giftBtn)
	addHoverEffect(buyPremBtn)
	addHoverEffect(closeBPBtn)
	addHoverEffect(closeBuyBtn)

	---------------------------------------------------------------------------
	-- АНИМАЦИЯ БЛИКОВ
	---------------------------------------------------------------------------
	for _, glow in ipairs(battleBass:GetChildren()) do
		if glow.Name:match("^Glow_") then
			local origPos = glow.Position
			task.spawn(function()
				while glow.Parent do
					local dur = 4 + math.random() * 4
					TweenService:Create(glow, TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						Position = UDim2.new(
							origPos.X.Scale + (math.random() - 0.5) * 0.06, 0,
							origPos.Y.Scale + (math.random() - 0.5) * 0.04, 0
						),
						BackgroundTransparency = 0.9 + math.random() * 0.06
					}):Play()
					task.wait(dur)
				end
			end)
		end
	end

	print("[BattlePassUIBuilder]: UI создан (Scale only).")
end

buildBattlePassUI()
