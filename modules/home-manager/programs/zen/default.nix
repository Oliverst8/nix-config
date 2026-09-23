{
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = lib.mkIf config.zen.enable {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "extensions.autoDisableScopes" = 0; # No Extension warning first open
        };
        # Keep the same extensions installed as in firefox
        extensions.packages = config.programs.firefox.profiles.default.extensions.packages;
      };
    };
  };
}
