{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    historySubstringSearch.enable = true;

    autocd = true;

    shellAliases = {
      ll = "ls -l";
      k = "kubectl";
      h = "helm";
      update = "sudo nixos-rebuild switch --flake";
    };

    initExtra = lib.readFile ./zshrc;

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "03r6hpb5fy4yaakqm3lbf4xcvd408r44jgpv4lnzl9asp4sb9qc0";
        };
      }
    ];
    sessionVariables = {
      CYPRESS_INSTALL_BINARY = 0;
      CYPRESS_RUN_BINARY = "${pkgs.cypress}/bin/Cypress";
    };
  };
}
