{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ sketchybar ];

  home.file.".config/sketchybar/sketchybarrc" = {
    text = ''
      #!/bin/bash

      PLUGIN_DIR="$CONFIG_DIR/plugins"

      ##### Bar Appearance #####
      sketchybar --bar position=top height=32 blur_radius=30 color=0x40000000

      ##### Events #####
      sketchybar --add event aerospace_workspace_change

      ##### Defaults #####
      sketchybar --default icon.font="SF Pro:Bold:14.0" \
                           label.font="SF Pro:Medium:13.0" \
                           icon.color=0xffffffff \
                           label.color=0xffffffff \
                           padding_left=5 \
                           padding_right=5

       ##### Workspaces #####
       for i in {1..8}; do
         sketchybar --add item workspace.$i left \
                    --set workspace.$i icon="$i" \
                                      icon.padding_left=8 \
                                      icon.padding_right=8 \
                                      background.corner_radius=6 \
                                      background.height=24 \
                                      background.drawing=off \
                                      script="$PLUGIN_DIR/workspace.sh" \
                                      click_script="aerospace workspace $i" \
                    --subscribe workspace.$i aerospace_workspace_change
       done
       
       # Add a global workspace listener
       sketchybar --add item workspace_listener left \
                  --set workspace_listener drawing=off \
                                          script="$PLUGIN_DIR/workspace.sh" \
                  --subscribe workspace_listener aerospace_workspace_change
      ##### Left Items #####
      sketchybar --add item front_app left \
                 --set front_app icon.drawing=off \
                                 script="$PLUGIN_DIR/front_app.sh" \
                 --subscribe front_app front_app_switched

      ##### Right Items #####
      sketchybar --add item clock right \
                 --set clock update_freq=1 \
                             icon="󰥔" \
                             script="$PLUGIN_DIR/clock.sh" \
                 --add item battery right \
                 --set battery update_freq=120 \
                               script="$PLUGIN_DIR/battery.sh" \
                 --subscribe battery system_woke power_source_change

      # Initialize all items on startup
      "$PLUGIN_DIR/init.sh" &

      # Force update all items
      sketchybar --update
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/workspace.sh" = {
    text = ''
      #!/bin/bash

      # Update all workspaces when triggered
      if [ "$SENDER" = "aerospace_workspace_change" ]; then
        # Get current focused workspace
        CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)
        
        for i in {1..8}; do
          if [ "$i" = "$CURRENT_WORKSPACE" ]; then
            sketchybar --set workspace.$i background.drawing=on \
                                        background.color=0xffffffff \
                                        icon.color=0xff000000
          else
            if aerospace list-windows --workspace "$i" 2>/dev/null | grep -q .; then
              sketchybar --set workspace.$i background.drawing=on \
                                          background.color=0x40ffffff \
                                          icon.color=0xffffffff
            else
              sketchybar --set workspace.$i background.drawing=off \
                                          icon.color=0x80ffffff
            fi
          fi
        done
      else
        # Handle individual workspace updates
        WORKSPACE_NAME="''${NAME#workspace.}"
        CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)

        if [ "$WORKSPACE_NAME" = "$CURRENT_WORKSPACE" ]; then
          sketchybar --set $NAME background.drawing=on \
                             background.color=0xffffffff \
                             icon.color=0xff000000
        else
          if aerospace list-windows --workspace "$WORKSPACE_NAME" 2>/dev/null | grep -q .; then
            sketchybar --set $NAME background.drawing=on \
                               background.color=0x40ffffff \
                               icon.color=0xffffffff
          else
            sketchybar --set $NAME background.drawing=off \
                               icon.color=0x80ffffff
          fi
        fi
      fi
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/front_app.sh" = {
    text = ''
      #!/bin/bash
      sketchybar --set $NAME label="$INFO"
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/clock.sh" = {
    text = ''
      #!/bin/bash
      sketchybar --set $NAME label=" $(date '+%H:%M')"
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/battery.sh" = {
    text = ''
      #!/bin/bash

      PERCENTAGE="$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)"
      CHARGING="$(pmset -g batt | grep 'AC Power')"

      [ "$PERCENTAGE" = "" ] && exit 0

      if [[ $CHARGING != "" ]]; then
        ICON="󰂄"
      elif [ $PERCENTAGE -gt 80 ]; then
        ICON="󰁹"
      elif [ $PERCENTAGE -gt 60 ]; then
        ICON="󰂀"
      elif [ $PERCENTAGE -gt 40 ]; then
        ICON="󰁾"
      elif [ $PERCENTAGE -gt 20 ]; then
        ICON="󰁼"
      else
        ICON="󰁺"
      fi

      sketchybar --set $NAME icon="$ICON" label=" $PERCENTAGE%"
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/init.sh" = {
    text = ''
      #!/bin/bash

      # Wait for sketchybar to be ready
      sleep 1

      # Initialize all items
      export NAME=clock; ~/.config/sketchybar/plugins/clock.sh
      export NAME=battery; ~/.config/sketchybar/plugins/battery.sh
      export NAME=front_app; export INFO="$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null || echo \'\')"; ~/.config/sketchybar/plugins/front_app.sh

      # Trigger workspace update
      sketchybar --trigger aerospace_workspace_change
    '';
    executable = true;
  };
}

