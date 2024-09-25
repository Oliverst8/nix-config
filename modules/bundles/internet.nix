{...}:
{
  imports = [
	../nixos/internet/network.nix
    #../nixos/internet/wpa_supplicant.nix
  ];

  #Network patch for ITU
  #in config
  #allow connection to eurdoman
        nixpkgs.config.packageOverrides = pkgs: rec {
          wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
            patches = attrs.patches ++ [ ../../patches/eduroam.patch ];
          });
        };

}
