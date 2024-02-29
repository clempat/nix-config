{ inputs, pkgs, ... }:
let
  isDarwin = system == "aarch64-darwin" || system == "x86_64-darwin";
  system = pkgs.system;
in
{
  programs.neovim = inputs.clement-nvim.lib.mkHomeManager { inherit system; };
}
