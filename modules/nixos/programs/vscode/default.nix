{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.vscode.enable {

    environment.systemPackages = [
      pkgs.vscode-fhs # Vscode using it own plugins
    ];
  };
}
