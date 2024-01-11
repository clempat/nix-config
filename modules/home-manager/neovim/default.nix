{ lib, programs, osConfig, ... }:
let
  cfg = osConfig.modules.neovim;
in
{
  config = lib.mkIf cfg.enable {
    programs.neovim =
      {
        enable = true;

        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
      };
  };
}
