# Session context script for Claude Code
# Outputs session info (date, timezone, location, host) at session start
# Used by SessionStart hook to provide context to Claude
{pkgs}:
pkgs.writeShellScript "session-context" ''
  echo "=== Session Context ==="
  ${pkgs.coreutils}/bin/date "+%Y-%m-%d %H:%M:%S %Z"
  ${pkgs.systemd}/bin/timedatectl 2>/dev/null | ${pkgs.gnugrep}/bin/grep "Time zone" || true
  echo "Location:"
  ${pkgs.curl}/bin/curl -s --max-time 3 "https://ipinfo.io/json" 2>/dev/null | \
    ${pkgs.jq}/bin/jq -r '"  \(.city), \(.region), \(.country)"' 2>/dev/null || \
    echo "  Unable to determine"
  echo "Host: $(${pkgs.coreutils}/bin/hostname)"
  echo "Tailscale: $(${pkgs.tailscale}/bin/tailscale status --self --json 2>/dev/null | \
    ${pkgs.jq}/bin/jq -r '.Self.HostName // "not connected"' 2>/dev/null || echo "not available")"
  echo "==="
  exit 0
''
