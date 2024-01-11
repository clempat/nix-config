# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, user, ... }:

{
  imports = [
    ../../modules
  ] ++ (import ../../modules/nixos);

  home-manager.users.${user}.imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ] ++ (import ../../modules/home-manager);

  modules.ssh.enable = true;
  modules._1password.enable = true;
  modules.git.enable = true;
  modules.flatpak.enable = true;
  modules.kde.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  modules.firefox.enable = true;
  modules.tmux.enable = true;
  modules.zsh.enable = true;
  modules.neovim.enable = true;

  modules.kitty.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "onepassword" "docker" "input" ];
    initialPassword = "changeme";
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

  fonts.packages = with pkgs; [
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
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    systemPackages = with pkgs; [
      ansible
      bash
      caffeine-ng
      cmake
      dnsutils
      esptool
      esphome
      fd
      fluxcd
      fzf
      gh
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
      nixpkgs-fmt
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
      spaceship-prompt
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

  nixpkgs.config.permittedInsecurePackages = [ "electron-25.9.0" ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

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
    stateVersion = "23.11";
  };

  nixpkgs.overlays = [
    (self: super: {
      discord = super.discord.overrideAttrs (_: {
        src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "0gmqzzs9ac6f48m3qixp3l3bipf2zmywai0aksy3j48s1qqiwz3j";
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
