# In Dev
{pkgs, ...}:
pkgs.writeShellScriptBin "history-search" ''
  selected=$(history | awk '{print $2}' | ${pkgs.fzf}/bin/fzf -i --border rounded --border-label="Directory Search" --info=inline)
  if [ -n "$selected" ]; then
  	read $selected
  fi
''
