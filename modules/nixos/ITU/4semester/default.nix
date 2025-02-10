{pkgs, ...}:

{
            
            imports = [
                        ./secondYear.nix
            ];


environment.systemPackages = [
            pkgs.jetbrains.rider
                        #            pkgs.dotnet-sdk_7
    pkgs.zulu21

                        (pkgs.dotnetCorePackages.combinePackages [
      pkgs.dotnetCorePackages.sdk_7_0
      pkgs.dotnetCorePackages.sdk_9_0
    ])
pkgs.python313
  ];

nixpkgs.config.permittedInsecurePackages = [
                "dotnet-sdk-7.0.410"
              ];
}
