#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

command -v git >/dev/null 2>&1 || {
  printf 'Fehler: git ist nicht verfügbar.\n' >&2
  exit 1
}

git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
  printf 'Fehler: Kein Git-Repository: %s\n' "$REPO_DIR" >&2
  exit 1
}

log() {
  local message timestamp
  message="$1"
  timestamp="$(date '+%Y-%m-%dT%H:%M:%S%z')"
  printf '%s %s\n' "$timestamp" "$message"
}

fail() {
  log "FEHLER: $1" >&2
  exit 1
}

STATUS="$(git -C "$REPO_DIR" status --porcelain)" || fail "Git-Status konnte nicht gelesen werden."
[[ -z "$STATUS" ]] || fail "Der Worktree enthält lokale Änderungen; Auto-Update übersprungen."

BRANCH="$(git -C "$REPO_DIR" branch --show-current)" || fail "Aktueller Branch konnte nicht ermittelt werden."
[[ -n "$BRANCH" ]] || fail "Detached HEAD; Auto-Update übersprungen."

git -C "$REPO_DIR" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' >/dev/null 2>&1 ||
  fail "Für $BRANCH ist kein Upstream konfiguriert."

BEFORE="$(git -C "$REPO_DIR" rev-parse --short HEAD)" || fail "Aktueller Commit konnte nicht gelesen werden."

if ! GIT_TERMINAL_PROMPT=0 GCM_INTERACTIVE=never \
  git -C "$REPO_DIR" pull --ff-only >/dev/null 2>&1; then
  fail "git pull --ff-only ist fehlgeschlagen; bitte einmal manuell prüfen."
fi

AFTER="$(git -C "$REPO_DIR" rev-parse --short HEAD)" || fail "Neuer Commit konnte nicht gelesen werden."

if [[ "$BEFORE" == "$AFTER" ]]; then
  log "Bereits aktuell auf $BRANCH ($AFTER)."
else
  log "Aktualisiert: $BRANCH $BEFORE -> $AFTER."
fi
