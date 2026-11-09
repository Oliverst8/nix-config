{ config, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Dark Pastel";
      window-decoration = if config.desktop.hyprland.enable then false else "auto";
      background-opacity = if config.desktop.hyprland.enable then 0.5 else 1;
      # Hyprland 0.57+ honours the client's blur request instead of its own setting
      background-blur = config.desktop.hyprland.enable;
      working-directory = "home";
      # no per-surface systemd scope; faster windows, no OOM isolation
      linux-cgroup = "never";
    };
  };
}
