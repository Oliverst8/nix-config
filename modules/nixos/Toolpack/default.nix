{ pkgs, ... }:
{

  environment.systemPackages = [
    pkgs.jetbrains.rider

    (pkgs.dotnetCorePackages.combinePackages [
      pkgs.dotnetCorePackages.sdk_9_0
    ])
    pkgs.teams-for-linux
    pkgs.dotnet-ef
    pkgs.python313
    pkgs.docker
    pkgs.nodejs_24
    pkgs.vscode-fhs
    pkgs.dbeaver-bin
    pkgs.azure-cli
    pkgs.lazysql
  ];
}
