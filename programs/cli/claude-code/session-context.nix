# Session context script for Claude Code
# Platform-aware script that conditionally includes relevant sections
# Only pulls in packages that are needed for the target platform
{
  pkgs,
  lib,
  isLinux,
  isDarwin,
  isDesktop,
  isHeadless,
  isMobile,
}: let
  # Common packages available everywhere
  coreutils = "${pkgs.coreutils}/bin";
  gnugrep = "${pkgs.gnugrep}/bin/grep";
  gnused = "${pkgs.gnused}/bin/sed";
  curl = "${pkgs.curl}/bin/curl";
  jq = "${pkgs.jq}/bin/jq";
  gawk = "${pkgs.gawk}/bin/awk";

  # Platform-specific packages
  systemdBin = lib.optionalString isLinux "${pkgs.systemd}/bin";
  tailscaleBin = lib.optionalString (isLinux || isDarwin) "${pkgs.tailscale}/bin/tailscale";
  pingBin =
    if isLinux
    then "${pkgs.iputils}/bin/ping"
    else if isDarwin
    then "/sbin/ping" # macOS has ping in /sbin
    else "";
  dockerBin = lib.optionalString isDesktop "${pkgs.docker}/bin/docker";

  # Time context section (all platforms)
  timeSection = ''
    # Time Context
    ${coreutils}/date "+%Y-%m-%d %H:%M:%S %Z"
    DAY=$(${coreutils}/date +%A)
    HOUR=$(${coreutils}/date +%H)
    if [ "$HOUR" -lt 12 ]; then TIME_OF_DAY="morning"
    elif [ "$HOUR" -lt 17 ]; then TIME_OF_DAY="afternoon"
    elif [ "$HOUR" -lt 21 ]; then TIME_OF_DAY="evening"
    else TIME_OF_DAY="night"; fi
    echo "Day: $DAY ($TIME_OF_DAY)"
  '';

  # Timezone section (Linux with systemd only)
  timezoneSection = lib.optionalString (isLinux && !isMobile) ''
    ${systemdBin}/timedatectl 2>/dev/null | ${gnugrep} "Time zone" || true
  '';

  # Location section (all platforms with network)
  locationSection = ''
    # Location
    echo "Location:"
    ${curl} -s --max-time 3 "https://ipinfo.io/json" 2>/dev/null | \
      ${jq} -r '"  \(.city), \(.region), \(.country)"' 2>/dev/null || \
      echo "  Unable to determine"
  '';

  # Hostname binary (inetutils on Linux, system on Darwin)
  hostnameBin =
    if isLinux
    then "${pkgs.inetutils}/bin/hostname"
    else "/bin/hostname"; # macOS has hostname in /bin

  # Host info section (all platforms)
  hostSection = ''
    # System/Hardware
    echo "Host: $(${hostnameBin})"
  '';

  # NixOS generation (Linux NixOS only, not nix-on-droid)
  nixosGenSection = lib.optionalString (isLinux && !isMobile) ''
    echo "NixOS Generation: $(${coreutils}/readlink /nix/var/nix/profiles/system 2>/dev/null | ${gnugrep} -oP 'system-\K[0-9]+' || echo "unknown")"
  '';

  # Battery section (Linux laptops only - norway, austria)
  # Check both BAT0 and BAT1 as different laptops use different names
  batterySection = lib.optionalString (isLinux && isDesktop) ''
    # Battery (laptop) - check BAT0 or BAT1
    for BAT in /sys/class/power_supply/BAT0 /sys/class/power_supply/BAT1; do
      if [ -f "$BAT/capacity" ]; then
        BAT_PCT=$(${coreutils}/cat "$BAT/capacity")
        BAT_STATUS=$(${coreutils}/cat "$BAT/status")
        echo "Battery: $BAT_PCT% ($BAT_STATUS)"
        break
      fi
    done
  '';

  # Disk space section (all platforms)
  diskSection = ''
    # Disk space
    ROOT_AVAIL=$(${coreutils}/df -h / 2>/dev/null | ${gawk} 'NR==2 {print $4}')
    echo "Disk Available: $ROOT_AVAIL"
  '';

  # GPU mode section (ASUS ROG laptops with supergfxctl - runtime check)
  gpuSection = lib.optionalString (isLinux && isDesktop) ''
    # GPU mode (NVIDIA hybrid - ASUS ROG)
    if command -v supergfxctl &>/dev/null; then
      GPU_MODE=$(supergfxctl -g 2>/dev/null || echo "unknown")
      echo "GPU Mode: $GPU_MODE"
    fi
  '';

  # Tailscale section (Linux and Darwin)
  tailscaleSection = lib.optionalString (isLinux || isDarwin) ''
    # Network/Connectivity
    echo "Tailscale: $(${tailscaleBin} status --self --json 2>/dev/null | \
      ${jq} -r '.Self.HostName // "not connected"' 2>/dev/null || echo "not available")"
  '';

  # Home network detection (Linux and Darwin with ping)
  networkSection = lib.optionalString ((isLinux || isDarwin) && pingBin != "") ''
    # Check if on home network (by checking if jacob-china is reachable)
    if ${pingBin} -c1 -W1 jacob-china &>/dev/null; then
      echo "Network: Home (jacob-china reachable)"
    else
      echo "Network: Away/Traveling"
    fi
  '';

  # Docker section (desktop machines only)
  dockerSection = lib.optionalString isDesktop ''
    # Development Context - Docker
    echo "Docker:"
    CONTAINERS=$(${dockerBin} ps --format "{{.Names}}" 2>/dev/null | ${coreutils}/tr '\n' ', ' | ${gnused} 's/,$//')
    if [ -n "$CONTAINERS" ]; then
      echo "  Running: $CONTAINERS"
    else
      echo "  No containers running"
    fi
  '';

  # Mobile-specific section (nix-on-droid)
  mobileSection = lib.optionalString isMobile ''
    echo "Platform: Nix-on-Droid (Android)"
  '';

  # Darwin-specific section
  darwinSection = lib.optionalString isDarwin ''
    echo "Platform: macOS (nix-darwin)"
  '';
in
  pkgs.writeShellScript "session-context" ''
    echo "=== Session Context ==="

    ${timeSection}
    ${timezoneSection}
    ${locationSection}
    ${hostSection}
    ${nixosGenSection}
    ${mobileSection}
    ${darwinSection}
    ${batterySection}
    ${diskSection}
    ${gpuSection}
    ${tailscaleSection}
    ${networkSection}
    ${dockerSection}

    echo "==="
    exit 0
  ''
