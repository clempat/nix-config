{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    sketchybar
    python3
  ];

  home.file.".config/sketchybar/sketchybarrc" = {
    text = ''
      #!/bin/bash

      CONFIG_DIR="$HOME/.config/sketchybar"
      PLUGIN_DIR="$CONFIG_DIR/plugins"

      # sketchybar runs with a minimal PATH
      export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

      ##### Bar Appearance #####
      sketchybar --bar position=top height=38 blur_radius=50 color=0x30000000

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
       WORKSPACE_ICONS=("" "" "3" "4" "󰭹" "6" "7" "8")
       
       for i in {1..8}; do
         icon_index=$((i-1))
         sketchybar --add item workspace.$i left \
                    --set workspace.$i icon="''${WORKSPACE_ICONS[$icon_index]}" \
                                      icon.padding_left=8 \
                                      icon.padding_right=8 \
                                      background.corner_radius=8 \
                                      background.height=28 \
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
       sketchybar --add item separator_left left \
                  --set separator_left icon="│" \
                                      icon.color=0x60ffffff \
                                      background.drawing=off \
                                      label.drawing=off
                                      
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
                                        background.color=0xff00FFFF \
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
                             background.color=0xff00FFFF \
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

  home.file.".config/sketchybar/plugins/ai_usage.sh" = {
    text = ''
      #!/bin/bash
      set -euo pipefail

      # SketchyBar runs via launchd; PATH often missing brew/nix.
      export PATH="/opt/homebrew/bin:/usr/local/bin:/etc/profiles/per-user/$USER/bin:$PATH"

      provider="''${1:-}"
      case "$provider" in
        codex|claude|antigravity) ;;
        *) provider="codex" ;;
      esac

      NAME="''${NAME:-ai_usage}"

      codexbar_bin=""
      if command -v codexbar >/dev/null 2>&1; then
        codexbar_bin="$(command -v codexbar)"
      elif [ -x "/opt/homebrew/bin/codexbar" ]; then
        codexbar_bin="/opt/homebrew/bin/codexbar"
      elif [ -x "/usr/local/bin/codexbar" ]; then
        codexbar_bin="/usr/local/bin/codexbar"
      elif command -v CodexBar >/dev/null 2>&1; then
        codexbar_bin="$(command -v CodexBar)"
      elif [ -x "/opt/homebrew/bin/CodexBar" ]; then
        codexbar_bin="/opt/homebrew/bin/CodexBar"
      elif [ -x "/Applications/CodexBar.app/Contents/MacOS/CodexBar" ]; then
        codexbar_bin="/Applications/CodexBar.app/Contents/MacOS/CodexBar"
      elif [ -x "$HOME/Applications/CodexBar.app/Contents/MacOS/CodexBar" ]; then
        codexbar_bin="$HOME/Applications/CodexBar.app/Contents/MacOS/CodexBar"
      elif [ -x "/opt/homebrew/Caskroom/codexbar/latest/CodexBar.app/Contents/MacOS/CodexBar" ]; then
        codexbar_bin="/opt/homebrew/Caskroom/codexbar/latest/CodexBar.app/Contents/MacOS/CodexBar"
      fi

      if [ -z "$codexbar_bin" ]; then
        sketchybar --set "$NAME" label="no-cli"
        exit 0
      fi

      if ! command -v python3 >/dev/null 2>&1; then
        sketchybar --set "$NAME" label="--"
        exit 0
      fi

      label="$(python3 - "$provider" "$codexbar_bin" <<'PY'
      import json
      import subprocess
      import sys

      provider = sys.argv[1]
      codexbar = sys.argv[2]


      def fmt_num(x):
        try:
          if isinstance(x, str):
            x = float(x)
          x = float(x)
          if abs(x - int(x)) < 1e-9:
            return str(int(x))
          return f"{x:.1f}"
        except Exception:
          return None


      def walk(obj):
        if isinstance(obj, dict):
          yield obj
          for v in obj.values():
            yield from walk(v)
        elif isinstance(obj, list):
          for v in obj:
            yield from walk(v)


      source = "web"
      if provider == "antigravity":
        source = "auto"

      cmd = [codexbar, "usage", "--provider", provider, "--format", "json", "--source", source]

      try:
        p = subprocess.run(cmd, capture_output=True, text=True, timeout=10)
      except Exception:
        print("--")
        raise SystemExit(0)

      stdout = (p.stdout or "").strip()
      stderr = (p.stderr or "").strip().lower()

      if p.returncode != 0 or not stdout:
        if "no browser cookies" in stderr:
          print("cookie")
        elif "missing current session" in stderr or "please log in" in stderr or "no available fetch strategy" in stderr:
          print("login")
        elif "not detected" in stderr:
          print("off")
        else:
          print("--")
        raise SystemExit(0)

      try:
        data = json.loads(stdout)
      except Exception:
        print("--")
        raise SystemExit(0)

      best = None

      for d in walk(data):
        keys = {k.lower(): k for k in d.keys()}
        for k in ("percent", "percentage", "pct", "usedpercent"):
          if k in keys:
            v = fmt_num(d[keys[k]])
            if v is not None:
              best = f"{v}%"
              break
        if best is not None:
          break

      if best is None:
        for d in walk(data):
          keys = {k.lower(): k for k in d.keys()}
          k_used = next((keys[k] for k in ("used", "usage", "spent") if k in keys), None)
          k_limit = next((keys[k] for k in ("limit", "quota", "cap") if k in keys), None)
          if k_used and k_limit:
            used = fmt_num(d[k_used])
            limit = fmt_num(d[k_limit])
            if used is not None and limit is not None:
              best = f"{used}/{limit}"
              break

      if best is None:
        for d in walk(data):
          keys = {k.lower(): k for k in d.keys()}
          k_rem = next((keys[k] for k in ("remaining", "left") if k in keys), None)
          if k_rem:
            rem = fmt_num(d[keys[k_rem]])
            if rem is not None:
              best = f"{rem} left"
              break

      if best is None:
        best = "--"

      print(best)
      PY
      )"

      sketchybar --set "$NAME" label="$label"
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
      export NAME=ai_codex; ~/.config/sketchybar/plugins/ai_usage.sh codex
      export NAME=ai_claude; ~/.config/sketchybar/plugins/ai_usage.sh claude
      export NAME=ai_gravity; ~/.config/sketchybar/plugins/ai_usage.sh antigravity

      # Trigger workspace update
      sketchybar --trigger aerospace_workspace_change
    '';
    executable = true;
  };
}
