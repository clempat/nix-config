{ config, lib, pkgs, user, ... }:
let
  cfg = config.mymodule.neovim;
in
{
  options = {
    mymodule.neovim.enable = lib.mkEnableOption "Enable Neovim";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${user} = {
      programs.neovim =
        {
          enable = true;

          viAlias = true;
          vimAlias = true;
          vimdiffAlias = true;
        };
    };
  };
}
