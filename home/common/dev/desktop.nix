{ pkgs, lib, desktop, ... }: {
  programs.vscode = {
    package = pkgs.unstable.vscode;
    enable = true;
  };

  home.packages =
    lib.optional (builtins.isString desktop) pkgs.unstable.sublime-merge;
}
