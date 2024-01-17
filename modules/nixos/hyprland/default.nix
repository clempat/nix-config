{ config, lib, system, pkgs, hyprland, vars, host, ... }:
let
  cfg = config.modules.hyprland;
  nvidia = config.modules.nvidia;
  exec = if nvidia.enanble then "exec dbus-launch nvidia-offload Hyprland" else "exec dbus-launch Hyprland";
in
{
  config = lib.mkIf cfg.enable {
    modules.wlwm.enable = true; # Wayland Window Manager
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        ${exec}
      fi
    '';
    
    environment = {
      variables = {
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";
      };

      sessionVariables = {
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
