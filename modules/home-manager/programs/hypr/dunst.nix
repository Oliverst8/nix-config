{ lib, config, ... }:

# Palette matches waybar.css (volcanic-moon)
{
  config = lib.mkIf config.hyprland.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          follow = "mouse";
          origin = "top-right";
          offset = "(12, 12)";
          width = "(280, 380)";
          height = "(0, 160)";
          gap_size = 8;
          padding = 12;
          horizontal_padding = 14;
          text_icon_padding = 12;
          corner_radius = 13;
          frame_width = 1;
          separator_height = 0;
          font = "JetBrainsMono Nerd Font 10";
          markup = "full";
          format = "<b>%s</b>\\n%b";
          alignment = "left";
          vertical_alignment = "center";
          icon_position = "left";
          min_icon_size = 32;
          max_icon_size = 48;
          progress_bar_height = 6;
          progress_bar_frame_width = 0;
          progress_bar_corner_radius = 3;
          highlight = "#ffb780";
          mouse_left_click = "do_action, close_current";
          mouse_middle_click = "close_all";
          mouse_right_click = "close_current";
        };

        urgency_low = {
          background = "#180e1ad9";
          foreground = "#9d7d8c";
          frame_color = "#ffb7802e";
          timeout = 4;
        };

        urgency_normal = {
          background = "#180e1ad9";
          foreground = "#f6e3cf";
          frame_color = "#ffb7802e";
          timeout = 6;
        };

        urgency_critical = {
          background = "#180e1af2";
          foreground = "#f6e3cf";
          frame_color = "#ff6b7a";
          highlight = "#ff6b7a";
          timeout = 0;
        };
      };
    };
  };
}
