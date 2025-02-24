--[[
    /------------ [ octohook.xyz ui library ] ------------\
    | fully by liamm#0223 (561301972293255180)            |
    | last modified 02/22/2025 by @zuvbruv                |
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
local startup_args = ({ ... })[1] or {}
if library ~= nil then
	library:unload()
end

local themes = {
	["Default"] = {
		["Accent"] = Color3.fromRGB(170, 242, 254),
		["Background"] = Color3.fromRGB(15, 15, 20),
		["Border"] = Color3.fromRGB(0, 0, 0),
		["Border 1"] = Color3.fromRGB(10, 10, 15),
		["Border 2"] = Color3.fromRGB(45, 45, 50),
		["Border 3"] = Color3.fromRGB(35, 35, 40),
		["Primary Text"] = Color3.fromRGB(240, 240, 240),
		["Secondary Text"] = Color3.fromRGB(145, 145, 145),
		["Group Background"] = Color3.fromRGB(20, 20, 25),
		["Selected Tab"] = Color3.fromRGB(20, 20, 25),
		["Unselected Tab"] = Color3.fromRGB(23, 23, 28),
		["Selected Tab Text"] = Color3.fromRGB(240, 240, 240),
		["Unselected Tab Text"] = Color3.fromRGB(145, 145, 145),
		["Section Background"] = Color3.fromRGB(18, 18, 23),
		["Option Text 1"] = Color3.fromRGB(235, 235, 235),
		["Option Text 2"] = Color3.fromRGB(155, 155, 155),
		["Option Border 1"] = Color3.fromRGB(45, 45, 50),
		["Option Border 2"] = Color3.fromRGB(0, 0, 0),
		["Option Background"] = Color3.fromRGB(31, 31, 34),
		["Risky Text"] = Color3.fromRGB(175, 21, 21),
		["Risky Text Enabled"] = Color3.fromRGB(255, 41, 41),
	},

	["Gamesense"] = {
		["Accent"] = Color3.fromRGB(147, 184, 26),
		["Background"] = Color3.fromRGB(17, 17, 17),
		["Border"] = Color3.fromRGB(0, 0, 0),
		["Border 1"] = Color3.fromRGB(47, 47, 47),
		["Border 2"] = Color3.fromRGB(17, 17, 17),
		["Border 3"] = Color3.fromRGB(10, 10, 10),
		["Primary Text"] = Color3.fromRGB(235, 235, 235),
		["Group Background"] = Color3.fromRGB(17, 17, 17),
		["Selected Tab"] = Color3.fromRGB(17, 17, 17),
		["Unselected Tab"] = Color3.fromRGB(17, 17, 17),
		["Selected Tab Text"] = Color3.fromRGB(245, 245, 245),
		["Unselected Tab Text"] = Color3.fromRGB(145, 145, 145),
		["Section Background"] = Color3.fromRGB(17, 17, 17),
		["Option Text 1"] = Color3.fromRGB(245, 245, 245),
		["Option Text 2"] = Color3.fromRGB(195, 195, 195),
		["Option Text 3"] = Color3.fromRGB(145, 145, 145),
		["Option Border 1"] = Color3.fromRGB(47, 47, 47),
		["Option Border 2"] = Color3.fromRGB(0, 0, 0),
		["Option Background"] = Color3.fromRGB(35, 35, 35),
		["Risky Text"] = Color3.fromRGB(175, 21, 21),
		["Risky Text Enabled"] = Color3.fromRGB(255, 41, 41),
	},

	["Tokyo Night"] = {
		["Accent"] = Color3.fromRGB(103, 89, 179),
		["Background"] = Color3.fromRGB(22, 22, 31),
		["Border"] = Color3.fromRGB(0, 0, 0),
		["Border 1"] = Color3.fromRGB(50, 50, 50),
		["Border 2"] = Color3.fromRGB(24, 25, 37),
		["Border 3"] = Color3.fromRGB(10, 10, 10),
		["Primary Text"] = Color3.fromRGB(235, 235, 235),
		["Group Background"] = Color3.fromRGB(24, 25, 37),
		["Selected Tab"] = Color3.fromRGB(24, 25, 37),
		["Unselected Tab"] = Color3.fromRGB(22, 22, 31),
		["Selected Tab Text"] = Color3.fromRGB(245, 245, 245),
		["Unselected Tab Text"] = Color3.fromRGB(145, 145, 145),
		["Section Background"] = Color3.fromRGB(22, 22, 31),
		["Option Text 1"] = Color3.fromRGB(245, 245, 245),
		["Option Text 2"] = Color3.fromRGB(195, 195, 195),
		["Option Text 3"] = Color3.fromRGB(145, 145, 145),
		["Option Border 1"] = Color3.fromRGB(50, 50, 50),
		["Option Border 2"] = Color3.fromRGB(0, 0, 0),
		["Option Background"] = Color3.fromRGB(24, 25, 37),
		["Risky Text"] = Color3.fromRGB(175, 21, 21),
		["Risky Text Enabled"] = Color3.fromRGB(255, 41, 41),
	},

	["Nekocheat"] = {
		["Accent"] = Color3.fromRGB(226, 30, 112),
		["Background"] = Color3.fromRGB(18, 18, 18),
		["Border"] = Color3.fromRGB(0, 0, 0),
		["Border 1"] = Color3.fromRGB(60, 60, 60),
		["Border 2"] = Color3.fromRGB(18, 18, 18),
		["Border 3"] = Color3.fromRGB(10, 10, 10),
		["Primary Text"] = Color3.fromRGB(255, 255, 255),
		["Group Background"] = Color3.fromRGB(18, 18, 18),
		["Selected Tab"] = Color3.fromRGB(18, 18, 18),
		["Unselected Tab"] = Color3.fromRGB(18, 18, 18),
		["Selected Tab Text"] = Color3.fromRGB(245, 245, 245),
		["Unselected Tab Text"] = Color3.fromRGB(145, 145, 145),
		["Section Background"] = Color3.fromRGB(18, 18, 18),
		["Option Text 1"] = Color3.fromRGB(255, 255, 255),
		["Option Text 2"] = Color3.fromRGB(255, 255, 255),
		["Option Text 3"] = Color3.fromRGB(255, 255, 255),
		["Option Border 1"] = Color3.fromRGB(50, 50, 50),
		["Option Border 2"] = Color3.fromRGB(0, 0, 0),
		["Option Background"] = Color3.fromRGB(23, 23, 23),
		["Risky Text"] = Color3.fromRGB(175, 21, 21),
		["Risky Text Enabled"] = Color3.fromRGB(255, 41, 41),
	},

	["Onetap"] = {
		["Accent"] = Color3.fromRGB(255, 165, 0),
		["Background"] = Color3.fromRGB(20, 20, 20),
		["Border"] = Color3.fromRGB(40, 40, 40),
		["Border 1"] = Color3.fromRGB(50, 50, 50),
		["Border 2"] = Color3.fromRGB(60, 60, 60),
		["Border 3"] = Color3.fromRGB(70, 70, 70),
		["Primary Text"] = Color3.fromRGB(255, 255, 255),
		["Secondary Text"] = Color3.fromRGB(200, 200, 200),
		["Group Background"] = Color3.fromRGB(30, 30, 30),
		["Selected Tab"] = Color3.fromRGB(40, 40, 40),
		["Unselected Tab"] = Color3.fromRGB(45, 45, 45),
		["Selected Tab Text"] = Color3.fromRGB(255, 255, 255),
		["Unselected Tab Text"] = Color3.fromRGB(200, 200, 200),
		["Section Background"] = Color3.fromRGB(35, 35, 35),
		["Option Text 1"] = Color3.fromRGB(235, 235, 235),
		["Option Text 2"] = Color3.fromRGB(155, 155, 155),
		["Option Border 1"] = Color3.fromRGB(50, 50, 50),
		["Option Border 2"] = Color3.fromRGB(0, 0, 0),
		["Option Background"] = Color3.fromRGB(40, 40, 40),
		["Risky Text"] = Color3.fromRGB(255, 50, 50),
		["Risky Text Enabled"] = Color3.fromRGB(255, 0, 0),
	},

	["Fatality"] = {
		["Accent"] = Color3.fromRGB(197, 7, 83),
		["Background"] = Color3.fromRGB(25, 19, 53),
		["Border"] = Color3.fromRGB(0, 0, 0),
		["Border 1"] = Color3.fromRGB(60, 53, 93),
		["Border 2"] = Color3.fromRGB(29, 23, 66),
		["Border 3"] = Color3.fromRGB(10, 10, 10),
		["Primary Text"] = Color3.fromRGB(235, 235, 235),
		["Group Background"] = Color3.fromRGB(29, 23, 66),
		["Selected Tab"] = Color3.fromRGB(29, 23, 66),
		["Unselected Tab"] = Color3.fromRGB(25, 19, 53),
		["Selected Tab Text"] = Color3.fromRGB(245, 245, 245),
		["Unselected Tab Text"] = Color3.fromRGB(145, 145, 145),
		["Section Background"] = Color3.fromRGB(25, 19, 53),
		["Option Text 1"] = Color3.fromRGB(245, 245, 245),
		["Option Text 2"] = Color3.fromRGB(195, 195, 195),
		["Option Text 3"] = Color3.fromRGB(145, 145, 145),
		["Option Border 1"] = Color3.fromRGB(60, 53, 93),
		["Option Border 2"] = Color3.fromRGB(0, 0, 0),
		["Option Background"] = Color3.fromRGB(29, 23, 66),
		["Risky Text"] = Color3.fromRGB(175, 21, 21),
		["Risky Text Enabled"] = Color3.fromRGB(255, 41, 41),
	},

	["Twitch"] = {
		["Accent"] = Color3.fromRGB(169, 112, 255),
		["Background"] = Color3.fromRGB(14, 14, 14),
		["Border"] = Color3.fromRGB(0, 0, 0),
		["Border 1"] = Color3.fromRGB(45, 45, 45),
		["Border 2"] = Color3.fromRGB(31, 31, 35),
		["Border 3"] = Color3.fromRGB(10, 10, 10),
		["Primary Text"] = Color3.fromRGB(235, 235, 235),
		["Group Background"] = Color3.fromRGB(31, 31, 35),
		["Selected Tab"] = Color3.fromRGB(31, 31, 35),
		["Unselected Tab"] = Color3.fromRGB(17, 17, 17),
		["Selected Tab Text"] = Color3.fromRGB(225, 225, 225),
		["Unselected Tab Text"] = Color3.fromRGB(160, 170, 175),
		["Section Background"] = Color3.fromRGB(17, 17, 17),
		["Option Text 1"] = Color3.fromRGB(245, 245, 245),
		["Option Text 2"] = Color3.fromRGB(195, 195, 195),
		["Option Text 3"] = Color3.fromRGB(145, 145, 145),
		["Option Border 1"] = Color3.fromRGB(45, 45, 45),
		["Option Border 2"] = Color3.fromRGB(0, 0, 0),
		["Option Background"] = Color3.fromRGB(24, 24, 27),
		["Risky Text"] = Color3.fromRGB(175, 21, 21),
		["Risky Text Enabled"] = Color3.fromRGB(255, 41, 41),
	},
}

-- // variables

-- globals
local vector3_new = Vector3.new
local vector3_zero = Vector3.zero
local vector2_new = Vector2.new
local vector2_zero = Vector2.zero
local cframe_new = CFrame.new
local cframe_zero = CFrame.zero
local color3_new = Color3.new
local color3_hsv = Color3.fromHSV
local color3_hex = Color3.fromHex
local udim_new = UDim.new
local udim2_new = UDim2.new
local udim2_scale = UDim2.fromScale
local udim2_offset = UDim2.fromOffset
local table_find = table.find
local table_sort = table.sort
local table_concat = table.concat
local table_insert = table.insert
local table_remove = table.remove
local table_clear = table.clear
local math_clamp = math.clamp
local math_floor = math.floor
local math_ceil = math.ceil
local math_huge = math.huge
local math_max = math.max
local math_min = math.min
local math_sin = math.sin
local math_cos = math.cos
local math_abs = math.abs
local math_rad = math.rad
local math_pi = math.pi

-- locals
local inputservice = game:GetService("UserInputService")
local actionservice = game:GetService("ContextActionService")
local tweenservice = game:GetService("TweenService")
local runservice = game:GetService("RunService")
local http = game:GetService("HttpService")
local stats = game:GetService("Stats")
local camera = workspace.CurrentCamera
local worldtoviewport = camera.WorldToViewportPoint

local decode = (syn and syn.crypt.base64.decode) or (crypt and crypt.base64decode) or base64_decode

local library = {
	classes = {},
	instances = {},
	connections = {},
	hooks = {},
	meta = {},
	flags = {},
	options = {},
	rainbows = {},
	notifs = {},
	debugmode = false,
	unloaded = false,
	cheatname = "therion",
	gamename = tostring(game.PlaceId),
	themes = themes,
	theme = themes.Default,
	signal = loadstring(
		game:HttpGetAsync("https://raw.githubusercontent.com/scotdotwtf/Hyphon-UI-Library-Reupload/main/signal.lua")
	)(),
	stat = { fps = 0, ping = 0 },
	drawings = {
		active = {},
		draggable = {},
		noparent = {},
		objects = {},
		raw = {},
	},
	utility = {
		table = {},
		vector2 = {},
		vector3 = {},
		camera = {},
		color = {},
		string = {},
	},
	images = {
		["colorsat2"] = decode(
			"iVBORw0KGgoAAAANSUhEUgAAAaQAAAGkCAQAAADURZm+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JQAAgIMAAPn/AACA6QAAdTAAAOpgAAA6mAAAF2+SX8VGAAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAACxMAAAsTAQCanBgAAAAHdElNRQflBwwSLyBEeyyCAAAD4klEQVR42u3YwQnAQAhFQTek/5pz9eBtEYzMlBD4PDcRADDBieMjwK3HJwBDghFepx0oEhgSOO0ARQJDAqcdKBJgSGBI4I0EhgQ47cCQwJDAGwlQJDAkcNqBIgGKBIoEhgROO0CRQJFAkQBDAqcdGBI47QBFAkUCQwKnHaBIoEigSKBIgCKBIYHTDhQJUCQwJHDagSIBigSGBE47UCRAkcCQwGkHKBIoEigSGBLgtANDAkMCbyTAkMBpB4oEigQoEhgSOO1AkQBDAqcdKBIoEqBIYEjgtANFUiRQJFAkMCTAaQeKBIoEigQYEjjtQJFAkQBFAkMCpx0oEmBI4LQDRQJFAhQJDAmcdqBIgCKBIoEhAU47UCRQJFAkwJDAaQeKBIYEOO1AkUCRYHuRTAmcduC0A0UCFAkUCQwJnHaAIoEigSKBIQFOO2gvkimBIoE3EhgS4LQDRQJDAqcdoEigSKBIYEiAIYEhwXx+NoAigSGB0w5QJDAkMCQwJKDiZwMoEhgSOO0ARQJFgnlFMiVw2oHTDhQJUCRQJDAkcNoBVZFMCRQJvJHAkACnHSgSKBIoElANSZPAaQdOOzAkwGkHigSGBIYEGBK08LMBFAkUCRQJMCQwJDAkWMjPBlAkMCRw2gG5SKYEigTeSGBIgNMOFAkMCQwJMCRo4WcDKBIYEjjtgFwkUwJFAm8kMCTAaQeKBIoEigRUQ9IkcNqB0w4MCXDagSKBIsHCIpkSOO3AaQeKBCgSKBIYEhgSYEjQws8GUCQwJHDaAblIpgSKBN5IYEiA0w4UCQwJDAkwJGjhZwMoEhgSOO0ARQJDAkMCQwIqfjaAIoEigSIBhgROO5hXJFMCpx047UCRAEUCRQJDAqcdUBXJlECRwBsJDAlw2oEigSKBIgGGBIYEhgSL+dkAigSGBE47QJHAkMBpB4oEGBIYEhgSrOZnAygSKBIoEmBI4LQDRQJFAhQJDAmcdrC8SKYEigTeSGBIgNMOFAkMCZx2gCKBIoEigSEBTjtQJFAkUCTAkMBpB4oEigQoEhgSOO1AkQBDAqcdKBKgSKBIYEjgtAMUCRQJFAkMCXDagSKBIoEiAYYETjtQJFAkQJHAkMBpB4oEGBI47UCRQJEARQJDAqcdoEigSGBI4LQDFAkUCRQJFAkwJHDagSKBIQFOOzAkMCTwRgIMCZx2oEigSIAigSKBIYHTzkcARQJFAkMCnHZgSGBI4I0EGBI47UCRQJEAQwKnHSgSKBKgSGBI4LQDRQIUCRQJDAmcdoAigSGB0w5QJFAkUCQwJMBpB4oEhgROO0CRwJDAkMAbCVAkMCT4gw/reQYigE05fAAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNy0xMlQxODo0NzozMiswMDowMN2VK3MAAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDctMTJUMTg6NDc6MzIrMDA6MDCsyJPPAAAAAElFTkSuQmCC"
		),
		["colortrans"] = decode(
			"iVBORw0KGgoAAAANSUhEUgAAAAoAAAB9CAYAAACbFfLEAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAAOvSURBVFhHxZa9cRRBEIV1ksDDxMTGx6dKNgkQARkQAgHg4+MTACV5BIBPANjYOvo95ut7M7sn4amr3vXr35nZ3t3bw+3t7cUqNzc3g53kcuhH5QkTD8fjcdCT3N3dDXYSOh4egROvwnEOl3SUtqO2siYZStgkB29oMs+L6ERySI41meYF8WN2kexx60yEZ0IDhwTnXpE7rtgt0GReFGE8cq6T8YGoWLsBif17wUQ3olOjtrLxCbvOBe6uybwskvfaYTwzPRUZVKQWJOm7whB0u2HDgU+dCR1Y7GnW3MAdTGgyr4oooQ9Uk5lsCRVrp1zFW1sDaQPJ7mQU7E4D/cykMzn2tSbzuoiESZx9mylINVw6/d6jWuOEr8tPh9nbW9sZALsFmsybIjmFQ01mmkpJPwqqOre0dQYoyMN08WQUtJXrwadkEmQoQZpLBbyCJvO2iOTcZOzPytxC2tPSONbk9qeRfHMg/eAEsrlE3UCX412RPkjJcTwz5kM7m2pp2d1lcENG7gfkdjoxE3ibqbuS7RMy0Y5CJojb1mTeF0G8+TEZDmTJjrlcdnVchNMqiKa4OQEcaPknQNSVhNxCF2kyH4oo2FNY/mccoyOVdAHqbL9+2nhAT4d5Jl1boZMTBr9WIpenqwdo4Jgm87EI4o2PLwBuPWu6UA1HK267ydBw0DGvP4zUcCWa66eNoeksLuhqXGkyn4pI2HxOZnMYwZULOk57QdVpTwUbx3hmzAsUb949Qh6EAj8zn4uk6AvgvrQSJOLdsSvlDI1vOgxwYAC7D4POk4t3V5yAIji2v82+FEnJ/xl1lExfTXTIJdHeY143Qcmrz4mqYi/5bcYKjuFcQWFrTeZrEUTd9cz8s04yTSa7JJyjn83GC3lyI4MraKCum9tMmquANjSZb8PJNHhm8El3t+wK0uc9Esg9pV8d+zA2hNoKvH2CfuigwNqtocl8LyLpjY/JtF2ye5ulzfKbOzyXF+CdSLcODN0cQ50S+DuuyfwQKfTm422Gb3rP5HJ0bR9GJgmb5ygNo7aSK3QTEvYOkPBkfhbpTUvHZCQ+IBXaU3YV72UFAkIGOgGszgcTzyGL/Mz8KjLJ8gUgmW6zh7D7at7D9jYbkwHEdg+ja8g1VZK5JvO7CFOw1GSmqUjoQLdcTtNqe02AY9OkX1JyrEGBInckIQOr399mf4pMsrzNLFm5dmYL4l4692dncOI+DA6jtkKQmJGJWSBOsqHJTFOR7PzPOPu/5MkSLy7+AlB3zNiqwui3AAAAAElFTkSuQmCC"
		),
		["colorsat1"] = decode(
			"iVBORw0KGgoAAAANSUhEUgAAAaQAAAGkCAQAAADURZm+AAAABGdBTUEAALGPC/xhBQAAACBjSFJNAAB6JQAAgIMAAPn/AACA6QAAdTAAAOpgAAA6mAAAF2+SX8VGAAAAAmJLR0QA/4ePzL8AAAAJcEhZcwAACxMAAAsTAQCanBgAAAAHdElNRQflBwwSLzK3wl3KAAADrElEQVR42u3TORLCMBBFwT+6/50hMqXSZgonBN0BWCDGYPwqeSWVZPWYVHd0Pc5H86v9areu4Sz9u7XZXT/vvtZtu6dtJtYw525iGya05afnWW17ltPE8fzfTZy/yf3vmCes59xf0Sf/42l3lnvGOyyH+y/bo/X689wCPCYkEBIICYQECAmEBEICIQFCAiGBkEBIgJBASCAkEBIgJBASCAmEBAgJhARCAiEBQgIhgZAAIYGQQEggJEBIICQQEggJEBIICYQEQgKEBEICIYGQACGBkEBIICRASCAkEBIICRASCAmEBAgJhARCAiEBQgIhgZBASICQQEggJBASICQQEggJhAQICYQEQgIhAUICIYGQQEguAQgJhARCAoQEQgIhgZAAIYGQQEggJEBIICQQEggJEBIICYQEQgKEBEICIYGQACGBkEBIgJBASCAkEBIgJBASCAmEBAgJhARCAiEBQgIhgZBASICQQEggJBASICQQEggJhAQICYQEQgKEBEICIYGQACGBkEBIICRASCAkEBIICRASCAmEBEIChARCAiGBkAAhgZBASCAkQEggJBASICQQEggJhAQICYQEQgIhAUICIYGQQEiAkEBIICQQEiAkEBIICYQECAmEBEIChARCAiGBkAAhgZBASCAkQEggJBASCAkQEggJhARCAoQEQgIhgZAAIYGQQEggJEBIICQQEiAkEBIICYQECAmEBEICIQFCAiGBkEBIgJBASCAkEBIgJBASCAmEBAgJhARCAiEBQgIhgZAAIYGQQEggJEBIICQQEggJEBIICYQEQgKEBEICIYGQACGBkEBIICRASCAkEBIgJBASCAmEBAgJhARCAiEBQgIhgZBASICQQEggJBASICQQEggJhAQICYQEQgIhAUICIYGQACGBkEBIICRASCAkEBIICRASCAmEBEIChARCAiGBkAAhgZBASCAkQEggJBASCAkQEggJhAQICYQEQgIhAUICIYGQQEiAkEBIICQQEiAkEBIICYQECAmEBEICIQFCAiGBkEBILgEICYQEQgKEBEICIYGQACGBkEBIICRASCAkEBIICRASCAmEBEIChARCAiGBkAAhgZBASICQQEggJBASICQQEggJhAQICYQEQgIhAUICIYGQQEiAkEBIICQQEiAkEBIICYQECAmEBEIChARCAiGBkAAhgZBASCAkQEggJBASCAkQEggJhARCAoQEQgIhgZAAIYGQQEggJEBIICQQEiAkEBL8lzft9AVFFzN+ywAAACV0RVh0ZGF0ZTpjcmVhdGUAMjAyMS0wNy0xMlQxODo0Nzo1MCswMDowMIxlM90AAAAldEVYdGRhdGU6bW9kaWZ5ADIwMjEtMDctMTJUMTg6NDc6NTArMDA6MDD9OIthAAAAAElFTkSuQmCC"
		),
		["arrow_down"] = decode(
			"iVBORw0KGgoAAAANSUhEUgAAABQAAAAPCAYAAADkmO9VAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsIAAA7CARUoSoAAAABoSURBVDhP7dBBCsAgDETR6LHs/XutNtMxi4BI1Cz7oFQw+QvLoyRR7f80CF48niuq6nfrOSPqG/qUDe+5qfWMhwveLxnHDAY4FzKPGQxyfioWM1jg3tBazGCR+85ezCDAzucs9gsQeQHFvhGzmKvF1QAAAABJRU5ErkJggg=="
		),
		["arrow_up"] = decode(
			"iVBORw0KGgoAAAANSUhEUgAAABQAAAALCAYAAAB/Ca1DAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAABYSURBVDhPxc7RDsAQDIXh9v0feoYe2eipbST7LyiSL+SXDsuOYWo7rYf0zEa38JH9KkLpA8MQQ93LGYY8dLh4iqEevR3eYuiKtuErhoCWZRVDGdVdWE0kAV2EK/50sUCyAAAAAElFTkSuQmCC"
		),
		["gradientp90"] = decode(
			"iVBORw0KGgoAAAANSUhEUgAAAfQAAAH0CAYAAADL1t+KAAAIGElEQVR4nO3XsW0gMQADQb6h0Nd/uy5CgfCLmQqYLfhv2zcA4L/283oAAHBP0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASDgbPtejwAA7njoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABBwtv2+HgEA3PHQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASDgbPtejwAA7njoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABBwtn2vRwAAdzx0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAg4277XIwCAOx46AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAScbb+vRwAAdzx0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAg4277XIwCAOx46AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAScbd/rEQDAHQ8dAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAALOtu/1CADgjocOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAF/H3kEen3kYGIAAAAASUVORK5CYII="
		),
		["gradientn90"] = decode(
			"iVBORw0KGgoAAAANSUhEUgAAAfQAAAH0CAYAAADL1t+KAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsMAAA7DAcdvqGQAAAghSURBVHhe7ddRTQRADEDBXf4xgAAMYOAMIOAMnAEMIJ1NFhN9mUma1sFL91rr9wwAMNjb/wYABhN0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACNhnfu4JAEzlQweAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAAEEHgABBB4AAQQeAgH3mdU8AYCofOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAE7DPPewIAU/nQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBA0AEgQNABIEDQASBgn/m+JwAwlQ8dAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAIEHQACBB0AAgQdAAL2mcc9AYCpfOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAELDPfN0TAJjKhw4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAfvM5z0BgKl86AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQsM983BMAmMqHDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgABgg4AAYIOAAGCDgAB+8z7PQGAqXzoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoABAg6AAQIOgAECDoADDeWn+9SAaeAvPCIQAAAABJRU5ErkJggg=="
		),
		["gradientp45"] = decode(
			"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"
		),
		["colorhue"] = decode(
			"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"
		),
	},
}

local signal = library.signal
local utility = library.utility
local camera = workspace.CurrentCamera

local flags = library.flags
local options = library.options

local drawing_classes = {
	"Square",
	"Quad",
	"Triangle",
	"Circle",
	"Line",
	"Text",
}

-- // initalizations
do
	for i, v in next, startup_args do
		library[i] = v
	end

	makefolder(library.cheatname .. "/" .. library.gamename)
	makefolder(library.cheatname .. "/" .. library.gamename .. "/configs")

	library.mouse_strings = {
		[Enum.UserInputType.MouseButton1] = "MB1",
		[Enum.UserInputType.MouseButton2] = "MB2",
		[Enum.UserInputType.MouseButton3] = "MB3",
	}

	library.key_strings = {
		[Enum.KeyCode.Space] = { " ", " " },
		[Enum.KeyCode.Slash] = { "/", "?" },
		[Enum.KeyCode.BackSlash] = { "\\", "|" },
		[Enum.KeyCode.Period] = { ".", ">" },
		[Enum.KeyCode.Comma] = { ",", "<" },
		[Enum.KeyCode.LeftBracket] = { "[", "{" },
		[Enum.KeyCode.RightBracket] = { "]", "}" },
		[Enum.KeyCode.Quote] = { "'", '"' },
		[Enum.KeyCode.Semicolon] = { ";", ":" },
		[Enum.KeyCode.Backquote] = { "`", "~" },
		[Enum.KeyCode.Minus] = { "-", "_" },
		[Enum.KeyCode.Equals] = { "=", "+" },
		[Enum.KeyCode.One] = { "1", "!" },
		[Enum.KeyCode.Two] = { "2", "@" },
		[Enum.KeyCode.Three] = { "3", "#" },
		[Enum.KeyCode.Four] = { "4", "$" },
		[Enum.KeyCode.Five] = { "5", "%" },
		[Enum.KeyCode.Six] = { "6", "^" },
		[Enum.KeyCode.Seven] = { "7", "&" },
		[Enum.KeyCode.Eight] = { "8", "*" },
		[Enum.KeyCode.Nine] = { "9", "(" },
		[Enum.KeyCode.Zero] = { "0", ")" },
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
		Enum.KeyCode.Tab,
	}

	if not startup_args.ignoreui then
		library.screengui = Instance.new("ScreenGui")
		library.screengui.Parent = gethui()

		local button = Instance.new("ImageButton")
		button.Parent = library.screengui
		button.Visible = true
		button.Modal = true
		button.Size = UDim2.new(1, 0, 1, 0)
		button.ZIndex = math_huge
		button.Transparency = 1
	end
end

-- // functions
do
	-- library
	function library:unload()
		for i, v in next, self.hooks do
			v:Remove()
		end
		for i, v in next, self.connections do
			v:Disconnect()
		end
		for i, v in next, self.drawings.objects do
			v:Remove()
		end
		for i, v in next, self.drawings.raw do
			v:Remove()
		end
		for i, v in next, self.instances do
			v:Destroy()
		end
		if library.screengui then
			library.screengui:Destroy()
		end
		table_clear(library)
		library.unloaded = true
		getgenv().library = nil
	end

	function library:connection(signal, callback, tbl)
		local connection = signal:Connect(callback)
		table_insert(self.connections, connection)
		if tbl then
			table_insert(tbl, connection)
		end
		return connection
	end

	function library:hookmetamethod(object, metamethod, func)
		local original = hookmetamethod(object, metamethod, func)
		local hook = {}

		function hook:Remove()
			hookmetamethod(object, metamethod, function(...)
				return original(...)
			end)
			table_remove(library.hooks, table_find(library.hooks, hook))
			table_clear(hook)
		end

		function hook:SetFunction(func)
			assert(
				typeof(func) == "function",
				("invalid hook function type. expected 'function', got '%s'"):format(typeof(func))
			)
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
			_replacement = replacement,
		}

		function hook:Remove()
			hookfunction(func, self._original)
			table_remove(library.hooks, table_find(library.hooks, hook))
			table_clear(hook)
		end

		function hook:SetFunction(newfunc)
			assert(
				typeof(newfunc) == "function",
				("invalid hook function type. expected 'function', got '%s'"):format(typeof(func))
			)
			hookmetamethod(func, newfunc)
		end

		table_insert(library.hooks, hook)
		return original, hook
	end

	function library:instance(class, properties)
		local inst = Instance.new(class)
		for i, v in next, properties or {} do
			inst[i] = v
		end
		table_insert(self.instances, inst)
		return inst
	end

	function library:define(class, constructor, properties, meta)
		assert(typeof(class) == "string", ("invalid class name. expected 'string', got '%s'"):format(typeof(class)))
		assert(
			typeof(constructor) == "function" or table_find(drawing_classes, constructor),
			("invalid constructor type. expected 'function', got '%s'"):format(typeof(constructor))
		)

		local object = {
			class = class,
			constructor = typeof(constructor) == "function" and constructor or function(properties)
				local drawing = Drawing.new(class)
				for i, v in next, properties do
					drawing[i] = v
				end
				return drawing
			end,
			default_properties = properties or {},
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
			for i, v in next, ({ ... })[1] or {} do
				drawing[i] = v
			end
			table_insert(library.drawings.raw, drawing)
			return drawing
		end

		local class_object = self.classes[class]
		return class_object.constructor(class_object.default_properties, ...)
	end

	function library:update_theme()
		for i, v in next, self.drawings.objects do
			if v.Theme == nil then
				continue
			end
			v.Theme = v.Theme
		end
		for i, v in next, self.options do
			if v.class == "colorpicker" and v.useaccent == true then
				v:set(library.theme.Accent, v.opacity)
			end
		end
	end

	function library:set_theme(theme)
		self.theme = self.themes[theme]
		self:update_theme()
	end

	function library:get_hover_object()
		table_sort(self.drawings.active, function(a, b)
			return a.ZIndex > b.ZIndex
		end)

		local mouse_position = inputservice:GetMouseLocation()
		for index, drawing in next, self.drawings.active do
			if
				drawing._object.Visible
				and utility.vector2.inside(mouse_position, drawing.AbsolutePosition, drawing.AbsoluteSize)
			then
				return drawing
			end
		end
	end

	function library:update_notifications()
		for i, v in next, self.notifs do
			utility:tween(v.objects.container, "Position", udim2_new(0, 5, 0, 100 + (i * 25)), 0.05)
		end
	end

	function library:notification(message, duration, color)
		local notification = {}
		notification.objects = library:create("notification")

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
			if not library.notifs then
				return
			end

			local index = table_find(library.notifs, notification)
			if index then
				table_remove(library.notifs, index)
			end

			library:update_notifications()

			if self.objects and self.objects.container then
				self.objects.container:Remove()
			end
		end

		task.spawn(function()
			notification.objects.background.AnchorPoint = vector2_new(1, 0)
			utility:tween(notification.objects.background, "AnchorPoint", vector2_new(0, 0), 0.15).Completed:Wait()
			utility:tween(notification.objects.progress, "Size", udim2_new(1, 0, 0, 1), duration or 5).Completed:Wait()
			utility:tween(notification.objects.background, "AnchorPoint", vector2_new(1, 0), 0.15)
		end)

		delay(0.15 + duration + 0.15, function()
			notification:remove()
		end)

		table_insert(library.notifs, notification)
		notification.objects.container.Position =
			udim2_new(0, 5, 0, 100 + (table_find(library.notifs, notification) * 25))
		notification:set_message(message)
		library:update_notifications()
		return notification
	end

	-- configs
	function library:load_config(config)
		if typeof(config) == "string" then
			local path = library.cheatname .. "/" .. library.gamename .. "/configs/" .. config .. ".txt"
			assert(isfile(path), ("unable to load config '%s' [invalid config]"):format(tostring(config)))
			config = http:JSONDecode(readfile(path))
		end

		for flag, value in next, config do
			xpcall(function()
				local option = library.options[flag]

				assert(option ~= nil, "invalid option")

				if option.class == "toggle" then
					option:set_state(value)
				elseif option.class == "slider" then
					option:set_value(value)
				elseif option.class == "colorpicker" then
					local split = value:split("_")
					option:set(
						Color3.fromHSV(tonumber(split[1]), tonumber(split[2]), tonumber(split[3])),
						tonumber(split[4])
					)
					option.useaccent = split[5] == "true"
					option.rainbow = split[6] == "true"
					if split[6] == "true" then
						table.insert(library.rainbows, option)
					end
				elseif option.class == "dropdown" then
					option:select(value)
				elseif option.class == "textbox" then
					option:set_text(option.text)
				elseif option.class == "keybind" then
					option:set_bind(
						utility.table.includes(Enum.KeyCode, value) and Enum.KeyCode[value]
							or utility.table.includes(Enum.UserInputType, value) and Enum.UserInputType[value]
					)
				end
			end, function()
				warn(flag .. " doesn't exist.")
			end)
		end
	end

	function library:save_config(name, existscheck)
		local path = library.cheatname .. "/" .. library.gamename .. "/configs/" .. name .. ".txt"

		if existscheck then
			assert(isfile(path) == false, ("unable to create config '%s' [already exists]"):format(name))
		end

		if not table_find(options.configs_selected.values, name) then
			options.configs_selected:add_value(name)
		end

		local config = {}

		for flag, option in next, library.options do
			local value = library.flags[flag]
			if option.class == "toggle" then
				config[flag] = option.state
			elseif option.class == "slider" then
				config[flag] = option.value
			elseif option.class == "keybind" then
				config[flag] = option.bind.Name
			elseif option.class == "colorpicker" then
				local h, s, v = option.color:ToHSV()
				config[flag] = tostring(h)
					.. "_"
					.. tostring(s)
					.. "_"
					.. tostring(v)
					.. "_"
					.. tostring(option.opacity)
					.. "_"
					.. tostring(option.useaccent)
					.. "_"
					.. tostring(option.rainbow)
			elseif option.class == "dropdown" then
				config[flag] = option.selected
			elseif option.class == "textbox" then
				config[flag] = option.text
			end
		end

		writefile(path, http:JSONEncode(config))
	end

	function library:delete_config(name)
		local path = library.cheatname .. "/" .. library.gamename .. "/configs/" .. name .. ".txt"
		local autoLoadPath = library.cheatname .. "/" .. library.gamename .. "/auto_load.txt"

		xpcall(function()
			assert(isfile(path), ("unable to delete config '%s' [not found]"):format(name))

			delfile(path)
			library:notification(("Successfully deleted config '%s'"):format(name), 5, color3_new(1, 0.35, 0.35))

			if isfile(autoLoadPath) and readfile(autoLoadPath) == name then
				delfile(autoLoadPath)
				library:notification("Auto-load config removed since it was deleted.", 5, color3_new(1, 0.35, 0.35))
			end

			if table_find(options.configs_selected.values, name) then
				options.configs_selected:remove_value(name)
			end
		end, function(err)
			library:notification(("Failed to delete config '%s': %s"):format(name, err), 5, color3_new(1, 0.35, 0.35))
		end)
	end

	-- util
	function utility:getclipboard()
		local clipboard

		local textbox = Instance.new("TextBox")
		textbox.Parent = library.screengui
		textbox.TextTransparency = 1
		textbox.BackgroundTransparency = 1
		textbox:CaptureFocus()

		task.spawn(function()
			textbox:GetPropertyChangedSignal("Text"):Wait()
			clipboard = textbox.Text
		end)

		keypress(0x11)
		keypress(0x56)
		task.wait()
		keyrelease(0x11)
		keyrelease(0x56)
		repeat
			task.wait()
		until clipboard ~= nil
		textbox:Destroy()
		return clipboard
	end

	function utility:convert_number_range(
		value: number,
		min_old: number,
		max_old: number,
		min_new: number,
		max_new: number
	)
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
			return self:raycast(origin, direction, utility.table.merge(ignore, { hit }), distance)
		end
		return hit
	end

	function utility:get_size_string(size, absolute)
		return ("R(%s, %s, %s, %s), A(%s, %s)"):format(
			size.X.Scale,
			size.X.Offset,
			size.Y.Scale,
			size.Y.Offset,
			absolute.X,
			absolute.Y
		)
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

			if typeof(value_new) == "number" then
				tween.value_current = self:lerp(tween.value_start, value_new, tween.progress_tween)
			else
				tween.value_current = tween.value_start:lerp(tween.value_new, tween.progress_tween)
			end

			if utility.table.includes(object, "_object") and not rawget(object._object, "__OBJECT_EXISTS") == true then
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
		return ({ pcall(function()
			local a = tbl[key]
		end) })[1]
	end

	function utility.table.merge(a, b)
		local c = {}
		for i, v in next, a or {} do
			c[i] = v
		end
		for i, v in next, b or {} do
			c[i] = v
		end
		return c
	end

	function utility.table.getdescendants(tbl, new)
		local new = new or {}
		for i, v in next, tbl do
			if typeof(v) == "table" then
				utility.table.getdescendants(v, new)
			else
				new[i] = v
			end
		end
		return new
	end

	function utility.table.deepcopy(tbl)
		local new = {}
		for i, v in next, tbl or {} do
			if typeof(v) == "table" then
				v = utility.table.deepcopy(v)
			end
			new[i] = v
		end
		return new
	end

	function utility.table.nuke(tbl)
		for i, v in next, tbl do
			if typeof(v) == "table" then
				utility.table.nuke(v)
			end
			tbl[i] = nil
		end
	end

	function utility.table.unfreeze(tbl)
		setreadonly(tbl, false)
		for i, v in next, tbl do
			if typeof(v) == "table" then
				utility.table.unfreeze(v)
			end
		end
	end

	function utility.table.clearkeys(tbl)
		local new = {}
		for i, v in next, tbl do
			table_insert(new, i)
		end
		return new
	end

	-- camera util
	function utility.camera.cframetoviewport(cframe, floor)
		local position, visible = worldtoviewport(
			library.camera,
			cframe * (cframe - cframe.p):ToObjectSpace(library.camera.CFrame - library.camera.CFrame.p).p
		)
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
		return string.match(str1, "^" .. str2)
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

	function library:add_tooltip(element, text)
		local tooltip = {}

		tooltip.background = library:create("rect", {
			Size = udim2_new(0, 200, 0, 40),
			Position = udim2_new(0, 0, 0, 0),
			Visible = false,
			Theme = { ["Color"] = "Option Background" },
			ZIndex = 100,
		})

		tooltip.text = library:create("text", {
			Position = udim2_new(0, 5, 0, 5),
			Theme = { ["Color"] = "Primary Text" },
			Parent = tooltip.background,
			ZIndex = 101,
		})
		local tooltip_bg = tooltip.background

		for i, color in ipairs({ "Border 1", "Border 2", "Border 1" }) do
			tooltip["border_" .. i] = library:create("outline", tooltip_bg, { Theme = { ["Color"] = color } })
			tooltip_bg = tooltip["border_" .. i]
		end

		library:connection(inputservice.InputChanged, function(input)
			if tooltip.background.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then
				tooltip.background.Position = udim2_new(0, input.Position.X + 15, 0, input.Position.Y + 15)
			end
		end)

		library:connection(element.MouseEnter, function()
			tooltip.text.Text = text
			tooltip.background.Size = udim2_new(0, tooltip.text.TextBounds.X + 10, 0, tooltip.text.TextBounds.Y + 10)
			tooltip.background.Visible = true
		end)

		library:connection(element.MouseLeave, function()
			tooltip.background.Visible = false
		end)
	end

	-- fov circle
	library.fovcircles = {}
	library.fovcircle = {}
	library.fovcircle.__index = library.fovcircle

	function library.fovcircle.new(flag, properties)
		local circle = setmetatable({
			_mode = "center",
			_fov = 0,
			_flag = flag,
			_components = {
				library:create("Circle", { Thickness = 1, ZIndex = -4 }),
				library:create("Circle", { Thickness = 1, ZIndex = -4 }),
				library:create("Circle", { Thickness = 3.5, ZIndex = -5 }),
			},
		}, library.fovcircle)

		table_insert(library.fovcircles, circle)

		for i, v in next, properties or {} do
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
		self:set("Position", self._mode == "mouse" and inputservice:GetMouseLocation() or library.screensize / 2)
	end

	function library.fovcircle:update_radius()
		self._fov = flags[self._flag .. "_fov_radius"]
			+ (flags[self._flag .. "_fov_dynamic"] and -(library.camera.FieldOfView * 2) or 0)
		self:set("Radius", self._fov)
	end

	function library.fovcircle:update()
		self:update_radius()
		self:update_position()
		self:set("Color", flags[self._flag .. "_fov_color"], true)
		self:set("Visible", flags[self._flag .. "_fov_enabled"])
		self:set("NumSides", flags[self._flag .. "_fov_sides"])
		self._components[3].Color = color3_new(0, 0, 0)
	end

	-- spring
	library.spring = {}
	library.spring.__index = library.spring

	function library.spring.new(freq, position)
		return setmetatable({
			f = freq,
			p = position,
			v = 0,
		}, library.spring)
	end

	function library.spring:update(delta, goal)
		local f = self.f * 2 * math.pi
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
			if not self.selected then
				return
			end

			local mouse_position = inputservice:GetMouseLocation()
			local relative_palette = (mouse_position - self.objects.color.AbsolutePosition)
			local relative_hue = (mouse_position - self.objects_hue.container.AbsolutePosition)
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
			self.objects.pointer.Position =
				udim2_new(math_clamp(1 - self.sat, 0.005, 0.995), 0, math_clamp(1 - self.val, 0.005, 0.995), 0)
			self.objects.color.Color = color3_hsv(self.hue, 1, 1)

			self.objects_hue.slider.Position = udim2_new(0, 0, math_clamp(self.hue, 0.005, 0.995), 0)
			self.objects_opacity.slider.Position = udim2_new(0, 0, math_clamp(self.opacity, 0.005, 0.995), 0)
			self.objects_opacity.container.Color = self.color

			self.hex_button:set_text("#" .. self.color:ToHex())

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

			self.objects.pointer.Position =
				udim2_new(math_clamp(1 - self.sat, 0.005, 0.995), 0, math_clamp(1 - self.val, 0.005, 0.995), 0)

			self.objects_opacity.container.Color = self.color
			self.objects.color.Color = color3_hsv(self.hue, 1, 1)
			self.objects_hue.slider.Position = udim2_new(0, 0, math_clamp(self.hue, 0.005, 0.995), 0)

			self.hex_button:set_text("#" .. self.color:ToHex())

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
			assert(
				typeof(opacity) == "number",
				("invalid opacity value. expected 'number', got '%s'"):format(typeof(opacity))
			)

			self.opacity = opacity
			self.objects_opacity.slider.Position = udim2_new(0, 0, math_clamp(self.opacity, 0.005, 0.995), 0)
			self.objects_opacity.container.Color = self.color
		end

		function library.meta.colorpicker:set(color, opacity)
			self:set_color(color or color3_new(1, 1, 1))
			self:set_opacity(opacity or 1)
		end
	end

	-- label
	library.meta.options.label = {}
	library.meta.options.label.__index = library.meta.options.label
	setmetatable(library.meta.options.label, library.meta.options)

	function library.meta.options.label:new(properties)
		local label = library:create("option", properties, self, "label")
		table_insert(self.options, label)
		label:set_text(properties.text or "")
		return self._type == "option" and self or label
	end

	function library.meta.options.label:set_text(str)
		assert(typeof(str) == "string", ("invalid label text type. expected 'string', got '%s'"):format(typeof(str)))

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
			local toggle = library:create("option", properties, self, "toggle")
			toggle.state = false

			toggle.objects.background = library:create("rect", {
				Theme = { ["Color"] = "Option Background" },
				Size = udim2_new(0, 6, 0, 6),
				Position = udim2_new(0, 3, 0, 5),
				AnchorPoint = vector2_new(0, 0),
				ZIndex = toggle.zindex + 3,
				Parent = toggle.objects.container,
			})

			if properties.tooltip then
				library:add_tooltip(toggle.objects.container, properties.tooltip)
			end

			toggle.objects.label.Position = udim2_new(0, 17, 0, 1)
			toggle.objects.border_inner =
				library:create("outline", toggle.objects.background, { ["Theme"] = { ["Color"] = "Border 1" } })
			toggle.objects.border_mid =
				library:create("outline", toggle.objects.border_inner, { ["Theme"] = { ["Color"] = "Border 2" } })
			toggle.objects.border_outer =
				library:create("outline", toggle.objects.border_mid, { ["Theme"] = { ["Color"] = "Border 1" } })

			library:connection(toggle.objects.container.MouseButton1Down, function()
				toggle:set_state(not toggle.state)
			end)

			library:connection(toggle.objects.container.MouseEnter, function()
				toggle.objects.border_mid.Theme = { ["Color"] = "Accent" }
			end)

			library:connection(toggle.objects.container.MouseLeave, function()
				toggle.objects.border_mid.Theme = { ["Color"] = toggle.state and "Accent" or "Border 2" }
			end)

			table_insert(self.options, toggle)
			toggle:set_state(toggle.state)
			return toggle
		end

		function library.meta.options.toggle:set_state(bool)
			assert(
				typeof(bool) == "boolean",
				("invalid toggle state type. expected 'boolean', got '%s'"):format(typeof(bool))
			)
			self.state = bool
			self.objects.border_mid.Theme =
				{ ["Color"] = (bool or self.objects.container.MouseHover) and "Accent" or "Border 2" }
			self.objects.background.Theme = { ["Color"] = bool and "Accent" or "Option Background" }
			self.objects.label.Theme = { ["Color"] = bool and "Option Text 1" or "Option Text 2" }
			if self.flag then
				library.flags[self.flag] = bool
			end
			self.callback(bool)
		end

		function library.meta.options.toggle:update_options()
			local pos_x = -2
			local pos_y = 0

			for index, option in next, self.options do
				if option.class == "colorpicker" or option.class == "keybind" then
					pos_x = pos_x + option.objects.container.AbsoluteSize.X + 2
					option.objects.container.Position = udim2_new(1, -pos_x, 0, 0)
				else
					pos_y = pos_y + option.objects.container.AbsoluteSize.Y + 2
					option.objects.container.Position = udim2_new(0, 0, 1, -pos_y)
				end
			end

			self.objects.container.Size = udim2_new(1, 0, 0, 18 + pos_y)
		end
	end

	-- button
	do
		library.meta.options.button = {}
		library.meta.options.button.__index = library.meta.options.button
		setmetatable(library.meta.options.button, library.meta.options)

		function library.meta.options.button:new(properties)
			local button = library:create("option", properties, self, "button")
			button.confirm = properties.confirm or false
			button.clicked = false

			button.objects.background = library:create("rect", {
				Theme = { ["Color"] = "Option Background" },
				Size = udim2_new(1, -6, 1, -8),
				Position = udim2_new(0.5, 0, 0.5, 0),
				AnchorPoint = vector2_new(0.5, 0.5),
				ZIndex = button.zindex + 3,
				Parent = button.objects.container,
			})

			button.objects.gradient = library:create("rect", {
				Size = udim2_new(1, 0, 1, 0),
				Transparency = 0.5,
				ZIndex = button.zindex + 4,
				Data = library.images.gradientp90,
				Parent = button.objects.background,
			}, "Image")

			if properties.tooltip then
				library:add_tooltip(button.objects.container, properties.tooltip)
			end

			library:connection(button.objects.container.MouseButton1Down, function()
				button.objects.background.Theme = { ["Color"] = "Accent" }
				button.objects.label.Theme = { ["Color"] = "Option Text 1" }

				if (button.confirm and button.clicked) or not button.confirm then
					task.spawn(button.callback)
					button.objects.label.Text = button.text
					button.clicked = false
				elseif button.confirm and not button.clicked then
					button.clicked = true
					for i = 3, 1, -1 do
						if not button.clicked then
							break
						end
						button.objects.label.Text = "confirm? [" .. i .. "s]"
						wait(1)
					end
					button.clicked = false
					button.objects.label.Text = button.text
				end
			end)

			library:connection(button.objects.container.MouseButton1Up, function()
				button.objects.background.Theme = { ["Color"] = "Option Background" }
				button.objects.label.Theme = { ["Color"] = "Option Text 2" }
			end)

			library:connection(button.objects.container.MouseEnter, function()
				button.objects.background.Theme = { ["Color"] = "Option Background" }
				button.objects.label.Theme = { ["Color"] = "Option Text 2" }
				button.objects.border_mid.Theme = { ["Color"] = "Accent" }
			end)

			library:connection(button.objects.container.MouseLeave, function()
				button.objects.background.Theme = { ["Color"] = "Option Background" }
				button.objects.label.Theme = { ["Color"] = "Option Text 2" }
				button.objects.border_mid.Theme = { ["Color"] = "Border 2" }
			end)

			button.objects.label.Center = true
			button.objects.label.Position = udim2_new(0.5, 0, 0, 2)
			button.objects.border_inner =
				library:create("outline", button.objects.background, { ["Theme"] = { ["Color"] = "Border 1" } })
			button.objects.border_mid =
				library:create("outline", button.objects.border_inner, { ["Theme"] = { ["Color"] = "Border 2" } })
			button.objects.border_outer =
				library:create("outline", button.objects.border_mid, { ["Theme"] = { ["Color"] = "Border 1" } })

			table_insert(self.options, button)
			return self._type == "option" and self or button
		end
	end

	-- slider
	do
		library.meta.options.slider = {}
		library.meta.options.slider.__index = library.meta.options.slider
		setmetatable(library.meta.options.slider, library.meta.options)

		function library.meta.options.slider:new(properties)
			local slider = library:create(
				"option",
				utility.table.merge(properties, { size = udim2_new(1, 0, 0, 36) }),
				self,
				"slider"
			)
			slider.parent = self
			slider.value = 0
			slider.min = properties.min or 0
			slider.max = properties.max or 100
			slider.maxtext = properties.maxtext or ""
			slider.mintext = properties.mintext or ""
			slider.increment = properties.increment or 1
			slider.prefix = properties.prefix or ""
			slider.suffix = properties.suffix or ""

			slider.objects.background = library:create("rect", {
				Theme = { ["Color"] = "Option Background" },
				Size = udim2_new(1, -6, 0, 10),
				Position = udim2_new(0.5, 0, 1, -5),
				AnchorPoint = vector2_new(0.5, 1),
				ZIndex = slider.zindex + 3,
				Parent = slider.objects.container,
			})

			slider.objects.slider = library:create("rect", {
				Theme = { ["Color"] = "Accent" },
				Size = udim2_new(0, 0, 1, 0),
				ZIndex = slider.zindex + 4,
				Parent = slider.objects.background,
			})

			slider.objects.gradient = library:create("rect", {
				Size = udim2_new(1, 0, 1, 0),
				Transparency = 0.5,
				ZIndex = slider.zindex + 5,
				Data = library.images.gradientp90,
				Parent = slider.objects.background,
			}, "Image")

			if properties.tooltip then
				library:add_tooltip(slider.objects.container, properties.tooltip)
			end

			library:connection(slider.objects.container.MouseButton1Down, function()
				slider:update()
				library.dragging_slider = slider
				slider.objects.border_mid.Theme = { ["Color"] = "Accent" }
			end)

			library:connection(slider.objects.container.MouseEnter, function()
				slider.objects.border_mid.Theme = { ["Color"] = "Accent" }
			end)

			library:connection(slider.objects.container.MouseLeave, function()
				slider.objects.border_mid.Theme = { ["Color"] = "Border 2" }
			end)

			slider.objects.label.ZIndex = slider.zindex + 6
			slider.objects.container.ZIndex = slider.zindex + 6

			slider.objects.container.Size = slider.parent.class == "section" and udim2_new(1, 0, 0, 36)
				or udim2_new(1, 0, 0, 18)
			slider.objects.label.Position = slider.parent.class == "section" and udim2_new(0, 0, 0, 1)
				or udim2_new(0.5, 0, 0, 1)
			slider.objects.label.Center = slider.parent.class ~= "section"

			slider.objects.border_inner =
				library:create("outline", slider.objects.background, { ["Theme"] = { ["Color"] = "Border 1" } })
			slider.objects.border_mid =
				library:create("outline", slider.objects.border_inner, { ["Theme"] = { ["Color"] = "Border 2" } })
			slider.objects.border_outer =
				library:create("outline", slider.objects.border_mid, { ["Theme"] = { ["Color"] = "Border 1" } })

			table_insert(self.options, slider)
			slider:set_value(properties.default or 0)
			return self._type == "option" and self or slider
		end

		function library.meta.options.slider:set_value(value, nocallback)
			assert(
				typeof(value) == "number",
				("invalid toggle state type. expected 'number', got '%s'"):format(typeof(value))
			)

			self.value = math_clamp(self.increment * math_floor(value / self.increment), self.min, self.max)
			self.objects.label.Theme = {
				["Color"] = (self.value == self.min or (0 > self.min and self.value == 0)) and "Option Text 2"
					or "Option Text 1",
			}

			local text = (self.value == self.min and self.mintext ~= "" and self.mintext)
				or (self.value == self.max and self.maxtext ~= "" and self.maxtext)
				or string.format("%.14g", self.value)

			if self.parent.class == "section" then
				self.objects.label.Text = self.prefix .. self.text .. ": " .. text .. self.suffix
			else
				self.objects.label.Text = self.prefix
					.. text
					.. self.suffix
					.. "/"
					.. self.prefix
					.. self.max
					.. self.suffix
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
			local relative =
				utility.vector2.floor(inputservice:GetMouseLocation() - self.objects.background.AbsolutePosition)
			local value =
				utility:convert_number_range(relative.X, 0, self.objects.background.AbsoluteSize.X, self.min, self.max)
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

			local colorpicker = library:create("option", properties, self, "colorpicker")
			colorpicker.parent = self
			colorpicker.useaccent = false
			colorpicker.rainbow = false
			colorpicker.displayuseaccent = properties.displayuseaccent == nil and true or properties.displayuseaccent
			colorpicker.color = properties.default or color3_new(1, 1, 1)
			colorpicker.opacity = properties.default_opacity or 0

			colorpicker.objects.background = library:create("rect", {
				Color = colorpicker.color,
				Size = udim2_new(0, 15, 0, 6),
				Position = udim2_new(1, -3, 0, 6),
				AnchorPoint = vector2_new(1, 0),
				ZIndex = colorpicker.zindex + 3,
				Parent = colorpicker.objects.container,
			})

			if self.class ~= "section" then
				colorpicker.objects.container.ZIndex = colorpicker.zindex + 4
				colorpicker.objects.container.Size = udim2_new(0, 21, 1, 0)
			end

			colorpicker.objects.label.Visible = self.class == "section"
			colorpicker.objects.border_inner =
				library:create("outline", colorpicker.objects.background, { ["Theme"] = { ["Color"] = "Border 1" } })
			colorpicker.objects.border_mid =
				library:create("outline", colorpicker.objects.border_inner, { ["Theme"] = { ["Color"] = "Border 2" } })
			colorpicker.objects.border_outer =
				library:create("outline", colorpicker.objects.border_mid, { ["Theme"] = { ["Color"] = "Border 1" } })

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
					library.colorpicker.objects.label.Text = colorpicker.text or colorpicker.flag or ""
					library.colorpicker:set(colorpicker.color, colorpicker.opacity)
				end
			end)

			library:connection(colorpicker.objects.container.MouseEnter, function()
				colorpicker.objects.border_mid.Theme = { ["Color"] = "Accent" }
			end)

			library:connection(colorpicker.objects.container.MouseLeave, function()
				colorpicker.objects.border_mid.Theme = { ["Color"] = colorpicker.state and "Accent" or "Border 2" }
			end)

			table_insert(self.options, colorpicker)
			if properties.flag ~= nil then
				flags[properties.flag] = colorpicker.color
			end
			return self._type == "option" and self or colorpicker
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
			local textbox = library:create("option", properties, self, "textbox")
			textbox.text = ""
			textbox.min = 0
			textbox.max = 100
			textbox.numeric = properties.numeric or false
			textbox.placeholder = properties.placeholder or ""
			textbox.callback = properties.callback or function() end
			textbox.parent = self

			textbox.objects.background = library:create("rect", {
				Theme = { ["Color"] = "Option Background" },
				Size = udim2_new(1, -6, 0, 10),
				Position = udim2_new(0.5, 0, 1, -5),
				AnchorPoint = vector2_new(0.5, 1),
				ZIndex = textbox.zindex + 3,
				Parent = textbox.objects.container,
			})

			textbox.objects.gradient = library:create("rect", {
				Size = udim2_new(1, 0, 1, 0),
				Transparency = 0.5,
				ZIndex = textbox.zindex + 4,
				Data = library.images.gradientp90,
				Parent = textbox.objects.background,
			}, "Image")

			textbox.objects.input = library:create("text", {
				Theme = { ["Color"] = "Option Text 2" },
				Position = udim2_new(0, 1, 0, -2),
				Text = textbox.placeholder,
				Center = textbox.center or false,
				ZIndex = textbox.zindex + 5,
				Parent = textbox.objects.background,
			})

			if properties.tooltip then
				library:add_tooltip(textbox.objects.container, properties.tooltip)
			end

			library:connection(textbox.objects.container.MouseButton1Down, function()
				if not textbox.focued then
					textbox:capture()
				end
			end)

			library:connection(textbox.objects.container.MouseEnter, function()
				textbox.objects.border_mid.Theme = { ["Color"] = "Accent" }
			end)

			library:connection(textbox.objects.container.MouseLeave, function()
				textbox.objects.border_mid.Theme = { ["Color"] = "Border 2" }
			end)

			textbox.objects.container.ZIndex = textbox.zindex + 5
			textbox.objects.label.Visible = textbox.parent.class == "section"
			textbox.objects.container.Size = textbox.parent.class == "section" and udim2_new(1, 0, 0, 36)
				or udim2_new(1, 0, 0, 18)
			textbox.objects.border_inner =
				library:create("outline", textbox.objects.background, { ["Theme"] = { ["Color"] = "Border 1" } })
			textbox.objects.border_mid =
				library:create("outline", textbox.objects.border_inner, { ["Theme"] = { ["Color"] = "Border 2" } })
			textbox.objects.border_outer =
				library:create("outline", textbox.objects.border_mid, { ["Theme"] = { ["Color"] = "Border 1" } })

			table_insert(self.options, textbox)
			if properties.default then
				textbox:set_text(properties.default)
			end
			return self._type == "option" and self or textbox
		end

		function library.meta.options.textbox:set_text(str, nocallback)
			assert(
				typeof(str) == "string",
				("invalid textbox input type. expected 'string', got '%s'"):format(typeof(str))
			)

			if self.numeric then
				str = str:gsub("[^%d%.%-]", "")
			end

			self.text = str
			local fakeText = str

			local maxLength = 25
			if #str > maxLength then
				fakeText = str:sub(1, maxLength) .. "..."
			end

			self.objects.input.Text = (str == "" and not self.focused) and self.placeholder or fakeText
			self.objects.input.Theme = { ["Color"] = self.focused and "Option Text 1" or "Option Text 2" }
			self.objects.label.Theme =
				{ ["Color"] = (str == "" and not self.focused) and "Option Text 2" or "Option Text 1" }

			if not nocallback then
				self.callback(str)
			end

			if self.flag ~= nil then
				library.flags[self.flag] = str
			end
		end

		function library.meta.options.textbox:handle_keypress(input)
			if not self.focused then
				return
			end

			local keycode = input.KeyCode
			local userType = input.UserInputType
			local isCtrlHeld = inputservice:IsKeyDown(Enum.KeyCode.LeftControl)
				or inputservice:IsKeyDown(Enum.KeyCode.RightControl)

			if not keycode or keycode == Enum.KeyCode.Unknown then
				return
			end
			if table_find(library.blacklisted_keys, keycode) then
				return
			end

			if keycode == Enum.KeyCode.A and isCtrlHeld then
				self.selectAll = true
				return
			end

			if keycode == Enum.KeyCode.Backspace then
				if self.selectAll then
					self:set_text("")
					self.selectAll = false
				else
					self:set_text(self.text:sub(1, -2))
				end
				return
			end

			if keycode == Enum.KeyCode.V and isCtrlHeld then
				local clipboard = utility:getclipboard()
				self:set_text(self.selectAll and clipboard or (self.text .. clipboard), true)
				self.selectAll = false
				return
			end

			if
				keycode == Enum.KeyCode.Return
				or keycode == Enum.KeyCode.Escape
				or userType == Enum.UserInputType.MouseButton1
				or userType == Enum.UserInputType.MouseButton2
			then
				self:release()
				if self.numeric then
					local numValue = tonumber(self.text) or 0
					self:set_text(tostring(numValue))
				end
				return
			end

			if isCtrlHeld then
				return
			end

			local keyString = library.key_strings[keycode]
			if type(keyString) == "table" then
				keyString = keyString[1]
			end
			if not keyString then
				keyString = keycode.Name:lower()
			end

			if not keyString or keyString == "unknown" then
				return
			end

			self:set_text(self.selectAll and keyString or (self.text .. keyString), true)
			self.selectAll = false
		end

		function library.meta.options.textbox:capture()
			if not self.focused then
				actionservice:BindAction("FreezeMovement", function()
					return Enum.ContextActionResult.Sink
				end, false, unpack(Enum.PlayerActions:GetEnumItems()))

				self.focused = true
				self:set_text(self.text, true)
				self.connection = library:connection(inputservice.InputBegan, function(input)
					if inputservice:GetFocusedTextBox() then
						return
					end
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
				actionservice:UnbindAction("FreezeMovement")
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
			local dropdown = library:create("option", properties, self, "dropdown")
			dropdown.multi = properties.multi or false
			dropdown.searching = false
			dropdown.maxvalues = 10
			dropdown.values = {}
			dropdown.selected = properties.multi and {} or ""

			for i, v in next, properties.values or {} do
				dropdown:add_value(v)
			end

			dropdown.objects.background = library:create("rect", {
				Theme = { ["Color"] = "Option Background" },
				Size = udim2_new(1, -6, 0, 10),
				Position = udim2_new(0.5, 0, 1, -5),
				AnchorPoint = vector2_new(0.5, 1),
				ZIndex = dropdown.zindex + 3,
				Parent = dropdown.objects.container,
			})

			dropdown.objects.status_text = library:create("text", {
				Theme = { ["Color"] = "Option Text 2" },
				Position = udim2_new(0, 1, 0, -3),
				Text = "none",
				Center = dropdown.center or false,
				ZIndex = dropdown.zindex + 5,
				Parent = dropdown.objects.background,
			})

			dropdown.objects.status = library:create("rect", {
				Size = udim2_new(0, 7, 0, 5),
				Position = udim2_new(1, -4, 0.5, 1),
				AnchorPoint = vector2_new(1, 0.5),
				ZIndex = dropdown.zindex + 4,
				Data = library.images.arrow_down,
				Parent = dropdown.objects.background,
			}, "Image")

			dropdown.objects.gradient = library:create("rect", {
				Size = udim2_new(1, 0, 1, 0),
				Transparency = 0.5,
				ZIndex = dropdown.zindex + 4,
				Data = library.images.gradientp90,
				Parent = dropdown.objects.background,
			}, "Image")

			library:connection(dropdown.objects.container.MouseButton1Down, function()
				for i, v in next, library.dropdown.connections do
					v:Disconnect()
				end

				if library.dropdown.selected == dropdown then
					dropdown.objects.status.Data = library.images.arrow_down
					dropdown.objects.status.Position = udim2_new(1, -4, 0.5, 1)
					library.dropdown.selected = nil
					library.dropdown.objects.background.Parent = nil
					library.dropdown.objects.background.Visible = false
				else
					dropdown.objects.status.Data = library.images.arrow_up
					dropdown.objects.status.Position = udim2_new(1, -4, 0.5, 0)
					library.dropdown.selected = dropdown
					library.dropdown.objects.background.Parent = dropdown.objects.container
					library.dropdown.objects.background.Visible = true
					dropdown:update()

					if inputservice:IsKeyDown(Enum.KeyCode.LeftControl) then
						local status_text = dropdown.objects.status_text

						dropdown.searching = true
						status_text.Text = ""

						local c
						c = library:connection(inputservice.InputBegan, function(input)
							if input.UserInputType ~= Enum.UserInputType.Keyboard or not input.KeyCode then
								return
							end
							if table_find(library.blacklisted_keys, input.KeyCode) then
								return
							end

							local caps = inputservice:IsKeyDown(Enum.KeyCode.LeftShift)
								or inputservice:IsKeyDown(Enum.KeyCode.RightShift)
							local keystring = library.key_strings[input.KeyCode]
							local keystring = (
								keystring == nil and (caps and input.KeyCode.Name or input.KeyCode.Name:lower())
								or (caps and keystring[2] or keystring[1])
							)

							if input.KeyCode == Enum.KeyCode.Backspace then
								status_text.Text = status_text.Text:sub(0, -2)
							elseif
								input.KeyCode == Enum.KeyCode.Return
								or input.KeyCode == Enum.KeyCode.Escape
								or input.UserInputType == Enum.UserInputType.MouseButton1
							then
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
				dropdown.objects.border_mid.Theme = { ["Color"] = "Accent" }
			end)

			library:connection(dropdown.objects.container.MouseLeave, function()
				dropdown.objects.border_mid.Theme = { ["Color"] = "Border 2" }
			end)

			dropdown.objects.container.ZIndex = dropdown.zindex + 6
			dropdown.objects.label.Visible = dropdown.parent.class == "section"
			dropdown.objects.container.Size = dropdown.parent.class == "section" and udim2_new(1, 0, 0, 36)
				or udim2_new(1, 0, 0, 18)
			dropdown.objects.border_inner =
				library:create("outline", dropdown.objects.background, { ["Theme"] = { ["Color"] = "Border 1" } })
			dropdown.objects.border_mid =
				library:create("outline", dropdown.objects.border_inner, { ["Theme"] = { ["Color"] = "Border 2" } })
			dropdown.objects.border_outer =
				library:create("outline", dropdown.objects.border_mid, { ["Theme"] = { ["Color"] = "Border 1" } })

			table_insert(self.options, dropdown)
			if properties.flag ~= nil then
				library.flags[properties.flag] = dropdown.selected
			end
			return self._type == "option" and self or dropdown
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
			local full_text = self.selected or ""
			local text = ""

			if self.multi then
				full_text = {}
				for i, v in next, self.values do
					if self.selected[v] == true then
						table_insert(full_text, v)
					end
				end
				full_text = table_concat(full_text, ", ") or ""
			end

			self.objects.status_text.Text = "none"

			for i, v in next, full_text:split("") do
				text = text .. v
				self.objects.status_text.Text = text
				if self.objects.status_text.TextBounds.X > self.objects.container.AbsoluteSize.X - 40 then
					self.objects.status_text.Text = text:sub(1, -3) .. "..."
					break
				end
			end
		end

		function library.meta.options.dropdown:update() -- i gave up trying to make things look nice on this dropdown shit
			if library.dropdown.selected ~= self then
				return
			end

			local dropdown = self

			for i, v in next, library.dropdown.connections do
				v:Disconnect()
			end

			for index in next, dropdown.values do
				if not library.dropdown.objects.values[index] then
					library.dropdown.objects.values[index] =
						library:create("dropdownvalue", library.dropdown.objects.background)
				end
			end

			local index = 1

			for _, objects in next, library.dropdown.objects.values do
				local value = dropdown.values[_]
				if value == nil then
					objects.container.Visible = false
					continue
				end

				local selected = (
					(dropdown.multi and dropdown.selected[value] == true)
					or (not dropdown.multi and dropdown.selected == value)
				)

				if not selected and dropdown.searching and not value:match(dropdown.objects.status_text.Text) then
					objects.container.Visible = false
					continue
				end

				objects.label.Text = value
				objects.label.Theme = { ["Color"] = (selected and "Option Text 1" or "Option Text 2") }
				objects.container.Transparency = selected and 0.1 or 0
				objects.container.Visible = true
				objects.container.Position = udim2_new(0, 2, 0, 2 + (index - 1) * 16)
				library.dropdown.objects.background.Size = udim2_new(1, -4, 0, index * 16 + 3)

				index = index + 1

				library:connection(objects.container.MouseButton1Down, function()
					if dropdown.multi then
						dropdown.selected[value] = not dropdown.selected[value]
						objects.label.Theme =
							{ ["Color"] = dropdown.selected[value] and "Option Text 1" or "Option Text 2" }
						objects.container.Transparency = dropdown.selected[value] and 0.15 or 0
					else
						dropdown.selected = dropdown.selected ~= value and value or nil
						for i, v in next, library.dropdown.objects.values do
							v.label.Theme = {
								["Color"] = (v == objects and dropdown.selected == value) and "Option Text 1"
									or "Option Text 2",
							}
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

			local keybind = library:create("option", properties, self, "keybind"), library.meta.options.keybind
			keybind.parent = self
			keybind.binding = false
			keybind.state = false
			keybind.mode = properties.mode or "toggle"
			keybind.key = properties.default or "none"

			if properties.indicator then
				keybind.indicator = library.keybind_indicator:value({
					key = keybind.text == "" and keybind.flag or keybind.text,
					enabled = false,
				})
			end

			keybind.objects.keytext = library:create("text", {
				Color = keybind.color,
				ZIndex = keybind.zindex + 3,
				Parent = keybind.objects.container,
			})

			keybind.objects.label.Visible = self.class == "section"

			if self.class ~= "section" then
				keybind.objects.container.ZIndex = keybind.zindex + 4
				keybind.objects.container.Size = udim2_new(0, 21, 1, 0)
			end

			library:connection(keybind.objects.container.MouseButton1Down, function()
				keybind.binding = true
				keybind:set_text("...")

				local c
				c = library:connection(inputservice.InputBegan, function(input)
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
				keybind.objects.keytext.Theme = { ["Color"] = "Accent" }
			end)

			library:connection(keybind.objects.container.MouseLeave, function()
				keybind.objects.keytext.Theme = { ["Color"] = keybind.binding and "Accent" or "Option Text 2" }
			end)

			library:connection(inputservice.InputBegan, function(input, gpe)
				if keybind.bind == "none" or keybind.bind == nil or gpe then
					return
				end

				if input.KeyCode == keybind.bind or input.UserInputType == keybind.bind then
					if keybind.mode == "toggle" then
						keybind.state = not keybind.state
					elseif keybind.mode == "hold" then
						keybind.state = true

						local c
						c = library:connection(inputservice.InputEnded, function(input)
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

						local c
						c = library:connection(runservice.Heartbeat, function(delta)
							if
								(input.KeyCode == keybind.key and not inputservice:IsKeyDown(keybind.key))
								or (
									input.UserInputType == keybind.key
									and not inputservice:IsMouseButtonPressed(keybind.key)
								)
							then
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
							if keybind.mode == "always" then
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
			return self._type == "option" and self or keybind
		end

		function library.meta.options.keybind:set_text(text)
			self.objects.keytext.Text = "[" .. tostring(text) .. "]"
			self.objects.keytext.Position = udim2_new(1, -self.objects.keytext.TextBounds.X, 0, 0)

			if self.indicator then
				self.indicator:set_enabled(text ~= "NONE" and self.state)
				self.indicator:set_value("[" .. text .. "]")
			end

			if self.parent.class ~= "section" then
				self.objects.container.Size = udim2_new(0, self.objects.keytext.TextBounds.X, 0, 17)
				self.parent:update_options()
			end
		end

		function library.meta.options.keybind:set_bind(bind)
			self.bind = bind == nil and "none" or bind
			self.binding = false

			local name = "none"
			if library.mouse_strings[bind] ~= nil then
				name = library.mouse_strings[bind]
			elseif bind ~= nil and bind.Name ~= nil then
				name = bind.Name
			end

			self:set_text(tostring(name):upper())
			self.objects.keytext.Theme = {
				["Color"] = self.objects.container.MouseHover and "Accent" or "Option Text 2",
			}
		end
	end

	-- separator
	do
		library.meta.options.separator = {}
		library.meta.options.separator.__index = library.meta.options.separator
		setmetatable(library.meta.options.separator, library.meta.options)

		function library.meta.options.separator:new(properties)
			local separator = library:create("option", properties, self, "separator"), library.meta.options.separator
			separator.state = false

			separator.objects.line_1 = library:create("rect", {
				Theme = { ["Color"] = "Option Background" },
				Size = udim2_new(0, 0, 0, 1),
				Position = udim2_new(0, 1, 0.5, 0),
				AnchorPoint = vector2_new(0, 0.5),
				ZIndex = separator.zindex + 3,
				Parent = separator.objects.container,
			})

			separator.objects.line_2 = library:create("rect", {
				Theme = { ["Color"] = "Option Background" },
				Size = udim2_new(0, 0, 0, 1),
				Position = udim2_new(1, -1, 0.5, 0),
				AnchorPoint = vector2_new(1, 0.5),
				ZIndex = separator.zindex + 3,
				Parent = separator.objects.container,
			})

			separator.objects.label.Center = true
			separator.objects.label.Position = udim2_new(0.5, 0, 0, 1)

			separator.objects.border_1 =
				library:create("outline", separator.objects.line_1, { ["Theme"] = { ["Color"] = "Border 1" } })
			separator.objects.border_2 =
				library:create("outline", separator.objects.line_2, { ["Theme"] = { ["Color"] = "Border 1" } })

			table_insert(self.options, separator)
			separator:set_text(separator.text)
			return self._type == "option" and self or separator
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
	library:define("drawing", function(_, class, properties, readonly)
		local drawing = {
			Name = "",
			Theme = {},
			_object = Drawing.new(class),
			_properties = properties or {},
			_readonly = readonly or {},
			_handlers = {},
			_children = {},
		}

		drawing._handlers.Size = function(size)
			drawing._object.Size = size or 0
			drawing._properties.Size = size or 0
		end

		drawing._handlers.Position = function(position)
			assert(
				typeof(position) == "UDim2",
				("invalid Position type. expected 'UDim2', got '%s'."):format(typeof(position))
			)

			local parent = drawing._properties.Parent
			local parent_position = parent == nil and vector2_zero or parent.AbsolutePosition
			local parent_size = parent == nil and library.screensize or parent.AbsoluteSize
			local new_position = utility:udim2_to_vector2(position, parent_size)
			local anchorpoint = (
				drawing._properties.AnchorPoint ~= nil
				and utility:udim2_to_vector2(
					udim2_new(drawing._properties.AnchorPoint.X, 0, drawing._properties.AnchorPoint.Y, 0),
					class == "Text" and drawing._object.TextBounds or drawing._properties.AbsoluteSize
				)
			) or vector2_new(0, 0)

			drawing._properties.Position = position
			drawing._properties.AbsolutePosition = utility.vector2.floor((parent_position + new_position) - anchorpoint)
			drawing._object.Position = drawing._properties.AbsolutePosition

			for i, v in next, drawing._children do
				v.Position = v.Position
			end
		end

		drawing._handlers.Visible = function(bool)
			assert(
				typeof(bool) == "boolean",
				("invalid Visible type. expected 'boolean', got '%s'"):format(typeof(bool))
			)

			local parent_visible = drawing._properties.Parent == nil and true
				or drawing._properties.Parent._object.Visible
			local visible = bool and parent_visible

			drawing._properties.Visible = bool
			drawing._object.Visible = visible

			for i, v in next, drawing._children do
				v.Visible = v.Visible
			end
		end

		drawing._handlers.AnchorPoint = function(anchorpoint)
			assert(
				typeof(anchorpoint) == "Vector2",
				("invalid AnchorPoint type. expected 'Vector2', got '%s'."):format(typeof(anchorpoint))
			)

			drawing._properties.AnchorPoint = anchorpoint
			drawing._handlers.Position(drawing._properties.Position)
		end

		drawing._handlers.Parent = function(parent)
			-- assert(parent == nil or table_find(library.drawings, parent), ("invalid Parent. not a valid drawing."))

			if drawing._properties.Parent ~= nil then
				table_remove(
					drawing._properties.Parent._children,
					table_find(drawing._properties.Parent._children, drawing._metatable)
				)
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
			drawing._metatable.ZIndex = drawing._properties.Parent == nil and 1
				or drawing._properties.Parent.ZIndex + offset
		end

		function drawing:GetDescendants(children, descendants)
			local descendants = {}
			local function a(t)
				for _, v in next, t._children do
					table_insert(descendants, v)
					a(v)
				end
			end
			a(self)
			return descendants
		end

		function drawing:Remove()
			if rawget(drawing._object, "__OBJECT_EXISTS") then
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

			for i, v in next, self._children do
				v:Remove()
			end
		end

		function drawing:Clone()
			local clone = library:create("drawing", class, drawing._properties, drawing._readonly)
			for i, v in next, drawing._properties do
				clone[i] = v
			end
			return clone
		end

		drawing._metatable = setmetatable({}, {
			__index = function(self, idx)
				if drawing[idx] ~= nil then
					return drawing[idx]
				elseif drawing._properties[idx] ~= nil or idx == "Parent" then
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
				elseif drawing._properties[idx] ~= nil or idx == "Parent" then
					drawing._properties[idx] = val
				elseif utility.table.includes(drawing._object, idx) or idx == "Data" then
					drawing._object[idx] = val
				else
					warn(("invalid '%s' property '%s'."):format(class, idx))
				end
			end,
		})

		table_insert(library.drawings.noparent, drawing._metatable)
		library.drawings.raw[drawing._object] = class
		library.drawings.objects[drawing] = drawing._metatable
		return drawing._metatable
	end)

	-- rect
	library:define("rect", function(default_properties, properties, class)
		local rect = library:create("drawing", class or "Square", {
			Size = udim2_new(0, 0, 0, 0),
			Position = udim2_new(0, 0, 0, 0),
			AbsoluteSize = vector2_new(0, 0),
			AbsolutePosition = vector2_new(0, 0),
			AnchorPoint = vector2_new(0, 0),
			Active = false,
			Draggable = false,
			MouseHover = false,
			MouseEnter = signal.new(),
			MouseLeave = signal.new(),
			MouseButton1Down = signal.new(),
			MouseButton1Up = signal.new(),
			MouseButton2Down = signal.new(),
			MouseButton2Up = signal.new(),
		}, {
			"AbsoluteSize",
			"AbsolutePosition",
			"MouseHover",
			"MouseEnter",
			"MouseLeave",
			"MouseButton1Down",
			"MouseButton1Up",
			"MouseButton2Down",
			"MouseButton2Up",
		})

		rect._handlers.Size = function(size)
			assert(typeof(size) == "UDim2", ("invalid Size type. expected 'UDim2', got '%s'"):format(typeof(size)))

			local parent = rect._properties.Parent
			local parent_position = parent == nil and vector2_new(0, 0) or parent.AbsolutePosition
			local parent_size = parent == nil and library.screensize or parent.AbsoluteSize

			rect._properties.Size = size
			rect._properties.AbsoluteSize = utility.vector2.floor(utility:udim2_to_vector2(size, parent_size))
			rect._object.Size = rect._properties.AbsoluteSize
			rect._handlers.AnchorPoint(rect._properties.AnchorPoint)

			for i, v in next, rect._children do
				v.Size = v.Size
			end
		end

		rect._handlers.Active = function(bool)
			assert(
				typeof(bool) == "boolean",
				("invalid Active type. expected 'boolean', got '%s'"):format(typeof(bool))
			)

			local position = table_find(library.drawings.active, rect)
			if not bool and position then
				table_remove(library.drawings.active, position)
			elseif bool and not position then
				table_insert(library.drawings.active, rect)
			end

			rect._properties.Active = bool
		end

		rect._handlers.Draggable = function(bool)
			assert(
				typeof(bool) == "boolean",
				("invalid Draggable type. expected 'boolean', got '%s'"):format(typeof(bool))
			)

			local position = table_find(library.drawings.draggable, rect)
			if not bool and position then
				table_remove(library.drawings.draggable, position)
			elseif bool and not position then
				table_insert(library.drawings.draggable, rect)
			end

			rect._properties.Draggable = bool
		end

		for property, value in next, utility.table.merge(default_properties, properties) do
			if property == "Filled" and class == "Image" then
				continue
			end
			rect[property] = value
		end

		return rect
	end, {
		Position = udim2_new(0, 0, 0, 0),
		Size = udim2_new(0, 0, 0, 0),
		AnchorPoint = vector2_new(0, 0),
		Visible = true,
		Filled = true,
		Active = false,
		Draggable = false,
	})

	-- text
	library:define("text", function(default_properties, properties)
		local text = library:create("drawing", "Text", {
			Position = udim2_new(0, 0, 0, 0),
			AbsolutePosition = vector2_new(0, 0),
			AnchorPoint = vector2_new(0, 0),
		}, {
			"AbsolutePosition",
		})

		for property, value in next, utility.table.merge(default_properties, properties) do
			text[property] = value
		end

		return text
	end, {
		Size = 13,
		Font = 2,
		Position = udim2_new(0, 0, 0, 0),
		Visible = true,
	})

	-- outline
	library:define("outline", function(default_properties, parent, properties)
		local outline = library:create("rect", { Parent = parent })

		outline._handlers.Thickness = function(thickness)
			if typeof(thickness) == "table" then -- [1] = top, [2] = right, [3] = bottom, [4] = left
				outline.AnchorPoint = vector2_new(0, 0)
				outline.Size = udim2_new(1, thickness[2] + thickness[4], 1, thickness[1] + thickness[3])
				outline.Position = udim2_new(0, -thickness[4], 0, -thickness[1])
			else
				outline.AnchorPoint = vector2_new(0.5, 0.5)
				outline.Size = udim2_new(1, thickness * 2, 1, thickness * 2)
			end
		end

		for i, v in next, utility.table.merge(default_properties, properties) do
			outline[i] = v
		end

		return outline
	end, {
		Position = udim2_new(0.5, 0, 0.5, 0),
		AnchorPoint = vector2_new(0.5, 0.5),
		ZIndexOffset = -1,
		Thickness = 1,
	})

	-- menu
	library:define("menu", function(meta, properties)
		local menu = setmetatable({}, meta)
		properties = properties or {}
		menu.text = properties.text or "menu"
		menu.size = properties.size or udim2_new(0, 525, 0, 650)
		menu.position = properties.position or udim2_new(0.2, 0, 0.2, 0)
		menu.open = true
		menu.visvalues = {}
		menu.objects = {}
		menu.tabs = {}

		menu.objects.background = library:create("rect", {
			Theme = { ["Color"] = "Background" },
			Visible = true,
			Size = menu.size,
			Position = menu.position,
		})

		menu.objects.title = library:create("text", {
			Theme = { ["Color"] = "Primary Text" },
			Position = udim2_new(0.5, 0, 0, -18),
			Center = true,
			Outline = true,
			Text = menu.text,
			Parent = menu.objects.background,
		})

		menu.objects.group_background = library:create("rect", {
			Theme = { ["Color"] = "Group Background" },
			Size = udim2_new(1, -20, 1, -57),
			Position = udim2_new(0.5, 0, 1, -10),
			AnchorPoint = vector2_new(0.5, 1),
			ZIndex = 3,
			Parent = menu.objects.background,
		})

		menu.objects.tab_container = library:create("rect", {
			Size = udim2_new(1, 0, 0, 27),
			Position = udim2_new(0, 0, 0, -10),
			AnchorPoint = vector2_new(0, 1),
			Transparency = 0,
			Parent = menu.objects.group_background,
		})

		menu.objects.section_container_1 = library:create("rect", {
			Size = udim2_new(0.485, -8, 1, -20),
			Position = udim2_new(0, 10, 0, 10),
			Parent = menu.objects.group_background,
			Transparency = 0,
			ZIndex = 5,
		})

		menu.objects.section_container_2 = library:create("rect", {
			Size = udim2_new(0.485, -8, 1, -20),
			Position = udim2_new(1, -10, 0, 10),
			AnchorPoint = vector2_new(1, 0, 0, 0),
			Parent = menu.objects.group_background,
			Transparency = 0,
			ZIndex = 5,
		})

		menu.objects.group_outline_1 =
			library:create("outline", menu.objects.group_background, { Theme = { ["Color"] = "Border 3" } })
		menu.objects.group_outline_2 =
			library:create("outline", menu.objects.group_outline_1, { Theme = { ["Color"] = "Border" } })
		menu.objects.outline_inner_1 =
			library:create("outline", menu.objects.background, { Theme = { ["Color"] = "Border 1" } })
		menu.objects.outline_inner_2 =
			library:create("outline", menu.objects.outline_inner_1, { Theme = { ["Color"] = "Border 2" } })
		menu.objects.outline_middle = library:create(
			"outline",
			menu.objects.outline_inner_2,
			{ Theme = { ["Color"] = "Border 3" }, Thickness = { 19, 5, 5, 5 } }
		)
		menu.objects.outline_outer_1 =
			library:create("outline", menu.objects.outline_middle, { Theme = { ["Color"] = "Accent" } })
		menu.objects.outline_outer_2 =
			library:create("outline", menu.objects.outline_outer_1, { Theme = { ["Color"] = "Border 1" } })

		menu.objects.drag_interaction = library:create("rect", {
			Size = udim2_new(1, 0, 1, 0),
			Active = true,
			Thickness = 1,
			ZIndex = 3,
			Transparency = 0,
			Parent = menu.objects.outline_outer_2,
		})

		menu.objects.drag_fade = library:create("rect", {
			Size = udim2_new(1, 0, 1, 0),
			Thickness = 1,
			ZIndex = 100,
			Transparency = 0,
			Parent = menu.objects.outline_outer_2,
		})

		library:connection(menu.objects.drag_interaction.MouseButton1Down, function()
			if menu.dragging then
				return
			end

			local drag_position_start = menu.objects.background.AbsolutePosition
			local mouse_position_start = inputservice:GetMouseLocation()
			local start_relative_pos = mouse_position_start - drag_position_start

			local inputchanged
			inputchanged = library:connection(inputservice.InputChanged, function(input)
				if input.UserInputType == Enum.UserInputType.MouseMovement then
					local position = inputservice:GetMouseLocation() - start_relative_pos
					local clamped_position = vector2_new(
						math_clamp(
							position.X,
							9,
							(camera.ViewportSize.X - menu.objects.outline_outer_2.AbsoluteSize.X) - 9
						),
						math_clamp(
							position.Y,
							23,
							(camera.ViewportSize.Y - menu.objects.outline_outer_2.AbsoluteSize.Y) - 23
						)
					)

					menu.objects.background.Position = udim2_offset(clamped_position.X, clamped_position.Y)
				end
			end)

			local inputended
			inputended = library:connection(inputservice.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					inputchanged:Disconnect()
					inputended:Disconnect()

					local final_position = menu.objects.background.Position
					utility:tween(menu.objects.background, "Position", final_position, 0.15, Enum.EasingStyle.Quad)
					utility:tween(menu.objects.drag_fade, "Transparency", 0, 0.075)

					menu.dragging = false
				end
			end)

			menu.dragging = true
			utility:tween(menu.objects.drag_fade, "Transparency", 0.2, 0.075)
		end)

		return menu
	end, {

		set_open = function(self, bool, duration)
			if bool == self.open then
				return
			end

			duration = duration or 0

			local objects = self.objects.background:GetDescendants()
			table_insert(objects, self.objects.background)

			for _, v in next, objects do
				if v.Transparency ~= 0 then
					if bool then
						utility:tween(v, "Transparency", self.visvalues[v] or 1, duration)
					else
						self.visvalues[v] = v.Transparency
						utility:tween(v, "Transparency", 0.05, duration)
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
			local tab = library:create("tab", properties, self.objects.tab_container)
			tab.sections = {}
			tab.order = properties.order or #self.tabs + 1
			tab.parent = self

			library:connection(tab.objects.background.MouseButton1Down, function()
				if self.selected == tab then
					return
				end
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
			table_sort(self.tabs, function(a, b)
				return a.order < b.order
			end)

			for i, tab in next, self.tabs do
				local selected = tab == self.selected
				tab.objects.background.Size = udim2_new(1 / #self.tabs, i == #self.tabs and 0 or -1, 1, 0)
				tab.objects.background.Position = udim2_new((i - 1) * (1 / #self.tabs), 0, 0, 0)
				tab.objects.background.Theme = { ["Color"] = selected and "Selected Tab" or "Unselected Tab" }
				tab.objects.text.Theme = { ["Color"] = selected and "Accent" or "Unselected Tab Text" }
				tab.objects.gradient.Data = selected and library.images.gradientn90 or library.images.gradientp90
				tab:update_sections()
			end
		end,
	}, true)

	-- tab
	library:define("tab", function(meta, properties, container, parent)
		local tab = setmetatable({}, meta)
		tab.text = properties.text or ""
		tab.objects = {}

		tab.objects.background = library:create("rect", {
			Name = "tab",
			Theme = { ["Color"] = "Unselected Tab" },
			Active = true,
			Size = udim2_new(1, 0, 1, 0),
			Parent = container,
			ZIndex = 6,
		})

		tab.objects.gradient = library:create("rect", {
			Size = udim2_new(1, 0, 1, 0),
			Parent = tab.objects.background,
			Transparency = 0.75,
			ZIndex = 6,
		}, "Image")

		tab.objects.text = library:create("text", {
			Theme = { ["Color"] = "Unselected Tab Text" },
			Position = udim2_new(0.5, 0, 0.5, -7),
			Center = true,
			Text = properties.text,
			Parent = tab.objects.background,
			ZIndex = 7,
		})

		tab.objects.outline_1 =
			library:create("outline", tab.objects.background, { Theme = { ["Color"] = "Border 3" } })
		tab.objects.outline_2 = library:create("outline", tab.objects.outline_1, { Theme = { ["Color"] = "Border" } })

		return tab
	end, {

		section = function(self, properties)
			local side = math_clamp(properties.side or 1, 1, 2)
			local section = library:create("section", properties, self.parent.objects["section_container_" .. side])
			section.options = {}
			section.side = side
			section.parent = self
			section.class = "section"

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

					if option.class == "toggle" then
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
		end,
	}, true)

	-- section
	library:define("section", function(default_properties, properties, container)
		local section = {}
		section.text = properties.text or ""
		section.objects = {}

		section.objects.background = library:create("rect", {
			Name = "section",
			Theme = { ["Color"] = "Section Background" },
			Size = udim2_new(1, 0, 0, 60),
			Parent = container,
			ZIndex = 6,
		})

		section.objects.accent = library:create("rect", {
			Theme = { ["Color"] = "Accent" },
			Size = udim2_new(1, 0, 0, 1),
			Parent = section.objects.background,
			ZIndex = 7,
		})

		section.objects.text = library:create("text", {
			Theme = { ["Color"] = "Primary Text" },
			Position = udim2_new(0, 10, 0, -8),
			Text = properties.text,
			Parent = section.objects.background,
			ZIndex = 9,
		})

		section.objects.text_border = library:create("rect", {
			Theme = { ["Color"] = "Section Background" },
			Size = udim2_new(0, section.objects.text.TextBounds.X + 8, 0, 3),
			Position = udim2_new(0, 6, 0, -2),
			Parent = section.objects.background,
			ZIndex = 8,
		})

		section.objects.container = library:create("rect", {
			Size = udim2_new(1, -14, 1, -10),
			Position = udim2_new(0, 7, 0, 10),
			Parent = section.objects.background,
			Transparency = 0,
			ZIndex = 7,
		})

		section.objects.outline_1 = library:create(
			"outline",
			section.objects.background,
			{ Theme = { ["Color"] = "Border" }, Thickness = { 1, 1, 1, 1 } }
		)
		section.objects.outline_2 = library:create(
			"outline",
			section.objects.outline_1,
			{ Theme = { ["Color"] = "Border 3" }, Thickness = { 1, 1, 1, 1 } }
		)

		return setmetatable(section, {
			__index = function(self, idx)
				if self[idx] ~= nil then
					return self[idx]
				elseif library.meta.options[idx] ~= nil then
					return library.meta.options[idx]
				end
			end,
		})
	end)

	-- option
	library:define("option", function(default_properties, properties, parent, id)
		print(id, properties.flag)

		local option = {}
		option._type = "option"
		option.class = id
		option.parent = parent
		option.flag = properties.flag
		option.order = properties.order or #option.parent.options + 1
		option.enabled = properties.enabled == nil and true or properties.enabled
		option.zindex = properties.zindex or 15
		option.text = properties.text or ""
		option.callback = properties.callback or function() end
		option.objects = {}
		option.options = {}

		option.objects.container = library:create("rect", {
			Name = id or "option",
			Size = properties.size or udim2_new(1, 0, 0, 18),
			Position = properties.position,
			AnchorPoint = properties.anchorpoint,
			Transparency = 0,
			Active = true,
			ZIndex = option.zindex,
			Parent = option.parent.objects.container,
		})

		option.objects.label = library:create("text", {
			Theme = { ["Color"] = "Option Text 2", ["OutlineColor"] = "Border 1" },
			Position = udim2_new(0, 0, 0, 1),
			Text = option.text,
			Outline = true,
			Parent = option.objects.container,
			ZIndex = option.zindex + 5,
		})

		if option.flag ~= nil then
			library.options[option.flag] = option
		end

		return setmetatable(option, library.meta.options[id])
	end)

	-- colorpicker slider
	library:define("colorpickerslider", function(default_properties, container, properties)
		local slider = {}

		slider.container = library:create("rect", {
			Name = properties.id,
			Active = true,
			Size = udim2_new(0, 10, 1, 0),
			Position = properties.position,
			Parent = container,
			ZIndex = container.ZIndex + 3,
		})

		slider.hue_image = library:create("rect", {
			Data = properties.image,
			Size = udim2_new(1, 0, 1, 0),
			Parent = slider.container,
			ZIndex = container.ZIndex + 4,
		}, "Image")

		slider.slider = library:create("rect", {
			Size = udim2_new(1, 0, 0, 3),
			Filled = false,
			Thickness = 1,
			Parent = slider.container,
			ZIndex = container.ZIndex + 5,
		})

		slider.hue_border_inner = library:create("outline", slider.container, { ["Theme"] = { ["Color"] = "Border" } })
		slider.hue_border_outer =
			library:create("outline", slider.hue_border_inner, { ["Theme"] = { ["Color"] = "Border 3" } })

		return slider
	end)

	-- colorpicker
	library:define("colorpicker", function(default_properties, properties)
		local colorpicker = setmetatable({}, library.meta.colorpicker)
		colorpicker.objects = {}
		colorpicker.options = {}
		colorpicker.color = color3_new(1, 1, 1)
		colorpicker.hex = colorpicker.color:ToHex()
		colorpicker.hue = ({ colorpicker.color:ToHSV() })[1] -- this is retarded its just to keep it clean(ish)
		colorpicker.sat = ({ colorpicker.color:ToHSV() })[2]
		colorpicker.val = ({ colorpicker.color:ToHSV() })[3]
		colorpicker.opacity = 1
		colorpicker.zindex = properties.zindex or 30

		colorpicker.objects.background = library:create("rect", {
			Name = "colorpicker",
			Theme = { ["Color"] = "Group Background" },
			Active = true,
			Size = udim2_new(0, 206, 0, 258),
			Position = udim2_new(1, -2, 1, 2),
			AnchorPoint = vector2_new(1, 0),
			ZIndex = colorpicker.zindex,
		})

		colorpicker.objects.label = library:create("text", {
			Text = "colorpicker name",
			Theme = { ["Color"] = "Primary Text" },
			Position = udim2_new(0, 6, 0, 1),
			Outline = true,
			Parent = colorpicker.objects.background,
			ZIndex = colorpicker.zindex + 1,
		})

		colorpicker.objects.color = library:create("rect", {
			Name = "color palette",
			Color = colorpicker.color,
			Active = true,
			Size = udim2_new(0, 150, 0, 150),
			Position = udim2_new(0, 8, 0, 20),
			Parent = colorpicker.objects.background,
			ZIndex = colorpicker.zindex + 5,
		})

		colorpicker.objects.sat = library:create("rect", {
			Data = library.images.colorsat1,
			Size = udim2_new(1, 0, 1, 0),
			Parent = colorpicker.objects.color,
			ZIndex = colorpicker.zindex + 6,
		}, "Image")

		colorpicker.objects.val = library:create("rect", {
			Data = library.images.colorsat2,
			Size = udim2_new(1, 0, 1, 0),
			Parent = colorpicker.objects.color,
			ZIndex = colorpicker.zindex + 7,
		}, "Image")

		colorpicker.objects.pointer = library:create("rect", {
			Position = udim2_new(1, 0.5, 1, 0),
			Size = udim2_new(0, 1, 0, 1),
			Color = color3_new(1, 1, 1),
			ZIndex = colorpicker.zindex + 7,
			Parent = colorpicker.objects.color,
		})

		colorpicker.objects.container = library:create("rect", {
			Name = "container",
			Size = udim2_new(0, 194, 0, 75),
			Position = udim2_new(0, -2, 1, 5),
			Transparency = 0,
			Parent = colorpicker.objects.color,
			ZIndex = colorpicker.zindex + 1,
		})

		colorpicker.objects.pointer_outline = library:create("outline", colorpicker.objects.pointer)
		colorpicker.objects.border_inner =
			library:create("outline", colorpicker.objects.background, { ["Theme"] = { ["Color"] = "Border 3" } })
		colorpicker.objects.border_outer =
			library:create("outline", colorpicker.objects.border_inner, { ["Theme"] = { ["Color"] = "Border" } })
		colorpicker.objects.color_border_inner =
			library:create("outline", colorpicker.objects.color, { ["Theme"] = { ["Color"] = "Border" } })
		colorpicker.objects.color_border_outer = library:create(
			"outline",
			colorpicker.objects.color_border_inner,
			{ ["Theme"] = { ["Color"] = "Border 3" } }
		)
		colorpicker.objects_hue = library:create(
			"colorpickerslider",
			colorpicker.objects.color,
			{ position = udim2_new(1, 10, 0, 0), image = library.images.colorhue, id = "hue" }
		)
		colorpicker.objects_opacity = library:create(
			"colorpickerslider",
			colorpicker.objects.color,
			{ position = udim2_new(1, 30, 0, 0), image = library.images.colortrans, id = "opacity" }
		)

		colorpicker.accent_toggle = colorpicker:toggle({
			text = "use accent",
			flag = "COLORPICKER_ACCENT_TOGGLE",
			position = udim2_new(0, 1, 0, 0),
			zindex = colorpicker.zindex + 10,
			callback = function(bool)
				if not colorpicker.selected or colorpicker.selected.flag == "theme_accent" then
					return
				end

				colorpicker.selected.useaccent = bool

				if bool then
					colorpicker:set(library.theme.Accent, colorpicker.selected.opacity)
					colorpicker.selected:set(library.theme.Accent, colorpicker.selected.opacity)
				end
			end,
		})

		colorpicker.rainbow_toggle = colorpicker:toggle({
			text = "rainbow",
			flag = "COLORPICKER_RAINBOW_TOGGLE",
			position = udim2_new(0, 1, 0, 20),
			zindex = colorpicker.zindex + 10,
			callback = function(bool)
				if not colorpicker.selected then
					return
				end

				colorpicker.selected.rainbow = bool

				if bool then
					if not table.find(library.rainbows, colorpicker.selected) then
						table.insert(library.rainbows, colorpicker.selected)
					end
				else
					local index = table.find(library.rainbows, colorpicker.selected)
					if index then
						table.remove(library.rainbows, index)
					end
				end
			end,
		})

		colorpicker.hex_button = colorpicker:button({
			text = "#" .. colorpicker.hex,
			size = udim2_new(0.5, -2, 0, 18),
			position = udim2_new(0, 1, 0, 40),
			zindex = colorpicker.zindex + 10,
		})

		colorpicker.reset = colorpicker:button({
			text = "reset",
			size = udim2_new(0.5, -2, 0, 18),
			position = udim2_new(0.5, 2, 0, 40),
			zindex = colorpicker.zindex + 10,
			callback = function()
				if not colorpicker.selected then
					return
				end
				colorpicker:set(
					colorpicker.selected.default or color3_new(1, 1, 1),
					colorpicker.selected.default_opacity or 0
				)
			end,
		})

		colorpicker.copy = colorpicker:button({
			text = "copy",
			size = udim2_new(0.5, -2, 0, 18),
			position = udim2_new(0, 1, 0, 60),
			zindex = colorpicker.zindex + 10,
			callback = function()
				if not colorpicker.selected then
					return
				end
				library.colorpicker_copied_color = colorpicker.selected.color
				library.colorpicker_copied_opacity = colorpicker.selected.opacity
				setclipboard(colorpicker.selected.color:ToHex())
			end,
		})

		colorpicker.paste = colorpicker:button({
			text = "paste",
			size = udim2_new(0.5, -2, 0, 18),
			position = udim2_new(0.5, 2, 0, 60),
			zindex = colorpicker.zindex + 10,
			callback = function()
				if not colorpicker.selected then
					return
				end
				colorpicker:set(
					library.colorpicker_copied_color or color3_new(1, 1, 1),
					library.colorpicker_copied_opacity or 0
				)
			end,
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
			if
				input.UserInputType == Enum.UserInputType.MouseMovement
				and (colorpicker.dragging_hue or colorpicker.dragging_sat or colorpicker.dragging_opacity)
			then
				colorpicker:update()
			end
		end)

		colorpicker.objects.background.Visible = false
		colorpicker:set(properties.default or colorpicker.color, properties.default_opacity or colorpicker.opacity)
		return colorpicker
	end)

	-- dropdown option
	library:define("dropdownvalue", function(default_properties, container)
		local objects = {}

		objects.container = library:create("rect", {
			Color = color3_new(1, 1, 1),
			Size = udim2_new(1, -8, 0, 15),
			Position = udim2_new(0, 2, 1, 0),
			Transparency = 0,
			Active = true,
			Visible = false,
			ZIndex = 43,
			Parent = container,
		})

		objects.label = library:create("text", {
			Theme = { ["Color"] = "Option Text 2" },
			Text = "placeholder",
			Position = udim2_new(0, 2, 0, 0),
			Outline = true,
			ZIndex = 44,
			Parent = objects.container,
		})

		return objects
	end)

	-- notification
	library:define("notification", function()
		local objects = {}
		local zindex = 100

		objects.container = library:create("rect", {
			Name = "container",
			Size = udim2_new(0, 200, 0, 18),
			Visible = false,
			ZIndex = zindex,
		})

		objects.background = library:create("rect", {
			Name = "background",
			Theme = { ["Color"] = "Background" },
			Parent = objects.container,
			ZIndex = zindex,
		})

		objects.label = library:create("text", {
			Theme = { ["Color"] = "Primary Text" },
			Position = udim2_new(0.5, 1, 0, 0),
			Center = true,
			Parent = objects.background,
			ZIndex = zindex + 1,
		})

		objects.accent = library:create("rect", {
			Name = "accent",
			Theme = { ["Color"] = "Accent" },
			Size = udim2_new(0, 1, 1, 0),
			Parent = objects.background,
			ZIndex = zindex + 1,
		})

		objects.progress = library:create("rect", {
			Name = "progress",
			Theme = { ["Color"] = "Accent" },
			Size = udim2_new(0, 0, 0, 1),
			Position = udim2_new(0, 0, 1, -1),
			Parent = objects.background,
			ZIndex = zindex + 1,
		})

		objects.border_inner = library:create("outline", objects.background, { Theme = { ["Color"] = "Border 3" } })
		objects.border_outer = library:create("outline", objects.border_inner, { Theme = { ["Color"] = "Border" } })

		return objects
	end)

	-- watermark
	library:define("watermark", function(meta, properties)
		local watermark = setmetatable({}, meta)
		properties = properties or {}
		watermark.lastupdate = 0
		watermark.enabled = properties.enabled or false
		watermark.objects = {}
		watermark.text = properties.text or {
			"hyphon.cc",
			"liamm#0223",
			"uid 1",
			"999ms",
			"999 fps",
		}
		watermark.position = properties.position or "Top Left"

		watermark.objects.background = library:create("rect", {
			Position = udim2_new(0, 10, 0, 10),
			Theme = { ["Color"] = "Background" },
			Visible = false,
		})

		watermark.objects.label = library:create("text", {
			Theme = { ["Color"] = "Primary Text" },
			Position = udim2_new(0.5, 0, 0, 2),
			Center = true,
			Parent = watermark.objects.background,
		})

		watermark.objects.accent = library:create("rect", {
			Theme = { ["Color"] = "Accent" },
			Size = udim2_new(1, 0, 0, 1),
			Parent = watermark.objects.background,
		})

		watermark.objects.outline =
			library:create("outline", watermark.objects.background, { Theme = { ["Color"] = "Border 1" } })
		watermark.objects.outline2 =
			library:create("outline", watermark.objects.outline, { Theme = { ["Color"] = "Border 2" } })

		library:connection(runservice.RenderStepped, function(delta)
			library.stat.fps = 1 / delta
			library.stat.ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()

			watermark.objects.background.Visible = watermark.enabled

			if tick() - watermark.lastupdate > 0.1 and watermark.enabled then
				watermark.lastupdate = tick()

				watermark.text[4] = tostring(math_floor(library.stat.ping)) .. "ms"
				watermark.text[5] = tostring(math_floor(library.stat.fps)) .. " fps"

				watermark.objects.label.Text = table_concat(watermark.text, " / ")
				watermark.objects.background.Size = udim2_new(0, watermark.objects.label.TextBounds.X + 10, 0, 18)

				local sizeX, sizeY =
					watermark.objects.background.Size.X.Offset, watermark.objects.background.Size.Y.Offset
				local textWidth = watermark.objects.label.TextBounds.X

				watermark.objects.background.Position = (watermark.position == "Top Left" and udim2_new(0, 10, 0, 10))
					or (watermark.position == "Top Right" and udim2_new(1, -sizeX - 10, 0, 10))
					or (watermark.position == "Bottom Left" and udim2_new(0, 10, 1, -sizeY - 10))
					or (watermark.position == "Bottom Right" and udim2_new(1, -sizeX - 10, 1, -sizeY - 10))
					or (watermark.position == "Center" and udim2_new(0.5, -textWidth / 2, 0, 10))
					or (watermark.position == "Custom" and udim2_new(
						library.flags.watermark_x / 100,
						0,
						library.flags.watermark_y / 100,
						0
					))
					or udim2_new(0, 10, 0, 10)
			end
		end)

		return watermark
	end, {
		set_enabled = function(self, bool)
			self.enabled = bool
		end,
	}, true)

	-- indicator
	library:define("indicator", function(meta, properties)
		local indicator = setmetatable({}, meta)
		properties = properties or {}
		indicator.title = properties.title or "title"
		indicator.position = properties.position or udim2_new(0, 0, 0, 0)
		indicator.enabled = true
		indicator.values = {}
		indicator.objects = {}
		indicator.zindex = 0

		indicator.objects.background = library:create("rect", {
			Theme = { ["Color"] = "Background" },
		})

		indicator.objects.accent = library:create("rect", {
			Theme = { ["Color"] = "Accent" },
			Size = udim2_new(1, 0, 0, 1),
			Parent = indicator.objects.background,
		})

		indicator.objects.title = library:create("text", {
			Theme = { ["Color"] = "Primary Text" },
			Position = udim2_new(0.5, 0, 0, 2),
			Center = true,
			Text = indicator.title,
			Parent = indicator.objects.background,
		})

		indicator.objects.border_inner =
			library:create("outline", indicator.objects.background, { Theme = { ["Color"] = "Border 3" } })
		indicator.objects.border_outer =
			library:create("outline", indicator.objects.border_inner, { Theme = { ["Color"] = "Border" } })

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

				value.objects.background.Position = udim2_new(0, 0, 0, pos_y)

				local size_y

				if value.alignment == "vertical" then
					size_y = value.objects.key.TextBounds.Y + value.objects.value.TextBounds.Y
					size_x =
						math_max(size_x, value.objects.key.TextBounds.X + 12, value.objects.value.TextBounds.X + 12)
					value.objects.value.Position = udim2_new(0, 6, 0, value.objects.key.TextBounds.Y - 8)
				else
					size_y = math_max(value.objects.key.TextBounds.Y + 4, value.objects.value.TextBounds.Y + 4)
					size_x = math_max(size_x, value.objects.key.TextBounds.X + 35 + value.objects.value.TextBounds.X)
				end

				value.objects.background.Size = udim2_new(1, 0, 0, size_y)
				pos_y = pos_y + size_y
			end

			self.objects.background.Size = udim2_new(0, size_x, 0, 18)
			self.objects.background.Position = self.position
		end,

		value = function(self, properties)
			local value = library:create("indicator_value", properties, self)
			table_insert(self.values, value)
			self:update()
			return value
		end,
	}, true)

	library:define("indicator_value", function(meta, properties, parent)
		local value = setmetatable({}, meta)
		value.parent = parent
		value.key = properties.key or "key"
		value.value = properties.value or "value"
		value.alignment = properties.alignment or "horizontal"
		value.objects = {}
		value.enabled = true

		value.objects.background = library:create("rect", {
			Theme = { ["Color"] = "Background" },
			Size = value.alignment == "vertical" and udim2_new(1, 0, 0, 36) or udim2_new(1, 0, 0, 18),
			Parent = parent.objects.background,
		})

		value.objects.key = library:create("text", {
			Theme = { ["Color"] = "Primary Text" },
			Position = udim2_new(0, 6, 0, 1),
			Text = value.key,
			Parent = value.objects.background,
		})

		value.objects.value = library:create("text", {
			Theme = { ["Color"] = "Secondary Text" },
			Position = value.alignment == "vertical" and udim2_new(0, 6, 0, 0) or udim2_new(1, -6, 0, 1),
			AnchorPoint = value.alignment == "vertical" and vector2_new(0, 0) or vector2_new(1, 0),
			Text = value.value,
			Parent = value.objects.background,
		})

		value.objects.border_inner =
			library:create("outline", value.objects.background, { Theme = { ["Color"] = "Border 3" } })
		value.objects.border_outer =
			library:create("outline", value.objects.border_inner, { Theme = { ["Color"] = "Border" } })

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
		end,
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
		library.camera_connection = library:connection(
			library.camera:GetPropertyChangedSignal("ViewportSize"),
			function()
				library.screensize = library.camera.ViewportSize
			end
		)
	end

	camera_added(workspace.CurrentCamera)

	library:connection(workspace:GetPropertyChangedSignal("CurrentCamera"), camera_added)

	library.debug_object = library:create("rect", {
		Color = color3_new(1, 1, 1),
		Size = udim2_new(1, 2, 1, 2),
		Position = udim2_new(0, -1, 0, -1),
		Filled = false,
		Thickness = 1,
		ZIndex = 9999,
	})

	library.debug_text = library:create("text", {
		Color = color3_new(1, 1, 1),
		Position = udim2_new(0.5, 0, 1, 0),
		Center = true,
		Outline = true,
		ZIndex = 9999,
		Parent = library.debug_object,
	})

	library:connection(inputservice.InputBegan, function(input, processed)
		-- if processed then return end

		if
			input.KeyCode == Enum.KeyCode.Equals
			and inputservice:IsKeyDown(Enum.KeyCode.LeftControl)
			and not processed
		then
			game:GetService("TeleportService"):Teleport(game.PlaceId)
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if
				library.colorpicker.selected ~= nil
				and not utility.vector2.inside(
					inputservice:GetMouseLocation(),
					library.colorpicker.objects.background.AbsolutePosition,
					library.colorpicker.objects.background.AbsoluteSize
				)
			then
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
			if library.fovcircles then
				for i, v in next, library.fovcircles do
					if v._mode == "mouse" then
						v:update()
					end
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

				if library.drawings and library.drawings.objects then
					table_sort(library.drawings.objects, function(a, b)
						return a.ZIndex > b.ZIndex
					end)

					for index, drawing in next, library.drawings.objects do
						if
							drawing.Name ~= ""
							and drawing._object.Visible
							and utility.vector2.inside(mouse_pos, drawing.AbsolutePosition, drawing.AbsoluteSize)
						then
							debug_hover_object = drawing
							break
						end
					end
				end

				if debug_hover_object then
					if library.debug_object.Parent ~= debug_hover_object then
						library.debug_object.Visible = true
						library.debug_object.Parent = debug_hover_object
						library.debug_text.Text = ("Name: %s\nSize: %s\nPosition: %s\nZIndex: %s\nChildren: %s\nCalculate: %s"):format(
							debug_hover_object.Name,
							utility:get_size_string(debug_hover_object.Size, debug_hover_object.AbsoluteSize),
							utility:get_size_string(debug_hover_object.Position, debug_hover_object.AbsolutePosition),
							debug_hover_object.ZIndex,
							#debug_hover_object._children,
							math_floor(((tick() - debug_calc_start) * 1000) * 10000) / 10000 .. "ms"
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

			if library.drawings and library.drawings.active then
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
			end

			if library.dragging_slider then
				library.dragging_slider:update()
			end
		end
	end)

	library:connection(camera:GetPropertyChangedSignal("FieldOfView"), function()
		for i, v in next, library.fovcircles do
			v:update()
		end
	end)

	library:connection(camera:GetPropertyChangedSignal("ViewportSize"), function()
		for i, v in next, library.drawings.noparent do
			v.Size = v.Size
			v.Position = v.Position
		end
		for i, v in next, library.fovcircles do
			v:update()
		end
	end)

	task.spawn(function()
		while task.wait(1 / 60) do
			if library.rainbows then
				local color = color3_hsv((tick() / 5) % 1, 0.5, 1)
				for i, v in next, library.rainbows do
					if not v.useaccent then
						v:set(color, v.opacity)
					end
				end
			end
		end
	end)
end

-- // finish
library.keybind_indicator =
	library:create("indicator", { title = "keybinds", position = udim2_new(0, 10, 0, 450), enabled = false })

library.watermark = library:create(
	"watermark",
	{ enabled = false, position = "top-left", text = { "therion", "version: v1.0.0", "pro", "999ms", "999 fps" } }
)
library.colorpicker = library:create("colorpicker", {})
library.dropdown = { selected = nil, objects = { values = {} }, connections = {} }

library.dropdown.objects.background = library:create("rect", {
	Theme = { ["Color"] = "Background" },
	Size = udim2_new(1, -4, 0, 20),
	Position = udim2_new(0.5, 0, 1, 0),
	AnchorPoint = vector2_new(0.5, 0),
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

library.dropdown.objects.border_inner =
	library:create("outline", library.dropdown.objects.background, { Theme = { ["Color"] = "Border 3" } })
library.dropdown.objects.border_outer =
	library:create("outline", library.dropdown.objects.border_inner, { Theme = { ["Color"] = "Border" } })

function library:create_settings_tab(menu)
	local tab = menu:tab({ text = "settings", order = 999 })
	local settings_main = tab:section({ text = "main", side = 1 })
	local settings_config = tab:section({ text = "config", side = 2 })
	local settings_themes = tab:section({ text = "themes", side = 1 })

	settings_main:keybind({
		text = "open / close",
		flag = "menubind",
		default = Enum.KeyCode.End,
		callback = function(bool)
			menu:set_open(bool, 0.1)
		end,
	})

	settings_main:toggle({
		text = "keybind indicator",
		flag = "keybind_indicator_enabled",
		callback = function(bool)
			library.keybind_indicator:set_enabled(bool)
		end,
	})

	settings_main:button({
		text = "join discord",
		callback = function()
			local res = request({
				Url = "http://127.0.0.1:6463/rpc?v=1",
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
					Origin = "https://discord.com",
				},
				Body = http:JSONEncode({
					cmd = "INVITE_BROWSER",
					nonce = http:GenerateGUID(false),
					args = { code = "NNwvvJkK3m" },
				}),
			})
			if res.Success then
				library:notification(library.cheatname .. " | joined discord", 3)
			end
		end,
	})

	settings_main:button({
		text = "copy javascript invite",
		callback = function()
			setclipboard("Roblox.GameLauncher.joinGameInstance(" .. game.PlaceId .. ',"' .. game.JobId .. '")')
		end,
	})

	settings_main:button({
		text = "rejoin",
		confirm = true,
		callback = function()
			game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
		end,
	})

	settings_main:separator({ text = "watermark", order = 1, enabled = true })

	settings_main:toggle({
		text = "enabled ",
		flag = "watermark_enabled",
		callback = function(bool)
			library.watermark:set_enabled(bool)
		end,
	})

	settings_main:dropdown({
		text = "position",
		flag = "watermark_pos",
		default = "Center",
		values = { "Center", "Top Left", "Top Right", "Bottom Left", "Bottom Right", "Custom" },
		callback = function(val)
			library.watermark.position = val
		end,
	})
	settings_main:slider({ text = "custom x", flag = "watermark_x", suffix = "%", min = 0, max = 100, increment = 0.1 })
	settings_main:slider({ text = "custom y", flag = "watermark_y", suffix = "%", min = 0, max = 100, increment = 0.1 })

	settings_config:dropdown({ text = "config", flag = "configs_selected" })
	settings_config:textbox({ text = "config name", flag = "configs_input" })

	settings_config:button({
		text = "create",
		confirm = true,
		callback = function()
			if not flags.configs_input or flags.configs_input:match("^%s*$") then
				library:notification("config name cannot be empty", 5, color3_new(1, 0.35, 0.35))
				return
			end

			local path = library.cheatname .. "/" .. library.gamename .. "/configs/" .. flags.configs_input .. ".txt"
			if isfile(path) then
				library:notification(
					("config '%s' already exists!"):format(flags.configs_input),
					5,
					color3_new(1, 0.35, 0.35)
				)
				return
			end

			xpcall(function()
				library:save_config(flags.configs_input, true)
				library:notification(
					("successfully created config '%s'"):format(flags.configs_input),
					5,
					color3_new(0.35, 1, 0.35)
				)
			end, function()
				library:notification(
					("unable to create config '%s'"):format(flags.configs_input),
					5,
					color3_new(1, 0.35, 0.35)
				)
			end)
		end,
	})

	settings_config:button({
		text = "save",
		confirm = true,
		callback = function()
			if not flags.configs_selected or flags.configs_selected:match("^%s*$") then
				library:notification("select a config before saving", 5, color3_new(1, 0.35, 0.35))
				return
			end

			local path = library.cheatname .. "/" .. library.gamename .. "/configs/" .. flags.configs_selected .. ".txt"
			if not isfile(path) then
				library:notification(
					("config '%s' does not exist!"):format(flags.configs_selected),
					5,
					color3_new(1, 0.35, 0.35)
				)
				return
			end

			xpcall(function()
				library:save_config(flags.configs_selected)
				library:notification(
					("successfully saved config '%s'"):format(flags.configs_selected),
					5,
					color3_new(0.35, 1, 0.35)
				)
			end, function(err)
				library:notification(
					err or ("unable to save config '%s'"):format(flags.configs_selected),
					5,
					color3_new(1, 0.35, 0.35)
				)
			end)
		end,
	})

	settings_config:button({
		text = "load",
		confirm = true,
		callback = function()
			xpcall(function()
				library:load_config(flags.configs_selected)
				library:notification(
					("successfully loaded config '%s'"):format(flags.configs_selected),
					5,
					color3_new(0.35, 1, 0.35)
				)
			end, function(err)
				library:notification(
					err or ("unable to load config '%s'"):format(flags.configs_selected),
					5,
					color3_new(1, 0.35, 0.35)
				)
			end)
		end,
	})

	settings_config:button({
		text = "delete",
		confirm = true,
		callback = function()
			xpcall(function()
				assert(flags.configs_selected ~= nil and flags.configs_selected ~= "", "No config selected")
				library:delete_config(flags.configs_selected)
			end, function(err)
				library:notification(
					err or ("unable to delete config '%s'"):format(flags.configs_selected),
					5,
					color3_new(1, 0.35, 0.35)
				)
			end)
		end,
	})

	settings_config:button({
		text = "set auto-load",
		confirm = true,
		callback = function()
			xpcall(function()
				writefile(library.cheatname .. "/" .. library.gamename .. "/auto_load.txt", flags.configs_selected)
				library:notification(
					("Auto-load config set to '%s'"):format(flags.configs_selected),
					5,
					color3_new(0.35, 1, 0.35)
				)
			end, function(err)
				library:notification(("Failed to set auto-load config: %s"):format(err), 5, color3_new(1, 0.35, 0.35))
			end)
		end,
	})

	settings_themes:colorpicker({
		text = "accent",
		flag = "theme_accent",
		default = library.themes.Default.Accent,
		callback = function(color)
			library.theme.Accent = color
			library:update_theme()
		end,
	})

	settings_themes:dropdown({
		text = "select theme",
		flag = "selected_theme",
		values = { "Default", "Tokyo Night", "Twitch", "Nekocheat", "Gamesense", "Onetap", "Fatality" },
		default = "Default",
	})

	settings_themes:button({
		text = "apply theme",
		confirm = true,
		callback = function()
			local selected_theme = flags.selected_theme
			if library.themes[selected_theme] then
				library:set_theme(selected_theme)
				library:notification(("applied theme: %s"):format(selected_theme), 5, color3_new(0.35, 1, 0.35))
			else
				library:notification("invalid theme selected", 5, color3_new(1, 0.35, 0.35))
			end
		end,
	})

	if isfolder(library.cheatname .. "/" .. library.gamename .. "/configs") then
		for i, v in next, listfiles(library.cheatname .. "/" .. library.gamename .. "/configs") do
			local ext = "." .. v:split(".")[#v:split(".")]
			if ext == ".txt" then
				options.configs_selected:add_value(v:split("\\")[#v:split("\\")]:sub(1, -#ext - 1))
			end
		end
	end

	task.spawn(function()
		local autoLoad = library.cheatname .. "/" .. library.gamename .. "/auto_load.txt"
		if isfile(autoLoad) then
			local config = readfile(autoLoad)
			if config and #config > 0 then
				library:load_config(config)
				library:notification(("Auto-loaded config '%s'"):format(config), 5, color3_new(0.35, 1, 0.35))
			end
		end
	end)

	return tab, settings_main
end

library.has_init = true
getgenv().library = library

return library
