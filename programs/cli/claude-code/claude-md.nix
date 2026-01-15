# Nix-generated CLAUDE.md for Claude Code
# This file is generated from Nix expressions with package path interpolation
# Edit THIS file (claude-md.nix), not the generated CLAUDE.md
{
  pkgs,
  config,
  lib,
  ...
}: ''
  !date && timedatectl | grep "Time zone"

  # Jacob's CachyOS Workstation

  > **Home Base**: Brisbane, Australia | **Schedule**: Early bird, flexible hours | **Note**: I travel often, so check the timezone above for current location context.
  >
  > **This CLAUDE.md is Nix-generated** - edit `claude-md.nix` in the Nix-Configuration repo, not this file!

  ---

  ## About Me

  - **Name**: Jacob Pyke
  - **GitHub**: [JPyke3](https://github.com/JPyke3) | github@pyk.ee
  - **Role**: Team Lead on Payroll-Standard project
  - **Work Style**: Early riser, most productive in mornings, flexible schedule
  - **Interests**: Local LLMs, mechanical keyboards, gaming

  ---

  ## System Overview

  ### Hardware
  | Component | Specification |
  |-----------|---------------|
  | **CPU** | AMD Ryzen AI 9 HX 370 w/ Radeon 890M (16 cores) |
  | **GPU** | NVIDIA RTX 5070 Ti Mobile + AMD Radeon 880M/890M |
  | **RAM** | 30GB + 30GB zram swap |
  | **Storage** | 3.6TB NVMe SSD |

  ### Operating System
  - **Distro**: CachyOS (Arch-based rolling release)
  - **Kernel**: 6.18.2-3-cachyos (custom optimized)
  - **Desktop**: KDE Plasma 6.5.4 + Hyprland (Wayland)
  - **Dotfiles**: ML4W 2.9.9 framework

  ### Peripherals
  - Custom ZMK wireless Corne keyboard (sometimes used)
  - SteelSeries Arctis buds (gaming/calls)
  - Controllers: DualSense, 8BitDo Pro

  ---

  ## Development Environment

  ### Languages & Versions
  | Language | Version | Notes |
  |----------|---------|-------|
  | Node.js | 22.21.1 LTS | Primary for web projects |
  | Python | 3.13.11 | Use uv/pipx for isolation |
  | Rust | 1.92.0 | Cargo for packages |
  | Go | 1.25.5 | System tools |
  | Kotlin | via Android Studio | Primary for mobile |
  | Java | JDK 17+ | Android development |

  ### Editors & IDEs
  - **Primary**: Neovim (set as $EDITOR)
  - **Android**: Android Studio 2025.2.1.8
  - **Config**: `~/.config/nvim/init.vim`

  ### Terminal
  - **Shell**: Zsh + Oh-My-Zsh + Powerlevel10k (Fish also available)
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
  - Use `pkexec` to elevate permissions when root access is needed (not `sudo`)
  - Always download files to `~/Downloads/` (use `${pkgs.aria2}/bin/aria2c -d ~/Downloads/`)

  ### Git Workflow
  - **Commit Style**: Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`)
  - Always run pre-commit hooks when available
  - Create focused, atomic commits

  ---

  ## Package Management

  ### Preferences by Ecosystem
  | Ecosystem | Preferred Tool | Notes |
  |-----------|----------------|-------|
  | System (Arch) | `yay` | AUR helper |
  | Python | `uv` / `pipx` | Isolation over global pip |
  | Node.js | `npm` | Standard npm |
  | Rust | `cargo` | Standard cargo |

  ### Common Commands
  ```bash
  # System packages
  yay -S <package>
  yay -Syu  # Full system upgrade

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

  ### Network Awareness
  - **Tailscale** is installed - internal services may be accessible via Tailscale network
  - **NordVPN/OpenVPN** available for external VPN needs
  - Home network uses Syncthing for file sync

  ---

  ## Remote Development

  ### Available Machines
  | Machine | Purpose | Access |
  |---------|---------|--------|
  | Mac Mini | Running various services | SSH via Tailscale |
  | Home Server | Storage, services | SSH via Tailscale |

  ### SSH Patterns
  - Keys: Ed25519 (`~/.ssh/id_ed25519`)
  - Use Tailscale hostnames when possible
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
  - **Launchers**: Steam (Proton CachyOS), Lutris, Heroic
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
