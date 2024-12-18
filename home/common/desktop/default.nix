{ pkgs, desktop, inputs, system, ... }: {
  imports = [
    (./. + "/${desktop}")

    ../dev

    ./firefox
    ./kitty
    ./alacritty.nix
    # ./gtk.nix
    # ./qt.nix
    # ./xdg.nix
    # ./zathura.nix
  ];

  home.packages = with pkgs; [
    # rambox
    alpaca
    audacity
    brave
    catppuccin-gtk
    chromium
    desktop-file-utils
    discord
    element-desktop
    inputs.zen-browser.packages."${system}".default
    libnotify
    libreoffice
    logseq
    loupe
    mumble
    nextcloud-client
    obsidian
    pamixer
    pavucontrol
    signal-desktop
    sqlite
    tailscale-systray
    todoist-electron
    vlc
    warp-terminal
    xdg-utils
    xorg.xlsclients
  ];

  fonts.fontconfig.enable = true;
}
