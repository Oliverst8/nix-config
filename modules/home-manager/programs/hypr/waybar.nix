{
  config,
  lib,
  pkgs,
  sources,
  ...
}:

let
  claudeUsage = config.claude-usage-waybar.enable;
  claude-usage-waybar =
    pkgs.callPackage ../../../../pkgs/claude-usage-waybar/claude-usage-waybar.nix
      {
        inherit sources;
      };

in
{
  config = {
    programs.waybar = {
      enable = true;
      style = builtins.readFile ./waybar.css;
      settings = {
        mainBar = {
          "layer" = "top";
          "position" = "top";
          "mod" = "dock";
          "margin-left" = 0;
          "margin-right" = 0;
          "margin-top" = 0;
          "margin-bottom" = 0;
          "exclusive" = true;
          "passthrough" = false;
          "gtk-layer-shell" = true;
          "height" = 40;
          "modules-left" = [
            "clock"
            "clock#date"
            "idle_inhibitor"
            "hyprland/language"
            "mpris"
          ]
          ++ lib.optional claudeUsage "custom/claude-usage";
          "modules-center" = [ "hyprland/workspaces" ];
          "modules-right" = [
            "tray"
            "cpu"
            "memory"
            "network"
            "backlight"
            "pulseaudio"
            "battery"
          ];
          "hyprland/workspaces" = {
            "on-scroll-up" = "hyprctl dispatch workspace e+1";
            "on-scroll-down" = "hyprctl dispatch workspace e-1";
            "all-outputs" = true;
            "on-click" = "activate";
            "format" = "{id} {windows}";
            "format-window-separator" = " ";
            "window-rewrite-default" = "󰣆";
            "window-rewrite" = {
              "class<com.mitchellh.ghostty>" = "󰊠";
              "class<firefox>" = "󰈹";
              "class<[Cc]ode|code-url-handler>" = "󰨞";
              "class<discord|vesktop|WebCord>" = "󰙯";
              "class<[Ss]potify>" = "󰓇";
              "class<steam>" = "󰓓";
              "class<org.kde.dolphin>" = "󰉋";
              "class<thunderbird>" = "󰇮";
              "class<teams.*>" = "󰊻";
              "class<mpv>" = "󰎁";
              "class<org.pulseaudio.pavucontrol|pavucontrol>" = "󰕾";
              "class<nixos-package-search>" = "󱄅";
            };
          };
          "clock" = {
            "format" = "󰥔 {:%H:%M}";
            "tooltip-format" = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
          };
          "clock#date" = {
            "format" = "󰃭 {:%a %d %b}";
            "tooltip-format" = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
          };
          "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {
              "activated" = "󰈈";
              "deactivated" = "󰈉";
            };
            "tooltip-format-activated" = "Keeping screen awake — click to allow idle/sleep";
            "tooltip-format-deactivated" = "Screen can idle/sleep — click to keep it awake";
          };
          "hyprland/language" = {
            "format" = "{}";
            "format-en" = "US";
            "format-da" = "DK";
            "keyboard-name" = "at-translated-set-2-keyboard";
          };
          "mpris" = {
            "format" = "{player_icon} {dynamic}";
            "format-paused" = "{status_icon} {dynamic}";
            "dynamic-order" = [
              "artist"
              "title"
            ];
            "dynamic-separator" = " - ";
            "max-length" = 34;
            "interval" = 2;
            "player-icons" = {
              "default" = "󰝚";
              "spotify" = "󰓇";
              "firefox" = "󰈹";
              "mpv" = "󰎁";
            };
            "status-icons" = {
              "paused" = "󰏤";
            };
            "tooltip-format" = "{player}: {artist} - {title}";
          };
          "cpu" = {
            "format" = "󰻠 {usage}%";
            "interval" = 5;
            "on-click" = "ghostty -e btop";
            "tooltip" = false;
          };
          "memory" = {
            "format" = "󰍛 {percentage}%";
            "interval" = 5;
            "tooltip-format" = "{used:0.1f} / {total:0.1f} GiB";
            "on-click" = "ghostty -e btop";
          };
          "tray" = {
            "icon-size" = 15;
            "tooltip" = false;
            "spacing" = 8;
          };
          "network" = {
            "format-wifi" = "󰖩 {essid}";
            "format-ethernet" = "󰈀 {ipaddr}";
            "format-linked" = "󰈀 no IP";
            "format-disconnected" = "󰖪 off";
            "format-alt" = "󰖩 {ipaddr}";
            "tooltip-format" = "{ifname} · {ipaddr} · {signalStrength}%";
          };
          "backlight" = {
            "format" = "{icon} {percent}%";
            "format-icons" = [
              "󰃜"
              "󰃝"
              "󰃞"
              "󰃟"
              "󰃠"
            ];
          };
          "pulseaudio" = {
            "format" = "{icon} {volume}%";
            "tooltip" = false;
            "format-muted" = "󰖁 mute";
            "format-icons" = {
              "headphone" = "󰋋";
              "default" = [
                "󰕿"
                "󰖀"
                "󰕾"
              ];
            };
            "on-click" = "pavucontrol";
            "on-click-right" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };
          "battery" = {
            "states" = {
              "warning" = 30;
              "critical" = 15;
            };
            "format" = "{icon} {capacity}%";
            "format-charging" = "󰂄 {capacity}%";
            "format-plugged" = "󰚥 {capacity}%";
            "format-alt" = "{icon} {time}";
            "format-icons" = [
              "󰁺"
              "󰁼"
              "󰁾"
              "󰂀"
              "󰁹"
            ];
          };
        }
        // lib.optionalAttrs claudeUsage {
          "custom/claude-usage" = {
            "exec" = "${claude-usage-waybar}/bin/claude-usage-bar";
            "interval" = 15;
            "return-type" = "json";
            "format" = "{}";
            "tooltip" = true;
            "on-click" = "setsid -f ${claude-usage-waybar}/bin/claude-usage-popup";
          };
        };
      };
    };

    # Backfills today's tokens + cost from ccusage; the bar only gets rate limits.
    systemd.user.services.claude-usage-today = lib.mkIf claudeUsage {
      Unit.Description = "Backfill today's Claude Code tokens and cost from ccusage";
      Service = {
        Type = "oneshot";
        ExecStart = "${claude-usage-waybar}/bin/claude-usage-today";
        Nice = 10;
      };
    };

    systemd.user.timers.claude-usage-today = lib.mkIf claudeUsage {
      Unit.Description = "Run the Claude Code usage backfill every 5 min";
      Timer = {
        OnActiveSec = "30s";
        OnBootSec = "1min";
        OnUnitActiveSec = "5min";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
