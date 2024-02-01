{ pkgs, config, ... }:
{
  # Place Files Inside Home Directory
  home.file.".emoji".source = ./files/emoji;
  home.file.".base16-themes".source = ./files/base16-themes;
  home.file.".face".source = ./files/face.png;
  home.file.".config/rofi/rofi.jpg".source = ./files/rofi.jpg;
  home.file.".local/share/fonts" = {
    source = ./files/fonts;
    recursive = true;
  };
  home.file."Pictures/Wallpapers".source = ./files/Wallpapers;
}
