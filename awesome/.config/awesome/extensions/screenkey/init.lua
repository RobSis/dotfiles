--[[
    screenkey - Awesome WM module for wrapping screenkey in wibox
                to avoid overlapping of workarea

    Usage:
    screenkey = require("screenkey")

    register in connect_for_each_screen function:
        screenkey.wibox:setup()

    bind to key:
        awful.key({ modkey }, "s", function () screenkey.toggle() end)
--]]

local awful = require("awful")

-- wibox properties
local wibox = awful.wibar({
    screen = s,
    height = 80,
    position = "bottom",
    visible = false
})

local function toggle()
    local s = awful.screen.focused()
    wibox.visible = not wibox.visible

    if wibox.visible then
        awful.spawn(string.format("/home/rsiska/.local/bin/screenkey --geometry %dx%d+%d+%d --opacity 0 --no-systray",
            wibox.width, wibox.height, wibox.x, wibox.y))
    else
        awful.spawn("pkill -f screenkey")
    end
end

return {
    wibox = wibox,
    toggle = toggle
}
