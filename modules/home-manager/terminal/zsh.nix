{config, ...}:

{
programs.zsh = {
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  shellAliases = {
    ll = "ls -l";
    update = "sudo nixos-rebuild switch --flake ~/nixos/#laptop";
  };
  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
  };

};

}
