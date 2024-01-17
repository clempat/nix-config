#
#  Bar
#

{ config, environment, lib, pkgs, ... }:

{
  config = lib.mkIf (config.modules.wlwm.enable) {
    environment.systemPackages = with pkgs; [
      waybar
    ];
  };
}
