{ config, lib, ... }:

{
  programs.git = lib.mkIf config.git.enable {
    enable = true;
    settings = {
      user = {
        name = "Oliver Starup";
        email = "Oliver@starup99.dk";
      };
      alias = {
        undo = "reset --soft HEAD~1";
      };

      init.defaultBranch = "main";
      credential.helper = "!gh auth git-credential";
    };
  };
}
