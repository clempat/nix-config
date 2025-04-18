{ pkgs, ... }:

{
  services.yabai = {
    enable = true;
    enableScriptingAddition = false;
    extraConfig = ''
            yabai -m space 1 --label Code
            yabai -m space 2 --label View
            yabai -m space 3 --label Browser
            yabai -m space 4 --label four
            yabai -m space 5 --label Communication
            yabai -m space 6 --label Misc

      # apps to not manage (ignore)
            yabai -m rule --add app="^System Settings$" manage=off
            yabai -m rule --add app="^Archive Utility$" manage=off
            yabai -m rule --add app="^balenaEtcher$" manage=off
            yabai -m rule --add app="^Creative Cloud$" manage=off
            yabai -m rule --add app="^Logi Options$" manage=off
            yabai -m rule --add app="^Alfred Preferences$" manage=off
            yabai -m rule --add app="Raycast" manage=off
            yabai -m rule --add app="^Music$" sticky=on layer=above manage=off
            yabai -m rule --add app="^Podcasts$" sticky=on layer=above manage=off
            yabai -m rule --add app="^Maps$" sticky=on layer=above manage=off
            yabai -m rule --add app="^Karabiner-Elements$" sticky=on layer=above manage=off
            yabai -m rule --add app="^Finder$" sticky=on layer=above manage=off
            yabai -m rule --add app="^Alfred Preferences$" sticky=on layer=above manage=off
            yabai -m rule --add app="^Disk Utility$" sticky=on layer=above manage=off
            yabai -m rule --add app="^Logi Options$" manage=off
            yabai -m rule --add app="^Signal$" sticky=on layer=above manage=off
            yabai -m rule --add app="^CleanShot X$" sticky=on layer=above manage=off
            yabai -m rule --add app="^Home Assistant$" sticky=on layer=above manage=off
            yabai -m rule --add app="^Cypress$" sticky=on layer=above manage=off
            yabai -m rule --add subrole="^AXSystemDialog$" sticky=on layer=above manage=off
            yabai -m rule --add subrole="^1Password$" sticky=on layer=above manage=off
            yabai -m rule --add app="^Arc$" title="^Space.*$" manage=off layer=below
            yabai -m rule --add app="^Arc$" title="^$" manage=off layer=below
            yabai -m rule --add app="^CleanShot X$" sticky=on layer=above manage=off
            yabai -m rule --add app="^Todoist$" sticky=on layer=above manage=off

      # yabai -m config external_bar                 all:27:0
            yabai -m config mouse_follows_focus          off
            yabai -m config focus_follows_mouse          autofocus #autofocus,autoraise
            yabai -m config window_placement             second_child
            yabai -m config window_shadow                off
            yabai -m config window_opacity               on
            yabai -m config window_opacity_duration      0.0
            yabai -m config active_window_opacity        1
            yabai -m config normal_window_opacity        0.90

      # window border
            yabai -m config window_border off
            yabai -m config window_border_width 3
            yabai -m config active_window_border_color 0xFF6faec0
            yabai -m config normal_window_border_color 0xFF3e4050
            yabai -m config insert_feedback_color        0xffd75f5f

            yabai -m config split_ratio                  0.50
            yabai -m config auto_balance                 off
            yabai -m config mouse_modifier               fn
            yabai -m config mouse_action1                move
            yabai -m config mouse_action2                resize

      # window gaps
            yabai -m config layout                     bsp
            yabai -m config top_padding                8
            yabai -m config bottom_padding             8
            yabai -m config left_padding               8
            yabai -m config right_padding              8
            yabai -m config window_gap                 8

      # notify when the yabai config finished loading
            echo "yabai configuration loaded.."
    '';
  };
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # open terminal
      # cmd - return : /Applications/Kitty.app/Contents/MacOS/kitty --single-instance -d ~
      # focus window
      alt - j : yabai -m window --focus west
      alt - k : yabai -m window --focus south
      # alt - i : yabai -m window --focus north
      alt - l : yabai -m window --focus east
      # swap window
      shift + alt - j : yabai -m window --swap west
      shift + alt - k : yabai -m window --swap south
      shift + alt - i : yabai -m window --swap north
      shift + alt - l : yabai -m window --swap east
      # move window
      shift + cmd - j : yabai -m window --warp west
      shift + cmd - k : yabai -m window --warp south
      shift + cmd - i : yabai -m window --warp north
      shift + cmd - l : yabai -m window --warp east
      # balance size of windows
      shift + alt - 0 : yabai -m space --balance
      # make floating window fill screen
      shift + alt - up     : yabai -m window --grid 1:1:0:0:1:1
      # make floating window fill left-half of screen
      shift + alt - left   : yabai -m window --grid 1:2:0:0:1:1
      # make floating window fill right-half of screen
      shift + alt - right  : yabai -m window --grid 1:2:1:0:1:1
      # create desktop, move window and follow focus - uses jq for parsing json (brew install jq)
      shift + cmd - n : yabai -m space --create && \
                        index="$(yabai -m query --spaces --display | jq 'map(select(."native-fullscreen" == 0))[-1].index')" && \
                        yabai -m window --space "''\'''${index}" && \
                        yabai -m space --focus "''\'''${index}"
      # create desktop and follow focus - uses jq for parsing json (brew install jq)
      cmd + alt - n : yabai -m space --create && \
                      index="$(yabai -m query --spaces --display | jq 'map(select(."native-fullscreen" == 0))[-1].index')" && \
                      yabai -m space --focus "''\'''${index}"
      # destroy desktop
      cmd + alt - w : yabai -m space --destroy
      # fast focus desktop
      cmd + alt - x : yabai -m space --focus recent
      cmd + alt - z : yabai -m space --focus prev
      cmd + alt - c : yabai -m space --focus next
      #cmd - 1 : yabai -m space --focus 1
      #cmd - 2 : yabai -m space --focus 2
      #cmd - 3 : yabai -m space --focus 3
      #cmd - 4 : yabai -m space --focus 4
      #cmd - 5 : yabai -m space --focus 5
      #cmd - 6 : yabai -m space --focus 6
      #cmd - 7 : yabai -m space --focus 7
      #cmd - 8 : yabai -m space --focus 8
      #cmd - 9 : yabai -m space --focus 9
      #cmd - 0 : yabai -m space --focus 10
      # send window to desktop and follow focus
      shift + cmd - x : yabai -m window --space recent; yabai -m space --focus recent
      shift + cmd - z : yabai -m window --space prev; yabai -m space --focus prev
      # shift + cmd - c : yabai -m window --space next; yabai -m space --focus next
      shift + cmd - 1 : yabai -m window --space  1; yabai -m space --focus 1
      shift + cmd - 2 : yabai -m window --space  2; yabai -m space --focus 2
      shift + cmd - 3 : yabai -m window --space  3; yabai -m space --focus 3
      #shift + cmd - 4 : yabai -m window --space  4; yabai -m space --focus 4
      #shift + cmd - 5 : yabai -m window --space  5; yabai -m space --focus 5
      #shift + cmd - 6 : yabai -m window --space  6; yabai -m space --focus 6
      #shift + cmd - 7 : yabai -m window --space  7; yabai -m space --focus 7
      #shift + cmd - 8 : yabai -m window --space  8; yabai -m space --focus 8
      #shift + cmd - 9 : yabai -m window --space  9; yabai -m space --focus 9
      #shift + cmd - 0 : yabai -m window --space 10; yabai -m space --focus 10
      # focus monitor
      ctrl + alt - x  : yabai -m display --focus recent
      ctrl + alt - z  : yabai -m display --focus prev
      ctrl + alt - c  : yabai -m display --focus next
      ctrl + alt - 1  : yabai -m display --focus 1
      ctrl + alt - 2  : yabai -m display --focus 2
      ctrl + alt - 3  : yabai -m display --focus 3
      # move window
      shift + ctrl - a : yabai -m window --move rel:-20:0
      shift + ctrl - s : yabai -m window --move rel:0:20
      shift + ctrl - w : yabai -m window --move rel:0:-20
      shift + ctrl - d : yabai -m window --move rel:20:0
      # increase window size
      # shift + alt - a : yabai -m window --resize left:-20:0
      # shift + alt - s : yabai -m window --resize bottom:0:20
      # shift + alt - w : yabai -m window --resize top:0:-20
      # shift + alt - d : yabai -m window --resize right:20:0
      # decrease window size
      # shift + cmd - a : yabai -m window --resize left:20:0
      # shift + cmd - s : yabai -m window --resize bottom:0:-20
      # shift + cmd - w : yabai -m window --resize top:0:20
      # shift + cmd - d : yabai -m window --resize right:-20:0
      # set insertion point in focused container
      ctrl + alt - h : yabai -m window --insert west
      ctrl + alt - j : yabai -m window --insert south
      ctrl + alt - k : yabai -m window --insert north
      ctrl + alt - l : yabai -m window --insert east
      # rotate tree
      alt - r : yabai -m space --rotate 90
      # mirror tree y-axis
      alt - y : yabai -m space --mirror y-axis
      # mirror tree x-axis
      alt - x : yabai -m space --mirror x-axis
      # toggle desktop offset
      # alt - a : yabai -m space --toggle padding; yabai -m space --toggle gap
      # toggle window parent zoom
      alt - d : yabai -m window --toggle zoom-parent
      # toggle window fullscreen zoom
      alt - f : yabai -m window --toggle zoom-fullscreen
      # toggle window native fullscreen
      shift + alt - f : yabai -m window --toggle native-fullscreen
      # toggle window border
      shift + alt - b : yabai -m window --toggle border
      # toggle window split type
      # alt - e : yabai -m window --toggle split
      # float / unfloat window and center on screen
      alt - t : yabai -m window --toggle float;\
                yabai -m window --grid 4:4:1:1:2:2
      # toggle sticky (show on all spaces)
      alt - s : yabai -m window --toggle sticky
      # toggle topmost (keep above other windows)
      # alt - o : yabai -m window --toggle topmost
      # toggle sticky, topmost and resize to picture-in-picture size
      alt - p : yabai -m window --toggle sticky;\
                yabai -m window --toggle topmost;\
                yabai -m window --grid 5:5:4:0:1:1
      # change layout of desktop
      ctrl + alt - a : yabai -m space --layout bsp
      ctrl + alt - d : yabai -m space --layout float
      :: passthrough
      ctrl + cmd - p ; passthrough
      passthrough < ctrl + cmd - p ; default
      # open iTerm with Ctrl+Alt+T
      ctrl + alt - t : /Applications/iTerm.app/Contents/MacOS/iTerm2
      # lock screen with Cmd+L
      # cmd - l : /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
    '';
  };
}
