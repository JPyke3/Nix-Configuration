#!/usr/bin/env bash
#
# Claude Code SessionStart hook for Nix-Configuration
# Automatically installs git pre-commit hooks and required tools
#

set -e

REPO_ROOT="${CLAUDE_PROJECT_DIR:-.}"
LOCAL_BIN="$HOME/.local/bin"

echo "[Claude] Initializing Nix-Configuration development environment..."

# Ensure local bin directory exists and is in PATH
mkdir -p "$LOCAL_BIN"
export PATH="$LOCAL_BIN:$PATH"

# Install git pre-commit hooks
if [ -f "$REPO_ROOT/scripts/pre-commit" ] && [ -d "$REPO_ROOT/.git/hooks" ]; then
    if [ -f "$REPO_ROOT/.git/hooks/pre-commit" ]; then
        INSTALLED_HASH=$(sha256sum "$REPO_ROOT/.git/hooks/pre-commit" 2>/dev/null | cut -d' ' -f1 || echo "")
        SOURCE_HASH=$(sha256sum "$REPO_ROOT/scripts/pre-commit" 2>/dev/null | cut -d' ' -f1 || echo "")

        if [ "$INSTALLED_HASH" = "$SOURCE_HASH" ]; then
            echo "[Claude] Pre-commit hook already installed and up-to-date"
        else
            echo "[Claude] Updating pre-commit hook..."
            cp "$REPO_ROOT/scripts/pre-commit" "$REPO_ROOT/.git/hooks/pre-commit"
            chmod +x "$REPO_ROOT/.git/hooks/pre-commit"
            echo "[Claude] Pre-commit hook updated"
        fi
    else
        echo "[Claude] Installing pre-commit hook..."
        cp "$REPO_ROOT/scripts/pre-commit" "$REPO_ROOT/.git/hooks/pre-commit"
        chmod +x "$REPO_ROOT/.git/hooks/pre-commit"
        echo "[Claude] Pre-commit hook installed"
    fi
else
    echo "[Claude] Warning: Could not find pre-commit hook or .git directory"
fi

# Install alejandra if not available (standalone binary available)
if ! command -v alejandra &> /dev/null; then
    echo "[Claude] Installing alejandra (Nix formatter)..."
    if curl -sL https://github.com/kamadorueda/alejandra/releases/latest/download/alejandra-x86_64-unknown-linux-musl -o "$LOCAL_BIN/alejandra" 2>/dev/null; then
        chmod +x "$LOCAL_BIN/alejandra"
        echo "[Claude] alejandra installed to $LOCAL_BIN"
    else
        echo "[Claude] Warning: Failed to download alejandra"
    fi
fi

# Check for tools that require Nix
echo "[Claude] Checking tool availability..."
AVAILABLE=()
MISSING=()

command -v alejandra &> /dev/null && AVAILABLE+=("alejandra") || MISSING+=("alejandra")
command -v deadnix &> /dev/null && AVAILABLE+=("deadnix") || MISSING+=("deadnix (requires Nix)")
command -v statix &> /dev/null && AVAILABLE+=("statix") || MISSING+=("statix (requires Nix)")
command -v nix &> /dev/null && AVAILABLE+=("nix") || MISSING+=("nix")

if [ ${#AVAILABLE[@]} -gt 0 ]; then
    echo "[Claude] Available: ${AVAILABLE[*]}"
fi

if [ ${#MISSING[@]} -gt 0 ]; then
    echo "[Claude] Not available: ${MISSING[*]}"
    echo "[Claude] Note: Some checks will be skipped. Full linting requires Nix."
fi

# Set environment variables for the session
if [ -n "$CLAUDE_ENV_FILE" ]; then
    cat >> "$CLAUDE_ENV_FILE" << EOF
export PATH="$LOCAL_BIN:\$PATH"
export NIX_CONFIG_HOOKS_INSTALLED=1
EOF
fi

echo "[Claude] Development environment ready!"
exit 0
