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
      "decs:LG Electronics LG ULTRAWIDE 0x0006DC35, 2560x1080@60, auto-up, 0.5"
    ];
  };

}
