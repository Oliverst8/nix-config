{ config, lib, ... }:
{
  config = lib.mkIf config.fprint.enable {
    services.fprintd.enable = true;

    security.pam.services = {
      login.fprintAuth = true;
      sudo.fprintAuth = true;
      sddm.fprintAuth = true;
      hyprlock.fprintAuth = true;
    };
  };
}
