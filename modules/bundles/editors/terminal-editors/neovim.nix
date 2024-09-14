{inputs, pkgs, config, ... }:
{

	imports = [
		../../../nixos/editors/terminal-editors/neovim.nix
		#		../../../home-manager/editors/terminal-editors/neovim-home.nix
	];

	home-manager.users.ostarup = {
		imports = [
			../../../home-manager/editors/terminal-editors/neovim-home.nix
		];
	};

}
