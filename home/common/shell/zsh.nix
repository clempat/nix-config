{ pkgs, isDarwin ? false, ... }: {

  home.sessionVariables.ZVM_VI_ESCAPE_BINDKEY = "jk";

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    sessionVariables.SSH_AUTH_SOCK = "~/.1password.agent.sock";

    initExtra = ''
      n () {
        if [ -n $NNNLVL ] && [ "$NNNLVL" -ge 1 ]; then
          echo "nnn is already running"
          return
        fi

        export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

        nnn -adeHo "$@"

        if [ -f "$NNN_TMPFILE" ]; then
          . "$NNN_TMPFILE"
          rm -f "$NNN_TMPFILE" > /dev/null
        fi
      }

      eval "$(atuin init zsh --disable-up-arrow)"
    '';

    # @TODO: Does not work yet
    zplug = {
      enable = true;
      plugins = [
        { name = "jeffreytse/zsh-vi-mode"; }
        { name = "tom-doerr/zsh_codex"; }
      ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
      extraConfig = ''
        bindkey '^X' create_completion
      '';
    };

    shellAliases = {
      cat = "bat";
      dr = "docker container run --interactive --rm --tty";
      lg = "lazygit";
      # ll = if isDarwin then "n" else "n -P K";
      nb = "nix build --json --no-link --print-build-logs";
      s = ''doppler run --config "nixos" --project "$(whoami)"'';
      wt = "git worktree";
      k = "kubectl";
    };

    syntaxHighlighting = { enable = true; };
  };
}
