{ config, lib, pkgs, user, ... }:

{
  imports = [
    ../../modules/desktop/i3/home.nix
  ];

  programs.git.signing.key = "2EF9A6A5B3AB6D76";

  services.fusuma = {
    enable = true;
    extraPackages = with pkgs; [ coreutils-full xdotool i3-gaps ];
    settings = {
      swipe = {
        "3" = {
          left = {
            command = "xdotool key alt+Right";
          };
          right = {
            command = "xdotool key alt+Left";
          };
          up = {
            command = "exec i3 focus down";
          };
          down = {
            command = "exec i3 focus up";
          };
        };
        "4" = {
          left = {
            command = "exec i3 workspace next";
          };
          right = {
            command = "exec i3 workspace prev";
          };
          up = {
            command = "exec i3 fullscreen toggle";
          };
          down = {
            command = "exec i3 floating toggle";
          };
        };
      };
      pinch = {
        "in" = {
          command = "xdotool key ctrl+plus";
        };
        "out" = {
          command = "xdotool key ctrl+shift+minus";
        };
      };
      threshold = {
        swipe = 0.4;
        pinch = 0.4;
      };
      interval = {
        swipe = 0.8;
        pinch = 0.8;
      };
    };
  };

  #services = {                            # Applets
  #  blueman-applet.enable = true;         # Bluetooth
  #};

}
