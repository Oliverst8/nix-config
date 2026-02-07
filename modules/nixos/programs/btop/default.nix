{
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages =
    if config.drivers.nvidia.enable then
      [
        (pkgs.btop.override { cudaSupport = true; })
      ]
    else
      [ pkgs.btop ];

}
