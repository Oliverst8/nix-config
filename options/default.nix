{ lib, ... }:

with lib;

{
  options.desktop.hyprland.enable = mkOption {
    type = types.bool;
    description = "Enable/Install hyprland";
    default = false;
  };
  options.systemFolder.name = mkOption {
    type = types.str;
    description = "The name of the current system (The name the config folder is in)";
    default = "";
  };
  options.gottis.enable = mkOption {
    type = types.bool;
    description = "Enable gottis";
    default = false;
  };
  options.git.enable = mkOption {
    # Not sure where it is enabled so turning this off dosent really turn off git, but all of the extra things are turned off
    type = types.bool;
    description = "Enable git";
    default = false;
  };
  options.git.lazygit.enable = mkOption {
    type = types.bool;
    description = "Enable lazygit (Only works if git is enabled)";
    default = true;
  };
  options.git.gh.enable = mkOption {
    type = types.bool;
    description = "Enable the github cli (Only works if git is enabled)";
    default = true;
  };
  options.docker.enable = mkOption {
    type = types.bool;
    description = "Enable and install docker";
    default = false;
  };
  options.docker.lazydocker.enable = mkOption {
    type = types.bool;
    description = "Enable lazydocker (Only works if docker is enabled)";
    default = true;
  };
  options.vscode.enable = mkOption {
    type = types.bool;
    description = "Enable/Install vscode";
    default = true;
  };
  options.itu.wiseflow.enable = mkOption {
    type = types.bool;
    description = "Enable/Install wiseflow";
    default = false;
  };
  options.desktop.hyprland.monitors = mkOption {
    type = types.listOf types.str;
    description = "List of monitor description for hyprland";
    default = [ ];
  };
  options.drivers.nvidia.enable = mkOption {
    type = types.bool;
    description = "Enable/Install nvidia drivers";
    default = false;
  };
  options.env.background = mkOption {
    type = types.str;
    description = "Path to background image for hyprland";
    default = "~/nixos/imgs/.background/City-Rain.png";
  };
  options.discord.enable = mkOption {
    type = types.bool;
    description = "Enable/Install discord";
    default = false;
  };

}
