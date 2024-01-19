{ pkgs, config, browser, wallpaperDir, flakeDir, ... }:

{
  # Install Packages For The User
  home.packages = with pkgs; [
    pkgs."${browser}" neofetch lolcat cmatrix discord htop btop libvirt
    swww grim slurp lm_sensors unzip unrar gnome.file-roller
    logseq obsidian libnotify swaynotificationcenter rofi-wayland imv v4l-utils
    ydotool cliphist wl-clipboard socat cowsay lsd pkg-config transmission-gtk mpv
    gimp obs-studio blender kdenlive meson hugo gnumake ninja go
    nodejs godot_4 rustup pavucontrol audacity zeroad xonotic
    openra font-awesome symbola noto-fonts-color-emoji material-icons
    spotify brightnessctl swayidle swaylock vim wget curl neovide todoist-electron lazygit tmux
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # Import Scripts
    (import ./../scripts/emopicker9000.nix { inherit pkgs; })
    (import ./../scripts/task-waybar.nix { inherit pkgs; })
    (import ./../scripts/squirtle.nix { inherit pkgs; })
    (import ./../scripts/wallsetter.nix { inherit pkgs; inherit wallpaperDir; })
    (import ./../scripts/themechange.nix { inherit pkgs; inherit flakeDir; })
    (import ./../scripts/theme-selector.nix { inherit pkgs; })
    (import ./../scripts/tmux-sessionizer.nix { inherit pkgs; })
  ];
}
