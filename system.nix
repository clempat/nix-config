{ inputs, config, pkgs, username,
  hostname, gitUsername, theLocale,
  theTimezone, wallpaperDir, wallpaperGit, lib, deviceProfile, ... }:

{
  imports =
    [
      ./hardware.nix
      ./config/system/boot.nix
      ./config/system/intel-opengl.nix
      ./config/system/amd-opengl.nix
      ./config/system/programs.nix
      ./config/system/polkit.nix
      ./config/system/services.nix
    ];

  # Enable Electron
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  # Enable networking
  networking.hostName = "${hostname}"; # Define your hostname
  networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = true;

  # Set your time zone
  time.timeZone = "${theTimezone}";

  # Shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Select internationalisation properties
  i18n.defaultLocale = "${theLocale}";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "${theLocale}";
    LC_IDENTIFICATION = "${theLocale}";
    LC_MEASUREMENT = "${theLocale}";
    LC_MONETARY = "${theLocale}";
    LC_NAME = "${theLocale}";
    LC_NUMERIC = "${theLocale}";
    LC_PAPER = "${theLocale}";
    LC_TELEPHONE = "${theLocale}";
    LC_TIME = "${theLocale}";
  };

  # Define a user account.
  users.users."${username}" = {
    homeMode = "755";
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Steam Configuration
  programs.steam = {
    enable = deviceProfile != "vm";
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };


  environment.sessionVariables = rec {
    POLKIT_BIN = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  system.stateVersion = "23.11";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
