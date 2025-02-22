{ ... }:

{
  programs.git = {
    enable = true;
    userName = "Oliver Starup";
    userEmail = "Oliver@starup99.dk";
    aliases = { undo = "reset --soft HEAD~1"; };

    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "!gh auth git-credential";
    };
  };
}
