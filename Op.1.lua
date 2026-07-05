local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local function Create(className, properties)
    local inst = Instance.new(className)
    for k, v in pairs(properties or {}) do
        inst[k] = v
    end
    return inst
end

local function Tween(instance, properties, duration)
    local tween = TweenService:Create(instance, TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

local TargetGui = (pcall(function() return CoreGui.Name end) and CoreGui) or Players.LocalPlayer:WaitForChild("PlayerGui")

local MacUi = TargetGui:FindFirstChild("MacUi")
local MainFrame, AppsFrame, ScrollingApps, ToggleSidebarBtn, PopUpFrameContainer

if not MacUi then
    MacUi = Create("ScreenGui", {
        Name = "MacUi",
        Parent = TargetGui,
        SafeAreaCompatibility = Enum.SafeAreaCompatibility.None,
        IgnoreGuiInset = true,
        ScreenInsets = Enum.ScreenInsets.None,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = MacUi,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })

    AppsFrame = Create("Frame", {
        Name = "Apps",
        Parent = MainFrame,
        Size = UDim2.new(0, 62, 0, 500),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        BorderSizePixel = 0
    })

    ScrollingApps = Create("ScrollingFrame", {
        Parent = AppsFrame,
        Size = UDim2.new(0, 60, 0, 378),
        Position = UDim2.new(0, 6, 0, 16),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0)
    })

    Create("UIListLayout", {
        Parent = ScrollingApps,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    ToggleSidebarBtn = Create("TextButton", {
        Parent = AppsFrame,
        Size = UDim2.new(0, 22, 0, 64),
        Position = UDim2.new(0, 62, 0, 106),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.7,
        TextColor3 = Color3.fromRGB(28, 43, 54),
        Text = "<",
        BorderSizePixel = 0
    })

    PopUpFrameContainer = Create("Frame", {
        Name = "PopUpFrame",
        Parent = MainFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0
    })

    local sidebarOpen = true
    ToggleSidebarBtn.MouseButton1Click:Connect(function()
        sidebarOpen = not sidebarOpen
        Tween(AppsFrame, {Position = sidebarOpen and UDim2.new(0, 0, 0, 0) or UDim2.new(0, -62, 0, 0)}, 0.3)
        ToggleSidebarBtn.Text = sidebarOpen and "<" or ">"
    end)
else
    MainFrame = MacUi:FindFirstChild("MainFrame")
    AppsFrame = MainFrame:FindFirstChild("Apps")
    ScrollingApps = AppsFrame:FindFirstChildOfClass("ScrollingFrame")
    ToggleSidebarBtn = AppsFrame:FindFirstChildOfClass("TextButton")
    PopUpFrameContainer = MainFrame:FindFirstChild("PopUpFrame")
end

local MacLib = {}
MacLib.Windows = {}

function MacLib:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "Window"
    local IconText = config.Icon or "E"
    local WindowType = config.Type or "Lib" 
    local StartPos = config.Position or UDim2.new(0, 346, 0, 90)
    local WindowSize = config.Size or UDim2.new(0, 474, 0, 290)
    local ZIndex = config.ZIndex or 1

    local PopUp = Create("Frame", {
        Name = "PopUp",
        Parent = PopUpFrameContainer,
        Size = WindowSize,
        Position = StartPos,
        BackgroundTransparency = 1,
        ZIndex = ZIndex,
        ClipsDescendants = false
    })

    Create("UIDragDetector", {
        Parent = PopUp
    })

    local Bg = Create("Frame", {
        Name = "Bg",
        Parent = PopUp,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(204, 204, 204),
        ZIndex = ZIndex,
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = Bg})

    local TopBar = Create("Frame", {
        Name = "TopBar",
        Parent = PopUp,
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = ZIndex + 1,
        BorderSizePixel = 0
    })
    Create("UICorner", {Parent = TopBar})
    Create("Frame", {
        Parent = TopBar,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 0, 8),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        ZIndex = ZIndex + 1
    })

    local AppIcon = Create("Frame", {
        Parent = TopBar,
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundColor3 = Color3.fromRGB(169, 255, 135),
        ZIndex = ZIndex + 2
    })
    Create("UICorner", {Parent = AppIcon, CornerRadius = UDim.new(0, 4)})
    Create("TextLabel", {
        Parent = AppIcon,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = IconText,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Balthazar,
        TextSize = 12
    })

    Create("TextLabel", {
        Parent = TopBar,
        Size = UDim2.new(0, 200, 0, 14),
        Position = UDim2.new(0, 20, 0, 4),
        BackgroundTransparency = 1,
        Text = Title,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = ZIndex + 2
    })

    local TopButtons = Create("Frame", {
        Parent = TopBar,
        Size = UDim2.new(0, 72, 0, 20),
        Position = UDim2.new(1, -72, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = ZIndex + 2
    })

    local MinBtn = Create("TextButton", {
        Parent = TopButtons,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1,
        Text = "–",
        TextSize = 10
    })

    local MaxBtn = Create("TextButton", {
        Parent = TopButtons,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 32, 0, 0),
        BackgroundTransparency = 1,
        Text = "□",
        TextSize = 10
    })

    local CloseBtn = Create("TextButton", {
        Parent = TopButtons,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(0, 52, 0, 0),
        BackgroundTransparency = 1,
        Text = "X",
        TextSize = 10
    })

    local CloseConfirm = Create("Frame", {
        Parent = PopUp,
        Size = UDim2.new(0, 118, 0, 82),
        Position = UDim2.new(0.5, -59, 0.5, -41),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = ZIndex + 10,
        Visible = false
    })
    Create("UICorner", {Parent = CloseConfirm})
    
    Create("TextLabel", {
        Parent = CloseConfirm,
        Size = UDim2.new(0, 96, 0, 10),
        Position = UDim2.new(0, 6, 0, 6),
        BackgroundTransparency = 1,
        Text = "Close?",
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = ZIndex + 11
    })
    
    Create("TextLabel", {
        Parent = CloseConfirm,
        Size = UDim2.new(0, 96, 0, 42),
        Position = UDim2.new(0, 6, 0, 18),
        BackgroundTransparency = 1,
        Text = "Are you sure you want to close? Background tasks might still run.",
        TextWrapped = true,
        TextScaled = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = ZIndex + 11
    })

    local ConfirmYes = Create("TextButton", {
        Parent = CloseConfirm,
        Size = UDim2.new(0, 46, 0, 14),
        Position = UDim2.new(0, 6, 0, 62),
        BackgroundColor3 = Color3.fromRGB(255, 161, 155),
        Text = "Confirm",
        ZIndex = ZIndex + 11
    })
    Create("UICorner", {Parent = ConfirmYes})

    local ConfirmNo = Create("TextButton", {
        Parent = CloseConfirm,
        Size = UDim2.new(0, 46, 0, 14),
        Position = UDim2.new(0, 54, 0, 62),
        BackgroundColor3 = Color3.fromRGB(211, 211, 211),
        Text = "Cancel",
        ZIndex = ZIndex + 11
    })
    Create("UICorner", {Parent = ConfirmNo})

    local SidebarIcon
    
    local function CreateSidebarApp()
        if SidebarIcon then return end
        SidebarIcon = Create("Frame", {
            Parent = ScrollingApps,
            Size = UDim2.new(0, 50, 0, 50),
            BackgroundColor3 = Color3.fromRGB(169, 255, 135),
            BackgroundTransparency = 1
        })
        Create("UICorner", {Parent = SidebarIcon, CornerRadius = UDim.new(0, 4)})
        
        local IconTxt = Create("TextLabel", {
            Parent = SidebarIcon,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = IconText,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.Balthazar,
            TextSize = 30,
            TextTransparency = 1
        })
        
        local OpenBtn = Create("TextButton", {
            Parent = SidebarIcon,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = ""
        })

        Tween(SidebarIcon, {BackgroundTransparency = 0}, 0.3)
        Tween(IconTxt, {TextTransparency = 0}, 0.3)
        
        OpenBtn.MouseButton1Click:Connect(function()
            PopUp.Visible = true
            PopUp.Size = UDim2.new(0, 0, 0, 0)
            Tween(PopUp, {Size = WindowSize}, 0.3)
            Tween(SidebarIcon, {BackgroundTransparency = 1}, 0.2)
            Tween(IconTxt, {TextTransparency = 1}, 0.2)
            task.delay(0.2, function()
                SidebarIcon:Destroy()
                SidebarIcon = nil
            end)
        end)
    end

    MinBtn.MouseButton1Click:Connect(function()
        Tween(PopUp, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.delay(0.3, function()
            PopUp.Visible = false
            CreateSidebarApp()
        end)
    end)

    local isExpanded = false
    MaxBtn.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded
        if isExpanded then
            Tween(PopUp, {Size = UDim2.new(0, WindowSize.X.Offset * 1.5, 0, WindowSize.Y.Offset * 1.5)}, 0.3)
        else
            Tween(PopUp, {Size = WindowSize}, 0.3)
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        CloseConfirm.Visible = true
        CloseConfirm.Size = UDim2.new(0, 0, 0, 0)
        Tween(CloseConfirm, {Size = UDim2.new(0, 118, 0, 82)}, 0.2)
    end)

    ConfirmNo.MouseButton1Click:Connect(function()
        Tween(CloseConfirm, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
        task.delay(0.2, function() CloseConfirm.Visible = false end)
    end)

    ConfirmYes.MouseButton1Click:Connect(function()
        Tween(PopUp, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        if SidebarIcon then SidebarIcon:Destroy() end
        task.delay(0.3, function() PopUp:Destroy() end)
    end)

    PopUp.Size = UDim2.new(0, 0, 0, 0)
    Tween(PopUp, {Size = WindowSize}, 0.4)

    if WindowType == "Custom" then
        local CustomFrame = Create("Frame", {
            Name = "CustomFrame",
            Parent = PopUp,
            Size = UDim2.new(1, 0, 1, -20),
            Position = UDim2.new(0, 0, 0, 20),
            BackgroundTransparency = 1,
            ZIndex = ZIndex + 1
        })
        return CustomFrame
    end

    local LibFrame = Create("Frame", {
        Name = "LibFrame",
        Parent = PopUp,
        Size = UDim2.new(1, 0, 1, -20),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        ZIndex = ZIndex + 1
    })

    local TabsContainer = Create("ScrollingFrame", {
        Name = "Tabs",
        Parent = LibFrame,
        Size = UDim2.new(0, 52, 1, 0),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ZIndex = ZIndex + 2
    })
    
    Create("UIListLayout", {
        Parent = TabsContainer,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2)
    })

    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = LibFrame,
        Size = UDim2.new(1, -52, 1, 0),
        Position = UDim2.new(0, 52, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = ZIndex + 2
    })

    local WindowObj = {}
    local CurrentTab = nil

    function WindowObj:CreateTab(tabName, tabIconId)
        local TabBtnFrame = Create("Frame", {
            Parent = TabsContainer,
            Size = UDim2.new(0, 48, 0, 16),
            BackgroundTransparency = 1
        })

        local TabMain = Create("Frame", {
            Parent = TabBtnFrame,
            Size = UDim2.new(0, 44, 0, 12),
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            ZIndex = ZIndex + 3
        })
        Create("UICorner", {Parent = TabMain, CornerRadius = UDim.new(0, 4)})
        local Stroke = Create("UIStroke", {Parent = TabMain, Color = Color3.fromRGB(195, 255, 170), Transparency = 1})

        Create("ImageLabel", {
            Parent = TabMain,
            Size = UDim2.new(0, 8, 0, 8),
            Position = UDim2.new(0, 2, 0, 2),
            BackgroundTransparency = 1,
            Image = tabIconId or "rbxassetid://13060262529",
            ImageColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = ZIndex + 4
        })

        local TabBtn = Create("TextButton", {
            Parent = TabMain,
            Size = UDim2.new(0, 34, 0, 12),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = tabName,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 10,
            ZIndex = ZIndex + 5
        })

        local TabScroll = Create("ScrollingFrame", {
            Parent = ContentContainer,
            Size = UDim2.new(1, 0, 1, -4),
            Position = UDim2.new(0, 0, 0, 2),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            BorderSizePixel = 0,
            Visible = false,
            ZIndex = ZIndex + 3
        })
        Create("UIListLayout", {Parent = TabScroll, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})

        if not CurrentTab then
            TabScroll.Visible = true
            Stroke.Transparency = 0
            CurrentTab = TabScroll
        end

        TabBtn.MouseButton1Click:Connect(function()
            if CurrentTab then CurrentTab.Visible = false end
            for _, v in ipairs(TabsContainer:GetDescendants()) do
                if v:IsA("UIStroke") then Tween(v, {Transparency = 1}, 0.2) end
            end
            Tween(Stroke, {Transparency = 0}, 0.2)
            TabScroll.Visible = true
            CurrentTab = TabScroll
        end)

        local Elements = {}

        function Elements:CreateButton(name, callback)
            local BtnFrame = Create("Frame", {
                Parent = TabScroll,
                Size = UDim2.new(1, -10, 0, 22),
                BackgroundTransparency = 1
            })

            Create("TextLabel", {
                Parent = BtnFrame,
                Size = UDim2.new(0, 104, 1, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = ZIndex + 4
            })

            local VisualBtn = Create("Frame", {
                Parent = BtnFrame,
                Size = UDim2.new(0, 34, 0, 14),
                Position = UDim2.new(1, -40, 0, 4),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = ZIndex + 4
            })
            Create("UICorner", {Parent = VisualBtn})

            Create("TextLabel", {
                Parent = VisualBtn,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "Click",
                TextSize = 10,
                ZIndex = ZIndex + 5
            })

            local Clicker = Create("TextButton", {
                Parent = BtnFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = ZIndex + 6
            })

            Clicker.MouseButton1Down:Connect(function()
                Tween(VisualBtn, {BackgroundColor3 = Color3.fromRGB(200, 200, 200)}, 0.1)
            end)
            Clicker.MouseButton1Up:Connect(function()
                Tween(VisualBtn, {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
                if callback then pcall(callback) end
            end)
        end

        function Elements:CreateToggle(name, default, callback)
            local state = default or false
            local TogFrame = Create("Frame", {
                Parent = TabScroll,
                Size = UDim2.new(1, -10, 0, 22),
                BackgroundTransparency = 1
            })

            Create("TextLabel", {
                Parent = TogFrame,
                Size = UDim2.new(0, 104, 1, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = ZIndex + 4
            })

            local TogBar = Create("Frame", {
                Parent = TogFrame,
                Size = UDim2.new(0, 34, 0, 14),
                Position = UDim2.new(1, -40, 0, 4),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = ZIndex + 4
            })
            Create("UICorner", {Parent = TogBar})

            local Dot = Create("Frame", {
                Parent = TogBar,
                Size = UDim2.new(0, 18, 0, 18),
                Position = state and UDim2.new(0, 18, 0, -2) or UDim2.new(0, -2, 0, -2),
                BackgroundColor3 = state and Color3.fromRGB(118, 255, 3) or Color3.fromRGB(255, 151, 151),
                ZIndex = ZIndex + 5
            })
            Create("UICorner", {Parent = Dot})

            local Clicker = Create("TextButton", {
                Parent = TogFrame,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = "",
                ZIndex = ZIndex + 6
            })

            Clicker.MouseButton1Click:Connect(function()
                state = not state
                Tween(Dot, {
                    Position = state and UDim2.new(0, 18, 0, -2) or UDim2.new(0, -2, 0, -2),
                    BackgroundColor3 = state and Color3.fromRGB(118, 255, 3) or Color3.fromRGB(255, 151, 151)
                }, 0.2)
                if callback then pcall(callback, state) end
            end)
        end

        function Elements:CreateSlider(name, min, max, default, callback)
            local val = default or min
            local SldFrame = Create("Frame", {
                Parent = TabScroll,
                Size = UDim2.new(1, -10, 0, 32),
                BackgroundTransparency = 1
            })

            Create("TextLabel", {
                Parent = SldFrame,
                Size = UDim2.new(0, 104, 0, 22),
                BackgroundTransparency = 1,
                Text = name,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = ZIndex + 4
            })

            local Bar = Create("Frame", {
                Parent = SldFrame,
                Size = UDim2.new(1, -10, 0, 8),
                Position = UDim2.new(0, 0, 0, 22),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ZIndex = ZIndex + 4
            })
            Create("UICorner", {Parent = Bar})

            local percent = (val - min) / (max - min)
            local Dot = Create("Frame", {
                Parent = Bar,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(percent, -7, 0, -3),
                BackgroundColor3 = Color3.fromRGB(173, 255, 192),
                ZIndex = ZIndex + 5
            })
            Create("UICorner", {Parent = Dot})
            
            local ValLbl = Create("TextLabel", {
                Parent = Dot,
                Size = UDim2.new(1, 0, 1, -20),
                Position = UDim2.new(0, 0, 0, -15),
                BackgroundTransparency = 1,
                Text = tostring(val),
                TextSize = 10,
                ZIndex = ZIndex + 6
            })

            local dragging = false
            Dot.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = UserInputService:GetMouseLocation()
                    local relativePos = mousePos.X - Bar.AbsolutePosition.X
                    local newPercent = math.clamp(relativePos / Bar.AbsoluteSize.X, 0, 1)
                    val = math.floor(min + (max - min) * newPercent)
                    Tween(Dot, {Position = UDim2.new(newPercent, -7, 0, -3)}, 0.05)
                    ValLbl.Text = tostring(val)
                    if callback then pcall(callback, val) end
                end
            end)
        end

        return Elements
    end

    return WindowObj
end

return MacLib
