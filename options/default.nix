{ lib, ... }:

{
  options.test.enable = lib.mkEnableOption {
    description = "Test option";
    default = false;
  };
}
