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

    file.".tmux.conf" = {
      source = ./tmux.conf;
    };

    file.".tmux-cht-languages" = {
      source = ./tmux-cht-languages;
    };
  };

  programs.tmux = {
    enable = true;
  };
}
