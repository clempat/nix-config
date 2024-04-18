{ pkgs, ... }:
pkgs.writeShellScriptBin "tmux-sesh" ''
  sesh connect "$(
    	${pkgs.sesh}/bin/sesh list -tz | fzf-tmux -p 55%,60% \
    		--no-sort --border-label ' sesh ' --prompt '⚡  ' \
    		--header '  ^a all ^t tmux ^x zoxide ^d tmux kill ^f find' \
    		--bind 'tab:down,btab:up' \
    		--bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list)' \
    		--bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t)' \
    		--bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z)' \
    		--bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
    		--bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(⚡  )+reload(sesh list)'
    )"
''

