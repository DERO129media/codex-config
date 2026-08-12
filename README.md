# Dennis Codex Config

Dieses Repository ist die zentrale Source of Truth für meine globalen Codex-Arbeits- und Qualitätsregeln. Die Regeln stehen ausschließlich in [`AGENTS.md`](./AGENTS.md) und werden nicht in einzelne Projekte kopiert.

## Regelhierarchie

Codex kombiniert die Anweisungen automatisch:

1. `~/.codex/AGENTS.md` – allgemeine, projektübergreifende Regeln
2. `<repository>/AGENTS.md` – projektspezifische Architektur, Contracts und Ausnahmen
3. `<repository>/<teilbereich>/AGENTS.md` – eng begrenzte Sonderregeln, nur wenn nötig

Je näher eine Datei am aktuellen Arbeitsverzeichnis liegt, desto höher ist ihre Priorität. Projektdateien sollen deshalb nur Wissen enthalten, das nicht sinnvoll global gilt.

Beim Arbeiten in diesem Config-Repository selbst kann dieselbe `AGENTS.md` einmal global und einmal als Repository-Regel geladen werden. Das ist erwartbar; in anderen Repositories greift sie nur global.

## Einrichtung

Repository an einen dauerhaften Ort klonen und die globale Codex-Datei verlinken:

```bash
git clone git@github.com:DERO129media/codex-config.git ~/codex-config
mkdir -p ~/.codex
ln -s ~/codex-config/AGENTS.md ~/.codex/AGENTS.md
```

Falls `~/.codex/AGENTS.md` bereits existiert, diese vorher sichern oder bewusst ersetzen.

## Änderungen verteilen

Änderungen werden nur hier vorgenommen, anschließend committed und gepusht. Auf weiteren Geräten genügt:

```bash
cd ~/codex-config
git pull
```

Der Symlink macht die aktuelle Version direkt verfügbar. Bereits laufende Codex-Sessions müssen neu gestartet werden; ein zusätzlicher Cache muss nicht gelöscht werden.

Zur Kontrolle:

```bash
codex --ask-for-approval never "Zeige mir, welche Instruction-Dateien aktiv sind."
```

Weitere Details: [Offizielle OpenAI-Dokumentation zu `AGENTS.md`](https://developers.openai.com/codex/agent-configuration/agents-md)
