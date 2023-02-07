{ config, lib, pkgs, user, ...}:

{
  imports = [
    ../../modules/desktop/i3/home.nix
  ];

  programs.git.signing.key = "2EF9A6A5B3AB6D76";
  
  #services = {                            # Applets
  #  blueman-applet.enable = true;         # Bluetooth
  #};

}
