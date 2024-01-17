#
#  Bar
#

{ config, environment, ... }:

{
  config = lib.mkIf (config.wlwm.enable) {
    environment.systemPackages = with pkgs; [
      waybar
    ];
  };
}
