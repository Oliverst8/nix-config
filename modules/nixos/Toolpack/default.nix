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
    pkgs.nodejs_22
    pkgs.pnpm
    pkgs.azure-cli
    pkgs.galculator
  ];
}
