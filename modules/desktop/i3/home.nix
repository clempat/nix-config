{ config, lib, pkgs, ... }:

let 
  mod = "Mod4";
  refresh_i3status = "killall -SIGUSR1 i3status";
  notify_volume = "if amixer get Master | grep -Fq '[off]' ; then volnoti-show -m; else volnoti-show $(amixer get Master | grep -Po '[0-9]+(?=%)' | head -1); fi";
  ws1="1:";
  ws2="2: Sizzy";
  ws3="3: Perso ";
  ws4="4: Pro ";
  ws5="5: Communications";
  ws6="6: Productivity";
  ws7="7: 📢";
  ws8="8";
  ws9="9";
  ws10="10: Music";
in {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;

      fonts = {
        names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
        style = "Bold Semi-Condensed";
        size = 14.0;
      };

      gaps = {
        outer = 1;
        inner = 10;
      };

      startup = [
        { command = "nm-applet"; notification = false; }
        { command = "picom --experimental-backend &"; always = true; notification = false; }
        { command = "xrandr --output eDP-1 --mode 1920x1200"; notification = false; }
        # { command = "xrandr --output eDP-1 --mode 2560x1600"; notification = false; }
        # { command = "bluetoothctl connect dc:d5:1c:52:d7:f8"; always = true; notification = false; } # Autocconect mouse
      ];

      floating = {
        modifier = "${mod}";
      };

      window = {
        hideEdgeBorders = "smart";
        commands = [
          { command = "border pixel 0"; criteria = { class = ".*"; } ; } 
        ];
      };

      colors = {
        focused = { border = "#6272A4"; childBorder = "#6272A4"; background = "#6272A4"; text = "#F8F8F2"; indicator = "#6272A4";};
        focusedInactive = { border = "#44475A"; childBorder = "#44475A"; background = "#44475A"; text = "#F8F8F2"; indicator = "#44475A";};
        unfocused = { border = "#282A36"; childBorder = "#282A36"; background = "#282A36"; text = "#BFBFBF"; indicator = "#282A36";};
        urgent = { border = "#44475A"; childBorder = "#FF5555"; background = "#FF5555"; text = "#F8F8F2"; indicator = "#FF5555";};
        placeholder = { border = "#282A36"; childBorder = "#282A36"; background = "#282A36"; text = "#F8F8F2"; indicator = "#282A36";};
        background = "#F8F8F2";
      };

      assigns = {
        "${ws1}" = [ 
          { class = "Alacrotty"; } 
          { class = "kitty"; } 
          { class = "Konsole"; } 
        ];
        "${ws2}" = [
          { class = "Sizzy"; }
        ];
        "${ws3}" = [
          { class = "firefox"; }
        ];
        "${ws4}" = [
          { class = "Brave-browser"; }
        ];
        "${ws5}" = [
          { class = "Microsoft Teams - Insiders"; }
        ];
        "${ws6}" = [
          { class = "Logseq"; }
          { class = "obisdian"; }
        ];
      };

      keybindings = lib.mkOptionDefault {
        "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${mod}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        "${mod}+x" = "exec sh -c '${pkgs.maim}/bin/maim -s | xclip -selection clipboard -t image/png'";
        "${mod}+Shift+x" = "exec sh -c '${pkgs.i3lock}/bin/i3lock -c 222222 & sleep 5 && xset dpms force of'";
        "${mod}+Shift+c" = "reload";
        "${mod}+Shift+r" = "restart";
        "Print" = "exec --no-startup-id flameshot gui";
        "Shift+Print" = "exec --no-startup-id flameshot full Media player controls";

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

        # Windows
        "${mod}+Shift+q" = "kill";
        "${mod}+f" = "fullscreen toggle";
        "${mod}+Shift+space" = "floating toggle";
        "${mod}+space" = "focus mode_toggle";
        "${mod}+a" = "focus parent";

        # Orientation
        "${mod}+h" = "split h";
        "${mod}+v" = "split v";
        

        # Layout
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";

        # Workspace
        "${mod}+1" = "workspace number ${ws1}";
        "${mod}+2" = "workspace number ${ws2}";
        "${mod}+3" = "workspace number ${ws3}";
        "${mod}+4" = "workspace number ${ws4}";
        "${mod}+5" = "workspace number ${ws5}";
        "${mod}+6" = "workspace number ${ws6}";
        "${mod}+7" = "workspace number ${ws7}";
        "${mod}+8" = "workspace number ${ws8}";
        "${mod}+9" = "workspace number ${ws9}";
        "${mod}+10" = "workspace number ${ws10}";

        "${mod}+Shift+1" = "move container to workspace number ${ws1}";
        "${mod}+Shift+2" = "move container to workspace number ${ws2}";
        "${mod}+Shift+3" = "move container to workspace number ${ws3}";
        "${mod}+Shift+4" = "move container to workspace number ${ws4}";
        "${mod}+Shift+5" = "move container to workspace number ${ws5}";
        "${mod}+Shift+6" = "move container to workspace number ${ws6}";
        "${mod}+Shift+7" = "move container to workspace number ${ws7}";
        "${mod}+Shift+8" = "move container to workspace number ${ws8}";
        "${mod}+Shift+9" = "move container to workspace number ${ws9}";
        "${mod}+Shift+10" = "move container to workspace number ${ws10}";

        # Audio
        XF86AudioRaiseVolume = "exec --no-startup-id \"amixer set Master 5%+ && ${refresh_i3status} && ${notify_volume}\"";
        XF86AudioLowerVolume = "exec --no-startup-id \"amixer set Master 5%- && ${refresh_i3status} && ${notify_volume}\"";
        # gradular volume control
        "${mod}+XF86AudioRaiseVolume" = "exec \"amixer set Master 1%+ && ${refresh_i3status} && ${notify_volume}\"";
        "${mod}+XF86AudioLowerVolume" = "exec \"amixer set Master 1%- && ${refresh_i3status} && ${notify_volume}\"";
        # Mute
        XF86AudioMute = "exec --no-startup-id \"amixer set Master toggle && ${refresh_i3status} && ${notify_volume}\"";

        # Light
        XF86MonBrightnessUp = "exec --no-startup-id light -A 10";
        XF86MonBrightnessDown = "exec --no-startup-id light -U 10";

        # gradular volume control
        "${mod}+XF86MonBrightnessUp" = "exec --no-startup-id light -A 1";
        "${mod}+XF86MonBrightnessDown" = "exec --no-startup-id light -U 1";

      };

    };
  };

  programs.i3status = {
    enable = true;
    modules = {
      "volume master" = {
        position = 1;
        settings = {
          format = "♪ %volume";
          format_muted = "♪ muted (%volume)";
          device = "default";
        };
      };
    };
  };
}
