#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SRC_ROOT="$SCRIPT_DIR/skills"
DEST_ROOT="${CODEX_HOME:-$HOME/.codex}/skills"
FORCE=0
DRY_RUN=0
LIST_ONLY=0

declare -a SELECTED_SKILLS=()

die() {
  echo "[install] $*" >&2
  exit 1
}

usage() {
  cat <<'USAGE'
Install Codex skills from this repository.

Usage:
  ./install.sh [options]

Options:
  --skill <name>     Install only one skill (repeatable)
  --dest <path>      Destination skills root (default: ${CODEX_HOME:-$HOME/.codex}/skills)
  --force            Overwrite destination skill folders if they already exist
  --dry-run          Print actions without writing files
  --list             List available skills and exit
  -h, --help         Show help

Examples:
  ./install.sh
  ./install.sh --skill godot-headless
  ./install.sh --dest "$HOME/.codex/skills" --force
USAGE
}

list_available_skills() {
  local found=0
  for d in "$SRC_ROOT"/*; do
    [[ -d "$d" ]] || continue
    [[ -f "$d/SKILL.md" ]] || continue
    basename "$d"
    found=1
  done

  if [[ $found -eq 0 ]]; then
    die "No installable skills found in $SRC_ROOT"
  fi
}

install_skill() {
  local skill_name="$1"
  local src="$SRC_ROOT/$skill_name"
  local dst="$DEST_ROOT/$skill_name"

  [[ -d "$src" ]] || die "Skill not found: $skill_name"
  [[ -f "$src/SKILL.md" ]] || die "Invalid skill (missing SKILL.md): $skill_name"

  if [[ -e "$dst" && $FORCE -ne 1 ]]; then
    echo "[install] Skip existing skill (use --force to overwrite): $skill_name"
    return 0
  fi

  if [[ $DRY_RUN -eq 1 ]]; then
    if [[ -e "$dst" ]]; then
      echo "[install] Would overwrite: $dst"
    else
      echo "[install] Would install: $dst"
    fi
    return 0
  fi

  mkdir -p "$DEST_ROOT"
  if [[ -e "$dst" ]]; then
    rm -rf "$dst"
  fi
  cp -R "$src" "$dst"
  echo "[install] Installed: $skill_name -> $dst"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skill)
      [[ $# -ge 2 ]] || die "Missing value for --skill"
      SELECTED_SKILLS+=("$2")
      shift 2
      ;;
    --dest)
      [[ $# -ge 2 ]] || die "Missing value for --dest"
      DEST_ROOT="$2"
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --list)
      LIST_ONLY=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "Unknown option: $1"
      ;;
  esac
done

[[ -d "$SRC_ROOT" ]] || die "Skills source directory missing: $SRC_ROOT"

if [[ $LIST_ONLY -eq 1 ]]; then
  list_available_skills
  exit 0
fi

if [[ ${#SELECTED_SKILLS[@]} -eq 0 ]]; then
  while IFS= read -r skill_name; do
    SELECTED_SKILLS+=("$skill_name")
  done < <(list_available_skills)
fi

for skill_name in "${SELECTED_SKILLS[@]}"; do
  install_skill "$skill_name"
done

if [[ $DRY_RUN -eq 1 ]]; then
  echo "[install] Dry run complete."
else
  echo "[install] Done. Restart Codex to pick up installed/updated skills."
fi
