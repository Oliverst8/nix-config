{
  options,
  config,
  lib,
  pkgs,
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
          "browser.startup.homepage" = "https://searx.aicampground.com";
          "browser.search.defaultenginename" = "Searx";
          "browser.search.order.1" = "Searx";

        };
      };
    };
  };
}
