{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sddm-sugar-candy-nix = {
      url = "gitlab:Zhaith-Izaliel/sddm-sugar-candy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-wsl,
      nixCats,
      ...
    }@inputs:
    let
      systems = [
        {
          name = "default";
          arch = "x86_64-linux";
          extraModules = [ ];
        }
        {
          name = "laptop";
          arch = "x86_64-linux";
          extraModules = [ ];
        }
        {
          name = "desktop";
          arch = "x86_64-linux";
          extraModules = [ ];
        }
        {
          name = "wsl";
          arch = "x86_64-linux";
          extraModules = [
            nixos-wsl.nixosModules.default
            {
              wsl.enable = true;
            }
          ];
        }
      ];
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (system: {
          name = system.name;
          value = nixpkgs.lib.nixosSystem {
            system = system.arch;
            specialArgs = { inherit inputs; };
            modules = [
              ./hosts/${system.name}/configuration.nix
              inputs.home-manager.nixosModules.default
            ]
            ++ system.extraModules;
          };
        }) systems
      );
    };
}
