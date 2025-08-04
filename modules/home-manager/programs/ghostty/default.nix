{ config, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Dark Pastel";
      window-decoration = if config.desktop.hyprland.enable then false else "auto";
      background-opacity = if config.desktop.hyprland.enable then 0.5 else 1;
    };
  };
}
