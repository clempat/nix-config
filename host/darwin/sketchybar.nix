{ pkgs, username, ... }: {
  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
    config = ''
      #!/bin/bash

      # Wait for aerospace to be available
      while ! command -v aerospace >/dev/null 2>&1; do
        sleep 0.5
      done

      # Load user configuration if it exists
      USER_CONFIG="/Users/${username}/.config/sketchybar/sketchybarrc"
      if [ -f "$USER_CONFIG" ]; then
        source "$USER_CONFIG"
      fi
    '';
  };
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;
}
