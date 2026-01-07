#!/usr/bin/env bash
#
# Claude Code SessionStart hook for Nix-Configuration
# Automatically installs git pre-commit hooks when starting a session
#

set -e

REPO_ROOT="${CLAUDE_PROJECT_DIR:-.}"

echo "[Claude] Initializing Nix-Configuration development environment..."

# Install git pre-commit hooks
if [ -f "$REPO_ROOT/scripts/pre-commit" ] && [ -d "$REPO_ROOT/.git/hooks" ]; then
    # Check if hook is already installed and up-to-date
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

# Verify required tools are available
echo "[Claude] Checking required tools..."
MISSING_TOOLS=()

command -v alejandra &> /dev/null || MISSING_TOOLS+=("alejandra")
command -v deadnix &> /dev/null || MISSING_TOOLS+=("deadnix")
command -v statix &> /dev/null || MISSING_TOOLS+=("statix")
command -v nix &> /dev/null || MISSING_TOOLS+=("nix")

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo "[Claude] Warning: Missing tools: ${MISSING_TOOLS[*]}"
    echo "[Claude] Pre-commit hooks may not work correctly without these tools"
else
    echo "[Claude] All required tools available"
fi

# Set environment variables for the session
if [ -n "$CLAUDE_ENV_FILE" ]; then
    cat >> "$CLAUDE_ENV_FILE" << 'EOF'
export NIX_CONFIG_HOOKS_INSTALLED=1
EOF
fi

echo "[Claude] Development environment ready!"
exit 0
