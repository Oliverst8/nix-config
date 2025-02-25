{ lib, ... }:

{
  options.test.enable = lib.mkEnableOption {
    description = "Test option";
    default = false;
  };
  options.test1.enable = lib.mkEnableOption {
    description = "Test option";
    default = true;
  };
}
