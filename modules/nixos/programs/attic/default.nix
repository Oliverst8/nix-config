{ pkgs, ... }:
{
  # Own cache on the Pi, tailnet-only; filled by the flake-update workflow
  nix.settings.extra-substituters = [ "http://starpi.tailc0008.ts.net:47219/main" ];
  nix.settings.extra-trusted-public-keys = [ "main:t940NsDexB9XQxAUtShBBDJ/l8+xz+NQCd0pxdYaG1A=" ];

  # Pull token, placed by hand (see docs/attic-pi.md)
  nix.settings.netrc-file = "/etc/nix/netrc";

  # Don't hang when off the tailnet or the Pi is down
  nix.settings.connect-timeout = 5;
  nix.settings.fallback = true;

  environment.systemPackages = [ pkgs.attic-client ];
}
