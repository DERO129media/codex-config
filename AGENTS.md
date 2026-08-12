# DERO – Globale AGENTS.md

Diese Datei definiert meine allgemeinen Arbeits- und Qualitätsregeln für Codex. Explizite Anforderungen und projektspezifische Regeln gehen vor.

## Geltungsbereich

Priorität bei Konflikten:

1. Aktueller Auftrag
2. Nächstgelegene projektspezifische `AGENTS.md`
3. Bestehende Contracts, aktuelle Dokumentation und etablierte Code-Patterns
4. Diese globale Datei

Projektspezifische Regeln dürfen diese Defaults bewusst konkretisieren oder überschreiben. Keine Regel als Vorwand verwenden, eine klare Aufgabe unnötig aufzublähen oder nicht auszuführen.

## Harte Grenzen

- Fremde oder unbeteiligte Änderungen niemals verwerfen, überschreiben oder ungefragt einbeziehen.
- Keine Secrets, Zugangsdaten oder sensiblen Daten exponieren, committen oder unnötig loggen.
- Keine destruktiven oder extern wirksamen Aktionen ohne ausdrücklichen Auftrag ausführen, insbesondere kein Push, Deployment, Versand, Löschen produktiver Daten oder irreversible Migration.
- Daten-, Berechtigungs- und Sicherheitsgrenzen nicht beiläufig verändern.
- Fehlende fachliche Informationen nicht erfinden.
- Keine Tests oder Verifikation behaupten, die nicht tatsächlich ausgeführt wurden.

## Grundprinzipien

Optimiere in dieser Reihenfolge:

1. Korrektheit
2. Einfachheit
3. Konsistenz mit dem bestehenden Code
4. Wartbarkeit
5. Praktisch relevante Performance

Sicherheit, Datenintegrität und der Erhalt fremder Änderungen sind harte Grenzen, keine nachgeordneten Optimierungsziele.

## Erst verstehen, dann ändern

Vor Änderungen:

- Relevante Implementierung, nächstgelegene `AGENTS.md` und aktuelle Dokumentation lesen.
- Die tatsächliche Source of Truth bestimmen; nicht auf alte Pläne oder Vermutungen vertrauen.
- Nach vorhandenen Komponenten, Utilities, Hooks, Services, Schemas, Konfigurationen und Patterns suchen.
- Git-Status prüfen und unbeteiligte Worktree-Änderungen erhalten.
- Bei strukturellen Änderungen zuerst Datenfluss, Zuständigkeiten und Modulgrenzen verstehen.
- Generierte Dateien über ihre kanonische Quelle ändern, nicht manuell.

Keine neue Architektur schaffen, wenn bereits ein geeignetes Muster existiert.

## Planung und Entscheidungen

Kleine, klar abgegrenzte Aufgaben direkt bearbeiten.

Vor größeren Änderungen einen kurzen Plan mit Akzeptanzkriterien erstellen, wenn mehrere Module oder Systemgrenzen betroffen sind, Datenmodelle oder öffentliche Contracts geändert werden, relevante Trade-offs bestehen oder mehrere eigenständige Schritte nötig sind.

Nach ausreichender Klärung umsetzen, statt weiter zu planen.

Rückfragen nur stellen, wenn eine offene Entscheidung Produktverhalten, Datenkompatibilität, Sicherheit oder Scope wesentlich verändert. Andernfalls eine vernünftige Annahme benennen und fortfahren.

## Einfachheit, Wiederverwendung und Architektur

Bevorzuge die kleinste vollständige und saubere Lösung.

- Nicht over-engineeren.
- Keine Abstraktionen für hypothetische Anforderungen einführen.
- Keine parallelen Lösungen für bereits gelöste Probleme schaffen.
- Unnötige Wrapper, Adapter, Factory-Schichten und Indirektion vermeiden.
- Direkten, verständlichen Code cleverem Code vorziehen.
- Keine beiläufigen Refactorings außerhalb des Auftrags durchführen.
- Keine Debug-Reste, temporären Hilfsskripte oder Logs zurücklassen.
- Veralteten Code nur entfernen, wenn dies sicher im Scope liegt.

Wenn 200 Zeilen geschrieben wurden und dasselbe Verhalten klar und vernünftig in etwa 50 Zeilen umgesetzt werden könnte, die Lösung vereinfachen und neu schreiben. Die Zeilenzahl ist nur ein Warnsignal für unnötige Komplexität.

Vor neuen Komponenten, Utilities, Hooks, Services, Datenstrukturen, CSS-Lösungen oder Validierungen zuerst nach einem bestehenden Äquivalent suchen. Wiederverwendung nicht erzwingen, wenn eine kleine lokale Lösung dadurch deutlich komplizierter wird.

Bestehende Grenzen respektieren:

- Fachlogik und Darstellung nicht vermischen, wenn das Projekt sie trennt.
- Versteckte Kopplungen vermeiden.
- Eine kanonische Source of Truth gegenüber synchronisierten Doppelzuständen bevorzugen.
- Öffentliche Contracts erhalten, sofern ihre Änderung nicht Teil der Aufgabe ist.
- Neue Abstraktionen erst bei einem konkreten wiederkehrenden Problem einführen.

## Abhängigkeiten

Neue Produktionsabhängigkeiten sind dauerhafte Kosten. Vor dem Hinzufügen prüfen:

1. Löst der vorhandene Stack das Problem?
2. Ist eine kleine, sichere lokale Lösung sinnvoller?
3. Reduziert die Dependency Komplexität, Wartungsaufwand oder Risiko?
4. Welche Folgen hat sie für Bundle, Laufzeit, Lizenz, Updates und Sicherheitsfläche?

Keine Packages nur aus Bequemlichkeit und keine Framework-Wechsel ohne ausdrückliche Notwendigkeit.

Kryptografie, Authentifizierung, Passwort-Handling, Signaturprüfung oder komplexe Protokollparser nicht selbst implementieren, wenn eine etablierte gepflegte Lösung verfügbar ist.

## UI, Designsystem und Accessibility

Das Design soll zentral steuerbar sein.

- Vorhandene Tokens, Primitives und Komponenten verwenden.
- Semantische Tokens gegenüber rohen visuellen Werten bevorzugen.
- Farben, Typografie, Abstände, Radien und Schatten nicht willkürlich lokal duplizieren.
- Wiederkehrende visuelle Muster bei Bedarf in die gemeinsame UI-Schicht überführen.
- Der Code ist die Source of Truth für konkrete Designwerte; Dokumentation erklärt das System.
- Für kleine Projekte kein unnötig komplexes Designsystem bauen.

Bei Oberflächen semantisches HTML und vorhandene zugängliche Patterns verwenden. Tastaturbedienung und sichtbaren Fokus erhalten, Icon-only-Controls zugänglich benennen und Interaktionen nicht nur über Farbe, Hover oder Mausbedienung vermitteln.

## Daten, Sicherheit und Fehler

Externe, importierte, persistierte und nutzergesteuerte Daten an Systemgrenzen als nicht vertrauenswürdig behandeln.

- Eingaben mit den vorhandenen Mechanismen validieren.
- Relevante Fehler nicht stillschweigend verschlucken.
- Ursache und Kontext diagnostizierbar halten.
- Fachliche Defaults nur verwenden, wenn sie definiert oder sicher ableitbar sind.
- Keine spekulative Security-Infrastruktur außerhalb des Auftrags einführen.

## Dokumentation und Kommentare

Dokumentation enthält dauerhaft relevantes Wissen: Setup, Betrieb, Architektur, Contracts, wichtige Designentscheidungen, Security-Anforderungen, Wartungsabläufe und bekannte Grenzen.

Nicht dokumentieren:

- offensichtliche Implementierungsdetails,
- temporäre Debug-Erkenntnisse, Sitzungsverläufe oder erledigte Aufgaben,
- Informationen, die Code oder Tests bereits eindeutig ausdrücken,
- dieselbe Information in mehreren Dokumenten.

Jede Information soll eine eindeutige Source of Truth haben. Dokumentation im selben Change aktualisieren, wenn eine festgehaltene Aussage durch die Änderung falsch wird.

Typische Dateien nur bei Bedarf: `README.md`, projektspezifische `AGENTS.md`, `docs/ARCHITECTURE.md`, `docs/DESIGN.md` und `docs/decisions/`.

Keine leeren oder zeremoniellen Dokumente anlegen. Historische Pläne klar kennzeichnen. Unbeteiligte Dokumentation nicht aus Vollständigkeitsgefühl anfassen.

Kommentare und Docstrings erklären Zweck, Invarianten, Trade-offs oder nicht offensichtliche Gründe. Sie wiederholen nicht lediglich den Code. Veraltete Kommentare entfernen oder korrigieren. TODOs nur konkret, begründet und auffindbar hinterlassen.

## Tests und Verifikation

Verifikation an Risiko und Repository-Vorgaben ausrichten:

1. Gezielte Tests für das geänderte Verhalten
2. Typ- oder statische Prüfungen
3. Lint- und Format-Prüfungen
4. Relevante breitere Testsuite
5. Build, wenn Kompilierung, Bundling oder Packaging betroffen sein können
6. Finaler Diff-Check auf unbeabsichtigte, generierte und reine Whitespace-Änderungen

Während der Entwicklung gezielte Checks verwenden. Teure vollständige Gates nicht nach jeder kleinen Änderung erneut starten; vor Abschluss den angemessenen vollständigen Gate ausführen.

Für sichtbare UI-Änderungen mindestens die leichteste sinnvolle visuelle oder interaktive Prüfung durchführen, sofern möglich. Browser-Automation, Screenshots oder E2E-Tests einsetzen, wenn Nutzer oder Repository dies verlangen, End-to-End-Verhalten betroffen ist oder das Ergebnis anders nicht zuverlässig geprüft werden kann.

Fehlschläge untersuchen und eigene Fehler, bestehende Fehler sowie Umgebungsprobleme unterscheiden.

## Self-Review

Vor Abschluss den finalen Diff prüfen auf:

- unnötigen Code, doppelte Logik und unnötige Abstraktionen,
- unnötige Dependencies und Scope Creep,
- Architekturverletzungen und Umgehung des Designsystems,
- Dead Code, Debug-Reste und veraltete Kommentare,
- fehlende Fehlerbehandlung, Validierung oder Tests,
- Dokumentationsdrift,
- Änderungen außerhalb des Auftrags.

Explizit fragen:

> Könnte diese Implementierung wesentlich einfacher sein und dabei genauso klar, korrekt und wartbar bleiben?

Wenn ja, vor Abschluss vereinfachen. Selbst verursachte Probleme innerhalb des Scopes beheben statt nur erwähnen.

## Scope und Git

Bei Review-, Analyse-, Diagnose- oder Planungsaufgaben untersuchen und berichten, aber das Repository nicht verändern, sofern keine Änderung angefordert wurde.

Bei Implementierungs-, Fix- oder Refactoring-Aufgaben die angeforderten Änderungen innerhalb des Scopes vollständig umsetzen, normale nicht-destruktive Verifikation durchführen und gewöhnliche Details selbstständig entscheiden, wenn das Ziel eindeutig ist.

Eine fokussierte Aufgabe nicht in einen repositoryweiten Umbau verwandeln.

Für Git gilt:

- Unbeteiligte Nutzeränderungen erhalten.
- Nur zum Auftrag gehörende Dateien stagen.
- Commits fokussiert halten und Conventional Commits verwenden.
- Unzusammenhängende Änderungen nicht vermischen.
- Nicht pushen, sofern dies nicht ausdrücklich autorisiert wurde.
- Keine repositoryweiten Formatierungen oder Autofixes mit unnötigen Fremdänderungen ausführen.

Ein projektspezifischer Git-Workflow geht vor.

## Definition of Done

Eine Implementierungsaufgabe ist abgeschlossen, wenn:

- das angeforderte Verhalten umgesetzt ist,
- relevante Verifikation ausgeführt wurde oder ein konkreter Blocker benannt ist,
- der finale Diff geprüft wurde,
- betroffene dauerhafte Dokumentation aktuell ist,
- keine selbst verursachten bekannten Fehler offen bleiben.

Im Abschlussbericht knapp nennen: Änderungen, ausgeführte Prüfungen, nicht mögliche Prüfungen sowie relevante Annahmen, Risiken oder Restpunkte.

## Kontinuierliche Verbesserung

Bei wiederholten Fehlern in dieser Reihenfolge vorgehen:

1. Verhalten durch Code, Typen oder Architektur erzwingen.
2. Deterministischen Test oder Lint-Regel ergänzen.
3. Projektdokumentation verbessern.
4. Erst zuletzt eine kurze Regel in die passende `AGENTS.md` aufnehmen.

Keine dauerhaften Regeln für einmalige Fehler ansammeln. Veraltete Regeln entfernen oder aktualisieren.