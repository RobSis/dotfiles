-- awesome v4.0 config
-- Standard libraries
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local lain          = require("lain")
-- Extensions
local keydoc        = require("keydoc")
local handy         = require("handy")
local screenkey     = require("screenkey")

-- Variables
local modkey         = "Mod4"
local altkey         = "Mod1"
local theme          = "powerarrow-minimal"

local terminal       = "urxvtc -g 132x32+400+300"
local terminal_mux   = terminal .. " -e zsh -c tmux"
local editor         = "vim"
local gui_editor     = terminal .. " -e zsh -c vim"
local browser        = "google-chrome"
local volume_control = "pavucontrol"

-- Layouts
awful.layout.layouts = {
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile,
    awful.layout.suit.tile.top,
}

-- Tags
local tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }

-- Auto-run
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then
            findme = cmd:sub(0, firstspace-1)
        end
        awful.spawn.with_shell(string.format("pgrep -u $USER -x %s > /dev/null || (%s)", findme, cmd))
    end
end

local set_wallpaper = function()
    awful.spawn(string.format("feh --randomize --bg-fill %s/Pictures/wallpapers", os.getenv("HOME")))
end

run_once({"unclutter -root"})
run_once({"compton"})
run_once({"urxvtd"})
run_once({"redshift -l 49:16"})

awful.spawn("setxkbmap -option compose:ralt -option ctrl:nocaps")
awful.spawn("xset -b")

-- Mouse bindings
local taglist_buttons = awful.util.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),

    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),

    awful.button({ }, 3, awful.tag.viewtoggle),

    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end)
)

local tasklist_buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            client.focus = c
            c:raise()
        end
    end)
)

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

-- Load theme
beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), theme))

-- Init UI
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper()

    -- Tags
    awful.tag(tagnames, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end)))

    -- attach mouse events to widgets
    beautiful.clock:buttons(awful.util.table.join(awful.button({ }, 1,
        function () handy("urxvtc -e zsh -c 'gcalcli agenda; read'", awful.placement.top_right, 0.3, 0.7, {honor_workarea = true}) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create primary wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = beautiful.menu_height, bg = beautiful.bg_normal, fg = beautiful.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
                wibox.container.background(s.mylayoutbox, beautiful.bg_normal_light),
                beautiful.arrr_dl,
            s.mytaglist,
            s.mypromptbox,
                beautiful.spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
                beautiful.arrl_ld,
            wibox.container.background(beautiful.vol_icon, beautiful.bg_normal_light),
            wibox.container.background(beautiful.vol.widget, beautiful.bg_normal_light),
                beautiful.arrl_dl,
            beautiful.mem_icon,
            beautiful.mem.widget,
                beautiful.arrl_ld,
            wibox.container.background(beautiful.cpu_icon, beautiful.bg_normal_light),
            wibox.container.background(beautiful.cpu.widget, beautiful.bg_normal_light),
                beautiful.arrl_dl,
            beautiful.temp_icon,
            beautiful.temp.widget,
                beautiful.arrl_ld,
            wibox.container.background(beautiful.bat_icon, beautiful.bg_normal_light),
            wibox.container.background(beautiful.bat.widget, beautiful.bg_normal_light),
                beautiful.arrl_dl,
            beautiful.clock,
        },
    }

    -- screenkey wibox
    screenkey.wibox:setup()
end)

-- Helper functions for sane(er) keyboard resizing in tiling layouts
local function resize_horizontal(factor)
    local pos = awful.client.idx()
    local layout = awful.layout.get(awful.screen.focused())
    local right_top = layout == awful.layout.suit.tile or layout == awful.layout.suit.top
    if layout == awful.layout.suit.tile then
        awful.tag.incmwfact(-factor)
    elseif layout == awful.layout.suit.tile.left then
        awful.tag.incmwfact(factor)
    elseif layout == awful.layout.suit.tile.top or layout == awful.layout.suit.tile.bottom then
        awful.client.incwfact((pos.idx % pos.num == 0 and 1 or -1) * (right_top and -1 or 1) * factor)
    end
end

local function resize_vertical(factor)
    local pos = awful.client.idx()
    local layout = awful.layout.get(awful.screen.focused())
    local right_top = layout == awful.layout.suit.tile or layout == awful.layout.suit.top
    if layout == awful.layout.suit.tile then
        awful.client.incwfact((pos.idx % pos.num == 0 and 1 or -1) * (right_top and -1 or 1) * factor)
    elseif layout == awful.layout.suit.tile.left then
        awful.client.incwfact((pos.idx % pos.num == 0 and 1 or -1) * (right_top and 1 or -1) * factor)
    elseif layout == awful.layout.suit.tile.top then
        awful.tag.incmwfact(-factor)
    elseif layout == awful.layout.suit.tile.bottom then
        awful.tag.incmwfact(factor)
    end
end

-- Key bindings
clientkeys = awful.util.table.join(
    keydoc.group("Client"),
    awful.key({ modkey, "Shift" }, "c", function (c) c:kill() end,
            "close"),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle,
            "toggle floating"),
    awful.key({ modkey }, "s", function (c) c.sticky = not c.sticky end,
            "toggle sticky flag"),
    awful.key({ modkey }, "t", function (c) c.ontop = not c.ontop end,
            "toggle keep on top"),

    awful.key({ modkey }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
            "minimize"),

    awful.key({ modkey }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end,
            "maximize"),

    awful.key({ modkey }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
            "fullscreen")
)

globalkeys = awful.util.table.join(

    -- Personal
    keydoc.group("Personal"),
    awful.key({ modkey }, "Return", function () awful.spawn(terminal_mux) end,
            "run terminal"),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(terminal) end,
            "run terminal without tmux"),
    awful.key({ modkey }, "q", function () awful.spawn(browser) end,
            "run browser" ),
    awful.key({ modkey }, "e", function () handy(gui_editor, awful.placement.bottom_right, 0.5, 0.4, {honor_workarea = true}) end,
            "toggle quick editor"),
    awful.key({ modkey }, "z", function () handy(terminal, awful.placement.bottom_left, 0.5, 0.4, {honor_workarea = true}) end,
            "toggle quick terminal"),
    awful.key({ modkey }, "b", function () screenkey.toggle() end,
            "show/hide screenkey"),

    -- General
    keydoc.group("Awesome"),
    awful.key({ modkey }, "i", keydoc.display,
            "show help"),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
            "restart awesome"),
    awful.key({ modkey, "Control" }, "q", function () awful.spawn("pkill gnome-session") end,
            "quit awesome"),
    awful.key({ modkey }, "space", function () awful.layout.inc(1) end,
            "next layout"),
    awful.key({ modkey, "Shift" }, "space", function () awful.layout.inc(-1) end,
            "previous layout"),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
             "restore last minimized client"),
    --awful.key({ modkey }, "r", function () awful.screen.focused().mypromptbox:run() end,
    --     "run prompt"),

    -- Rofi
    awful.key({ modkey }, "r", function () run_once({"rofi -show run"}) end,
            "run prompt (rofi)"),
    awful.key({ modkey }, "w", function () run_once({"rofi -show window"}) end,
            "window selector (rofi)"),

    -- Multi-head
    --awful.key({ modkey }, "Left", function () awful.screen.focus_relative(-1) end,
    --          { group = "screen", description = "focus the previous screen" }),
    --awful.key({ modkey }, "Right", function () awful.screen.focus_relative(1) end,
    --          { group = "screen", description = "focus the next screen" }),

    keydoc.group("Layout"),
    -- By-direction client focus
    awful.key({ modkey }, "h", function()
            awful.client.focus.bydirection("left")
            if client.focus then client.focus:raise() end
        end,
            "move focus left"),
    awful.key({ modkey }, "l", function()
            awful.client.focus.bydirection("right")
            if client.focus then client.focus:raise() end
        end,
            "move focus right"),
    awful.key({ modkey }, "j", function()
            awful.client.focus.bydirection("down")
            if client.focus then client.focus:raise() end
        end,
            "move focus down"),
    awful.key({ modkey }, "k", function()
            awful.client.focus.bydirection("up")
            if client.focus then client.focus:raise() end
        end,
            "move focus up"),

    -- By-direction client swapping
    awful.key({ modkey, "Shift" }, "h", function () awful.client.swap.bydirection("left", c) end,
            "swap with client on the left"),
    awful.key({ modkey, "Shift" }, "l", function () awful.client.swap.bydirection("right", c) end,
            "swap with client on the right"),
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.bydirection("down", c) end,
            "swap with client below"),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.bydirection("up", c) end,
            "swap with client above"),
    awful.key({ modkey, "Shift" }, "p", function () awful.client.swap.byidx(-1, c) end,
            "swap with previous client"),
    awful.key({ modkey, "Shift" }, "n", function () awful.client.swap.byidx(1, c) end,
            "swap with next client"),

    -- By-direction client resizing
    awful.key({ modkey, altkey   }, "h", function () resize_horizontal(0.05) end,
            "resize horizontally"),
    awful.key({ modkey, altkey   }, "l", function () resize_horizontal(-0.05) end,
            "resize horizontally"),
    awful.key({ modkey, altkey   }, "j", function () resize_vertical(0.05) end,
            "resize vertically"),
    awful.key({ modkey, altkey   }, "k", function () resize_vertical(-0.05) end,
            "resize vertically"),

    -- Layout configuration
    -- TODO: hjkl doesn't really make sense here..
    awful.key({ modkey, "Control" }, "h", function () awful.tag.incnmaster(-1, nil, true) end,
            "decrease the number of master clients"),
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incnmaster( 1, nil, true) end,
            "increase the number of master clients"),
    awful.key({ modkey, "Control" }, "j", function () awful.tag.incncol(-1, nil, true) end,
            "decrease the number of slave columns/rows"),
    awful.key({ modkey, "Control" }, "k", function () awful.tag.incncol( 1, nil, true) end,
            "increase the number of slave columns/rows"),
    awful.key({ modkey }, "Tab", function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
            "go to previous client"),

    -- FIXME: maybe this shouldn't be managed by WM...
    -- ALSA volume control
    awful.key({}, "#123",
        function ()
            os.execute(string.format("amixer -q set %s 5%%+", beautiful.vol.channel))
            beautiful.vol.update()
        end),
    awful.key({}, "#122",
        function ()
            os.execute(string.format("amixer -q set %s 5%%-", beautiful.vol.channel))
            beautiful.vol.update()
        end),
    awful.key({}, "#121",
        function ()
            os.execute(string.format("amixer -q set %s toggle", beautiful.vol.togglechannel or beautiful.vol.channel))
            beautiful.vol.update()
        end),

    -- Brightness control
    awful.key({}, "#232",
        function ()
            os.execute("~/.local/bin/brightness dec 100")
        end),
    awful.key({}, "#233",
        function ()
            os.execute("~/.local/bin/brightness inc 100")
        end),

    keydoc.group("Tags"),
    awful.key({ modkey }, "Escape", awful.tag.history.restore,
            "go to previous tag")
)

-- Bind number row to tags.
for i = 1, 10 do
    globalkeys = awful.util.table.join(globalkeys,
        keydoc.group("Tags"),
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
            i == 1 and "view tag n" or nil),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
            i == 1 and "toggle tag n" or nil),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                              tag:view_only()
                          end
                     end
                  end,
            i == 1 and "move client to tag n" or nil),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
            i == 1 and "toggle client on tag n" or nil)
    )
end

root.keys(globalkeys)

-- Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     titlebards_enabled = false,
                     size_hints_honor = false
      }
    },

    { rule = { class = "Spek" },
        properties = { floating = true,
                       raise = false }},

    { rule = { class = "Pavucontrol" },
        properties = { floating = true } },

    { rule = { class = "zoom" },
        properties = { floating = true } },

    { rule = { class = "Nicotine" },
        properties = { tag = "0" } }
}

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    awful.client.setslave(c)

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Disable border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized then
            c.border_width = 0
        elseif #awful.screen.focused().clients > 1 then
            c.border_width = beautiful.border_width
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
