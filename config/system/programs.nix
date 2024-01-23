{ pkgs, config, ... }:

{
  imports = [
    ./programs/_1password.nix
  ];

  # List System Programs
  environment.systemPackages = with pkgs; [
    ansible
    cmake
    dnsutils
    esphome
    esptool
    fd
    fluxcd
    fzf
    gcc
    gitleaks
    gnome.gnome-keyring
    go
    go-task
    hyprshade
    killall
    kubectl
    kubectl-tree
    kubernetes-helm
    kustomize
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5.qtgraphicaleffects
    nextcloud-client
    polkit_gnome
    ripgrep
    sops
  ];
}
