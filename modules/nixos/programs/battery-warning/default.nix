{
  config,
  lib,
  pkgs,
  ...
}:
let
  # KDE's ocean theme ships purpose-made battery sounds and is far gentler than
  # sound-theme-freedesktop. Already in the closure via Plasma 6.
  sounds = "${pkgs.kdePackages.ocean-sound-theme}/share/sounds/ocean/stereo";

  battery-warn = pkgs.writeShellApplication {
    name = "battery-warn";
    runtimeInputs = [
      pkgs.libnotify
      pkgs.pulseaudio
      pkgs.coreutils
    ];
    text = ''
      bat=/sys/class/power_supply/BAT0
      [ -d "$bat" ] || exit 0

      status=$(cat "$bat/status")
      capacity=''${BATTERY_WARN_FORCE_CAPACITY:-$(cat "$bat/capacity")}
      state="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/battery-warn.state"

      # Charging / Full / "Not charging" -> clear any latched warning and stop.
      if [ "$status" != "Discharging" ] && [ -z "''${BATTERY_WARN_FORCE_CAPACITY:-}" ]; then
        rm -f "$state"
        exit 0
      fi

      last_level=0
      last_time=0
      if [ -f "$state" ]; then read -r last_level last_time < "$state"; fi
      now=$(date +%s)

      # $1 = level, $2 = sound file, $3 = title
      warn() {
        notify-send -u critical -a Battery -i battery-caution \
          -h string:x-dunst-stack-tag:battery-warn \
          "$3" "Battery at ''${capacity}% — plug in the charger." || true
        paplay "$2" || true
        printf '%s %s\n' "$1" "$now" > "$state"
      }

      if [ "$capacity" -le 5 ]; then
        # Re-nag every 5 minutes while critically low.
        if [ "$last_level" -ne 5 ] || [ $((now - last_time)) -ge 300 ]; then
          warn 5 "${sounds}/battery-caution.oga" "Battery critically low"
        fi
      elif [ "$capacity" -le 10 ]; then
        if [ "$last_level" -eq 0 ]; then
          warn 10 "${sounds}/battery-low.oga" "Battery low"
        fi
      elif [ "$capacity" -ge 12 ]; then
        # Hysteresis: only re-arm once clearly back above the 10% threshold.
        rm -f "$state"
      fi
    '';
  };
in
{
  config = lib.mkIf config.battery.warn.enable {
    systemd.user.services.battery-warn = {
      description = "Low battery warning";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${battery-warn}/bin/battery-warn";
      };
    };

    systemd.user.timers.battery-warn = {
      description = "Poll battery level for low-battery warnings";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2m";
        OnUnitActiveSec = "1m";
        AccuracySec = "10s";
      };
    };

    # Installed so the warning can be triggered by hand for testing.
    environment.systemPackages = [ battery-warn ];
  };
}
