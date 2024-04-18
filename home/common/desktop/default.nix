{ pkgs, desktop, ... }: {
  imports = [
    (./. + "/${desktop}")

    ../dev

    ./firefox
    ./kitty
    ./alacritty.nix
    ./gtk.nix
    ./qt.nix
    ./xdg.nix
    ./zathura.nix
  ];

  home.packages = with pkgs; [
    audacity
    catppuccin-gtk
    desktop-file-utils
    ght
    libnotify
    loupe
    mumble
    obsidian
    pamixer
    pavucontrol
    rambox
    signal-desktop
    todoist-electron
    xdg-utils
    xorg.xlsclients
  ];

  fonts.fontconfig.enable = true;
}
