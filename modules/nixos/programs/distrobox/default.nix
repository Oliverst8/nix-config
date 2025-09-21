{
  pkgs,
  ...
}:

{
  config = {
    environment.systemPackages = [ pkgs.distrobox ];
  };
}
