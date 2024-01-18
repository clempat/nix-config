{ config, lib, pkgs, ... }:
let cfg = config.modules.flatpak;
in
{
  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;
    # Required for flatpak with windowmanagers
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
}
