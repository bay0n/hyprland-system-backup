-- Hyprland 0.55+ configuration (Lua).

local mainMod = "SUPER"
local terminal = "ghostty"
local fileManager = "hyprfm"
local menu = "exec dms ipc call spotlight toggle"
local browser = "firefox"

-- Environment must be set before Hyprland initializes its display server.
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- Keep DisplayLink/EVDI out of Hyprland while troubleshooting game-related crashes.
hl.env("AQ_DRM_DEVICES", "/home/bayon/.config/hypr/drm/nvidia:/home/bayon/.config/hypr/drm/intel")




-- Stable EDID descriptions keep the physical monitors mapped correctly when DP ports are renumbered.
-- Screenshot layout: Philips above laptop, Dell to the right, cute/Eizo portrait at far right.
hl.monitor({ output = "desc:Chimei Innolux Corporation 0x1521", mode = "1920x1080@144", position = "0x0", scale = 1, transform = 0 }) -- laptop
hl.monitor({ output = "desc:Philips Consumer Electronics Company 220BLPY AU51701001478", mode = "1680x1050@59.88", position = "240x-1050", scale = 1, transform = 0 }) -- Philips
hl.monitor({ output = "desc:Dell Inc. DELL S2422HG 3NK7K83", mode = "1920x1080@165", position = "1920x-540", scale = 1, transform = 0 }) -- Dell
hl.monitor({ output = "desc:Eizo Nanao Corporation S1701 69096017", mode = "1280x1024@60", position = "3840x-470", scale = 1, transform = 1 }) -- cute / Eizo portrait


hl.workspace_rule({ workspace = "1", monitor = "desc:Chimei Innolux Corporation 0x1521", default = true })
hl.workspace_rule({ workspace = "2", monitor = "desc:Dell Inc. DELL S2422HG 3NK7K83", default = true })
hl.workspace_rule({ workspace = "name:Phil", monitor = "desc:Philips Consumer Electronics Company 220BLPY AU51701001478", default = true, persistent = true })
hl.workspace_rule({ workspace = "name:cute", monitor = "desc:Eizo Nanao Corporation S1701 69096017", default = true, persistent = true })


-- Settings
hl.config({


    input = {
        kb_layout = "de",
    },

    dwindle = {
        force_split = 2,
        preserve_split = false,
    },

    cursor = {
        no_hardware_cursors = 0,
    },

    decoration = {
        rounding = 14,
        active_opacity = 0.85,
        inactive_opacity = 0.85,
        fullscreen_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 15,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = false,
            size = 1,
            passes = 1,
            vibrancy = 0.1696,
        },
    },


    general = {
        col = {
            active_border = "rgba(cba6f7ff)",
            inactive_border = "rgba(585b70ff)",
        },
        border_size = 2,
        resize_on_border = false,
    },

})

-- Per-device settings
hl.device({ name = "razer-razer-viper-v3-hyperspeed", middle_button_emulation = false })
hl.device({ name = "razer-razer-viper-v3-hyperspeed-2", middle_button_emulation = false })

-- Start background services once per Hyprland session.
hl.on("hyprland.start", function()
    hl.exec_cmd(" wayvnc --gpu --max-fps=60 --output=DP-3 0.0.0.0 5900")
    hl.exec_cmd(" elephant")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    hl.exec_cmd(" ~/.config/hypr/xdg-portal-init.sh")
    hl.exec_cmd(" awww-daemon")
    hl.exec_cmd("vesktop", { workspace = "name:Phil silent"})
    hl.exec_cmd("spotify", { workspace = "name:cute silent"})
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("wl-clip-persist --clipboard both")
    hl.exec_cmd("~/.config/hypr/scripts/auto-restore.sh")
    hl.dispatch(hl.dsp.focus({ workspace = 2 }))
end)

-- Main keybindings

-- Consume Alt+F4 so applications do not receive their default close shortcut.
hl.bind("ALT + F4", hl.dsp.exec_cmd("true"))
-- Force-kill the focused window's process when Alt+Tab is pressed.
hl.bind("ALT + TAB", hl.dsp.exec_cmd("pid=$(hyprctl -j activewindow | jq -r '.pid // empty'); [ -n \"$pid\" ] && kill -KILL \"$pid\""))

hl.bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("~/.config/hypr/scripts/toggle_opacity.sh"))




hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("dms ipc call wallpaperCarousel open"))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal), { repeating = true })
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), { repeating = true })
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(browser), { repeating = true })
hl.bind(mainMod .. " + V", hl.dsp.window.float())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -z -m region"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { repeating = true })
hl.bind(mainMod .. " + G", hl.dsp.window.fullscreen({ mode = "maximized" }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close(), { repeating = true })
hl.bind(mainMod .. " + H", hl.dsp.layout("togglesplit"), { repeating = true })
-- Logitech MX Keys Sperrtaste (XF86Sleep) abfangen und als reines hyprlock ausführen
hl.bind("+ XF86Sleep", hl.dsp.exec_cmd("dms ipc call lock lock"), { locked = true })
-- Some MX Keys firmware / connection modes report the lock key under these aliases.
hl.bind("+ XF86ScreenSaver", hl.dsp.exec_cmd("dms ipc call lock lock"), { locked = true })
hl.bind(mainMod .. " + TAB", hl.dsp.window.cycle_next({ next = true }),{repeating = true })
-- hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("~/.config/hypr/scripts/safe-kill.sh") )
hl.bind("SUPER + I", hl.dsp.exec_cmd("~/.config/hypr/scripts/launch-impala.sh"))
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })



-- Toggle dms visibility cleanly using SIGUSR1(this wrong)
hl.bind("SUPER + B", hl.dsp.exec_cmd("pkill -SIGUSR1 dms "))


-- Move and resize windows with the pointer.
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Resize mode
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
    hl.bind("left",  hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
    hl.bind("up",    hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
    hl.bind("down",  hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
    hl.bind("l",     hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
    hl.bind("h",     hl.dsp.window.resize({ x = -500, y = 0, relative = true }), { repeating = true })
    hl.bind("k",     hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
    hl.bind("j",     hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
    hl.bind("escape", hl.dsp.submap("reset"))
    hl.bind("RETURN", hl.dsp.submap("reset"))
end)

-- Hardware and media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +10%"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -10%"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness-sync.sh +5%"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness-sync.sh 5%-"), { repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { release = true })
hl.bind("CTRL + ALT + SHIFT + SPACE", hl.dsp.exec_cmd("hypremoji"))


-- Scratchpad
hl.bind(mainMod .. " + X", hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.window.move({ workspace = "e+0" }))

-- Workspaces
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i, follow = true }))
end
hl.bind(mainMod .. " + C", hl.dsp.focus({ workspace = "name:cute" }))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.move({
    workspace = "name:cute",
    follow = true,
}))

hl.bind(mainMod .. " + A", hl.dsp.focus({ workspace = "name:Phil" }))
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.window.move({
    workspace = "name:Phil",
    follow = true,
}))

-- Focus and move windows across monitors.
for key, direction in pairs({ left = "l", right = "r", up = "u", down = "d" }) do
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ direction = direction }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

-- Window rules
hl.window_rule({ match = { class = "quickshell" }, fullscreen = true })
hl.window_rule({ match = { class = "ZapZap", float = false }, border_size = 2 })
hl.window_rule({
    match = { class = "internet-tui" },
    float = true,
    size = { "monitor_w * 0.5", "monitor_h * 0.5" },
    center = true,
})





hl.animation({
    leaf = "layers",
    enabled = true,
    speed = 4,
    bezier = "default",
    style = "slide",
})
hl.layer_rule({ match = { namespace = "waybar" }, animation = "slide" })
    hl.window_rule({ match = { class = "discord" }, workspace = "special:minimized" })
    hl.window_rule({ match = { class = "spotify" }, workspace = "special:minimized" })

hl.config({
    cursor = {
        no_hardware_cursors = true,
    },
})
