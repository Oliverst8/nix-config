{ ... }:
{
  config = {
    #Self made options
    gottis.enable = true;
    systemFolder.name = "desktop";
    git.enable = true;
    docker.enable = true;
    desktop.hyprland.enable = true;
    drivers.nvidia.enable = true;
    discord.enable = true;
    hypridle.enable = true;
    env.background = "~/nixos/imgs/.background/pure-black-background.jpg";

    desktop.hyprland.monitors = [
      "desc:ASUSTek COMPUTER INC XG27AQDMG S6LMRS002976,2560x1440@239.97,0x0,1"
      "DP-4, 2560x1440@144.00, auto-right, 1"
    ];

  };

}
