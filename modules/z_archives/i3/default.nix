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

  programs.xss-lock = {
    enable = true;
    lockerCommand = "${pkgs.betterlockscreen}/bin/betterlockscreen -l blur";
    # Not running inside a display manager, XDG_SEAT_PATH not defined
    # lockerCommand = "${pkgs.lightdm}/bin/dm-tool switch-to-greeter";
    # lockerCommand = "/run/current-system/sw/bin/dm-tool switch-to-greeter";
  };

  environment.systemPackages = with pkgs; [
    xclip
    rofi
    rofi-calc
    rofi-emoji
    i3status
    i3blocks-gaps
    betterlockscreen
    maim
  ];

  environment.pathsToLink = [ "/libexec" ];
}
