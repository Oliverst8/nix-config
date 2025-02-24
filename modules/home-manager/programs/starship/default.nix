{ lib, config, ... }:

{
  programs = lib.mkIf config.test.enable { starship.enable = true; };
}
