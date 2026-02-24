-- LocalScript: QuestUIBuilder
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
	AccentOrange = Color3.fromRGB(255, 160, 0),
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(180, 180, 200),
	TextMuted = Color3.fromRGB(100, 100, 130),
}

--------------------------------------------------------------------------------
-- СОЗДАНИЕ QUEST SLOT
--------------------------------------------------------------------------------

local function createQuestSlot(name, parent, zBase)
	local slot = Instance.new("Frame")
	slot.Name = name
	slot.Size = UDim2.new(0.95, 0, 0.28, 0)
	slot.BackgroundColor3 = C.BgCard
	slot.BackgroundTransparency = 0.15
	slot.BorderSizePixel = 0
	slot.Visible = false
	slot.ZIndex = zBase
	slot.Parent = parent
	createCorner(slot, 0.06)
	createStroke(slot, Color3.fromRGB(45, 45, 75), 1, 0.5)

	-- Полоса слева
	local sideBar = Instance.new("Frame")
	sideBar.Name = "SideBar"
	sideBar.Size = UDim2.new(0.008, 0, 0.7, 0)
	sideBar.Position = UDim2.new(0.015, 0, 0.5, 0)
	sideBar.AnchorPoint = Vector2.new(0, 0.5)
	sideBar.BackgroundColor3 = C.AccentBlue
	sideBar.BorderSizePixel = 0
	sideBar.ZIndex = zBase + 1
	sideBar.Parent = slot
	createCorner(sideBar, 0.4)

	-- Иконка квеста
	createText({
		Name = "QuestIcon",
		Text = "📋",
		Size = UDim2.new(0.06, 0, 0.5, 0),
		Position = UDim2.new(0.035, 0, 0.25, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Font = Enum.Font.GothamBlack,
		ZIndex = zBase + 1,
		Parent = slot,
	})

	-- Название квеста
	createText({
		Name = "NameQuest",
		Text = "Quest Name",
		Size = UDim2.new(0.5, 0, 0.3, 0),
		Position = UDim2.new(0.1, 0, 0.12, 0),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = zBase + 1,
		Parent = slot,
	})

	-- Прогресс текст
	createText({
		Name = "Progress",
		Text = "0 / 10",
		Size = UDim2.new(0.15, 0, 0.25, 0),
		Position = UDim2.new(0.1, 0, 0.72, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = zBase + 2,
		Parent = slot,
	})

	-- Прогресс бар
	local progressBar = Instance.new("Frame")
	progressBar.Name = "ProgressBar"
	progressBar.Size = UDim2.new(0.5, 0, 0.14, 0)
	progressBar.Position = UDim2.new(0.1, 0, 0.48, 0)
	progressBar.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
	progressBar.BorderSizePixel = 0
	progressBar.ZIndex = zBase + 1
	progressBar.Parent = slot
	createCorner(progressBar, 0.3)

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = C.AccentBlue
	fill.BorderSizePixel = 0
	fill.ZIndex = zBase + 2
	fill.ClipsDescendants = true
	fill.Parent = progressBar
	createCorner(fill, 0.3)
	createGradient(fill, ColorSequence.new({
		ColorSequenceKeypoint.new(0, C.AccentBlue),
		ColorSequenceKeypoint.new(1, C.AccentPurple),
	}), 0)

	-- Награды
	local rewardsFrame = Instance.new("Frame")
	rewardsFrame.Name = "RewardsFrame"
	rewardsFrame.Size = UDim2.new(0.25, 0, 0.7, 0)
	rewardsFrame.Position = UDim2.new(0.63, 0, 0.5, 0)
	rewardsFrame.AnchorPoint = Vector2.new(0, 0.5)
	rewardsFrame.BackgroundColor3 = C.BgLight
	rewardsFrame.BackgroundTransparency = 0.4
	rewardsFrame.BorderSizePixel = 0
	rewardsFrame.ZIndex = zBase + 1
	rewardsFrame.Parent = slot
	createCorner(rewardsFrame, 0.1)

	-- Rewards title
	createText({
		Name = "RewardsTitle",
		Text = "REWARDS",
		Size = UDim2.new(0.9, 0, 0.2, 0),
		Position = UDim2.new(0.5, 0, 0.05, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.GothamBold,
		ZIndex = zBase + 2,
		Parent = rewardsFrame,
	})

	-- XP reward
	local expRow = Instance.new("Frame")
	expRow.Name = "ExpRow"
	expRow.Size = UDim2.new(0.9, 0, 0.3, 0)
	expRow.Position = UDim2.new(0.5, 0, 0.3, 0)
	expRow.AnchorPoint = Vector2.new(0.5, 0)
	expRow.BackgroundTransparency = 1
	expRow.ZIndex = zBase + 2
	expRow.Parent = rewardsFrame

	createText({
		Name = "ExpIcon",
		Text = "⭐",
		Size = UDim2.new(0.25, 0, 0.8, 0),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		ZIndex = zBase + 3,
		Parent = expRow,
	})

	createText({
		Name = "AwardExp",
		Text = "+100",
		Size = UDim2.new(0.7, 0, 0.8, 0),
		Position = UDim2.new(0.28, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.AccentGold,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = zBase + 3,
		Parent = expRow,
	})

	-- Coins reward
	local coinRow = Instance.new("Frame")
	coinRow.Name = "CoinRow"
	coinRow.Size = UDim2.new(0.9, 0, 0.3, 0)
	coinRow.Position = UDim2.new(0.5, 0, 0.62, 0)
	coinRow.AnchorPoint = Vector2.new(0.5, 0)
	coinRow.BackgroundTransparency = 1
	coinRow.ZIndex = zBase + 2
	coinRow.Parent = rewardsFrame

	createText({
		Name = "CoinIcon",
		Text = "🪙",
		Size = UDim2.new(0.25, 0, 0.8, 0),
		Position = UDim2.new(0, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		ZIndex = zBase + 3,
		Parent = coinRow,
	})

	createText({
		Name = "AwardCoins",
		Text = "+50",
		Size = UDim2.new(0.7, 0, 0.8, 0),
		Position = UDim2.new(0.28, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.AccentGold,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = zBase + 3,
		Parent = coinRow,
	})

	-- Claim Button
	local claimBtn = createButton({
		Name = "ClaimQuestBtn",
		Size = UDim2.new(0.1, 0, 0.5, 0),
		Position = UDim2.new(0.96, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Text = "CLAIM",
		BackgroundColor3 = C.AccentGreen,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		CornerRadius = 0.15,
		ZIndex = zBase + 2,
		Parent = slot,
	})
	claimBtn.Visible = false
	createGradient(claimBtn, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 220, 100)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 160, 70)),
	}), 90)
	addHover(claimBtn)

	return slot
end

--------------------------------------------------------------------------------
-- ПОСТРОЕНИЕ
--------------------------------------------------------------------------------

local function buildQuestUI()
	local screenGui = playerGui:WaitForChild("MainGameGui", 30)
	if not screenGui then
		warn("[QuestUIBuilder]: MainGameGui не найден!")
		return
	end

	local oldQuest = screenGui:FindFirstChild("QuestFrame")
	if oldQuest then oldQuest:Destroy() end

	---------------------------------------------------------------------------
	-- QuestFrame
	---------------------------------------------------------------------------
	local questFrame = Instance.new("Frame")
	questFrame.Name = "QuestFrame"
	questFrame.Size = UDim2.new(0.5, 0, 0.6, 0)
	questFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	questFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	questFrame.BackgroundColor3 = C.BgDark
	questFrame.BorderSizePixel = 0
	questFrame.Visible = false
	questFrame.ZIndex = 10
	questFrame.ClipsDescendants = true
	questFrame.Parent = screenGui

	createCorner(questFrame, 0.02)
	createStroke(questFrame, Color3.fromRGB(60, 50, 100), 2, 0.3)
	createGradient(questFrame, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 8, 22)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 12, 35)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 6, 18)),
	}), 135)

	-- Блики
	for i = 1, 4 do
		local glow = Instance.new("Frame")
		glow.Name = "Glow_" .. i
		glow.Size = UDim2.new(0.12 + math.random() * 0.1, 0, 0.15 + math.random() * 0.1, 0)
		glow.Position = UDim2.new(math.random() * 0.7, 0, math.random() * 0.6, 0)
		glow.BackgroundColor3 = i % 2 == 0 and C.AccentPurple or C.AccentBlue
		glow.BackgroundTransparency = 0.93
		glow.BorderSizePixel = 0
		glow.ZIndex = 10
		glow.Parent = questFrame
		createCorner(glow, 0.5)
	end

	---------------------------------------------------------------------------
	-- HEADER
	---------------------------------------------------------------------------
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0.12, 0)
	header.Position = UDim2.new(0, 0, 0, 0)
	header.BackgroundColor3 = C.BgMedium
	header.BackgroundTransparency = 0.3
	header.BorderSizePixel = 0
	header.ZIndex = 15
	header.Parent = questFrame

	createGradient(header, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 18, 50)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 10, 28)),
	}), 0)

	local headerLine = Instance.new("Frame")
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

	createText({
		Name = "QuestIcon",
		Text = "📜",
		Size = UDim2.new(0.05, 0, 0.7, 0),
		Position = UDim2.new(0.03, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Font = Enum.Font.GothamBlack,
		ZIndex = 16,
		Parent = header,
	})

	createText({
		Name = "Title",
		Text = "QUESTS",
		Size = UDim2.new(0.2, 0, 0.45, 0),
		Position = UDim2.new(0.09, 0, 0.18, 0),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = header,
	})

	createText({
		Name = "Subtitle",
		Text = "Complete tasks to earn rewards",
		Size = UDim2.new(0.35, 0, 0.3, 0),
		Position = UDim2.new(0.09, 0, 0.6, 0),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = header,
	})

	-- Close button
	local closeButton = createButton({
		Name = "CloseButton",
		Size = UDim2.new(0.05, 0, 0.55, 0),
		Position = UDim2.new(0.97, 0, 0.5, 0),
		AnchorPoint = Vector2.new(1, 0.5),
		Text = "✕",
		BackgroundColor3 = C.AccentRed,
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		CornerRadius = 0.2,
		ZIndex = 17,
		Parent = header,
	})
	addHover(closeButton)

	---------------------------------------------------------------------------
	-- TAB BUTTONS
	---------------------------------------------------------------------------
	local tabBar = Instance.new("Frame")
	tabBar.Name = "TabBar"
	tabBar.Size = UDim2.new(0.94, 0, 0.08, 0)
	tabBar.Position = UDim2.new(0.5, 0, 0.14, 0)
	tabBar.AnchorPoint = Vector2.new(0.5, 0)
	tabBar.BackgroundTransparency = 1
	tabBar.BorderSizePixel = 0
	tabBar.ZIndex = 14
	tabBar.Parent = questFrame

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.FillDirection = Enum.FillDirection.Horizontal
	tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabLayout.Padding = UDim.new(0.015, 0)
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Parent = tabBar

	local tabs = {
		{Name = "DailyQuestsBtn", Text = "📅 DAILY", Order = 1, Color = C.AccentBlue},
		{Name = "WeeklyQuestsBtn", Text = "📆 WEEKLY", Order = 2, Color = C.AccentPurple},
		{Name = "EventQuestsBtn", Text = "🎉 EVENT", Order = 3, Color = C.AccentGold},
	}

	for _, tabData in ipairs(tabs) do
		local tabBtn = createButton({
			Name = tabData.Name,
			Size = UDim2.new(0.3, 0, 0.9, 0),
			Text = tabData.Text,
			BackgroundColor3 = Color3.fromRGB(60, 60, 60),
			TextColor3 = C.TextPrimary,
			Font = Enum.Font.GothamBold,
			CornerRadius = 0.15,
			ZIndex = 15,
			Parent = tabBar,
		})
		tabBtn.LayoutOrder = tabData.Order

		-- Счётчик уведомлений
		local counter = Instance.new("Frame")
		counter.Name = "Counter"
		counter.Size = UDim2.new(0.12, 0, 0.45, 0)
		counter.Position = UDim2.new(0.92, 0, 0.1, 0)
		counter.AnchorPoint = Vector2.new(0.5, 0)
		counter.BackgroundColor3 = C.AccentRed
		counter.BorderSizePixel = 0
		counter.Visible = false
		counter.ZIndex = 16
		counter.Parent = tabBtn
		createCorner(counter, 0.4)

		local counterText = createText({
			Name = "CounterText",
			Text = "0",
			Size = UDim2.new(0.9, 0, 0.9, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextColor3 = C.TextPrimary,
			Font = Enum.Font.GothamBlack,
			ZIndex = 17,
			Parent = counter,
		})

		addHover(tabBtn)
	end

	---------------------------------------------------------------------------
	-- QUEST CONTAINERS (3 контейнера по 3 слота)
	---------------------------------------------------------------------------
	local containerNames = {
		{Name = "DailyQuests", Visible = true},
		{Name = "WeeklyQuests", Visible = false},
		{Name = "EventQuests", Visible = false},
	}

	for _, cData in ipairs(containerNames) do
		local container = Instance.new("ScrollingFrame")
		container.Name = cData.Name
		container.Size = UDim2.new(0.96, 0, 0.68, 0)
		container.Position = UDim2.new(0.5, 0, 0.24, 0)
		container.AnchorPoint = Vector2.new(0.5, 0)
		container.BackgroundTransparency = 1
		container.BorderSizePixel = 0
		container.ScrollBarThickness = 3
		container.ScrollBarImageColor3 = C.AccentPurple
		container.ScrollBarImageTransparency = 0.4
		container.AutomaticCanvasSize = Enum.AutomaticSize.Y
		container.ScrollingDirection = Enum.ScrollingDirection.Y
		container.CanvasSize = UDim2.new(0, 0, 0, 0)
		container.Visible = cData.Visible
		container.ZIndex = 13
		container.Parent = questFrame

		local layout = Instance.new("UIListLayout")
		layout.FillDirection = Enum.FillDirection.Vertical
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout.Padding = UDim.new(0.02, 0)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent = container

		createPadding(container, 0.01, 0.01, 0, 0)

		-- 3 слота квестов
		for i = 1, 3 do
			local slot = createQuestSlot("Quest" .. i, container, 14)
			slot.LayoutOrder = i
		end

		-- Empty text
		createText({
			Name = "EmptyText",
			Text = "📋 No quests available",
			Size = UDim2.new(0.6, 0, 0.2, 0),
			Position = UDim2.new(0.5, 0, 0.4, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			TextColor3 = C.TextMuted,
			Font = Enum.Font.Gotham,
			ZIndex = 14,
			Parent = container,
		})
	end

	---------------------------------------------------------------------------
	-- BOTTOM BAR
	---------------------------------------------------------------------------
	local bottomBar = Instance.new("Frame")
	bottomBar.Name = "BottomBar"
	bottomBar.Size = UDim2.new(1, 0, 0.07, 0)
	bottomBar.Position = UDim2.new(0, 0, 0.93, 0)
	bottomBar.BackgroundColor3 = C.BgMedium
	bottomBar.BackgroundTransparency = 0.3
	bottomBar.BorderSizePixel = 0
	bottomBar.ZIndex = 15
	bottomBar.Parent = questFrame

	createGradient(bottomBar, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 10, 28)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 18, 45)),
	}), 0)

	local bottomLine = Instance.new("Frame")
	bottomLine.Size = UDim2.new(1, 0, 0.025, 0)
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

	createText({
		Name = "BottomInfo",
		Text = "🔄 Quests reset daily at midnight  •  Complete all for bonus rewards",
		Size = UDim2.new(0.9, 0, 0.7, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		ZIndex = 16,
		Parent = bottomBar,
	})

	---------------------------------------------------------------------------
	-- АНИМАЦИИ
	---------------------------------------------------------------------------
	for _, glow in ipairs(questFrame:GetChildren()) do
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

	print("[QuestUIBuilder]: UI создан.")
end

buildQuestUI()
