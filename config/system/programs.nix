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
    go
    go-task
    hyprshade
    killall
    kubectl
    kubectl-tree
    kubernetes-helm
    kustomize
    gnome.gnome-keyring
    # libsForQt5.kwallet
    # libsForQt5.kwallet-pam
    # libsForQt5.kwalletmanager
    polkit_gnome
    ripgrep
    sops
  ];
}
