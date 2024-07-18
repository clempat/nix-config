{ pkgs, lib, desktop, ... }: {
  programs.vscode = { enable = true; };

  home.packages = lib.optional (builtins.isString desktop) pkgs.sublime-merge;
}
