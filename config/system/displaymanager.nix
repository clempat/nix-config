{ pkgs, config, theKBDLayout, theKBDVariant, ... }:

{
  services.xserver = {
    enable = true;
    layout = "${theKBDLayout}";
    xkbVariant = "${theKBDVariant}";
    libinput.enable = true;
    displayManager.sddm = {
      enable = true;
      autoNumlock = true;
      wayland.enable = true;
      theme = "sugar-dark";
    };
  };

  environment.systemPackages = let themes = pkgs.callPackage ../pkgs/sddm-sugar-dark.nix { }; in
    [
      themes.sddm-sugar-dark
    ];
}

