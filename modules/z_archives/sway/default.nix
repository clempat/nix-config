{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    pamixer # Pulse Audio Mixer
    swaylock-fancy # Screen Locker
    waybar # Bar
  ];
}
