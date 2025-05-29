_: {
  boot = {
    initrd.systemd.enable = true;

    binfmt.emulatedSystems = [ "aarch64-linux" ];

    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
