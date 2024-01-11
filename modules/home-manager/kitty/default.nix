{ home, config, lib, pkgs, ... }:
let cfg = config.modules.kitty;
in
{
  config = lib.mkIf cfg.enable
    {
      home.sessionVariables.TERMINAL = "kitty";
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
}
