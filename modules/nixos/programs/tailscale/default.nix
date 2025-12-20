{ ... }:
{
  services.tailscale.enable = true;
  services.resolved.enable = true; # This makes DNS work after sleep
}
