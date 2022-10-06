{ config, lib, pkgs, ... }:

let 
  mod = "Mod4";
in {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;

      fonts = {
        names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
        style = "Bold Semi-Condensed";
        size = 11.0;
      };

      keybindings = lib.mkOptionDefault {
        "$mod+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${mod}+p" = "exec ${pkgs.rofi}/bin/rofi";
        "${mod}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
        "${mod}+Shift+x" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";

        # Focus
        "${mod}+j" = "focus left";
        "${mod}+k" = "focus down";
        "${mod}+l" = "focus up";
        "${mod}+semicolon" = "focus right";

        # Move
        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+semicolon" = "move right";
      };

    };
  };
}
