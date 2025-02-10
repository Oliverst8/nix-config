{pkgs, ...}:
{
  # Enable networking
  networking.networkmanager.enable = true;

  # https://kisonecat.com/blog/eduroam-openssl-wpa-supplicant/
  nixpkgs.config.packageOverrides = pkgs: {
    wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
      patches = attrs.patches ++ [ ../../../patches/eduroam.patch ];
    });
  };
}
