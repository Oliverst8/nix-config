{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    oldNixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    sources.url = "./sources";
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
    # sddm-sugar-candy-nix = {
    #   url = "gitlab:Zhaith-Izaliel/sddm-sugar-candy-nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # Neovim plugins not in nixpkgs — add new ones with the "plugins-" prefix.
    # nixCats's standardPluginOverlay picks these up automatically and exposes
    # them as pkgs.neovimPlugins.<name>  (strip the "plugins-" prefix).
    # Then reference them in modules/home-manager/programs/neovim/default.nix
    # under startupPlugins and create a lua config in lua/custom/plugins/.
    plugins-ts-error-translator = {
      url = "github:dmmulroy/ts-error-translator.nvim";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      oldNixpkgs,
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
            specialArgs = {
              inherit inputs;
              sources = inputs.sources.sources;
              old = inputs.oldNixpkgs.legacyPackages.${system.arch};
            };

            modules = [
              { nixpkgs.hostPlatform = system.arch; }
              ./hosts/${system.name}/configuration.nix
              inputs.home-manager.nixosModules.default
              {
                nixpkgs.config.allowUnfree = true;
                home-manager.users.ostarup.nixpkgs.config.allowUnfree = true;
              }
            ]
            ++ system.extraModules;
          };
        }) systems
      );
    };
}
