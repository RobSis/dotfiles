local awful = require("awful")

tmuxlike = {}

function tmuxlike.resize_horizontal(factor)
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

function tmuxlike.resize_vertical(factor)
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

return tmuxlike
