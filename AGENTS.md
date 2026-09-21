# DERO – Globale AGENTS.md

Diese Datei definiert meine globalen Arbeits- und Qualitätsregeln für Codex. Explizite Anforderungen und näher liegende projektspezifische `AGENTS.md`-Dateien gehen vor.

Die Regeln sind Entscheidungsprinzipien, keine Pflicht-Checkliste. Keine zusätzliche Arbeit nur zur sichtbaren Regelbefolgung erzeugen und keine Regel als Vorwand verwenden, eine klare Aufgabe aufzublähen oder nicht umzusetzen.

## Session-Bestätigung

Die erste sichtbare Antwort jeder neuen interaktiven Codex-Session beginnt mit `[DERO Config | 1.02 | Aktiv]`, sofern kein zwingendes Ausgabeformat oder maschinenlesbarer Output dagegensteht.

Der Marker erscheint nur einmal pro Session und dient als Smoke-Test, welche Version dieser Konfiguration geladen wurde.

Bei jeder Änderung an dieser globalen `AGENTS.md` die Version im Marker im selben Change erhöhen. Pro zusammengehörigem Change einmal erhöhen, nicht pro Bearbeitungsschritt. Die Zahl nach dem Punkt ist ein fortlaufender Revisionszähler mit mindestens zwei Stellen (z. B. `1.02` → `1.03`, `1.99` → `1.100`). Die aktuelle Version ausschließlich im Marker oben pflegen.

## Prioritäten und harte Grenzen

Optimiere in dieser Reihenfolge:

1. Korrektheit
2. Einfachheit
3. Konsistenz mit dem bestehenden Code
4. Wartbarkeit
5. Praktisch relevante Performance

Sicherheit, Datenintegrität und der Erhalt fremder Änderungen sind harte Grenzen.

- Fremde oder unbeteiligte Änderungen niemals verwerfen, überschreiben oder ungefragt einbeziehen.
- Keine Secrets, Zugangsdaten oder sensiblen Daten exponieren, committen oder unnötig loggen.
- Keine destruktiven oder extern wirksamen Aktionen ohne ausdrücklichen Auftrag ausführen, insbesondere kein Push, Deployment, Versand, Löschen produktiver Daten oder irreversible Migration.
- Daten-, Berechtigungs- und Sicherheitsgrenzen nicht beiläufig verändern.
- Fehlende fachliche Informationen nicht erfinden.
- Keine Tests, Prüfungen oder Ergebnisse behaupten, die nicht tatsächlich ausgeführt oder beobachtet wurden.

## Arbeitsweise

### Erst verstehen, dann ändern

- Relevante Implementierung, die nächstgelegene `AGENTS.md` und aktuelle Dokumentation lesen.
- Die tatsächliche Source of Truth bestimmen; bei strukturellen Änderungen zusätzlich Datenfluss, Zuständigkeiten und Modulgrenzen verstehen.
- Relevante Pfade, Symbole, Imports, Verwendungen und Aufrufer gezielt lokalisieren, bevor große Dateien oder Repository-Bereiche vollständig gelesen werden.
- Vor neuen Lösungen nach vorhandenen Komponenten, Utilities, Services, Schemas, Konfigurationen und Patterns suchen.
- Den Git-Status zu Beginn prüfen und unbeteiligte Worktree-Änderungen erhalten.
- Generierte Dateien über ihre kanonische Quelle ändern, nicht manuell.
- Bereits gelesene, unveränderte Dateien und bekannte Zustände nicht ohne konkrete offene Frage erneut laden oder prüfen.

Keine neue Architektur schaffen, wenn bereits ein geeignetes Muster existiert.

### Planung und Entscheidungen

Kleine, klar abgegrenzte Aufgaben direkt bearbeiten.

Einen kurzen Plan mit Akzeptanzkriterien erstellen, wenn mehrere Module oder Systemgrenzen betroffen sind, Datenmodelle oder öffentliche Contracts geändert werden, relevante Trade-offs bestehen oder mehrere eigenständige Schritte nötig sind.

Nach ausreichender Klärung umsetzen, statt weiter zu planen. Gewöhnliche und sicher reversible Implementierungsdetails selbstständig entscheiden. Nur nachfragen, wenn eine fehlende fachliche Entscheidung Produktverhalten, Datenkompatibilität, Sicherheit oder Scope wesentlich verändert und nicht sicher reversibel ist.

### Kontext- und Tool-Effizienz

Korrektheit und ausreichende Verifikation gehen vor Tokenersparnis. Bereits bekannte Informationen nicht unnötig erneut in den Modellkontext laden.

- Zusammengehörige Abfragen bündeln und Tool-Ausgaben standardmäßig kompakt halten; bei konkretem Diagnosebedarf gezielt erweitern.
- Stabile Erkenntnisse innerhalb derselben Session weiterverwenden.
- Nach größeren Arbeitsphasen einen knappen internen Stand aus relevanten Dateien, Entscheidungen, Verifikation und offenen Punkten beibehalten. Nach einer Context-Compaction darauf aufbauen, statt das Repository neu zu erkunden.
- System-, Git-, Deployment-, Health- und Testabfragen nur wiederholen, wenn sich der relevante Zustand verändert haben kann oder ein finaler Nachweis nötig ist.
- Bei Git zunächst `git diff --stat`, `git diff --name-only` oder gezielte Hunks verwenden.
- Arbeit nur parallelisieren oder an Subagents geben, wenn die Aufgaben klar getrennt sind. Keine überlappende Repository-Erkundung oder doppelte Reads erzeugen.

## Implementierungsdisziplin

Bevorzuge die kleinste vollständige und saubere Lösung, die zur bestehenden Architektur passt.

- Direkten, verständlichen Code cleverem oder unnötig generischem Code vorziehen.
- Vor neuen Komponenten, Utilities, Services, Datenstrukturen, CSS-Lösungen oder Validierungen nach einem bestehenden Äquivalent suchen.
- Wiederverwendung nicht erzwingen, wenn eine kleine lokale Lösung dadurch deutlich komplizierter wird.
- Keine Abstraktionen für hypothetische Anforderungen, parallelen Lösungen oder beiläufigen Refactorings außerhalb des Auftrags einführen.
- Keine neuen Modi, Konfigurationsschichten, Erweiterungspunkte oder Dependencies ohne konkreten Bedarf schaffen.
- Keine Debug-Reste, temporären Hilfsskripte oder unnötigen Logs zurücklassen.
- Veralteten Code nur entfernen, wenn dies sicher zum Scope gehört.

Eine Abstraktion ist gerechtfertigt, wenn sie konkrete wiederkehrende Komplexität entfernt oder eine wichtige Systemgrenze klarer und sicherer macht. Formale Sauberkeit allein reicht nicht.

Bevorzuge Lösungen, durch die Branches, Zustände, Sonderfälle, Helper oder Schichten entfallen. Komplexität nicht lediglich auf mehrere Dateien oder Abstraktionen verteilen.

Wenn die Implementierung im Verhältnis zum Problem deutlich zu komplex oder umfangreich wird, innerhalb des bestehenden Scopes vereinfachen. Den Scope nicht allein erweitern, um die Architektur grundsätzlich zu verbessern.

Bestehende Grenzen respektieren:

- Fachlogik und Darstellung trennen, wenn das Projekt dies vorsieht.
- Fachliche Entscheidungen in der kanonischen Schicht halten.
- Eine kanonische Source of Truth gegenüber synchronisierten Doppelzuständen bevorzugen.
- Öffentliche Contracts erhalten, sofern ihre Änderung nicht Teil der Aufgabe ist.
- Versteckte Kopplungen, implizite Seiteneffekte und unnötig generische Mechanismen vermeiden.
- Zusammengehörige Zustandsänderungen möglichst atomar ausführen; andernfalls eine sichere Reihenfolge und nachvollziehbare Wiederaufnahme oder Kompensation vorsehen.

### Abhängigkeiten

Vor einer neuen Produktionsabhängigkeit prüfen, ob der vorhandene Stack oder eine kleine lokale Lösung genügt und ob die Dependency Komplexität, Wartungsaufwand oder Risiko tatsächlich reduziert. Bundle, Laufzeit, Lizenz, Updates und Sicherheitsfläche berücksichtigen.

Keine Packages nur aus Bequemlichkeit und keine Framework-Wechsel ohne ausdrückliche Notwendigkeit.

Kryptografie, Authentifizierung, Passwort-Handling, Signaturprüfung oder komplexe Protokollparser nicht selbst implementieren, wenn eine etablierte und gepflegte Lösung verfügbar ist.

## Daten, Typen, Sicherheit und Fehler

Externe, importierte, persistierte und nutzergesteuerte Daten an Systemgrenzen als nicht vertrauenswürdig behandeln.

- Eingaben mit den vorhandenen Mechanismen validieren.
- In typisierten Projekten externe Daten an der Systemgrenze als `unknown` behandeln und dort eingrenzen.
- `any`, unnötige Casts, übermäßige Optionalität und stille Fallbacks nicht verwenden, um unklare Invarianten zu verdecken.
- Relevante Fehler nicht verschlucken; Ursache und fachlichen Kontext diagnostizierbar halten.
- Fachliche Defaults nur verwenden, wenn sie definiert oder sicher ableitbar sind.
- Keine spekulative Security-Infrastruktur außerhalb des Auftrags einführen.

## UI, Designsystem und Accessibility

Bei Oberflächen:

- Vorhandene Tokens, Primitives und Komponenten verwenden.
- Semantische Tokens bevorzugen und Designwerte nicht willkürlich lokal duplizieren.
- Wiederkehrende visuelle Muster nur bei tatsächlicher Wiederholung in die gemeinsame UI-Schicht überführen.
- Den Code als Source of Truth für konkrete Designwerte behandeln; Dokumentation erklärt das System.
- Für kleine Projekte kein unnötig komplexes Designsystem bauen.
- Semantisches HTML und vorhandene zugängliche Patterns verwenden.
- Tastaturbedienung und sichtbaren Fokus erhalten, Icon-only-Controls zugänglich benennen und Interaktionen nicht ausschließlich über Farbe, Hover oder Mausbedienung vermitteln.

## Dokumentation und Kommentare

Dokumentation enthält dauerhaft relevantes Wissen wie Setup, Betrieb, Architektur, Contracts, wichtige Entscheidungen, Security-Anforderungen, Wartungsabläufe und bekannte Grenzen.

- Jede Information soll eine eindeutige Source of Truth haben.
- Dokumentation im selben Change aktualisieren, wenn eine festgehaltene Aussage falsch wird.
- Keine offensichtlichen Implementierungsdetails, temporären Erkenntnisse, Sitzungsverläufe, erledigten Aufgaben oder mehrfach gepflegten Informationen dokumentieren.
- Keine leeren oder zeremoniellen Dokumente anlegen; historische Pläne klar kennzeichnen.
- Unbeteiligte Dokumentation nicht aus Vollständigkeitsgefühl anfassen.

Kommentare und Docstrings erklären Zweck, Invarianten, Trade-offs oder nicht offensichtliche Gründe, nicht lediglich den Code. Veraltete Kommentare korrigieren oder entfernen. TODOs nur konkret, begründet und auffindbar hinterlassen.

## Tests und Verifikation

Tests sind ausführbare Verhaltensverträge, kein Selbstzweck und kein Mittel zur künstlichen Erhöhung der Coverage.

Bei geändertem Verhalten mit relevantem Risiko das erwartete Verhalten vor der Implementierung festlegen und möglichst zuerst einen kleinen fokussierten Test schreiben. Test-first besonders bei geschäftskritischer, sicherheits- oder datenrelevanter Logik, öffentlichen Contracts, Datenformaten, Zustandsübergängen, Parsern, Validierung sowie reproduzierbaren Bugfixes und Regressionen bevorzugen.

Assertions aus dem gewünschten Verhalten, Contract oder reproduzierten Fehler ableiten. Keine Tests ergänzen, die nur das Typsystem, triviale Getter, Framework-Verhalten oder Implementierungsdetails wiederholen.

Für kritische Nutzerabläufe über mehrere Komponenten hinweg E2E-Tests einsetzen, sofern das Zusammenspiel nicht durch fokussierte Tests ausreichend abgesichert ist. Ausgeführte E2E-Tests mit reproduzierbarem Testaufruf und geeignetem Ergebnisnachweis, etwa Testreport oder Trace, belegen.

Für Dokumentation, reine Konfiguration, visuelle Versuche, einfache Verdrahtung oder explorative Prototypen die leichteste aussagekräftige Verifikation verwenden. Für eine kleine Änderung nicht allein ein unverhältnismäßig großes Testsystem einführen.

Verifikation risikobasiert staffeln:

1. Gezielte Tests für das geänderte Verhalten
2. Bei Bedarf Typprüfung, statische Analyse und Lint
3. Relevante breitere Testsuite
4. Bei betroffener Kompilierung, Bundling oder Packaging der Build
5. Finaler Diff-Check

Teure vollständige Verify-, Build- oder E2E-Gates erst bei stabilem Arbeitsstand und final vor Abschluss ausführen. Ein erfolgreiches Gate nicht wiederholen, wenn seitdem keine dafür relevanten Änderungen erfolgt sind.

Erfolgreiche Checks kompakt zusammenfassen. Bei Fehlschlägen zuerst die relevante Fehlerstelle mit begrenztem Kontext untersuchen. Eigene Fehler, bestehende Fehler und Umgebungsprobleme unterscheiden.

Für sichtbare UI-Änderungen mindestens die leichteste sinnvolle visuelle oder interaktive Prüfung durchführen. Zuerst den primär betroffenen Zustand und einen repräsentativen Breakpoint prüfen; weitere Zustände, Screenshots oder E2E-Läufe nur bei konkretem Risiko, Unsicherheit oder Auftrag ergänzen. Bereits beantwortete visuelle Fragen nicht erneut prüfen.

## Self-Review, Scope und Git

Bei Review-, Analyse-, Diagnose- oder Planungsaufgaben untersuchen und berichten, aber das Repository nicht verändern, sofern keine Änderung angefordert wurde. Bei Implementierungs-, Fix- oder Refactoring-Aufgaben die angeforderten Änderungen innerhalb des Scopes vollständig umsetzen und normal verifizieren.

Eine fokussierte Aufgabe nicht in einen repositoryweiten Umbau verwandeln.

Vor Abschluss mit `git diff --stat` und/oder `git diff --name-only` Umfang und Dateien erfassen und anschließend die relevanten Änderungen gezielt prüfen auf:

- unnötigen Code, doppelte Logik und unnötige Abstraktionen,
- unnötige Dependencies und Scope Creep,
- Architekturverletzungen und Umgehung des Designsystems,
- Dead Code, Debug-Reste und veraltete Kommentare,
- fehlende Fehlerbehandlung, Validierung oder Tests,
- Dokumentationsdrift und Änderungen außerhalb des Auftrags.

Explizit fragen:

> Könnte diese Implementierung wesentlich einfacher sein und dabei genauso klar, korrekt und wartbar bleiben?

Wenn ja, vor Abschluss vereinfachen. Selbst verursachte Probleme innerhalb des Scopes beheben statt nur erwähnen.

Für Git gilt:

- Keine Commits erstellen, sofern dies nicht ausdrücklich angefordert wird oder der projektspezifische Workflow Commits verlangt.
- Falls committed wird, nur zum Auftrag gehörende Dateien stagen, unzusammenhängende Änderungen trennen und fokussierte Conventional Commits verwenden.
- Nicht pushen, sofern dies nicht ausdrücklich autorisiert wurde.
- Keine repositoryweiten Formatierungen oder Autofixes mit unnötigen Fremdänderungen ausführen.

Ein projektspezifischer Git-Workflow geht vor.

## Definition of Done

Eine Implementierungsaufgabe ist abgeschlossen, wenn das angeforderte Verhalten umgesetzt, relevante Verifikation ausgeführt oder ein konkreter Blocker benannt, der finale Diff geprüft, betroffene dauerhafte Dokumentation aktualisiert und kein selbst verursachter bekannter Fehler offen ist.

Im Abschlussbericht knapp nennen: Änderungen, ausgeführte und nicht mögliche Prüfungen sowie relevante Annahmen, Risiken oder Restpunkte.

## Kontinuierliche Verbesserung

Bei wiederholten Fehlern in dieser Reihenfolge vorgehen:

1. Verhalten durch Code, Typen oder Architektur erzwingen.
2. Deterministischen Test oder eine Lint-Regel ergänzen.
3. Projektdokumentation verbessern.
4. Erst zuletzt eine kurze Regel in die passende `AGENTS.md` aufnehmen.

Keine dauerhaften Regeln für einmalige Fehler ansammeln. Veraltete Regeln entfernen oder aktualisieren.
