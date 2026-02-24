-- LocalScript: TabMenuUIBuilder
-- Размещение: StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

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
	AccentPurple = Color3.fromRGB(150, 50, 255),
	AccentGreen = Color3.fromRGB(0, 200, 100),
	TextPrimary = Color3.fromRGB(255, 255, 255),
	TextSecondary = Color3.fromRGB(180, 180, 200),
	TextMuted = Color3.fromRGB(100, 100, 130),
	LocalPlayerBg = Color3.fromRGB(40, 35, 65),
}

--------------------------------------------------------------------------------
-- ПОСТРОЕНИЕ
--------------------------------------------------------------------------------

local function buildTabMenuUI()
	local existingGui = playerGui:FindFirstChild("TabGui")
	if existingGui then existingGui:Destroy() end

	---------------------------------------------------------------------------
	-- TabGui (ScreenGui)
	---------------------------------------------------------------------------
	local tabGui = Instance.new("ScreenGui")
	tabGui.Name = "TabGui"
	tabGui.ResetOnSpawn = false
	tabGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	tabGui.IgnoreGuiInset = true
	tabGui.Enabled = false
	tabGui.Parent = playerGui

	---------------------------------------------------------------------------
	-- Основной контейнер
	---------------------------------------------------------------------------
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0.35, 0, 0.55, 0)
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.BackgroundColor3 = C.BgDark
	mainFrame.BorderSizePixel = 0
	mainFrame.ZIndex = 10
	mainFrame.ClipsDescendants = true
	mainFrame.Parent = tabGui

	createCorner(mainFrame, 0.02)
	createStroke(mainFrame, Color3.fromRGB(60, 50, 100), 2, 0.3)
	createGradient(mainFrame, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 8, 22)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(18, 12, 35)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 6, 18)),
	}), 135)

	-- Декоративные блики
	for i = 1, 3 do
		local glow = Instance.new("Frame")
		glow.Name = "Glow_" .. i
		glow.Size = UDim2.new(0.15 + math.random() * 0.1, 0, 0.15 + math.random() * 0.1, 0)
		glow.Position = UDim2.new(math.random() * 0.7, 0, math.random() * 0.6, 0)
		glow.BackgroundColor3 = i % 2 == 0 and C.AccentPurple or C.AccentBlue
		glow.BackgroundTransparency = 0.94
		glow.BorderSizePixel = 0
		glow.ZIndex = 10
		glow.Parent = mainFrame
		createCorner(glow, 0.5)
	end

	---------------------------------------------------------------------------
	-- HEADER — 14%
	---------------------------------------------------------------------------
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0.12, 0)
	header.Position = UDim2.new(0, 0, 0, 0)
	header.BackgroundColor3 = C.BgMedium
	header.BackgroundTransparency = 0.3
	header.BorderSizePixel = 0
	header.ZIndex = 15
	header.Parent = mainFrame

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

	-- Иконка
	createText({
		Name = "TabIcon",
		Text = "👥",
		Size = UDim2.new(0.07, 0, 0.7, 0),
		Position = UDim2.new(0.03, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		Font = Enum.Font.GothamBlack,
		ZIndex = 16,
		Parent = header,
	})

	-- Заголовок
	createText({
		Name = "Title",
		Text = "PLAYERS",
		Size = UDim2.new(0.3, 0, 0.5, 0),
		Position = UDim2.new(0.11, 0, 0.18, 0),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBlack,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = header,
	})

	-- Счётчик онлайн
	local onlineFrame = Instance.new("Frame")
	onlineFrame.Name = "OnlineFrame"
	onlineFrame.Size = UDim2.new(0.2, 0, 0.45, 0)
	onlineFrame.Position = UDim2.new(0.95, 0, 0.5, 0)
	onlineFrame.AnchorPoint = Vector2.new(1, 0.5)
	onlineFrame.BackgroundColor3 = C.BgLight
	onlineFrame.BackgroundTransparency = 0.4
	onlineFrame.BorderSizePixel = 0
	onlineFrame.ZIndex = 16
	onlineFrame.Parent = header
	createCorner(onlineFrame, 0.25)

	local greenDot = Instance.new("Frame")
	greenDot.Name = "GreenDot"
	greenDot.Size = UDim2.new(0.1, 0, 0.35, 0)
	greenDot.Position = UDim2.new(0.08, 0, 0.5, 0)
	greenDot.AnchorPoint = Vector2.new(0, 0.5)
	greenDot.BackgroundColor3 = C.AccentGreen
	greenDot.BorderSizePixel = 0
	greenDot.ZIndex = 17
	greenDot.Parent = onlineFrame
	createCorner(greenDot, 0.5)

	createText({
		Name = "OnlineCount",
		Text = "0 / 12",
		Size = UDim2.new(0.7, 0, 0.7, 0),
		Position = UDim2.new(0.24, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.AccentGreen,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 17,
		Parent = onlineFrame,
	})

	-- Подзаголовок
	createText({
		Name = "Subtitle",
		Text = "Hold TAB to view",
		Size = UDim2.new(0.3, 0, 0.3, 0),
		Position = UDim2.new(0.11, 0, 0.62, 0),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = header,
	})

	---------------------------------------------------------------------------
	-- КОЛОНКИ
	---------------------------------------------------------------------------
	local columnsHeader = Instance.new("Frame")
	columnsHeader.Name = "ColumnsHeader"
	columnsHeader.Size = UDim2.new(0.94, 0, 0.06, 0)
	columnsHeader.Position = UDim2.new(0.5, 0, 0.14, 0)
	columnsHeader.AnchorPoint = Vector2.new(0.5, 0)
	columnsHeader.BackgroundColor3 = C.BgLight
	columnsHeader.BackgroundTransparency = 0.5
	columnsHeader.BorderSizePixel = 0
	columnsHeader.ZIndex = 14
	columnsHeader.Parent = mainFrame
	createCorner(columnsHeader, 0.15)

	local cols = {
		{Name = "ColAvatar", Text = "", Pos = 0.02, Size = 0.1},
		{Name = "ColName", Text = "PLAYER", Pos = 0.14, Size = 0.4, Align = Enum.TextXAlignment.Left},
		{Name = "ColLevel", Text = "LEVEL", Pos = 0.7, Size = 0.25, Align = Enum.TextXAlignment.Center},
	}

	for _, col in ipairs(cols) do
		createText({
			Name = col.Name,
			Text = col.Text,
			Size = UDim2.new(col.Size, 0, 0.8, 0),
			Position = UDim2.new(col.Pos, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			TextColor3 = C.TextMuted,
			Font = Enum.Font.GothamBold,
			TextXAlignment = col.Align or Enum.TextXAlignment.Center,
			ZIndex = 15,
			Parent = columnsHeader,
		})
	end

	---------------------------------------------------------------------------
	-- TabList (ScrollingFrame)
	---------------------------------------------------------------------------
	local tabList = Instance.new("ScrollingFrame")
	tabList.Name = "TabList"
	tabList.Size = UDim2.new(0.94, 0, 0.73, 0)
	tabList.Position = UDim2.new(0.5, 0, 0.215, 0)
	tabList.AnchorPoint = Vector2.new(0.5, 0)
	tabList.BackgroundTransparency = 1
	tabList.BorderSizePixel = 0
	tabList.ScrollBarThickness = 3
	tabList.ScrollBarImageColor3 = C.AccentPurple
	tabList.ScrollBarImageTransparency = 0.3
	tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabList.ScrollingDirection = Enum.ScrollingDirection.Y
	tabList.ElasticBehavior = Enum.ElasticBehavior.Always
	tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabList.Active = true
	tabList.ScrollingEnabled = true
	tabList.ZIndex = 13
	tabList.Parent = mainFrame

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.Padding = UDim.new(0.012, 0)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = tabList

	createPadding(tabList, 0.008, 0.008, 0, 0)

	---------------------------------------------------------------------------
	-- НИЖНЯЯ ПАНЕЛЬ
	---------------------------------------------------------------------------
	local bottomBar = Instance.new("Frame")
	bottomBar.Name = "BottomBar"
	bottomBar.Size = UDim2.new(1, 0, 0.06, 0)
	bottomBar.Position = UDim2.new(0, 0, 0.94, 0)
	bottomBar.BackgroundColor3 = C.BgMedium
	bottomBar.BackgroundTransparency = 0.3
	bottomBar.BorderSizePixel = 0
	bottomBar.ZIndex = 15
	bottomBar.Parent = mainFrame

	createGradient(bottomBar, ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 10, 28)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 18, 45)),
	}), 0)

	local bottomLine = Instance.new("Frame")
	bottomLine.Size = UDim2.new(1, 0, 0.03, 0)
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
		Text = "Press TAB to toggle  •  Player list updates automatically",
		Size = UDim2.new(0.9, 0, 0.7, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		ZIndex = 16,
		Parent = bottomBar,
	})

	---------------------------------------------------------------------------
	-- TabTemplate (в Templates)
	---------------------------------------------------------------------------
	local templatesFolder = ReplicatedStorage:FindFirstChild("Templates")
	if not templatesFolder then
		templatesFolder = Instance.new("Folder")
		templatesFolder.Name = "Templates"
		templatesFolder.Parent = ReplicatedStorage
	end

	local oldTemplate = templatesFolder:FindFirstChild("TabTemplate")
	if oldTemplate then oldTemplate:Destroy() end

	local tabTemplate = Instance.new("Frame")
	tabTemplate.Name = "TabTemplate"
	tabTemplate.Size = UDim2.new(0.98, 0, 0.1, 0)
	tabTemplate.BackgroundColor3 = C.BgCard
	tabTemplate.BackgroundTransparency = 0.2
	tabTemplate.BorderSizePixel = 0
	tabTemplate.Visible = false
	tabTemplate.ZIndex = 14
	tabTemplate.Parent = templatesFolder
	createCorner(tabTemplate, 0.1)
	createStroke(tabTemplate, Color3.fromRGB(45, 45, 75), 1, 0.6)

	-- Полоса слева (индикатор)
	local sideBar = Instance.new("Frame")
	sideBar.Name = "SideBar"
	sideBar.Size = UDim2.new(0.005, 0, 0.65, 0)
	sideBar.Position = UDim2.new(0.012, 0, 0.5, 0)
	sideBar.AnchorPoint = Vector2.new(0, 0.5)
	sideBar.BackgroundColor3 = C.AccentBlue
	sideBar.BorderSizePixel = 0
	sideBar.ZIndex = 15
	sideBar.Parent = tabTemplate
	createCorner(sideBar, 0.4)

	-- Аватар
	local avatarBg = Instance.new("Frame")
	avatarBg.Name = "AvatarBg"
	avatarBg.Size = UDim2.new(0.08, 0, 0.75, 0)
	avatarBg.Position = UDim2.new(0.03, 0, 0.5, 0)
	avatarBg.AnchorPoint = Vector2.new(0, 0.5)
	avatarBg.BackgroundColor3 = C.BgLight
	avatarBg.BackgroundTransparency = 0.3
	avatarBg.BorderSizePixel = 0
	avatarBg.ZIndex = 15
	avatarBg.Parent = tabTemplate
	createCorner(avatarBg, 0.2)
	createStroke(avatarBg, C.AccentBlue, 1, 0.5)

	local displayPlayer = createImage({
		Name = "DisplayPlayer",
		Size = UDim2.new(0.85, 0, 0.85, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = "",
		ZIndex = 16,
		Parent = avatarBg,
	})
	createCorner(displayPlayer, 0.15)

	-- Имя игрока
	local playerName = createText({
		Name = "PlayerName",
		Text = "PlayerName",
		Size = UDim2.new(0.45, 0, 0.45, 0),
		Position = UDim2.new(0.13, 0, 0.15, 0),
		TextColor3 = C.TextPrimary,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = tabTemplate,
	})

	-- UIGradient на имени (для подсветки локального игрока)
	local nameGradient = Instance.new("UIGradient")
	nameGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(220, 220, 240)),
	})
	nameGradient.Parent = playerName

	-- DisplayName/Username подпись
	createText({
		Name = "PlayerUsername",
		Text = "",
		Size = UDim2.new(0.35, 0, 0.3, 0),
		Position = UDim2.new(0.13, 0, 0.58, 0),
		TextColor3 = C.TextMuted,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 15,
		Parent = tabTemplate,
	})

	-- Бейдж уровня
	local levelBadge = Instance.new("Frame")
	levelBadge.Name = "LevelBadge"
	levelBadge.Size = UDim2.new(0.18, 0, 0.55, 0)
	levelBadge.Position = UDim2.new(0.78, 0, 0.5, 0)
	levelBadge.AnchorPoint = Vector2.new(0, 0.5)
	levelBadge.BackgroundColor3 = C.BgLight
	levelBadge.BackgroundTransparency = 0.3
	levelBadge.BorderSizePixel = 0
	levelBadge.ZIndex = 15
	levelBadge.Parent = tabTemplate
	createCorner(levelBadge, 0.2)

	-- Звезда уровня
	createText({
		Name = "LevelIcon",
		Text = "★",
		Size = UDim2.new(0.3, 0, 0.7, 0),
		Position = UDim2.new(0.05, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.AccentGold,
		Font = Enum.Font.GothamBlack,
		ZIndex = 16,
		Parent = levelBadge,
	})

	-- Текст уровня
	createText({
		Name = "PlayerLevel",
		Text = "LEVEL 1",
		Size = UDim2.new(0.6, 0, 0.6, 0),
		Position = UDim2.new(0.35, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0, 0.5),
		TextColor3 = C.TextSecondary,
		Font = Enum.Font.GothamBold,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 16,
		Parent = levelBadge,
	})

	---------------------------------------------------------------------------
	-- TAB INPUT (показ/скрытие)
	---------------------------------------------------------------------------
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if input.KeyCode == Enum.KeyCode.Tab then
			tabGui.Enabled = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.Tab then
			tabGui.Enabled = false
		end
	end)

	---------------------------------------------------------------------------
	-- АНИМАЦИИ
	---------------------------------------------------------------------------
	-- Блики
	for _, glow in ipairs(mainFrame:GetChildren()) do
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
						BackgroundTransparency = 0.91 + math.random() * 0.06
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

	-- Обновление счётчика
	task.spawn(function()
		while mainFrame.Parent do
			local count = #Players:GetPlayers()
			local onlineLabel = onlineFrame:FindFirstChild("OnlineCount")
			if onlineLabel then
				onlineLabel.Text = count .. " / 12"
			end
			task.wait(3)
		end
	end)

	print("[TabMenuUIBuilder]: UI создан.")
end

buildTabMenuUI()
