{ config, ... }:

{
  imports = [ ./hyprland.nix ./kde.nix ];

  config = {
    #assert assertMsg ((config.desktop.environment or "") == "") "Error: config.desktop.environment must be set to a non-empty value."; 
    kde.enable = (if (config.desktop.environment == "kde"
      || config.desktop.environment == "both") then
      true
    else
      false);
    hyprland-module.enable = (if (config.desktop.environment == "hyprland"
      || config.desktop.environment == "both") then
      true
    else
      false);
  };
}
