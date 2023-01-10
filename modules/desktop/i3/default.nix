{ config, lib, pkgs, inputs, user, ... }:

{
  services = {
    gnome.gnome-keyring.enable = true;
    picom = {
      enable = true;
      vSync = true;
      shadowExclude = [
        "class_g = 'firefox' && argb"
      ];
      settings = {
        corner-radius = 16;
        blur =
          {
            method = "dual_kawase";
            strength = 5;
          };
        use-damage = "false";
      };
      fade = true;
      fadeSteps = [
        0.07
        0.07
      ];
      wintypes = {
        normal = { blur-background = true; };
        spash = { blur-background = false; };
      };
      backend = "glx";
      opacityRules = [
        "80:class_g = 'kitty'"
      ];
    };
    xserver = {
      enable = true;

      layout = "us";
      xkbVariant = "altgr-intl";
      xkbOptions = "eurosign:e";
      libinput.enable = true;

      desktopManager = {
        wallpaper.mode = "fill";
        xterm.enable = false;
        plasma5 = {
          enable = true;
        };
      };

      displayManager = {
        lightdm = {
          enable = true;
          background = ../../themes/backgrounds/1.png;
          greeter.enable = true;
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

  environment.pathsToLink = [ "/libexec" ];

  # Required for flatpak with windowmanagers
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
