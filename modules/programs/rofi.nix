#
# System Menu
#

{ config, lib, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;# Theme.rasi alternative. Add Theme here
in
{
  programs = {
    rofi = {
      enable = true;
      plugins = [ pkgs.rofi-calc pkgs.rofi-emoji ];
      terminal = "${pkgs.kitty}/bin/kitty";
      location = "center";
      theme = ../themes/rofi/spotlight-dark.rasi;
    };
  };
}
