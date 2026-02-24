-- LocalScript: SearchPartyUIBuilder
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
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(radius or 0.05, 0)
	c.Parent = parent
	return c
end

local function createStroke(parent, color, thickness, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(255, 255, 255)
	s.Thickness = thickness or 1
	s.Transparency = transparency or 0.5
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local function createGradient(parent, colorSeq, rotation)
	local g = Instance.new("UIGradient")
	g.Color = colorSeq
	g.Rotation = rotation or 90
	g.Parent = parent
	return g
end

local function createPadding(parent, top, bottom, left, right)
	local p = Instance.new("UIPadding")
	p.PaddingTop = UDim.new(top or 0, 0)
	p.PaddingBottom = UDim.new(bottom or 0, 0)
	p.PaddingLeft = UDim.new(left or 0, 0)
	p.PaddingRight = UDim.new(right or 0, 0)
	p.Parent = parent
	return p
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
	i.ImageTransparency = props.ImageTransparency or 0
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

local function addHover(button, scaleMultiplier)
	scaleMultiplier = scaleMultiplier or 1.05
	local orig = button.Size
	local hover = UDim2.new(orig.X.Scale * scaleMultiplier, 0, orig.Y.Scale * scaleMultiplier, 0)
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
	AccentPurpleDark = Color3.fromRGB(90, 20, 180),
	AccentGreen = Color3.fromRGB(0, 200, 100),
	AccentRed = Color3.fromRGB(220, 50, 50),
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

local function buildSearchPartyUI()

	---------------------------------------------------------------------------
	-- 1. SearchPartyGui (ScreenGui)
	---------------------------------------------------------------------------
	local existingGui = playerGui:FindFirstChild("SearchPartyGui")
	if existingGui then existingGui:Destroy() end

	local searchPartyGui = Instance.new("ScreenGui")
	searchPartyGui.Name = "SearchPartyGui"
	searchPartyGui.ResetOnSpawn = false
	searchPartyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	searchPartyGui.IgnoreGuiInset = true
	searchPartyGui.Parent = playerGui

	---------------------------------------------------------------------------
	-- 2. SearchPartyFrame — главный фрейм
	---------------------------------------------------------------------------
	local searchFrame = Instance.new("Frame")
	searchFrame.Name = "SearchPartyFrame"
	searchFrame.Size = UDim2.new(0.55, 0, 0.65, 0)
	searchFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	searchFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	searchFrame.BackgroundColor3 = C.BgDark
	searchFrame.BorderSizePixel = 0
	searchFrame.Visible = false
	searchFrame.ZIndex = 10
	searchFrame.ClipsDescendants = true
	searchFrame.Parent = searchPartyGui

	createCorner(searchFrame, 0.02)
	createStroke(searchFrame, Color3.fromRGB(60, 50, 100), 2, 0.3)

	createGradient(searchFrame, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 8, 22)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 12, 35)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 6, 18)),
	}), 135)

	-- Декоративные блики
	for i = 1, 4 do
		local glow = Instance.new("Frame")
		glow.Name = "Glow_" .. i
		glow.Size = UDim2.new(0.12 + math.random() * 0.12, 0, 0.15 + math.random() * 0.15, 0)
		glow.Position = UDim2.new(math.random() * 0.7, 0, math.random() * 0.6, 0)
		glow.BackgroundColor3 = i % 2 == 0 and C.AccentPurple or C.AccentBlue
		glow.BackgroundTransparency = 0.93
		glow.BorderSizePixel = 0
		glow.ZIndex = 10
		glow.Parent = searchFrame
		createCorner(glow, 0.5)
	end

	---------------------------------------------------------------------------
	-- 3. HEADER
	---------------------------------------------------------------------------
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0.12, 0)
	header.Position = UDim2.new(0, 0, 0, 0)
	header.BackgroundColor3 = C.BgMedium
	header.BackgroundTransparency = 0.3
	header.BorderSizePixel = 0
	header.ZIndex = 15
	header.Parent = searchFrame

	createGradient(header, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 18, 50)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 10, 28)),
	}), 0)

	-- Линия акцента
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

	-- Иконка поиска
	createText({
		Name = "SearchIcon",
		Text = "🔍",
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
		Text = "SEARCH PARTY",
		Size = UDim2.new(0.35, 0, 0.45, 0),
		Position = UDim2.new(0.1, 0, 0.2, 0),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = header,
	})

	-- Подзаголовок
	createText({
		Name = "Subtitle",
		Text = "Find and join available parties",
		Size = UDim2.new(0.4, 0, 0.3, 0),
		Position = UDim2.new(0.1, 0, 0.6, 0),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = header,
	})

	-- Онлайн счётчик
	local onlineFrame = Instance.new("Frame")
	onlineFrame.Name = "OnlineFrame"
	onlineFrame.Size = UDim2.new(0.15, 0, 0.45, 0)
	onlineFrame.Position = UDim2.new(0.78, 0, 0.5, 0)
	onlineFrame.AnchorPoint = Vector2.new(0, 0.5)
	onlineFrame.BackgroundColor3 = C.BgLight
	onlineFrame.BackgroundTransparency = 0.4
	onlineFrame.BorderSizePixel = 0
	onlineFrame.ZIndex = 16
	onlineFrame.Parent = header
	createCorner(onlineFrame, 0.2)

	-- Зелёный индикатор
	local greenDot = Instance.new("Frame")
	greenDot.Name = "GreenDot"
	greenDot.Size = UDim2.new(0.12, 0, 0.35, 0)
	greenDot.Position = UDim2.new(0.08, 0, 0.5, 0)
	greenDot.AnchorPoint = Vector2.new(0, 0.5)
	greenDot.BackgroundColor3 = C.AccentGreen
	greenDot.BorderSizePixel = 0
	greenDot.ZIndex = 17
	greenDot.Parent = onlineFrame
	createCorner(greenDot, 0.5)

	createText({
		Name = "OnlineCount",
		Text = "0 Online",
		Size = UDim2.new(0.7, 0, 0.7, 0),
		Position = UDim2.new(0.25, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.AccentGreen,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 17,
		Parent = onlineFrame,
	})

	-- Кнопка «Назад»
	local backButton = createButton({
		Name = "BackButton",
		Size = UDim2.new(0.05, 0, 0.55, 0),
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
	-- 4. КОЛОНКИ ЗАГОЛОВКОВ (под хедером)
	---------------------------------------------------------------------------
	local columnsHeader = Instance.new("Frame")
	columnsHeader.Name = "ColumnsHeader"
	columnsHeader.Size = UDim2.new(0.96, 0, 0.06, 0)
	columnsHeader.Position = UDim2.new(0.5, 0, 0.14, 0)
	columnsHeader.AnchorPoint = Vector2.new(0.5, 0)
	columnsHeader.BackgroundColor3 = C.BgLight
	columnsHeader.BackgroundTransparency = 0.5
	columnsHeader.BorderSizePixel = 0
	columnsHeader.ZIndex = 14
	columnsHeader.Parent = searchFrame
	createCorner(columnsHeader, 0.15)

	-- Колонки
	local columns = {
		{Name = "ColLeader", Text = "👑 LEADER", Pos = 0.02, Size = 0.22, Align = Enum.TextXAlignment.Left},
		{Name = "ColPlayers", Text = "👥 MEMBERS", Pos = 0.26, Size = 0.14, Align = Enum.TextXAlignment.Center},
		{Name = "ColDiff", Text = "⚔ DIFFICULTY", Pos = 0.42, Size = 0.16, Align = Enum.TextXAlignment.Center},
		{Name = "ColLvl", Text = "📊 REQ. LVL", Pos = 0.6, Size = 0.14, Align = Enum.TextXAlignment.Center},
		{Name = "ColAction", Text = "", Pos = 0.78, Size = 0.2, Align = Enum.TextXAlignment.Center},
	}

	for _, col in ipairs(columns) do
		createText({
			Name = col.Name,
			Text = col.Text,
			Size = UDim2.new(col.Size, 0, 0.8, 0),
			Position = UDim2.new(col.Pos, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextColor3 = C.TextMuted,
			Font = Enum.Font.GothamBold,
			TextXAlignment = col.Align,
			ZIndex = 15,
			Parent = columnsHeader,
		})
	end

	---------------------------------------------------------------------------
	-- 5. СПИСОК ПАРТИЙ (PartyList — ScrollingFrame)
	---------------------------------------------------------------------------
	local partyList = Instance.new("ScrollingFrame")
	partyList.Name = "PartyList"
	partyList.Size = UDim2.new(0.96, 0, 0.7, 0)
	partyList.Position = UDim2.new(0.5, 0, 0.215, 0)
	partyList.AnchorPoint = Vector2.new(0.5, 0)
	partyList.BackgroundTransparency = 1
	partyList.BorderSizePixel = 0
	partyList.ScrollBarThickness = 4
	partyList.ScrollBarImageColor3 = C.AccentPurple
	partyList.ScrollBarImageTransparency = 0.3
	partyList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	partyList.ScrollingDirection = Enum.ScrollingDirection.Y
	partyList.ElasticBehavior = Enum.ElasticBehavior.Always
	partyList.CanvasSize = UDim2.new(0, 0, 0, 0)
	partyList.ZIndex = 13
	partyList.Parent = searchFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	listLayout.Padding = UDim.new(0.015, 0)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = partyList

	createPadding(partyList, 0.01, 0.01, 0, 0)

	-- Текст "Нет партий"
	local emptyText = createText({
		Name = "EmptyText",
		Text = "🔍 No parties found...\nCreate your own!",
		Size = UDim2.new(0.6, 0, 0.3, 0),
		Position = UDim2.new(0.5, 0, 0.35, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		ZIndex = 14,
		Parent = partyList,
	})

	---------------------------------------------------------------------------
	-- 6. НИЖНЯЯ ПАНЕЛЬ
	---------------------------------------------------------------------------
	local bottomBar = Instance.new("Frame")
	bottomBar.Name = "BottomBar"
	bottomBar.Size = UDim2.new(1, 0, 0.08, 0)
	bottomBar.Position = UDim2.new(0, 0, 0.92, 0)
	bottomBar.BackgroundColor3 = C.BgMedium
	bottomBar.BackgroundTransparency = 0.3
	bottomBar.BorderSizePixel = 0
	bottomBar.ZIndex = 15
	bottomBar.Parent = searchFrame

	createGradient(bottomBar, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 10, 28)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 18, 45)),
	}), 0)

	-- Верхняя линия
	local bottomLine = Instance.new("Frame")
	bottomLine.Size = UDim2.new(1, 0, 0.02, 0)
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

	-- Инфо текст
	createText({
		Name = "BottomInfo",
		Text = "💡 Click JOIN to enter a party  •  Max 4 players per party",
		Size = UDim2.new(0.65, 0, 0.7, 0),
		Position = UDim2.new(0.03, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = bottomBar,
	})

	-- Кнопка Refresh
	local refreshBtn = createButton({
		Name = "RefreshBtn",
		Size = UDim2.new(0.15, 0, 0.65, 0),
		Position = UDim2.new(0.96, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Text = "🔄 REFRESH",
		BackgroundColor3 = C.AccentBlue,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		CornerRadius = 0.15,
		ZIndex = 17,
		Parent = bottomBar,
	})

	createGradient(refreshBtn, ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.AccentBlue),
		ColorSequenceKeypoint.new(1, C.AccentBlueDark),
	}), 90)
	addHover(refreshBtn)

	---------------------------------------------------------------------------
	-- 7. PartyTemplate — шаблон строки в списке
	---------------------------------------------------------------------------
	local templatesFolder = ReplicatedStorage:FindFirstChild("Templates")
	if not templatesFolder then
		templatesFolder = Instance.new("Folder")
		templatesFolder.Name = "Templates"
		templatesFolder.Parent = ReplicatedStorage
	end

	local oldPartyTemplate = templatesFolder:FindFirstChild("PartyTemplate")
	if oldPartyTemplate then oldPartyTemplate:Destroy() end

	local partyTemplate = Instance.new("Frame")
	partyTemplate.Name = "PartyTemplate"
	partyTemplate.Size = UDim2.new(0.98, 0, 0.13, 0)
	partyTemplate.BackgroundColor3 = C.BgCard
	partyTemplate.BackgroundTransparency = 0.15
	partyTemplate.BorderSizePixel = 0
	partyTemplate.Visible = false
	partyTemplate.ZIndex = 14
	partyTemplate.Parent = templatesFolder
	createCorner(partyTemplate, 0.08)
	createStroke(partyTemplate, Color3.fromRGB(50, 50, 80), 1, 0.5)

	-- Левая цветная полоса (индикатор)
	local sideBar = Instance.new("Frame")
	sideBar.Name = "SideBar"
	sideBar.Size = UDim2.new(0.006, 0, 0.7, 0)
	sideBar.Position = UDim2.new(0.01, 0, 0.5, 0)
	sideBar.AnchorPoint = Vector2.new(0, 0.5)
	sideBar.BackgroundColor3 = C.AccentPurple
	sideBar.BorderSizePixel = 0
	sideBar.ZIndex = 15
	sideBar.Parent = partyTemplate
	createCorner(sideBar, 0.4)

	-------------------------------
	-- LeaderStats (аватар + имя)
	-------------------------------
	local leaderStats = Instance.new("Frame")
	leaderStats.Name = "LeaderStats"
	leaderStats.Size = UDim2.new(0.22, 0, 0.8, 0)
	leaderStats.Position = UDim2.new(0.025, 0, 0.5, 0)
	leaderStats.AnchorPoint = Vector2.new(0, 0.5)
	leaderStats.BackgroundTransparency = 1
	leaderStats.BorderSizePixel = 0
	leaderStats.ZIndex = 15
	leaderStats.Parent = partyTemplate

	-- Аватар лидера
	local leaderImageBg = Instance.new("Frame")
	leaderImageBg.Name = "LeaderImageBg"
	leaderImageBg.Size = UDim2.new(0.28, 0, 0.85, 0)
	leaderImageBg.Position = UDim2.new(0, 0, 0.5, 0)
	leaderImageBg.AnchorPoint = Vector2.new(0, 0.5)
	leaderImageBg.BackgroundColor3 = C.BgLight
	leaderImageBg.BackgroundTransparency = 0.3
	leaderImageBg.BorderSizePixel = 0
	leaderImageBg.ZIndex = 15
	leaderImageBg.Parent = leaderStats
	createCorner(leaderImageBg, 0.2)
	createStroke(leaderImageBg, C.AccentGold, 1.5, 0.4)

	local leaderImage = createImage({
		Name = "LeaderImage",
		Size = UDim2.new(0.85, 0, 0.85, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = "",
		ZIndex = 16,
		Parent = leaderImageBg,
	})
	createCorner(leaderImage, 0.15)

	-- Корона лидера
	createText({
		Name = "CrownIcon",
		Text = "👑",
		Size = UDim2.new(0.35, 0, 0.3, 0),
		Position = UDim2.new(0.85, 0, 0.05, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		ZIndex = 17,
		Parent = leaderImageBg,
	})

	-- Имя лидера
	createText({
		Name = "LeaderName",
		Text = "PlayerName",
		Size = UDim2.new(0.65, 0, 0.45, 0),
		Position = UDim2.new(0.32, 0, 0.15, 0),
		TextColor3 = C.AccentGold,
		Font = Enum.Font.GothamBlack,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = leaderStats,
	})

	-- "Party Leader" подпись
	createText({
		Name = "LeaderTag",
		Text = "Party Leader",
		Size = UDim2.new(0.5, 0, 0.3, 0),
		Position = UDim2.new(0.32, 0, 0.58, 0),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = leaderStats,
	})

	-------------------------------
	-- Счётчик участников
	-------------------------------
	local plrCountFrame = Instance.new("Frame")
	plrCountFrame.Name = "PlrCountFrame"
	plrCountFrame.Size = UDim2.new(0.14, 0, 0.55, 0)
	plrCountFrame.Position = UDim2.new(0.27, 0, 0.5, 0)
	plrCountFrame.AnchorPoint = Vector2.new(0, 0.5)
	plrCountFrame.BackgroundColor3 = C.BgLight
	plrCountFrame.BackgroundTransparency = 0.4
	plrCountFrame.BorderSizePixel = 0
	plrCountFrame.ZIndex = 15
	plrCountFrame.Parent = partyTemplate
	createCorner(plrCountFrame, 0.15)

	-- Иконки участников
	local playersIconsFrame = Instance.new("Frame")
	playersIconsFrame.Name = "PlayersIconsInParty"
	playersIconsFrame.Size = UDim2.new(0.55, 0, 0.75, 0)
	playersIconsFrame.Position = UDim2.new(0.05, 0, 0.5, 0)
	playersIconsFrame.AnchorPoint = Vector2.new(0, 0.5)
	playersIconsFrame.BackgroundTransparency = 1
	playersIconsFrame.BorderSizePixel = 0
	playersIconsFrame.ZIndex = 16
	playersIconsFrame.Parent = plrCountFrame

	local iconsLayout = Instance.new("UIListLayout")
	iconsLayout.FillDirection = Enum.FillDirection.Horizontal
	iconsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	iconsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	iconsLayout.Padding = UDim.new(0.02, 0)
	iconsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	iconsLayout.Parent = playersIconsFrame

	-- Шаблон иконки участника
	local iconTemplate = createImage({
		Name = "ImageLabel",
		Size = UDim2.new(0.3, 0, 0.9, 0),
		Image = "",
		ZIndex = 17,
		Parent = playersIconsFrame,
	})
	iconTemplate.Visible = false
	createCorner(iconTemplate, 0.3)

	-- Текст счётчика
	local plrInParty = createText({
		Name = "PlrInParty",
		Text = "(1/4)",
		Size = UDim2.new(0.4, 0, 0.7, 0),
		Position = UDim2.new(0.6, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.GothamBold,
		ZIndex = 16,
		Parent = plrCountFrame,
	})

	-------------------------------
	-- Difficulty Badge
	-------------------------------
	local diffBadge = Instance.new("Frame")
	diffBadge.Name = "DiffBadge"
	diffBadge.Size = UDim2.new(0.14, 0, 0.5, 0)
	diffBadge.Position = UDim2.new(0.44, 0, 0.5, 0)
	diffBadge.AnchorPoint = Vector2.new(0, 0.5)
	diffBadge.BackgroundColor3 = C.AccentGreen
	diffBadge.BackgroundTransparency = 0.2
	diffBadge.BorderSizePixel = 0
	diffBadge.ZIndex = 15
	diffBadge.Parent = partyTemplate
	createCorner(diffBadge, 0.2)

	local difficultyLabel = createText({
		Name = "DifficultyLabel",
		Text = "Easy",
		Size = UDim2.new(0.9, 0, 0.8, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		ZIndex = 16,
		Parent = diffBadge,
	})

	-------------------------------
	-- Level Requirement
	-------------------------------
	local lvlFrame = Instance.new("Frame")
	lvlFrame.Name = "LvlFrame"
	lvlFrame.Size = UDim2.new(0.1, 0, 0.5, 0)
	lvlFrame.Position = UDim2.new(0.61, 0, 0.5, 0)
	lvlFrame.AnchorPoint = Vector2.new(0, 0.5)
	lvlFrame.BackgroundColor3 = C.BgLight
	lvlFrame.BackgroundTransparency = 0.4
	lvlFrame.BorderSizePixel = 0
	lvlFrame.ZIndex = 15
	lvlFrame.Parent = partyTemplate
	createCorner(lvlFrame, 0.2)

	-- Иконка уровня
	createText({
		Name = "LvlIcon",
		Text = "📊",
		Size = UDim2.new(0.35, 0, 0.6, 0),
		Position = UDim2.new(0.08, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		ZIndex = 16,
		Parent = lvlFrame,
	})

	local lvlRequire = createText({
		Name = "LvlRequire",
		Text = "Lvl: 1",
		Size = UDim2.new(0.55, 0, 0.6, 0),
		Position = UDim2.new(0.42, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = lvlFrame,
	})

	-------------------------------
	-- JOIN Button
	-------------------------------
	local joinBtn = createButton({
		Name = "JoinToPartyButton",
		Size = UDim2.new(0.16, 0, 0.55, 0),
		Position = UDim2.new(0.96, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Text = "⚡ JOIN",
		BackgroundColor3 = C.AccentGreen,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		CornerRadius = 0.15,
		ZIndex = 16,
		Parent = partyTemplate,
	})

	createGradient(joinBtn, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 210, 100)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 160, 70)),
	}), 90)

	---------------------------------------------------------------------------
	-- 8. PartyPlayersTemplate — шаблон участника в пати
	---------------------------------------------------------------------------
	local oldPPT = templatesFolder:FindFirstChild("PartyPlayersTemplate")
	if oldPPT then oldPPT:Destroy() end

	local partyPlayersTemplate = Instance.new("Frame")
	partyPlayersTemplate.Name = "PartyPlayersTemplate"
	partyPlayersTemplate.Size = UDim2.new(0.95, 0, 0.18, 0)
	partyPlayersTemplate.BackgroundColor3 = C.BgCard
	partyPlayersTemplate.BackgroundTransparency = 0.15
	partyPlayersTemplate.BorderSizePixel = 0
	partyPlayersTemplate.Visible = false
	partyPlayersTemplate.ZIndex = 14
	partyPlayersTemplate.Parent = templatesFolder
	createCorner(partyPlayersTemplate, 0.08)
	createStroke(partyPlayersTemplate, Color3.fromRGB(45, 45, 75), 1, 0.5)

	-- Аватар участника
	local playerImageBg = Instance.new("Frame")
	playerImageBg.Name = "PlayerImageBg"
	playerImageBg.Size = UDim2.new(0.08, 0, 0.75, 0)
	playerImageBg.Position = UDim2.new(0.02, 0, 0.5, 0)
	playerImageBg.AnchorPoint = Vector2.new(0, 0.5)
	playerImageBg.BackgroundColor3 = C.BgLight
	playerImageBg.BackgroundTransparency = 0.3
	playerImageBg.BorderSizePixel = 0
	playerImageBg.ZIndex = 15
	playerImageBg.Parent = partyPlayersTemplate
	createCorner(playerImageBg, 0.15)

	local playerImage = createImage({
		Name = "PlayerImage",
		Size = UDim2.new(0.85, 0, 0.85, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = "",
		ZIndex = 16,
		Parent = playerImageBg,
	})
	createCorner(playerImage, 0.15)

	-- Имя игрока
	createText({
		Name = "PlayerName",
		Text = "PlayerName",
		Size = UDim2.new(0.35, 0, 0.4, 0),
		Position = UDim2.new(0.12, 0, 0.18, 0),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = partyPlayersTemplate,
	})

	-- Уровень игрока
	createText({
		Name = "PlayerLevel",
		Text = "Lvl: 1",
		Size = UDim2.new(0.15, 0, 0.3, 0),
		Position = UDim2.new(0.12, 0, 0.58, 0),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = partyPlayersTemplate,
	})

	-- Кнопка Kick
	local kickBtn = createButton({
		Name = "KickButton",
		Size = UDim2.new(0.1, 0, 0.5, 0),
		Position = UDim2.new(0.96, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Text = "KICK",
		BackgroundColor3 = C.AccentRed,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		CornerRadius = 0.15,
		ZIndex = 16,
		Parent = partyPlayersTemplate,
	})
	kickBtn.Visible = false

	---------------------------------------------------------------------------
	-- 9. InvitePlrTemplate — шаблон приглашения
	---------------------------------------------------------------------------
	local oldInvite = templatesFolder:FindFirstChild("InvitePlrTemplate")
	if oldInvite then oldInvite:Destroy() end

	local inviteTemplate = Instance.new("TextButton")
	inviteTemplate.Name = "InvitePlrTemplate"
	inviteTemplate.Size = UDim2.new(0.95, 0, 0.12, 0)
	inviteTemplate.BackgroundColor3 = C.BgCard
	inviteTemplate.BackgroundTransparency = 0.15
	inviteTemplate.BorderSizePixel = 0
	inviteTemplate.Text = ""
	inviteTemplate.AutoButtonColor = true
	inviteTemplate.Visible = false
	inviteTemplate.ZIndex = 20
	inviteTemplate.Parent = templatesFolder
	createCorner(inviteTemplate, 0.1)
	createStroke(inviteTemplate, Color3.fromRGB(45, 45, 75), 1, 0.5)

	-- Hover полоса
	local inviteSideBar = Instance.new("Frame")
	inviteSideBar.Name = "SideBar"
	inviteSideBar.Size = UDim2.new(0.005, 0, 0.65, 0)
	inviteSideBar.Position = UDim2.new(0.01, 0, 0.5, 0)
	inviteSideBar.AnchorPoint = Vector2.new(0, 0.5)
	inviteSideBar.BackgroundColor3 = C.AccentBlue
	inviteSideBar.BorderSizePixel = 0
	inviteSideBar.ZIndex = 21
	inviteSideBar.Parent = inviteTemplate
	createCorner(inviteSideBar, 0.4)

	-- Аватар
	local inviteIcon = createImage({
		Name = "iconInvitePlr",
		Size = UDim2.new(0.07, 0, 0.75, 0),
		Position = UDim2.new(0.03, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Image = "",
		ZIndex = 21,
		Parent = inviteTemplate,
	})
	createCorner(inviteIcon, 0.2)

	-- Имя
	createText({
		Name = "NameInvitePlr",
		Text = "PlayerName",
		Size = UDim2.new(0.35, 0, 0.4, 0),
		Position = UDim2.new(0.12, 0, 0.15, 0),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 21,
		Parent = inviteTemplate,
	})

	-- Уровень
	createText({
		Name = "lvlInvitePlr",
		Text = "Lvl: 1",
		Size = UDim2.new(0.15, 0, 0.3, 0),
		Position = UDim2.new(0.12, 0, 0.58, 0),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 21,
		Parent = inviteTemplate,
	})

	-- "INVITE" текст справа
	createText({
		Name = "InviteText",
		Text = "📨 INVITE",
		Size = UDim2.new(0.15, 0, 0.5, 0),
		Position = UDim2.new(0.95, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		TextColor3 = C.AccentBlue,
		Font = Enum.Font.GothamBlack,
		ZIndex = 21,
		Parent = inviteTemplate,
	})

	---------------------------------------------------------------------------
	-- 10. АНИМАЦИЯ БЛИКОВ
	---------------------------------------------------------------------------
	for _, glow in ipairs(searchFrame:GetChildren()) do
		if glow.Name:match("^Glow_") then
			local origPos = glow.Position
			task.spawn(function()
				while glow.Parent do
					local dur = 4 + math.random() * 4
					TweenService:Create(glow, TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
						Position = UDim2.new(
							origPos.X.Scale + (math.random() - 0.5) * 0.05, 0,
							origPos.Y.Scale + (math.random() - 0.5) * 0.04, 0
						),
						BackgroundTransparency = 0.9 + math.random() * 0.06
					}):Play()
					task.wait(dur)
				end
			end)
		end
	end

	-- Пульсация зелёного индикатора
	task.spawn(function()
		while greenDot.Parent do
			TweenService:Create(greenDot, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				BackgroundTransparency = 0.4
			}):Play()
			task.wait(1)
			TweenService:Create(greenDot, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				BackgroundTransparency = 0
			}):Play()
			task.wait(1)
		end
	end)

	-- Обновление счётчика онлайн
	task.spawn(function()
		while searchFrame.Parent do
			local count = #Players:GetPlayers()
			local onlineLabel = onlineFrame:FindFirstChild("OnlineCount")
			if onlineLabel then
				onlineLabel.Text = count .. " Online"
			end
			task.wait(5)
		end
	end)

	print("[SearchPartyUIBuilder]: UI создан (Scale only).")
end

buildSearchPartyUI()
