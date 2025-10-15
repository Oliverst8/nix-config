{
  config,
  lib,
  ...
}:

{

  config = lib.mkIf config.itu.eduroam.enable {
    # Apply patch to wpa_supplicant if enabled
    nixpkgs.config.packageOverrides = (
      pkgs: {
        wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
          patches = attrs.patches ++ [ ../../../patches/eduroam.patch ];
        });
      }
    );
  };
}
