# Nix-Configuration

Multi-machine NixOS and nix-darwin configuration repository using Nix Flakes.

## Machine Naming Convention

Machines are named after **geographic locations** (countries/regions):

| Name | Platform | Purpose |
|------|----------|---------|
| **norway** | NixOS (x86_64) | Primary ASUS ROG laptop - NVIDIA+AMD hybrid graphics, KDE Plasma + Hyprland |
| **austria** | NixOS (aarch64) | Apple Silicon MacBook - Asahi Linux, KDE Plasma + Hyprland |
| **japan** | NixOS (x86_64) | Steam Deck OLED - Jovian, gaming-focused |
| **china** | NixOS (x86_64) | Home server - Media stack, self-hosted services |
| **singapore** | NixOS (x86_64) | **[DEPRECATED]** Gaming desktop, VR development |
| **germany** | nix-darwin (aarch64) | Mac Mini - Yabai WM, Tdarr transcoding |
| **vietnam** | Nix-on-Droid (aarch64) | Samsung Galaxy Z Fold 5 - Mobile development with Claude Code |

---

## Repository Structure

```
.
├── flake.nix                    # Main flake - inputs and system outputs
├── flake.lock                   # Locked dependencies
├── rebuild                      # Build script (format, rebuild, commit)
├── .sops.yaml                   # SOPS secrets configuration
│
├── programs/                    # Program configurations
│   ├── cli/                     # CLI tools
│   │   ├── zsh.nix              # Zsh with oh-my-zsh, Pure prompt
│   │   ├── nvim/                # Neovim configuration
│   │   ├── tmux.nix             # Terminal multiplexer
│   │   ├── zellij.nix           # Modern terminal multiplexer (all machines)
│   │   ├── mosh.nix             # Mobile shell (all machines)
│   │   ├── fastfetch.nix        # System info display (all machines)
│   │   ├── git.nix              # Git with diff-so-fancy
│   │   ├── lf.nix               # File manager
│   │   ├── ollama.nix           # Local LLM
│   │   ├── spicetify.nix        # Spotify customization
│   │   ├── nix-index.nix        # Package search
│   │   └── homebrew.nix         # macOS Homebrew
│   │
│   ├── daemon/                  # Background services
│   │   ├── jellyfin.nix         # Media server
│   │   ├── sonarr.nix           # TV management
│   │   ├── radarr.nix           # Movie management
│   │   ├── lidarr.nix           # Music management
│   │   ├── prowlarr.nix         # Indexer manager
│   │   ├── bazarr.nix           # Subtitles
│   │   ├── transmission.nix     # Torrent client
│   │   ├── deluge.nix           # Torrent client
│   │   ├── nginx.nix            # Web server/reverse proxy
│   │   ├── tailscale.nix        # VPN mesh networking
│   │   ├── syncthing/           # File synchronization
│   │   ├── docker.nix           # Container runtime
│   │   ├── distrobox.nix        # Container environments
│   │   ├── nextcloud.nix        # Cloud storage
│   │   ├── vaultwarden.nix      # Password manager
│   │   ├── gitea.nix            # Git hosting
│   │   ├── home-assistant.nix   # Home automation
│   │   ├── immich.nix           # Photo management
│   │   ├── tdarr.nix            # Video transcoding
│   │   ├── kanata/              # Keyboard remapping
│   │   ├── yabai.nix            # macOS window manager
│   │   ├── sketchybar/          # macOS status bar
│   │   └── ...                  # Many more services
│   │
│   └── desktop/                 # GUI applications
│       ├── hyprland.nix         # Wayland compositor
│       ├── hyprlock.nix         # Screen locker
│       ├── waybar/              # Status bar
│       ├── kitty/               # Terminal emulator
│       ├── firefox.nix          # Web browser
│       ├── chrome.nix           # Chromium
│       ├── vscode.nix           # Code editor
│       └── gaming/              # Gaming configs (emulators)
│
├── systems/                     # System configurations
│   ├── nixos/
│   │   ├── configuration.nix    # Shared NixOS config (all machines)
│   │   ├── home.nix             # Shared home-manager config
│   │   ├── unstable-packages.nix # Packages from unstable channel
│   │   ├── norway/              # ASUS ROG laptop
│   │   │   ├── configuration.nix
│   │   │   ├── hardware-configuration.nix
│   │   │   └── home.nix
│   │   ├── austria/             # Apple Silicon (Asahi)
│   │   │   ├── configuration.nix
│   │   │   ├── hardware-configuration.nix
│   │   │   ├── home.nix
│   │   │   └── apple-silicon-support/  # Asahi modules
│   │   ├── japan/               # Steam Deck
│   │   │   ├── configuration.nix
│   │   │   ├── hardware-configuration.nix
│   │   │   ├── home.nix
│   │   │   └── syncthing.nix
│   │   ├── china/               # Home server
│   │   │   ├── configuration.nix
│   │   │   ├── hardware-configuration.nix
│   │   │   └── home.nix
│   │   └── singapore/           # [DEPRECATED] Desktop
│   │
│   ├── darwin/                  # macOS (Mac Mini)
│   │   ├── configuration.nix
│   │   ├── home.nix
│   │   ├── mac-defaults.nix
│   │   └── kmonad.nix
│   │
│   ├── nix-on-droid/            # Android (Samsung Galaxy Z Fold 5)
│   │   └── vietnam/
│   │       ├── nix-on-droid.nix
│   │       └── home.nix
│   │
│   └── stylix.nix               # Global theming (Outer Wilds - custom OLED theme)
│
├── users/jacob/
│   └── common-home.nix          # Shared user config (packages, shell, secrets)
│
├── secrets/                     # SOPS encrypted secrets
│   └── secrets.yaml
│
├── scripts/                     # Utility scripts
├── wallpapers/                  # Desktop wallpapers
└── .github/workflows/           # CI/CD automation
```

---

## Key Flake Inputs

| Input | Version | Purpose |
|-------|---------|---------|
| `nixpkgs` | 25.11 | Stable packages |
| `unstable` | latest | Bleeding-edge packages |
| `home-manager` | 25.11 | User environment management |
| `nix-darwin` | 25.11 | macOS system configuration |
| `nix-on-droid` | 24.05 | Android Nix environment |
| `stylix` | 25.11 | Consistent theming across systems |
| `sops-nix` | - | Secrets management (age encryption) |
| `jovian` | - | Steam Deck support |
| `nixos-apple-silicon` | - | Asahi Linux support |
| `claude-code` | - | Claude Code CLI integration |

---

## Common Tasks

### Adding a New CLI Program

1. Create `programs/cli/<program>.nix`:
```nix
{ pkgs, ... }:
{
  programs.<program> = {
    enable = true;
    # configuration...
  };
}
```

2. Import in `users/jacob/common-home.nix`:
```nix
imports = [
  # ...existing imports
  ../../programs/cli/<program>.nix
];
```

### Adding a New Daemon/Service

1. Create `programs/daemon/<service>.nix`:
```nix
{ config, pkgs, ... }:
{
  services.<service> = {
    enable = true;
    # configuration...
  };
}
```

2. Import in the relevant system's `configuration.nix`:
```nix
imports = [
  # ...existing imports
  ../../../programs/daemon/<service>.nix
];
```

### Adding a New Desktop Program

1. Create `programs/desktop/<program>.nix`:
```nix
{ pkgs, ... }:
{
  home.packages = [ pkgs.<program> ];
  # or programs.<program> = { ... };
}
```

2. Import in the relevant system's `home.nix`:
```nix
imports = [
  # ...existing imports
  ../../../programs/desktop/<program>.nix
];
```

### Adding a New System

1. Create directory `systems/nixos/<name>/` with:
   - `configuration.nix` - System configuration
   - `hardware-configuration.nix` - Hardware-specific (generate with `nixos-generate-config`)
   - `home.nix` - Home-manager configuration

2. Add to `flake.nix` outputs:
```nix
nixosConfigurations = {
  # ...existing systems
  jacob-<name> = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";  # or aarch64-linux
    specialArgs = { inherit inputs; };
    modules = [
      ./systems/nixos/configuration.nix
      ./systems/nixos/<name>/configuration.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.users.jacobpyke = import ./systems/nixos/<name>/home.nix;
      }
    ];
  };
};
```

### Enabling/Disabling Services

- **Enable**: Add import to system's `configuration.nix`
- **Disable**: Remove/comment the import
- **Configure**: Edit the service file in `programs/daemon/`

### Adding Packages from Unstable

Edit `systems/nixos/unstable-packages.nix`:
```nix
environment.systemPackages = with unstablePkgs; [
  # existing packages
  <new-package>
];
```

---

## Build Commands

```bash
# Rebuild current system (uses hostname)
sudo nixos-rebuild switch --flake .

# Rebuild specific system
sudo nixos-rebuild switch --flake .#jacob-norway

# Build without switching (test)
sudo nixos-rebuild build --flake .#jacob-norway

# Update flake inputs
nix flake update

# Update single input
nix flake lock --update-input nixpkgs

# Format nix files
alejandra .

# Use the rebuild script (formats, rebuilds, commits)
./rebuild
```

### Darwin (macOS)

```bash
darwin-rebuild switch --flake .#jacob-germany
```

### Nix-on-Droid (Android)

```bash
# On the phone (after installing Nix-on-Droid app)
nix-on-droid switch --flake .#jacob-vietnam

# Update from Git
cd ~/.config/nix-on-droid && git pull && nix-on-droid switch --flake .#jacob-vietnam
```

---

## Key Technologies

| Technology | Purpose |
|------------|---------|
| **Stylix** | Consistent theming (Outer Wilds custom OLED theme) across all systems |
| **SOPS-nix** | Secrets management with age encryption |
| **Syncthing** | File synchronization across devices |
| **Tailscale** | Mesh VPN for secure inter-machine networking |
| **Home Manager** | User environment and dotfile management |
| **Attic** | Self-hosted Nix binary cache (runs on china, stores on Synology NAS) |

---

## Binary Cache Infrastructure

### Architecture

```
GitHub Actions (EC2) → Build → Push via Tailscale → Attic (china:5000) → Synology NAS
                                                           ↑
                                            All systems fetch from here
```

### Components

| Component | Location | Purpose |
|-----------|----------|---------|
| **Attic Server** | `jacob-china:5000` | Binary cache server (Tailscale only) |
| **Storage** | Synology NAS `/volume1/nix-cache` | NFS-mounted NAR file storage |
| **Cache name** | `main` | Default Attic cache |
| **Garbage Collection** | 30-day retention | Runs daily |

### Cache Priority Order (CI)

1. **Magic Nix Cache** - Ephemeral per-CI-run cache (fastest for repeated builds in same run)
2. **Attic** (`http://jacob-china:5000/main`) - Self-hosted primary cache via Tailscale
3. **Cachix** (`https://jpyke3.cachix.org`) - Public fallback when Attic unavailable
4. **cache.nixos.org** - Official NixOS cache (always available)

> **Note:** Historical `modules-shrunk` build failures were caused by a Nix 2.18.x bug (fixed by using Nix 2.28.3), not cache corruption.

### Attic Management

```bash
# Login to Attic (on any Tailscale-connected machine)
attic login main http://jacob-china:5000 <token>

# Push a build manually
attic push main /nix/store/<path>

# Check cache status
attic cache info main
```

---

## Secrets Management

Secrets are managed via SOPS with age encryption:

- **Config**: `.sops.yaml`
- **Secrets file**: `secrets/secrets.yaml`
- **Key location**: `~/.config/sops/age/keys.txt`

### Accessing secrets in configurations:

```nix
sops.secrets."path/to/secret" = {
  owner = "jacobpyke";
};

# Then use: config.sops.secrets."path/to/secret".path
```

---

## System-Specific Notes

### norway (Primary Laptop)
- NVIDIA RTX 5070 Ti + AMD Radeon 890M hybrid graphics
- Uses PRIME offload with power management
- ASUS ROG tools (asusd, supergfxd)
- KDE Plasma 6 + Hyprland available

### austria (Apple Silicon)
- Asahi Linux with custom GPU drivers
- Custom kernel modules in `apple-silicon-support/`
- Firmware in `systems/nixos/austria/firmware/`

### japan (Steam Deck)
- Jovian NixOS with Decky Loader
- Auto-mounts SD card to `/games`
- Syncthing for game saves/ROMs

### china (Home Server)
- Media stack: Jellyfin, Sonarr, Radarr, Lidarr, etc.
- NFS mounts for media storage (Synology NAS)
- Nginx reverse proxy for services
- User groups for permission management
- **Attic binary cache server** (port 5000, Tailscale only)
- NFS mount `/nix-cache` for Attic storage on Synology

### germany (Mac Mini)
- Yabai window manager
- Rclone mounts for media
- Tdarr transcoding node

### vietnam (Samsung Galaxy Z Fold 5)
- Nix-on-Droid (proot-based, no root required)
- Claude Code for mobile AI development
- Zellij + Mosh for persistent remote sessions
- Syncthing (manual start via `sync-start` alias)
- Outer Wilds theme (pure black OLED)

---

## CI/CD

GitHub Actions workflows in `.github/workflows/`:
- `build.yaml` - Unified build for all systems (norway, china, japan), pushes to Attic + Cachix
- `main.yaml` - Daily flake.lock updates
- `deadnix.yml` - Dead code detection
- `claude.yml` / `claude-code-review.yml` - Claude Code automation

### Build Pipeline

1. **EC2 Spot Runner** starts (c6i.4xlarge, 100GB disk)
2. **Nix** installed with flake support
3. **Cachix** + **Magic Nix Cache** for CI acceleration
4. **Tailscale** connects to home network
5. **Builds** all systems: `jacob-norway`, `jacob-china`, `jacob-japan`
6. **Pushes** to both Cachix (public) and Attic (self-hosted)

---

## Troubleshooting

### Rebuild fails
```bash
# Check for syntax errors
nix flake check

# Build with verbose output
sudo nixos-rebuild switch --flake . --show-trace
```

### Hardware config changes
```bash
# Regenerate hardware config
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

### Secrets not decrypting
```bash
# Ensure age key exists
cat ~/.config/sops/age/keys.txt

# Re-encrypt secrets
sops --encrypt --in-place secrets/secrets.yaml
```
