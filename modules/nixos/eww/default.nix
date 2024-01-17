#
#  Bar
#

{ config, lib, pkgs, vars, ...}:

{
  config = lib.mkIf (config.wlwm.enable) {
    environment.systemPackages = with pkgs; [
      eww-wayland         # Widgets
      jq                  # JSON Processor
      socat               # Data Transfer
    ];
  };
}