{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ sketchybar ];

  home.file.".config/sketchybar/sketchybarrc" = {
    text = ''
      #!/bin/bash

      CONFIG_DIR="$HOME/.config/sketchybar"
      PLUGIN_DIR="$CONFIG_DIR/plugins"

      ##### Bar Appearance #####
      sketchybar --bar position=top height=32 blur_radius=30 color=0x40000000

      ##### Events #####
      sketchybar --add event aerospace_workspace_change
      sketchybar --add event aerospace_focus_change

      ##### Defaults #####
      sketchybar --default icon.font="GeistMono Nerd Font:Bold:14.0" \
                           label.font="GeistMono Nerd Font:Medium:14.0" \
                           icon.color=0xffffffff \
                           label.color=0xffffffff \
                           padding_left=5 \
                           padding_right=15

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
                 --subscribe front_app front_app_switched aerospace_focus_change

      ##### Right Items #####
      sketchybar --add item clock right \
                 --set clock update_freq=1 \
                             icon="󰥔" \
                             icon.padding_right=4 \
                             script="$PLUGIN_DIR/clock.sh" \
                 --add item battery right \
                 --set battery update_freq=120 \
                               icon.padding_right=4 \
                               script="$PLUGIN_DIR/battery.sh" \
                 --subscribe battery system_woke power_source_change

        # CPU and Memory
        sketchybar --add item cpu right \
                   --set cpu update_freq=5 \
                               icon="" \
                               icon.padding_right=4 \
                               script="$PLUGIN_DIR/cpu.sh" \
                   --add item mem right \
                   --set mem update_freq=5 \
                               icon="󰍛" \
                               icon.padding_right=4 \
                               script="$PLUGIN_DIR/mem.sh"

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
        # Use passed environment variable or fallback to aerospace command
        CURRENT_WORKSPACE="''${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"
        
        # Exit if we can't determine current workspace
        [ -z "$CURRENT_WORKSPACE" ] && exit 0
        
        for i in {1..8}; do
          if [ "$i" = "$CURRENT_WORKSPACE" ]; then
            sketchybar --set workspace.$i background.drawing=on \
                                        background.color=0xffffffff \
                                        icon.color=0xff000000
          else
            # Check if workspace has windows with error handling
            if command -v aerospace >/dev/null 2>&1 && aerospace list-windows --workspace "$i" 2>/dev/null | grep -q .; then
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
        CURRENT_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
        
        # Exit if we can't determine current workspace
        [ -z "$CURRENT_WORKSPACE" ] && exit 0

        if [ "$WORKSPACE_NAME" = "$CURRENT_WORKSPACE" ]; then
          sketchybar --set $NAME background.drawing=on \
                             background.color=0xffffffff \
                             icon.color=0xff000000
        else
          # Check if workspace has windows with error handling
          if command -v aerospace >/dev/null 2>&1 && aerospace list-windows --workspace "$WORKSPACE_NAME" 2>/dev/null | grep -q .; then
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
      sketchybar --set $NAME label="$(date '+%H:%M')"
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

      sketchybar --set $NAME icon="$ICON" label="$PERCENTAGE%"
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/cpu.sh" = {
    text = ''
      #!/bin/bash
      CPU_USAGE=$(ps -A -o %cpu | awk '{s+=$1} END {print s}')
      CPU_LABEL=$(printf "%.1f%%" "$CPU_USAGE")
      sketchybar --set $NAME label="$CPU_LABEL"
    '';
    executable = true;
  };

  home.file.".config/sketchybar/plugins/mem.sh" = {
    text = ''
      #!/bin/bash
      MEM_USED=$(vm_stat | awk '/Pages active/ {active=$3} /Pages wired down/ {wired=$4} /Pages occupied by compressor/ {compressed=$5} /Pages speculative/ {speculative=$3} /Pages free/ {free=$3} END {used=active+wired+compressed+speculative; total=used+free; printf "%.1f", used/total*100}')
      sketchybar --set $NAME label="$MEM_USED%"
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

