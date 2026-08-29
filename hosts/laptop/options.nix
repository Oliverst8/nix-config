{ ... }:
{
  config = {
    gottis.enable = true;
    systemFolder.name = "laptop";
    git.enable = true;
    docker.enable = true;
    desktop.hyprland.enable = true;
    itu.wiseflow.enable = false;
    kitty-cli.enable = true;
    apple-sus.enable = true;
    itu.eduroam.enable = true;
    steam.enable = true;
    fprint.enable = true;

    desktop.hyprland.monitors = [
      "desc:Lenovo Group Limited 0x403A,1920x1200@60,0x0,1"
      "decs:LG Electronics LG ULTRAWIDE 0x0006DC35, 2560x1080@60, auto-up, 0.5"
    ];
  };

}
