{ ... }:

{
  config = {
    services.wpaperd = {
      enable = true;
      settings = {
        any = {
          path = "~/nixos/imgs/.background";
        };
      };
    };
  };
}
