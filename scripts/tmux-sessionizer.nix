{pkgs}:
pkgs.writeShellScriptBin "tmux-sessionizer" ''
  if [[ $# -eq 1 ]]; then
      selected=$1
  else
  	selected=$(${pkgs.fd}/bin/fd . "$HOME" --hidden -d 4 -t directory | ${pkgs.fzf}/bin/fzf -i --border rounded --border-label="Directory Search" --info=inline --preview='${pkgs.eza}/bin/eza -1 --color=always -L=3 -T --icons --git {}' )
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

  if ! ${pkgs.tmux}/bin/tmux has-session -t=$selected_name 2> /dev/null; then
      ${pkgs.tmux}/bin/tmux new-session -ds $selected_name -c $selected
  fi

  ${pkgs.tmux}/bin/tmux switch-client -t $selected_name
''
