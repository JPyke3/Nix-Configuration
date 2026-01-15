# Permission rules for Claude Code
# This file is SEEDED on first run, then Claude Code can modify it at runtime
# See home.activation.seedClaudePermissions in claude-code.nix
{pkgs, ...}: {
  permissions = {
    allow = [
      # Notification commands (Nix paths)
      "Bash(${pkgs.libnotify}/bin/notify-send:*)"

      # System info commands
      "Bash(wmctrl --help:*)"
      "Bash(xdotool --help:*)"
      "Bash(echo:*)"
      "Bash(pacman:*)"
      "Bash(apt list:*)"
      "Bash(qdbus6 --help:*)"
      "Bash(qdbus6:*)"
      "Bash(curl:*)"

      # Web access
      "WebSearch"
      "WebFetch(domain:github.com)"
      "WebFetch(domain:aur.archlinux.org)"
      "WebFetch(domain:raw.githubusercontent.com)"
      "WebFetch(domain:api.github.com)"
      "WebFetch(domain:medium.com)"
      "WebFetch(domain:gamesdb.launchbox-app.com)"
      "WebFetch(domain:mother3.fobby.net)"
      "WebFetch(domain:bbs.archlinux.org)"
      "WebFetch(domain:support.8bitdo.com)"
      "WebFetch(domain:www.pcgamingwiki.com)"
      "WebFetch(domain:download.8bitdo.com)"
      "WebFetch(domain:ronstechhub.com)"
      "WebFetch(domain:gbatemp.net)"
      "WebFetch(domain:steam.tools)"
      "WebFetch(domain:www.steamcardexchange.net)"
      "WebFetch(domain:steam.supply)"
      "WebFetch(domain:steamlvlup.net)"
      "WebFetch(domain:levelcalculator.com)"
      "WebFetch(domain:asus-linux.org)"
      "WebFetch(domain:rog.asus.com)"
      "WebFetch(domain:wiki.archlinux.org)"
      "WebFetch(domain:alexop.dev)"
      "WebFetch(domain:portmaster.games)"
      "WebFetch(domain:opensource.rock-chips.com)"
      "WebFetch(domain:rocknix.org)"

      # File system commands
      "Bash(ls:*)"
      "Bash(chmod:*)"
      "Bash(find:*)"
      "Bash(cat:*)"
      "Bash(tree:*)"
      "Bash(file:*)"

      # Docker MCP
      "mcp__MCP_DOCKER__mcp-find"

      # Node.js / NPM
      "Bash(npx --version:*)"
      "Bash(npx tweakcc:*)"
      "Bash(npm install:*)"
      "Bash(npm config set:*)"
      "Bash(~/.local/bin/tweakcc:*)"
      "Bash(node --version:*)"
      "Bash(npm --version:*)"

      # Python
      "Bash(pip install:*)"
      "Bash(python -m venv:*)"
      "Bash(source .venv/bin/activate)"
      "Bash(black:*)"
      "Bash(isort:*)"
      "Bash(mypy:*)"
      "Bash(whisper-dictate:*)"
      "Bash(pre-commit install:*)"
      "Bash(pip:*)"
      "Bash(pipx list:*)"
      "Bash(pipx:*)"
      "Bash(uv --version:*)"

      # Image manipulation
      "Bash(identify:*)"
      "Bash(convert:*)"
      "Bash(magick:*)"

      # System services
      "Bash(systemctl list-unit-files:*)"
      "Bash(systemctl:*)"
      "Bash(sudo systemctl start:*)"
      "Bash(sudo systemctl enable:*)"

      # Git operations
      "Bash(git --version:*)"
      "Bash(git clone:*)"
      "Bash(git add:*)"
      "Bash(git -C ~/.mydotfiles config:*)"
      "Bash(git -C /home/jacobpyke/Development/rcbot2 remote -v)"
      "Bash(git -C /home/jacobpyke/Development/Source-Engine-ML remote:*)"
      "Bash(git -C /home/jacobpyke/Development/nix-configuration remote -v)"
      "Bash(git -C /home/jacobpyke/Development/AiMP-Mobile-Builds log --oneline --all)"

      # Go / Rust
      "Bash(go version:*)"
      "Bash(rustc:*)"
      "Bash(cargo --version:*)"

      # Hardware info
      "Bash(lspci:*)"
      "Bash(lsblk:*)"
      "Bash(lsusb:*)"

      # Network utilities
      "Bash(tailscale status:*)"
      "Bash(ssh:*)"
      "Bash(mount:*)"
      "Bash(nmap:*)"
      "Bash(ping:*)"
      "Bash(smbclient:*)"
      "Bash(timeout 5 bash -c 'echo > /dev/tcp/jacob-nas/22')"
      "Bash(timeout 5 bash -c 'echo > /dev/tcp/jacob-china/22')"
      "Bash(timeout 5 bash -c 'echo > /dev/tcp/jacob-nas/5000')"
      "Bash(timeout 5 bash -c 'echo > /dev/tcp/jacob-nas/5001')"
      "Bash(rsync:*)"

      # Nix commands
      "Bash(nix flake check:*)"
      "Bash(nix:*)"
      "Bash(alejandra:*)"
      "Bash(nix-store --verify --repair:*)"
      "Bash(nix-collect-garbage:*)"
      "Bash(nix-store:*)"
      "Bash(nix-instantiate:*)"

      # Misc utilities
      "Bash(timedatectl:*)"
      "Bash(bw:*)"
      "Bash(source:*)"
      "Bash(bw-status)"
      "Bash(wine --version:*)"
      "Bash(./setup.sh)"
      "Bash(sudo cp:*)"
      "Bash(sudo udevadm control:*)"
      "Bash(sudo udevadm trigger:*)"
      "Bash(jq:*)"
      "Bash(bash:*)"
      "Bash(sudo mkdir:*)"
      "Bash(udisksctl mount:*)"
      "Bash(udisksctl unmount:*)"
      "Bash(zcat:*)"
      "Bash(dd:*)"
      "Bash(sync)"
      "Bash(pgrep:*)"
      "Bash(aria2c:*)"
      "Bash(/run/current-system/sw/bin/ls -la ~)"
      "Bash(/run/current-system/sw/bin/ls:*)"
      "Bash(fd:*)"

      # AI tools
      "Bash(aider:*)"

      # GitHub CLI
      "Bash(gh repo list:*)"
      "Bash(gh repo view:*)"
      "Bash(gh api:*)"

      # ASUS ROG tools
      "Bash(supergfxctl:*)"

      # Claude CLI
      "Bash(claude --version)"
    ];
    deny = [];
    ask = [];
  };
}
