{ pkgs, ... }: {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.kde.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];

  environment.systemPackages = with pkgs; [
    polkit_gnome
    kdePackages.filelight
  ];
}
