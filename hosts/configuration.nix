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

  fonts.fonts = with pkgs; [
    source-code-pro
    font-awesome
    corefonts
    jetbrains-mono
    (nerdfonts.override {
      fonts = [
        "FiraCode"
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
      ripgrep
      killall
      neovim
      pciutils
      usbutils
      wget
      vscode
      volnoti
      gcc
      pre-commit
      sops
      go-task
      fluxcd
      fzf
      kubectl
      kubectl-tree
      gitleaks
      kustomize
      helm
      nodePackages.prettier
      zsh-powerlevel10k
      nixfmt
      go
      libstdcxx5 
      python311
      ninja
      sumneko-lua-language-server
      cmake
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

  security.rtkit.enable = true;
  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
    };
  };

  hardware.pulseaudio.enable = false;

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
  ];

  # 1Password
  users.groups.onepassword.gid = 44399;

  security.wrappers = {
    "1Password-BrowserSupport" = {
      source =
        "${pkgs._1password-gui}/share/1password/1Password-BrowserSupport";
      owner = "root";
      group = "onepassword";
      setuid = false;
      setgid = true;
    };

    "1Password-KeyringHelper" = {
      source = "${pkgs._1password-gui}/share/1password/1Password-KeyringHelper";
      owner = "root";
      group = "onepassword";
      setuid = true;
      setgid = true;
    };
  };

}
