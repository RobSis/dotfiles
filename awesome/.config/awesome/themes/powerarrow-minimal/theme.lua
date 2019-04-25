-- awesome v4.0 powerarrow theme
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local theme                     = {}

theme.dir                       = os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-minimal"

theme.font                      = "DejaVu Sans 9"
theme.monofont                  = "DejaVuSansMono Nerd Font Mono 9"
theme.tasklist_shape            = gears.shape.powerline

-- {{{ minimalist
theme.fg_normal                 = "#999999"
theme.bg_normal                 = "#2b2b2bee"
theme.fg_focus                  = theme.fg_normal
theme.bg_focus                  = theme.bg_normal
theme.fg_urgent                 = "#FFAF5F"
theme.bg_urgent                 = theme.bg_normal
theme.bg_segment1               = "#1c1c1c"
theme.bg_segment2               = "#444444"
theme.taglist_fg_focus          = "#eeeeee"
theme.taglist_bg_empty          = theme.bg_segment1
theme.taglist_bg_focus          = theme.bg_segment1
theme.taglist_bg_occupied       = theme.bg_segment1
theme.taglist_bg_urgent         = theme.bg_segment1
theme.tasklist_bg_normal        = theme.bg_segment1
theme.tasklist_bg_focus         = theme.bg_segment2
theme.border_normal             = theme.bg_normal
theme.border_focus              = "#7F7F7F"
theme.border_marked             = "#CC9393"
-- }}}

-- {{{ solarized-light
-- theme.fg_normal                 = "#fdf6e3"
-- theme.bg_normal                 = "#fdf6e300"
-- theme.fg_focus                  = theme.fg_normal
-- theme.bg_focus                  = theme.bg_normal
-- theme.fg_urgent                 = "#FFAF5F"
-- theme.bg_urgent                 = theme.bg_normal
-- theme.bg_segment1               = "#556b73"
-- theme.bg_segment2               = "#93a1a1"
-- theme.taglist_bg_empty          = theme.bg_segment1
-- theme.taglist_bg_focus          = theme.bg_segment1
-- theme.taglist_bg_occupied       = theme.bg_segment1
-- theme.taglist_bg_urgent         = theme.bg_segment1
-- theme.taglist_fg_focus         = "#c59910"
-- theme.tasklist_bg_normal        = theme.bg_segment1
-- theme.tasklist_bg_focus         = theme.bg_segment2
-- theme.border_normal             = "#3F3F3F"
-- theme.border_focus              = "#7F7F7F"
-- theme.border_marked             = "#CC9393"
-- theme.notification_bg           = "#586e75aa"
-- theme.notification_border_width = 0
-- }}}

theme.menu_height               = 30
theme.useless_gap               = 0
theme.gap_single_client         = false
theme.border_width              = 1
theme.master_width_factor       = 0.6
theme.tasklist_plain_task_name  = true
theme.tasklist_disable_icon     = true

theme.taglist_squares_sel       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel     = theme.dir .. "/icons/square_unsel.png"

theme.layout_floating           = theme.dir .. "/icons/layouts/floating.png"
theme.layout_tile               = theme.dir .. "/icons/layouts/tile.png"
theme.layout_tileleft           = theme.dir .. "/icons/layouts/tileleft.png"
theme.layout_tilebottom         = theme.dir .. "/icons/layouts/tilebottom.png"
theme.layout_tiletop            = theme.dir .. "/icons/layouts/tiletop.png"
theme.layout_fairh              = theme.dir .. "/icons/layouts/fairh.png"
theme.layout_fairv              = theme.dir .. "/icons/layouts/fairv.png"
theme.layout_spiral             = theme.dir .. "/icons/layouts/spiral.png"
theme.layout_dwindle            = theme.dir .. "/icons/layouts/dwindle.png"
theme.layout_max                = theme.dir .. "/icons/layouts/max.png"
theme.layout_fullscreen         = theme.dir .. "/icons/layouts/fullscreen.png"
theme.layout_magnifier          = theme.dir .. "/icons/layouts/magnifier.png"
theme.layout_cornernw           = theme.dir .. "/icons/layouts/cornernw.png"
theme.layout_cornerne           = theme.dir .. "/icons/layouts/cornerne.png"
theme.layout_cornersw           = theme.dir .. "/icons/layouts/cornersw.png"
theme.layout_cornerse           = theme.dir .. "/icons/layouts/cornerse.png"


theme.widget_mem                = "  "
theme.widget_cpu                = "  "
theme.widget_temp               = "  "
theme.widget_battery_ac         = "  "
theme.widget_battery_full       = "  "
theme.widget_battery_low        = "  "
theme.widget_battery_empty      = "  "
theme.widget_clock              = "  "

-- {{{ Widgets
local markup = lain.util.markup
-- }}}

-- Textclock
theme.clock = awful.widget.watch(
    "date +'%a %d %b %R'", 15,
    function(widget, stdout)
        widget:set_markup(markup.font(theme.monofont, theme.widget_clock) ..
            markup.font(theme.font, stdout))
    end
)

-- MEM
theme.mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.monofont, theme.widget_mem) ..
            markup.font(theme.font, mem_now.used .. "MB "))
    end
})

-- CPU
theme.cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.monofont, theme.widget_cpu) ..
            markup.font(theme.font, cpu_now.usage .. "% "))
    end
})

-- Coretemp
theme.temp = lain.widget.temp({
    settings = function()
        local color = theme.fg_normal
        if coretemp_now > 70 then
           color = theme.fg_urgent
        end
        widget:set_markup(markup.font(theme.monofont, theme.widget_temp) ..
            markup.fontfg(theme.font, color, coretemp_now .. "°C "))
    end
})

-- Battery
theme.bat = lain.widget.bat({
    full_notify = "off",
    settings = function()
        if bat_now.status ~= "N/A" then
            local color = theme.fg_normal
            local icon = theme.widget_battery_full
            if bat_now.ac_status == 1 then
                widget:set_markup(markup.font(theme.monofont, theme.widget_battery_ac) ..
                    markup.font(theme.font, "AC "))
                return
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                color = theme.fg_urgent
                icon = theme.widget_battery_empty
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                color = theme.fg_urgent
                icon = theme.widget_battery_low
            end
            widget:set_markup(markup.font(theme.monofont, icon) ..
                markup.fontfg(theme.font, color, bat_now.perc .. "% "))
        else
            widget:set_markup(markup.font(theme.monofont, theme.widget_battery_ac) ..
                markup.font(theme.font, "AC "))
        end
    end
})

-- Separators
local separators = lain.util.separators
separators.width = 14

function theme.decorate_left(layout, ...)
    for i = 1, #arg do
        if (i - 1) % 2 == 0 then
            if i > 1 then
                layout:add(separators.arrow_right("alpha", theme.bg_segment2))
            end
            layout:add(wibox.container.background(arg[i], theme.bg_segment2))
            layout:add(separators.arrow_right(theme.bg_segment2, "alpha"))
        else
            layout:add(separators.arrow_right("alpha", theme.bg_segment1))
            layout:add(wibox.container.background(arg[i], theme.bg_segment1))
            layout:add(separators.arrow_right(theme.bg_segment1, "alpha"))
        end
    end
end

function theme.decorate_right(layout, ...)
    for i = 1, #arg do
        if (i - 1) % 2 == 0 then
            layout:add(separators.arrow_left("alpha", theme.bg_segment1))
            layout:add(wibox.container.background(arg[i], theme.bg_segment1))
            if i < #arg then
                layout:add(separators.arrow_left(theme.bg_segment1, "alpha"))
            end
        else
            layout:add(separators.arrow_left("alpha", theme.bg_segment2))
            layout:add(wibox.container.background(arg[i], theme.bg_segment2))
            if i < #arg then
                layout:add(separators.arrow_left(theme.bg_segment2, "alpha"))
            end
        end
    end
end

return theme
