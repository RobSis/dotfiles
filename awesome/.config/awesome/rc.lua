--[[ Hellricer's Awesome WM config

     Principles:
        * minimal
            - window manager should manage _windows_, not things like
              brightness & volume control (use xbindkeys), wallpapers (use feh/…)
              or launchers/menus (use rofi/…)
        * modular
            - extensions are kept in separate modules
        * mouse-free
            - while mouse is still supported, everything can be achieved through
              key bindings
        * easy-to-learn, learn-as-you-use & intuitive
            - despite the previous point, keep shortcuts meaningful and their number low

--]]

local capi = {
    awesome = awesome,
    screen  = screen,
    root    = root,
    client  = client,
}

--- Standard libraries
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")

--- Extensions
package.path = awful.util.getdir("config") .."/extensions/?.lua;"
            .. awful.util.getdir("config") .. "/extensions/?/init.lua;"
            .. package.path
local keydoc        = require("keydoc")
local handy         = require("handy")
local screenkey     = require("screenkey")
local hints         = require("hints")
local rofi          = require("rofi")
local tmuxlike      = require("tmuxlike")
local rodent        = require("rodent")

--- Variables
local modkey         = "Mod4"
local altkey         = "Mod1"
local theme          = "powerarrow-minimal"

local terminal       = "urxvtc"
local terminal_mux   = terminal .. " -e zsh -c tmux"
local gui_editor     = terminal .. " -e zsh -c vim"

--- Layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
}

--- Tags
local tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }

--- Auto-run
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        local findme = cmd
        local firstspace = cmd:find(" ")
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
run_once({"xbindkeys"})
run_once({"compton"})
run_once({"volnoti -t 2 -a 0.4 -r 0"})
run_once({"urxvtd"})
run_once({"redshift -l 49:16"})

awful.spawn("setxkbmap -option compose:ralt -option ctrl:nocaps")
awful.spawn("xset -b")

--- Load theme
beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), theme))
hints.init()

--- Init screens
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper()

    -- Tags
    awful.tag(tagnames, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(rodent.layoutbox_buttons)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, rodent.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, rodent.tasklist_buttons)

    -- Create primary wibox
    s.mywibox = awful.wibar {
        position = "top",
        screen = s,
        height = beautiful.menu_height,
        bg = beautiful.bg_normal,
        fg = beautiful.fg_normal
    }

    -- decorate widgets with arrows & alternating colors
    local left_sector = wibox.layout.fixed.horizontal()
    beautiful.decorate_left(left_sector,
        s.mylayoutbox,
        s.mytaglist)

    local right_sector = wibox.layout.fixed.horizontal()
    right_sector:add(wibox.widget.systray())
    beautiful.decorate_right(right_sector,
        beautiful.mem.widget,
        beautiful.cpu.widget,
        beautiful.temp.widget,
        beautiful.bat.widget,
        beautiful.clock)

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        left_sector,
        {
            layout = wibox.layout.fixed.horizontal,
            s.mytasklist,
        },
        right_sector
    }

    -- screenkey wibox
    screenkey.wibox:setup()

    -- custom mouse events
    beautiful.clock:buttons(awful.util.table.join(awful.button({ }, 1,
        function () handy(
            "urxvtc -e zsh -c 'gcalcli agenda; read'",
            awful.placement.top_right, 0.3, 0.7, {honor_workarea = true}
        )
        end
    )))
end)

--- Key bindings
local clientkeys = awful.util.table.join(
    keydoc.group("Client"),
    awful.key({ modkey }, "d", function (c) c:kill() end,
            "close client"),
    awful.key({ modkey }, "f", function (c) rofi.client_flags(c) end,
            "flags"),
    awful.key({ modkey }, "s", function (c) hints.swap(c) end,
            "swap")
)

local globalkeys = awful.util.table.join(
    -- Personal
    keydoc.group("Quick access"),
    awful.key({ modkey }, "Return", function () awful.spawn(terminal_mux) end,
            "run terminal"),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(terminal) end,
            "run terminal without tmux"),
    awful.key({ modkey }, "e", function () handy(gui_editor, awful.placement.bottom_left, 0.5, 0.4, {honor_workarea = true}) end,
            "toggle quick editor"),
    awful.key({ modkey }, "z", function () handy(terminal, awful.placement.bottom_right, 0.5, 0.4, {honor_workarea = true}) end,
            "toggle quick terminal"),
    awful.key({ modkey }, "b", function () screenkey.toggle() end,
            "show/hide screenkey"),

    keydoc.group("Awesome"),
    awful.key({ modkey }, "i", keydoc.display,
            "show help"),
    awful.key({ modkey, "Control" }, "r", capi.awesome.restart,
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
                      capi.client.focus = c
                      c:raise()
                  end
              end,
             "restore last minimized client"),

    -- Rofi
    awful.key({ modkey }, "r", rofi.prompt,
            "run prompt"),
    awful.key({ modkey }, "w", rofi.clients,
            "window selector"),

    -- Multi-head
    --awful.key({ modkey }, "Left", function () awful.screen.focus_relative(-1) end,
    --          { group = "screen", description = "focus the previous screen" }),
    --awful.key({ modkey }, "Right", function () awful.screen.focus_relative(1) end,
    --          { group = "screen", description = "focus the next screen" }),

    keydoc.group("Layout"),
    -- By-direction client focus
    awful.key({ modkey }, "h", function()
            awful.client.focus.bydirection("left")
            if capi.client.focus then capi.client.focus:raise() end
        end,
            "move focus left"),
    awful.key({ modkey }, "l", function()
            awful.client.focus.bydirection("right")
            if capi.client.focus then capi.client.focus:raise() end
        end,
            "move focus right"),
    awful.key({ modkey }, "j", function()
            awful.client.focus.bydirection("down")
            if capi.client.focus then capi.client.focus:raise() end
        end,
            "move focus down"),
    awful.key({ modkey }, "k", function()
            awful.client.focus.bydirection("up")
            if capi.client.focus then capi.client.focus:raise() end
        end,
            "move focus up"),

    -- By-direction client swapping
    awful.key({ modkey, "Shift" }, "h", function () awful.client.swap.bydirection("left") end,
            "swap with client on the left"),
    awful.key({ modkey, "Shift" }, "l", function () awful.client.swap.bydirection("right") end,
            "swap with client on the right"),
    awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.bydirection("down") end,
            "swap with client below"),
    awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.bydirection("up") end,
            "swap with client above"),

    -- tmuxlike client resizing
    awful.key({ modkey, altkey   }, "h", function () tmuxlike.resize_horizontal(0.05) end,
            "resize horizontally"),
    awful.key({ modkey, altkey   }, "l", function () tmuxlike.resize_horizontal(-0.05) end,
            "resize horizontally"),
    awful.key({ modkey, altkey   }, "j", function () tmuxlike.resize_vertical(0.05) end,
            "resize vertically"),
    awful.key({ modkey, altkey   }, "k", function () tmuxlike.resize_vertical(-0.05) end,
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
            if capi.client.focus then
                capi.client.focus:raise()
            end
        end,
            "go to previous client"),

    keydoc.group("Tags"),
    awful.key({ modkey }, "Escape", awful.tag.history.restore,
            "go to previous tag")
)

-- Bind number row to tags (zero included)
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
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if capi.client.focus then
                          local tag = capi.client.focus.screen.tags[i]
                          if tag then
                              capi.client.focus:move_to_tag(tag)
                              tag:view_only()
                          end
                     end
                  end,
            i == 1 and "move client to tag n" or nil),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local src = awful.screen.focused().selected_tag
                      local dest = awful.screen.focused().tags[i]
                      if not src or not dest then return end

                      local clients = src:clients()
                      for _, c in ipairs(clients) do
                          c:move_to_tag(dest)
                      end
                      dest:view_only()
                  end,
            i == 1 and "move all clients to tag n" or nil)
    )
end

capi.root.keys(globalkeys)

--- Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = rodent.clientbuttons(modkey),
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     titlebars_enabled = true,
                     size_hints_honor = false
      }
    },

    { rule = { class = "Spek" },
        properties = { floating = true,
                       raise = false }}
}

--- Signals
-- Signal function to execute when a new client appears.
capi.client.connect_signal("manage", function (c, startup)
    awful.client.setslave(c)

    -- Enable sloppy focus
    c:connect_signal("mouse::enter", rodent.enter_signal)

    if not startup and
        not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
capi.screen.connect_signal("property::geometry", set_wallpaper)

-- Disable border for maximized clients
capi.client.connect_signal("focus",
function(c)
    if c.maximized then
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end)

capi.client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

--- vim: foldexpr=getline(v\:lnum)=~'^---\\s'?'>1'\:'=' foldmethod=expr
