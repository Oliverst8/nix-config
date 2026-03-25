{ ... }:

{
  config.programs.yazi = {
    enable = true;
    shellWrapperName = "yy";
    settings.manager = {
      show_hidden = true;
    };
  };
}
