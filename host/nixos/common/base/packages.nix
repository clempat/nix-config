{ pkgs, ... }:
{
  basePackages = with pkgs.unstable; [
    # openai-whisper
    # terminal-notifier
    _1password-cli
    alacritty
    alsa-utils
    bat
    binutils
    code-cursor
    curl
    cp210x-program
    devbox
    dig
    dua
    duf
    eza
    fabric-ai
    fd
    file
    gcc
    git
    gnumake
    jq
    killall
    libcec
    neovim
    nfs-utils
    ntfs3g
    openai
    pciutils
    rclone
    ripgrep
    rsync
    sesh
    sox
    tpm2-tss
    traceroute
    tree
    unzip
    usbutils
    wget
    yazi
    yq-go
  ];
}
