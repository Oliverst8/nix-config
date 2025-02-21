{ inputs, pkgs, lib, config, ... }: {

  options = { kde.enable = lib.mkEnableOption "kde"; };
  config = lib.mkIf config.kde.enable {
    #Enable for kde 6
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

  };

}
