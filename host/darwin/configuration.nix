{ pkgs, username, ... }: {
  imports = [ ./yabai.nix ];

  nix = {
    optimise.automatic = true;
    settings = {
      builders-use-substitutes = true;
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
      trusted-users = [ "root" "${username}" ];
    };
  };

  programs.zsh.enable = true;
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  users.users.${username}.home = "/Users/${username}";

  environment.shells = [ pkgs.zsh ];
  security.pam.enableSudoTouchIdAuth = true;

  homebrew = { # Homebrew Package Manager
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    taps = [ "mrkai77/cask" "heroku/brew" "homebrew/cask-fonts" ];
    brews = [
      "pngpaste"

      # TODO: Move this to backend flake
      "zlib"
      "gdal"
      "libgeoip"
      "libxml2"
      "mailhog"
      "nvm"
      "pkg-config"
      "shellcheck"
      "xmlsec1"
      "libb2"
      "python@3.11"
    ];
    masApps = {
      "drafts" = 1435957248;
      "parcel" = 639968404;
      "paste" = 967805235;
      "timery" = 1425368544;
      "toggl" = 1291898086;
      "wireguard" = 1451685025;
    };
    casks = [
      "1password"
      "1password-cli"
      "arc"
      "bartender"
      "cleanshot"
      "cursor"
      "dropzone"
      "deskpad"
      "elgato-stream-deck"
      "eloston-chromium"
      "fantastical"
      "figma"
      "firefox"
      "font-geist"
      "font-geist-mono"
      "font-geist-mono-nerd-font"
      "font-hack"
      "font-hack-nerd-font"
      "font-inter"
      "font-jetbrains-mono"
      "font-jetbrains-mono-nerd-font"
      "font-roboto"
      "github"
      "handbrake"
      "home-assistant"
      "karabiner-elements"
      "kitty"
      "logi-options+"
      "logseq"
      "loop"
      "moonlight"
      "mockoon"
      "nextcloud"
      "obs"
      "obsidian"
      "ollama"
      "orbstack"
      "pgadmin4"
      "raindropio"
      "raycast"
      "sequel-ace"
      "sizzy"
      "spotify"
      "tailscale"
      "todoist"
      "utm"
      "vlc"
      "warp"
      # "docker" # Changed for orbstack
      # "logitech-g-hub"
    ];
  };

  # Need to add `defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false`
  system = { # Global macOS System Settings

    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        "com.apple.swipescrolldirection" = false;
      };
      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
        static-only = true;
      };
      finder = { QuitMenuItem = false; };
      trackpad = { Clicking = true; };
    };
    activationScripts.postActivation.text =
      "sudo chsh -s ${pkgs.zsh}/bin/zsh"; # Set Default Shell
  };
}
