{ hostname, pkgs, lib, username, ... }: {
  imports = [
    ./boot.nix
    ./console.nix
    ./hardware.nix
    ./locale.nix
    ./zramswap.nix

    ../services/avahi.nix
    ../services/firewall.nix
    ../services/openssh.nix
    ../services/network.nix
    ../services/sops.nix

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
  };

  services = {
    chrony.enable = true;
    journald.extraConfig = "SystemMaxUse=250M";
    flatpak.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  # Create dirs for home-manager
  systemd.tmpfiles.rules =
    [ "d /nix/var/nix/profiles/per-user/${username} 0755 ${username} root" ];
}
