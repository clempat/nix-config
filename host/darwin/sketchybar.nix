{ pkgs, username, ... }: {
  services.sketchybar = {
    enable = true;
    config = ''
      #!/bin/bash
      
      # Load user configuration if it exists
      USER_CONFIG="/Users/${username}/.config/sketchybar/sketchybarrc"
      if [ -f "$USER_CONFIG" ]; then
        source "$USER_CONFIG"
      fi
    '';
  };
  system.defaults.NSGlobalDomain._HIHideMenuBar = true;
}
