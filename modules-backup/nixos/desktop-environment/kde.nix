{inputs, pkgs, lib, config, ...}:
{

	options = {
		
	kde.enable = lib.mkEnableOption "kde";
		  };
config = lib.mkIf config.kde.enable {
  #Enable for kde 6
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;  

  #Enable for kde 5
  ## Enable the X11 windowing system.
  ##services.xserver.enable = true;

  ## Enable the KDE Plasma Desktop Environment.
  #services.xserver.displayManager.sddm.enable = true;
  #services.xserver.desktopManager.plasma5.enable = true;
	};


}
