{ pkgs, ... }: {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
    powerdevil  # Disable PowerDevil to prevent CPU governor conflicts
  ];

  environment.systemPackages = with pkgs.unstable; [
    polkit_gnome
    kdePackages.filelight

    wl-clipboard
    xclip
  ];
}
