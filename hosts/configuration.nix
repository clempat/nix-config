# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, user, ... }:

{
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "onepassword" "docker" ];
    shell = pkgs.zsh;
  };

  networking.extraHosts = ''
  '';

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.utf8";
    LC_IDENTIFICATION = "de_DE.utf8";
    LC_MEASUREMENT = "de_DE.utf8";
    LC_MONETARY = "de_DE.utf8";
    LC_NAME = "de_DE.utf8";
    LC_NUMERIC = "de_DE.utf8";
    LC_PAPER = "de_DE.utf8";
    LC_TELEPHONE = "de_DE.utf8";
    LC_TIME = "de_DE.utf8";
  };

  services.languagetool.enable = true;

  fonts.fonts = with pkgs; [
    source-code-pro
    font-awesome
    corefonts
    jetbrains-mono
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Iosevka"
        "FantasqueSansMono"
      ];
    })
  ];

  environment = {
    variables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    systemPackages = with pkgs; [
      ansible
      bash
      cmake
      fd
      fluxcd
      fzf
      gcc
      gitleaks
      go
      go-task
      jdk17_headless
      kubernetes-helm
      killall
      kubectl
      kubectl-tree
      kustomize
      libstdcxx5
      neovim
      ninja
      nixfmt
      nodePackages.prettier
      pciutils
      polkit_gnome
      pre-commit
      python311
      ripgrep
      sops
      sumneko-lua-language-server
      terraform
      usbutils
      volnoti
      vscode
      wget
      zsh-powerlevel10k
    ];

  };

  programs.kdeconnect.enable = true;

  programs.steam.enable = true;
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        libgdiplus
      ];
    };
  };

  programs.git = {
    enable = true;
    config = {
      user = {
        email = "clement.patout@gmail.com";
        name = "Clement Patout";
      };
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  programs._1password-gui.enable = true;
  programs._1password.enable = true;
  programs._1password-gui.polkitPolicyOwners = [ user ];

  security.rtkit.enable = true;
  security.pam.services.kwallet.enableKwallet = true;
  security.polkit.enable = true;

  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
    };
  };

  hardware.pulseaudio.enable = false;
  hardware.nvidia.forceFullCompositionPipeline = true;

  virtualisation.docker.enable = true;

  services = {

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    flatpak.enable = true;

    openssh = {
      enable = true;
      allowSFTP = true;
      # tmp for guacamole 
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };

  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };

  nixpkgs.config.allowUnfree = true;

  system = {
    autoUpgrade = {
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "22.05";
  };

  nixpkgs.overlays = [
    (self: super: {
      discord = super.discord.overrideAttrs (_: {
        src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "1pw9q4290yn62xisbkc7a7ckb1sa5acp91plp2mfpg7gp7v60zvz";
        };
      });
    })
    (self: super: {
      cypress = super.cypress.overrideAttrs (_: {
        version = "12.5.1";
        src = super.fetchzip {
          url = "https://cdn.cypress.io/desktop/12.5.1/linux-x64/cypress.zip";
          sha256 = "rdMlaCjUXvV05hbmoyFtTOUdZGWyFCQnTvkRIUH3myM=";
        };
      });
    })
  ];

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      unitConfig = {
        Description = "polkit-gnome-authentication-agent-1";
        Wants = [ "graphical-session.target" ];
        WantedBy = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

}
