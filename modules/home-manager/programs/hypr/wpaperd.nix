{ config, ... }:

{
  config = {
    services.wpaperd = {
      enable = true;
      settings = {
        any = {
          path = config.env.background;
        };
      };
    };
  };
}
