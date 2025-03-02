{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

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

  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/default/configuration.nix
        #./hosts/laptop/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
     };
      laptop = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/laptop/configuration.nix
        #./hosts/laptop/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
     };
     wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
	./hosts/wsl/configuration.nix
        inputs.home-manager.nixosModules.default
          nixos-wsl.nixosModules.default
          {
            wsl.enable = true;
          }
        ];
      };
    };
  };
}
