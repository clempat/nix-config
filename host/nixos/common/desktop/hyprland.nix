{ pkgs, lib, ... }:
let
  hypr-run = pkgs.writeShellScriptBin "hypr-run" ''
    export XDG_SESSION_TYPE="wayland"
    export XDG_SESSION_DESKTOP="Hyprland"
    export XDG_CURRENT_DESKTOP="Hyprland"

    systemd-run --user --scope --collect --quiet --unit="hyprland" \
        systemd-cat --identifier="hyprland" ${pkgs.hyprland}/bin/Hyprland $@

    ${pkgs.hyprland}/bin/hyperctl dispatch exit
  '';
in {
  programs = {
    dconf.enable = true;
    file-roller.enable = true;
    hyprland.enable = true;
  };

  environment = {
    variables.NIXOS_OZONE_WL = "1";

    systemPackages = with pkgs; [ polkit_gnome nautilus zenity ];
  };

  services = {
    dbus = {
      enable = true;
      # Make the gnome keyring work properly
      packages = with pkgs; [ gnome-keyring gcr ];
    };

    gnome = {
      gnome-keyring.enable = true;
      sushi.enable = true;
    };

    greetd = {
      enable = true;
      restart = false;
      settings = {
        default_session = {
          command = ''
            ${
              lib.makeBinPath [ pkgs.greetd.tuigreet ]
            }/tuigreet -r --asterisks --time \
              --cmd ${lib.getExe hypr-run}
          '';
        };
      };
    };

    gvfs.enable = true;
  };

  security = {
    pam = {
      services = {
        # unlock gnome keyring automatically with greetd
        greetd.enableGnomeKeyring = true;
      };
    };
  };
}
