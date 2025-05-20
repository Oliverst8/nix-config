{ pkgs, ... }:

{

  environment.systemPackages = [
    pkgs.jetbrains.rider
    pkgs.zulu21

    (pkgs.dotnetCorePackages.combinePackages [
      pkgs.dotnetCorePackages.sdk_7_0
      pkgs.dotnetCorePackages.sdk_8_0
      pkgs.dotnetCorePackages.sdk_9_0
    ])
    pkgs.dotnet-ef
    pkgs.python313
    pkgs.docker
    pkgs.nodejs_22
    pkgs.pnpm
    pkgs.azure-cli
    pkgs.galculator
  ];

  nixpkgs.config.permittedInsecurePackages = [ "dotnet-sdk-7.0.410" ];
}
