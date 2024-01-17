{ config, lib, system, pkgs, hyprland, vars, host, ... }:
let
  cfg = config.modules.hyperland;
  nvidia = config.modules.nvidia;
  colors = import ../../theming/colors.nix;
in
{
  config = lib.mkIf cfg.enable {
    wlwm.enable = true; # Wayland Window Manager

    environment =
      let
        exec = if nvidia.enable then "exec dbus-launch nvidia-offload Hyprland" else "exec dbus-launch Hyprland";
      in
      {
        loginShellInit = ''
          if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
            exec dbus-launch nvidia-offload Hyprland
          fi
        ''; # Start from TTY1

        variables = {
          #WLR_NO_HARDWARE_CURSORS="1";         # Needed for VM
          #WLR_RENDERER_ALLOW_SOFTWARE="1";
          XDG_CURRENT_DESKTOP = "Hyprland";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "Hyprland";
        };
        sessionVariables =
          if nvidia.enable then {
            #GBM_BACKEND = "nvidia-drm";
            #__GL_GSYNC_ALLOWED = "0";
            #__GL_VRR_ALLOWED = "0";
            #WLR_DRM_NO_ATOMIC = "1";
            #__GLX_VENDOR_LIBRARY_NAME = "nvidia";
            #_JAVA_AWT_WM_NONREPARENTING = "1";

            QT_QPA_PLATFORM = "wayland";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

            GDK_BACKEND = "wayland";
            WLR_NO_HARDWARE_CURSORS = "1";
            MOZ_ENABLE_WAYLAND = "1";
          } else {
            QT_QPA_PLATFORM = "wayland";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

            GDK_BACKEND = "wayland";
            WLR_NO_HARDWARE_CURSORS = "1";
            MOZ_ENABLE_WAYLAND = "1";
          };
        systemPackages = with pkgs; [
          grimblast # Screenshot
          swayidle # Idle Daemon
          swaylock # Lock Screen
          wl-clipboard # Clipboard
          wlr-randr # Monitor Settings
        ];
      };

    security.pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };

    programs = {
      hyprland = {
        # Window Manager
        enable = true;
        package = hyprland.packages.${pkgs.system}.hyprland;
        #nvidiaPatches = if hostName == "work" then true else false;
      };
    };

    systemd.sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=no
      AllowSuspendThenHibernate=no
      AllowHybridSleep=yes
    ''; # Clamshell Mode

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    }; # Cache
  };
}
