{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot = lib.mkIf config.apple-sus.enable {

    plymouth = {
      enable = true;
      theme = "apple-mac-plymouth";
      themePackages = [
        (pkgs.callPackage ./macos-theme.nix { })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 1;
    loader.grub.timeoutStyle = "hidden"; # don’t show menu unless key pressed
  };
}
