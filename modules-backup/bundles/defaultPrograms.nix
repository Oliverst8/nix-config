{pkgs, ...}:

{
environment.systemPackages = [
    pkgs.libsForQt5.okular
    pkgs.pavucontrol
    pkgs.libsForQt5.dolphin
    pkgs.power-profiles-daemon
    pkgs.mpv
    pkgs.direnv
    pkgs.nixfmt
    pkgs.tree
  ];
}
