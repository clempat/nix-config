{ pkgs, desktop, config, inputs, system, lib, ... }:
let
  oi_icon = builtins.fetchurl {
    url =
      "https://github.com/open-webui/open-webui/blob/main/backend/open_webui/static/logo.png?raw=true";
    sha256 = "sha256:066vxl00g5zlcyljv42s671ld8iy063id623690g8131jqswkgii";
  };
in {
  imports = [
    (./. + "/${desktop}")

    ../dev

    ./firefox
    ./kitty
    ./alacritty.nix
    # ./gtk.nix
    # ./qt.nix
    # ./xdg.nix
    # ./zathura.nix
  ];

  home.file.".config/xdg/icons/openwebui.png".source = oi_icon;

  home.packages = with pkgs.unstable;
    [
      # rambox
      alpaca
      audacity
      beeper
      brave
      catppuccin-gtk
      chromium
      desktop-file-utils
      devpod-desktop
      discord
      element-desktop
      figma-linux
      # orca-slicer
      libnotify
      libreoffice
      # using EOL electron
      # logseq
      loupe
      lmstudio
      mumble
      nextcloud-client
      pamixer
      pavucontrol
      signal-desktop
      ultrastar-manager
      # ultrastardx
      sqlite
      vlc
      vesktop
      warp-terminal
      wireguard-ui
      xdg-utils
      xorg.xlsclients
    ] ++ [
      # From flake inputs
      inputs.zen-browser.packages.${system}.default
    ];

  fonts.fontconfig.enable = true;

  xdg.desktopEntries.openwebui = {
    name = "Open Web UI";
    genericName = "Open Web UI";
    exec = "${lib.getExe pkgs.chromium} --app=https://chat.patout.app";
    icon = "${config.home.homeDirectory}/.config/xdg/icons/openwebui.png";
  };

  xdg.desktopEntries.penpot = {
    name = "Penpot";
    genericName = "Penpot";
    exec = "${lib.getExe pkgs.chromium} --app=https://penpot.patout.app";
  };
}
