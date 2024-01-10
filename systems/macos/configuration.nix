{ config, pkgs, vars, ... }:

{
  imports = [ ../../modules ];

  users.users.${user} = {            # MacOS User
    home = "/Users/${user}";
    shell = pkgs.zsh;                     # Default Shell
  };

  networking = {
    computerName = "MacBook";             # Host Name
    hostName = "MacBook";
  };

  mymodule.ssh.enable = true;
  mymodule.git.enable = true;
  mymodule.firefox.enable = true;
  mymodule.tmux.enable = true;
  mymodule.zsh.enable = true;
  mymodule.neovim.enable = true;
  mymodule.kitty.enable = true;

  fonts = {                               # Fonts
    fontDir.enable = true;
    fonts = with pkgs; [
      source-code-pro
      font-awesome
      (nerdfonts.override {
        fonts = [
          "FiraCode"
        ];
      })
    ];
  };

  environment = {
    shells = with pkgs; [ zsh ];          # Default Shell
    variables = {                         # Environment Variables
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [         # System-Wide Packages
      # Terminal
      ansible
      git
      pfetch
      ranger

      fd
      ripgrep
    ];
  };

  programs = {
    zsh.enable = true;                    # Shell
  };

  services = {
    nix-daemon.enable = true;             # Auto-Upgrade Daemon
  };

  homebrew = {                            # Homebrew Package Manager
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap";
    };
    brews = [
      
    ];
    casks = [
      "1password"
      "1password-cli"
      "bartender"
      "arc"
      "home-assistant"
    ];
  };

  nix = {
    package = pkgs.nix;
    gc = {                                # Garbage Collection
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  system = {                              # Global macOS System Settings
    defaults = {
      NSGlobalDomain = {
        KeyRepeat = 1;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
      };
      dock = {
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
      };
      finder = {
        QuitMenuItem = false;
      };
      trackpad = {
        Clicking = true;
      };
    };
    activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh''; # Set Default Shell
    stateVersion = 4;
  };

  home-manager.users.${user} = {
    home = {
      stateVersion = "23.11";
    };
  };

  
}