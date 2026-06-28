#!/usr/bin/env bash
# OneCrawler Skills Installer
#
# Quick install (online):
#   curl -fsSL https://raw.githubusercontent.com/makexxoo/onecrawler-skills/main/install.sh | bash
#
# Options:
#   bash install.sh --codex      Codex only
#   bash install.sh --claude     Claude Code only
#   bash install.sh --cli-only   CLI only (~/.local/bin)
#
# Idempotent: safe to run multiple times.

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; CYAN='\033[0;36m'; NC='\033[0m'
ok()   { echo -e "  ${GREEN}✓${NC} $*"; }
warn() { echo -e "  ${YELLOW}⚠${NC} $*"; }
die()  { echo -e "  ${RED}✗${NC} $*"; exit 1; }

REPO_URL="https://github.com/makexxoo/onecrawler-skills.git"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
CLAUDE_DIR="$HOME/.claude/skills"
PREFIX="${PREFIX:-$HOME/.local}"
BIN_DIR="$PREFIX/bin"
DEFAULT_BASE="http://localhost:8080"

DO_CODEX=false; DO_CLAUDE=false; DO_CLI=false; DO_ALL=true

# Parse args (handle both "bash install.sh --xxx" and "curl ... | bash -s -- --xxx")
for arg in "$@"; do
    case "$arg" in
        --codex)    DO_CODEX=true; DO_ALL=false ;;
        --claude)   DO_CLAUDE=true; DO_ALL=false ;;
        --cli-only) DO_CLI=true; DO_ALL=false ;;
        --all)      DO_ALL=true ;;
        -h|--help)  sed -n '4,10p' "$0" | sed 's/^# //;s/^#$//'; exit 0 ;;
        *) die "Unknown option: $arg" ;;
    esac
done
$DO_ALL && { DO_CODEX=true; DO_CLAUDE=true; DO_CLI=true; }

# ---- Resolve repo root ----

if [ -f "${BASH_SOURCE[0]}" ] && [ -d "$(dirname "${BASH_SOURCE[0]}")/skills" ]; then
    REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    REPO_ROOT="$(mktemp -d 2>/dev/null || mktemp -d -t onecrawler)"
    trap "rm -rf $REPO_ROOT" EXIT
    echo "Cloning $REPO_URL ..."
    git clone -q "$REPO_URL" "$REPO_ROOT"
fi

SKILLS_SRC="$REPO_ROOT/skills"
CLI_SRC="$REPO_ROOT/bin/onecrawler"

echo ""
echo -e "${CYAN}  ╔══════════════════════════════════════╗${NC}"
echo -e "${CYAN}  ║     OneCrawler Skills Installer      ║${NC}"
echo -e "${CYAN}  ╚══════════════════════════════════════╝${NC}"
echo ""

[ ! -d "$SKILLS_SRC" ] && die "Skills dir not found: $SKILLS_SRC"
$DO_CLI && [ ! -f "$CLI_SRC" ] && die "CLI not found: $CLI_SRC"

# ---- Prompt for ONECRAWLER_BASE ----

if [ -t 0 ]; then
    echo -e "${CYAN}Where is your OneCrawler service running?${NC}"
    echo -e "  Press Enter for default: ${GREEN}$DEFAULT_BASE${NC}"
    echo ""
    # Use /dev/tty for reliable interactive input (works with curl pipe too)
    read -r -p "  ONECRAWLER_BASE [$DEFAULT_BASE]: " user_base </dev/tty || true
    ONECRAWLER_BASE="${user_base:-$DEFAULT_BASE}"
else
    # Non-interactive (AI agent or piped input), use default
    ONECRAWLER_BASE="$DEFAULT_BASE"
    warn "Non-interactive mode — using default: $DEFAULT_BASE"
fi

# ---- Detect shell config file ----

detect_shell_rc() {
    local shell_name
    shell_name="$(basename "${SHELL:-$SHELL}")"
    case "$shell_name" in
        zsh)  echo "$HOME/.zshrc" ;;
        bash) echo "$HOME/.bashrc" ;;
        *)    [ -f "$HOME/.zshrc" ] && echo "$HOME/.zshrc" || echo "$HOME/.bashrc" ;;
    esac
}

SHELL_RC="$(detect_shell_rc)"

# ---- Install global CLI ----

if $DO_CLI; then
    mkdir -p "$BIN_DIR"
    if [ -f "$BIN_DIR/onecrawler" ] && diff -q "$CLI_SRC" "$BIN_DIR/onecrawler" >/dev/null 2>&1; then
        ok "CLI already up to date: $BIN_DIR/onecrawler"
    else
        cp "$CLI_SRC" "$BIN_DIR/onecrawler"
        chmod +x "$BIN_DIR/onecrawler"
        ok "CLI installed: $BIN_DIR/onecrawler"
    fi

    # Ensure ~/.local/bin is in PATH
    if ! echo "$PATH" | tr ':' '\n' | grep -qF "$BIN_DIR"; then
        if ! grep -qF "export PATH=\"$BIN_DIR" "$SHELL_RC" 2>/dev/null; then
            echo "" >> "$SHELL_RC"
            echo "# Added by OneCrawler installer" >> "$SHELL_RC"
            echo "export PATH=\"$BIN_DIR:\$PATH\"" >> "$SHELL_RC"
            ok "Added $BIN_DIR to PATH in $SHELL_RC"
        fi
    fi
fi

# ---- Configure ONECRAWLER_BASE ----

if ! grep -qF "export ONECRAWLER_BASE=" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# OneCrawler service URL" >> "$SHELL_RC"
    echo "export ONECRAWLER_BASE=\"$ONECRAWLER_BASE\"" >> "$SHELL_RC"
    ok "ONECRAWLER_BASE=$ONECRAWLER_BASE → $SHELL_RC"
else
    # Already configured — update if different
    current="$(grep 'export ONECRAWLER_BASE=' "$SHELL_RC" | tail -1 | sed 's/.*=//;s/"//g')"
    if [ "$current" != "$ONECRAWLER_BASE" ]; then
        warn "ONECRAWLER_BASE already set to $current in $SHELL_RC"
        warn "Skipping — edit manually if you want to change it."
    else
        ok "ONECRAWLER_BASE already configured: $current"
    fi
fi

# ---- Install skills ----

install_skills_to() {
    local dest="$1" label="$2"
    mkdir -p "$dest"

    # Copy CLI alongside skills for fallback
    local cli_dest="$dest/cli/onecrawler"
    mkdir -p "$(dirname "$cli_dest")"
    cp "$CLI_SRC" "$cli_dest"
    chmod +x "$cli_dest"

    # Sub-skills (directory-based)
    for dir in "$SKILLS_SRC"/*/; do
        local name; name=$(basename "$dir")
        local sf="$dir/SKILL.md"
        [ ! -f "$sf" ] && continue
        local target="$dest/onecrawler-$name"
        if [ -d "$target" ] && diff -q "$sf" "$target/SKILL.md" >/dev/null 2>&1; then
            continue
        fi
        mkdir -p "$target"
        cp "$sf" "$target/SKILL.md"
        ok "$label: onecrawler-$name"
    done

    # Root skill (single-file)
    local root_skill="$SKILLS_SRC/onecrawler.md"
    if [ -f "$root_skill" ]; then
        if [ ! -f "$dest/onecrawler.md" ] || ! diff -q "$root_skill" "$dest/onecrawler.md" >/dev/null 2>&1; then
            cp "$root_skill" "$dest/onecrawler.md"
            ok "$label: onecrawler (root)"
        fi
    fi
}

if $DO_CODEX; then
    echo ""
    echo "--- Codex ($CODEX_HOME/skills/) ---"
    install_skills_to "$CODEX_HOME/skills" "codex"
fi

if $DO_CLAUDE; then
    echo ""
    echo "--- Claude Code (~/.claude/skills/) ---"
    install_skills_to "$CLAUDE_DIR" "claude"
fi

# ---- Summary ----

echo ""
echo -e "${GREEN}Done!${NC}"
echo ""
echo "  CLI:   onecrawler health"
echo "  URL:   $ONECRAWLER_BASE"
echo "  Shell: $SHELL_RC"
echo ""

if $DO_CODEX || $DO_CLAUDE; then
    echo "  Skills installed. Restart your AI agent to pick them up."
    echo ""
fi

echo "  Run this to apply changes now:"
echo -e "    ${CYAN}source $SHELL_RC${NC}"
echo ""
echo "  Or open a new terminal and try:"
echo "    onecrawler health"
