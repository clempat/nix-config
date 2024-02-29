{ pkgs, config, browser, wallpaperDir, flakeDir, deviceProfile, username, wallpaperGit, ... }:

{
  # Install Packages For The User
  home.packages = with pkgs; [
    audacity
    brightnessctl
    btop
    bottles
    cliphist
    cmatrix
    cowsay
    curl
    font-awesome
    gimp
    gnome.file-roller
    gnumake
    go
    godot_4
    grim
    handbrake
    htop
    hugo
    imv
    kdenlive
    lazygit
    libnotify
    libvirt
    lm_sensors
    lolcat
    lsd
    makemkv
    material-icons
    meson
    mpv
    neofetch
    ninja
    nodejs
    noto-fonts-color-emoji
    obs-studio
    obsidian
    onlyoffice-bin
    pavucontrol
    pkg-config
    pkgs."${browser}"
    python311Packages.pyvips
    rofi-wayland
    rustup
    slurp
    socat
    swayidle
    swaylock-effects
    swaynotificationcenter
    swww
    symbola
    tmux
    transmission-gtk
    unrar
    unzip
    v4l-utils
    vim
    wget
    winetricks
    wl-clipboard
    ydotool
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

    # Import Scripts
    (import ./../scripts/emopicker9000.nix { inherit pkgs; })
    (import ./../scripts/task-waybar.nix { inherit pkgs; })
    (import ./../scripts/squirtle.nix { inherit pkgs; })
    (import ./../scripts/wallsetter.nix {
      inherit pkgs; inherit wallpaperDir;
    })
    (import ./../scripts/themechange.nix { inherit pkgs; inherit flakeDir; })
    (import ./../scripts/theme-selector.nix { inherit pkgs; })
    (import ./../scripts/tmux-sessionizer.nix { inherit pkgs; })
    (import ./../scripts/kn.nix { inherit pkgs; })
    (import ./../scripts/nvidia-offload.nix { inherit pkgs; })

  ] ++ (if (deviceProfile != "vm") then [
    discord
    logseq
    spotify
    todoist-electron
  ] else [ ]);
}
