-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
local lain      = require("lain")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
----beautiful.init(awful.util.get_themes_dir() .. "default/theme.lua")
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/ether-aw4-noah/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.magnifier,
    lain.layout.uselesstile,
    lain.layout.uselessfair,
    lain.layout.uselesstile.bottom,
    lain.layout.uselesstile.top,
--    awful.layout.suit.floating,
    }
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Launcher

---- mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })
firefox_nightly_launcher = awful.widget.launcher({ image = beautiful.firefox_nightly_icon, command = "firefox-nightly" })
pcmanfm_launcher = awful.widget.launcher({ image = beautiful.pcmanfm_icon, command = "pcmanfm" })
nixnote_launcher = awful.widget.launcher({ image = beautiful.nixnote_icon, command = "nixnote" })
remmina_launcher = awful.widget.launcher({ image = beautiful.remmina_icon, command = "remmina" })

-- }}}

-- {{{ Wibox
markup = lain.util.markup
blue   = beautiful.fg_focus
red    = "#EB8F8F"
green  = "#8FEB8F"
orange  = "#EAEB8F"

-- Textclock
mytextclock = awful.widget.textclock()
--mytextclock = awful.widget.textclock("<span font='Tamsyn 5'> </span>%H:%M ")

-- Calendar
lain.widgets.calendar:attach(mytextclock)

-- Coretemp
tempicon = wibox.widget.imagebox(beautiful.widget_temp)
tempwidget = lain.widgets.temp({
    settings = function()
        widget:set_markup(markup(beautiful.fg_normal, coretemp_now .. "°C "))
    end
})

-- CPU
cpuicon = wibox.widget.imagebox(beautiful.cpu)
cpubar = awful.widget.progressbar()
cpubar:set_color(beautiful.fg_normal)
cpubar:set_width(55)
cpubar:set_ticks(true)
cpubar:set_ticks_size(6)
cpubar:set_background_color(beautiful.bg_normal)
cpumargin = wibox.layout.margin(cpubar, 2, 7)
cpumargin:set_top(6)
cpumargin:set_bottom(6)
cpuupd = lain.widgets.cpu({
    settings = function()
            cpu_perc = tonumber(cpu_now.usage)

            if cpu_perc >= 90 then
                cpubar:set_color(red)
            elseif cpu_perc > 66 then
                cpubar:set_color(red)
                cpuicon:set_image(beautiful.cpu)
            elseif cpu_perc > 33 then
                cpubar:set_color(orange)
                cpuicon:set_image(beautiful.cpu)
            else
                cpubar:set_color(green)
                cpuicon:set_image(beautiful.cpu)
            end
        cpubar:set_value(cpu_perc / 100)
    end
})
cpuwidget = wibox.widget.background(cpumargin)
cpuwidget:set_bgimage(beautiful.widget_bg)

-- MEM
memicon = wibox.widget.imagebox(beautiful.mem)
membar = awful.widget.progressbar()
membar:set_color(beautiful.fg_normal)
membar:set_width(55)
membar:set_ticks(true)
membar:set_ticks_size(6)
membar:set_background_color(beautiful.bg_normal)
memmargin = wibox.layout.margin(membar, 2, 7)
memmargin:set_top(6)
memmargin:set_bottom(6)
memupd = lain.widgets.mem({
    settings = function()
            mem_perc = tonumber((mem_now.used * 100) / mem_now.total)

            if mem_perc >= 90 then
                membar:set_color(red)
            elseif mem_perc > 66 then
                membar:set_color(red)
                memicon:set_image(beautiful.mem)
            elseif mem_perc > 33 then
                membar:set_color(orange)
                memicon:set_image(beautiful.mem)
            else
                membar:set_color(green)
                memicon:set_image(beautiful.mem)
            end
        membar:set_value(mem_perc / 100)
    end
})
memwidget = wibox.widget.background(memmargin)
memwidget:set_bgimage(beautiful.widget_bg)

-- Battery
baticon = wibox.widget.imagebox(beautiful.bat)
batbar = awful.widget.progressbar()
batbar:set_color(beautiful.fg_normal)
batbar:set_width(55)
batbar:set_ticks(true)
batbar:set_ticks_size(6)
batbar:set_background_color(beautiful.bg_normal)
batmargin = wibox.layout.margin(batbar, 2, 7)
batmargin:set_top(6)
batmargin:set_bottom(6)
batupd = lain.widgets.bat({
    settings = function()
       if bat_now.perc == "N/A" or bat_now.status == "Not present" then
            bat_perc = 100
            baticon:set_image(beautiful.ac)
        elseif bat_now.status == "Charging" then
            bat_perc = tonumber(bat_now.perc)
            baticon:set_image(beautiful.ac)

            if bat_perc >= 98 then
                batbar:set_color(green)
            elseif bat_perc > 50 then
                batbar:set_color(beautiful.fg_normal)
            elseif bat_perc > 15 then
                batbar:set_color(beautiful.fg_normal)
            else
                batbar:set_color(red)
            end
        else
            bat_perc = tonumber(bat_now.perc)

            if bat_perc >= 98 then
                batbar:set_color(green)
            elseif bat_perc > 50 then
                batbar:set_color(beautiful.fg_normal)
                baticon:set_image(beautiful.bat)
            elseif bat_perc > 15 then
                batbar:set_color(beautiful.fg_normal)
                baticon:set_image(beautiful.bat_low)
            else
                batbar:set_color(red)
                baticon:set_image(beautiful.bat_no)
            end
        end
        batbar:set_value(bat_perc / 100)
    end
})
batwidget = wibox.widget.background(batmargin)
batwidget:set_bgimage(beautiful.widget_bg)

-- ALSA volume bar
volicon = wibox.widget.imagebox(beautiful.vol)
volume = lain.widgets.alsabar({width = 55, ticks = true, ticks_size = 6,
card = "0", step = "2%",
settings = function()
    if volume_now.status == "off" then
        volicon:set_image(beautiful.vol_mute)
    elseif volume_now.level == 0 then
        volicon:set_image(beautiful.vol_no)
    elseif volume_now.level <= 50 then
        volicon:set_image(beautiful.vol_low)
    else
        volicon:set_image(beautiful.vol)
    end
end,
colors =
{
    background = beautiful.bg_normal,
    mute = red,
    unmute = beautiful.fg_normal
}})
volmargin = wibox.layout.margin(volume.bar, 2, 7)
volmargin:set_top(6)
volmargin:set_bottom(6)
volumewidget = wibox.widget.background(volmargin)
volumewidget:set_bgimage(beautiful.widget_bg)

-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
--mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
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
--                  awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 2, function (c) c:kill() end),
                     awful.button({ }, 3, client_menu_toggle_fn()))
--                   awful.button({ }, 4, function ()
--                                              awful.client.focus.byidx(1)
--                                          end),
--                   awful.button({ }, 5, function ()
--                                              awful.client.focus.byidx(-1)
--                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "➊" }, s, awful.layout.layouts[1])
    awful.tag.add("➋", { layout = awful.layout.layouts[2], screen = s, })
    awful.tag.add("➌", { layout = awful.layout.layouts[3], screen = s, })
    awful.tag.add("➍", { layout = awful.layout.layouts[4], screen = s, })
    awful.tag.add("➎", { layout = awful.layout.layouts[5], screen = s, })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end)))
--                         awful.button({ }, 4, function () awful.layout.inc( 1) end),
--                         awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mytopwibox = awful.wibar({ position = "top", opacity = 0.96, screen = s })

    -- Add widgets to the wibox
    s.mytopwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
        },
            s.mypromptbox, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            --mykeyboardlayout,
            wibox.layout.margin(tempicon,0,0,2,2),
            tempwidget,
            wibox.layout.margin(cpuicon,0,0,2,2),
            wibox.layout.margin(cpuwidget,0,0,6,6),
            wibox.layout.margin(memicon,0,0,2,2),
            wibox.layout.margin(memwidget,0,0,6,6),
            wibox.layout.margin(volicon,0,0,2,2),
            wibox.layout.margin(volumewidget,0,0,6,6),
            wibox.layout.margin(baticon,0,0,2,2),
            wibox.layout.margin(batwidget,0,0,6,6),
            mytextclock,
        },
    }

    -- Create the second wibox
    s.mybottomwibox = awful.wibar({ position = "bottom", opacity = 0.96, screen = s })

    -- Add widgets to the second wibox
    s.mybottomwibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.layout.margin(firefox_nightly_launcher,2,2,2,2),
            wibox.layout.margin(pcmanfm_launcher,2,2,2,2),
            wibox.layout.margin(nixnote_launcher,2,2,2,2),
            wibox.layout.margin(remmina_launcher,2,2,2,2),
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systray,
            wibox.layout.margin(wibox.widget.systray(),3,3,3,3),
            wibox.layout.margin(s.mylayoutbox,3,3,3,3),
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
--  awful.button({ }, 4, awful.tag.viewnext),
--  awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
--  awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
--            {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
--    awful.key({ modkey }, "p", function() menubar.show() end,
--              {description = "show the menubar", group = "launcher"})

    -- Custom Key bindings
    awful.key({ modkey,           }, "w", function () awful.spawn("firefox-nightly") end),
    awful.key({ modkey,           }, "p", function () awful.spawn("pcmanfm") end),
    awful.key({ modkey,           }, "Up", function () awful.spawn("slimlock") end),
    awful.key({ "Mod1", "Control" }, "a", function () awful.util.spawn_with_shell("keepass --auto-type") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
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
		     size_hints_honor = false
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- Note : "➊", "➋", "➌", "➍", "➎"
    { rule = { class = "Firefox" },
       properties = { screen = 1, tag = "➊" } },

    { rule = { class = "Pcmanfm" },
       properties = { screen = 1, tag = "➋" } },

    { rule = { class = "KeePass" },
     	    properties = { screen = 1, tag = "➎" } },
	    
    { rule = { class = "Gimp" },
     	    properties = { screen = 1, tag = "➎" } },

    { rule = { class = "Gimp", role = "gimp-image-window" },
          properties = { maximized_horizontal = true,
                         maximized_vertical = true } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
--client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
client.connect_signal("focus", function(c) c.border_width = beautiful.border_width end)
client.connect_signal("unfocus", function(c) c.border_width = 0 end)
 
-- No border for maximized clients
client.connect_signal("focus",
    function(c)
        if c.maximized_horizontal == true and c.maximized_vertical == true then
            c.border_color = beautiful.border_normal
        else
            c.border_color = beautiful.border_focus
        end
    end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange", function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then -- Fine grained borders and floaters control
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width

                -- No borders with only one visible client
                elseif #clients == 1 or layout == "max" then
                    c.border_width = 0
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
      end)
end
-- }}}

-- {{{ Run autostarting applications only once
function autostart(cmd, delay)
    delay = delay or 0
    awful.util.spawn_with_shell("pgrep -u $USER -x -f '" .. cmd .. "' || ( sleep " .. delay .. " && " .. cmd .. " )")
end

-- Autostart applications. The extra argument is optional, it means how long to
-- delay a command before starting it (in seconds).
--autostart("pkill nm-applet", 1)
autostart("nm-applet", 15)
autostart("firefox-nightly")
autostart("keepass")

-- }}}
