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

  layout-lookup = pkgs.writers.writePython3Bin "layout-lookup" { doCheck = false; } (
    builtins.readFile ./layout-lookup.py
  );

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
    home.packages = [ layout-lookup ];

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
            kb_layout = "us,dk";
            # altgr-intl: AltGr+z/l/w = æ/ø/å
            kb_variant = "altgr-intl,";
            kb_options = "caps:escape_shifted_capslock";
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

        layer_rule = [
          {
            name = "notifications";
            match.namespace = "^notifications$";
            animation = "slide right";
            blur = true;
            ignore_alpha = 0.3;
          }
        ];

        window_rule = [
          {
            name = "airpods-settings";
            match.title = "AirPods Settings";
            float = true;
            pin = true;
          }
          {
            name = "layout-lookup";
            match.class = "local.layoutlookup";
            float = true;
            center = true;
            size = "640 360";
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
        hl.bind(mainMod .. " + SHIFT + SPACE", ${exec "hyprctl switchxkblayout all next"})
        -- Copilot key (sends SUPER + SHIFT + F23): next key -> notification, CTRL + Copilot -> window
        local lookupKeys = { [49] = "TLDE", [51] = "BKSL", [94] = "LSGT" }
        for i = 1, 12 do lookupKeys[9 + i] = string.format("AE%02d", i); lookupKeys[23 + i] = string.format("AD%02d", i) end
        for i = 1, 11 do lookupKeys[37 + i] = string.format("AC%02d", i) end
        for i = 1, 10 do lookupKeys[51 + i] = string.format("AB%02d", i) end
        hl.define_submap("layout-lookup", function()
          for code, pos in pairs(lookupKeys) do
            for lvl, mods in ipairs({ "", "SHIFT + ", "MOD5 + ", "SHIFT + MOD5 + " }) do
              hl.bind(mods .. "code:" .. code, function()
                hl.dispatch(hl.dsp.exec_cmd("${lib.getExe layout-lookup} --notify " .. pos .. " " .. (lvl - 1)))
                hl.dispatch(hl.dsp.submap("reset"))
              end)
            end
          end
          for _, mod in ipairs({ "Shift_L", "Shift_R", "ISO_Level3_Shift" }) do hl.bind(mod, function() end) end
          hl.bind("catchall", hl.dsp.submap("reset"))
        end)
        hl.bind(mainMod .. " + SHIFT + code:201", hl.dsp.submap("layout-lookup"))
        hl.bind(mainMod .. " + CTRL + SHIFT + code:201", ${exec "ghostty --class=local.layoutlookup --gtk-single-instance=false --title=layout-lookup --window-padding-x=16 --window-padding-y=14 --background-opacity=0.85 --confirm-close-surface=false -e ${lib.getExe layout-lookup}"})
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
