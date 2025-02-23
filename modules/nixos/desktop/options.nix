{ lib, ... }:

{
  options = {
    hyprland-module.enable = lib.mkEnableOption {
      description = "Enables hyprland";
      default = false;
    };
  };
}
