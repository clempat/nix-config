{ desktop, pkgs, self, username, ... }:
let theme = import "${self}/lib/theme" { inherit pkgs; };
in {
  imports = [
    (./. + "/${desktop}.nix")
    ../hardware/yubikey.nix
    ../services/pipewire.nix
    ../virt
    ./piper.nix
    ./flatpak.nix
  ];

  # Enable Plymouth and surpress some logs by default.
  boot.plymouth.enable = true;
  boot.kernelParams = [
    # The 'splash' arg is included by the plymouth option
    "quiet"
    "loglevel=3"
    "rd.udev.log_priority=3"
    "vt.global_cursor_default=0"
  ];

  hardware.graphics.enable = true;

  # Enable location services
  location.provider = "geoclue2";

  environment.etc = {
    "1password/custom_allowed_browsers" = {
      text = ''
        vivaldi-bin
        zen
        zen-beta
      '';
      mode = "0755";
    };
  };

  programs = {
    _1password-gui = {
      enable = true;
      package = pkgs.unstable._1password-gui;
      polkitPolicyOwners = [ "${username}" ];
    };
  };

  fonts = {
    packages = with pkgs; [
      liberation_ttf
      ubuntu_font_family

      theme.fonts.default.package
      theme.fonts.emoji.package
      theme.fonts.iconFont.package
      theme.fonts.monospace.package

      geist-font
    ];

    # Use fonts specified by user rather than default ones
    enableDefaultPackages = false;

    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "${theme.fonts.default.name}" "${theme.fonts.emoji.name}" ];
        sansSerif =
          [ "${theme.fonts.default.name}" "${theme.fonts.emoji.name}" ];
        monospace = [ "${theme.fonts.monospace.name}" ];
        emoji = [ "${theme.fonts.emoji.name}" ];
      };
    };
  };
}
