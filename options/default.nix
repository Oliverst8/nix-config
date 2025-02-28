{ lib, ... }:

with lib;

{
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

  options.nvidia.enable = mkOption {
    type = types.bool;
    description = "Enable nvidia specific settings";
    default = false;
  };
}
