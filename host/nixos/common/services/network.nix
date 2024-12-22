_: {
  networking = {
    networkmanager = {
      enable = true;
      wifi = { backend = "iwd"; };
    };
    nameservers = [ "192.168.40.254" ];
  };

  services.resolved = {
    enable = true;
    fallbackDns = ["1.1.1.1" "9.9.9.9"];
  };
}
