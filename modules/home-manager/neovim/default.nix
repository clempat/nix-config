{ lib, programs, config, ... }:
let
  cfg = config.modules.neovim;
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
