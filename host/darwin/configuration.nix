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
    taps = [ "homebrew/cask" "mrkai77/cask" ];
    brews = [ "pngpaste" ];
    masApps = {
      "tailscale" = 1475387142;
      "paste" = 967805235;
    };
    casks = [
      "1password"
      "1password-cli"
      "arc"
      "bartender"
      "cleanshot"
      "docker"
      "dropzone"
      "elgato-stream-deck"
      "firefox"
      "home-assistant"
      "kitty"
      "logi-options-plus"
      "logitech-g-hub"
      "logseq"
      "loop"
      "obs"
      "obsidian"
      "pgadmin4"
      "raindropio"
      "raycast"
      "sequel-ace"
      "sizzy"
      "todoist"
      "utm"
      "warp"
    ];
  };

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
