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
    beeper
    brave
    catppuccin-gtk
    chromium
    desktop-file-utils
    devpod-desktop
    discord
    element-desktop
    figma-linux
    inputs.zen-browser.packages."${system}".default
    libnotify
    libreoffice
    # using EOL electron
    # logseq
    loupe
    mumble
    nextcloud-client
    obsidian
    pamixer
    pavucontrol
    signal-desktop
    ultrastar-manager
    ultrastardx
    sqlite
    todoist-electron
    vlc
    warp-terminal
    wireguard-ui
    xdg-utils
    xorg.xlsclients
  ];

  fonts.fontconfig.enable = true;
}
