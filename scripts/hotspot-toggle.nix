# Hotspot toggle script for desktop environments
{ pkgs, ... }: pkgs.writeShellScriptBin "hotspot-toggle" ''
  if pgrep hostapd > /dev/null; then
    pkexec /etc/hotspot-control.sh stop
    ${pkgs.libnotify}/bin/notify-send "Hotspot" "Stopped - WiFi reconnecting"
  else
    pkexec /etc/hotspot-control.sh start
    ${pkgs.libnotify}/bin/notify-send "Hotspot" "Started - SSID: Jellyfin-Travel"
  fi
''