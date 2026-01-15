# Nix-generated CLAUDE.md for Claude Code
# This file is generated from Nix expressions with package path interpolation
# Edit THIS file (claude-md.nix), not the generated CLAUDE.md
{
  pkgs,
  config,
  lib,
  ...
}: ''
  !${pkgs.coreutils}/bin/echo "=== Session Context ===" && ${pkgs.coreutils}/bin/date "+%Y-%m-%d %H:%M:%S %Z" && ${pkgs.systemd}/bin/timedatectl | ${pkgs.gnugrep}/bin/grep "Time zone" && ${pkgs.coreutils}/bin/echo "Location:" && (${pkgs.curl}/bin/curl -s --max-time 3 "https://ipinfo.io/json" 2>/dev/null | ${pkgs.jq}/bin/jq -r '"  \(.city), \(.region), \(.country) (IP: \(.ip))"' 2>/dev/null || ${pkgs.coreutils}/bin/echo "  Unable to determine") && ${pkgs.coreutils}/bin/echo "Host: $(${pkgs.coreutils}/bin/hostname)" && ${pkgs.coreutils}/bin/echo "NixOS:" && (${pkgs.coreutils}/bin/cat /etc/os-release 2>/dev/null | ${pkgs.gnugrep}/bin/grep -E "^(NAME|VERSION)=" | ${pkgs.gnused}/bin/sed 's/^/  /') && ${pkgs.coreutils}/bin/echo "Kernel: $(${pkgs.coreutils}/bin/uname -r)" && ${pkgs.coreutils}/bin/echo "Tailscale: $(${pkgs.tailscale}/bin/tailscale status --self --json 2>/dev/null | ${pkgs.jq}/bin/jq -r '.Self.HostName // "not connected"' 2>/dev/null || ${pkgs.coreutils}/bin/echo "not available")" && ${pkgs.coreutils}/bin/echo "==="

  # Jacob's NixOS Workstation

  > **Home Base**: Brisbane, Australia | **Schedule**: Early bird, flexible hours | **Note**: I travel often, check the session context above for current location.
  >
  > **This CLAUDE.md is Nix-generated** - edit `claude-md.nix` in the Nix-Configuration repo, not this file!
  >
  > **Platform**: NixOS with Nix Flakes - all system configuration is declarative and reproducible.

  ---

  ## About Me

  - **Name**: Jacob Pyke
  - **GitHub**: [JPyke3](https://github.com/JPyke3) | github@pyk.ee
  - **Role**: Team Lead on Payroll-Standard project
  - **Work Style**: Early riser, most productive in mornings, flexible schedule
  - **Interests**: Local LLMs, mechanical keyboards, gaming

  ---

  ## System Overview

  ### Platform
  - **OS**: NixOS (declarative Linux distribution)
  - **Configuration**: Nix Flakes with home-manager
  - **Desktop**: KDE Plasma 6 + Hyprland (Wayland)
  - **Config Repo**: `~/Development/Nix-Configuration/`

  ### Hardware
  | Component | Specification |
  |-----------|---------------|
  | **CPU** | AMD Ryzen AI 9 HX 370 w/ Radeon 890M (16 cores) |
  | **GPU** | NVIDIA RTX 5070 Ti Mobile + AMD Radeon 880M/890M |
  | **RAM** | 30GB + 30GB zram swap |
  | **Storage** | 3.6TB NVMe SSD |

  ### Peripherals
  - Custom ZMK wireless Corne keyboard (sometimes used)
  - SteelSeries Arctis buds (gaming/calls)
  - Controllers: DualSense, 8BitDo Pro

  ---

  ## NixOS Specifics

  ### Key Concepts
  - **Declarative**: All system config lives in `~/Development/Nix-Configuration/`
  - **Reproducible**: Same config = same system on any machine
  - **Rollback**: Can boot into any previous generation if something breaks
  - **Flakes**: Modern Nix with locked dependencies via `flake.lock`

  ### Common Nix Commands
  ```bash
  # Rebuild system (after editing config)
  sudo nixos-rebuild switch --flake ~/Development/Nix-Configuration#jacob-norway

  # Update all flake inputs
  nix flake update

  # Search for packages
  nix search nixpkgs <package>

  # Run a package without installing (PREFERRED for one-off commands)
  nix run nixpkgs#<package> -- <args>

  # Enter a dev shell with specific packages (PREFERRED for sessions)
  nix shell nixpkgs#nodejs nixpkgs#yarn

  # Garbage collect old generations
  sudo nix-collect-garbage -d

  # Format Nix files
  ${pkgs.alejandra}/bin/alejandra .
  ```

  ### CRITICAL: Package Installation Rules

  **NEVER use `nix profile install`** - This creates imperative state that conflicts with declarative NixOS.

  | Scenario | Correct Approach |
  |----------|------------------|
  | Need a tool temporarily | `nix shell nixpkgs#<package>` or `nix run nixpkgs#<package>` |
  | Need a tool permanently | Add to Nix config (`home.nix` or `configuration.nix`) and rebuild |
  | Command not found | Use `nix shell nixpkgs#<package>` to get it temporarily |
  | Testing a tool | `nix run nixpkgs#<package> -- --help` |

  **Examples:**
  ```bash
  # WRONG - creates imperative state
  nix profile install nixpkgs#ripgrep

  # CORRECT - temporary shell with ripgrep
  nix shell nixpkgs#ripgrep

  # CORRECT - run ripgrep once without installing
  nix run nixpkgs#ripgrep -- "pattern" .

  # CORRECT - add to config for permanent installation
  # Edit home.nix: home.packages = [ pkgs.ripgrep ];
  # Then: sudo nixos-rebuild switch --flake .#jacob-norway
  ```

  ### Machine Names (Geographic Convention)
  | Name | Platform | Purpose |
  |------|----------|---------|
  | **norway** | NixOS x86_64 | Primary ASUS ROG laptop (this machine) |
  | **austria** | NixOS aarch64 | Apple Silicon MacBook (Asahi) |
  | **japan** | NixOS x86_64 | Steam Deck OLED |
  | **china** | NixOS x86_64 | Home server |
  | **germany** | nix-darwin | Mac Mini |
  | **vietnam** | Nix-on-Droid | Samsung Galaxy Z Fold 5 |

  ---

  ## Development Environment

  ### Languages & Versions
  | Language | Version | Notes |
  |----------|---------|-------|
  | Node.js | 22.x LTS | Primary for web projects |
  | Python | 3.13.x | Use uv/pipx for isolation |
  | Rust | Latest stable | Cargo for packages |
  | Go | Latest stable | System tools |
  | Kotlin | via Android Studio | Primary for mobile |
  | Java | JDK 17+ | Android development |

  ### Editors & IDEs
  - **Primary**: Neovim (set as $EDITOR)
  - **Android**: Android Studio
  - **Config**: `~/.config/nvim/init.vim`

  ### Terminal
  - **Shell**: Zsh + Oh-My-Zsh + Pure prompt
  - **Terminal**: Kitty (primary), Alacritty (secondary)
  - **Multiplexer**: Zellij (vim-style navigation)

  ### Modern CLI Tools (Prefer These - Nix Store Paths)

  Use these **Nix store paths** for reliability across all systems:

  | Traditional | Modern Replacement | Nix Path |
  |-------------|-------------------|----------|
  | `ls` | `eza -a --icons=always` | `${pkgs.eza}/bin/eza` |
  | `cat` | `bat` | `${pkgs.bat}/bin/bat` |
  | `grep` | `rg` (ripgrep) | `${pkgs.ripgrep}/bin/rg` |
  | `find` | `fd` | `${pkgs.fd}/bin/fd` |
  | `du` | `dust` | `${pkgs.dust}/bin/dust` |
  | `df` | `duf` | `${pkgs.duf}/bin/duf` |
  | `curl`/`wget` | `aria2c` | `${pkgs.aria2}/bin/aria2c` |

  **Quick Reference Scripts** (Nix paths guaranteed to work):
  ```bash
  # System info
  ${pkgs.fastfetch}/bin/fastfetch

  # File listing with icons
  ${pkgs.eza}/bin/eza -la --icons=always

  # Search file contents
  ${pkgs.ripgrep}/bin/rg "pattern"

  # Find files by name
  ${pkgs.fd}/bin/fd "filename"

  # JSON processing
  ${pkgs.jq}/bin/jq '.key' file.json

  # Git operations
  ${pkgs.git}/bin/git status
  ```

  ### Containers & Virtualization
  - Docker + Docker Desktop
  - QEMU for VMs

  ---

  ## Primary Projects

  ### 1. Payroll-Standard (MAIN FOCUS)
  **Location**: `/home/jacobpyke/Development/Payroll-Standard/`

  A comprehensive payroll management platform monorepo:

  | Component | Tech Stack | Purpose |
  |-----------|------------|---------|
  | PAYS-CMS | Next.js 13.5 + Payload CMS 2.0 | Web platform & CMS |
  | PAYI-Backend | AWS CDK + TypeScript | Infrastructure & AI orchestration |
  | **payroll-standard-android** | Kotlin + Jetpack Compose | **Mobile app (PRIMARY FOCUS)** |
  | Payroll-Standard-Amplify | Markdown | Documentation wiki |

  #### Android App Details (Primary Focus)
  - **Architecture**: Clean Architecture + MVI pattern
  - **Min SDK**: 24 | **Target SDK**: 36
  - **Testing**: 80% coverage minimum required
  - **Quality Tools**: Detekt, ktlint 1.5.0, pre-commit hooks
  - **AI Integration**: PAY-i chatbot using Anthropic Claude API

  **Common Commands**:
  ```bash
  # Build
  ./gradlew assembleDebug

  # Install on device
  ./gradlew installDebug

  # Run tests
  ./gradlew test

  # Code quality
  ./gradlew detekt
  ./gradlew ktlintCheck
  ./gradlew ktlintFormat

  # Coverage report
  ./gradlew jacocoTestReport
  ```

  ### 2. AiMP-Mobile-Builds
  **Location**: `/home/jacobpyke/Development/AiMP-Mobile-Builds/`
  - Monorepo with AWS Lambda microservices
  - MetaMealMixer backends (Stripe, S3, DynamoDB)
  - OpenAI GPT integration

  ### 3. Other Active Projects
  | Project | Location | Tech Stack |
  |---------|----------|------------|
  | obsidian-game-backlog | `~/Development/obsidian-game-backlog/` | TypeScript, Obsidian plugin |
  | whisper-dictate | `~/Development/whisper-dictate/` | Python, PyQt6, whisper.cpp |
  | Pyk.ee | `~/Development/Pyk.ee/` | Vanilla JS, zero-build |
  | ZMK | `~/Development/zmk/` | Zephyr RTOS, C (keyboard firmware) |

  ---

  ## Coding Standards

  ### Style Preferences
  - **Strict linting**: Zero warnings allowed (ESLint, Detekt, Black, Clippy)
  - **Type safety**: TypeScript strict mode, Python type hints + mypy, Kotlin null safety
  - **Documentation**: JSDoc/KDoc/docstrings on all public APIs
  - **Functional style**: Prefer immutability, pure functions, avoid unnecessary classes

  ### Testing Requirements
  - **Android**: 80% minimum coverage, enforced via pre-commit
  - **TypeScript/Node**: 100% coverage where possible (obsidian-game-backlog, Website-Test)
  - **Python**: pytest with good coverage

  ### Code Quality Rules
  - Maximum nesting depth: 3 levels
  - Prefer early returns over deep nesting
  - Small, focused functions
  - Descriptive variable names

  ---

  ## Claude Behavior Preferences

  ### How I Want Claude to Work
  1. **Proactive & Autonomous**: Take initiative, make reasonable assumptions, move quickly
  2. **Test-Driven**: Always write/run tests, maintain coverage requirements
  3. **Modern Tools**: Use modern CLI tools (eza, bat, rg, fd) over traditional ones
  4. **Functional Style**: Prefer immutability and pure functions
  5. **Expressive Output**: Make responses visually engaging and easy to scan

  ### Response Formatting Rules
  Use rich formatting to make output readable and visually interesting:

  | Element | Usage |
  |---------|-------|
  | **Bold** | Key terms, important info, file names, command names |
  | *Italics* | Emphasis, notes, asides |
  | `code` | Inline code, paths, variables, CLI commands |
  | Emojis | Status indicators and visual anchors |

  **Common Emoji Guide**:
  - ✅ Success / Done
  - ❌ Error / Failed
  - ⚠️ Warning / Caution
  - 📁 Files / Directories
  - 🔧 Fixes / Configuration
  - 🚀 Deployment / Launch
  - 🔍 Searching / Investigating
  - 💡 Tips / Suggestions
  - 🎯 Goals / Targets
  - 🔐 Security / Permissions
  - 📦 Packages / Dependencies
  - 🧪 Testing
  - 🐛 Bugs

  **Formatting Best Practices**:
  - Use headers (##, ###) to organize longer responses
  - Use bullet points and numbered lists for clarity
  - Use tables for comparing options or listing structured data
  - Use code blocks with syntax highlighting for multi-line code
  - Bold the **most important** words in each paragraph for scannability

  ### When Working on Code
  - Read existing code before suggesting changes
  - Follow existing patterns in the codebase
  - Run linters and tests before considering work complete
  - Use Neovim syntax when suggesting file edits

  ### System Administration
  - This is **NixOS** - edit Nix config files, don't use imperative package managers
  - **NEVER use `nix profile install`** - use `nix shell` or `nix run` for temporary needs
  - If a command is not found, use `nix shell nixpkgs#<package>` to get it temporarily
  - Use `pkexec` to elevate permissions when root access is needed (not `sudo`)
  - Always download files to `~/Downloads/` (use `${pkgs.aria2}/bin/aria2c -d ~/Downloads/`)
  - For permanent system changes, edit the Nix configuration and rebuild

  ### Git Workflow
  - **Commit Style**: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`)
  - Always run pre-commit hooks when available
  - Create focused, atomic commits

  ---

  ## Package Management

  ### NixOS Package Management
  | Task | Command |
  |------|---------|
  | Search packages | `nix search nixpkgs <package>` |
  | Run temporarily | `nix run nixpkgs#<package>` |
  | Dev shell | `nix shell nixpkgs#pkg1 nixpkgs#pkg2` |
  | Add to system | Edit `configuration.nix` or `home.nix`, then rebuild |
  | Update inputs | `nix flake update` |

  ### Per-Ecosystem Tools
  | Ecosystem | Preferred Tool | Notes |
  |-----------|----------------|-------|
  | System | Nix | Declarative via flake config |
  | Python | `uv` / `pipx` | Isolation over global pip |
  | Node.js | `npm` | Standard npm |
  | Rust | `cargo` | Standard cargo |

  ### Common Commands
  ```bash
  # Rebuild NixOS system
  sudo nixos-rebuild switch --flake ~/Development/Nix-Configuration#jacob-norway

  # Python (isolated tools)
  pipx install <tool>
  uv pip install <package>

  # Node.js
  npm install
  npm run build
  npm test
  ```

  ---

  ## Security Practices

  ### Critical Rules
  1. **NEVER commit secrets** - Use `.env` files, never hardcode credentials
  2. **Pre-commit hooks** - Run security scanners (gitleaks, semgrep) before commits
  3. **Bitwarden** - Use `bw` CLI for credential management when needed
  4. **SOPS-nix** - System secrets are managed via SOPS encryption in the Nix config

  ### Network Awareness
  - **Tailscale** is installed - internal services accessible via Tailscale network
  - **NordVPN/OpenVPN** available for external VPN needs
  - Home network uses Syncthing for file sync

  ---

  ## Remote Development

  ### Available Machines (via Tailscale)
  | Machine | Hostname | Purpose |
  |---------|----------|---------|
  | Mac Mini | `jacob-germany` | Running various services |
  | Home Server | `jacob-china` | Storage, media, binary cache |
  | Steam Deck | `jacob-japan` | Gaming, portable dev |

  ### SSH Patterns
  - Keys: Ed25519 (`~/.ssh/id_ed25519`)
  - Use Tailscale hostnames: `ssh jacob-china`, `ssh jacob-germany`
  - Config in `~/.ssh/config` if needed

  ---

  ## Interests & Future Goals

  ### Local LLMs
  Deeply interested but not yet configured on this machine. Would like to set up:
  - Code assistance (Codestral, DeepSeek Coder)
  - General chat capabilities
  - Local embeddings for RAG/document search

  The RTX 5070 Ti has plenty of VRAM for this - just needs setup.

  ### Gaming
  - **Launchers**: Steam (Proton), Lutris, Heroic
  - **Games**: Minecraft, Factorio, RuneScape (RuneLite), various Steam games
  - **Controllers**: DualSense, 8BitDo Pro (switch frequently)

  ### Keyboards
  - Custom ZMK wireless Corne keyboard
  - Firmware in `~/Development/zmk/`
  - Sometimes use laptop keyboard (currently)

  ---

  ## Directory Structure

  ```
  ~/Development/
  ├── Nix-Configuration/          # THIS MACHINE'S CONFIG (Nix flake)
  ├── Payroll-Standard/           # Main project (monorepo)
  │   ├── PAYS-CMS/               # Next.js + Payload CMS
  │   ├── PAYI-Backend/           # AWS CDK
  │   ├── payroll-standard-android/  # Kotlin (PRIMARY FOCUS)
  │   └── Payroll-Standard-Amplify/  # Docs
  ├── AiMP-Mobile-Builds/         # Secondary project
  ├── obsidian-game-backlog/      # Obsidian plugin
  ├── whisper-dictate/            # Python speech-to-text
  ├── Pyk.ee/                     # Personal portfolio
  ├── zmk/                        # Keyboard firmware
  └── ... (25+ total projects)

  ~/.config/
  ├── nvim/                       # Neovim config
  ├── kitty/                      # Terminal config
  ├── hypr/                       # Hyprland WM
  ├── zshrc/                      # Zsh modules
  └── ...

  ~/.claude/
  ├── CLAUDE.md                   # This file (Nix-generated)
  ├── settings.json               # Claude Code settings (Nix-managed)
  ├── settings.local.json         # Permissions (user-managed, seeded by Nix)
  └── plugins/                    # Installed plugins
  ```

  ---

  ## Quick Reference

  ### Payroll-Standard Android (Most Common)
  ```bash
  cd ~/Development/Payroll-Standard/payroll-standard-android

  # Build & run
  ./gradlew assembleDebug && ./gradlew installDebug

  # Test with coverage
  ./gradlew test jacocoTestReport

  # Lint & format
  ./gradlew ktlintFormat detekt
  ```

  ### Common Aliases (from .zshrc) - Nix Paths
  ```bash
  # These use Nix store paths for reliability
  alias ll='${pkgs.eza}/bin/eza -al --icons=always'
  alias nf='${pkgs.fastfetch}/bin/fastfetch'
  ```

  ---

  *Nix-generated from `programs/cli/claude-code/claude-md.nix`*
''
