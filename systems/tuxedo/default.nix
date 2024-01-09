# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "i915.force_probe=46a6"
    "tuxedo_keyboard.mode=0"
    "tuxedo_keyboard.brightness=255"
    "tuxedo_keyboard.color_left=0xff0a0a"
  ];

  networking.hostName = "tuxedo"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Try to optimize the screen
  services.xserver.enable = true;
  services.xserver.dpi = 192;
  environment.variables =
    {
      GDK_SCALE = "1";
      GDK_DPI_SCALE = "1";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1";
    };

  # NVIDIA
  environment.systemPackages = [
    nvidia-offload
    pkgs.light
    pkgs.pmutils
    pkgs.fusuma
    pkgs.xdotool
  ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.tuxedo-keyboard.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

}
