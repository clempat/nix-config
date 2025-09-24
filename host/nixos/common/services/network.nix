# Network configuration
{ pkgs, config, lib, ... }: {
  networking = {
    networkmanager = {
      enable = true;
      wifi = { backend = "iwd"; };
      dns = lib.mkForce "none";
    };
    nameservers = [ "192.168.40.29" ];
  };

  services.resolved = {
    enable = true;
    fallbackDns = [ "1.1.1.1" "9.9.9.9" ];
  };
}
