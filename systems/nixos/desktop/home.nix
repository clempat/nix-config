{ config, lib, pkgs, ... }:

{
  imports = [
    ../../modules/desktop/i3/home.nix
  ];


  programs.git.signing.key = "35EAB9A8FEE12F8D";

  services = {
    # Applets
    blueman-applet.enable = true; # Bluetooth
  };

}
