# Nix-generated statusline script for Claude Code
# All binaries use Nix store paths for reproducibility
{pkgs, ...}: ''
  #!/usr/bin/env bash

  # Read JSON input from stdin
  input=$(${pkgs.coreutils}/bin/cat)

  # Extract data from JSON using Nix-path jq
  current_dir=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.workspace.current_dir')
  model_display=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.model.display_name')
  model_id=$(echo "$input" | ${pkgs.jq}/bin/jq -r '.model.id')

  # Determine model short name and color
  if [[ "$model_id" == *"opus"* ]]; then
      model_short="Opus"
      model_color="\033[38;5;141m"  # Purple for Opus
  elif [[ "$model_id" == *"sonnet"* ]]; then
      model_short="Sonnet"
      model_color="\033[38;5;208m"  # Orange for Sonnet
  elif [[ "$model_id" == *"haiku"* ]]; then
      model_short="Haiku"
      model_color="\033[38;5;77m"   # Green for Haiku
  else
      model_short="Claude"
      model_color="\033[38;5;39m"   # Blue for others
  fi

  # Extract version from model_id (e.g., "claude-opus-4-5-20251101" -> "4.5")
  if [[ "$model_id" =~ ([0-9]+)-([0-9]+)- ]]; then
      model_version="''${BASH_REMATCH[1]}.''${BASH_REMATCH[2]}"
      model_display_full="''${model_short} ''${model_version}"
  else
      model_display_full="''${model_short}"
  fi

  # Colors (oh-my-zsh style)
  reset="\033[0m"
  bold="\033[1m"
  cyan="\033[38;5;51m"
  blue="\033[38;5;39m"
  green="\033[38;5;77m"
  yellow="\033[38;5;220m"
  red="\033[38;5;196m"
  magenta="\033[38;5;201m"
  white="\033[38;5;231m"
  gray="\033[38;5;244m"
  dim="\033[2m"

  # Directory formatting (show basename or ~ for home)
  if [[ "$current_dir" == "$HOME" ]]; then
      dir_display="~"
  elif [[ "$current_dir" == "$HOME"/* ]]; then
      # Show relative to home
      dir_display="~/''${current_dir#$HOME/}"
  else
      dir_display="$current_dir"
  fi

  # Git information using Nix-path git
  git_info=""
  if ${pkgs.git}/bin/git -C "$current_dir" rev-parse --git-dir > /dev/null 2>&1; then
      # Get branch name
      branch=$(${pkgs.git}/bin/git -C "$current_dir" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null || echo "detached")

      # Check if dirty (modified or staged files)
      if ! ${pkgs.git}/bin/git -C "$current_dir" --no-optional-locks diff --quiet 2>/dev/null || \
         ! ${pkgs.git}/bin/git -C "$current_dir" --no-optional-locks diff --cached --quiet 2>/dev/null; then
          status_symbol="✗"
          status_color="$red"
      else
          status_symbol="✓"
          status_color="$green"
      fi

      # Check for untracked files
      if [[ -n $(${pkgs.git}/bin/git -C "$current_dir" --no-optional-locks ls-files --others --exclude-standard 2>/dev/null) ]]; then
          untracked="…"
      else
          untracked=""
      fi

      # Check ahead/behind status
      push_status=""
      upstream=$(${pkgs.git}/bin/git -C "$current_dir" --no-optional-locks rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
      if [[ -n "$upstream" ]]; then
          ahead=$(${pkgs.git}/bin/git -C "$current_dir" --no-optional-locks rev-list --count '@{upstream}..HEAD' 2>/dev/null || echo "0")
          behind=$(${pkgs.git}/bin/git -C "$current_dir" --no-optional-locks rev-list --count 'HEAD..@{upstream}' 2>/dev/null || echo "0")

          if [[ "$ahead" -gt 0 && "$behind" -gt 0 ]]; then
              push_status=" ''${yellow}↑''${ahead}↓''${behind}''${reset}"
          elif [[ "$ahead" -gt 0 ]]; then
              push_status=" ''${green}↑''${ahead}''${reset}"
          elif [[ "$behind" -gt 0 ]]; then
              push_status=" ''${red}↓''${behind}''${reset}"
          fi
      else
          # No upstream set
          push_status=" ''${gray}⚡''${reset}"
      fi

      git_info=" ''${gray}on''${reset} ''${magenta}⎇ ''${branch}''${reset} ''${status_color}''${status_symbol}''${untracked}''${reset}''${push_status}"
  fi

  # Context window information
  context_info=""
  usage=$(echo "$input" | ${pkgs.jq}/bin/jq '.context_window.current_usage')
  if [[ "$usage" != "null" ]]; then
      # Calculate current context usage (input + cache creation + cache read)
      current=$(echo "$usage" | ${pkgs.jq}/bin/jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
      size=$(echo "$input" | ${pkgs.jq}/bin/jq '.context_window.context_window_size')

      # Calculate percentage
      pct=$((current * 100 / size))

      # Format token counts (e.g., 24000 -> 24k, 200000 -> 200k)
      format_tokens() {
          local num=$1
          if [[ $num -ge 1000000 ]]; then
              echo "$((num / 1000000))M"
          elif [[ $num -ge 1000 ]]; then
              echo "$((num / 1000))k"
          else
              echo "$num"
          fi
      }

      current_formatted=$(format_tokens $current)
      size_formatted=$(format_tokens $size)

      # Create visual progress bar (10 blocks)
      filled_blocks=$((pct / 10))
      empty_blocks=$((10 - filled_blocks))

      # Build progress bar
      progress_bar=""
      for ((i=0; i<filled_blocks; i++)); do
          progress_bar+="█"
      done
      for ((i=0; i<empty_blocks; i++)); do
          progress_bar+="░"
      done

      # Determine color based on percentage
      if [[ $pct -ge 80 ]]; then
          context_color="$red"
          warning_icon=" ⚠"
      elif [[ $pct -ge 60 ]]; then
          context_color="$yellow"
          warning_icon=""
      else
          context_color="$green"
          warning_icon=""
      fi

      context_info=" ''${gray}│''${reset} ''${context_color}''${progress_bar}''${reset} ''${dim}''${current_formatted}/''${size_formatted} (''${pct}%%)''${warning_icon}''${reset}"
  fi

  # Build status line with oh-my-zsh style
  # Format: ➜ directory on ⎇ branch ✓/✗ | Model Version | ██░░░░░░░░ 24k/200k (12%)
  ${pkgs.coreutils}/bin/printf "''${cyan}➜''${reset} ''${bold}''${blue}''${dir_display}''${reset}''${git_info} ''${gray}│''${reset} ''${model_color}''${model_display_full}''${reset}''${context_info}"
''
