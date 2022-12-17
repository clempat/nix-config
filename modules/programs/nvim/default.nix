{ pkgs,... }:

{
    home.sessionPath = [
        "$HOME/.local/share/nvim/mason/bin"
    ];
    programs = {
        neovim = {
            enable = true;
            viAlias = true;
            vimAlias = true;

            plugins = with pkgs.vimPlugins; [
                pkgs.vimPlugins.packer-nvim
            ];
        };
    };
}
