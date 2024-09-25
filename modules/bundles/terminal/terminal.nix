{...}:

{

	imports = [
		../../nixos/terminal/alacritty.nix
	];

	home-manager.users.ostarup = {
		imports = [
			#../../home-manager/terminal/alacritty.nix
			#../../home-manager/terminal/zsh.nix
		];
	};

}
