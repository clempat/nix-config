{ config, lib, pkgs, user, ... }:

{ 
  imports =                                   # Home Manager Modules
  #  (import ../modules/editors) ++
    (import ../modules/programs);
  #  (import ../modules/services) ++
  #  (import ../modules/shell);

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";

    packages = with pkgs; [
      # Terminal
      btop              # Resource Manager
      pfetch            # Minimal fetch
      ranger            # File Manager
      networkmanager
      gnupg
      pinentry
      
      # Video/Audio
      feh               # Image Viewer
      mpv               # Media Player
      pavucontrol       # Audio control
      plex-media-player # Media Player
      vlc               # Media Player
      stremio           # Media Streamer
      makemkv
      jellyfin

      # Apps
      firefox           # Browser
      google-chrome     # Browser
      remmina           # XRDP & VNC Client
      obsidian
      todoist-electron
      nextcloud-client
      # pcloud

      # File Management
      okular            # PDF viewer
      gnome.file-roller # Archive Manager
      pcmanfm           # File Manager
      rsync             # Syncer $ rsync -r dir1/ dir2/
      unzip             # Zip files
      unrar             # Rar files

      # General configuration
      git              # Repositories
      #killall          # Stop Applications
      #pciutils         # Computer utility info
      #pipewire         # Sound
      usbutils         # USB utility info
      #wacomtablet      # Wacom Tablet
      #wget             # Downloader
      #zsh              # Shell
      gnome.gnome-keyring
      #
      # General home-manager
      #kitty            # Terminal Emulator
      dunst            # Notifications
      #doom emacs       # Text Editor
      flameshot        # Screenshot
      libnotify        # Dep for Dunst
      #neovim           # Text Editor
      #rofi             # Menu
      #udiskie          # Auto Mounting
      #vim              # Text Editor
      #
      # Xorg configuration
      #xclip            # Console Clipboard
      #xorg.xev         # Input viewer
      #xorg.xkill       # Kill Applications
      #xorg.xrandr      # Screen settings
      #xterm            # Terminal
      #
      # Xorg home-manager
      picom            # Compositer
      #polybar          # Bar
      #sxhkd            # Shortcuts
      #
      # Wayland configuration
      #autotiling       # Tiling Script
      #swayidle         # Idle Management Daemon
      #wev              # Input viewer
      #wl-clipboard     # Console Clipboard
      #
      # Wayland home-manager
      #pamixer          # Pulse Audio Mixer
      #swaylock-fancy   # Screen Locker
      #waybar           # Bar
      #
      # Desktop
      # blueman          # Bluetooth
      #deluge           # Torrents
      discord          # Chat
      #ffmpeg           # Video Support (dslr)
      #gmtp             # Mount MTP (GoPro)
      #gphoto2          # Digital Photography
      handbrake        # Encoder
      #heroic           # Game Launcher
      #hugo             # Static Website Builder
      lutris           # Game Launcher
      #mkvtoolnix       # Matroska Tool
      #new-lg4ff        # Logitech Drivers
      #plex-media-player# Media Player
      #polymc           # MC Launcher
      steam            # Games
      wine
      #simple-scan      # Scanning
      _1password-gui
      # 
      # Laptop
      #blueman          # Bluetooth
      #light            # Display Brightness
      #libreoffice      # Office Tools
      #simple-scan      # Scanning
      #
      # Flatpak
      obs-studio       # Recording/Live Streaming
      # Media
      libdvdcss
      libdvdread
      libdvdnav
      nodejs
      rustc
      cargo

      # Cypress
      cypress

      luajitPackages.luacheck
      shellcheck
      luarocks
    ];
    file.".config/wall".source = ../modules/themes/backgrounds/catpuccin.png;
    pointerCursor = {                         # This will set cursor systemwide so applications can not choose their own
      name = "Dracula-cursors";
      package = pkgs.dracula-theme;
      size = 16;
    };
    stateVersion = "22.05";
  };

  programs = {
    home-manager.enable = true;
  };

  gtk = {                                     # Theming
    enable = true;
    theme = {
      name = "Dracula";
      package = pkgs.dracula-theme;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "JetBrains Mono Medium";         # or FiraCode Nerd Font Mono Medium
    };                                        # Cursor is declared under home.pointerCursor
  };
}
