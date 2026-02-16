# Nix-generated CLAUDE.md for Claude Code
# This file is generated from Nix expressions with package path interpolation
# Edit THIS file (claude-md.nix), not the generated CLAUDE.md
{
  pkgs,
  config,
  lib,
  ...
}: ''
  # Jacob's NixOS Workstation

  > Nix-generated from `claude-md.nix` — edit that file, not this one.

  ## Platform & Config
  - **NixOS** with Flakes + home-manager | Config repo: `~/Development/Nix-Configuration/`
  - Rebuild: `sudo nixos-rebuild switch --flake ~/Development/Nix-Configuration#jacob-norway`
  - Format Nix files: `${pkgs.alejandra}/bin/alejandra .`
  - **NEVER** use `nix profile install` — use `nix shell nixpkgs#<pkg>` or `nix run nixpkgs#<pkg>` for temporary needs
  - Permanent packages: add to Nix config and rebuild
  - Use `pkexec` for root elevation (not `sudo`)
  - Download files to `~/Downloads/`: `${pkgs.aria2}/bin/aria2c -d ~/Downloads/ <url>`

  ## Machines (geographic names, Tailscale-connected)
  **norway** (this laptop) | **china** (home server) | **germany** (Mac Mini) | **austria** (Asahi MacBook) | **japan** (Steam Deck) | **vietnam** (Galaxy Fold)

  ## Behavior
  - **Proactive & autonomous** — take initiative, make reasonable assumptions, move quickly
  - **Test-driven** — always write/run tests, maintain coverage requirements
  - **Functional style** — immutability, pure functions, early returns, max 3 nesting levels
  - **Rich formatting** — use emojis (✅❌⚠️🔧🚀🔍💡🎯📦🧪🐛), **bold**, tables, headers for scannability
  - **Conventional commits** — `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`

  ## Coding Standards
  - Zero linter warnings (ESLint, Detekt, Black, Clippy)
  - Strict types: TypeScript strict mode, Python type hints + mypy, Kotlin null safety
  - JSDoc/KDoc/docstrings on all public APIs
  - Small focused functions, descriptive names, max 3 nesting levels

  ## Testing Requirements
  - **Android**: 80% minimum coverage, enforced via pre-commit
  - **TypeScript/Node**: 100% coverage where possible
  - **Python**: pytest with good coverage

  ## Security
  - **NEVER** commit secrets — use `.env` files, never hardcode credentials
  - System secrets: SOPS-nix with age encryption
  - Pre-commit hooks run gitleaks + semgrep

  ## Primary Project
  **Payroll-Standard** (`~/Development/Payroll-Standard/`) — payroll platform monorepo:
  - **Android app** (PRIMARY FOCUS): Kotlin + Jetpack Compose, Clean Architecture + MVI, Detekt + ktlint 1.5.0
  - PAYS-CMS: Next.js 13.5 + Payload CMS 2.0 | PAYI-Backend: AWS CDK + TypeScript
''
