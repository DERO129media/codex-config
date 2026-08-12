# DERO – Globale AGENTS.md

Diese Datei enthält meine allgemeinen Arbeits- und Qualitätsregeln. Projektspezifische `AGENTS.md`-Dateien dürfen diese Regeln ergänzen oder dort überschreiben, wo das jeweilige Repository bewusst andere Anforderungen hat.

## Grundprinzipien

Optimiere in dieser Reihenfolge für:

1. Korrektheit
2. Einfachheit
3. Konsistenz mit dem bestehenden Code
4. Wartbarkeit
5. Sicherheit und Robustheit
6. Performance, wenn sie praktisch relevant ist

## Erst verstehen, dann ändern

Vor Änderungen:

- Relevante bestehende Implementierung lesen.
- Die nächstgelegene projektspezifische `AGENTS.md` und relevante Dokumentation unter `/docs` lesen.
- Die aktuelle Source of Truth bestimmen und nicht auf Erinnerung, alte Pläne oder historische Notizen vertrauen.
- Nach vorhandenen Komponenten, Utilities, Hooks, Services, Schemas, Konfigurationen und Patterns suchen, bevor etwas Neues angelegt wird.
- Den aktuellen Git-Status prüfen und fremde beziehungsweise nicht zum Auftrag gehörende Änderungen erhalten.
- Bei strukturellen Änderungen zuerst den betroffenen Datenfluss und die Modulgrenzen verstehen.

Keine neue Architektur schaffen, wenn das Repository bereits ein geeignetes etabliertes Muster besitzt.

## Einfachheit vor Komplexität

Bevorzuge die kleinste Implementierung, die das gewünschte Problem vollständig und sauber löst.

- Nicht over-engineeren.
- Keine Abstraktionen für hypothetische zukünftige Anforderungen einführen (nur ggf. erwähnen).
- Keine parallelen Implementierungen für bereits gelöste Probleme schaffen.
- Unnötige Wrapper, Adapter, Factory-Schichten und Indirektion vermeiden.
- Eine Helper-Funktion, die nur einmal verwendet wird, nur dann anlegen, wenn sie die Lesbarkeit deutlich verbessert.
- Direkten und verständlichen Code cleverem Code vorziehen.
- Veralteten Code entfernen, statt unbegründete Kompatibilitätspfade dauerhaft mitzuschleppen.
- Den Scope nicht beiläufig um fremde Refactorings oder Cleanups erweitern.

Wenn 200 Zeilen geschrieben wurden und dasselbe Verhalten klar und vernünftig in etwa 50 Zeilen umgesetzt werden könnte, die Lösung vereinfachen und neu schreiben.

Die Zeilenzahl ist kein Zielwert. Sie ist lediglich ein Warnsignal für möglicherweise unnötige Komplexität.

## Wiederverwenden vor Neuerfinden

Bevor etwas Neues angelegt wird, zuerst nach einem bestehenden Äquivalent suchen, insbesondere bei:

- Komponenten
- Utilities
- Hooks
- Services
- Datenmodellen
- Konfigurationen
- CSS-Patterns
- Validierungsschemas
- Abstraktionen

Eine etablierte generische Lösung bevorzugen, bevor eine Sonderlösung entsteht. Wiederverwendung nicht erzwingen, wenn dadurch eine kleine lokale Lösung deutlich komplizierter oder schwerer verständlich würde.

## Abhängigkeiten

Neue Produktionsabhängigkeiten sind Kosten und keine kostenlose Abkürzung.

Vor dem Hinzufügen einer Dependency:

1. Prüfen, ob der vorhandene Stack das Problem bereits lösen kann.
2. Prüfen, ob die benötigte Funktionalität klein genug für eine lokale Implementierung ist.
3. Die Dependency nur hinzufügen, wenn sie Komplexität, Wartungsaufwand oder Risiko tatsächlich reduziert.

Keine Packages nur aus Bequemlichkeit hinzufügen. Keine Framework- oder grundlegenden Bibliothekswechsel durchführen, wenn die Aufgabe dies nicht ausdrücklich erfordert.

## Architektur

Bestehende Modul-, Zuständigkeits- und Ownership-Grenzen respektieren.

- Verantwortlichkeiten klar halten.
- Fachlogik nicht in Darstellungscode verschieben, wenn das Projekt diese Bereiche trennt.
- Versteckte Kopplungen zwischen Modulen vermeiden.
- Eine kanonische Source of Truth gegenüber synchronisierten Doppelzuständen bevorzugen.
- Keine zweite Repräsentation kanonischer Daten ohne klaren Grund einführen.
- Bestehende öffentliche Contracts erhalten, sofern ihre Änderung nicht Teil der Aufgabe ist.

## UI und Designsystem

Das Design soll zentral steuerbar sein. Wenn bereits ein Designsystem existiert:

- Vorhandene Tokens, Primitives und Komponenten verwenden.
- Zentrale Designentscheidungen nicht durch willkürliche lokale Werte umgehen.
- Bestehende UI-Primitives nicht erneut implementieren.
- Semantische Design-Tokens gegenüber rohen visuellen Werten bevorzugen.

Farben, Typografie, Abstände, Radien, Schatten und andere wiederkehrende Designentscheidungen sollen, wo sinnvoll, eine zentrale Source of Truth besitzen. Feature-Code konsumiert das Designsystem und definiert es nicht jedes Mal neu.

Wenn sich ein visuelles Muster wiederholt und noch nicht zentral existiert, prüfen, ob es in die gemeinsame UI-/Design-Schicht gehört, bevor mehrere lokale Varianten entstehen. Der Code ist die Source of Truth für konkrete Designwerte. Dokumentation erklärt das System und seine Regeln, statt alle Werte redundant zu duplizieren.

Für kleine Projekte kein unnötig komplexes Designsystem bauen.

## Accessibility

Bei nutzerseitigen Oberflächen:

- Semantisches HTML verwenden, wo möglich.
- Bedienbarkeit per Tastatur erhalten.
- Icon-only-Controls mit zugänglichen Bezeichnungen versehen.
- Fokusverhalten nicht ohne barrierefreien Ersatz entfernen.
- Bestehende zugängliche Dialog-, Formular- und Benachrichtigungsmuster wiederverwenden.

Bestehende Accessibility-Patterns des Repositories gehen vor neuen Sonderlösungen.

## Daten, Sicherheit und Fehler

Externe, importierte, persistierte und nutzergesteuerte Daten an Systemgrenzen grundsätzlich als nicht vertrauenswürdig behandeln. Vorhandene Validierungs- und Fehlerbehandlungsmechanismen des Projekts verwenden.

- Keine Secrets, Tokens oder Zugangsdaten exponieren.
- Keine sensiblen Payloads unnötig loggen.
- Relevante Fehler nicht stillschweigend verschlucken.
- Fehlende fachliche Daten oder Eigenschaften nicht erfinden.
- Bestehende Sicherheitsgrenzen erhalten, sofern deren Änderung nicht ausdrücklich Teil der Aufgabe ist.

Keine spekulative Security-Infrastruktur einführen, die mit dem aktuellen Auftrag nichts zu tun hat.

## Dokumentationsprinzipien

Dokumentation enthält dauerhaft relevantes Wissen. Nicht dokumentieren, nur weil sich Code geändert hat.

Dokumentation ist sinnvoll für:

- Projektzweck, Setup und Betrieb
- Architektur und Zuständigkeitsgrenzen
- wichtige technische Contracts
- nicht offensichtliche Designentscheidungen
- Security- und Datenanforderungen
- wiederkehrende Wartungsabläufe
- wichtige bekannte Grenzen

Nicht dokumentieren:

- offensichtliche Implementierungsdetails
- temporäre Debug-Erkenntnisse
- Sitzungsverläufe
- erledigte Aufgabenlisten
- Informationen, die bereits klar durch Code oder Tests ausgedrückt werden
- dieselbe Information in mehreren Dokumenten

Jede dauerhaft relevante Information soll eine eindeutige Source of Truth haben.

### Bevorzugte Dokumentationsstruktur

Nur Dateien verwenden, die das Projekt tatsächlich benötigt:

- `README.md` – Zweck, Setup, Kommandos und Orientierung
- `AGENTS.md` – projektspezifische Codex-Regeln, Constraints und Verifikation
- `docs/ARCHITECTURE.md` – Architektur und wichtige Systemgrenzen
- `docs/DESIGN.md` – Designsystem und UI-Prinzipien, wenn relevant
- `docs/README.md` – Doku-Navigation nur bei ausreichend umfangreicher Dokumentation
- `docs/decisions/` – nur für wichtige Entscheidungen, deren Begründung später relevant bleibt

Keine leeren oder rein zeremoniellen Dokumentationsdateien anlegen. Wird Dokumentation zu groß, nach Verantwortungsbereichen aufteilen, statt eine einzelne riesige Datei wachsen zu lassen. Historische Pläne und Audits klar als historisch kennzeichnen. Sie dürfen nicht stillschweigend zu aktuellen Vertragsquellen werden.

## Dokumentation aktualisieren

Dokumentation im selben Change aktualisieren, wenn eine dort festgehaltene dauerhafte Information durch die Änderung falsch wird. Typische Auslöser:

- Setup oder Befehle ändern sich
- Architektur ändert sich
- Daten- oder API-Contracts ändern sich
- dokumentiertes Nutzerverhalten ändert sich
- Designsystem-Contracts ändern sich
- Security- oder Betriebsanforderungen ändern sich

Keine unbeteiligte Dokumentation nur aus Vollständigkeitsgefühl anfassen.

## Tests und Verifikation

Die Verifikation soll zum Risiko der Änderung passen. Die im Repository definierten Befehle und Werkzeuge verwenden und keinen bestimmten Stack voraussetzen. Je nach Projekt und Änderung:

1. Gezielte Tests für das geänderte Verhalten ausführen.
2. Typ- oder statische Prüfungen ausführen.
3. Lint- und Format-Prüfungen ausführen.
4. Relevante breitere Testsuite ausführen.
5. Einen Build ausführen, wenn Kompilierung, Bundling oder Packaging betroffen sein können.
6. Den finalen Diff auf unbeabsichtigte und reine Whitespace-Änderungen prüfen.

Während der Entwicklung gezielte Checks verwenden. Teure vollständige Projekt-Gates nicht nach jeder kleinen Datei erneut starten. Vor Abschluss den angemessenen vollständigen Gate des Repositories ausführen.

Browser-Automation, Screenshots, Playwright oder andere visuelle Prüfungen nicht standardmäßig ausführen, außer:

- der Nutzer fordert sie ausdrücklich an,
- das Repository verlangt sie ausdrücklich,
- oder sie sind tatsächlich notwendig, um das gewünschte Verhalten sinnvoll zu verifizieren.

Schlägt ein Check fehl, zuerst die Ursache untersuchen und nicht automatisch von einem Produktfehler ausgehen.

## Verpflichtender Self-Review

Vor Abschluss einer Implementierung den finalen Diff noch einmal aus Sicht eines Maintainers prüfen, der den Code nicht selbst geschrieben hat. Gezielt prüfen auf:

- unnötigen Code
- doppelte Logik
- unnötige Abstraktionen
- unnötige Dependencies
- Scope Creep
- Architekturverletzungen
- Umgehung des Designsystems
- veraltete Kommentare
- Dead Code
- fehlende Fehlerbehandlung
- fehlende Validierung
- fehlende oder schwache Tests
- Dokumentationsdrift
- unbeabsichtigte Änderungen außerhalb des Auftrags

Explizit fragen:

> Könnte diese Implementierung wesentlich einfacher sein und dabei genauso klar und korrekt bleiben?

Wenn ja: vor Abschluss vereinfachen.

Probleme, die durch die eigene Änderung entstanden sind und innerhalb des Scopes sicher behoben werden können, nicht lediglich im Abschlussbericht erwähnen, sondern beheben.

## Scope-Disziplin

Bei Review-, Analyse-, Diagnose- oder Planungsaufgaben:

- Untersuchen und berichten.
- Das Repository nicht verändern, sofern keine Änderung angefordert wurde.

Bei Implementierungs-, Fix- oder Refactoring-Aufgaben:

- Die angeforderten Änderungen innerhalb des Scopes umsetzen.
- Normale nicht-destruktive Verifikation ohne zusätzliche Rückfrage durchführen.
- Gewöhnliche Implementierungsdetails selbstständig entscheiden, wenn das gewünschte Verhalten eindeutig ist.

Nur dann Rückfragen stellen, wenn eine offene Entscheidung Produktverhalten, Datenkompatibilität, Sicherheit oder Scope wesentlich verändern würde. Eine fokussierte Aufgabe nicht in einen repositoryweiten Umbau verwandeln.

## Git

Bestehende fremde oder unzusammenhängende Worktree-Änderungen erhalten.

- Unbeteiligte Nutzeränderungen niemals verwerfen oder überschreiben.
- Nur Dateien stagen, die zum abgeschlossenen Auftrag gehören.
- Commits fokussiert halten.
- Beim Erstellen von Commits Conventional Commits verwenden.
- Unzusammenhängende Änderungen nicht in einem Commit vermischen.
- Nicht pushen, sofern dies nicht ausdrücklich autorisiert wurde.

Definiert ein Repository einen spezielleren Git-Workflow, gelten dessen projektspezifische Regeln.

## Kontinuierliche Verbesserung

Wenn Codex wiederholt denselben Fehler macht, in dieser Reihenfolge prüfen:

1. Kann das gewünschte Verhalten durch Code, Typen oder Architektur strukturell erzwungen werden?
2. Kann ein deterministischer Test oder eine Lint-Regel den Fehler verhindern?
3. Sollte die relevante Projektdokumentation verbessert werden?
4. Sollte eine kurze Regel in die nächstgelegene passende `AGENTS.md` aufgenommen werden?

Keine dauerhaften Regeln für einmalige Fehler ansammeln.
Veraltete Regeln entfernen oder aktualisieren.