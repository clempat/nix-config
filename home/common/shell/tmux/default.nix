{ pkgs, ... }:
let
  tmux-nerd-font-window-name = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-nerd-font-window-name.tmux";
    version = "v2.1.0";
    rtpFilePath = "tmux-nerd-font-window-name.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "joshmedeski";
      repo = "tmux-nerd-font-window-name";
      rev = "v2.1.0";
      hash = "sha256-HqSaOcnb4oC0AtS0aags2A5slsPiikccUSuZ1sVuago=";
    };
  };

in {
  home.packages = with pkgs.unstable; [
    fzf
    # gitmux
    sesh
    (import ./tmux-sesh.nix { pkgs = pkgs.unstable; })
  ];

  home.file.".config/tmux/gitmux.conf".source = ./gitmux.conf;
  home.file.".config/tmux/tmux-nerd-font-window-name.yml".source =
    ./tmux-nerd-font-window-name.yml;

  programs.tmux = {
    enable = true;
    clock24 = true;
    shell = "${pkgs.zsh}/bin/zsh";

    package = pkgs.unstable.tmux;

    plugins = with pkgs.unstable.tmuxPlugins; [
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
      fpp
      fzf-tmux-url
      net-speed
      resurrect
      sensible
      tmux-fzf
      tmux-nerd-font-window-name
      tmux-thumbs
      vim-tmux-navigator
      yank
    ];

    extraConfig = ''
      set -gu default-command
      set -g default-shell "$SHELL"

      ${builtins.readFile ./tmux.conf}
      bind-key "k" run-shell "tmux-sesh"
      # Enable vi mode
      set-window-option -g mode-keys vi

      # Search settings
      bind-key / copy-mode \; send-key ?
      bind-key ? copy-mode \; send-key ?

      # Make search case insensitive
      set-window-option -g wrap-search on
      set-window-option -g mode-keys vi
    '';
  };

}
