{ ... }:
{
  config = {
    gottis.enable = true;
    systemFolder.name = "laptop";
    git.enable = true;
    docker.enable = true;
    desktop.hyprland.enable = true;
    itu.wiseflow.enable = false;

    desktop.hyprland.monitors = [
      "desc:BOE 0x07F7,1920x1080@60,0x0,1"
    ];
  };

}
