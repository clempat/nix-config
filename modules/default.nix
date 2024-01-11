{ lib, ... }:
{
  options.modules = {
    _1password.enable = lib.mkEnableOption "Enable 1Password";
    firefox.enable = lib.mkEnableOption "Enable Firefox";
    flatpak.enable = lib.mkEnableOption "Enable Flatpak";
    git.enable = lib.mkEnableOption "Enable Git";
    kde.enable = lib.mkEnableOption "Enable KDE";
    kitty.enable = lib.mkEnableOption "Enable Kitty";
    neovim.enable = lib.mkEnableOption "Enable Neovim";
    ssh.enable = lib.mkEnableOption "Enable SSH";
    tmux.enable = lib.mkEnableOption "Enable TMUX";
    zsh.enable = lib.mkEnableOption "Enable ZSH";
  };
  config = { };
}