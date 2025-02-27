{ lib, ... }:

with lib;

{
  options.gottis.enable = mkOption {
    type = types.bool;
    description = "Enable gottis";
    default = false;
  };
  options.git.enable = mkOption {
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
}
