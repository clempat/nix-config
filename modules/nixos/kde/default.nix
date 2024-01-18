{ lib, config, services, environment, pkgs, ... }:
let cfg = config.modules.kde;
in
{
  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
    services.xserver.dpi = 192;
    # Configure keymap in X11
    services.xserver = {
      layout = "us";
      xkbVariant = "altgr-intl";
    };

    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      plasma-browser-integration
      konsole
      oxygen
    ];
  };

}
