{ pkgs, ... }: {
  basePackages = with pkgs; [
    _1password-cli
    alacritty
    alsa-utils
    bat
    binutils
    code-cursor
    curl
    devbox
    dig
    dua
    duf
    eza
    fabric-ai
    fd
    file
    git
    gcc
    gnumake
    jq
    killall
    libcec
    neovim
    sox
    nfs-utils
    ntfs3g
    openai
    # openai-whisper
    pciutils
    ripgrep
    rsync
    rclone
    sesh
    # terminal-notifier
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
