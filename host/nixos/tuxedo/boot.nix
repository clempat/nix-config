{ pkgs, lib, config, ... }: {
  boot = {
    # Secure boot configuration
    bootspec.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    initrd = {
      availableKernelModules = [
        "i915"
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];

      kernelModules = [ "dm-snapshot" ];

      luks.devices = {
        root = {
          device = "/dev/disk/by-uuid/c1bf2d65-4438-44eb-baa2-403af4597d4e";
          preLVM = true;
        };
      };
    };

    # This is for OBS Virtual Cam Support - v4l2loopback setup
    kernelModules = [ "v4l2loopback" "sg" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];

    # Use the latest Linux kernel, rather than the default LTS
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
