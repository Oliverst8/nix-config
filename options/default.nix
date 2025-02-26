{ lib, ... }:

with lib;

{
  options.test.enable = mkOption {
    type = types.str;
    description = "Test option";
    default = false;
  };
  options.gottis.enable = mkOption {
    type = types.bool;
    description = "Enable gottis";
    default = false;
  };
}
