# Dennis Codex Config

Dieses Repository ist die zentrale Source of Truth für meine globalen Codex-Arbeits- und Qualitätsregeln. Die Regeln stehen ausschließlich in [`AGENTS.md`](./AGENTS.md) und werden nicht in einzelne Projekte kopiert.

## Regelhierarchie

Codex kombiniert die Anweisungen automatisch:

1. `~/.codex/AGENTS.md` beziehungsweise `%USERPROFILE%\.codex\AGENTS.md` – globale Regeln
2. `<repository>/AGENTS.md` – projektspezifische Architektur, Contracts und Ausnahmen
3. `<repository>/<teilbereich>/AGENTS.md` – eng begrenzte Sonderregeln, nur wenn nötig

Je näher eine Datei am aktuellen Arbeitsverzeichnis liegt, desto höher ist ihre Priorität. Projektdateien sollen deshalb nur Wissen enthalten, das nicht sinnvoll global gilt.

Beim Arbeiten in diesem Config-Repository selbst kann dieselbe `AGENTS.md` einmal global und einmal als Repository-Regel geladen werden. Das ist erwartbar; in anderen Repositories greift sie nur global.

## Passender Installer

| System und Codex-Umgebung | Installer | Standardziel |
| --- | --- | --- |
| macOS – Codex-App und CLI | `install.sh` | `~/.codex/AGENTS.md` |
| Ubuntu/Linux – CLI | `install.sh` | `~/.codex/AGENTS.md` |
| Windows nativ – Codex-App und CLI | `install.ps1` | `%USERPROFILE%\.codex\AGENTS.md` |
| Windows WSL2 – App im WSL-Modus und WSL-CLI | `install.sh` | `~/.codex/AGENTS.md` innerhalb von WSL |

Native Windows-Prozesse und WSL verwenden standardmäßig unterschiedliche Codex-Home-Verzeichnisse. Wer beide Varianten nutzt, führt beide Installer in der jeweiligen Umgebung aus oder setzt bewusst ein gemeinsames `CODEX_HOME`.

Beide Installer respektieren `CODEX_HOME`, sichern vorhandene Dateien oder abweichende Symlinks mit einem Zeitstempel und lassen einen bereits korrekten Symlink unverändert. Verzeichnisse am Zielpfad werden aus Sicherheitsgründen nicht automatisch ersetzt.

## Einrichtung

Repository an einen dauerhaften Ort klonen:

```bash
git clone git@github.com:DERO129media/codex-config.git ~/codex-config
cd ~/codex-config
```

Auf macOS, Ubuntu oder innerhalb von WSL2 inklusive Auto-Update:

```bash
./install.sh --enable-auto-update
```

Unter nativem Windows in PowerShell inklusive Auto-Update:

```powershell
git clone git@github.com:DERO129media/codex-config.git "$HOME\codex-config"
Set-Location "$HOME\codex-config"
.\install.ps1 -EnableAutoUpdate
```

Ohne Auto-Update können die Installer weiterhin ohne Option ausgeführt werden. Mit der Option richten sie eine Prüfung alle 15 Minuten ein:

- macOS: LaunchAgent `de.dero.codex-config.update`
- Ubuntu/Linux/WSL2: systemd-User-Timer `dero-codex-config-update.timer`
- Windows nativ: Aufgabe `DERO Codex Config Auto Update`

Der macOS-LaunchAgent und die Windows-Aufgabe laufen im angemeldeten Benutzerkontext. Der Ubuntu-Timer kann mit aktiviertem Linger auch nach dem Logout weiterarbeiten.

Der Updater führt ausschließlich `git pull --ff-only` aus. Bei lokalen Änderungen, einem Detached HEAD, fehlendem Upstream oder nicht fast-forward-fähigem Stand bricht er ab und versucht es beim nächsten Lauf erneut. Er verwirft oder überschreibt keine lokalen Änderungen. macOS und Windows schreiben Scheduler-Ausgaben in das jeweilige Codex-Home; unter Linux stehen sie im systemd-Journal.

Der Scheduler arbeitet ohne interaktive Git-Abfragen. Der Remote-Zugriff muss deshalb vorher funktionieren. Für einen Headless-Ubuntu-Server eignet sich beispielsweise ein auf dieses Repository begrenzter Read-only-Deploy-Key.

Unter Linux benötigt die automatische Einrichtung einen aktiven systemd-User-Manager. Auf einem dauerhaft laufenden Ubuntu-Server muss für Updates nach dem Logout gegebenenfalls einmalig Linger aktiviert werden:

```bash
sudo loginctl enable-linger "$USER"
```

Innerhalb von WSL2 muss systemd aktiviert sein. Native Windows-Prozesse werden unabhängig davon über die Windows-Aufgabenplanung aktualisiert.

Falls PowerShell die Ausführung blockiert oder Windows das Erstellen eines Symlinks ablehnt, müssen gegebenenfalls die PowerShell-Ausführungsrichtlinie, der Windows-Entwicklermodus oder Administratorrechte angepasst werden.

## Automatisch mit Codex einrichten

Diesen Prompt in einer lokalen Codex-Session verwenden:

```text
Hier ist das Repository mit meiner globalen Codex-Konfiguration: https://github.com/DERO129media/codex-config

Lies die README.md vollständig. Klone oder öffne das Repository an einem dauerhaften Ort und richte danach die globale AGENTS.md mit dem passenden vorhandenen Installer ein. Aktiviere dabei auch das Auto-Update alle 15 Minuten. Berücksichtige Betriebssystem, CODEX_HOME sowie unter Windows die Unterscheidung zwischen nativer Ausführung und WSL. Sichere vorhandene Ziele entsprechend dem Installer. Prüfe anschließend den Symlink, den nicht-interaktiven Git-Zugriff und den sicheren Updater mit einem manuellen Testlauf. Kontrolliere außerdem, ob der native Scheduler registriert und aktiv ist. Prüfe auf einem Ubuntu-Server zusätzlich, ob der systemd-User-Manager nach dem Logout weiterläuft. Falls die Codex CLI verfügbar ist, prüfe mit einem neuen Codex-Aufruf, ob die globale Instruction-Datei geladen wird. Ändere die AGENTS.md nicht, verwirf keine lokalen Änderungen und committe oder pushe nichts. Nenne mir abschließend Zielpfad, Scheduler, Prüfergebnis und gegebenenfalls den Backup-Pfad.
```

## Manuell prüfen

Auf macOS, Ubuntu oder in WSL2:

```bash
ls -l "${CODEX_HOME:-$HOME/.codex}/AGENTS.md"
```

Unter nativem Windows in PowerShell:

```powershell
$CodexDir = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { "$HOME\.codex" }
Get-Item "$CodexDir\AGENTS.md" | Format-List FullName, LinkType, Target
```

Codex selbst kann die aktive Instruction-Kette in einer neuen Session prüfen:

```bash
codex --ask-for-approval never "Zeige mir, welche Instruction-Dateien aktiv sind."
```

In einem sauberen Checkout kann der Updater manuell getestet werden:

```bash
./update.sh
```

```powershell
.\update.ps1
```

Den Auto-Update-Scheduler prüfen:

```bash
# macOS
launchctl print "gui/$(id -u)/de.dero.codex-config.update"

# Ubuntu/Linux/WSL2
systemctl --user status dero-codex-config-update.timer --no-pager
systemctl --user list-timers dero-codex-config-update.timer --no-pager
```

```powershell
# Windows nativ
Get-ScheduledTask -TaskName 'DERO Codex Config Auto Update'
```

## Änderungen verteilen

Änderungen werden nur hier vorgenommen, anschließend committed und gepusht. Geräte mit aktiviertem Scheduler übernehmen den neuen Stand innerhalb von ungefähr 15 Minuten, sobald sie Netzwerkzugriff haben und der jeweilige User-Scheduler läuft. Ein schmutziger Worktree wird bewusst nicht aktualisiert.

Ohne Auto-Update bleibt der manuelle Weg:

```bash
cd ~/codex-config
git pull --ff-only
```

Der Symlink macht die aktuelle Version direkt verfügbar. Bereits laufende Codex-Sessions müssen neu gestartet werden; ein zusätzlicher Cache muss nicht gelöscht werden.

Weitere Details: [Offizielle OpenAI-Dokumentation zu `AGENTS.md`](https://learn.chatgpt.com/docs/agent-configuration/agents-md) und [Windows-/WSL-Konfiguration](https://learn.chatgpt.com/docs/windows/windows-app#share-config-auth-and-sessions-with-wsl).
