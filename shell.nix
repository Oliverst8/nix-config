{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = [
    pkgs.git
    pkgs.neovim
    pkgs.lazygit
  ];

  shellHook = ''
    echo "[*] Setting up git config for this shell..."
    git config --global user.name "Oliver Starup"
    git config --global user.email "Oliver@starup99.dk"
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.editor "nvim"
  '';
}
