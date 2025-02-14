{ pkgs, ...}:

{
            environment.systemPackages = [
                pkgs.nodejs_22
                pkgs.pnpm
              ];

}
