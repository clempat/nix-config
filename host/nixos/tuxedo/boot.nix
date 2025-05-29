{ pkgs, lib, config, ... }: {
  boot = {
    # Secure boot configuration
    bootspec.enable = true;
    loader.systemd-boot.enable = true;

    tmp.cleanOnBoot = true;

    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
        "sdhci_pci"
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
    kernelModules = [
      # "v4l2loopback"
      "sg"
      "kvm-intel"
    ];
    # extraModulePackages = with pkgs; [ linuxPackages_latest.v4l2loopback ];
    # extraModprobeConfig = ''
    #   options v4l2loopback exclusive_caps=1 card_label="Virtual Webcam"
    #   options i915 enable_guc=2
    # '';

    # Use the latest Linux kernel, rather than the default LTS
    kernelPackages = pkgs.unstable.linuxPackages_6_14;
  };
}
