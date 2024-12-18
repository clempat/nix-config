{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.piper ];

  # runtime dependency
  services.ratbagd.enable = true;
}
