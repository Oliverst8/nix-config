{pkgs, lib, config, inputs, ...}:
{
options = {
	hyprland-module.enable = lib.mkEnableOption "Enables hyprland";
	};

imports =  [
	../controlhub/libinput.nix
	];


config =  lib.mkIf config.hyprland-module.enable {
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
		wev
		wpaperd
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
