{pkgs, lib, config, ...}:
{
options = {
	hyprland-module.enable = lib.mkEnableOption "Enables hyprland";
	};

config =  lib.mkIf config.hyprland-module.enable {
	services.displayManager.sddm.enable = true;
	services.displayManager.sddm.wayland.enable = true;

	programs.hyprland.enable = true;
	programs.hyprland.xwayland.enable = true;
	
	environment.systemPackages = with pkgs; [
		pkgs.waybar
		(pkgs.waybar.overrideAttrs (oldAttrs: {
			mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
			})
		)

		dunst
		libnotify
		swww
		kitty
		rofi-wayland
		brightnessctl
		networkmanagerapplet
		swayosd
		wl-clipboard
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
