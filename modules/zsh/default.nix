{ config, lib, pkgs, user, ... }:
let
  cfg = config.mymodule.zsh;
  _1password = config.mymodule._1password;
in
{
  options = {
    mymodule.zsh.enable = lib.mkEnableOption "Enable ZSH";
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;

    environment.systemPackages = with pkgs; [ zsh spaceship-prompt ];
    users.users.${user} = {
      shell = pkgs.zsh;
    };
    home-manager.users.${user} = {
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
      };
    };
  };
}
