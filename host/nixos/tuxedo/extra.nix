{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:

{
  # Enhanced thermal management for optimal fan control
  # Fan profile optimization:
  # - Balanced profile provides good cooling while minimizing noise
  # - Fans stay off until 35°C, gradually increase to maintain temps
  # - Full speed available at high temps (95°C+) for safety
  
  # CPU performance optimizations
  powerManagement = {
    powertop.enable = false; # Disabled - too aggressive power savings
    cpuFreqGovernor = "performance";
  };
  
  # Intel P-state driver optimizations  
  boot.kernelParams = [
    "intel_pstate=active"
    "processor.ignore_ppc=1"
  ];
  
  # Optimize CPU performance scaling
  systemd.services.cpu-performance = {
    description = "Set optimal CPU performance parameters";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "cpu-performance" ''
        # Set reasonable minimum CPU performance (25% for balance of performance/battery)
        echo 25 > /sys/devices/system/cpu/intel_pstate/min_perf_pct
        # Ensure turbo is enabled
        echo 0 > /sys/devices/system/cpu/intel_pstate/no_turbo
      '';
    };
  };
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
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
