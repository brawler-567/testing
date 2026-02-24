-- LocalScript: PartyUIBuilder
-- Размещение: StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--------------------------------------------------------------------------------
-- УТИЛИТЫ
--------------------------------------------------------------------------------

local function createCorner(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(r or 0.05, 0)
	c.Parent = p
	return c
end

local function createStroke(p, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(255, 255, 255)
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0.5
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = p
	return s
end

local function createGradient(p, colorSeq, rotation)
	local g = Instance.new("UIGradient")
	g.Color = colorSeq
	g.Rotation = rotation or 90
	g.Parent = p
	return g
end

local function createPadding(p, t, b, l, r)
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(t or 0, 0)
	pad.PaddingBottom = UDim.new(b or 0, 0)
	pad.PaddingLeft = UDim.new(l or 0, 0)
	pad.PaddingRight = UDim.new(r or 0, 0)
	pad.Parent = p
	return pad
end

local function createText(props)
	local l = Instance.new("TextLabel")
	l.Name = props.Name or "TextLabel"
	l.Size = props.Size or UDim2.new(1, 0, 1, 0)
	l.Position = props.Position or UDim2.new(0, 0, 0, 0)
	l.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	l.BackgroundTransparency = 1
	l.Text = props.Text or ""
	l.TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255)
	l.Font = props.Font or Enum.Font.GothamBold
	l.TextScaled = true
	l.RichText = props.RichText or false
	l.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Center
	l.TextYAlignment = props.TextYAlignment or Enum.TextYAlignment.Center
	l.ZIndex = props.ZIndex or 2
	l.Parent = props.Parent
	return l
end

local function createImage(props)
	local i = Instance.new("ImageLabel")
	i.Name = props.Name or "ImageLabel"
	i.Size = props.Size or UDim2.new(1, 0, 1, 0)
	i.Position = props.Position or UDim2.new(0, 0, 0, 0)
	i.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	i.BackgroundTransparency = props.BackgroundTransparency == nil and 1 or props.BackgroundTransparency
	i.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(0, 0, 0)
	i.Image = props.Image or ""
	i.ImageColor3 = props.ImageColor3 or Color3.fromRGB(255, 255, 255)
	i.ScaleType = props.ScaleType or Enum.ScaleType.Fit
	i.ZIndex = props.ZIndex or 2
	i.Parent = props.Parent
	return i
end

local function createButton(props)
	local b = Instance.new("TextButton")
	b.Name = props.Name or "Button"
	b.Size = props.Size or UDim2.new(1, 0, 0.1, 0)
	b.Position = props.Position or UDim2.new(0, 0, 0, 0)
	b.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	b.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(0, 170, 255)
	b.Text = props.Text or ""
	b.TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255)
	b.Font = props.Font or Enum.Font.GothamBold
	b.TextScaled = true
	b.BorderSizePixel = 0
	b.AutoButtonColor = true
	b.ZIndex = props.ZIndex or 3
	b.Parent = props.Parent
	createCorner(b, props.CornerRadius or 0.15)
	return b
end

local function createTextBox(props)
	local t = Instance.new("TextBox")
	t.Name = props.Name or "TextBox"
	t.Size = props.Size or UDim2.new(1, 0, 1, 0)
	t.Position = props.Position or UDim2.new(0, 0, 0, 0)
	t.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	t.BackgroundColor3 = props.BackgroundColor3 or Color3.fromRGB(20, 20, 35)
	t.Text = props.Text or ""
	t.PlaceholderText = props.PlaceholderText or ""
	t.TextColor3 = props.TextColor3 or Color3.fromRGB(255, 255, 255)
	t.PlaceholderColor3 = props.PlaceholderColor3 or Color3.fromRGB(100, 100, 130)
	t.Font = props.Font or Enum.Font.GothamBold
	t.TextScaled = true
	t.BorderSizePixel = 0
	t.ClearTextOnFocus = false
	t.ZIndex = props.ZIndex or 3
	t.Parent = props.Parent
	createCorner(t, props.CornerRadius or 0.15)
	return t
end

local function addHover(button, mult)
	mult = mult or 1.05
	local orig = button.Size
	local hover = UDim2.new(orig.X.Scale * mult, 0, orig.Y.Scale * mult, 0)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = hover}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = orig}):Play()
	end)
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
	AccentRed = Color3.fromRGB(220, 50, 50),
	AccentOrange = Color3.fromRGB(255, 130, 0),
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(180, 180, 200),
	TextMuted = Color3.fromRGB(100, 100, 130),
	PremiumGold1 = Color3.fromRGB(255, 215, 0),
	PremiumGold2 = Color3.fromRGB(255, 150, 0),
	Locked = Color3.fromRGB(60, 60, 80),
}

--------------------------------------------------------------------------------
-- ПОСТРОЕНИЕ
--------------------------------------------------------------------------------

local function buildPartyUI()
	local existingGui = playerGui:FindFirstChild("PartyGui")
	if existingGui then existingGui:Destroy() end

	---------------------------------------------------------------------------
	-- PartyGui (ScreenGui)
	---------------------------------------------------------------------------
	local partyGui = Instance.new("ScreenGui")
	partyGui.Name = "PartyGui"
	partyGui.ResetOnSpawn = false
	partyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	partyGui.IgnoreGuiInset = true
	partyGui.Parent = playerGui

	---------------------------------------------------------------------------
	-- PartyFrame — основной фрейм пати
	---------------------------------------------------------------------------
	local partyFrame = Instance.new("Frame")
	partyFrame.Name = "PartyFrame"
	partyFrame.Size = UDim2.new(0.45, 0, 0.6, 0)
	partyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	partyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	partyFrame.BackgroundColor3 = C.BgDark
	partyFrame.BorderSizePixel = 0
	partyFrame.Visible = false
	partyFrame.ZIndex = 10
	partyFrame.ClipsDescendants = true
	partyFrame.Parent = partyGui

	createCorner(partyFrame, 0.02)
	createStroke(partyFrame, Color3.fromRGB(60, 50, 100), 2, 0.3)
	createGradient(partyFrame, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 8, 22)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 12, 35)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 6, 18)),
	}), 135)

	-- Декоративные блики
	for i = 1, 4 do
		local glow = Instance.new("Frame")
		glow.Name = "Glow_" .. i
		glow.Size = UDim2.new(0.12 + math.random() * 0.1, 0, 0.15 + math.random() * 0.12, 0)
		glow.Position = UDim2.new(math.random() * 0.7, 0, math.random() * 0.6, 0)
		glow.BackgroundColor3 = i % 2 == 0 and C.AccentPurple or C.AccentBlue
		glow.BackgroundTransparency = 0.93
		glow.BorderSizePixel = 0
		glow.ZIndex = 10
		glow.Parent = partyFrame
		createCorner(glow, 0.5)
	end

	---------------------------------------------------------------------------
	-- HEADER — 12% высоты
	---------------------------------------------------------------------------
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0.12, 0)
	header.Position = UDim2.new(0, 0, 0, 0)
	header.BackgroundColor3 = C.BgMedium
	header.BackgroundTransparency = 0.3
	header.BorderSizePixel = 0
	header.ZIndex = 15
	header.Parent = partyFrame

	createGradient(header, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 18, 50)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 10, 28)),
	}), 0)

	local headerLine = Instance.new("Frame")
	headerLine.Name = "AccentLine"
	headerLine.Size = UDim2.new(1, 0, 0.025, 0)
	headerLine.Position = UDim2.new(0, 0, 0.975, 0)
	headerLine.BorderSizePixel = 0
	headerLine.ZIndex = 16
	headerLine.Parent = header
	createGradient(headerLine, ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.AccentBlue),
		ColorSequenceKeypoint.new(0.5, C.AccentPurple),
		ColorSequenceKeypoint.new(1, C.AccentGold),
	}), 0)

	-- Иконка
	createText({
		Name = "PartyIcon",
		Text = "⚔",
		Size = UDim2.new(0.06, 0, 0.7, 0),
		Position = UDim2.new(0.03, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Font = Enum.Font.GothamBlack,
		ZIndex = 16,
		Parent = header,
	})

	-- Заголовок
	createText({
		Name = "Title",
		Text = "YOUR PARTY",
		Size = UDim2.new(0.3, 0, 0.45, 0),
		Position = UDim2.new(0.1, 0, 0.18, 0),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = header,
	})

	-- Подзаголовок (счётчик игроков)
	createText({
		Name = "PartyCount",
		Text = "0/4 Members",
		Size = UDim2.new(0.25, 0, 0.3, 0),
		Position = UDim2.new(0.1, 0, 0.6, 0),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = header,
	})

	-- Иконка карты (справа в хедере)
	local mapIconBg = Instance.new("Frame")
	mapIconBg.Name = "MapIconBg"
	mapIconBg.Size = UDim2.new(0.07, 0, 0.65, 0)
	mapIconBg.Position = UDim2.new(0.72, 0, 0.5, 0)
	mapIconBg.AnchorPoint = Vector2.new(0, 0.5)
	mapIconBg.BackgroundColor3 = C.BgLight
	mapIconBg.BackgroundTransparency = 0.3
	mapIconBg.BorderSizePixel = 0
	mapIconBg.ZIndex = 16
	mapIconBg.Parent = header
	createCorner(mapIconBg, 0.15)
	createStroke(mapIconBg, C.AccentPurple, 1, 0.5)

	local mapIcon = createImage({
		Name = "MapIcon",
		Size = UDim2.new(0.85, 0, 0.85, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = "",
		ZIndex = 17,
		Parent = mapIconBg,
	})
	createCorner(mapIcon, 0.1)

	-- Кнопка настроек
	local settingsButton = createButton({
		Name = "SettingsButton",
		Size = UDim2.new(0.06, 0, 0.55, 0),
		Position = UDim2.new(0.82, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Text = "⚙",
		BackgroundColor3 = C.BgLight,
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.GothamBlack,
		CornerRadius = 0.2,
		ZIndex = 17,
		Parent = header,
	})
	createStroke(settingsButton, C.AccentPurple, 1, 0.5)
	addHover(settingsButton)

	-- Кнопка «Назад» (выход из пати)
	local backButton = createButton({
		Name = "BackButton",
		Size = UDim2.new(0.06, 0, 0.55, 0),
		Position = UDim2.new(0.96, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Text = "✕",
		BackgroundColor3 = C.AccentRed,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		CornerRadius = 0.2,
		ZIndex = 17,
		Parent = header,
	})
	addHover(backButton)

	---------------------------------------------------------------------------
	-- PLAYERS FRAME — список участников (58% высоты)
	---------------------------------------------------------------------------
	local playersFrame = Instance.new("ScrollingFrame")
	playersFrame.Name = "PlayersFrame"
	playersFrame.Size = UDim2.new(0.96, 0, 0.58, 0)
	playersFrame.Position = UDim2.new(0.5, 0, 0.14, 0)
	playersFrame.AnchorPoint = Vector2.new(0.5, 0)
	playersFrame.BackgroundTransparency = 1
	playersFrame.BorderSizePixel = 0
	playersFrame.ScrollBarThickness = 3
	playersFrame.ScrollBarImageColor3 = C.AccentPurple
	playersFrame.ScrollBarImageTransparency = 0.4
	playersFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	playersFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	playersFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	playersFrame.ZIndex = 13
	playersFrame.Parent = partyFrame

	local playersLayout = Instance.new("UIListLayout")
	playersLayout.FillDirection = Enum.FillDirection.Vertical
	playersLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	playersLayout.Padding = UDim.new(0.02, 0)
	playersLayout.SortOrder = Enum.SortOrder.LayoutOrder
	playersLayout.Parent = playersFrame

	createPadding(playersFrame, 0.015, 0.015, 0, 0)

	---------------------------------------------------------------------------
	-- BOTTOM BAR — 15% высоты
	---------------------------------------------------------------------------
	local bottomBar = Instance.new("Frame")
	bottomBar.Name = "BottomBar"
	bottomBar.Size = UDim2.new(1, 0, 0.15, 0)
	bottomBar.Position = UDim2.new(0, 0, 0.85, 0)
	bottomBar.BackgroundColor3 = C.BgMedium
	bottomBar.BackgroundTransparency = 0.3
	bottomBar.BorderSizePixel = 0
	bottomBar.ZIndex = 15
	bottomBar.Parent = partyFrame

	createGradient(bottomBar, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 10, 28)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 18, 45)),
	}), 0)

	local bottomLine = Instance.new("Frame")
	bottomLine.Size = UDim2.new(1, 0, 0.015, 0)
	bottomLine.Position = UDim2.new(0, 0, 0, 0)
	bottomLine.BorderSizePixel = 0
	bottomLine.BackgroundTransparency = 0.5
	bottomLine.ZIndex = 16
	bottomLine.Parent = bottomBar
	createGradient(bottomLine, ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.AccentPurple),
		ColorSequenceKeypoint.new(0.5, C.AccentBlue),
		ColorSequenceKeypoint.new(1, C.AccentGold),
	}), 0)

	-- Кнопка телепорта (только для лидера)
	local teleportButton = createButton({
		Name = "TeleportButton",
		Size = UDim2.new(0.35, 0, 0.6, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Text = "🚀 START GAME",
		BackgroundColor3 = C.AccentGreen,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		CornerRadius = 0.15,
		ZIndex = 17,
		Parent = bottomBar,
	})
	teleportButton.Visible = false
	createGradient(teleportButton, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 220, 100)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 160, 70)),
	}), 90)
	addHover(teleportButton)

	-- Инфо текст
	createText({
		Name = "WaitingText",
		Text = "⏳ Waiting for leader to start...",
		Size = UDim2.new(0.6, 0, 0.5, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		ZIndex = 16,
		Parent = bottomBar,
	})

	---------------------------------------------------------------------------
	-- SETTINGS FRAME — оверлей настроек (внутри PartyFrame)
	---------------------------------------------------------------------------
	local settingsFrame = Instance.new("Frame")
	settingsFrame.Name = "SettingsFrame"
	settingsFrame.Size = UDim2.new(0.92, 0, 0.7, 0)
	settingsFrame.Position = UDim2.new(0.5, 0, 0.48, 0)
	settingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	settingsFrame.BackgroundColor3 = C.BgDark
	settingsFrame.BackgroundTransparency = 0.05
	settingsFrame.BorderSizePixel = 0
	settingsFrame.Visible = false
	settingsFrame.ZIndex = 20
	settingsFrame.ClipsDescendants = true
	settingsFrame.Parent = partyFrame

	createCorner(settingsFrame, 0.03)
	createStroke(settingsFrame, C.AccentPurple, 2, 0.3)
	createGradient(settingsFrame, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 12, 30)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 6, 20)),
	}), 135)

	-- Settings Header
	local settingsHeader = Instance.new("Frame")
	settingsHeader.Name = "SettingsHeader"
	settingsHeader.Size = UDim2.new(1, 0, 0.12, 0)
	settingsHeader.Position = UDim2.new(0, 0, 0, 0)
	settingsHeader.BackgroundColor3 = C.BgMedium
	settingsHeader.BackgroundTransparency = 0.4
	settingsHeader.BorderSizePixel = 0
	settingsHeader.ZIndex = 21
	settingsHeader.Parent = settingsFrame

	createText({
		Name = "SettingsTitle",
		Text = "⚙ PARTY SETTINGS",
		Size = UDim2.new(0.5, 0, 0.7, 0),
		Position = UDim2.new(0.04, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 22,
		Parent = settingsHeader,
	})

	local closeSettingsBtn = createButton({
		Name = "CloseButton",
		Size = UDim2.new(0.07, 0, 0.6, 0),
		Position = UDim2.new(0.96, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Text = "✕",
		BackgroundColor3 = C.AccentRed,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		CornerRadius = 0.2,
		ZIndex = 22,
		Parent = settingsHeader,
	})
	closeSettingsBtn.Visible = false
	addHover(closeSettingsBtn)

	-- ============ DIFFICULTY SECTION ============
	local diffSection = Instance.new("Frame")
	diffSection.Name = "DiffSection"
	diffSection.Size = UDim2.new(0.92, 0, 0.2, 0)
	diffSection.Position = UDim2.new(0.5, 0, 0.16, 0)
	diffSection.AnchorPoint = Vector2.new(0.5, 0)
	diffSection.BackgroundColor3 = C.BgLight
	diffSection.BackgroundTransparency = 0.5
	diffSection.BorderSizePixel = 0
	diffSection.ZIndex = 21
	diffSection.Parent = settingsFrame
	createCorner(diffSection, 0.08)

	createText({
		Name = "DiffLabel",
		Text = "⚔ DIFFICULTY",
		Size = UDim2.new(0.4, 0, 0.3, 0),
		Position = UDim2.new(0.03, 0, 0.05, 0),
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 22,
		Parent = diffSection,
	})

	-- Кнопки сложности
	local diffBtnsFrame = Instance.new("Frame")
	diffBtnsFrame.Name = "DiffButtons"
	diffBtnsFrame.Size = UDim2.new(0.94, 0, 0.5, 0)
	diffBtnsFrame.Position = UDim2.new(0.5, 0, 0.9, 0)
	diffBtnsFrame.AnchorPoint = Vector2.new(0.5, 1)
	diffBtnsFrame.BackgroundTransparency = 1
	diffBtnsFrame.ZIndex = 22
	diffBtnsFrame.Parent = diffSection

	local diffLayout = Instance.new("UIListLayout")
	diffLayout.FillDirection = Enum.FillDirection.Horizontal
	diffLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	diffLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	diffLayout.Padding = UDim.new(0.015, 0)
	diffLayout.SortOrder = Enum.SortOrder.LayoutOrder
	diffLayout.Parent = diffBtnsFrame

	local difficulties = {
		{Name = "EasyButton", Text = "Easy", Color = Color3.fromRGB(0, 200, 30), Order = 1},
		{Name = "MediumButton", Text = "Medium", Color = Color3.fromRGB(255, 200, 30), Order = 2},
		{Name = "HardButton", Text = "Hard", Color = Color3.fromRGB(255, 130, 0), Order = 3},
		{Name = "InsaneButton", Text = "Insane", Color = Color3.fromRGB(130, 0, 100), Order = 4},
		{Name = "ExtremeButton", Text = "Extreme", Color = Color3.fromRGB(125, 0, 0), Order = 5},
	}

	for _, diff in ipairs(difficulties) do
		local btn = createButton({
			Name = diff.Name,
			Size = UDim2.new(0.18, 0, 0.9, 0),
			Text = diff.Text,
			BackgroundColor3 = diff.Color,
			TextColor3 = C.TextPrimary,
			Font = Enum.Font.GothamBold,
			CornerRadius = 0.15,
			ZIndex = 23,
			Parent = diffBtnsFrame,
		})
		btn.LayoutOrder = diff.Order
		addHover(btn)
	end

	-- ============ LEVEL REQUIRE SECTION ============
	local lvlSection = Instance.new("Frame")
	lvlSection.Name = "LvlSection"
	lvlSection.Size = UDim2.new(0.92, 0, 0.15, 0)
	lvlSection.Position = UDim2.new(0.5, 0, 0.39, 0)
	lvlSection.AnchorPoint = Vector2.new(0.5, 0)
	lvlSection.BackgroundColor3 = C.BgLight
	lvlSection.BackgroundTransparency = 0.5
	lvlSection.BorderSizePixel = 0
	lvlSection.ZIndex = 21
	lvlSection.Parent = settingsFrame
	createCorner(lvlSection, 0.08)

	createText({
		Name = "LvlLabel",
		Text = "📊 LEVEL REQUIREMENT",
		Size = UDim2.new(0.5, 0, 0.5, 0),
		Position = UDim2.new(0.03, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 22,
		Parent = lvlSection,
	})

	local lvlFrame = Instance.new("Frame")
	lvlFrame.Name = "LVLFrame"
	lvlFrame.Size = UDim2.new(0.2, 0, 0.6, 0)
	lvlFrame.Position = UDim2.new(0.75, 0, 0.5, 0)
	lvlFrame.AnchorPoint = Vector2.new(0, 0.5)
	lvlFrame.BackgroundTransparency = 1
	lvlFrame.ZIndex = 22
	lvlFrame.Parent = lvlSection

	local requireTextBox = createTextBox({
		Name = "RequireTextBox",
		Size = UDim2.new(1, 0, 1, 0),
		Text = "1",
		PlaceholderText = "Lvl",
		BackgroundColor3 = Color3.fromRGB(18, 18, 32),
		TextColor3 = C.AccentGold,
		Font = Enum.Font.GothamBlack,
		CornerRadius = 0.15,
		ZIndex = 23,
		Parent = lvlFrame,
	})
	createStroke(requireTextBox, C.AccentGold, 1.5, 0.4)

	-- ============ PRIVACY SECTION ============
	local privacySection = Instance.new("Frame")
	privacySection.Name = "PrivacySection"
	privacySection.Size = UDim2.new(0.92, 0, 0.15, 0)
	privacySection.Position = UDim2.new(0.5, 0, 0.57, 0)
	privacySection.AnchorPoint = Vector2.new(0.5, 0)
	privacySection.BackgroundColor3 = C.BgLight
	privacySection.BackgroundTransparency = 0.5
	privacySection.BorderSizePixel = 0
	privacySection.ZIndex = 21
	privacySection.Parent = settingsFrame
	createCorner(privacySection, 0.08)

	createText({
		Name = "PrivacyLabel",
		Text = "🔒 PRIVACY",
		Size = UDim2.new(0.3, 0, 0.5, 0),
		Position = UDim2.new(0.03, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 22,
		Parent = privacySection,
	})

	-- Тогл приватности
	local privacyFrame = Instance.new("Frame")
	privacyFrame.Name = "PrivacyFrame"
	privacyFrame.Size = UDim2.new(0.12, 0, 0.55, 0)
	privacyFrame.Position = UDim2.new(0.85, 0, 0.5, 0)
	privacyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	privacyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
	privacyFrame.BorderSizePixel = 0
	privacyFrame.ZIndex = 22
	privacyFrame.Parent = privacySection
	createCorner(privacyFrame, 0.3)
	createStroke(privacyFrame, C.AccentGreen, 1, 0.4)

	local movingPart = Instance.new("Frame")
	movingPart.Name = "MovingPart"
	movingPart.Size = UDim2.new(0.4, 0, 0.8, 0)
	movingPart.Position = UDim2.new(0.069, 0, 0.1, 0)
	movingPart.BackgroundColor3 = C.AccentGreen
	movingPart.BorderSizePixel = 0
	movingPart.ZIndex = 23
	movingPart.Parent = privacyFrame
	createCorner(movingPart, 0.3)

	local privacyImage = createImage({
		Name = "Image",
		Size = UDim2.new(0.7, 0, 0.7, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = "rbxassetid://8046472186",
		ZIndex = 24,
		Parent = movingPart,
	})

	local interactButton = createButton({
		Name = "InteractButton",
		Size = UDim2.new(1, 0, 1, 0),
		Text = "",
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		ZIndex = 25,
		Parent = privacyFrame,
	})
	interactButton.BackgroundTransparency = 1

	-- ============ INVITE BUTTON (в настройках) ============
	local inviteButton = createButton({
		Name = "InviteButton",
		Size = UDim2.new(0.92, 0, 0.12, 0),
		Position = UDim2.new(0.5, 0, 0.78, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Text = "📨 INVITE PLAYERS",
		BackgroundColor3 = C.AccentBlue,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		CornerRadius = 0.15,
		ZIndex = 22,
		Parent = settingsFrame,
	})
	createGradient(inviteButton, ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.AccentBlue),
		ColorSequenceKeypoint.new(1, C.AccentBlueDark),
	}), 90)
	addHover(inviteButton)

	---------------------------------------------------------------------------
	-- INVITE FRAME — оверлей приглашений (внутри PartyFrame)
	---------------------------------------------------------------------------
	local inviteFrame = Instance.new("Frame")
	inviteFrame.Name = "InviteFrame"
	inviteFrame.Size = UDim2.new(0.92, 0, 0.7, 0)
	inviteFrame.Position = UDim2.new(0.5, 0, 0.48, 0)
	inviteFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	inviteFrame.BackgroundColor3 = C.BgDark
	inviteFrame.BackgroundTransparency = 0.05
	inviteFrame.BorderSizePixel = 0
	inviteFrame.Visible = false
	inviteFrame.ZIndex = 25
	inviteFrame.ClipsDescendants = true
	inviteFrame.Parent = partyFrame

	createCorner(inviteFrame, 0.03)
	createStroke(inviteFrame, C.AccentBlue, 2, 0.3)
	createGradient(inviteFrame, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 15, 35)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 8, 22)),
	}), 135)

	-- Invite Header
	local inviteHeader = Instance.new("Frame")
	inviteHeader.Name = "InviteHeader"
	inviteHeader.Size = UDim2.new(1, 0, 0.12, 0)
	inviteHeader.Position = UDim2.new(0, 0, 0, 0)
	inviteHeader.BackgroundColor3 = C.BgMedium
	inviteHeader.BackgroundTransparency = 0.4
	inviteHeader.BorderSizePixel = 0
	inviteHeader.ZIndex = 26
	inviteHeader.Parent = inviteFrame

	createText({
		Name = "InviteTitle",
		Text = "📨 INVITE PLAYERS",
		Size = UDim2.new(0.5, 0, 0.7, 0),
		Position = UDim2.new(0.04, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.AccentBlue,
		Font = Enum.Font.GothamBlack,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 27,
		Parent = inviteHeader,
	})

	local closeInviteButton = createButton({
		Name = "closeInviteButton",
		Size = UDim2.new(0.07, 0, 0.6, 0),
		Position = UDim2.new(0.96, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Text = "✕",
		BackgroundColor3 = C.AccentRed,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		CornerRadius = 0.2,
		ZIndex = 27,
		Parent = inviteHeader,
	})
	addHover(closeInviteButton)

	-- Invite Scroll
	local inviteScrollFrame = Instance.new("ScrollingFrame")
	inviteScrollFrame.Name = "InviteScrollFrame"
	inviteScrollFrame.Size = UDim2.new(0.96, 0, 0.84, 0)
	inviteScrollFrame.Position = UDim2.new(0.5, 0, 0.14, 0)
	inviteScrollFrame.AnchorPoint = Vector2.new(0.5, 0)
	inviteScrollFrame.BackgroundTransparency = 1
	inviteScrollFrame.BorderSizePixel = 0
	inviteScrollFrame.ScrollBarThickness = 3
	inviteScrollFrame.ScrollBarImageColor3 = C.AccentBlue
	inviteScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	inviteScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	inviteScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	inviteScrollFrame.ZIndex = 26
	inviteScrollFrame.Parent = inviteFrame

	local inviteLayout = Instance.new("UIListLayout")
	inviteLayout.FillDirection = Enum.FillDirection.Vertical
	inviteLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	inviteLayout.Padding = UDim.new(0.015, 0)
	inviteLayout.SortOrder = Enum.SortOrder.LayoutOrder
	inviteLayout.Parent = inviteScrollFrame

	createPadding(inviteScrollFrame, 0.01, 0.01, 0, 0)

	---------------------------------------------------------------------------
	-- ChooseMap — выбор карты
	---------------------------------------------------------------------------
	local chooseMap = Instance.new("Frame")
	chooseMap.Name = "ChooseMap"
	chooseMap.Size = UDim2.new(0.5, 0, 0.55, 0)
	chooseMap.Position = UDim2.new(0.5, 0, 0.5, 0)
	chooseMap.AnchorPoint = Vector2.new(0.5, 0.5)
	chooseMap.BackgroundColor3 = C.BgDark
	chooseMap.BorderSizePixel = 0
	chooseMap.Visible = false
	chooseMap.ZIndex = 10
	chooseMap.ClipsDescendants = true
	chooseMap.Parent = partyGui

	createCorner(chooseMap, 0.02)
	createStroke(chooseMap, Color3.fromRGB(60, 50, 100), 2, 0.3)
	createGradient(chooseMap, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 8, 22)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 6, 18)),
	}), 135)

	-- Choose Map Header
	createText({
		Name = "ChooseMapTitle",
		Text = "🗺 CHOOSE MAP",
		Size = UDim2.new(0.5, 0, 0.1, 0),
		Position = UDim2.new(0.5, 0, 0.05, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		TextColor3 = C.AccentGold,
		Font = Enum.Font.GothamBlack,
		ZIndex = 12,
		Parent = chooseMap,
	})

	-- Карты
	local maps = {
		{Name = "Forest", Text = "🌲 Forest", Image = "rbxassetid://83360223", Color = Color3.fromRGB(0, 150, 50)},
		{Name = "Desert", Text = "🏜 Desert", Image = "rbxassetid://4887497253", Color = Color3.fromRGB(200, 150, 50)},
		{Name = "Snow", Text = "❄ Snow", Image = "", Color = Color3.fromRGB(100, 180, 255)},
	}

	local mapsFrame = Instance.new("Frame")
	mapsFrame.Name = "MapsContainer"
	mapsFrame.Size = UDim2.new(0.92, 0, 0.7, 0)
	mapsFrame.Position = UDim2.new(0.5, 0, 0.55, 0)
	mapsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mapsFrame.BackgroundTransparency = 1
	mapsFrame.ZIndex = 11
	mapsFrame.Parent = chooseMap

	local mapsLayout = Instance.new("UIListLayout")
	mapsLayout.FillDirection = Enum.FillDirection.Horizontal
	mapsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	mapsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	mapsLayout.Padding = UDim.new(0.025, 0)
	mapsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	mapsLayout.Parent = mapsFrame

	for idx, mapData in ipairs(maps) do
		-- CanvasGroup оборачивает каждую карту
		local canvasGroup = Instance.new("CanvasGroup")
		canvasGroup.Name = mapData.Name
		canvasGroup.Size = UDim2.new(0.3, 0, 0.95, 0)
		canvasGroup.BackgroundColor3 = C.BgCard
		canvasGroup.BackgroundTransparency = 0.1
		canvasGroup.BorderSizePixel = 0
		canvasGroup.LayoutOrder = idx
		canvasGroup.ZIndex = 12
		canvasGroup.Parent = mapsFrame
		createCorner(canvasGroup, 0.05)
		createStroke(canvasGroup, mapData.Color, 1.5, 0.4)

		-- Фоновое изображение карты
		local mapBg = createImage({
			Name = "MapBg",
			Size = UDim2.new(1, 0, 0.6, 0),
			Position = UDim2.new(0, 0, 0, 0),
			Image = mapData.Image,
			ScaleType = Enum.ScaleType.Crop,
			ZIndex = 12,
			Parent = canvasGroup,
		})
		mapBg.ImageTransparency = 0.3

		-- Контейнер для названия и кнопки
		local mapInfoFrame = Instance.new("Frame")
		mapInfoFrame.Name = "Frame"
		mapInfoFrame.Size = UDim2.new(1, 0, 0.4, 0)
		mapInfoFrame.Position = UDim2.new(0, 0, 0.6, 0)
		mapInfoFrame.BackgroundTransparency = 1
		mapInfoFrame.ZIndex = 13
		mapInfoFrame.Parent = canvasGroup

		createText({
			Name = "MapName",
			Text = mapData.Text,
			Size = UDim2.new(0.9, 0, 0.4, 0),
			Position = UDim2.new(0.5, 0, 0.15, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			TextColor3 = mapData.Color,
			Font = Enum.Font.GothamBlack,
			ZIndex = 14,
			Parent = mapInfoFrame,
		})

		local selectBtn = createButton({
			Name = mapData.Name .. "Btn",
			Size = UDim2.new(0.7, 0, 0.35, 0),
			Position = UDim2.new(0.5, 0, 0.85, 0),
			AnchorPoint = Vector2.new(0.5, 1),
			Text = "SELECT",
			BackgroundColor3 = mapData.Color,
			TextColor3 = C.TextPrimary,
			Font = Enum.Font.GothamBold,
			CornerRadius = 0.15,
			ZIndex = 14,
			Parent = mapInfoFrame,
		})
		addHover(selectBtn)
	end

	---------------------------------------------------------------------------
	-- PartyPlayersTemplate (в Templates)
	---------------------------------------------------------------------------
	local templatesFolder = ReplicatedStorage:FindFirstChild("Templates")
	if not templatesFolder then
		templatesFolder = Instance.new("Folder")
		templatesFolder.Name = "Templates"
		templatesFolder.Parent = ReplicatedStorage
	end

	local oldPPT = templatesFolder:FindFirstChild("PartyPlayersTemplate")
	if oldPPT then oldPPT:Destroy() end

	local ppt = Instance.new("Frame")
	ppt.Name = "PartyPlayersTemplate"
	ppt.Size = UDim2.new(0.95, 0, 0.2, 0)
	ppt.BackgroundColor3 = C.BgCard
	ppt.BackgroundTransparency = 0.15
	ppt.BorderSizePixel = 0
	ppt.Visible = false
	ppt.ZIndex = 14
	ppt.Parent = templatesFolder
	createCorner(ppt, 0.08)
	createStroke(ppt, Color3.fromRGB(45, 45, 75), 1, 0.5)

	-- Аватар
	local playerImage = createImage({
		Name = "PlayerImage",
		Size = UDim2.new(0.1, 0, 0.75, 0),
		Position = UDim2.new(0.03, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Image = "",
		ZIndex = 15,
		Parent = ppt,
	})
	createCorner(playerImage, 0.2)

	-- Имя
	createText({
		Name = "PlayerName",
		Text = "PlayerName",
		Size = UDim2.new(0.4, 0, 0.4, 0),
		Position = UDim2.new(0.15, 0, 0.15, 0),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 15,
		Parent = ppt,
	})

	-- Уровень
	createText({
		Name = "PlayerLevel",
		Text = "Lvl: 1",
		Size = UDim2.new(0.2, 0, 0.3, 0),
		Position = UDim2.new(0.15, 0, 0.58, 0),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 15,
		Parent = ppt,
	})

	-- Кик
	local kickBtn = createButton({
		Name = "KickButton",
		Size = UDim2.new(0.12, 0, 0.5, 0),
		Position = UDim2.new(0.96, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Text = "KICK",
		BackgroundColor3 = C.AccentRed,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		CornerRadius = 0.15,
		ZIndex = 16,
		Parent = ppt,
	})
	kickBtn.Visible = false
	addHover(kickBtn)

	print("[PartyUIBuilder]: UI создан.")
end

buildPartyUI()
