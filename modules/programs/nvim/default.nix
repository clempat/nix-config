{ pkgs,... }:

{
    home = {
        file.".config/nvim/lua/custom" = {
            recursive = true;
            source = ./config;
        };
    };
}