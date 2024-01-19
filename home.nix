{ config, pkgs, inputs, username,
  gitUsername, gitEmail, gtkThemeFromScheme,
  theme, browser, wallpaperDir, wallpaperGit,
  flakeDir, ... }:

{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Set The Colorscheme
  colorScheme = inputs.nix-colors.colorSchemes."${theme}";

  # Import Program Configurations
  imports = [
    inputs.nix-colors.homeManagerModules.default
    inputs.hyprland.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim

    # Enable &/ Configure Programs
    ./config/home/git.nix
    ./config/home/waybar.nix
    ./config/home/swaync.nix
    ./config/home/swaylock.nix
    ./config/home/starship.nix
    ./config/home/neofetch.nix
    ./config/home/hyprland.nix
    ./config/home/kitty.nix
    ./config/home/rofi.nix
    ./config/home/zsh.nix
    ./config/home/gtk-qt.nix
    ./config/home/firefox.nix
    ./config/home/_1password.nix
    ./config/home/tmux.nix
    ./config/home/neovim.nix

    # Install Programs & Scripts For User
    ./config/home/packages.nix

    # Place Home Files Like Pictures
    ./config/home/files.nix
  ];

  # Define Settings For Xresources
  xresources.properties = {
    "Xcursor.size" = 24;
  };

  # Create XDG Dirs
  xdg = {
    userDirs = {
        enable = true;
        createDirectories = true;
    };
  };

  programs.home-manager.enable = true;
  services.ssh-agent.enable = true;
  programs.ssh.enable = true;
}
