{ lib, ... }:

with lib;

{
  options.gottis.enable = mkOption {
    type = types.bool;
    description = "Enable gottis";
    default = false;
  };
}
