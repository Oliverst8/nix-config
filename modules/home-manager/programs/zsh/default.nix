{ lib, config, ... }:

let
  cfg = config.zsh;
in
{
  options = {
    zsh.enable = lib.mkEnableOption "Enable zsh";
  };
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        update = "nh os switch ~/nixos -H " + config.systemFolder.name + " --ask";
        nxdry = "sudo nixos-rebuild dry-activate --flake ~/nixos/#" + config.systemFolder.name;
        g = "lazygit";
        y = "yazi";
        sp = "spotify_player";
        sus = "python -c 'print(chr(sum(range(ord(min(str(not())))))))'";
        stim = "asciiquarium";
      };

      #history = {
      #  size = 10000;
      #  path = "${config.xdg.dataHome}/zsh/history";
      #};
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
          "direnv"
        ];
      };
    };
  };
}
