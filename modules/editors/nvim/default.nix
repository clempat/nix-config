#########
# Neovim
########


{ pkgs, ...}:

{
  programs = {
    neovim = {
      viAlias = true;
      vimAlias = true;
    };
  };

  home.file.".config/nvim" = {
  source = pkgs.fetchFromGitHub {
      owner = "NvChad";
      rev = "74e374ef7be0dac71c8c7d6a16b4cc1b0ebcb2e5";
      sha256 = "V/ROrXVPp1vfDX/WOF5N2iuLO92EF2mSJDIsVuCcOxA=";
      repo = "NvChad";
    };
    recursive = true;
  };

  home.file.".config/nvim/lua/custom" = {
    source = ./config;
    recursive = true;
  };
} 
