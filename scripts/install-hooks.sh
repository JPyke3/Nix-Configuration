#!/usr/bin/env bash
#
# Install git hooks for Nix-Configuration repository
#
# Usage: ./scripts/install-hooks.sh
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
HOOKS_DIR="$REPO_ROOT/.git/hooks"

echo "Installing git hooks for Nix-Configuration..."

# Ensure we're in a git repository
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo "Error: Not a git repository"
    exit 1
fi

# Create hooks directory if it doesn't exist
mkdir -p "$HOOKS_DIR"

# Install pre-commit hook
if [ -f "$HOOKS_DIR/pre-commit" ]; then
    echo "Backing up existing pre-commit hook to pre-commit.backup"
    mv "$HOOKS_DIR/pre-commit" "$HOOKS_DIR/pre-commit.backup"
fi

cp "$SCRIPT_DIR/pre-commit" "$HOOKS_DIR/pre-commit"
chmod +x "$HOOKS_DIR/pre-commit"

echo ""
echo "✓ Pre-commit hook installed successfully!"
echo ""
echo "The hook will run the following checks before each commit:"
echo "  1. alejandra  - Format Nix files"
echo "  2. deadnix    - Remove dead code"
echo "  3. statix     - Lint for anti-patterns"
echo "  4. nix flake check - Validate the flake"
echo ""
echo "Required tools (install via nix-shell or your system):"
echo "  - alejandra"
echo "  - deadnix"
echo "  - statix"
echo "  - nix (with flakes enabled)"
echo ""
echo "To skip hooks temporarily: git commit --no-verify"
