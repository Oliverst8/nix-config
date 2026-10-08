{ config, lib, ... }:
{
  config = lib.mkIf config.fprint.enable {
    services.fprintd.enable = true;

    security.pam.services = {
      login.fprintAuth = true;
      sudo.fprintAuth = true;
      hyprlock.fprintAuth = true;

      # pam_fprintd(8): "The PAM stack is by design a serialised authentication, so
      # it is not possible for pam_fprintd to allow authentication through passwords
      # and fingerprints at the same time."
      #
      # Left at the front of the stack it blocks for its full 30s verification
      # timeout on every password login (SDDM substacks `login`, so the greeter
      # inherits this). Running it after pam_unix means a correct password
      # short-circuits the stack immediately, while an empty password still falls
      # through to the reader.
      #
      # Relative offsets per the warning on
      # security.pam.services.<name>.rules.<type>.<name>.order — absolute values are
      # unstable across nixpkgs bumps.
      login.rules.auth.fprintd.order = config.security.pam.services.login.rules.auth.unix.order + 10;
      hyprlock.rules.auth.fprintd.order =
        config.security.pam.services.hyprlock.rules.auth.unix.order + 10;
    };
  };
}
