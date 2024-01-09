{ config, lib, pkgs, user, ... }:
let
  cfg = config.mymodule.flatpak;
in
{
  options = {
    mymodule.flatpak.enable = lib.mkEnableOption "Enable Flatpak";
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
      # Required for flatpak with windowmanagers
      xdg.portal = {
        enable = true;
        extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      };
    home-manager.users.${user} = {
    };
  };
}
