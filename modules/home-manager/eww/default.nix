#
#  Bar
#

{ osConfig, lib, pkgs, vars, ... }:

{
  config = lib.mkIf (osConfig.modules.wlwm.enable) {
    home.file.".config/eww" = {
      source = ./config;
      recursive = true;
    };
  };
}
