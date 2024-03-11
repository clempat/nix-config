{ inputs, pkgs, ... }:
let
  tmux_reset = ''
    # First remove *all* keybindings
    # unbind-key -a
    # Now reinsert all the regular tmux keys
      bind ^X lock-server
      bind c new-window -c "#{pane_current_path}"
      bind ^D detach
      bind * list-clients

      bind H previous-window
      bind L next-window

      bind r command-prompt "rename-window %%"
      bind R source-file ~/.config/tmux/tmux.conf
      bind ^A last-window
      bind ^W list-windows
      bind w list-windows
      bind z resize-pane -Z
      bind ^L refresh-client
      bind l refresh-client
      bind | split-window
      bind s split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind '"' choose-window
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind -r -T prefix , resize-pane -L 20
      bind -r -T prefix . resize-pane -R 20
      bind -r -T prefix - resize-pane -D 7
      bind -r -T prefix = resize-pane -U 7
      bind : command-prompt
      bind * setw synchronize-panes
      bind P set pane-border-status
      bind q kill-pane
      bind x swap-pane -D
      bind S choose-session
      bind g display-popup -d "#{pane_current_path}" -xC -yC -w80% -h80% -E lazygit
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -n C-n display-popup -E nvim -c ":ObsidianNew"
      bind-key -n C-q display-popup -w "90%" -h "85%" -E nvim -c ":ObsidianSearch"
  '';
  tmux_conf = ''
    set-option -g default-terminal 'screen-254color'
    set-option -g terminal-overrides ',xterm-256color:RGB'

    set -g prefix ^A
    set -g base-index 1              # start indexing windows at 1 instead of 0
    set -g detach-on-destroy off     # don't exit from tmux when closing a session
    set -g escape-time 0             # zero-out escape time delay
    set -g history-limit 1000000     # increase history size (from 2,000)
    set -g renumber-windows on       # renumber all windows when any window is closed
    set -g set-clipboard on          # use system clipboard
    set -g status-position top       # macOS / darwin style
    set -g default-terminal "''${TERM}"
    setw -g mode-keys vi
    set -g pane-active-border-style 'fg=magenta,bg=default'
    set -g pane-border-style 'fg=brightblack,bg=default'
    set -g mouse on


    set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
    set -g @fzf-url-history-limit '2000'

    set -g @continuum-restore 'on'
    set -g @resurrect-strategy-nvim 'session'
  '';
in {
  programs.tmux = {
    enable = true;
    clock24 = true;

    extraConfig = ''
      ${tmux_reset}
      ${tmux_conf}
    '';
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
          set -g @catppuccin_status_modules_right "directory date_time"
          set -g @catppuccin_status_modules_left "session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator " "
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{b:pane_current_path}"
          # set -g @catppuccin_meetings_text "#($HOME/.config/tmux/scripts/cal.sh)"
          set -g @catppuccin_date_time_text "%H:%M"
        '';
      }
      continuum
      fpp
      tmux-fzf
      fzf-tmux-url
      net-speed
      resurrect
      sensible
      tmux-thumbs
      vim-tmux-navigator
      yank
      {
        plugin = inputs.tmux-sessionx.packages.${pkgs.system}.default;
        extraConfig = ''
          set -g @sessionx-bind 'o'
          set -g @sessionx-window-height '85%'
          set -g @sessionx-window-width '75%'
          set -g @sessionx-zoxide-mode 'on'
          set -g @sessionx-filter-current 'false'
          set -g @sessionx-preview-enabled 'true'
        '';
      }
    ];
  };
}
