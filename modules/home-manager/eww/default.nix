#
#  Bar
#

{ config, lib, pkgs, vars, ... }:

{
  config = lib.mkIf (config.wlwm.enable) {
    home.file.".config/eww" = {
      source = ./config;
      recursive = true;
    };
  };
}
