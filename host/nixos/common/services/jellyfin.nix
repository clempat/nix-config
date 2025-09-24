# Jellyfin media server configuration
{ pkgs, config, lib, ... }: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # Add jellyfin to video and render groups for hardware acceleration
  users.users.jellyfin.extraGroups = [ "video" "render" ];

  # Ensure media directories are accessible
  systemd.tmpfiles.rules = [
    "d /var/lib/jellyfin 0755 jellyfin jellyfin -"
    "d /var/cache/jellyfin 0755 jellyfin jellyfin -"
  ];

  # Hardware acceleration support for Intel graphics
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}