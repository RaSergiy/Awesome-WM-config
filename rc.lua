
require("awful")
require("awful.autofocus")
require("awful.rules")
require("awful.remote")
require("beautiful")
require("menu")
-- require("vpl")
require("naughty")



os.execute ("xsetroot -solid '#000000' &")
os.execute ("if [[ -z `pidof urxvtd` ]]; then; urxvtd -q -f -o; fi &")
-- os.execute ("sudo nm-applet &")
-- os.execute ("deluge-gtk &")
-- os.execute ("pidgin &")


terminal   = "urxvtc"
terminalex = "urxvtc -e screen -U"
terminalbig = "urxvtc -font '-*-terminus-medium-r-normal-*-24-*-*-*-*-*-iso10646-*' -e screen -U"
modkey     = "Mod4"

homedir = os.getenv('HOME')
confdir = homedir .. "/.config/awesome"

layouts = {
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max }

beautiful.init ( confdir .. "/theme.lua" )


vol_up='5%+'
vol_dn='5%-'
vol_proto='amixer set %s "%s" | tr "\\n" "-" | sed --silent \'s/.*\\(\\[[0-9]*%%\\]\\).*\\(\\[[0-9]*%%\\]\\).*/%s: \\1 \\2\\n/gp\' | dzen2 -p 2 -x 412 -w 200 -sa c &'
vol_pcm_up=string.format(vol_proto, 'PCM', vol_up, 'PCM')
vol_pcm_dn=string.format(vol_proto, 'PCM', vol_dn, 'PCM')
vol_master_up=string.format(vol_proto, 'Master', vol_up, 'MASTER')
vol_master_dn=string.format(vol_proto, 'Master', vol_dn, 'MASTER')


---------------------------------------

function execo(command)
   local fh = io.popen(command)
   local str = ""
   for i in fh:lines() do
      str = str .. i
   end
   io.close(fh)
   return str
end


function setstatus()
	textbox_ppp.text = execo ('echo -n `mpc --format "[%file%]" | tr "\\n" "^" | sed --silent \'s/.*\\/\\(.*\\)^.*#\\([0-9]*\\/[0-9]*\\)\\s*\\(.*\\)\\s(.*/\\2: \\3: \\1 |/p\'`; echo " `/sbin/ifconfig ppp0 | sed \'s/.*bytes:\\([0-9]*\\) (\\([0-9.]*\\) \\(.\\).*bytes:\\([0-9]*\\) (\\([0-9.]*\\) \\(.\\).*/N:\\1-\\2\\3\\/\\4-\\5\\6   /p\' --silent`"; ~/.config/awesome/powerm.rb')
--	textbox_ppp.text = execo ('echo -n `mpc --format "[%file%]" | tr "\\n" "^" | sed --silent \'s/.*\\/\\(.*\\)^.*#\\([0-9]*\\/[0-9]*\\)\\s*\\(.*\\)\\s(.*/\\2: \\3: \\1 |/p\'`; echo " `/sbin/ifconfig ppp0 | sed \'s/.*bytes:\\([0-9]*\\) (\\([0-9.]*\\) \\(.\\).*bytes:\\([0-9]*\\) (\\([0-9.]*\\) \\(.\\).*/N:\\1-\\2\\3\\/\\4-\\5\\6   /p\' --silent`"; echo " `acpi`" | sed \'s/Battery 0: \\([a-zA-Z]*\\), \\([0-9]*%\\)/B:\\2\\1/; s/Charging/↑/; s/Discharging/↓/; s/, //g; s/z*[a-z A-Z]*$/ /\'')
--	textbox_ppp.text = execo ('echo -n `mpc --format "[%file%]" | tr "\\n" "^" | sed --silent \'s/.*\\/\\(.*\\)^.*#\\([1-9]*\\/[0-9]*\\)\\s*\\(.*\\)\\s(.*/\\2: \\3: \\1 |/p\'`; echo " `acpi`" | sed \'s/Battery 0: \\([a-zA-Z]*\\), \\([0-9]*%\\)/B:\\2\\1/; s/Charging/↑/; s/Discharging/↓/; s/, //g; s/z*[a-z A-Z]*$/ /\'')
end


function run_or_raise(cmd, properties)
   local clients = client.get()
   local focused = awful.client.next(0)
   local findex = 0
   local matched_clients = {}
   local n = 0
   for i, c in pairs(clients) do
      if match(properties, c) then
         n = n + 1
         matched_clients[n] = c
         if c == focused then
            findex = n
         end
      end
   end
   if n > 0 then
      local c = matched_clients[1]
      if 0 < findex and findex < n then
         c = matched_clients[findex+1]
      end
      local ctags = c:tags()
      if table.getn(ctags) == 0 then
         local curtag = awful.tag.selected()
         awful.client.movetotag(curtag, c)
      else
         awful.tag.viewonly(ctags[1])
      end
      client.focus = c
      c:raise()
      return
   end
   awful.util.spawn(cmd)
end

function match (table1, table2)
   for k, v in pairs(table1) do
      if table2[k] ~= v and not table2[k]:find(v) then
         return false
      end
   end
   return true
end

----------------------------------------

tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 0 }, s, layouts[1])
end


-- menu_awesome = { 
--  { "menu reload", function()
--    ret=os.execute("vpl --awesome")
--    naughty.notify({text=string.format("%d", ret) , timeout=10 })
--  end },
--	{ "restart", awesome.restart },
--	{ "quit", awesome.quit } }
--

-- menu_mpd = { 
--	{ "play", function () execo ("mpc toggle") end},
--	{ "stop", function () execo ("mpc stop") end} } 
menu_main = awful.menu({ items = { 
  { "ALT", menu.alt_menu },
--  { "VPL", vpl.mediafiles },
--  { "MPD", menu_mpd },
  { "Terminal", terminalex },
  { "Sys: shutdown", function () naughty.notify({text=execo("sudo halt"), timeout=10 }) end },
  { "Sys: reboot", function () naughty.notify({text=execo("sudo init 6"), timeout=10 }) end },
--  { "A: reload", function()
--    catfile =  homedir.."/tmp/vplawesomeaout"
--    ret=os.execute("vpl --awesome > "..catfile)
--    if ret==0 then
--	    awesome.restart()
--    else
--	    naughty.notify({title=string.format("VPL menu regeneration failed with code: %d", ret) , timeout=10 })
--    end
--  end },
	{ "Awes: restart", awesome.restart },
	{ "Awes: quit", awesome.quit } 
} })


menu_launcher = awful.widget.launcher({ image = image(beautiful.awesome_icon), menu = menu_main })


textbox_ppp = widget({ type = "textbox", name = "tb_ppp0" })
textbox_ppp.text = ''
mytimer = timer({ timeout = 1 })
mytimer:add_signal("timeout", setstatus)
mytimer:start()


mytextclock = awful.widget.textclock({ align = "right" }, " %Y.%m.%d.%u   %H:%M ")
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
 mytasklist = {}
 mytasklist.buttons = awful.util.table.join(
                      awful.button({ }, 1, function (c)
                                               if not c:isvisible() then
                                                   awful.tag.viewonly(c:tags()[1])
                                               end
                                               client.focus = c
                                               c:raise()
                                           end),
                      awful.button({ }, 3, function ()
                                               if instance then
                                                   instance:hide()
                                                   instance = nil
                                               else
                                                   instance = awful.menu.clients({ width=250 })
                                               end
                                           end),
                      awful.button({ }, 4, function ()
                                               awful.client.focus.byidx(1)
                                               if client.focus then client.focus:raise() end
                                           end),
                      awful.button({ }, 5, function ()
                                               awful.client.focus.byidx(-1)
                                               if client.focus then client.focus:raise() end
                                           end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget & remove unused tags
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.noempty, mytaglist.buttons)

    -- Create a tasklist widget.
   mytasklist[s] = awful.widget.tasklist(function(c) return awful.widget.tasklist.label.currenttags(c, s) end, mytasklist.buttons )


    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {   menu_launcher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        mytextclock,
        s == 1 and mysystray or nil,
	textbox_ppp,
	mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () menu_main:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(

    awful.key({ modkey,           }, "Up",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "Down",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    awful.key({ modkey,           }, "a", function () menu_main:show(true)        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j",    function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "Up",   function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k",    function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Shift"   }, "Down", function () awful.client.swap.byidx( -1)    end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminalex) end),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "Return", function () awful.util.spawn(terminalbig) end),

    awful.key({ modkey, "Control" }, "r", awesome.restart),


    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey,           }, "Right", function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "Left",  function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey, "Control" }, "space", function () awful.layout.inc(layouts, 1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, 1) end),


--    awful.key({ modkey },            "\\",    function () os.execute( "killall xulrunner &") end),
--    awful.key({ modkey },            "|",     function () os.execute( "killall xulrunner &") end),

    awful.key({ modkey },            "p",     function () os.execute( confdir .. "/proglist") end),
    awful.key({ modkey },            "[",     function () os.execute( confdir .. "/mntumnt &") end),
    awful.key({ modkey },            "]",     function () os.execute( confdir .. "/mntumnt --umount &") end),
--    awful.key({ modkey,           }, "t",     function () run_or_raise( homedir.."/.toonel/run", { class = "guiswing-ClientForm" } ) end),
				-- #2
    awful.key({ modkey,           }, "f",     function () run_or_raise( "firefox", { class = "Firefox" } ) end),
				-- #3
    awful.key({ modkey,           }, "i",     function () run_or_raise( "pidgin", { class = "Pidgin" } ) end),
    				-- #4
    awful.key({ modkey,           }, "b",     function () run_or_raise( "wine 'C:\\soft\\bq\\bq5.exe'", { instance = "bq5.exe" } ) end),
    awful.key({ modkey,           }, "u",     function () run_or_raise( "wine 'C:\\soft\\buzz\\buzz.exe'", { instance = "buzz.exe" } ) end),
    				-- #9
    awful.key({ modkey,           }, "y",     function () run_or_raise( "sudo synaptic", { class = "Synaptic" } ) end),
    awful.key({ modkey,           }, "t",     function () run_or_raise( "deluge", { class="Deluge"} ) end),
    awful.key({ modkey,           }, "s",     function () os.execute( "stardict-gtk &") end),
    awful.key({ },                   "Print", function () os.execute( "import -window root ~/screenshot-`date +%Y%m%d-%H%M%S`.png &") end),
    awful.key({ modkey },            "m",     function () os.execute( terminal .. " -e alsamixer &") end),
    awful.key({ modkey },            "d",     function () os.execute( terminal .. " -e ncmpc &") end),

    awful.key({ modkey },            "c",     function () os.execute( "mpc toggle &") end),
    awful.key({ modkey, "Shift" },   "c",     function () os.execute( "mpc stop &") end),
    awful.key({ modkey },            "z",     function () os.execute( "mpc prev &") end),
    awful.key({ modkey },            "x",     function () os.execute( "mpc next &") end),
    awful.key({ modkey, "Shift" },   "z",     function () os.execute( "mpc seek -00:00:10 &") end),
    awful.key({ modkey, "Control" }, "z",     function () os.execute( "mpc seek -00:01:00 &") end),
    awful.key({ modkey, "Shift" },   "x",     function () os.execute( "mpc seek +00:00:10 &") end),
    awful.key({ modkey, "Control" }, "x",     function () os.execute( "mpc seek +00:01:00 &") end),

    awful.key({ },     "XF86AudioRaiseVolume",function () os.execute(vol_pcm_up) end),
    awful.key({ },     "XF86AudioLowerVolume",function () os.execute(vol_pcm_dn) end),
    awful.key({modkey},"XF86AudioRaiseVolume",function () os.execute(vol_master_up) end),
    awful.key({modkey},"XF86AudioLowerVolume",function () os.execute(vol_master_dn) end),

--    awful.key({ },        "XF86PowerOff",     function () os.execute( "halt &" ) end),
    awful.key({ },        "XF86AudioPlay",    function () os.execute( "mpc toggle &" ) end),
    awful.key({ "Shift" },"XF86AudioPlay",    function () os.execute( "mpc stop &" ) end),
    awful.key({ modkey }, "XF86AudioPlay",    function () awful.util.spawn(terminal..' -e ncmpc') end),


    awful.key({ modkey, "Control" }, "i",
    function (c)
    local class = ""
    local name = ""
    local instance = ""

    if client.focus.class then
        class = client.focus.class
    end
    if client.focus.name then
        name = client.focus.name
    end
    if client.focus.instance then
        instance = client.focus.instance
    end

  naughty.notify({
    text="c: " .. class .. " i: " .. instance,
    title=name,
    timeout=10 })

       end),


    awful.key({ modkey }, "r",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
--    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
--    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey, "Control" }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey            }, "q",      function (c) c:kill()                         end),
    awful.key({ modkey            }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(10, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 10 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

root.keys(globalkeys)


awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
     { rule = { class = "Vlc" },
       properties = { floating = true } },
     { rule = { class = "MPlayer" },
       properties = { floating = true } },
     { rule = { class = "Firefox" },
       properties = { tag = tags[1][2] } },
     { rule = { class = "Pidgin" },
       properties = { tag = tags[1][3] } },
     { rule = { class = "Wine" },
       properties = { tag = tags[1][4] } },
--     { rule = { class = "GQview" },
--       properties = { tag = tags[1][6] } },
--     { rule = { instance = "buzz.exe" },
--       properties = { tag = tags[1][4] } },
--     { rule = { class = "Thunderbird" },
--       properties = { tag = tags[1][6] } },
     { rule = { class = "Deluge" },
       properties = { tag = tags[1][7] } },
     { rule = { class = "Gimp" },
       properties = { tag = tags[1][8], floating=true } },
     { rule = { class = "Synaptic" },
       properties = { tag = tags[1][9] } },
     { rule = { class = "guiswing-ClientForm" },
       properties = { tag = tags[1][10] } },
}

-------------------------------------------------------
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)

    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })
    -- No icons in the titlebar
    -- c.titlebar.widgets[3].appicon=nil
    -- no icons on titlebar update
    -- c:add_signal("property::icon", function(c)
    --   c.titlebar.widgets[3].appicon=nil
    -- end)

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c)
		then client.focus = c end
    end)

    if not startup then
        -- Set the windows at the slave, i.e. put it at the end of others instead of setting it master.
        awful.client.setslave(c)
        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
    c.size_hints_honor = false
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
