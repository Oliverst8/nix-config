{ config, lib, ...}:

{
  imports = [
  ../../nixos/desktop-environment/kde.nix
  ../../nixos/desktop-environment/hyprland-module.nix
  ];
     
  config = {
    #assert assertMsg ((config.desktop.environment or "") == "") "Error: config.desktop.environment must be set to a non-empty value."; 
    kde.enable = (if (config.desktop.environment == "kde") then true else false);
    hyprland-module.enable = (if (config.desktop.environment == "hyprland") then true else false);
  };
}
