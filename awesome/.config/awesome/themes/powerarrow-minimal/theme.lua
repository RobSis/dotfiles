-- awesome v4.0 dark powerarrow
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local os    = { getenv = os.getenv }

local theme                     = {}
theme.dir                       = os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-minimal"
theme.font                      = "DejaVu Sans 9"
theme.monofont                  = "DejaVu Sans Mono 8"
theme.fg_normal                 = "#999999"
theme.fg_focus                  = "#dddddd"
theme.fg_urgent                 = "#FFAF5F"
theme.bg_normal                 = "#1A1A1A"
theme.bg_normal_light           = "#444444"
theme.bg_focus                  = "#1A1A1A"
theme.bg_urgent                 = "#1A1A1A"
theme.menu_height               = 28
theme.useless_gap               = 0
theme.gap_single_client         = false
theme.border_width              = 1
theme.master_width_factor       = 0.6
theme.border_normal             = "#3F3F3F"
theme.border_focus              = "#7F7F7F"
theme.border_marked             = "#CC9393"
theme.tasklist_bg_focus         = "#1A1A1A"
theme.taglist_fg_focus          = "#DDDDDD"
theme.taglist_bg_focus          = "#1A1A1A"
theme.taglist_squares_sel       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile               = theme.dir .. "/icons/tile.png"
theme.layout_tileleft           = theme.dir .. "/icons/tileleft.png"
theme.layout_tilebottom         = theme.dir .. "/icons/tilebottom.png"
theme.layout_tiletop            = theme.dir .. "/icons/tiletop.png"
theme.layout_fairv              = theme.dir .. "/icons/fairv.png"
theme.layout_fairh              = theme.dir .. "/icons/fairh.png"
theme.layout_spiral             = theme.dir .. "/icons/spiral.png"
theme.layout_dwindle            = theme.dir .. "/icons/dwindle.png"
theme.layout_max                = theme.dir .. "/icons/max.png"
theme.layout_fullscreen         = theme.dir .. "/icons/fullscreen.png"
theme.layout_magnifier          = theme.dir .. "/icons/magnifier.png"
theme.layout_floating           = theme.dir .. "/icons/floating.png"
theme.widget_ac                 = theme.dir .. "/icons/ac.png"
theme.widget_battery            = theme.dir .. "/icons/battery.png"
theme.widget_battery_low        = theme.dir .. "/icons/battery_low.png"
theme.widget_battery_empty      = theme.dir .. "/icons/battery_empty.png"
theme.widget_mem                = theme.dir .. "/icons/mem.png"
theme.widget_cpu                = theme.dir .. "/icons/cpu.png"
theme.widget_temp               = theme.dir .. "/icons/temp.png"
theme.widget_vol                = theme.dir .. "/icons/vol.png"
theme.widget_vol_low            = theme.dir .. "/icons/vol_low.png"
theme.widget_vol_no             = theme.dir .. "/icons/vol_no.png"
theme.widget_vol_mute           = theme.dir .. "/icons/vol_mute.png"
theme.tasklist_plain_task_name  = true
theme.tasklist_disable_icon     = true

local markup = lain.util.markup

-- Separators
local separators = lain.util.separators
theme.spr     = wibox.widget.textbox(' ')
theme.arrl_dl = separators.arrow_left(theme.bg_normal_light, "alpha")
theme.arrl_ld = separators.arrow_left("alpha", theme.bg_normal_light)
theme.arrr_dl = separators.arrow_right(theme.bg_normal_light, "alpha")
theme.arrr_ld = separators.arrow_right("alpha", theme.bg_normal_light)

-- Textclock
theme.clock = awful.widget.watch(
    "date +'%a %d %b %R'", 15,
    function(widget, stdout)
        widget:set_markup(" " .. markup.font(theme.font, stdout))
    end
)

-- MEM
theme.mem_icon = wibox.widget.imagebox(theme.widget_mem)
theme.mem = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. mem_now.used .. "MB "))
    end
})

-- CPU
theme.cpu_icon = wibox.widget.imagebox(theme.widget_cpu)
theme.cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.font(theme.font, " " .. cpu_now.usage .. "% "))
    end
})

-- Coretemp
theme.temp_icon = wibox.widget.imagebox(theme.widget_temp)
theme.temp = lain.widget.temp({
    settings = function()
        local color = theme.fg_normal
        if coretemp_now > 70 then
           color = theme.fg_urgent
        end
        widget:set_markup(markup.fontfg(theme.font, color, " " .. coretemp_now .. "°C "))
    end
})

-- Battery
theme.bat_icon = wibox.widget.imagebox(theme.widget_battery)
theme.bat = lain.widget.bat({
    full_notify = "off",
    settings = function()
        if bat_now.status ~= "N/A" then
            local color = theme.fg_normal
            if bat_now.ac_status == 1 then
                widget:set_markup(markup.font(theme.font, " AC "))
                theme.bat_icon:set_image(theme.widget_ac)
                return
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 5 then
                theme.bat_icon:set_image(theme.widget_battery_empty)
                color = theme.fg_urgent
            elseif not bat_now.perc and tonumber(bat_now.perc) <= 15 then
                color = theme.fg_urgent
                theme.bat_icon:set_image(theme.widget_battery_low)
            else
                theme.bat_icon:set_image(theme.widget_battery)
            end
            widget:set_markup(markup.fontfg(theme.font, color, " " .. bat_now.perc .. "% "))
        else
            widget:set_markup(markup.font(theme.font, " AC "))
            theme.bat_icon:set_image(theme.widget_ac)
        end
    end
})

-- ALSA volume
theme.vol_icon = wibox.widget.imagebox(theme.widget_vol)
theme.vol_icon:buttons(awful.util.table.join(
    awful.button({ }, 1, function ()
        awful.spawn(awful.util.volume_control)
    end)))
theme.vol = lain.widget.alsa({
    settings = function()
        if volume_now.status == "off" then
            theme.vol_icon:set_image(theme.widget_vol_mute)
        elseif tonumber(volume_now.level) == 0 then
            theme.vol_icon:set_image(theme.widget_vol_no)
        elseif tonumber(volume_now.level) <= 50 then
            theme.vol_icon:set_image(theme.widget_vol_low)
        else
            theme.vol_icon:set_image(theme.widget_vol)
        end

        widget:set_markup(markup.font(theme.font, " " .. volume_now.level .. "% "))
        widget:buttons(awful.util.table.join(
            awful.button({ }, 1, function ()
                awful.spawn(awful.util.volume_control)
            end)))
    end
})

-- TODO: cmus widget
theme.cmus, cmus_timer = awful.widget.watch(
    "cmus-remote -Q",
    2,
    function(widget, stdout)
        local cmus_now = {
            status   = "N/A",
            artist  = "N/A",
            title   = "N/A",
            album   = "N/A"
        }

        for w in string.gmatch(stdout, "(.-)tag") do
            a, b = w:match("(%w+) (.-)\n")
            cmus_now[a] = b
        end

        widget:set_text(cmus_now.artist .. " - " .. cmus_now.title)
    end
)

return theme
