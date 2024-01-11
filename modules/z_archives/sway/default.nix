{ config, lib, pkgs, user, ... }:

{

  environment.systemPackages = with pkgs; [
    pamixer # Pulse Audio Mixer
    swaylock-fancy # Screen Locker
    waybar # Bar
  ];
}
