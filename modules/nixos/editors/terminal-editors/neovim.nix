{inputs, pkgs, ...}:
{
	environment.systemPackages = with pkgs; [
	  #Neovim plugin and extra things needed for it
	  neovim
	  gcc
	  gnumake42
	  ripgrep
	  unzip
	  xclip
	  fd
	  lua
	  cargo
	  unzip
	  go
	];
}
