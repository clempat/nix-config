{ pkgs }:

pkgs.writeShellScriptBin "tmux-sessionizer" ''
#!/usr/bin/env bash

if [[ $# -eq 1 ]]; then
	selected=$1
else
	selected=$(find ~/ ~/workspace -mindepth 1 -maxdepth 3 -type d \( -not -path '*/\.*' -not -name '.*' \) -o -name ".config" | ${pkgs.fzf}/bin/fzf)
fi

if [[ -z $selected ]]; then
	exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)
if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
	${pkgs.tmux}/bin/tmux new-session -s $selected_name -c $selected
	exit 0
fi

if ! tmux has-session -t $selected_name 2>/dev/null; then
	${pkgs.tmux}/bin/tmux new-session -ds $selected_name -c $selected
fi

if [[ -z $TMUX ]]; then
	${pkgs.tmux}/bin/tmux attach-session -t $selected_name
else
	${pkgs.tmux}/bin/tmux switch-client -t $selected_name
fi
''

