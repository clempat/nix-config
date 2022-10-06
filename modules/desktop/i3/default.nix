{config, lib, pkgs, inputs, user,...}:

{
  services = {
    xserver = {
      enable = true;

      layout = "us";
      xkbOptions = "eurosign:e";
      libinput.enable = true;

      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
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

      videoDrivers = [
        "nvidia"
      ];

    };

  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    xclip
    rofi
    i3status
    i3lock
    i3blocks-gaps
  ];

  environment.pathsToLink = ["/libexec"];

  # Required for flatpak with windowmanagers
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
