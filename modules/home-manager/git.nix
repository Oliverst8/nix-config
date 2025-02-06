{ ... }:
{
  programs.git = {
    enable = true;
    userName = "oliverst8";
    userEmail = "oliver@starup99.dk";
    
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "!gh auth git-credential";
    };
    
    includes = [
      {
        condition = "gitdir:~/ITU/";
        path = "~/ITU/.gitconfig";
      }
    ];
  };
}
