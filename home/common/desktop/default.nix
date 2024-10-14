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
    audacity
    brave
    catppuccin-gtk
    chromium
    desktop-file-utils
    libnotify
    logseq
    loupe
    mumble
    obsidian
    pamixer
    pavucontrol
    rambox
    signal-desktop
    sqlite
    todoist-electron
    vlc
    xdg-utils
    xorg.xlsclients
    warp-terminal
    inputs.zen-browser.packages."${system}".default
  ];

  fonts.fontconfig.enable = true;
}
