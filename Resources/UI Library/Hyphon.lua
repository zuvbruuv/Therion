--[[
    /------------ [ octohook.xyz ui library ] ------------\
    | fully by liamm#0223 (561301972293255180)            |
    | last modified 12/17/2022                            |
    | if used, give credit.                               |
    |                                                     |
    \-----------------------------------------------------/


    // -- Documentation -- \\

    option:set_enabled(enabled <boolean>)
    option:set_text(text <string>)

    -- menu
    local menu = library:create('menu', properties <table>)
    library.menu = menu

    text <string>
    size <udim2>
    position <udim2>

    -- tab
    local tab = menu:tab(properties <table>)

    text <string>
    order <number>

    -- section
    local section = tab:section(properties <table>)

    text <string>
    side <number>


    -- toggle
    local toggle = section:toggle(properties <table>)
    
    default <boolean>
    text <string>
    order <number>
    enabled <boolean>
    callback <function>
    

    -- slider
    local slider = section:slider(properties <table>)
    local slider = toggle:slider(properties <table>)
    
    default <number>
    min <number>
    max <number>
    increment <number>
    text <string>
    order <number>
    enabled <boolean>
    callback <function>


    -- colorpicker
    local colorpicker = section:colorpicker(properties <table>)
    local colorpicker = toggle:colorpicker(properties <table>)
    
    default <color3>
    default_opacity <number>
    text <string>
    order <number>
    enabled <boolean>
    callback <function> [color, opacity]


    -- keybind
    local keybind = section:keybind(properties <table>)
    local keybind = toggle:keybind(properties <table>)
    
    default <keycode> <userinputtype>
    mode <string> [toggle, hold, always]
    text <string>
    order <number>
    enabled <boolean>
    callback <function>


    -- textbox
    local textbox = section:textbox(properties <table>)
    local textbox = toggle:textbox(properties <table>)
    
    default <string>
    placeholder <string>
    text <string>
    order <number>
    enabled <boolean>
    callback <function>

    -- button
    local button = section:button(properties <table>)
    
    text <string>
    order <number>
    enabled <boolean>
    callback <function>

    -- separator
    local separator = section:separator(properties <table>)
    
    text <string>
    order <number>
    enabled <boolean>


    -- finishing up
    AFTER CREATING ALL YOUR OPTIONS, DO library.menu:refresh()

--]]

-- // load
local startup_args = ({...})[1] or {}
if library ~= nil then
    library:unload()
end

local themes = {
    ['default'] = {
        ['Accent']              = Color3.fromRGB(77, 160, 255),
        ['Background']          = Color3.fromRGB(15,15,20),
        ['Border']              = Color3.fromRGB(0,0,0),
        ['Border 1']            = Color3.fromRGB(10,10,15),
        ['Border 2']            = Color3.fromRGB(45,45,50),
        ['Border 3']            = Color3.fromRGB(35,35,40),
        ['Primary Text']        = Color3.fromRGB(240,240,240),
        ['Secondary Text']      = Color3.fromRGB(145, 145, 145),
        ['Group Background']    = Color3.fromRGB(20,20,25),
        ['Selected Tab']        = Color3.fromRGB(20,20,25),
        ['Unselected Tab']      = Color3.fromRGB(23,23,28),
        ['Selected Tab Text']   = Color3.fromRGB(240,240,240),
        ['Unselected Tab Text'] = Color3.fromRGB(145,145,145),
        ['Section Background']  = Color3.fromRGB(18,18,23),
        ['Option Text 1']       = Color3.fromRGB(235,235,235),
        ['Option Text 2']       = Color3.fromRGB(155,155,155),
        ['Option Border 1']     = Color3.fromRGB(45,45,50),
        ['Option Border 2']     = Color3.fromRGB(0,0,0),
        ['Option Background']   = Color3.fromRGB(31,31,34),
        ["Risky Text"]          = Color3.fromRGB(175, 21, 21),
        ["Risky Text Enabled"]  = Color3.fromRGB(255, 41, 41),
    }
}

-- // variables

-- globals
local vector3_new  = Vector3.new
local vector3_zero = Vector3.zero
local vector2_new  = Vector2.new
local vector2_zero = Vector2.zero
local cframe_new   = CFrame.new
local cframe_zero  = CFrame.zero
local color3_new   = Color3.new
local color3_hsv   = Color3.fromHSV
local color3_hex   = Color3.fromHex
local udim_new     = UDim.new
local udim2_new    = UDim2.new
local udim2_scale  = UDim2.fromScale
local udim2_offset = UDim2.fromOffset
local table_find   = table.find
local table_sort   = table.sort
local table_concat = table.concat
local table_insert = table.insert
local table_remove = table.remove
local table_clear  = table.clear
local math_clamp   = math.clamp
local math_floor   = math.floor
local math_ceil    = math.ceil
local math_huge    = math.huge
local math_max     = math.max
local math_min     = math.min
local math_sin     = math.sin
local math_cos     = math.cos
local math_abs     = math.abs 
local math_rad     = math.rad
local math_pi      = math.pi

-- locals
local inputservice    = game:GetService('UserInputService')
local actionservice   = game:GetService('ContextActionService')
local tweenservice    = game:GetService('TweenService')
local runservice      = game:GetService('RunService')
local http            = game:GetService('HttpService')
local stats           = game:GetService('Stats')
local camera          = workspace.CurrentCamera
local worldtoviewport = camera.WorldToViewportPoint

local library = {
    classes     = {},
    instances   = {},
    connections = {},
    hooks       = {},
    meta        = {},
    flags       = {},
    options     = {},
    rainbows    = {},
    notifs      = {},
    debugmode   = false,
    cheatname   = 'therion',
    gamename    = tostring(game.PlaceId),
    themes      = themes,
    theme       = themes.default,
    signal      = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/scotdotwtf/Hyphon-UI-Library-Reupload/main/signal.lua'))(),
    stat        = {fps = 0, ping = 0},
    drawings    = {
        active    = {},
        draggable = {},
        noparent  = {},
        objects   = {},
        raw       = {}
    },
    utility     = {
        table     = {},
        vector2   = {},
        vector3   = {},
        camera    = {},
        color     = {},
        string    = {}
    },
    images = {
        ["colorsat2"] = loadstring(game:HttpGet('https://raw.githubusercontent.com/zuvbruuv/Therion/refs/heads/main/Resources/Images/gradient_image.png')),
        ["colortrans"] = loadstring(game:HttpGet('https://raw.githubusercontent.com/zuvbruuv/Therion/refs/heads/main/Resources/Images/transbar_image.png')),
        ["colorsat1"] = loadstring(game:HttpGet('https://raw.githubusercontent.com/zuvbruuv/Therion/refs/heads/main/Resources/Images/white_image.png')),
        ["arrow_down"] = crypt.base64.decode("iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAABoSURBVDhP7dBBCsAgDETR6LHs/XutNtMxi4BI1Cz7oFQw+QvLoyRR7f80CF48niuq6nfrOSPqG/qUDe+5qfWMhwveLxnHDAY4FzKPGQxyfioWM1jg3tBazGCR+85ezCDAzucs9gsQeQHFvhGzmKvF1QAAAABJRU5ErkJggg=="),
        ["arrow_up"] = crypt.base64.decode("iVBORw0KGgoAAAANSUhEUgAAABQAAAALCAYAAAB/Ca1DAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABYSURBVDhPxc7RDsAQDIXh9v0feoYe2eipbST7LyiSL+SXDsuOYWo7rYf0zEa38JH9KkLpA8MQQ93LGYY8dLh4iqEevR3eYuiKtuErhoCWZRVDGdVdWE0kAV2EK/50sUCyAAAAAElFTkSuQmCC"),
        ["gradientp90"] = crypt.base64.decode("iVBORw0KGgoAAAANSUhEUgAAAfQAAAH0CAYAAADL1t+KAAAIGElEQVR4nO3XsW0gMQADQb6h0Nd/uy5CgfCLmQqYLfhv2zcA4L/283oAAHBP0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASDgbPtejwAA7njoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABBwtv2+HgEA3PHQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASDgbPtejwAA7njoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABBwtn2vRwAAdzx0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAg4277XIwCAOx46AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAScbb+vRwAAdzx0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAg4277XIwCAOx46AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAScbd/rEQDAHQ8dAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAALOtu/1CADgjocOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAF/H3kEen3kYGIAAAAASUVORK5CYII="),
        ["gradientn90"] = crypt.base64.decode("iVBORw0KGgoAAAANSUhEUgAAAfQAAAH0CAYAAADL1t+KAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAghSURBVHhe7ddRTQRADEDBXf4xgAAMYOAMIOAMnAEMIJ1NFhN9mUma1sFL91rr9wwAMNjb/wYABhN0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACNhnfu4JAEzlQweAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAgH3mdU8AYCofOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAE7DPPewIAU/nQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBgn/m+JwAwlQ8dAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAL2mcc9AYCpfOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAELDPfN0TAJjKhw4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAfvM5z0BgKl86AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQsM983BMAmMqHDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgAB+8z7PQGAqXzoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoADDeWn+9SAaeAvPCIQAAAABJRU5ErkJggg=="),
        ["gradientp45"] = crypt.base64.decode("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"),
        ["colorhue"] = loadstring(game:HttpGet('https://raw.githubusercontent.com/zuvbruuv/Therion/refs/heads/main/Resources/Images/rainbow_image.png'))
    }
}

local signal  = library.signal
local utility = library.utility
local camera  = workspace.CurrentCamera

local flags = library.flags
local options = library.options

local drawing_classes = {
    'Square',
    'Quad',
    'Triangle',
    'Circle',
    'Line',
    'Text'
}

-- // initalizations
do

    for i,v in next, startup_args do
        library[i] = v
    end

    makefolder(library.cheatname .. '/' .. library.gamename)
    makefolder(library.cheatname .. '/' .. library.gamename .. '/configs')

    library.mouse_strings = {
        [Enum.UserInputType.MouseButton1] = 'MB1',
        [Enum.UserInputType.MouseButton2] = 'MB2',
        [Enum.UserInputType.MouseButton3] = 'MB3',
    }
    
    library.key_strings = {
        [Enum.KeyCode.Space] = {' ', ' '},
        [Enum.KeyCode.Slash] = {'/', '?'},
        [Enum.KeyCode.BackSlash] = {'\\', '|'},
        [Enum.KeyCode.Period] = {'.', '>'},
        [Enum.KeyCode.Comma] = {',', '<'},
        [Enum.KeyCode.LeftBracket] = {'[', '{'},
        [Enum.KeyCode.RightBracket] = {']', '}'},
        [Enum.KeyCode.Quote] = {'\'', '"'},
        [Enum.KeyCode.Semicolon] = {';', ':'},
        [Enum.KeyCode.Backquote] = {'`', '~'},
        [Enum.KeyCode.Minus] = {'-', '_'},
        [Enum.KeyCode.Equals] = {'=', '+'},
        [Enum.KeyCode.One] = {'1', '!'},
        [Enum.KeyCode.Two] = {'2', '@'},
        [Enum.KeyCode.Three] = {'3', '#'},
        [Enum.KeyCode.Four] = {'4', '$'},
        [Enum.KeyCode.Five] = {'5', '%'},
        [Enum.KeyCode.Six] = {'6', '^'},
        [Enum.KeyCode.Seven] = {'7', '&'},
        [Enum.KeyCode.Eight] = {'8', '*'},
        [Enum.KeyCode.Nine] = {'9', '('},
        [Enum.KeyCode.Zero] = {'0', ')'},
    }
    
    library.blacklisted_keys = {
        Enum.KeyCode.LeftShift,
        Enum.KeyCode.RightShift,
        Enum.KeyCode.LeftControl,
        Enum.KeyCode.RightControl,
        Enum.KeyCode.LeftAlt,
        Enum.KeyCode.RightAlt,
        Enum.KeyCode.LeftSuper,
        Enum.KeyCode.RightSuper,
        Enum.KeyCode.CapsLock,
        Enum.KeyCode.Tab
    }

    if not startup_args.ignoreui then
        library.screengui = Instance.new('ScreenGui')
        library.screengui.Parent = gethui()

        local button = Instance.new('ImageButton')
        button.Parent = library.screengui
        button.Visible = true
        button.Modal = true
        button.Size = UDim2.new(1,0,1,0)
        button.ZIndex = math_huge
        button.Transparency = 1
    end

end

-- // functions
do
    
    -- library
    function library:unload()
        for i,v in next, self.hooks do v:Remove() end
        for i,v in next, self.connections do v:Disconnect() end
        for i,v in next, self.drawings.objects do v:Remove() end
        for i,v in next, self.drawings.raw do v:Remove() end
        for i,v in next, self.instances do v:Destroy() end
        if library.screengui then
            library.screengui:Destroy()
        end
        table_clear(library)
        getgenv().library = nil
    end

    function library:connection(signal, callback, tbl)
        local connection = signal:Connect(callback)
        table_insert(self.connections, connection)
        if tbl then table_insert(tbl, connection) end
        return connection
    end

    function library:hookmetamethod(object, metamethod, func)
        local original = hookmetamethod(object, metamethod, func)
        local hook = {}

        function hook:Remove()
            hookmetamethod(object, metamethod, function(...) return original(...) end)
            table_remove(library.hooks, table_find(library.hooks, hook))
            table_clear(hook)
        end

        function hook:SetFunction(func)
            assert(typeof(func) == 'function', ("invalid hook function type. expected 'function', got '%s'"):format(typeof(func)))
            hookmetamethod(object, metamethod, func)
        end

        table_insert(library.hooks, hook)
        return original, hook
    end

    function library:hookfunction(func, replacement)

        local replacement = function(...)
            return replacement(...)
        end

        local original = hookfunction(func, replacement)
        local hook = {
            _func = func,
            _original = original,
            _replacement = replacement
        }

        function hook:Remove()
            hookfunction(func, self._original)
            table_remove(library.hooks, table_find(library.hooks, hook))
            table_clear(hook)
        end

        function hook:SetFunction(newfunc)
            assert(typeof(newfunc) == 'function', ("invalid hook function type. expected 'function', got '%s'"):format(typeof(func)))
            hookmetamethod(func, newfunc)
        end

        table_insert(library.hooks, hook)
        return original, hook
    end

    function library:instance(class, properties)
        local inst = Instance.new(class)
        for i,v in next, properties or {} do 
            inst[i] = v
        end
        table_insert(self.instances, inst)
        return inst
    end
    
    function library:define(class, constructor, properties, meta)
        assert(typeof(class) == 'string', ("invalid class name. expected 'string', got '%s'"):format(typeof(class)))
        assert(typeof(constructor) == 'function' or table_find(drawing_classes, constructor), ("invalid constructor type. expected 'function', got '%s'"):format(typeof(constructor)))

        local object = {
            class = class,
            constructor = typeof(constructor) == 'function' and constructor or function(properties) local drawing = Drawing.new(class); for i,v in next, properties do drawing[i] = v end; return drawing end,
            default_properties = properties or {}
        }

        if meta then
            properties.__index = properties
        end

        self.classes[class] = object
        return object
    end

    function library:create(class, ...)
        assert(self.classes[class] or table_find(drawing_classes, class), ("class '%s' not found"):format(class))

        if table_find(drawing_classes, class) then
            local drawing = Drawing.new(class)
            for i,v in next, ({...})[1] or {} do
                drawing[i] = v
            end
            table_insert(library.drawings.raw, drawing)
            return drawing
        end

        local class_object = self.classes[class]
        return class_object.constructor(class_object.default_properties, ...)
    end

    function library:update_theme()
        for i,v in next, self.drawings.objects do
            if v.Theme == nil then continue end 
            v.Theme = v.Theme
        end
        for i,v in next, self.options do
            if v.class == 'colorpicker' and v.useaccent == true then
                v:set(library.theme.Accent, v.opacity)
            end
        end
    end

    function library:set_theme(theme)
        self.theme = self.themes[theme]
        self:update_theme()
    end

    function library:get_hover_object()
        table_sort(self.drawings.active, function(a,b)
            return a.ZIndex > b.ZIndex
        end)

        local mouse_position = inputservice:GetMouseLocation()
        for index, drawing in next, self.drawings.active do
            if drawing._object.Visible and utility.vector2.inside(mouse_position, drawing.AbsolutePosition, drawing.AbsoluteSize) then
                return drawing
            end
        end
    end

    function library:update_notifications()
        for i,v in next, self.notifs do
            utility:tween(v.objects.container, 'Position', udim2_new(0,5,0,100 + (i * 25)), 0.05)
        end
    end

    function library:notification(message, duration, color)
        local notification = {}
        notification.objects = library:create('notification')

        if color ~= nil then
            notification.objects.accent.Theme = {}
            notification.objects.accent.Color = color
            notification.objects.progress.Theme = {}
            notification.objects.progress.Color = color
        end
        
        function notification:set_message(message)
            self.objects.label.Text = message
            self.objects.background.Size = udim2_new(0, self.objects.label.TextBounds.X + 14, 0, 17)
        end

        function notification:remove()
            table_remove(library.notifs, table_find(library.notifs, notification))
            library:update_notifications()
            self.objects.container:Remove()
        end

        task.spawn(function()
            notification.objects.background.AnchorPoint = vector2_new(1,0)
            utility:tween(notification.objects.background, 'AnchorPoint', vector2_new(0,0), 0.15).Completed:Wait()
            utility:tween(notification.objects.progress, 'Size', udim2_new(1,0,0,1), duration or 5).Completed:Wait()
            utility:tween(notification.objects.background, 'AnchorPoint', vector2_new(1,0), 0.15)
        end)

        delay(0.15 + duration + 0.15, function()
            notification:remove()
        end)

        table_insert(library.notifs, notification)
        notification.objects.container.Position = udim2_new(0,5,0,100 + (table_find(library.notifs, notification) * 25))
        notification:set_message(message)
        library:update_notifications()
        return notification
    end

    -- configs
    function library:load_config(config)
        if typeof(config) == 'string' then
            local path = library.cheatname .. '/' .. library.gamename .. '/configs/' .. config .. '.txt'
            assert(isfile(path), ("unable to load config '%s' [invalid config]"):format(tostring(config)))
            config = http:JSONDecode(readfile(path))
        end

        for flag, value in next, config do
            xpcall(function()
                local option = library.options[flag]

                assert(option ~= nil, 'invalid option')

                if option.class == 'toggle' then
                    option:set_state(value)
                elseif option.class == 'slider' then
                    option:set_value(value)
                elseif option.class == 'colorpicker' then
                    local split = value:split('_')
                    option:set(Color3.fromHex(split[1]), tonumber(split[2]))
                    option.useaccent = split[3] == 'true'
                    option.rainbow = split[4] == 'true'
                    if split[4] == 'true' then
                        table.insert(library.rainbows, option)
                    end
                elseif option.class == 'dropdown' then
                    option:select(value)
                elseif option.class == 'textbox' then
                    option:set_text(option.text)
                elseif option.class == 'keybind' then
                    option:set_bind(utility.table.includes(Enum.KeyCode, value) and Enum.KeyCode[value] or utility.table.includes(Enum.UserInputType, value) and Enum.UserInputType[value])
                end
            end, function(err)
                library:notification(("unable to set '%s' to '%s' [%s]"):format(flag, typeof(value), tostring(err)), 5)
            end)
        end
    end

    function library:save_config(name, existscheck)

        local path = library.cheatname .. '/' .. library.gamename .. '/configs/' .. name .. '.txt'
        
        if existscheck then
            assert(isfile(path) == false, ("unable to create config '%s' [already exists]"):format(name))
        end

        if not table_find(options.configs_selected.values, name) then
            options.configs_selected:add_value(name)
        end

        local config = {}

        for flag, option in next, library.options do
            local value = library.flags[flag]
            if option.class == 'toggle' then
                config[flag] = option.state
            elseif option.class == 'slider' then
                config[flag] = option.value
            elseif option.class == 'keybind' then
                config[flag] = option.bind.Name
            elseif option.class == 'colorpicker' then
                config[flag] = tostring(option.color:ToHex()) .. '_' .. tostring(option.opacity) .. '_' .. tostring(option.useaccent) .. '_' tostring(option.rainbow)
            elseif option.class == 'dropdown' then
                config[flag] = option.selected
            elseif option.class == 'textbox' then
                config[flag] = option.text
            end
        end

        writefile(path, http:JSONEncode(config))

    end


    -- util
    function utility:getclipboard()
        local clipboard

        local textbox = Instance.new('TextBox')
        textbox.Parent = library.screengui
        textbox.TextTransparency = 1
        textbox.BackgroundTransparency = 1
        textbox:CaptureFocus()

        task.spawn(function()
            textbox:GetPropertyChangedSignal('Text'):Wait()
            clipboard = textbox.Text
        end)

        keypress(0x11)
        keypress(0x56)
        task.wait()
        keyrelease(0x11)
        keyrelease(0x56)
        repeat task.wait() until clipboard ~= nil
        textbox:Destroy()
        return clipboard
    end

    function utility:convert_number_range(value: number, min_old: number, max_old: number, min_new: number, max_new: number)
        return (((value - min_old) * (max_new - min_new)) / (max_old - min_old)) + min_new
    end

    function utility:udim2_to_vector2(udim2: UDim2, parent_size: Vector2)
        local x = udim2.X.Offset + udim2.X.Scale * parent_size.X
        local y = udim2.Y.Offset + udim2.Y.Scale * parent_size.Y
        return vector2_new(x, y)
    end

    function utility:raycast(origin, direction, ignore, distance)
        distance = distance or 15000
        ignore = ignore or {}

        local hit = workspace:FindPartOnRayWithIgnoreList(Ray.new(origin, direction * distance or 15000), ignore or {})
        if hit and 0.25 <= hit.Transparency then
            return self:raycast(origin, direction, utility.table.merge(ignore, {hit}), distance)
        end
        return hit
    end

    function utility:get_size_string(size, absolute)
        return ('R(%s, %s, %s, %s), A(%s, %s)'):format(size.X.Scale, size.X.Offset, size.Y.Scale, size.Y.Offset, absolute.X, absolute.Y)
    end

    function utility:lerp(min, max, time)
        return min + (max - min) * time
    end

    function utility:replaceupvalue(func, upvalue, replacement)
        local old = getupvalue(func, upvalue)
        setupvalue(func, upvalue, replacement)
        return old
    end

    function utility:tween(object, property, value_new, time, style, direction)
        local tween = {}
        tween.style = style or Enum.EasingStyle.Linear
        tween.direction = direction or Enum.EasingDirection.In
        tween.value_start = object[property]
        tween.value_new = value_new
        tween.progress_lerp = 0
        tween.Completed = library.signal.new()
 
        function tween:Cancel()
            tween.connection:Disconnect()
            table.clear(tween)
        end

        tween.connection = library:connection(runservice.Heartbeat, function(delta)
            tween.progress_lerp = tween.progress_lerp + (delta / time)

            tween.progress_tween = tweenservice:GetValue(tween.progress_lerp, tween.style, tween.direction)

            if typeof(value_new) == 'number' then
                tween.value_current = self:lerp(tween.value_start, value_new, tween.progress_tween)
            else
                tween.value_current = tween.value_start:lerp(tween.value_new, tween.progress_tween)
            end
            
            if utility.table.includes(object, '_object') and not rawget(object._object, '__OBJECT_EXISTS') == true then
                tween.connection:Disconnect()
                tween.Completed:Fire()
                return
            end

            object[property] = tween.value_current

            if tween.progress_lerp >= 1 or object == nil then
                tween.connection:Disconnect()
                tween.Completed:Fire()
                return
            end

        end)

        return tween
    end

    -- table util
    function utility.table.includes(tbl, key)
        return ({pcall(function() local a = tbl[key] end)})[1]
    end

    function utility.table.merge(a,b)
        local c = {}
        for i,v in next, a or {} do c[i] = v end
        for i,v in next, b or {} do c[i] = v end
        return c
    end

    function utility.table.getdescendants(tbl, new)
        local new = new or {}
        for i,v in next, tbl do
            if typeof(v) == 'table' then
                utility.table.getdescendants(v, new)
            else
                new[i] = v
            end
        end
        return new
    end

    function utility.table.deepcopy(tbl)
        local new = {}
        for i,v in next, tbl or {} do
            if typeof(v) == 'table' then
                v = utility.table.deepcopy(v)
            end
            new[i] = v
        end
        return new
    end
    
    function utility.table.nuke(tbl)
        for i,v in next, tbl do
            if typeof(v) == 'table' then
                utility.table.nuke(v)
            end
            tbl[i] = nil
        end
    end

    function utility.table.unfreeze(tbl)
        setreadonly(tbl, false)
        for i,v in next, tbl do
            if typeof(v) == 'table' then
                utility.table.unfreeze(v)
            end
        end
    end
    
    function utility.table.clearkeys(tbl)
        local new = {}
        for i,v in next, tbl do
            table_insert(new, i)
        end
        return new
    end

    -- camera util
    function utility.camera.cframetoviewport(cframe, floor)
        local position, visible = worldtoviewport(library.camera, cframe * (cframe - cframe.p):ToObjectSpace(library.camera.CFrame - library.camera.CFrame.p).p)
        if floor then
            position = utility.vector2.floor(position)
        end
        return position, visible
    end

    function utility.camera.isvisible(position, model, ignore)
        local ray = Ray.new(library.camera.CFrame.p, cframe_new(library.camera.CFrame.p, position).LookVector * 10000)
        local hit, position, normal = workspace:FindPartOnRayWithIgnoreList(ray, ignore or {})
        if not hit then
            return false
        end
        return hit:IsDescendantOf(model), hit, position, normal
    end

    -- vector2 util
    function utility.vector2.floor(vector2)
        return vector2_new(math_floor(vector2.X), math_floor(vector2.Y))
    end
    
    function utility.vector2.rotate(vector2: Vector2, rotation: number)
        local c = math_cos(rotation)
        local s = math_sin(rotation)
        return vector2_new(c * vector2.X - s * vector2.Y, s * vector2.X + c * vector2.Y)
    end

    function utility.vector2.inside(position: Vector2, rect_position: Vector2, rect_size: Vector2)
        local x1 = rect_position.X
        local y1 = rect_position.Y
        local x2 = x1 + rect_size.X
        local y2 = y1 + rect_size.Y
        return position.X >= x1 and position.Y >= y1 and position.X <= x2 and position.Y <= y2
    end

    -- color util
    function utility.color.torgb(color: Color3)
        return color.R * 255, color.G * 255, color.B * 255
    end

    function utility.color.add(color1: Color3, color2: Color3)
        return color3_new(color1.R + color2.R, color1.G + color2.G, color1.B + color2.B)
    end

    -- string util
    function utility.string.startswith(str1, str2)
        return string.match(str1, '^' .. str2)
    end

end

-- // meta
do

    -- options
    library.meta.options = {}
    library.meta.options.functions = {}
    library.meta.options.__index = function(self, idx)
        if library.meta.options[idx] ~= nil then
            return library.meta.options[idx].new
        elseif library.meta.options.functions[idx] ~= nil then
            return library.meta.options.functions[idx]
        end
        return rawget(self, idx)
    end
    
    function library.meta.options.functions:set_text(str)
        self.text = str
        self.objects.label.Text = str
    end

    function library.meta.options.functions:set_enabled(bool)
        self.enabled = bool
        self.parent:update_options()
    end

    -- fov circle
    library.fovcircles = {}
    library.fovcircle = {}
    library.fovcircle.__index = library.fovcircle

    function library.fovcircle.new(flag, properties)
        local circle = setmetatable({
            _mode = 'center',
            _fov = 0,
            _flag = flag,
            _components = {
                library:create('Circle', {Thickness = 1, ZIndex = -4}),
                library:create('Circle', {Thickness = 1, ZIndex = -4}),
                library:create('Circle', {Thickness = 3.5, ZIndex = -5})
            }
        }, library.fovcircle)

        table_insert(library.fovcircles, circle)

        for i,v in next, properties or {} do
            circle[i] = v
        end

        return circle
    end

    function library.fovcircle:set(property, value)
        self._components[1][property] = value
        self._components[2][property] = value
        self._components[3][property] = value
    end

    function library.fovcircle:update_position()
        self:set('Position', self._mode == 'mouse' and inputservice:GetMouseLocation() or library.screensize / 2)
    end

    function library.fovcircle:update_radius()
        self._fov = flags[self._flag .. '_fov_radius'] + (flags[self._flag .. '_fov_dynamic'] and -(library.camera.FieldOfView * 2) or 0)
        self:set('Radius', self._fov)
    end

    function library.fovcircle:update()
        self:update_radius()
        self:update_position()
        self:set('Color', flags[self._flag .. '_fov_color'], true)
        self:set('Visible', flags[self._flag .. '_fov_enabled'])
        self:set('NumSides', flags[self._flag .. '_fov_sides'])
        self._components[3].Color = color3_new(0,0,0)
    end

    -- spring
    library.spring = {}
    library.spring.__index = library.spring

    function library.spring.new(freq, position)
        return setmetatable({
            f = freq,
            p = position,
            v = 0
        }, library.spring)
    end

    function library.spring:update(delta, goal)
        local f = self.f*2*math.pi
		local p0 = self.p
		local v0 = self.v

		local offset = goal - p0
		local decay = math.exp(-f * delta)

		local p1 = goal + (v0 * delta - offset * (f * delta + 1)) * decay
		local v1 = (f * delta * (offset * f - v0) + v0) * decay

		self.p = p1
		self.v = v1

		return p1
    end

    function library.spring:reset(position)
        self.p = position
        self.v = 0
    end

    -- colorpicker object
    do
        library.meta.colorpicker = {}
        library.meta.colorpicker.__index = library.meta.colorpicker
        setmetatable(library.meta.colorpicker, library.meta.options)

        function library.meta.colorpicker:update()
            if not self.selected then return end

            local mouse_position = inputservice:GetMouseLocation()
            local relative_palette = (mouse_position - self.objects.color.AbsolutePosition)
            local relative_hue     = (mouse_position - self.objects_hue.container.AbsolutePosition)
            local relative_opacity = (mouse_position - self.objects_opacity.container.AbsolutePosition)

            if self.dragging_sat then
                self.sat = math_clamp(1 - relative_palette.X / self.objects.color.AbsoluteSize.X, 0, 1)
                self.val = math_clamp(1 - relative_palette.Y / self.objects.color.AbsoluteSize.Y, 0, 1)
            elseif self.dragging_hue then
                self.hue = math_clamp(relative_hue.Y / self.objects_hue.container.AbsoluteSize.Y, 0, 1)
            elseif self.dragging_opacity then
                self.opacity = math_clamp(relative_opacity.Y / self.objects_opacity.container.AbsoluteSize.Y, 0, 1)
            end

            if self.accent_toggle.state then
                self.hue, self.sat, self.val = library.theme.Accent:ToHSV()
            end

            self.color = color3_hsv(self.hue, self.sat, self.val)
            self.objects.pointer.Position = udim2_new(math_clamp(1 - self.sat, 0.005, 0.995), 0, math_clamp(1 - self.val, 0.005, 0.995), 0)
            self.objects.color.Color = color3_hsv(self.hue, 1, 1)

            self.objects_hue.slider.Position = udim2_new(0,0,math_clamp(self.hue, 0.005, 0.995),0)
            self.objects_opacity.slider.Position = udim2_new(0,0,math_clamp(self.opacity, 0.005, 0.995),0)
            self.objects_opacity.container.Color = self.color

            self.hex_button:set_text('#' .. self.color:ToHex())

            if self.selected ~= nil then
                self.selected.color = self.color
                self.selected.opacity = self.opacity
                self.selected.objects.background.Color = self.color
                self.selected.callback(self.selected.color, self.selected.opacity)
                if self.selected.flag ~= nil then
                    flags[self.selected.flag] = self.color
                end
            end

        end

        function library.meta.colorpicker:set_color(color)
            -- assert(typeof(color) == 'Color3', ("invalid opacity value. expected 'Color3', got '%s'"):format(typeof(opacity)))
            
            self.color = color
            self.hue, self.sat, self.val = self.color:ToHSV()

            self.objects.pointer.Position = udim2_new(math_clamp(1 - self.sat, 0.005, 0.995), 0, math_clamp(1 - self.val, 0.005, 0.995), 0)

            self.objects_opacity.container.Color = self.color
            self.objects.color.Color = color3_hsv(self.hue, 1, 1)
            self.objects_hue.slider.Position = udim2_new(0,0,math_clamp(self.hue, 0.005, 0.995),0)

            self.hex_button:set_text('#' .. self.color:ToHex())

            if self.selected ~= nil then
                self.selected.color = self.color
                self.selected.objects.background.Color = self.color
                self.selected.callback(self.selected.color, self.selected.opacity)
                if self.selected.flag ~= nil then
                    flags[self.selected.flag] = self.color
                end
            end

        end

        function library.meta.colorpicker:set_opacity(opacity)
            assert(typeof(opacity) == 'number', ("invalid opacity value. expected 'number', got '%s'"):format(typeof(opacity)))
            
            self.opacity = opacity
            self.objects_opacity.slider.Position = udim2_new(0,0,math_clamp(self.opacity, 0.005, 0.995),0)
            self.objects_opacity.container.Color = self.color
        end

        function library.meta.colorpicker:set(color, opacity)
            self:set_color(color or color3_new(1,1,1))
            self:set_opacity(opacity or 1)
        end

    end

    -- label
    library.meta.options.label = {}
    library.meta.options.label.__index = library.meta.options.label
    setmetatable(library.meta.options.label, library.meta.options)

    function library.meta.options.label:new(properties)
        local label = library:create('option', properties, self, 'label')
        table_insert(self.options, label)
        label:set_text(properties.text or '')
        return self._type == 'option' and self or label
    end

    function library.meta.options.label:set_text(str)
        assert(typeof(str) == 'string', ("invalid label text type. expected 'string', got '%s'"):format(typeof(str)))

        self.objects.label.Text = str
        self.objects.container.Size = udim2_new(1, 0, 0, self.objects.label.TextBounds.Y + 4)
        self.parent:update_options()
    end

    -- toggle
    do
        library.meta.options.toggle = {}
        library.meta.options.toggle.__index = library.meta.options.toggle
        setmetatable(library.meta.options.toggle, library.meta.options)

        function library.meta.options.toggle:new(properties)
            local toggle = library:create('option', properties, self, 'toggle')
            toggle.state = false

            toggle.objects.background = library:create('rect', {
                Theme = {['Color'] = 'Option Background'},
                Size = udim2_new(0,6,0,6),
                Position = udim2_new(0,3,0,5),
                AnchorPoint = vector2_new(0,0),
                ZIndex = toggle.zindex + 3,
                Parent = toggle.objects.container
            })

            toggle.objects.label.Position = udim2_new(0,17,0,1)
            toggle.objects.border_inner = library:create('outline', toggle.objects.background,   {['Theme'] = {['Color'] = 'Border 1'}})
            toggle.objects.border_mid   = library:create('outline', toggle.objects.border_inner, {['Theme'] = {['Color'] = 'Border 2'}})
            toggle.objects.border_outer = library:create('outline', toggle.objects.border_mid,   {['Theme'] = {['Color'] = 'Border 1'}})

            library:connection(toggle.objects.container.MouseButton1Down, function()
                toggle:set_state(not toggle.state)
            end)

            library:connection(toggle.objects.container.MouseEnter, function()
                toggle.objects.border_mid.Theme = {['Color'] = 'Accent'}
            end)

            library:connection(toggle.objects.container.MouseLeave, function()
                toggle.objects.border_mid.Theme = {['Color'] = toggle.state and 'Accent' or 'Border 2'}
            end)

            table_insert(self.options, toggle)
            toggle:set_state(toggle.state)
            return toggle
        end

        function library.meta.options.toggle:set_state(bool)
            assert(typeof(bool) == 'boolean', ("invalid toggle state type. expected 'boolean', got '%s'"):format(typeof(bool)))
            self.state = bool
            self.objects.border_mid.Theme = {['Color'] = (bool or self.objects.container.MouseHover) and 'Accent' or 'Border 2'}
            self.objects.background.Theme = {['Color'] = bool and 'Accent' or 'Option Background'}
            self.objects.label.Theme = {['Color'] = bool and 'Option Text 1' or 'Option Text 2'}
            if self.flag then
                library.flags[self.flag] = bool
            end
            self.callback(bool)
        end

        function library.meta.options.toggle:update_options()

            local pos_x = -2
            local pos_y = 0

            for index, option in next, self.options do
                if option.class == 'colorpicker' or option.class == 'keybind' then
                    pos_x = pos_x + option.objects.container.AbsoluteSize.X + 2
                    option.objects.container.Position = udim2_new(1,-pos_x,0,0)
                else
                    pos_y = pos_y + option.objects.container.AbsoluteSize.Y + 2
                    option.objects.container.Position = udim2_new(0,0,1,-pos_y)
                end
            end

            self.objects.container.Size = udim2_new(1,0,0,18 + pos_y)

        end

    end

    -- button
    do
        library.meta.options.button = {}
        library.meta.options.button.__index = library.meta.options.button
        setmetatable(library.meta.options.button, library.meta.options)

        function library.meta.options.button:new(properties)
            local button = library:create('option', properties, self, 'button')
            button.confirm = properties.confirm or false
            button.clicked = false

            button.objects.background = library:create('rect', {
                Theme = {['Color'] = 'Option Background'},
                Size = udim2_new(1,-6,1,-8),
                Position = udim2_new(0.5,0,0.5,0),
                AnchorPoint = vector2_new(0.5,0.5),
                ZIndex = button.zindex + 3,
                Parent = button.objects.container
            })

            button.objects.gradient = library:create('rect', {
                Size = udim2_new(1,0,1,0),
                Transparency = 0.5,
                ZIndex = button.zindex + 4,
                Data = library.images.gradientp90,
                Parent = button.objects.background,
            }, 'Image')

            library:connection(button.objects.container.MouseButton1Down, function()
                button.objects.background.Theme = {['Color'] = 'Accent'}
                button.objects.label.Theme = {['Color'] = 'Option Text 1'}

                if (button.confirm and button.clicked) or not button.confirm then
                    task.spawn(button.callback)
                    button.objects.label.Text = button.text
                    button.clicked = false
                elseif button.confirm and not button.clicked then
                    button.clicked = true
                    for i = 3, 1, -1 do
                        if not button.clicked then break end
                        button.objects.label.Text = 'confirm? [' .. i .. 's]'
                        wait(1)
                    end
                    button.clicked = false
                    button.objects.label.Text = button.text
                end
            end)

            library:connection(button.objects.container.MouseButton1Up, function()
                button.objects.background.Theme = {['Color'] = 'Option Background'}
                button.objects.label.Theme = {['Color'] = 'Option Text 2'}
            end)

            library:connection(button.objects.container.MouseEnter, function()
                button.objects.background.Theme = {['Color'] = 'Option Background'}
                button.objects.label.Theme = {['Color'] = 'Option Text 2'}
                button.objects.border_mid.Theme = {['Color'] = 'Accent'}
            end)

            library:connection(button.objects.container.MouseLeave, function()
                button.objects.background.Theme = {['Color'] = 'Option Background'}
                button.objects.label.Theme = {['Color'] = 'Option Text 2'}
                button.objects.border_mid.Theme = {['Color'] = 'Border 2'}
            end)

            button.objects.label.Center   = true
            button.objects.label.Position = udim2_new(0.5,0,0,2)
            button.objects.border_inner   = library:create('outline', button.objects.background,   {['Theme'] = {['Color'] = 'Border 1'}})
            button.objects.border_mid     = library:create('outline', button.objects.border_inner, {['Theme'] = {['Color'] = 'Border 2'}})
            button.objects.border_outer   = library:create('outline', button.objects.border_mid,   {['Theme'] = {['Color'] = 'Border 1'}})

            table_insert(self.options, button)
            return self._type == 'option' and self or button
        end
    end

    -- slider
    do
        library.meta.options.slider = {}
        library.meta.options.slider.__index = library.meta.options.slider
        setmetatable(library.meta.options.slider, library.meta.options)

        function library.meta.options.slider:new(properties)
            local slider = library:create('option', utility.table.merge(properties, {size = udim2_new(1,0,0,36)}), self, 'slider')
            slider.parent = self
            slider.value = 0
            slider.min = properties.min or 0
            slider.max = properties.max or 100
            slider.maxtext = properties.maxtext or ''
            slider.mintext = properties.mintext or ''
            slider.increment = properties.increment or 1
            slider.prefix = properties.prefix or ''
            slider.suffix = properties.suffix or ''

            slider.objects.background = library:create('rect', {
                Theme = {['Color'] = 'Option Background'},
                Size = udim2_new(1,-6,0,10),
                Position = udim2_new(0.5,0,1,-5),
                AnchorPoint = vector2_new(0.5,1),
                ZIndex = slider.zindex + 3,
                Parent = slider.objects.container
            })

            slider.objects.slider = library:create('rect', {
                Theme = {['Color'] = 'Accent'},
                Size = udim2_new(0,0,1,0),
                ZIndex = slider.zindex + 4,
                Parent = slider.objects.background
            })

            slider.objects.gradient = library:create('rect', {
                Size = udim2_new(1,0,1,0),
                Transparency = 0.5,
                ZIndex = slider.zindex + 5,
                Data = library.images.gradientp90,
                Parent = slider.objects.background,
            }, 'Image')

            library:connection(slider.objects.container.MouseButton1Down, function()
                slider:update()
                library.dragging_slider = slider
                slider.objects.border_mid.Theme = {['Color'] = 'Accent'}
            end)

            library:connection(slider.objects.container.MouseEnter, function()
                slider.objects.border_mid.Theme = {['Color'] = 'Accent'}
            end)

            library:connection(slider.objects.container.MouseLeave, function()
                slider.objects.border_mid.Theme = {['Color'] = 'Border 2'}
            end)

            slider.objects.label.ZIndex     = slider.zindex + 6
            slider.objects.container.ZIndex = slider.zindex + 6

            slider.objects.container.Size = slider.parent.class == 'section' and udim2_new(1,0,0,36) or udim2_new(1,0,0,18)
            slider.objects.label.Position = slider.parent.class == 'section' and udim2_new(0,0,0,1) or udim2_new(0.5,0,0,1)
            slider.objects.label.Center   = slider.parent.class ~= 'section'

            slider.objects.border_inner = library:create('outline', slider.objects.background,   {['Theme'] = {['Color'] = 'Border 1'}})
            slider.objects.border_mid   = library:create('outline', slider.objects.border_inner, {['Theme'] = {['Color'] = 'Border 2'}})
            slider.objects.border_outer = library:create('outline', slider.objects.border_mid,   {['Theme'] = {['Color'] = 'Border 1'}})

            table_insert(self.options, slider)
            slider:set_value(properties.default or 0)            
            return self._type == 'option' and self or slider
        end

        function library.meta.options.slider:set_value(value, nocallback)
            assert(typeof(value) == 'number', ("invalid toggle state type. expected 'number', got '%s'"):format(typeof(value)))

            self.value = math_clamp(self.increment * math_floor(value / self.increment), self.min, self.max)
            self.objects.label.Theme = {['Color'] = (self.value == self.min or (0 > self.min and self.value == 0)) and 'Option Text 2' or 'Option Text 1'}

            local text = (self.value == self.min and self.mintext ~= '' and self.mintext) or (self.value == self.max and self.maxtext ~= '' and self.maxtext) or string.format("%.14g", self.value)

            if self.parent.class == 'section' then
                self.objects.label.Text = self.prefix .. self.text .. ': ' .. text .. self.suffix
            else
                self.objects.label.Text = self.prefix .. text .. self.suffix .. '/' .. self.prefix .. self.max .. self.suffix
            end

            if self.min >= 0 then
                self.objects.slider.Size = udim2_new((self.value - self.min) / (self.max - self.min), 0, 1, 0)
            else
                self.objects.slider.Size = udim2_new(self.value / (self.max - self.min), 0, 1, 0)
                self.objects.slider.Position = udim2_new((0 - self.min) / (self.max - self.min), 0, 0, 0)
            end

            if self.flag ~= nil then
                library.flags[self.flag] = self.value
            end

            if not nocallback then
                self.callback(self.value)
            end
        end

        function library.meta.options.slider:update()
            local relative = utility.vector2.floor(inputservice:GetMouseLocation() - self.objects.background.AbsolutePosition)
            local value = utility:convert_number_range(relative.X, 0, self.objects.background.AbsoluteSize.X, self.min, self.max)
            self:set_value(math_clamp(value, self.min, self.max))
        end

    end

    -- colorpicker
    do
        library.meta.options.colorpicker = {}
        library.meta.options.colorpicker.__index = library.meta.options.colorpicker
        setmetatable(library.meta.options.colorpicker, library.meta.options)

        function library.meta.options.colorpicker:new(properties)
            properties = properties or {}

            local colorpicker = library:create('option', properties, self, 'colorpicker')
            colorpicker.parent = self
            colorpicker.useaccent = false
            colorpicker.rainbow = false
            colorpicker.displayuseaccent = properties.displayuseaccent == nil and true or properties.displayuseaccent
            colorpicker.color = properties.default or color3_new(1,1,1)
            colorpicker.opacity = properties.default_opacity or 0

            colorpicker.objects.background = library:create('rect', {
                Color = colorpicker.color,
                Size = udim2_new(0,15,0,6),
                Position = udim2_new(1,-3,0,6),
                AnchorPoint = vector2_new(1,0),
                ZIndex = colorpicker.zindex + 3,
                Parent = colorpicker.objects.container
            })

            if self.class ~= 'section' then
                colorpicker.objects.container.ZIndex = colorpicker.zindex + 4
                colorpicker.objects.container.Size = udim2_new(0,21,1,0) 
            end

            colorpicker.objects.label.Visible = self.class == 'section'
            colorpicker.objects.border_inner = library:create('outline', colorpicker.objects.background,   {['Theme'] = {['Color'] = 'Border 1'}})
            colorpicker.objects.border_mid   = library:create('outline', colorpicker.objects.border_inner, {['Theme'] = {['Color'] = 'Border 2'}})
            colorpicker.objects.border_outer = library:create('outline', colorpicker.objects.border_mid,   {['Theme'] = {['Color'] = 'Border 1'}})

            library:connection(colorpicker.objects.container.MouseButton1Down, function()
                if library.colorpicker.selected == colorpicker then
                    library.colorpicker.selected = nil
                    library.colorpicker.objects.background.Parent = nil
                    library.colorpicker.objects.background.Visible = false
                else
                    library.colorpicker.selected = colorpicker
                    library.meta.options.toggle.set_state(options.COLORPICKER_ACCENT_TOGGLE, colorpicker.useaccent)
                    library.meta.options.toggle.set_state(options.COLORPICKER_RAINBOW_TOGGLE, colorpicker.rainbow)
                    library.colorpicker.objects.background.Parent = colorpicker.objects.container
                    library.colorpicker.objects.background.Visible = true
                    library.colorpicker.objects.label.Text = colorpicker.text or colorpicker.flag or ''
                    library.colorpicker:set(colorpicker.color, colorpicker.opacity)
                end
            end)

            library:connection(colorpicker.objects.container.MouseEnter, function()
                colorpicker.objects.border_mid.Theme = {['Color'] = 'Accent'}
            end)

            library:connection(colorpicker.objects.container.MouseLeave, function()
                colorpicker.objects.border_mid.Theme = {['Color'] = colorpicker.state and 'Accent' or 'Border 2'}
            end)

            table_insert(self.options, colorpicker)
            if properties.flag ~= nil then
                flags[properties.flag] = colorpicker.color
            end
            return self._type == 'option' and self or colorpicker
        end

        function library.meta.options.colorpicker:set(color, opacity)
            if self.useaccent then
                color = library.theme.Accent
            end

            self.color = color
            self.opacity = opacity
            self.objects.background.Color = color
            if self.flag ~= nil then
                library.flags[self.flag] = color
            end
            if library.colorpicker.selected == self then
                library.colorpicker:set(color, opacity)
            end
            self.callback(color, opacity)
        end

    end

    -- textbox
    do
        library.meta.options.textbox = {}
        library.meta.options.textbox.__index = library.meta.options.textbox

        function library.meta.options.textbox:new(properties)
            local textbox = library:create('option', properties, self, 'textbox')
            textbox.text = ''
            textbox.min = 0
            textbox.max = 100
            textbox.numeric = properties.numeric or false
            textbox.placeholder = properties.placeholder or ''
            textbox.callback = properties.callback or function() end
            textbox.parent = self

            textbox.objects.background = library:create('rect', {
                Theme = {['Color'] = 'Option Background'},
                Size = udim2_new(1,-6,0,10),
                Position = udim2_new(0.5,0,1,-5),
                AnchorPoint = vector2_new(0.5,1),
                ZIndex = textbox.zindex + 3,
                Parent = textbox.objects.container
            })

            textbox.objects.gradient = library:create('rect', {
                Size = udim2_new(1,0,1,0),
                Transparency = 0.5,
                ZIndex = textbox.zindex + 4,
                Data = library.images.gradientp90,
                Parent = textbox.objects.background,
            }, 'Image')

            textbox.objects.input = library:create('text', {
                Theme = {['Color'] = 'Option Text 2'},
                Position = udim2_new(0,1,0,-2),
                Text = textbox.placeholder,
                Center = textbox.center or false,
                ZIndex = textbox.zindex + 5,
                Parent = textbox.objects.background,
            })

            library:connection(textbox.objects.container.MouseButton1Down, function()
                if not textbox.focued then
                    textbox:capture()
                end
            end)

            library:connection(textbox.objects.container.MouseEnter, function()
                textbox.objects.border_mid.Theme = {['Color'] = 'Accent'}
            end)

            library:connection(textbox.objects.container.MouseLeave, function()
                textbox.objects.border_mid.Theme = {['Color'] = 'Border 2'}
            end)

            textbox.objects.container.ZIndex = textbox.zindex + 5
            textbox.objects.label.Visible  = textbox.parent.class == 'section'
            textbox.objects.container.Size = textbox.parent.class == 'section' and udim2_new(1,0,0,36) or udim2_new(1,0,0,18)
            textbox.objects.border_inner   = library:create('outline', textbox.objects.background,   {['Theme'] = {['Color'] = 'Border 1'}})
            textbox.objects.border_mid     = library:create('outline', textbox.objects.border_inner, {['Theme'] = {['Color'] = 'Border 2'}})
            textbox.objects.border_outer   = library:create('outline', textbox.objects.border_mid,   {['Theme'] = {['Color'] = 'Border 1'}})

            table_insert(self.options, textbox)
            if properties.default then
                textbox:set_text(properties.default)
            end
            return self._type == 'option' and self or textbox
        end

        function library.meta.options.textbox:set_text(str, nocallback)
            assert(typeof(str) == 'string', ("invalid textbox input type. expected 'string', got '%s'"):format(typeof(str)))

            if self.numeric then
                str = str:gsub('[^%d%.%-]', '')
            end

            self.text = str
            self.objects.input.Text = (str == '' and not self.focused) and self.placeholder or str
            self.objects.input.Theme = {['Color'] = self.focused and 'Option Text 1' or 'Option Text 2'}
            self.objects.label.Theme = {['Color'] = (str == '' and not self.focused) and 'Option Text 2' or 'Option Text 1'}

            if not nocallback then
                self.callback(str)
            end

            if self.flag ~= nil then
                library.flags[self.flag] = str
            end
        end

        function library.meta.options.textbox:handle_keypress(input)
            if not self.focused then return end
            if table_find(library.blacklisted_keys, input.KeyCode) then return end

            if input.KeyCode == Enum.KeyCode.Backspace then
                self:set_text(self.text:sub(0,-2))
            elseif input.KeyCode == Enum.KeyCode.V and inputservice:IsKeyDown(Enum.KeyCode.LeftControl) then
                self:set_text(self.text .. utility:getclipboard(), true)
            elseif input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.Escape or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
                self:release()
                if self.numeric then
                    local str = tostring(tonumber(self.text))
                    if not str or str == '' or str == 'nil' then
                        str = '0'
                    end
                    self:set_text(str)
                else
                    self:set_text(self.text)
                end
                return
            else
                local caps = inputservice:IsKeyDown(Enum.KeyCode.LeftShift) or inputservice:IsKeyDown(Enum.KeyCode.RightShift)
                local keystring = library.key_strings[input.KeyCode]
                local keystring = (keystring == nil and (caps and input.KeyCode.Name or input.KeyCode.Name:lower()) or (caps and keystring[2] or keystring[1]))
                self:set_text(self.text .. keystring, true)
            end
        end

        function library.meta.options.textbox:capture()
            if not self.focused then
                actionservice:BindAction(
                    'FreezeMovement',
                    function()
                        return Enum.ContextActionResult.Sink
                    end,
                    false,
                    unpack(Enum.PlayerActions:GetEnumItems())
                )

                self.focused = true
                self:set_text(self.text, true)
                self.connection = library:connection(inputservice.InputBegan, function(input)

                    if inputservice:GetFocusedTextBox() then return end
                    local released = false

                    self:handle_keypress(input)

                    task.spawn(function()
                        inputservice.InputEnded:Wait()
                        released = true
                    end)

                    task.wait(0.5)
                    if not released then
                        repeat
                            self:handle_keypress(input)
                            wait(0.05)
                        until released
                    end
                end)
            end
        end

        function library.meta.options.textbox:release()
            if self.focused then
                actionservice:UnbindAction('FreezeMovement')
                self.focused = false
                self.connection:Disconnect()
            end
        end

    end

    -- dropdown
    do
        library.meta.options.dropdown = {}
        library.meta.options.dropdown.__index = library.meta.options.dropdown
        setmetatable(library.meta.options.dropdown, library.meta.options)

        function library.meta.options.dropdown:new(properties)
            local dropdown = library:create('option', properties, self, 'dropdown')
            dropdown.multi = properties.multi or false
            dropdown.searching = false
            dropdown.maxvalues = 10
            dropdown.values = {}
            dropdown.selected = properties.multi and {} or ''

            for i,v in next, properties.values or {} do
                dropdown:add_value(v)
            end 

            dropdown.objects.background = library:create('rect', {
                Theme = {['Color'] = 'Option Background'},
                Size = udim2_new(1,-6,0,10),
                Position = udim2_new(0.5,0,1,-5),
                AnchorPoint = vector2_new(0.5,1),
                ZIndex = dropdown.zindex + 3,
                Parent = dropdown.objects.container
            })
            
            dropdown.objects.status_text = library:create('text', {
                Theme = {['Color'] = 'Option Text 2'},
                Position = udim2_new(0,1,0,-3),
                Text = 'none',
                Center = dropdown.center or false,
                ZIndex = dropdown.zindex + 5,
                Parent = dropdown.objects.background,
            })

            dropdown.objects.status = library:create('rect', {
                Size = udim2_new(0,7,0,5),
                Position = udim2_new(1,-4,0.5,1),
                AnchorPoint = vector2_new(1,0.5),
                ZIndex = dropdown.zindex + 4,
                Data = library.images.arrow_down,
                Parent = dropdown.objects.background,
            }, 'Image')

            dropdown.objects.gradient = library:create('rect', {
                Size = udim2_new(1,0,1,0),
                Transparency = 0.5,
                ZIndex = dropdown.zindex + 4,
                Data = library.images.gradientp90,
                Parent = dropdown.objects.background,
            }, 'Image')

            library:connection(dropdown.objects.container.MouseButton1Down, function()

                for i,v in next, library.dropdown.connections do
                    v:Disconnect()
                end

                if library.dropdown.selected == dropdown then
                    dropdown.objects.status.Data = library.images.arrow_down
                    dropdown.objects.status.Position = udim2_new(1,-4,0.5,1)
                    library.dropdown.selected = nil
                    library.dropdown.objects.background.Parent = nil
                    library.dropdown.objects.background.Visible = false
                else
                    dropdown.objects.status.Data = library.images.arrow_up
                    dropdown.objects.status.Position = udim2_new(1,-4,0.5,0)
                    library.dropdown.selected = dropdown
                    library.dropdown.objects.background.Parent = dropdown.objects.container
                    library.dropdown.objects.background.Visible = true
                    dropdown:update()

                    if inputservice:IsKeyDown(Enum.KeyCode.LeftControl) then

                        local status_text = dropdown.objects.status_text

                        dropdown.searching = true
                        status_text.Text = ''
                        
                        local c; c = library:connection(inputservice.InputBegan, function(input)
                            if input.UserInputType ~= Enum.UserInputType.Keyboard or not input.KeyCode then return end
                            if table_find(library.blacklisted_keys, input.KeyCode) then return end
                
                            local caps = inputservice:IsKeyDown(Enum.KeyCode.LeftShift) or inputservice:IsKeyDown(Enum.KeyCode.RightShift)
                            local keystring = library.key_strings[input.KeyCode]
                            local keystring = (keystring == nil and (caps and input.KeyCode.Name or input.KeyCode.Name:lower()) or (caps and keystring[2] or keystring[1]))
                
                            if input.KeyCode == Enum.KeyCode.Backspace then
                                status_text.Text = status_text.Text:sub(0,-2)
                            elseif input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.Escape or input.UserInputType == Enum.UserInputType.MouseButton1 then
                                c:Disconnect()
                                dropdown.searching = false
                                status_text.Text = dropdown.text
                                return
                            else
                                status_text.Text = status_text.Text .. keystring
                            end
        
                            dropdown:update()
        
                        end)
        
                    end

                end
            end)

            library:connection(dropdown.objects.container.MouseEnter, function()
                dropdown.objects.border_mid.Theme = {['Color'] = 'Accent'}
            end)

            library:connection(dropdown.objects.container.MouseLeave, function()
                dropdown.objects.border_mid.Theme = {['Color'] = 'Border 2'}
            end)

            dropdown.objects.container.ZIndex = dropdown.zindex + 6
            dropdown.objects.label.Visible  = dropdown.parent.class == 'section'
            dropdown.objects.container.Size = dropdown.parent.class == 'section' and udim2_new(1,0,0,36) or udim2_new(1,0,0,18)
            dropdown.objects.border_inner   = library:create('outline', dropdown.objects.background,   {['Theme'] = {['Color'] = 'Border 1'}})
            dropdown.objects.border_mid     = library:create('outline', dropdown.objects.border_inner, {['Theme'] = {['Color'] = 'Border 2'}})
            dropdown.objects.border_outer   = library:create('outline', dropdown.objects.border_mid,   {['Theme'] = {['Color'] = 'Border 1'}})
            
            table_insert(self.options, dropdown)
            if properties.flag ~= nil then
                library.flags[properties.flag] = dropdown.selected
            end
            return self._type == 'option' and self or dropdown
        end

        function library.meta.options.dropdown:select(values)
            self.selected = values
            self:update_text()
            library.flags[self.flag] = self.selected
            if self.callback ~= nil then
                self.callback(self.selected)
            end
        end

        function library.meta.options.dropdown:add_value(value)
            table_insert(self.values, value)
            if self.multi then
                self.selected[value] = false
            end
            self:update()
        end

        function library.meta.options.dropdown:remove_value(value)
            table_remove(self.values, table_find(self.values, value))
            if self.multi then
                self.selected[value] = nil
            end
            self:update()
        end

        function library.meta.options.dropdown:update_text()
            local full_text = self.selected or ''
            local text = ''
            
            if self.multi then
                full_text = {}
                for i,v in next, self.values do
                    if self.selected[v] == true then
                        table_insert(full_text, v)
                    end
                end
                full_text = table_concat(full_text, ', ') or ''
            end

            self.objects.status_text.Text = 'none'

            for i,v in next, full_text:split('') do
                text = text .. v
                self.objects.status_text.Text = text
                if self.objects.status_text.TextBounds.X > self.objects.container.AbsoluteSize.X - 40 then
                    self.objects.status_text.Text = text:sub(1,-3) .. '...'
                    break
                end
            end
        end

        function library.meta.options.dropdown:update() -- i gave up trying to make things look nice on this dropdown shit
            if library.dropdown.selected ~= self then return end

            local dropdown = self

            for i,v in next, library.dropdown.connections do
                v:Disconnect()
            end

            for index in next, dropdown.values do
                if not library.dropdown.objects.values[index] then
                    library.dropdown.objects.values[index] = library:create('dropdownvalue', library.dropdown.objects.background)
                end
            end

            local index = 1

            for _, objects in next, library.dropdown.objects.values do
                local value = dropdown.values[_]
                if value == nil then
                    objects.container.Visible = false
                    continue
                end

                local selected = ((dropdown.multi and dropdown.selected[value] == true) or (not dropdown.multi and dropdown.selected == value))

                if not selected and dropdown.searching and not value:match(dropdown.objects.status_text.Text) then
                    objects.container.Visible = false
                    continue
                end

                objects.label.Text = value
                objects.label.Theme = {['Color'] = (selected and 'Option Text 1' or 'Option Text 2')}
                objects.container.Transparency = selected and 0.1 or 0
                objects.container.Visible = true
                objects.container.Position = udim2_new(0,2,0,2 + (index - 1) * 16)
                library.dropdown.objects.background.Size = udim2_new(1,-4,0,index * 16 + 3)

                index = index + 1
        
                library:connection(objects.container.MouseButton1Down, function()
                    if dropdown.multi then
                        dropdown.selected[value] = not dropdown.selected[value]
                        objects.label.Theme = {['Color'] = dropdown.selected[value] and 'Option Text 1' or 'Option Text 2'}
                        objects.container.Transparency = dropdown.selected[value] and 0.15 or 0
                    else
                        dropdown.selected = dropdown.selected ~= value and value or nil
                        for i,v in next, library.dropdown.objects.values do
                            v.label.Theme = {['Color'] = (v == objects and dropdown.selected == value) and 'Option Text 1' or 'Option Text 2'}
                            v.container.Transparency = (v == objects and dropdown.selected == value) and 0.15 or 0
                        end
                    end
                    if dropdown.flag ~= nil then
                        library.flags[dropdown.flag] = dropdown.selected
                    end
                    if dropdown.callback ~= nil then
                        dropdown.callback(dropdown.selected)
                    end
                    if not dropdown.searching then
                        dropdown:update_text()
                    else
                        dropdown:update()
                    end
                end, library.dropdown.connections)
            end
        end

    end

    -- keybind
    do
        library.meta.options.keybind = {}
        library.meta.options.keybind.__index = library.meta.options.keybind
        setmetatable(library.meta.options.keybind, library.meta.options)


        function library.meta.options.keybind:new(properties)
            properties = properties or {}

            local keybind = library:create('option', properties, self, 'keybind'), library.meta.options.keybind
            keybind.parent = self
            keybind.binding = false
            keybind.state = false
            keybind.mode = properties.mode or 'toggle'
            keybind.key = properties.default or 'none'

            if properties.indicator then
                keybind.indicator = library.keybind_indicator:value({key = keybind.text == '' and keybind.flag or keybind.text, enabled = false})
            end

            keybind.objects.keytext = library:create('text', {
                Color = keybind.color,
                ZIndex = keybind.zindex + 3,
                Parent = keybind.objects.container
            })

            keybind.objects.label.Visible = self.class == 'section'

            if self.class ~= 'section' then
                keybind.objects.container.ZIndex = keybind.zindex + 4
                keybind.objects.container.Size = udim2_new(0,21,1,0) 
            end

            library:connection(keybind.objects.container.MouseButton1Down, function()

                keybind.binding = true
                keybind:set_text('...')
                
                local c; c = library:connection(inputservice.InputBegan, function(input)
                    if input.KeyCode == Enum.KeyCode.Backspace then
                        keybind:set_bind(nil)
                    elseif not keybind.nomouse and library.mouse_strings[input.UserInputType] then
                        keybind:set_bind(input.UserInputType)
                    elseif input.UserInputType == Enum.UserInputType.Keyboard then
                        keybind:set_bind(input.KeyCode)
                    end

                    if not keybind.binding then
                        c:Disconnect()
                    end
                end)

            end)

            library:connection(keybind.objects.container.MouseEnter, function()
                keybind.objects.keytext.Theme = {['Color'] = 'Accent'}
            end)

            library:connection(keybind.objects.container.MouseLeave, function()
                keybind.objects.keytext.Theme = {['Color'] = keybind.binding and 'Accent' or 'Option Text 2'}
            end)

            library:connection(inputservice.InputBegan, function(input, gpe)
                if keybind.bind == 'none' or keybind.bind == nil or gpe then return end

                if input.KeyCode == keybind.bind or input.UserInputType == keybind.bind then
                    if keybind.mode == 'toggle' then
                        keybind.state = not keybind.state
                    elseif keybind.mode == 'hold' then
                        keybind.state = true

                        local c; c = library:connection(inputservice.InputEnded, function(input)
                            if input.KeyCode == keybind.bind or input.UserInputType == keybind.bind then
                                c:Disconnect()
                                if keybind.indicator then
                                    keybind.indicator:set_enabled(false)
                                end
                                keybind.state = false
                                keybind.callback(keybind.state)
                                if keybind.flag ~= nil then
                                    flags[keybind.flag] = keybind.state
                                end
                            end
                        end)

                    else
                        keybind.state = true

                        local c; c = library:connection(runservice.Heartbeat, function(delta)
                            if (input.KeyCode == keybind.key and not inputservice:IsKeyDown(keybind.key)) or (input.UserInputType == keybind.key and not inputservice:IsMouseButtonPressed(keybind.key)) then
                                c:Disconnect()
                                if keybind.flag ~= nil then
                                    flags[keybind.flag] = keybind.state
                                end
                                if keybind.indicator then
                                    keybind.indicator:set_enabled(false)
                                end
                                keybind.state = false
                                keybind.callback(keybind.state)
                            end
                            if keybind.mode == 'always' then
                                keybind.callback(delta)
                            end
                        end)

                    end

                    if keybind.indicator then
                        keybind.indicator:set_enabled(keybind.state)
                    end

                    keybind.callback(keybind.state)
                    if keybind.flag ~= nil then
                        flags[keybind.flag] = keybind.state
                    end
                end
            end)

            keybind:set_bind(properties.default)
            table_insert(self.options, keybind)
            return self._type == 'option' and self or keybind
        end

        function library.meta.options.keybind:set_text(text)
            self.objects.keytext.Text = '[' .. tostring(text) .. ']'
            self.objects.keytext.Position = udim2_new(1,-self.objects.keytext.TextBounds.X,0,0)

            if self.indicator then
                self.indicator:set_enabled(text ~= 'NONE' and self.state)
                self.indicator:set_value('[' .. text .. ']')                
            end

            if self.parent.class ~= 'section' then
                self.objects.container.Size = udim2_new(0,self.objects.keytext.TextBounds.X, 0, 17)
                self.parent:update_options()
            end
        end

        function library.meta.options.keybind:set_bind(bind)
            self.bind = bind == nil and 'none' or bind
            self.binding = false

            local name = 'none'
            if library.mouse_strings[bind] ~= nil then
                name = library.mouse_strings[bind]
            elseif bind ~= nil and bind.Name ~= nil then
                name = bind.Name
            end
            
            self:set_text(tostring(name):upper())
            self.objects.keytext.Theme = {
                ['Color'] = self.objects.container.MouseHover and 'Accent' or 'Option Text 2'
            }
        end

    end

    -- separator
    do
        library.meta.options.separator = {}
        library.meta.options.separator.__index = library.meta.options.separator
        setmetatable(library.meta.options.separator, library.meta.options)

        function library.meta.options.separator:new(properties)
            local separator = library:create('option', properties, self, 'separator'), library.meta.options.separator
            separator.state = false

            separator.objects.line_1 = library:create('rect', {
                Theme = {['Color'] = 'Option Background'},
                Size = udim2_new(0,0,0,1),
                Position = udim2_new(0,1,0.5,0),
                AnchorPoint = vector2_new(0,0.5),
                ZIndex = separator.zindex + 3,
                Parent = separator.objects.container
            })

            separator.objects.line_2 = library:create('rect', {
                Theme = {['Color'] = 'Option Background'},
                Size = udim2_new(0,0,0,1),
                Position = udim2_new(1,-1,0.5,0),
                AnchorPoint = vector2_new(1,0.5),
                ZIndex = separator.zindex + 3,
                Parent = separator.objects.container
            })

            separator.objects.label.Center = true
            separator.objects.label.Position = udim2_new(0.5,0,0,1)

            separator.objects.border_1 = library:create('outline', separator.objects.line_1, {['Theme'] = {['Color'] = 'Border 1'}})
            separator.objects.border_2 = library:create('outline', separator.objects.line_2, {['Theme'] = {['Color'] = 'Border 1'}})

            table_insert(self.options, separator)
            separator:set_text(separator.text)
            return self._type == 'option' and self or separator
        end

        function library.meta.options.separator:set_text(str)
            self.text = str
            self.objects.label.Text = str

            local size_x = (self.objects.container.AbsoluteSize.X - self.objects.label.TextBounds.X - 12) / 2
            self.objects.line_1.Size = udim2_new(0, size_x, 0, 1)
            self.objects.line_2.Size = udim2_new(0, size_x, 0, 1)

        end

    end
end

-- // classes
do

    -- drawing
    library:define('drawing', function(_, class, properties, readonly)
        local drawing = {
            Name        = '',
            Theme       = {},
            _object     = Drawing.new(class),
            _properties = properties or {},
            _readonly   = readonly or {},
            _handlers   = {},
            _children   = {}
        }

        drawing._handlers.Size = function(size)
            drawing._object.Size = size or 0
            drawing._properties.Size = size or 0
        end

        drawing._handlers.Position = function(position)
            assert(typeof(position) == 'UDim2', ("invalid Position type. expected 'UDim2', got '%s'."):format(typeof(position)))

            local parent = drawing._properties.Parent
            local parent_position = parent == nil and vector2_zero or parent.AbsolutePosition
            local parent_size = parent == nil and library.screensize or parent.AbsoluteSize
            local new_position = utility:udim2_to_vector2(position, parent_size)
            local anchorpoint = (
                drawing._properties.AnchorPoint ~= nil and 
                utility:udim2_to_vector2(
                    udim2_new(drawing._properties.AnchorPoint.X, 0, drawing._properties.AnchorPoint.Y, 0), 
                    class == 'Text' and drawing._object.TextBounds or drawing._properties.AbsoluteSize
                )
            ) or vector2_new(0,0)
            
            drawing._properties.Position = position
            drawing._properties.AbsolutePosition = utility.vector2.floor((parent_position + new_position) - anchorpoint)
            drawing._object.Position = drawing._properties.AbsolutePosition

            for i,v in next, drawing._children do
                v.Position = v.Position
            end

        end

        drawing._handlers.Visible = function(bool)
            assert(typeof(bool) == 'boolean', ("invalid Visible type. expected 'boolean', got '%s'"):format(typeof(bool)))

            local parent_visible = drawing._properties.Parent == nil and true or drawing._properties.Parent._object.Visible
            local visible = bool and parent_visible

            drawing._properties.Visible = bool
            drawing._object.Visible = visible

            for i,v in next, drawing._children do
                v.Visible = v.Visible
            end

        end

        drawing._handlers.AnchorPoint = function(anchorpoint)
            assert(typeof(anchorpoint) == 'Vector2', ("invalid AnchorPoint type. expected 'Vector2', got '%s'."):format(typeof(anchorpoint)))
            
            drawing._properties.AnchorPoint = anchorpoint
            drawing._handlers.Position(drawing._properties.Position)

        end

        drawing._handlers.Parent = function(parent)
            -- assert(parent == nil or table_find(library.drawings, parent), ("invalid Parent. not a valid drawing."))

            if drawing._properties.Parent ~= nil then
                table_remove(drawing._properties.Parent._children, table_find(drawing._properties.Parent._children, drawing._metatable))
            end

            if parent ~= nil then
                table_insert(parent._children, drawing._metatable)
            end
             
            local position = table_find(library.drawings.noparent, drawing._metatable)
            if parent == nil and not position then
                table_insert(library.drawings.noparent, drawing._metatable)
            elseif parent ~= nil and position then
                table_remove(library.drawings.noparent, position)
            end

            drawing._properties.Parent = parent
            drawing._handlers.Position(drawing._properties.Position)
            drawing._handlers.Size(drawing._properties.Size)
            
        end

        drawing._handlers.Theme = function(theme)
            drawing.Theme = theme
            for property, themecolor in next, theme do
                local color = library.theme[themecolor]
                if themecolor then
                    drawing._metatable[property] = color
                end
            end
        end

        drawing._handlers.ZIndexOffset = function(offset)
            drawing._metatable.ZIndex = drawing._properties.Parent == nil and 1 or drawing._properties.Parent.ZIndex + offset
        end

        function drawing:GetDescendants(children, descendants)
            local descendants = {}
            local function a(t)
                for _,v in next, t._children do
                    table_insert(descendants, v)
                    a(v)
                end
            end
            a(self)
            return descendants
        end

        function drawing:Remove()

            if rawget(drawing._object, '__OBJECT_EXISTS') then
                self._object:Remove()
            end

            if drawing._properties.Parent ~= nil then
                drawing._properties.Parent._children[drawing] = nil
            end

            library.drawings.raw[drawing._object] = nil
            library.drawings.objects[drawing] = nil
            library.drawings.noparent[drawing] = nil
            library.drawings.active[drawing] = nil
            library.drawings.draggable[drawing] = nil

            for i,v in next, self._children do
                v:Remove()
            end
            
        end

        function drawing:Clone()
            local clone = library:create('drawing', class, drawing._properties, drawing._readonly)
            for i,v in next, drawing._properties do
                clone[i] = v
            end
            return clone
        end

        drawing._metatable = setmetatable({}, {
            __index = function(self, idx)
                if drawing[idx] ~= nil then
                    return drawing[idx]
                elseif drawing._properties[idx] ~= nil or idx == 'Parent' then
                    return drawing._properties[idx]
                elseif drawing._object[idx] ~= nil then
                    return drawing._object[idx]
                else
                    warn(("invalid '%s' property '%s'."):format(class, idx))
                end
            end,
            __newindex = function(self, idx, val)
                if table_find(drawing._readonly, idx) then
                    warn(("'%s' property '%s' is readonly."):format(class, idx))
                elseif drawing._handlers[idx] then
                    drawing._handlers[idx](val)
                elseif drawing[idx] ~= nil then
                    drawing[idx] = val
                elseif drawing._properties[idx] ~= nil or idx == 'Parent' then
                    drawing._properties[idx] = val
                elseif utility.table.includes(drawing._object, idx) or idx == 'Data' then
                    drawing._object[idx] = val
                else
                    warn(("invalid '%s' property '%s'."):format(class, idx))
                end
            end
        })

        table_insert(library.drawings.noparent, drawing._metatable)
        library.drawings.raw[drawing._object] = class
        library.drawings.objects[drawing] = drawing._metatable
        return drawing._metatable
    end)

    -- rect
    library:define('rect', function(default_properties, properties, class)
        local rect = library:create('drawing', class or 'Square', {
            Size             = udim2_new(0,0,0,0),
            Position         = udim2_new(0,0,0,0),
            AbsoluteSize     = vector2_new(0,0),
            AbsolutePosition = vector2_new(0,0),
            AnchorPoint      = vector2_new(0,0),
            Active           = false,
            Draggable        = false,
            MouseHover       = false,
            MouseEnter       = signal.new(),
            MouseLeave       = signal.new(),
            MouseButton1Down = signal.new(),
            MouseButton1Up   = signal.new(),
            MouseButton2Down = signal.new(),
            MouseButton2Up   = signal.new(),
        }, {
            'AbsoluteSize',
            'AbsolutePosition',
            'MouseHover',
            'MouseEnter',
            'MouseLeave',
            'MouseButton1Down',
            'MouseButton1Up',
            'MouseButton2Down',
            'MouseButton2Up'
        })

        rect._handlers.Size = function(size)
            assert(typeof(size) == 'UDim2', ("invalid Size type. expected 'UDim2', got '%s'"):format(typeof(size)))

            local parent = rect._properties.Parent
            local parent_position = parent == nil and vector2_new(0,0) or parent.AbsolutePosition
            local parent_size = parent == nil and library.screensize or parent.AbsoluteSize
            
            rect._properties.Size = size
            rect._properties.AbsoluteSize = utility.vector2.floor(utility:udim2_to_vector2(size, parent_size))
            rect._object.Size = rect._properties.AbsoluteSize
            rect._handlers.AnchorPoint(rect._properties.AnchorPoint)

            for i,v in next, rect._children do
                v.Size = v.Size
            end

        end

        rect._handlers.Active = function(bool)
            assert(typeof(bool) == 'boolean', ("invalid Active type. expected 'boolean', got '%s'"):format(typeof(bool)))

            local position = table_find(library.drawings.active, rect)
            if not bool and position then
                table_remove(library.drawings.active, position)
            elseif bool and not position then
                table_insert(library.drawings.active, rect)
            end

            rect._properties.Active = bool

        end

        rect._handlers.Draggable = function(bool)
            assert(typeof(bool) == 'boolean', ("invalid Draggable type. expected 'boolean', got '%s'"):format(typeof(bool)))

            local position = table_find(library.drawings.draggable, rect)
            if not bool and position then
                table_remove(library.drawings.draggable, position)
            elseif bool and not position then
                table_insert(library.drawings.draggable, rect)
            end

            rect._properties.Draggable = bool

        end

        for property, value in next, utility.table.merge(default_properties, properties) do
            if property == 'Filled' and class == 'Image' then continue end
            rect[property] = value
        end 

        return rect
    end, {
        Position = udim2_new(0,0,0,0),
        Size = udim2_new(0,0,0,0),
        AnchorPoint = vector2_new(0,0),
        Visible = true,
        Filled = true,
        Active = false,
        Draggable = false
    })

    -- text
    library:define('text', function(default_properties, properties)
        local text = library:create('drawing', 'Text', {
            Position         = udim2_new(0,0,0,0),
            AbsolutePosition = vector2_new(0,0),
            AnchorPoint      = vector2_new(0,0),
        }, {
            'AbsolutePosition',
        })

        for property, value in next, utility.table.merge(default_properties, properties) do
            text[property] = value
        end

        return text
    end, {
        Size = 13,
        Font = 2,
        Position = udim2_new(0,0,0,0),
        Visible = true,
    })

    -- outline
    library:define('outline', function(default_properties, parent, properties)
        local outline = library:create('rect', {Parent = parent})

        outline._handlers.Thickness = function(thickness)
            if typeof(thickness) == 'table' then -- [1] = top, [2] = right, [3] = bottom, [4] = left
                outline.AnchorPoint = vector2_new(0,0)
                outline.Size = udim2_new(
                    1, 
                    thickness[2] + thickness[4],
                    1,
                    thickness[1] + thickness[3]
                )
                outline.Position = udim2_new(
                    0,
                    -thickness[4],
                    0,
                    -thickness[1]
                )
            else
                outline.AnchorPoint = vector2_new(0.5,0.5)
                outline.Size = udim2_new(1, thickness * 2, 1, thickness * 2)
            end
        end

        for i,v in next, utility.table.merge(default_properties, properties) do
            outline[i] = v
        end
        
        return outline
    end, {
        Position = udim2_new(0.5,0,0.5,0),
        AnchorPoint = vector2_new(0.5,0.5),
        ZIndexOffset = -1,
        Thickness = 1,
    })

    -- menu
    library:define('menu', function(meta, properties)
        local menu = setmetatable({}, meta)
        properties     = properties or {}
        menu.text      = properties.text or 'menu'
        menu.size      = properties.size or udim2_new(0, 525, 0, 650)
        menu.position  = properties.position or udim2_new(0.2, 0, 0.2, 0)
        menu.open      = true
        menu.visvalues = {}
        menu.objects   = {}
        menu.tabs      = {}

        menu.objects.background = library:create('rect', {
            Theme    = {['Color'] = 'Background'},
            Visible  = true,
            Size     = menu.size,
            Position = menu.position
        })

        menu.objects.title = library:create('text', {
            Theme    = {['Color'] = 'Primary Text'},
            Position = udim2_new(0.5,0,0,-18),
            Center   = true,
            Outline  = true,
            Text     = menu.text,
            Parent   = menu.objects.background
        })

        menu.objects.group_background = library:create('rect', {
            Theme       = {['Color'] = 'Group Background'},
            Size        = udim2_new(1,-20,1,-57),
            Position    = udim2_new(0.5,0,1,-10),
            AnchorPoint = vector2_new(0.5,1),
            ZIndex      = 3,
            Parent      = menu.objects.background,
        })

        menu.objects.tab_container = library:create('rect', {
            Size = udim2_new(1,0,0,27),
            Position = udim2_new(0,0,0,-10),
            AnchorPoint = vector2_new(0,1),
            Transparency = 0,
            Parent = menu.objects.group_background
        })

        menu.objects.section_container_1 = library:create('rect', {
            Size = udim2_new(0.485,-8,1,-20),
            Position = udim2_new(0,10,0,10),
            Parent = menu.objects.group_background,
            Transparency = 0,
            ZIndex = 5,
        })

        menu.objects.section_container_2 = library:create('rect', {
            Size = udim2_new(0.485,-8,1,-20),
            Position = udim2_new(1,-10,0,10),
            AnchorPoint = vector2_new(1,0,0,0),
            Parent = menu.objects.group_background,
            Transparency = 0,
            ZIndex = 5,
        })

        menu.objects.group_outline_1 = library:create('outline', menu.objects.group_background, {Theme = {['Color'] = 'Border 3'}})
        menu.objects.group_outline_2 = library:create('outline', menu.objects.group_outline_1,  {Theme = {['Color'] = 'Border'}})
        menu.objects.outline_inner_1 = library:create('outline', menu.objects.background,       {Theme = {['Color'] = 'Border 1'}})
        menu.objects.outline_inner_2 = library:create('outline', menu.objects.outline_inner_1,  {Theme = {['Color'] = 'Border 2'}})
        menu.objects.outline_middle  = library:create('outline', menu.objects.outline_inner_2,  {Theme = {['Color'] = 'Border 3'}, Thickness = {19, 5, 5, 5}})
        menu.objects.outline_outer_1 = library:create('outline', menu.objects.outline_middle,   {Theme = {['Color'] = 'Accent'}})
        menu.objects.outline_outer_2 = library:create('outline', menu.objects.outline_outer_1,  {Theme = {['Color'] = 'Border 1'}})

        menu.objects.drag_interaction = library:create('rect', {
            Size = udim2_new(1,0,1,0),
            Active = true,
            Thickness = 1,
            ZIndex = 3,
            Transparency = 0,
            Parent = menu.objects.outline_outer_2
        })

        menu.objects.drag_fade = library:create('rect', {
            Size = udim2_new(1,0,1,0),
            Thickness = 1,
            ZIndex = 100,
            Transparency = 0,
            Parent = menu.objects.outline_outer_2
        })

        library:connection(menu.objects.drag_interaction.MouseButton1Down, function()
            if menu.dragging then
                return
            end

            local drag_position_start = menu.objects.background.AbsolutePosition
            local mouse_position_start = inputservice:GetMouseLocation()
            local start_relative_pos = mouse_position_start - drag_position_start
            local drag_position = mouse_position_start - start_relative_pos

            local drag_object = library:create('rect', {
                Size = udim2_offset(menu.objects.outline_outer_2.AbsoluteSize.X, menu.objects.outline_outer_2.AbsoluteSize.Y),
                Position = udim2_offset(drag_position.X - 9, drag_position.Y - 23),
                Color = color3_new(1,1,1),
                Filled = false,
                Thickness = 1,
                Transparency = 0,
                ZIndex = 100,
            })

            local inputchanged; inputchanged = library:connection(inputservice.InputChanged, function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    local position = inputservice:GetMouseLocation() - start_relative_pos
                    drag_position = vector2_new(math_clamp(position.X, 9, (camera.ViewportSize.X + 9) - menu.objects.outline_outer_2.AbsoluteSize.X), math_clamp(position.Y, 23, (camera.ViewportSize.Y + 23) - menu.objects.outline_outer_2.AbsoluteSize.Y))
                    drag_object.Position = udim2_offset(drag_position.X - 9, drag_position.Y - 23)
                end
            end)

            local inputended; inputended = library:connection(inputservice.InputEnded, function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    inputchanged:Disconnect()
                    inputended:Disconnect()

                    utility:tween(menu.objects.background, 'Position', udim2_offset(drag_position.X, drag_position.Y), 0.15, Enum.EasingStyle.Quad)
                    utility:tween(menu.objects.drag_fade, 'Transparency', 0, 0.075)
                    utility:tween(drag_object, 'Transparency', 0, 0.075).Completed:Wait()
                    drag_object:Remove()
                    menu.dragging = false

                end
            end)

            menu.dragging = true
            utility:tween(drag_object, 'Transparency', 1, 0.075)
            utility:tween(menu.objects.drag_fade, 'Transparency', 0.2, 0.075).Completed:Wait()
        end)

        return menu
    end, {

        set_open = function(self, bool, duration)
            if bool == self.open then return end

            duration = duration or 0

            local objects = self.objects.background:GetDescendants()
            table_insert(objects, self.objects.background)

            for _,v in next, objects do
                if v.Transparency ~= 0 then
                    if bool then
                        utility:tween(v, 'Transparency', self.visvalues[v] or 1, duration)
                    else
                        self.visvalues[v] = v.Transparency
                        utility:tween(v, 'Transparency', 0.05, duration)
                    end
                end
            end

            task.spawn(function()
                if not bool then
                    task.wait(duration)
                end
                if library.screengui then
                    library.screengui.Enabled = bool
                end
                self.objects.background.Visible = bool
                self.open = bool
            end)
        end,

        tab = function(self, properties)
            local tab = library:create('tab', properties, self.objects.tab_container)
            tab.sections = {}
            tab.order = properties.order or #self.tabs + 1
            tab.parent = self

            library:connection(tab.objects.background.MouseButton1Down, function()
                if self.selected == tab then return end
                self.selected = tab
                self:refresh()
            end)

            if self.selected == nil then
                self.selected = tab
            end

            table_insert(self.tabs, tab)
            return tab
        end,

        refresh = function(self)
            table_sort(self.tabs, function(a,b)
                return a.order < b.order
            end)

            for i, tab in next, self.tabs do
                local selected = tab == self.selected
                tab.objects.background.Size     = udim2_new(1 / #self.tabs, i == #self.tabs and 0 or -1, 1, 0)
                tab.objects.background.Position = udim2_new((i - 1) * (1 / #self.tabs), 0, 0, 0)
                tab.objects.background.Theme    = {['Color'] = selected and 'Selected Tab' or 'Unselected Tab'}
                tab.objects.text.Theme          = {['Color'] = selected and 'Accent' or 'Unselected Tab Text'}
                tab.objects.gradient.Data       = selected and library.images.gradientn90 or library.images.gradientp90
                tab:update_sections()
            end
        end
    }, true)

    -- tab
    library:define('tab', function(meta, properties, container, parent)
        local tab = setmetatable({}, meta)
        tab.text = properties.text or ''
        tab.objects = {}

        tab.objects.background = library:create('rect', {
            Name = 'tab',
            Theme = {['Color'] = 'Unselected Tab'},
            Active = true,
            Size = udim2_new(1,0,1,0),
            Parent = container,
            ZIndex = 6
        })

        tab.objects.gradient = library:create('rect', {
            Size = udim2_new(1,0,1,0),
            Parent = tab.objects.background,
            Transparency = 0.75,
            ZIndex = 6
        }, 'Image')

        tab.objects.text = library:create('text', {
            Theme = {['Color'] = 'Unselected Tab Text'},
            Position = udim2_new(0.5,0,0.5,-7),
            Center = true,
            Text = properties.text,
            Parent = tab.objects.background,
            ZIndex = 7
        })

        tab.objects.outline_1 = library:create('outline', tab.objects.background, {Theme = {['Color'] = 'Border 3'}})
        tab.objects.outline_2 = library:create('outline', tab.objects.outline_1,  {Theme = {['Color'] = 'Border'}})

        return tab
    end, {

        section = function(self, properties)
            local side = math_clamp(properties.side or 1, 1, 2)
            local section = library:create('section', properties, self.parent.objects['section_container_' .. side])
            section.options = {}
            section.side = side
            section.parent = self
            section.class = 'section'

            function section:update_options()
                self.parent:update_sections()
            end

            table_insert(self.sections, section)
            return setmetatable(section, library.meta.options)
        end,

        update_sections = function(self)
            local pos_y_1 = 0
            local pos_y_2 = 0
            for _, section in next, self.sections do
                local size_y = 0
                for _, option in next, section.options do
                    option.objects.container.Visible = option.enabled
                    if not option.enabled then
                        continue
                    end

                    if option.class == 'toggle' then
                        option:update_options()
                    end

                    option.objects.container.Position = udim2_new(0, 0, 0, 2 + size_y)
                    size_y = size_y + option.objects.container.AbsoluteSize.Y + 1
                end

                section.objects.background.Visible = self.parent.selected == self
                section.objects.background.Position = udim2_new(0, 0, 0, section.side == 1 and pos_y_1 or pos_y_2)
                section.objects.background.Size = udim2_new(1, 0, 0, size_y + 15)
                
                if section.side == 1 then
                    pos_y_1 = pos_y_1 + section.objects.background.AbsoluteSize.Y + 15
                else
                    pos_y_2 = pos_y_2 + section.objects.background.AbsoluteSize.Y + 15
                end
            end
        end
    }, true)

    -- section
    library:define('section', function(default_properties, properties, container)
        local section = {}
        section.text = properties.text or ''
        section.objects = {}

        section.objects.background = library:create('rect', {
            Name = 'section',
            Theme = {['Color'] = 'Section Background'},
            Size = udim2_new(1,0,0,60),
            Parent = container,
            ZIndex = 6,
        })

        section.objects.accent = library:create('rect', {
            Theme = {['Color'] = 'Accent'},
            Size = udim2_new(1,0,0,1),
            Parent = section.objects.background,
            ZIndex = 7
        })

        section.objects.text = library:create('text', {
            Theme = {['Color'] = 'Primary Text'},
            Position = udim2_new(0,10,0,-8),
            Text = properties.text,
            Parent = section.objects.background,
            ZIndex = 9,
        })

        section.objects.text_border = library:create('rect', {
            Theme = {['Color'] = 'Section Background'},
            Size = udim2_new(0, section.objects.text.TextBounds.X + 8, 0, 3),
            Position = udim2_new(0,6,0,-2),
            Parent = section.objects.background,
            ZIndex = 8
        })

        section.objects.container = library:create('rect', {
            Size = udim2_new(1,-14,1,-10),
            Position = udim2_new(0,7,0,10),
            Parent = section.objects.background,
            Transparency = 0,
            ZIndex = 7
        })

        section.objects.outline_1 = library:create('outline', section.objects.background, {Theme = {['Color'] = 'Border'}, Thickness = {1,1,1,1}})
        section.objects.outline_2 = library:create('outline', section.objects.outline_1,  {Theme = {['Color'] = 'Border 3'}, Thickness = {1,1,1,1}})

        return setmetatable(section, {
            __index = function(self, idx)
                if self[idx] ~= nil then
                    return self[idx]
                elseif library.meta.options[idx] ~= nil then
                    return library.meta.options[idx]
                end
            end
        })
    end)

    -- option
    library:define('option', function(default_properties, properties, parent, id)
        print(id, properties.flag)

        local option = {}
        option._type    = 'option'
        option.class    = id
        option.parent   = parent
        option.flag     = properties.flag
        option.order    = properties.order or #option.parent.options + 1
        option.enabled  = properties.enabled == nil and true or properties.enabled
        option.zindex   = properties.zindex or 15
        option.text     = properties.text or ''
        option.callback = properties.callback or function() end
        option.objects  = {}
        option.options  = {}

        option.objects.container = library:create('rect', {
            Name = id or 'option',
            Size = properties.size or udim2_new(1,0,0,18),
            Position = properties.position,
            AnchorPoint = properties.anchorpoint,
            Transparency = 0,
            Active = true,
            ZIndex = option.zindex,
            Parent = option.parent.objects.container
        })

        option.objects.label = library:create('text', {
            Theme = {['Color'] = 'Option Text 2', ['OutlineColor'] = 'Border 1'},
            Position = udim2_new(0,0,0,1),
            Text = option.text,
            Outline = true,
            Parent = option.objects.container,
            ZIndex = option.zindex + 5
        })

        if option.flag ~= nil then
            library.options[option.flag] = option
        end

        return setmetatable(option, library.meta.options[id])
    end)

    -- colorpicker slider
    library:define('colorpickerslider', function(default_properties, container, properties)
        local slider = {}

        slider.container = library:create('rect', {
            Name = properties.id,
            Active = true,
            Size = udim2_new(0,10,1,0),
            Position = properties.position,
            Parent = container,
            ZIndex = container.ZIndex + 3,
        })

        slider.hue_image = library:create('rect', {
            Data = properties.image,
            Size = udim2_new(1,0,1,0),
            Parent = slider.container,
            ZIndex = container.ZIndex + 4,
        }, 'Image')

        slider.slider = library:create('rect', {
            Size = udim2_new(1,0,0,3),
            Filled = false,
            Thickness = 1,
            Parent = slider.container,
            ZIndex = container.ZIndex + 5,
        })

        slider.hue_border_inner = library:create('outline', slider.container, {['Theme'] = {['Color'] = 'Border'}})
        slider.hue_border_outer = library:create('outline', slider.hue_border_inner, {['Theme'] = {['Color'] = 'Border 3'}})

        return slider
    end)

    -- colorpicker
    library:define('colorpicker', function(default_properties, properties)
        local colorpicker = setmetatable({}, library.meta.colorpicker)
        colorpicker.objects = {}
        colorpicker.options = {}
        colorpicker.color   = color3_new(1,1,1)
        colorpicker.hex     = colorpicker.color:ToHex()
        colorpicker.hue     = ({colorpicker.color:ToHSV()})[1] -- this is retarded its just to keep it clean(ish)
        colorpicker.sat     = ({colorpicker.color:ToHSV()})[2]
        colorpicker.val     = ({colorpicker.color:ToHSV()})[3]
        colorpicker.opacity = 1
        colorpicker.zindex  = properties.zindex or 30

        colorpicker.objects.background = library:create('rect', {
            Name = 'colorpicker',
            Theme = {['Color'] = 'Group Background'},
            Active = true,
            Size = udim2_new(0,206,0,258),
            Position = udim2_new(1,-2,1,2),
            AnchorPoint = vector2_new(1,0),
            ZIndex = colorpicker.zindex
        })

        colorpicker.objects.label = library:create('text', {
            Text = 'colorpicker name',
            Theme = {['Color'] = 'Primary Text'},
            Position = udim2_new(0,6,0,1),
            Outline = true,
            Parent = colorpicker.objects.background,
            ZIndex = colorpicker.zindex + 1
        })

        colorpicker.objects.color = library:create('rect', {
            Name = 'color palette',
            Color = colorpicker.color,
            Active = true,
            Size = udim2_new(0,150,0,150),
            Position = udim2_new(0,8,0,20),
            Parent = colorpicker.objects.background,
            ZIndex = colorpicker.zindex + 5,
        })

        colorpicker.objects.sat = library:create('rect', {
            Data = library.images.colorsat1,
            Size = udim2_new(1,0,1,0),
            Parent = colorpicker.objects.color,
            ZIndex = colorpicker.zindex + 6,
        }, 'Image')

        colorpicker.objects.val = library:create('rect', {
            Data = library.images.colorsat2,
            Size = udim2_new(1,0,1,0),
            Parent = colorpicker.objects.color,
            ZIndex = colorpicker.zindex + 7,
        }, 'Image')

        colorpicker.objects.pointer = library:create('rect', {
            Position = udim2_new(1,0.5,1,0),
            Size = udim2_new(0,1,0,1),
            Color = color3_new(1,1,1),
            ZIndex = colorpicker.zindex + 7,
            Parent = colorpicker.objects.color
        })

        colorpicker.objects.container = library:create('rect', {
            Name = 'container',
            Size = udim2_new(0,194,0,75),
            Position = udim2_new(0,-2,1,5),
            Transparency = 0,
            Parent = colorpicker.objects.color,
            ZIndex = colorpicker.zindex + 1,
        })

        colorpicker.objects.pointer_outline = library:create('outline', colorpicker.objects.pointer)
        colorpicker.objects.border_inner = library:create('outline', colorpicker.objects.background, {['Theme'] = {['Color'] = 'Border 3'}})
        colorpicker.objects.border_outer = library:create('outline', colorpicker.objects.border_inner,   {['Theme'] = {['Color'] = 'Border'}})
        colorpicker.objects.color_border_inner = library:create('outline', colorpicker.objects.color,   {['Theme'] = {['Color'] = 'Border'}})
        colorpicker.objects.color_border_outer = library:create('outline', colorpicker.objects.color_border_inner, {['Theme'] = {['Color'] = 'Border 3'}})
        colorpicker.objects_hue = library:create('colorpickerslider', colorpicker.objects.color, {position = udim2_new(1,10,0,0),  image = library.images.colorhue, id = 'hue'})
        colorpicker.objects_opacity = library:create('colorpickerslider', colorpicker.objects.color, {position = udim2_new(1,30,0,0), image = library.images.colortrans, id = 'opacity'})

        colorpicker.accent_toggle = colorpicker:toggle({
            text = 'use accent',
            flag = 'COLORPICKER_ACCENT_TOGGLE',
            position = udim2_new(0,1,0,0),
            zindex = colorpicker.zindex + 10,
            callback = function(bool)
                if not colorpicker.selected or colorpicker.selected.flag == 'theme_accent' then return end
                
                colorpicker.selected.useaccent = bool

                if bool then
                    colorpicker:set(library.theme.Accent, colorpicker.selected.opacity)
                    colorpicker.selected:set(library.theme.Accent, colorpicker.selected.opacity) 
                end
            end
        })

        colorpicker.rainbow_toggle = colorpicker:toggle({
            text = 'rainbow',
            flag = 'COLORPICKER_RAINBOW_TOGGLE',
            position = udim2_new(0,1,0,20),
            zindex = colorpicker.zindex + 10,
            callback = function(bool)
                if not colorpicker.selected then return end

                colorpicker.selected.rainbow = bool

                if bool then
                    table.insert(library.rainbows, colorpicker.selected)
                elseif table.find(library.rainbows, colorpicker.selected) then
                    table.remove(library.rainbows, table.find(library.rainbows, colorpicker.selected))
                end
            end
        })

        colorpicker.hex_button = colorpicker:button({
            text = '#' .. colorpicker.hex,
            size = udim2_new(0.5,-2,0,18),
            position = udim2_new(0,1,0,40),
            zindex = colorpicker.zindex + 10
        })

        colorpicker.reset = colorpicker:button({
            text = 'reset',
            size = udim2_new(0.5,-2,0,18),
            position = udim2_new(0.5,2,0,40),
            zindex = colorpicker.zindex + 10,
            callback = function()
                if not colorpicker.selected then return end
                colorpicker:set(colorpicker.selected.default or color3_new(1,1,1), colorpicker.selected.default_opacity or 0)
            end
        })

        colorpicker.copy = colorpicker:button({
            text = 'copy',
            size = udim2_new(0.5,-2,0,18),
            position = udim2_new(0,1,0,60),
            zindex = colorpicker.zindex + 10,
            callback = function()
                if not colorpicker.selected then return end
                library.colorpicker_copied_color = colorpicker.selected.color
                library.colorpicker_copied_opacity = colorpicker.selected.opacity
                setclipboard(colorpicker.selected.color:ToHex())
            end
        })

        colorpicker.paste = colorpicker:button({
            text = 'paste',
            size = udim2_new(0.5,-2,0,18),
            position = udim2_new(0.5,2,0,60),
            zindex = colorpicker.zindex + 10,
            callback = function()
                if not colorpicker.selected then return end
                colorpicker:set(library.colorpicker_copied_color or color3_new(1,1,1), library.colorpicker_copied_opacity or 0)
            end
        })

        library:connection(colorpicker.objects.color.MouseButton1Down, function()
            colorpicker.dragging_sat = true
            colorpicker:update()
        end)

        library:connection(colorpicker.objects_hue.container.MouseButton1Down, function()
            colorpicker.dragging_hue = true
            colorpicker:update()
        end)

        library:connection(colorpicker.objects_opacity.container.MouseButton1Down, function()
            colorpicker.dragging_opacity = true
            colorpicker:update()
        end)

        library:connection(inputservice.InputEnded, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                colorpicker.dragging_opacity = false
                colorpicker.dragging_sat = false
                colorpicker.dragging_hue = false
            end
        end)

        library:connection(inputservice.InputChanged, function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and (colorpicker.dragging_hue or colorpicker.dragging_sat or colorpicker.dragging_opacity) then
                colorpicker:update()
            end
        end)

        colorpicker.objects.background.Visible = false
        colorpicker:set(properties.default or colorpicker.color, properties.default_opacity or colorpicker.opacity)
        return colorpicker
    end)

    -- dropdown option
    library:define('dropdownvalue', function(default_properties, container)
        local objects = {}

        objects.container = library:create('rect', {
            Color = color3_new(1,1,1),
            Size = udim2_new(1,-8,0,15),
            Position = udim2_new(0,2,1,0),
            Transparency = 0,
            Active = true,
            Visible = false,
            ZIndex = 43,
            Parent = container
        })

        objects.label = library:create('text', {
            Theme = {['Color'] = 'Option Text 2'},
            Text = 'placeholder',
            Position = udim2_new(0,2,0,0),
            Outline = true,
            ZIndex = 44,
            Parent = objects.container
        })

        return objects
    end)

    -- notification
    library:define('notification', function()
        local objects = {}
        local zindex = 100

        objects.container = library:create('rect', {
            Name = 'container',
            Size = udim2_new(0,200,0,18),
            Visible = false,
            ZIndex = zindex,
        })

        objects.background = library:create('rect', {
            Name = 'background',
            Theme = {['Color'] = 'Background'},
            Parent = objects.container,
            ZIndex = zindex,
        })

        objects.label = library:create('text', {
            Theme = {['Color'] = 'Primary Text'},
            Position = udim2_new(0.5,1,0,0),
            Center = true,
            Parent = objects.background,
            ZIndex = zindex + 1,
        })

        objects.accent = library:create('rect', {
            Name = 'accent',
            Theme = {['Color'] = 'Accent'},
            Size = udim2_new(0,1,1,0),
            Parent = objects.background,
            ZIndex = zindex + 1,
        })

        objects.progress = library:create('rect', {
            Name = 'progress',
            Theme = {['Color'] = 'Accent'},
            Size = udim2_new(0,0,0,1),
            Position = udim2_new(0,0,1,-1),
            Parent = objects.background,
            ZIndex = zindex + 1,
        })

        objects.border_inner = library:create('outline', objects.background,   {Theme = {['Color'] = 'Border 3'}})
        objects.border_outer = library:create('outline', objects.border_inner, {Theme = {['Color'] = 'Border'}})

        return objects
    end)

    -- watermark
    library:define('watermark', function(properties)
        local watermark = {}
        watermark.lastupdate = 0
        watermark.enabled = false
        watermark.objects = {}
        watermark.text = properties.text or {
            'hyphon.cc',
            'liamm#0223',
            'uid 1',
            '999ms',
            '999 fps'
        }

        watermark.objects.background = library:create('rect', {
            Position = udim2_new(0,10,0,10),
            Theme = {['Color'] = 'Background'},
            Visible = false
        })

        watermark.objects.label = library:create('text', {
            Theme = {['Color'] = 'Primary Text'},
            Position = udim2_new(0.5,0,0,2),
            Center = true,
            Parent = watermark.objects.background
        })

        watermark.objects.accent = library:create('rect', {
            Theme = {['Color'] = 'Accent'},
            Size = udim2_new(1,0,0,1),
            Parent = watermark.objects.background
        })

        
        watermark.objects.outline = library:create('outline', watermark.objects.background, {Theme = {['Color'] = 'Border 1'}})
        watermark.objects.outline2 = library:create('outline', watermark.objects.outline, {Theme = {['Color'] = 'Border 2'}})

        library:connection(runservice.RenderStepped, function(delta)
            library.stat.fps = 1 / delta
            library.stat.ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()

            watermark.objects.background.Visible = watermark.enabled

            if tick() - watermark.lastupdate > 0.1 and watermark.enabled then
                watermark.lastupdate = tick()

                watermark.text[4] = tostring(math_floor(library.stat.ping)) .. 'ms'
                watermark.text[5] = tostring(math_floor(library.stat.fps)) .. ' fps'

                watermark.objects.label.Text = table_concat(watermark.text, ' / ')
                watermark.objects.background.Size = udim2_new(0, watermark.objects.label.TextBounds.X + 10, 0, 18) 
            end
        end)


        return watermark
    end)

    -- indicator
    library:define('indicator', function(meta, properties)
        local indicator = setmetatable({}, meta)
        properties = properties or {}
        indicator.title = properties.title or 'title'
        indicator.position = properties.position or udim2_new(0,0,0,0)
        indicator.enabled = true
        indicator.values = {}
        indicator.objects = {}
        indicator.zindex = 0
        
        indicator.objects.background = library:create('rect', {
            Theme = {['Color'] = 'Background'},
        })

        indicator.objects.accent = library:create('rect', {
            Theme = {['Color'] = 'Accent'},
            Size = udim2_new(1,0,0,1),
            Parent = indicator.objects.background,
        })

        indicator.objects.title = library:create('text', {
            Theme = {['Color'] = 'Primary Text'},
            Position = udim2_new(0.5,0,0,2),
            Center = true,
            Text = indicator.title,
            Parent = indicator.objects.background,
        })

        indicator.objects.border_inner = library:create('outline', indicator.objects.background, {Theme = {['Color'] = 'Border 3'}})
        indicator.objects.border_outer = library:create('outline', indicator.objects.border_inner, {Theme = {['Color'] = 'Border'}})

        indicator:set_enabled(properties.enabled == nil and true or properties.enabled)
        indicator:update()
        return indicator
    end, {

        set_enabled = function(self, bool)
            if (self.enabled and not bool) or (not self.enabled and bool) then
                self.objects.background.Visible = bool
                self.enabled = bool
            end
        end,

        set_title = function(self, text, noupdate)
            self.objects.title.Text = tostring(text)
            if not noupdate then
                self:update()
            end
        end,

        update = function(self)
            local size_x = math_max(125, self.objects.title.TextBounds.X + 24)
            local pos_y = 21

            for idx, value in next, self.values do

                if not value.enabled then
                    continue
                end

                value.objects.background.Position = udim2_new(0,0,0,pos_y)

                local size_y

                if value.alignment == 'vertical' then
                    size_y = value.objects.key.TextBounds.Y + value.objects.value.TextBounds.Y
                    size_x = math_max(size_x, value.objects.key.TextBounds.X + 12, value.objects.value.TextBounds.X + 12)
                    value.objects.value.Position = udim2_new(0, 6, 0, value.objects.key.TextBounds.Y - 8)
                else
                    size_y = math_max(value.objects.key.TextBounds.Y + 4, value.objects.value.TextBounds.Y + 4)
                    size_x = math_max(size_x, value.objects.key.TextBounds.X + 35 + value.objects.value.TextBounds.X)
                end

                value.objects.background.Size = udim2_new(1,0,0,size_y)
                pos_y = pos_y + size_y

            end

            self.objects.background.Size = udim2_new(0, size_x, 0, 18)
            self.objects.background.Position = self.position
        end,

        value = function(self, properties)
            local value = library:create('indicator_value', properties, self)
            table_insert(self.values, value)
            self:update()
            return value
        end

    }, true)

    library:define('indicator_value', function(meta, properties, parent)
        local value = setmetatable({}, meta)
        value.parent = parent
        value.key = properties.key or 'key'
        value.value = properties.value or 'value'
        value.alignment = properties.alignment or 'horizontal'
        value.objects = {}
        value.enabled = true

        value.objects.background = library:create('rect', {
            Theme = {['Color'] = 'Background'},
            Size = value.alignment == 'vertical' and udim2_new(1,0,0,36) or udim2_new(1,0,0,18),
            Parent = parent.objects.background
        })

        value.objects.key = library:create('text', {
            Theme = {['Color'] = 'Primary Text'},
            Position = udim2_new(0,6,0,1),
            Text = value.key,
            Parent = value.objects.background
        })

        value.objects.value = library:create('text', {
            Theme = {['Color'] = 'Secondary Text'},
            Position = value.alignment == 'vertical' and udim2_new(0,6,0,0) or udim2_new(1,-6,0,1),
            AnchorPoint = value.alignment == 'vertical' and vector2_new(0,0) or vector2_new(1,0),
            Text = value.value,
            Parent = value.objects.background
        })

        value.objects.border_inner = library:create('outline', value.objects.background, {Theme = {['Color'] = 'Border 3'}})
        value.objects.border_outer = library:create('outline', value.objects.border_inner, {Theme = {['Color'] = 'Border'}})

        value:set_enabled(properties.enabled == nil and true or properties.enabled)
        return value
    end, {

        set_value = function(self, text, noupdate)
            self.objects.value.Text = tostring(text)
            if not noupdate then
                self.parent:update()
            end
        end,

        set_key = function(self, text, noupdate)
            self.objects.key.Text = tostring(text)
            if not noupdate then
                self.parent:update()
            end
        end,

        set_enabled = function(self, bool)
            if (self.enabled and not bool) or (not self.enabled and bool) then
                self.objects.background.Visible = bool
                self.enabled = bool
                self.parent:update()
            end
        end

    }, true)

end

-- // listeners
do

    function camera_added(camera)
        if library.camera then
            library.camera_connection:Disconnect()
        end

        library.camera = workspace.CurrentCamera
        library.screensize = library.camera.ViewportSize
        library.camera_connection = library:connection(library.camera:GetPropertyChangedSignal('ViewportSize'), function()
            library.screensize = library.camera.ViewportSize
        end)
    end

    camera_added(workspace.CurrentCamera)

    library:connection(workspace:GetPropertyChangedSignal('CurrentCamera'), camera_added)

    library.debug_object = library:create('rect', {
        Color = color3_new(1,1,1),
        Size = udim2_new(1,2,1,2),
        Position = udim2_new(0,-1,0,-1),
        Filled = false,
        Thickness = 1,
        ZIndex = 9999,
    })
    
    library.debug_text = library:create('text', {
        Color = color3_new(1,1,1),
        Position = udim2_new(0.5,0,1,0),
        Center = true,
        Outline = true,
        ZIndex = 9999,
        Parent = library.debug_object,
    })

    library:connection(inputservice.InputBegan, function(input, processed)
        -- if processed then return end

        if input.KeyCode == Enum.KeyCode.Equals and inputservice:IsKeyDown(Enum.KeyCode.LeftControl) and not processed then
            game:GetService('TeleportService'):Teleport(game.PlaceId)
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            if library.colorpicker.selected ~= nil and not utility.vector2.inside(inputservice:GetMouseLocation(), library.colorpicker.objects.background.AbsolutePosition, library.colorpicker.objects.background.AbsoluteSize) then
                library.colorpicker.selected = nil
                library.colorpicker.objects.background.Parent = nil
                library.colorpicker.objects.background.Visible = false
            end

            local hover_object = library:get_hover_object()
            if hover_object then
                hover_object.MouseButton1Down:Fire()
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            local hover_object = library:get_hover_object()
            if hover_object then
                hover_object.MouseButton2Down:Fire()
            end
        end
    end)

    library:connection(inputservice.InputEnded, function(input, processed)
        -- if processed then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then

            library.dragging_slider = nil

            local hover_object = library:get_hover_object()
            if hover_object then
                hover_object.MouseButton1Up:Fire()
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            local hover_object = library:get_hover_object()
            if hover_object then
                hover_object.MouseButton2Up:Fire()
            end
        end
    end)

    library:connection(inputservice.InputChanged, function(input, processed)

        if input.UserInputType == Enum.UserInputType.MouseMovement then

            for i,v in next, library.fovcircles do
                if v._mode == 'mouse' then
                    v:update()
                end
            end

            if not (library.has_init and library.menu and library.menu.open) then
                return
            end

            local mouse_pos = inputservice:GetMouseLocation()
            local hover_object = library:get_hover_object()

            if library.debugmode then
                local debug_calc_start = tick()
                local debug_hover_object

                table_sort(library.drawings.objects, function(a,b)
                    return a.ZIndex > b.ZIndex
                end)

                for index, drawing in next, library.drawings.objects do
                    if drawing.Name ~= '' and drawing._object.Visible and utility.vector2.inside(mouse_pos, drawing.AbsolutePosition, drawing.AbsoluteSize) then
                        debug_hover_object = drawing
                        break
                    end
                end

                if debug_hover_object then
                    if library.debug_object.Parent ~= debug_hover_object then
                        library.debug_object.Visible = true
                        library.debug_object.Parent = debug_hover_object
                        library.debug_text.Text = ('Name: %s\nSize: %s\nPosition: %s\nZIndex: %s\nChildren: %s\nCalculate: %s'):format(
                            debug_hover_object.Name,
                            utility:get_size_string(debug_hover_object.Size, debug_hover_object.AbsoluteSize),
                            utility:get_size_string(debug_hover_object.Position, debug_hover_object.AbsolutePosition),
                            debug_hover_object.ZIndex,
                            #debug_hover_object._children,
                            math_floor(((tick() - debug_calc_start) * 1000) * 10000) / 10000 .. 'ms'
                        ) 
                    end
                else
                    library.debug_object.Parent = nil
                    library.debug_object.Visible = false
                end
            else
                library.debug_object.Parent = nil
                library.debug_object.Visible = false
            end

            for index, drawing in next, library.drawings.active do
                if drawing._object.Visible then
                    if hover_object == drawing and not drawing.MouseHover then
                        drawing._properties.MouseHover = true
                        drawing.MouseEnter:Fire()
                    elseif not (hover_object == drawing) and drawing.MouseHover then
                        drawing._properties.MouseHover = false
                        drawing.MouseLeave:Fire()
                    end
                end
            end

            if library.dragging_slider then
                library.dragging_slider:update()
            end

        end
    end)

    library:connection(camera:GetPropertyChangedSignal('FieldOfView'), function()
        for i,v in next, library.fovcircles do
            v:update()
        end
    end)

    library:connection(camera:GetPropertyChangedSignal('ViewportSize'), function()
        for i,v in next, library.drawings.noparent do
            v.Size = v.Size
            v.Position = v.Position
        end
        for i,v in next, library.fovcircles do
            v:update()
        end
    end)

    task.spawn(function()
        while task.wait(1 / 60) do
            local color = color3_hsv((tick() / 5) % 1, 0.5, 1)
            for i,v in next, library.rainbows do
                if not v.useaccent then
                    v:set(color, v.opacity)
                end
            end
        end
    end)

end

-- // finish
library.keybind_indicator = library:create('indicator', {title = 'keybinds', position = udim2_new(0,10,0,450), enabled = false})
library.colorpicker = library:create('colorpicker', {})
library.dropdown = {selected = nil, objects = {values = {}}, connections = {}}

library.dropdown.objects.background = library:create('rect', {
    Theme = {['Color'] = 'Background'},
    Size = udim2_new(1,-4,0,20),
    Position = udim2_new(0.5,0,1,0),
    AnchorPoint = vector2_new(0.5,0),
    Visible = false,
    ZIndex = 40,
})

-- library.dropdown.objects.scroll = library:create('rect', {
--     Theme = {['Color'] = 'Accent'},
--     Size = udim2_new(0,2,0.5,0),
--     Position = udim2_new(1,-1,0,1),
--     AnchorPoint = vector2_new(1,0),
--     ZIndex = 42,
--     Parent = library.dropdown.objects.background 
-- })

library.dropdown.objects.border_inner = library:create('outline', library.dropdown.objects.background, {Theme = {['Color'] = 'Border 3'}})
library.dropdown.objects.border_outer = library:create('outline', library.dropdown.objects.border_inner, {Theme = {['Color'] = 'Border'}})

function library:create_settings_tab(menu)
    local tab = menu:tab({text = 'settings', order = 999})
    local settings_main = tab:section({text = 'main', side = 1})
    local settings_config = tab:section({text = 'config', side = 2})

    settings_main:keybind({text = 'open / close', flag = 'menubind', default = Enum.KeyCode.End, callback = function(bool)
        menu:set_open(bool, 0.1)
    end})

    settings_main:colorpicker({text = 'accent', flag = 'theme_accent', default = library.themes.default.Accent, callback = function(color)
        library.theme.Accent = color
        library:update_theme()
    end})

    settings_main:toggle({text = 'keybind indicator', flag = 'keybind_indicator_enabled', callback = function(bool)
        library.keybind_indicator:set_enabled(bool)
    end})

    settings_main:button({text = 'join discord', callback = function()
        local res = request({
            Url = 'http://127.0.0.1:6463/rpc?v=1',
            Method = 'POST',
            Headers = {
                ['Content-Type'] = 'application/json',
                Origin = 'https://discord.com'
            },
            Body = http:JSONEncode({
                cmd = 'INVITE_BROWSER',
                nonce = http:GenerateGUID(false),
                args = {code = 'JAp8z9BtBB'}
            })
        })
        if res.Success then
            library:notification(library.cheatname .. ' | joined discord', 3);
        end
    end})

    settings_main:button({text = 'copy javascript invite', callback = function()
        setclipboard('Roblox.GameLauncher.joinGameInstance('..game.PlaceId..',"'..game.JobId..'")')
    end})

    settings_main:button({text = 'rejoin', confirm = true, callback = function()
        game:GetService('TeleportService'):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end})


    settings_config:dropdown({text = 'config', flag = 'configs_selected'})
    settings_config:textbox({text = 'config name', flag = 'configs_input'})

    settings_config:button({text = 'create', confirm = true, callback = function()
        xpcall(function()
            library:save_config(flags.configs_input, true)
            library:notification(("successfully created config '%s'"):format(flags.configs_input), 5, color3_new(0.35, 1, 0.35))
        end, function()
            library:notification(("unable to create config '%s'"):format(flags.configs_input), 5, color3_new(1, 0.35, 0.35))
        end)
    end})

    settings_config:button({text = 'save', confirm = true, callback = function()
        xpcall(function()
            library:save_config(flags.configs_selected)
            library:notification(("successfully saved config '%s'"):format(flags.configs_selected), 5, color3_new(0.35, 1, 0.35))
        end, function(err)
            library:notification(err or ("unable to save config '%s'"):format(flags.configs_selected), 5, color3_new(1, 0.35, 0.35))
        end)
    end})

    settings_config:button({text = 'load', confirm = true, callback = function()
        xpcall(function()
            library:load_config(flags.configs_selected)
            library:notification(("successfully loaded config '%s'"):format(flags.configs_selected), 5, color3_new(0.35, 1, 0.35))
        end, function(err)
            library:notification(err or ("unable to load config '%s'"):format(flags.configs_selected), 5, color3_new(1, 0.35, 0.35))
        end)
    end})

    if isfolder(library.cheatname .. '/' .. library.gamename .. '/configs') then
        for i,v in next, listfiles(library.cheatname .. '/' .. library.gamename .. '/configs') do
            local ext = '.'..v:split('.')[#v:split('.')];
            if ext == '.txt' then
                options.configs_selected:add_value(v:split('\\')[#v:split('\\')]:sub(1,-#ext-1))
            end
        end
    end

    return tab, settings_main
end

library.has_init = true
getgenv().library = library
return library
