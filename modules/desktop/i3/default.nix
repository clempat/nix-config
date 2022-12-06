{config, lib, pkgs, inputs, user,...}:

{
  services = {
    gnome.gnome-keyring.enable = true;
    picom.enable = true;
    xserver = {
      enable = true;

      layout = "us";
      xkbVariant = "altgr-intl";
      xkbOptions = "eurosign:e";
      libinput.enable = true;

      desktopManager = {
        xterm.enable = false;
        plasma5 = {
          enable = true;
        };
      };

      displayManager = {
        lightdm = {
          enable = true;
          background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
          greeters = {
            gtk = {
              theme = {
                name = "Dracula";
                package = pkgs.dracula-theme;
              };
              cursorTheme = {
                name = "Dracula-cursors";
                package = pkgs.dracula-theme;
                size = 16;
              };
            };
          };
        };
        defaultSession = "none+i3";
      };

      windowManager = {
        i3 = {
          enable = true;
          package = pkgs.i3-gaps;
        };
      };

    };

  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    xclip
    rofi
    i3status
    i3lock
    i3blocks-gaps
    maim
  ];

  environment.pathsToLink = ["/libexec"];

  # Required for flatpak with windowmanagers
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
