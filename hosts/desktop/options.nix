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
    env.background = "~/nixos/imgs/.background/pure-black-background.jpg";

    desktop.hyprland.monitors = [
    ];

  };

}
