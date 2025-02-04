{ lib, config, ... }:

let
  cfg = config.zsh;
in
{
  options = {
    zsh.enable = lib.mkEnableOption "Enable zsh";
    zsh.dualboot = lib.mkEnableOption "Enables grub aliases";
  };
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        ll = "ls -l";
        update="sudo nixos-rebuild switch --flake ~/nixos/#laptop";
      };

      shellAliases.windows = lib.mkIf cfg.dualboot "sudo grub-reboot 1 && reboot";

      sessionVariables = {
        PATH = "$PATH:/home/david/.dotnet/tools";
        DOTNET_CLI_TELEMETRY_OPTOUT = 1;
      };
      #history = {
      #  size = 10000;
      #  path = "${config.xdg.dataHome}/zsh/history";
      #};
      oh-my-zsh = {
        enable = true;
        plugins = [ ];
      };
    };
  };
}

