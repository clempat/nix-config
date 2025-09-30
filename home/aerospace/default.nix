{ config, lib, pkgs, ... }:
let
  # Script to get appropriate top gap based on display resolution
  getTopGap = pkgs.writeShellScript "get-top-gap" ''
    # Get main display resolution
    RESOLUTION=$(system_profiler SPDisplaysDataType | grep Resolution | head -1 | awk '{print $2}')

    # If builtin display (typical resolutions: 2560, 3024, etc.)
    if [[ "$RESOLUTION" =~ ^(2560|3024|3456) ]]; then
      echo "35"  # Less padding for builtin high-res display
    else
      echo "45"  # More padding for external displays
    fi
  '';
in {
  xdg.configFile."aerospace/aerospace.toml" = let
    sketchybar = lib.getExe pkgs.sketchybar;
    aerospace-settings = {
      # managed by nix-darwin
      start-at-login = false;
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      key-mapping.preset = "qwerty";

      automatically-unhide-macos-hidden-apps = true;
      after-startup-command = [
        "move-workspace-to-monitor --workspace 6 --wrap-around next"
        "workspace 1"
      ];

      workspace-to-monitor-force-assignment = {
        "1" = [ "dell" ];
        "2" = [ "dell" ];
        "3" = [ "dell" ];
        "4" = [ "builtin" ];
        "5" = [ "builtin" ];
        "6" = [ "builtin" ];
      };

      exec-on-workspace-change = [
        "/bin/bash"
        "-c"
        "${sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
        "&"
        "/bin/bash"
        "-c"
        "${config.xdg.configFile."aerospace/pip-move.sh".source}"
      ];

      on-focus-changed =
        [ "exec-and-forget ${sketchybar} --trigger aerospace_focus_change" ];
      on-window-detected = [
        {
          "if".app-name-regex-substring =
            "zen|arc|dia|firefox|brave|chromium|google-chrome";
          "if".window-title-regex-substring = "(?!Picture-in-Picture)";
          run = [ "move-node-to-workspace 2" ];
        }
        {
          "if".app-name-regex-substring =
            "kitty|ghostty|alacritty|terminal|wezterm|warp";
          run = [ "move-node-to-workspace 1" ];
        }
        {
          "if".app-name-regex-substring = "home assistant";
          run = [ "layout floating" ];
        }
        {
          "if".app-name-regex-substring = "home assistant";
          run = [ "move-node-to-workspace 8" ];
        }
        {
          "if".app-name-regex-substring = "1password";
          run = [ "layout floating" ];
        }
        {
          "if".app-id = "com.raycast.macos";
          "if".window-title-regex-substring = "AI Chat";
          run = [ "layout tiling" ];
        }
        {
          "if".window-title-regex-substring = "Picture-in-Picture";
          run = [ "layout floating" ];
        }
      ];

      gaps = {
        inner.horizontal = 10;
        inner.vertical = 10;
        outer.left = 5;
        outer.bottom = 5;
        outer.top = 40; # Reduced from 45 - better for builtin display
        outer.right = 5;
      };
      # 'main' binding mode declaration
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      # 'main' binding mode must be always presented
      # Fallback value (if you omit the key): mode.main.binding = {}
      mode.main.binding = {
        # All possible keys:
        # - Letters.        a, b, c, ..., z
        # - Numbers.        0, 1, 2, ..., 9
        # - Keypad numbers. keypad0, keypad1, keypad2, ..., keypad9
        # - F-keys.         f1, f2, ..., f20
        # - Special keys.   minus, equal, period, comma, slash, backslash, quote, semicolon, backtick,
        #                   leftSquareBracket, rightSquareBracket, space, enter, esc, backspace, tab
        # - Keypad special. keypadClear, keypadDecimalMark, keypadDivide, keypadEnter, keypadEqual,
        #                   keypadMinus, keypadMultiply, keypadPlus
        # - Arrows.         left, down, up, right

        # All possible modifiers: cmd, alt, ctrl, shift

        # All possible commands: https://nikitabobko.github.io/AeroSpace/commands

        # cmd-enter = let
        #   script = pkgs.writeText "ghostty.applescript" ''
        #     tell application "Ghostty"
        #       if it is running then
        #         activate
        #         tell application "System Events" to keystroke "n" using {command down}
        #       else
        #         activate
        #       end if
        #     end tell
        #   '';
        # in "exec-and-forget osascript ${script}";

        cmd-q = "close";

        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        alt-f = [ "layout tiles floating" ];
        alt-q = [ "layout tiles accordion" ];
        alt-v = [ "join-with left" ];

        # See: https://nikitabobko.github.io/AeroSpace/commands#focus
        cmd-left = "focus left";
        cmd-down = "focus down";
        cmd-up = "focus up";
        cmd-right = "focus right";

        # See: https://nikitabobko.github.io/AeroSpace/commands#move
        cmd-shift-h = "move left";
        cmd-shift-j = "move down";
        cmd-shift-k = "move up";
        cmd-shift-l = "move right";

        cmd-m = "focus-monitor --wrap-around next";
        cmd-shift-m = "move-node-to-monitor --wrap-around next";

        # See: https://nikitabobko.github.io/AeroSpace/commands#resize
        cmd-shift-minus = "resize smart -50";
        cmd-shift-equal = "resize smart +50";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        cmd-tab = "workspace-back-and-forth";
        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        cmd-shift-tab = "move-workspace-to-monitor --wrap-around next";

        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        cmd-shift-semicolon = "mode service";
      } // (lib.lists.foldl' (acc: letter:
        acc // {
          # See: https://nikitabobko.github.io/AeroSpace/commands#workspace
          "cmd-${lib.strings.toLower letter}" = "workspace ${letter}";
          # See: https://nikitabobko.github.io/AeroSpace/commands#move-node-to-workspace
          "cmd-shift-${lib.strings.toLower letter}" =
            "move-node-to-workspace ${letter}";
        }) { } (lib.strings.stringToCharacters "123456789"));

      # 'service' binding mode declaration.
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      mode.service.binding = {
        esc = [ "reload-config" "mode main" ];
        r = [ "flatten-workspace-tree" "mode main" ]; # reset layout
        f = [
          "layout floating tiling"
          "mode main"
        ]; # Toggle between floating and tiling layout
        backspace = [ "close-all-windows-but-current" "mode main" ];

        # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
        # s = ["layout sticky tiling" "mode main"];

        cmd-shift-h = [ "join-with left" "mode main" ];
        cmd-shift-j = [ "join-with down" "mode main" ];
        cmd-shift-k = [ "join-with up" "mode main" ];
        cmd-shift-l = [ "join-with right" "mode main" ];
        cmd-shift-f = [ "fullscreen" "mode main" ];

        # 1080p streaming window
        s = let
          script = pkgs.writeText "resize-1080p.applescript" ''
            tell application "System Events"
              set frontApp to name of first application process whose frontmost is true
              tell application process frontApp
                set frontWindow to front window
                set position of frontWindow to {100, 100}
                set size of frontWindow to {1920, 1080}
              end tell
            end tell
          '';
        in [
          "layout floating"
          "exec-and-forget osascript ${script}"
          "mode main"
        ];

        down = "volume down";
        up = "volume up";
        shift-down = [ "volume set 0" "mode main" ];
      };
    };
    format = pkgs.formats.toml { };
  in {
    source = (format.generate "aerospace.toml" aerospace-settings);
    onChange = "${lib.getExe pkgs.aerospace} reload-config";
  };
  xdg.configFile."aerospace/pip-move.sh" = {
    text = ''
      #!/bin/bash
      # Move Picture-in-Picture window to the current focused workspace
      CURRENT_WORKSPACE="''${AEROSPACE_FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

      # Move the Picture-in-Picture window to the current workspace
      "${pkgs.aerospace}/bin/aerospace" move-node-to-workspace "$CURRENT_WORKSPACE" --window-title-regex-substring "Picture-in-Picture"
    '';
    executable = true;
  };
}
