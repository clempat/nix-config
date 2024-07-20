{ pkgs, desktop, ... }: {
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
    catppuccin-gtk
    desktop-file-utils
    libnotify
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
  ];

  fonts.fontconfig.enable = true;
}
