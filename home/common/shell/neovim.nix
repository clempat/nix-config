{ inputs, pkgs, system, ... }: {
  programs.neovim = inputs.clement-nvim.lib.mkHomeManager { inherit system; };
}
