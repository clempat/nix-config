{ pkgs, username, ... }: {
  imports = [ ./yabai.nix ];

  nix = {
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  users.users.${username}.home = "/Users/${username}";

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
      # "gdal"
      "libgeoip"
      "libxml2"
      "mailhog"
      "nvm"
      "pkg-config"
      "shellcheck"
      "xmlsec1"
    ];
    masApps = {
      "tailscale" = 1475387142;
      "paste" = 967805235;
      "toggl" = 1291898086;
      "timery" = 1425368544;
      "drafts" = 1435957248;
    };
    casks = [
      "1password"
      "1password-cli"
      "arc"
      "bartender"
      "cleanshot"
      "dropzone"
      "elgato-stream-deck"
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
      "logi-options-plus"
      "logseq"
      "loop"
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
