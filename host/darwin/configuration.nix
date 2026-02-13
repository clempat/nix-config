{ pkgs, username, ... }:
{
  # imports = [ ./yabai.nix ];
  imports = [
    ./aerospace.nix
    ./sketchybar.nix
  ];

  system.primaryUser = username;

  nix = {
    optimise.automatic = true;
    settings = {
      builders-use-substitutes = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      trusted-users = [
        "root"
        "${username}"
      ];
      extra-platforms = [ "x86_64-linux" ];
    };
  };

  nixpkgs.config.allowBroken = true;

  programs.zsh.enable = true;
  system.stateVersion = 4;
  users.users.${username}.home = "/Users/${username}";

  environment.shells = [ pkgs.zsh ];
  environment.variables = {
    EDITOR = "nvim";
    OLLAMA_HOST = "0.0.0.0:11434";
  };
  # security.pam.enableSudoTouchIdAuth = true;

  # Following will allow to use touch id in tmux
  # See: https://github.com/LnL7/nix-darwin/issues/985
  environment.systemPackages = [ pkgs.pam-reattach ];

  environment.etc."pam.d/sudo_local".text = ''
    # Managed by Nix Darwin
    auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so ignore_ssh
    auth       sufficient     pam_tid.so
  '';

  homebrew = {
    # Homebrew Package Manager
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    greedyCasks = true;
    taps = [
      "mrkai77/cask"
      "heroku/brew"
      "sst/tap"
      "steipete/tap"
    ];
    brews = [
      "pngpaste"

      # TODO: Move this to backend flake
      "zlib"
      "libxml2"
      "mailhog"
      "mole"
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
      # "toggl" = 1291898086;
      "wireguard" = 1451685025;
    };
    casks = [
      "1password"
      "bartender"
      "karabiner-elements"
      "tailscale-app"
      "beeper"
      "cleanshot"
      "cursor"
      "steipete/tap/codexbar"
      "docker-desktop"
      "dropzone"
      "dropbox"
      "deskpad"
      "elgato-stream-deck"
      "ungoogled-chromium"
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
      "handbrake-app"
      "home-assistant"
      "kitty"
      "logi-options+"
      "logseq"
      "loop"
      "moonlight"
      "mockoon"
      "nextcloud"
      "obs"
      "obsidian"
      "ollama-app"
      # "orbstack"
      "pgadmin4"
      "raindropio"
      "raycast"
      "sequel-ace"
      "spotify"
      "todoist-app"
      "utm"
      "vlc"
      "warp"
      # "docker" # Changed for orbstack
      # "logitech-g-hub"
    ];
  };

  # Need to add `defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false`
  system = {
    # Global macOS System Settings

    defaults = {
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        "com.apple.swipescrolldirection" = false;
        NSWindowShouldDragOnGesture = true;
      };
      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
        static-only = true;
      };
      finder = {
        QuitMenuItem = false;
      };
      trackpad = {
        Clicking = true;
      };
    };
    activationScripts.postActivation.text = "sudo chsh -s ${pkgs.zsh}/bin/zsh"; # Set Default Shell
  };
}
