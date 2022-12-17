{ pkgs,... }:

{
  programs = {
    neovim = {
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        pkgs.vimPlugins.packer-nvim
      ];
    };
  };
}
