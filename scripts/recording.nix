{ pkgs, isDarwin }:
let
  space_default = "8";
  x_recording = "600";
  y_recording = "100";
  darwindScript = ''
    # Required parameters:
    # @raycast.schemaVersion 1
    # @raycast.title Recording
    # @raycast.mode silent

    # Optional parameters:
    # @raycast.icon 🤖

    # Documentation:
    # @raycast.description Recording Setup
    # @raycast.author clement
    # @raycast.authorURL https://raycast.com/clement

    current_padding=$(${pkgs.yabai}/bin/yabai -m config --space 1 left_padding)

    if [ "$current_padding" -eq 8 ]; then
      ${pkgs.yabai}/bin/yabai -m config --space 1 left_padding ${x_recording}
      ${pkgs.yabai}/bin/yabai -m config --space 1 right_padding ${x_recording}
      ${pkgs.yabai}/bin/yabai -m config --space 1 top_padding ${y_recording}
      ${pkgs.yabai}/bin/yabai -m config --space 1 bottom_padding ${y_recording}
      ${pkgs.yabai}/bin/yabai -m config --space 2 left_padding ${x_recording}
      ${pkgs.yabai}/bin/yabai -m config --space 2 right_padding ${x_recording}
      ${pkgs.yabai}/bin/yabai -m config --space 2 top_padding ${y_recording}
      ${pkgs.yabai}/bin/yabai -m config --space 2 bottom_padding ${y_recording}
      ${pkgs.yabai}/bin/yabai -m space --balance

      # Start OBS
      open -a OBS
      ${pkgs.yabai}/bin/yabai -m window --focus recent
    else
      ${pkgs.yabai}/bin/yabai -m config --space 1 left_padding ${space_default}
      ${pkgs.yabai}/bin/yabai -m config --space 1 right_padding ${space_default}
      ${pkgs.yabai}/bin/yabai -m config --space 1 top_padding ${space_default}
      ${pkgs.yabai}/bin/yabai -m config --space 1 bottom_padding ${space_default}
      ${pkgs.yabai}/bin/yabai -m config --space 2 left_padding ${space_default}
      ${pkgs.yabai}/bin/yabai -m config --space 2 right_padding ${space_default}
      ${pkgs.yabai}/bin/yabai -m config --space 2 top_padding ${space_default}
      ${pkgs.yabai}/bin/yabai -m config --space 2 bottom_padding ${space_default}
      ${pkgs.yabai}/bin/yabai -m space --balance
    fi
  '';
  nixosScript = ''
    #!/bin/sh
    # This script is used to record the screen.
    # It will record the screen for 10 seconds and save the output to the file
    # /tmp/screen.mp4
    echo "Not implemented"
  '';
  script = if isDarwin then darwindScript else nixosScript;
in pkgs.writeShellScriptBin "recording" script
