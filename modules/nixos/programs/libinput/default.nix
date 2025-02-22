{ pkgs, ... }:
{
  services = {
    xserver.windowManager.fvwm2.gestures = true;
    libinput.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libinput
    libinput-gestures
    wmctrl
    xdotool
  ];
}
