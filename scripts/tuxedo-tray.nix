{ pkgs, ... }:

pkgs.writeShellScriptBin "tuxedo-tray" ''
  #!/usr/bin/env bash

  # Tuxedo Fan Profile System Tray Integration
  # Provides quick access to switch between fan profiles

  get_current_profile() {
    ${pkgs.tuxedo-rs}/bin/tailor profile list | grep "(active)" | cut -d' ' -f1
  }

  get_all_profiles() {
    ${pkgs.tuxedo-rs}/bin/tailor profile list | cut -d' ' -f1
  }

  set_profile() {
    local profile="$1"
    ${pkgs.tuxedo-rs}/bin/tailor profile set "$profile"
    ${pkgs.libnotify}/bin/notify-send "Tuxedo Fan Profile" "Switched to: $profile" -i fan
  }

  show_menu() {
    local current=$(get_current_profile)
    local menu=""
    
    # Build menu with current profile marked
    while IFS= read -r profile; do
      if [ "$profile" = "$current" ]; then
        menu="$menu●  $profile (current)\n"
      else
        menu="$menu○  $profile\n"
      fi
    done < <(get_all_profiles)
    
    # Show menu using rofi/dmenu
    selected=$(echo -e "$menu" | ${pkgs.rofi}/bin/rofi -dmenu -p "Fan Profile:" -theme-str 'window {width: 300px;}' | sed 's/^[●○]  //' | cut -d' ' -f1)
    
    if [ -n "$selected" ] && [ "$selected" != "$current" ]; then
      set_profile "$selected"
    fi
  }

  case "''${1:-menu}" in
    menu)
      show_menu
      ;;
    current)
      get_current_profile
      ;;
    list)
      get_all_profiles
      ;;
    set)
      if [ -n "$2" ]; then
        set_profile "$2"
      else
        echo "Usage: tuxedo-tray set <profile>"
        exit 1
      fi
      ;;
    cycle)
      ${pkgs.tuxedo-rs}/bin/tailor profile cycle
      current=$(get_current_profile)
      ${pkgs.libnotify}/bin/notify-send "Tuxedo Fan Profile" "Switched to: $current" -i fan
      ;;
    *)
      echo "Usage: tuxedo-tray [menu|current|list|set <profile>|cycle]"
      exit 1
      ;;
  esac
''
