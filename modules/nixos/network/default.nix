{ ... }:
{
  imports = [
    ./eduroam-patch.nix
  ];
  # Enable networking
  networking.networkmanager.enable = true;

  # Fix no wifi after sleep
  networking.networkmanager.wifi.powersave = false;

  #Disable waiting for network on boot
  systemd.services.NetworkManager-wait-online.enable = false;

}
