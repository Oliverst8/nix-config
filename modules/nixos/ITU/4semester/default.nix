{pkgs, ...}:

{
environment.systemPackages = [
    pkgs.jetbrains.rider
    pkgs.dotnet-sdk_7
    pkgs.zulu21
  ];

nixpkgs.config.permittedInsecurePackages = [
                "dotnet-sdk-7.0.410"
              ];
}
