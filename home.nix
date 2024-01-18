{ osConfig, config, lib, pkgs, user, theme, gtkThemeFromScheme, inputs, wallpaperDir, ... }:

{
  imports = [
    inputs.nix-colors.homeManagerModules.default
  ] ++ (import ./modules/home-manager);

  home.username = "${user}";
  home.homeDirectory = "/home/${user}";
  home.stateVersion = "23.11";

  home.file."Pictures/Wallpapers/trabi.jpg".source = ./modules/themes/backgrounds/trabi_wallpaper.jpg;

  # Set The Colorscheme
  colorScheme = inputs.nix-colors.colorSchemes."${theme}";

  home.packages = with pkgs; [
    btop # Resource Manager
    cargo
    cmatrix
    cowsay
    discord # Chat
    feh # Image Viewer
    gimp
    gnome.file-roller
    gnome.file-roller # Archive Manager
    gnupg
    handbrake # Encoder
    imagemagick
    imv
    jellyfin
    lazygit
    libdvdcss
    libdvdnav
    libdvdread
    lm_sensors
    logseq
    lolcat
    lsd
    luajitPackages.luacheck
    luarocks
    lutris # Game Launcher
    makemkv
    material-icons
    minecraft
    mpv # Media Player
    networkmanager
    nextcloud-client
    nodejs
    obs-studio # Recording/Live Streaming
    obsidian
    okular # PDF viewer
    pavucontrol # Audio control
    pcmanfm # File Manager
    pfetch # Minimal fetch
    pinentry
    plex-media-player # Media Player
    prismlauncher
    ranger # File Manager
    rclone
    remmina # XRDP & VNC Client
    rsync # Syncer $ rsync -r dir1/ dir2/
    rustc
    shellcheck
    slurp
    steam # Games
    stremio # Media Streamer
    todoist-electron
    unrar # Rar files
    unzip # Zip files
    util-linux
    vlc # Media Player
    wine
    xboxdrv # xbox controller
    # TODO move those to wayland only
    wl-clipboard
    (import ./scripts/wallsetter.nix { inherit pkgs; inherit wallpaperDir; })
  ];

  # Configure Cursor Theme
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };


  gtk = {
    # Theming
    enable = true;
    theme = {
      name = "${config.colorScheme.slug}";
      package = gtkThemeFromScheme { scheme = config.colorScheme; };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrains Mono Medium"; # or FiraCode Nerd Font Mono Medium
    }; # Cursor is declared under home.pointerCursor
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  programs.home-manager.enable = true;
}
