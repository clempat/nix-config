{ config, lib, pkgs, user, ...}:

{
  imports = [
    ../../modules/desktop/i3/home.nix
  ];
  
  #services = {                            # Applets
  #  blueman-applet.enable = true;         # Bluetooth
  #};

}