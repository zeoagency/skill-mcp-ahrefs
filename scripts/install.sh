#!/usr/bin/env bash
# ==============================================================================
# skill-mcp-ahrefs installer
# Installs the Ahrefs SEO Intelligence Skill into your AI coding assistant.
# Supports: Antigravity, Claude Code, Cursor, Windsurf, or custom directories.
# ==============================================================================

set -euo pipefail

SKILL_NAME="ahrefs-seo-intelligence"
REPO_URL="https://github.com/zeoagency/skill-mcp-ahrefs.git"

# Text formatting
BOLD="\033[1m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
YELLOW="\033[0;33m"
RED="\033[0;31m"
RESET="\033[0m"

info() { echo -e "${BLUE}${BOLD}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}${BOLD}[SUCCESS]${RESET} $1"; }
warn() { echo -e "${YELLOW}${BOLD}[WARN]${RESET} $1"; }
error() { echo -e "${RED}${BOLD}[ERROR]${RESET} $1"; exit 1; }

# Parse arguments
TARGET_DIR=""
MODE="symlink" # symlink | copy

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target|-t)
      TARGET_DIR="$2"
      shift 2
      ;;
    --copy|-c)
      MODE="copy"
      shift
      ;;
    --symlink|-s)
      MODE="symlink"
      shift
      ;;
    --help|-h)
      echo "Usage: ./install.sh [options]"
      echo ""
      echo "Options:"
      echo "  --target, -t <dir>   Target skills directory to install into"
      echo "  --copy, -c           Copy files instead of symlinking"
      echo "  --symlink, -s        Create symbolic link (default)"
      echo "  --help, -h           Show this help message"
      exit 0
      ;;
    *)
      error "Unknown option: $1"
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Detect default targets if not specified
if [[ -z "$TARGET_DIR" ]]; then
  echo -e "${BOLD}Select your target environment:${RESET}"
  echo "1) Google Antigravity / AGY (~/.gemini/config/skills/)"
  echo "2) Claude Code (~/.claude/skills/)"
  echo "3) Cursor / Custom Agent Skills (~/.cursor/skills/)"
  echo "4) Custom directory"
  read -r -p "Enter choice [1-4] (default 1): " choice || choice="1"
  choice="${choice:-1}"

  case "$choice" in
    1) TARGET_DIR="$HOME/.gemini/config/skills/$SKILL_NAME" ;;
    2) TARGET_DIR="$HOME/.claude/skills/$SKILL_NAME" ;;
    3) TARGET_DIR="$HOME/.cursor/skills/$SKILL_NAME" ;;
    4)
      read -r -p "Enter absolute path for target directory: " custom_path
      TARGET_DIR="$custom_path/$SKILL_NAME"
      ;;
    *)
      TARGET_DIR="$HOME/.gemini/config/skills/$SKILL_NAME"
      ;;
  esac
fi

PARENT_DIR="$(dirname "$TARGET_DIR")"
mkdir -p "$PARENT_DIR"

info "Installing $SKILL_NAME into $TARGET_DIR using mode: $MODE..."

# Remove existing installation/symlink if present
if [[ -L "$TARGET_DIR" || -d "$TARGET_DIR" ]]; then
  warn "Removing existing destination at $TARGET_DIR"
  rm -rf "$TARGET_DIR"
fi

if [[ "$MODE" == "symlink" ]]; then
  ln -s "$SCRIPT_DIR" "$TARGET_DIR"
  success "Created symlink: $TARGET_DIR -> $SCRIPT_DIR"
else
  mkdir -p "$TARGET_DIR"
  cp -r "$SCRIPT_DIR/SKILL.md" "$SCRIPT_DIR/references" "$TARGET_DIR/"
  success "Copied skill files to $TARGET_DIR"
fi

echo ""
echo -e "${GREEN}${BOLD}✓ Ahrefs SEO Intelligence Skill successfully installed!${RESET}"
echo -e "Target path: ${BOLD}$TARGET_DIR${RESET}"
echo -e "Skill triggers: 'audit domain SEO', 'find striking distance keywords', 'compare competitors in Ahrefs', 'analyze content gap', etc."
echo ""
