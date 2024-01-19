{ config, pkgs, flakeDir, ... }:

{
  # Configure ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    historySubstringSearch.enable = true;

    autocd = true;

    profileExtra = ''
      #if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
      #  exec Hyprland
      #fi
    '';
    sessionVariables = {
    
    };
    shellAliases = {
      sv="sudo vim";
      flake-rebuild="sudo nixos-rebuild switch --flake ${flakeDir}";
      gcCleanup="nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      k="kubectl";
      h = "helm";
      v="nvim";
      vim="nvim";
      vi="nvim";
      ls="lsd";
      ll="lsd -l";
      la="lsd -a";
      lal="lsd -al";
      ".."="cd ..";
    };

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
}

