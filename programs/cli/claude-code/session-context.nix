# Session context script for Claude Code
# Outputs comprehensive session info at startup and after compaction
# Used by SessionStart hook to provide context to Claude
{pkgs}:
pkgs.writeShellScript "session-context" ''
  echo "=== Session Context ==="

  # Time Context
  ${pkgs.coreutils}/bin/date "+%Y-%m-%d %H:%M:%S %Z"
  DAY=$(${pkgs.coreutils}/bin/date +%A)
  HOUR=$(${pkgs.coreutils}/bin/date +%H)
  if [ "$HOUR" -lt 12 ]; then TIME_OF_DAY="morning"
  elif [ "$HOUR" -lt 17 ]; then TIME_OF_DAY="afternoon"
  elif [ "$HOUR" -lt 21 ]; then TIME_OF_DAY="evening"
  else TIME_OF_DAY="night"; fi
  echo "Day: $DAY ($TIME_OF_DAY)"
  ${pkgs.systemd}/bin/timedatectl 2>/dev/null | ${pkgs.gnugrep}/bin/grep "Time zone" || true

  # Location
  echo "Location:"
  ${pkgs.curl}/bin/curl -s --max-time 3 "https://ipinfo.io/json" 2>/dev/null | \
    ${pkgs.jq}/bin/jq -r '"  \(.city), \(.region), \(.country)"' 2>/dev/null || \
    echo "  Unable to determine"

  # System/Hardware
  echo "Host: $(${pkgs.coreutils}/bin/hostname)"
  echo "NixOS Generation: $(${pkgs.coreutils}/bin/readlink /nix/var/nix/profiles/system 2>/dev/null | ${pkgs.gnugrep}/bin/grep -oP 'system-\K[0-9]+' || echo "unknown")"

  # Battery (laptop)
  if [ -f /sys/class/power_supply/BAT0/capacity ]; then
    BAT_PCT=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/BAT0/capacity)
    BAT_STATUS=$(${pkgs.coreutils}/bin/cat /sys/class/power_supply/BAT0/status)
    echo "Battery: $BAT_PCT% ($BAT_STATUS)"
  fi

  # Disk space
  ROOT_AVAIL=$(${pkgs.coreutils}/bin/df -h / 2>/dev/null | ${pkgs.gawk}/bin/awk 'NR==2 {print $4}')
  echo "Disk Available: $ROOT_AVAIL"

  # GPU mode (NVIDIA hybrid - ASUS ROG)
  if command -v supergfxctl &>/dev/null; then
    GPU_MODE=$(supergfxctl -g 2>/dev/null || echo "unknown")
    echo "GPU Mode: $GPU_MODE"
  fi

  # Network/Connectivity
  echo "Tailscale: $(${pkgs.tailscale}/bin/tailscale status --self --json 2>/dev/null | \
    ${pkgs.jq}/bin/jq -r '.Self.HostName // "not connected"' 2>/dev/null || echo "not available")"

  # Check if on home network (by checking if jacob-china is reachable)
  if ${pkgs.iputils}/bin/ping -c1 -W1 jacob-china &>/dev/null; then
    echo "Network: Home (jacob-china reachable)"
  else
    echo "Network: Away/Traveling"
  fi

  # Development Context - Docker containers
  echo "Docker:"
  CONTAINERS=$(${pkgs.docker}/bin/docker ps --format "{{.Names}}" 2>/dev/null | ${pkgs.coreutils}/bin/tr '\n' ', ' | ${pkgs.gnused}/bin/sed 's/,$//')
  if [ -n "$CONTAINERS" ]; then
    echo "  Running: $CONTAINERS"
  else
    echo "  No containers running"
  fi

  echo "==="
  exit 0
''
