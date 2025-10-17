{ ... }:
{
  imports = [
    ./eduroam-patch.nix
  ];
  # Enable networking
  networking.networkmanager.enable = true;

  #Disable waiting for network on boot
  systemd.services.NetworkManager-wait-online.enable = false;

}
