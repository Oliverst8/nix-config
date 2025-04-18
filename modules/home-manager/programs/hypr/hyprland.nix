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
in
{
  options = {
    hyprland.enable = lib.mkEnableOption "Enable Hyprland";
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [
        pkgs.hyprlandPlugins.hyprexpo
        #inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      ];
      settings = {
        monitor = [
          #"HDMI-A-1, prefered, auto, 1, mirror,eDP-1"
          ",preferred,auto,auto"
        ];

        xwayland = {
          force_zero_scaling = true;
        };

        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
        ];

        general = {
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          # col.active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          # col.inactive_border = "rgba(595959aa)";
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          # drop_shadow = true;
          # shadow_range = 4;
          # shadow_render_power = 3;
          #  col.shadow = "rgba(1a1a1aee)";
          blur = {
            enabled = true;
            size = 8;
            passes = 3;
            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        master = {
          new_status = "master";
        };

        misc = {
          force_default_wallpaper = -1;
          disable_hyprland_logo = true;
        };

        input = {
          kb_layout = "dk";
          follow_mouse = 1;
          sensitivity = 0;
          touchpad = {
            natural_scroll = true;
          };
        };

        gestures = {
          workspace_swipe = true;
          workspace_swipe_cancel_ratio = 0.2;
        };

        device = {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        };

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, Q, exec, ${terminal}"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, ${fileManager}"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, ${menu}"
          "$mainMod, P, pseudo,"
          "$mainMod, code:60, exec,smile"
          ", code:107, exec, grim -g \"$(slurp -d)\" - | wl-copy"
          "$mainMod, J, togglesplit,"
          "$mainMod, F, fullscreen, 0"
          "$mainMod, L, exec, hyprlock"
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod, S, togglespecialworkspace, magic"
          "$mainMod SHIFT, S, movetoworkspace, special:magic"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          "$mainMod, SPACE, exec, rofi -show drun -show-icons"
          "$mainMod SHIFT, Q, exec, ${browser}"
          "$mainMod, A, exec, ~/.config/hypr-backup/rofi_keybinds.sh"
          "$mainMod, code:49, hyprexpo:expo, toggle" # can be: toggle, off/disable or on/enable
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        bindel = [
          ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume=raise"
          ", XF86AudioLowerVolume, exec, swayosd-client --output-volume=lower"
          ", XF86AudioMute, exec, swayosd-client --output-volume=mute-toggle"
          ", XF86AudioMicMute, exec, swayosd-client --input-volume=mute-toggle"
          ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
          ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
        ];

        plugin = {
          hyprexpo = {
            columns = 3;
            gap_size = 5;
            #bg_col = "rgb(111111)";
            #workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1

            enable_gesture = true; # laptop touchpad
            gesture_fingers = 3; # 3 or 4
            gesture_distance = 300; # how far is the "max"
            gesture_positive = true; # positive = swipe down. Negative = swipe up.
          };
        };

        exec-once = [
          "swww init"
          "nm-applet --indicator"
          "wpaperd"
          "waybar"
          "dunst"
          "exec swayosd-server"
          "libinput-gestures"
        ];
      };
    };
  };
}
