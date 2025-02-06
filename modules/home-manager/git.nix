{ ... }:
{
  programs.git = {
    enable = true;
    userName = "oliverst8";
    userEmail = "oliver@starup99.dk";
    
    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "gh auth token";
    };
    
    includes = [
      {
        condition = "gitdir:~/ITU/";
        path = "~/ITU/.gitconfig";
      }
    ];
  };
}
