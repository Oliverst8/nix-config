{pkgs, ...}:

{
environment.systemPackages = [
    pkgs.libsForQt5.okular
    pkgs.pavucontrol
    pkgs.libsForQt5.dolphin
  ];
}
