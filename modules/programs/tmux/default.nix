{ config, pkgs, ... }:
{
  home = {
    file.".local/bin/tmux-sessionizer" = {
      source = ./tmux-sessionizer;
      executable = true;
    };

    file.".local/bin/tmux-cht.sh" = {
      source = ./tmux-cht.sh;
      executable = true;
    };

    file.".tmux-cht-command" = {
      source = ./tmux-cht-command;
    };

    file.".tmux-cht-languages" = {
      source = ./tmux-cht-languages;
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;


    extraConfig = ''
      unbind C-b
      set-option -g prefix C-a
      set-option -sg escape-time 10
      set-option -g focus-events on

      bind-key C-a send-prefix

      set -g base-index 1
      set -g status-keys vi
      setw -g mode-keys vi
      set -g default-terminal	"screen-256color"
      set -ga terminal-overrides ",xterm-256color:Tc"
      set -g mouse on


      # reload config file
      bind r source-file ~/.tmux.conf \; display ".tmux.conf reloaded!"
      bind -n C-f display-popup -E "~/.local/bin/tmux-sessionizer"

      bind-key -r i run-shell "tmux neww ~/.local/bin/tmux-cht.sh"
      bind-key -r F run-shell "~/.local/bin/tmux-sessionizer ~/workspace/enpal/EnpalCustomerPortal"
      bind-key -r J run-shell "~/.local/bin/tmux-sessionizer ~/workspace/perso/home-assistant"
      bind-key -r K run-shell "~/.local/bin/tmux-sessionizer ~/workspace/perso/home-cluster"

      # This will open the pane with same directory
      bind '"' split-window -h -c '#{pane\_current\_path}'  # Split panes horizontal  
      bind '%' split-window -v -c '#{pane\_current\_path}'  # Split panes vertically 
      bind c new-window -c "#{pane_current_path}"

    '';
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      fpp
      vim-tmux-navigator
      net-speed
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-battery false
          set -g @dracula-show-powerline true
          set -g @dracula-refresh-rate 10
          set -g @dracula-show-fahrenheit false
        '';
      }
      # {
      #   plugin = tmuxPlugins.power-theme;
      #   extraConfig = ''
      #     set -g @tmux_power_show_upload_speed true
      #     set -g @tmux_power_show_download_speed true
      #     set -g @tmux_power_left_arrow_icon ' '
      #     set -g @tmux_power_right_arrow_icon ' '
      #   '';
      # }
    ];
  };
}
