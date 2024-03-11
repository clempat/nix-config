{ pkgs, ... }: {
  basePackages = with pkgs; [
    _1password
    bat
    binutils
    curl
    dig
    dua
    duf
    fd
    file
    git
    jq
    killall
    neovim
    nfs-utils
    ntfs3g
    pciutils
    ripgrep
    rsync
    tpm2-tss
    traceroute
    tree
    unstable.eza
    unzip
    usbutils
    wget
    yq-go
  ];
}
