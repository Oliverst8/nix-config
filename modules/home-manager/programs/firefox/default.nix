{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          #"browser.startup.homepage" = "https://google.com";
          "browser.search.defaultenginename" = "Google";
          "browser.search.order.1" = "Google";
          "extensions.autoDisableScopes" = 0;
          "layout.css.prefers-color-scheme.content-override" = 0;
          "browser.theme.toolbar-theme" = 0;
          "browser.theme.content-theme" = 0;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        };
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
          bitwarden
          multi-account-containers
          temporary-containers
        ];
      };
    };
  };
}
