{ hostname, pkgs, lib, username, ... }: {
  imports = [
    ./boot.nix
    ./hardware.nix
    ./locale.nix

    ../services/avahi.nix
    ../services/firewall.nix
    ../services/kanata.nix
    ../services/openssh.nix
    ../services/network.nix
    ../services/sops.nix
    ../services/wireguard.nix
    ../services/tailscale.nix
    ../services/jellyfin.nix
    ../services/hotspot.nix

    ../hardware/bluetooth.nix
    ../hardware/audioengine.nix
  ];

  networking = {
    hostName = hostname;
    useDHCP = lib.mkDefault true;
  };

  environment.systemPackages =
    (import ./packages.nix { inherit pkgs; }).basePackages;

  programs = {
    zsh.enable = true;
    _1password = {
      enable = true;
      package = pkgs.unstable._1password-cli;
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [ stdenv.cc.cc.lib glibc zlib openssl ];
    };
    # Enable captive browser for dedicated captive portal handling
    captive-browser = {
      enable = true;
      interface = "wlan0"; # Your WiFi interface
    };
  };

  services = {
    chrony.enable = true;
    journald.extraConfig = "SystemMaxUse=250M";
    power-profiles-daemon.enable = false;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Create dirs for home-manager
  systemd.tmpfiles.rules =
    [ "d /nix/var/nix/profiles/per-user/${username} 0755 ${username} root" ];
}
