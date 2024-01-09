{ config, lib, pkgs, user, inputs, ... }:
let
  cfg = config.mymodule.kde;
in
{
  options = {
    mymodule.kde.enable = lib.mkEnableOption "Enable KDE";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    environment.plasma5.excludePackages = with pkgs.libsForQt5; [
      plasma-browser-integration
      konsole
      oxygen
    ];


    home-manager.users.${user} = {
      imports = [ inputs.plasma-manager.homeManagerModules.plasma-manager ./home.nix ];
    };
  };
}