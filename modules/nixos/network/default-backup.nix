{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.networking.eduroamPatch;
in
{
  options.networking.eduroamPatch = {
    enable = lib.mkEnableOption "Enable patch for wpa_supplicant (Eduroam)" // {
      default = true;
    };
  };

  config = {
    # Enable networking
    networking.networkmanager.enable = true;

    # Apply patch to wpa_supplicant if enabled
    nixpkgs.config.packageOverrides = lib.mkIf cfg.enable (pkgs: {
      wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
        patches = attrs.patches ++ [ ../../../patches/eduroam.patch ];
      });
    });
  };
}
