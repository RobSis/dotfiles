--[[
    rodent.lua - keeping mouse bindings in separate module
--]]
local awful = require("awful")

local rodent = {
    taglist_buttons = awful.util.table.join(
        awful.button({ }, 1, function(t) t:view_only() end)
    ),

    tasklist_buttons = awful.util.table.join(
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
    ),

    layoutbox_buttons = awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc( 1) end),
        awful.button({ }, 3, function () awful.layout.inc(-1) end)
    ),

    clientbuttons = function(modkey)
        return awful.util.table.join(
            awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
            awful.button({ modkey }, 1, awful.mouse.client.move),
            awful.button({ modkey }, 3, awful.mouse.client.resize)
        )
    end,

    enter_signal = function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end
}

return rodent
