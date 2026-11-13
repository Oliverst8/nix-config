{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.hyprland;
  terminal = "ghostty";
  fileManager = "dolphin";
  browser = "firefox";
  menu = "wofi --show drun";

  # "output, mode, position, scale" -> hl.monitor table
  parseMonitor =
    s:
    let
      p = map lib.trim (lib.splitString "," s);
    in
    {
      output = builtins.elemAt p 0;
      mode = builtins.elemAt p 1;
      position = builtins.elemAt p 2;
      scale = builtins.elemAt p 3;
    };

  exec = cmd: "hl.dsp.exec_cmd(${lib.generators.toLua { } cmd})";

  startup = [
    "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
    "nm-applet --indicator"
    "wpaperd"
    "waybar"
    "dunst"
    "swayosd-server"
    "vicinae server"
    "libinput-gestures"
    "librepods --hide"
  ];
in
{
  options = {
    hyprland.enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";

      settings = {
        monitor = map parseMonitor config.desktop.hyprland.monitors;

        env = [
          {
            _args = [
              "XCURSOR_SIZE"
              "24"
            ];
          }
          {
            _args = [
              "HYPRCURSOR_SIZE"
              "24"
            ];
          }
          # GTK4's wayland IM eats dead keys when no input method is running
          {
            _args = [
              "GTK_IM_MODULE"
              "simple"
            ];
          }
        ];

        config = {
          xwayland.force_zero_scaling = true;

          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;
            col.active_border = {
              # amber -> rose, matches the waybar palette
              colors = [
                "rgba(ffb780ee)"
                "rgba(e8829aee)"
              ];
              angle = 45;
            };
            col.inactive_border = {
              colors = [ "rgba(3a2233aa)" ];
            };
            resize_on_border = false;
            allow_tearing = false;
            layout = "dwindle";
          };

          decoration = {
            rounding = 10;
            active_opacity = 1.0;
            inactive_opacity = 1.0;
            blur = {
              enabled = true;
              size = 8;
              passes = 3;
              vibrancy = 0.1696;
            };
          };

          animations.enabled = true;
          dwindle.preserve_split = true;
          master.new_status = "master";

          misc = {
            force_default_wallpaper = -1;
            disable_hyprland_logo = true;
          };

          input = {
            kb_layout = "dk";
            kb_options = "caps:swapescape";
            follow_mouse = 1;
            sensitivity = 0;
            touchpad.natural_scroll = true;
          };

          gestures.workspace_swipe_cancel_ratio = 0.2;
        };

        gesture = {
          fingers = 3;
          direction = "horizontal";
          action = "workspace";
        };

        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };

        window_rule = [
          {
            name = "airpods-settings";
            match.title = "AirPods Settings";
            float = true;
            pin = true;
          }
        ]
        ++ lib.optional config.nixos-package-search.enable {
          name = "nixos-package-search";
          match.class = "nixos-package-search";
          no_anim = true;
        };
      };

      extraConfig = ''
        hl.curve("myBezier", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
        hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
        hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
        hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
        hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
        hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
        hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

        local mainMod = "SUPER"

        hl.bind(mainMod .. " + Q", ${exec terminal})
        hl.bind(mainMod .. " + C", hl.dsp.window.close())
        hl.bind(mainMod .. " + M", hl.dsp.exit())
        hl.bind(mainMod .. " + E", ${exec fileManager})
        hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
        hl.bind(mainMod .. " + R", ${exec menu})
        hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
        hl.bind(mainMod .. " + code:60", ${exec "smile"})
        hl.bind("code:107", ${exec ''grim -g "$(slurp -d)" - | wl-copy''})
        hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
        hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
        hl.bind(mainMod .. " + L", ${exec "hyprlock"})
        hl.bind(mainMod .. " + SPACE", ${exec "vicinae toggle"})
        hl.bind(mainMod .. " + SHIFT + Q", ${exec browser})
        hl.bind(mainMod .. " + A", ${exec "~/.config/hypr-backup/rofi_keybinds.sh"})
        ${lib.optionalString config.nixos-package-search.enable ''hl.bind("ALT + SPACE", ${exec "nixos-package-search"})''}

        hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
        hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
        hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
        hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

        for i = 1, 10 do
          local key = i % 10
          hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
          hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
        end

        hl.bind(mainMod .. " + S",          hl.dsp.workspace.toggle_special("magic"))
        hl.bind(mainMod .. " + SHIFT + S",  hl.dsp.window.move({ workspace = "special:magic" }))
        hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
        hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

        hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
        hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        local media = { locked = true, repeating = true }
        hl.bind("XF86AudioRaiseVolume",  ${exec "swayosd-client --output-volume=raise"}, media)
        hl.bind("XF86AudioLowerVolume",  ${exec "swayosd-client --output-volume=lower"}, media)
        hl.bind("XF86AudioMute",         ${exec "swayosd-client --output-volume=mute-toggle"}, media)
        hl.bind("XF86AudioMicMute",      ${exec "swayosd-client --input-volume=mute-toggle"}, media)
        hl.bind("XF86MonBrightnessUp",   ${exec "swayosd-client --brightness raise"}, media)
        hl.bind("XF86MonBrightnessDown", ${exec "swayosd-client --brightness lower"}, media)

        hl.on("hyprland.start", function()
        ${lib.concatMapStrings (c: "  hl.exec_cmd(${lib.generators.toLua { } c})\n") startup}end)
      '';
    };
  };
}
