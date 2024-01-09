{ config, lib, pkgs, user, ... }:
let
  cfg = config.mymodule.kitty;
in
{
  options = {
    mymodule.kitty.enable = lib.mkEnableOption "Enable Kitty";
  };

  config = lib.mkIf cfg.enable {
    environment.variables.TERMINAL = "kitty";

    home-manager.users.${user} = {
      programs.kitty = {
        enable = true;
        theme = "Nord";
        font.package = pkgs.meslo-lgs-nf;
        font.name = "MesloLGS NF";
        settings = {
          # background_opacity = "0.9";
          hide_window_decorations = "titlebar-only";
          font_size = 12;
          window_padding_width = 8;
        };
      };
    };
  };
}