{ pkgs, inputs, lib, config, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.tuxedo-infinitybook-pro14-gen7
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
      libglvnd
      mesa
    ];
    enable32Bit = true;
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  services.xserver.videoDrivers = [ "nvidia" "intel" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;

    prime = {
      # offload = {
      #   enable = true;
      #   enableOffloadCmd = true;
      # };
      sync.enable = true;
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


  programs.steam.enable = true;
}
