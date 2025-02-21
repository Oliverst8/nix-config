{...}:

{

	imports = [
		../../nixos/terminal/alacritty.nix
		../../nixos/terminal/ghostty.nix
		../../nixos/terminal/starship.nix
	];

	home-manager.users.ostarup = {
		imports = [
			#../../home-manager/terminal/alacritty.nix
			#../../home-manager/terminal/zsh.nix
		];
	};

}
