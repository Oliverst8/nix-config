{ config, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Dark Pastel";
      # brighter grey than the theme's #555555 so it stays readable on the blur
      palette = [ "8=#8a8a8a" ];
      window-decoration = if config.desktop.hyprland.enable then false else "auto";
      background-opacity = if config.desktop.hyprland.enable then 0.5 else 1;
      background-blur = config.desktop.hyprland.enable;
      working-directory = "home";
      # no per-surface systemd scope; faster windows, no OOM isolation
      linux-cgroup = "never";
    };
  };
}
