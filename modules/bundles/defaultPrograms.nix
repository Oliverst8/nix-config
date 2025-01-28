{pkgs, ...}:

{
environment.systemPackages = [
    pkgs.libsForQt5.okular
  ];
}
