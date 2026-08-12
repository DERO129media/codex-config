#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf 'Fehler: %s\n' "$1" >&2
  exit 1
}

xml_escape() {
  local value
  value="$1"
  value="${value//&/&amp;}"
  value="${value//</&lt;}"
  value="${value//>/&gt;}"
  value="${value//\"/&quot;}"
  value="${value//\'/&apos;}"
  printf '%s' "$value"
}

systemd_quote() {
  local value
  value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  value="${value//%/%%}"
  printf '"%s"' "$value"
}

enable_macos_auto_update() {
  local update_script label domain plist_dir plist_file temp_file
  local escaped_label escaped_script escaped_stdout escaped_stderr

  update_script="$1"
  label="de.dero.codex-config.update"
  domain="gui/$(id -u)"
  plist_dir="$HOME/Library/LaunchAgents"
  plist_file="$plist_dir/$label.plist"
  temp_file="${plist_file}.tmp.$$"

  escaped_label="$(xml_escape "$label")"
  escaped_script="$(xml_escape "$update_script")"
  escaped_stdout="$(xml_escape "$CODEX_DIR/codex-config-update.log")"
  escaped_stderr="$(xml_escape "$CODEX_DIR/codex-config-update.error.log")"

  mkdir -p "$plist_dir"

  cat >"$temp_file" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$escaped_label</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$escaped_script</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
  <key>StartInterval</key>
  <integer>900</integer>
  <key>StandardOutPath</key>
  <string>$escaped_stdout</string>
  <key>StandardErrorPath</key>
  <string>$escaped_stderr</string>
</dict>
</plist>
EOF

  mv "$temp_file" "$plist_file"

  if launchctl print "$domain/$label" >/dev/null 2>&1; then
    launchctl bootout "$domain/$label"
  fi

  launchctl bootstrap "$domain" "$plist_file"
  launchctl enable "$domain/$label"
  launchctl kickstart -k "$domain/$label"

  printf 'Auto-Update aktiviert: launchd prüft das Repository alle 15 Minuten.\n'
}

enable_linux_auto_update() {
  local update_script unit_dir service_name timer_name service_file timer_file
  local bash_path exec_start

  update_script="$1"
  command -v systemctl >/dev/null 2>&1 ||
    fail "systemctl ist nicht verfügbar; Auto-Update konnte nicht eingerichtet werden."
  systemctl --user show-environment >/dev/null 2>&1 ||
    fail "Kein aktiver systemd-User-Manager. Unter WSL zuerst systemd aktivieren."

  unit_dir="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
  service_name="dero-codex-config-update.service"
  timer_name="dero-codex-config-update.timer"
  service_file="$unit_dir/$service_name"
  timer_file="$unit_dir/$timer_name"
  bash_path="$(command -v bash)"
  exec_start="$(systemd_quote "$bash_path") $(systemd_quote "$update_script")"

  mkdir -p "$unit_dir"

  cat >"$service_file" <<EOF
[Unit]
Description=Update Dennis Codex configuration

[Service]
Type=oneshot
ExecStart=$exec_start
TimeoutStartSec=5min
EOF

  cat >"$timer_file" <<EOF
[Unit]
Description=Update Dennis Codex configuration every 15 minutes

[Timer]
OnCalendar=*:0/15
Persistent=true
RandomizedDelaySec=30s
Unit=$service_name

[Install]
WantedBy=timers.target
EOF

  systemctl --user daemon-reload
  systemctl --user enable --now "$timer_name"

  printf 'Auto-Update aktiviert: systemd prüft das Repository alle 15 Minuten.\n'
  printf 'Hinweis für Server: Der User-Manager muss nach dem Logout weiterlaufen; siehe README zum Linger-Modus.\n'
}

ENABLE_AUTO_UPDATE=false

case "${1:-}" in
  "") ;;
  --enable-auto-update) ENABLE_AUTO_UPDATE=true ;;
  *) fail "Unbekannte Option: $1. Erlaubt ist nur --enable-auto-update." ;;
esac

[[ $# -le 1 ]] || fail "Zu viele Argumente."

case "$(uname -s)" in
  MINGW* | MSYS* | CYGWIN*)
    fail "Unter Windows bitte install.ps1 in PowerShell verwenden."
    ;;
esac

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SOURCE="$REPO_DIR/AGENTS.md"

if [[ -n "${CODEX_HOME:-}" ]]; then
  CODEX_DIR="$CODEX_HOME"
elif [[ -n "${HOME:-}" ]]; then
  CODEX_DIR="$HOME/.codex"
else
  fail "Weder CODEX_HOME noch HOME ist gesetzt."
fi

[[ -f "$SOURCE" ]] || fail "Quelldatei fehlt: $SOURCE"

mkdir -p "$CODEX_DIR"
CODEX_DIR="$(cd "$CODEX_DIR" && pwd -P)"
TARGET="$CODEX_DIR/AGENTS.md"

if [[ -L "$TARGET" && "$TARGET" -ef "$SOURCE" ]]; then
  printf 'Symlink ist bereits korrekt:\n%s -> %s\n' "$TARGET" "$SOURCE"
else
  if [[ -d "$TARGET" && ! -L "$TARGET" ]]; then
    fail "Ziel ist ein Verzeichnis und wird nicht automatisch ersetzt: $TARGET"
  fi

  if [[ -e "$TARGET" || -L "$TARGET" ]]; then
    BACKUP="${TARGET}.backup.$(date +%Y%m%d-%H%M%S)"
    [[ ! -e "$BACKUP" && ! -L "$BACKUP" ]] || fail "Backup-Ziel existiert bereits: $BACKUP"

    mv "$TARGET" "$BACKUP"
    printf 'Bestehendes Ziel gesichert:\n%s\n' "$BACKUP"
  fi

  ln -s "$SOURCE" "$TARGET"

  if [[ ! -L "$TARGET" || ! "$TARGET" -ef "$SOURCE" ]]; then
    fail "Symlink konnte nicht verifiziert werden: $TARGET"
  fi

  printf 'Symlink erstellt:\n%s -> %s\n' "$TARGET" "$SOURCE"
fi

if [[ "$ENABLE_AUTO_UPDATE" == true ]]; then
  UPDATE_SCRIPT="$REPO_DIR/update.sh"
  [[ -x "$UPDATE_SCRIPT" ]] || fail "Updater fehlt oder ist nicht ausführbar: $UPDATE_SCRIPT"

  case "$(uname -s)" in
    Darwin) enable_macos_auto_update "$UPDATE_SCRIPT" ;;
    Linux) enable_linux_auto_update "$UPDATE_SCRIPT" ;;
    *) fail "Auto-Update wird auf diesem Betriebssystem nicht unterstützt." ;;
  esac
fi
