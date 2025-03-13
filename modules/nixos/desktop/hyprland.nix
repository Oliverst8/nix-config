{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  options = {
    hyprland-module.enable = lib.mkEnableOption "Enables hyprland";
  };

  imports = [ ../programs/libinput ];

  config = lib.mkIf config.hyprland-module.enable {
    services.displayManager.sddm = {
      enable = true;
      sugarCandyNix = {
        enable = true;
        settings = {
          Background = lib.cleanSource ./../../../imgs/.background/City-Rain.png;
          FullBlur = true;
          ForceHideCompletePassword = true;
        };
      };
    };
    services.displayManager.sddm.wayland.enable = true;

    programs.hyprland.enable = true;
    programs.hyprland.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
      pkgs.waybar
      dunst
      libnotify
      swww
      kitty
      rofi-wayland
      brightnessctl
      networkmanagerapplet
      swayosd
      wl-clipboard
      wev
      wpaperd
      hyprlock
      #Screenshot:
      pkgs.grim
      pkgs.slurp
    ];

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

}
