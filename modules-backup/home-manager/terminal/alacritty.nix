{ inputs, pkg, config, ... }:
{
	home.file.".config/alacritty/" = {
	 	source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/dotfiles/.config/alacritty";
	};
}
