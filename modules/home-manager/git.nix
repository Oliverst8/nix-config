{ ... }:
{
  programs.git = {
    enable = true;
    userName = "Oliver Starup";
    userEmail = "Oliver@starup99.dk";
    
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "!gh auth git-credential";
    };
  };
}
