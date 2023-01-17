{ config, pkgs, ... }:
{
  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  # security.pam.u2f.control = "sufficient"; # Yubikey is enough
  security.pam.u2f.control = "required"; # multiple authentication

}
