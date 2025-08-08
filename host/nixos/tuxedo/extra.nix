{ inputs, lib, config, ... }:

{
  # Thermal management for quieter fans
  services.thermald.enable = true;
  powerManagement.powertop.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    open = false;
    nvidiaSettings = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      # sync.enable = true; # Removed as offload is generally better for laptops
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  specialisation = {
    on-the-go.configuration = {
      system.nixos.tags = [ "on-the-go" ];
      hardware.nvidia = {
        prime.offload.enable = lib.mkForce true;
        prime.offload.enableOffloadCmd = lib.mkForce true;
        prime.sync.enable = lib.mkForce false;
      };
    };
  };
}
