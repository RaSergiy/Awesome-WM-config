-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]

theme = {}
theme.font          = "sans 8"

theme.bg_normal     = "#111111"
theme.fg_normal     = "#AAAAAA"
theme.bg_focus      = "#442222"
theme.fg_focus      = "#22FF22"
theme.bg_urgent     = "#ff0000"
theme.fg_urgent     = "#FF8866"
theme.bg_minimize   = "#444444"
theme.fg_minimize   = "#ffffff"

theme.border_width  = "1"
theme.border_normal = "#111111"
theme.border_focus  = "#779077"
theme.border_marked = "#FF0000"

theme.titlebar_bg_normal= "#000000"
theme.titlebar_fg_normal= "#777777"
theme.titlebar_bg_focus = "#000000"
theme.titlebar_fg_focus = "#88FFBB"

theme.taglist_bg_focus  = "#111111"
theme.taglist_fg_focus  = "#FF4400"
theme.taglist_bg_urgent = "#BB0000"
theme.taglist_fg_urgent = "#000000"

theme.tasklist_bg_focus = "#000000"
theme.tasklist_fg_focus = "#88FFBB"
theme.tasklist_bg_urgent= "#FF0000"
theme.tasklist_fg_urgent= "#FFFF00"

theme.menu_fg_normal    = "#AAAA00"
theme.menu_bg_normal    = "#112211"
theme.menu_fg_focus     = "#00ff00"
theme.menu_bg_focus     = "#442222"
theme.menu_border_color = "#444444"
theme.menu_border_width = 1
theme.menu_height       = 15
theme.menu_width        = 250

theme.awesome_icon                 = confdir .. "/is2.png"
theme.menu_submenu_icon            = confdir .. "/isu.png"
theme.titlebar_close_button_normal = confdir .. "/icl.png"
theme.titlebar_close_button_focus  = confdir .. "/ica.png"
theme.tasklist_floating_icon       = confdir .. "/itf.png"
theme.layout_floating              = confdir .. "/is1.png"
theme.layout_max                   = confdir .. "/ilm.png"
theme.layout_tile                  = confdir .. "/ilt.png"
theme.layout_tilebottom            = confdir .. "/ilb.png"

return theme
