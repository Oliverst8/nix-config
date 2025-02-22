{ ... }: {
  options = { zsh.enable = lib.mkEnableOption "Enable zsh"; };
  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch --flake ~/nixos/#laptop";
        g = "lazygit";
        y = "yazi";
        s = "spotify_player";
        sus = "python -c 'print(chr(sum(range(ord(min(str(not())))))))'";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "copypath"
          "copyfile"
          "colorize"
          "colored-man-pages"
          "gh"
        ];
      };
    };
  };
}
