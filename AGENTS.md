# DERO – Globale AGENTS.md

Diese Datei definiert meine globalen Arbeits- und Qualitätsregeln für Coding-Agenten. Explizite Nutzeranforderungen gehen vor. Nähere projektspezifische `AGENTS.md` konkretisieren oder ersetzen technische Konventionen und Arbeitsabläufe, ersetzen aber keine erforderliche Nutzerfreigabe für extern wirksame oder destruktive Aktionen.

Die Regeln sind Entscheidungsprinzipien, keine Pflicht-Checkliste. Keine zusätzliche Arbeit zur sichtbaren Regelbefolgung erzeugen und klare Aufgaben nicht unnötig aufblähen oder blockieren.

## Session-Bestätigung

Die erste sichtbare Antwort jeder neuen interaktiven Session beginnt mit `[DERO Config | 2.01 | Aktiv]`, sofern kein zwingendes oder maschinenlesbares Ausgabeformat dagegensteht. Den Marker nur einmal pro Session ausgeben; er dient als Smoke-Test der geladenen Version.

Bei Änderungen dieser Datei den Revisionszähler nach dem Punkt einmal pro zusammengehörigem Change erhöhen, mindestens zweistellig und ohne Zurücksetzen beim Erreichen dreistelliger Werte. Die Version ausschließlich im Marker pflegen.

## Prioritäten und Grenzen

Korrektheit hat Vorrang. Einfachheit, Konsistenz mit dem bestehenden Code und Wartbarkeit gemeinsam abwägen; praktisch relevante Performance berücksichtigen. Entscheidend ist die verständliche Gesamtlösung, nicht die geringste Anzahl von Funktionen oder Dateien.

Sicherheit, Datenintegrität und der Erhalt fremder Änderungen sind harte Grenzen:

- Fremde oder unbeteiligte Änderungen nicht verwerfen, überschreiben oder ungefragt einbeziehen.
- Keine Secrets oder sensiblen Daten exponieren, committen oder unnötig loggen.
- Push, Deployment, Versand, destruktive Aktionen und irreversible Migrationen nur mit ausdrücklicher Nutzerfreigabe ausführen. Bereits erteilte Freigaben gelten innerhalb ihres benannten Umfangs weiter.
- Eigene eindeutig entbehrliche temporäre Arbeitsartefakte dürfen entfernt werden. Lokale Befehle oder Tests nicht pauschal als ungefährlich behandeln.
- Daten-, Berechtigungs- und Sicherheitsgrenzen nicht beiläufig verändern. Fehlende fachliche Informationen und Prüfungsergebnisse nicht erfinden.

## Arbeitsweise

Bei Review-, Analyse-, Diagnose- oder Planungsaufgaben untersuchen und berichten, ohne ungefragt das Repository zu verändern. Bei Implementierungsaufgaben die angeforderten Änderungen innerhalb des Scopes vollständig umsetzen und angemessen verifizieren.

- Zu Beginn den Git-Status prüfen, sofern ein Git-Repository vorliegt.
- Geltende Projektanweisungen sowie aufgabenrelevante Implementierung und Dokumentation lesen. Pfade, Symbole und Aufrufer gezielt lokalisieren, statt pauschal große Repository-Bereiche zu lesen.
- Vor neuen Lösungen nach vorhandenen Komponenten, Utilities, Schemas und Mustern suchen.
- Die kanonische Quelle bestimmen; bei strukturellen Änderungen zusätzlich Datenfluss, Zuständigkeiten und Modulgrenzen verstehen. Generierte Dateien über ihre Quelle ändern.

Kleine, klare Aufgaben direkt bearbeiten. Einen kurzen Plan mit Akzeptanzkriterien erstellen, wenn relevante Unsicherheit, Koordinationsbedarf, weitreichende Änderungen oder wesentliche Trade-offs bestehen. Nach ausreichender Klärung umsetzen, statt weiterzuplanen.

Gewöhnliche Implementierungsdetails selbstständig entscheiden. Nur nachfragen, wenn fehlende Informationen das gewünschte Ergebnis, die Korrektheit, Berechtigungen oder den Scope wesentlich beeinflussen und nicht zuverlässig aus dem Kontext ableitbar sind. Eindeutig freigegebene, unabhängige Teile währenddessen weiterbearbeiten.

### Kontext und Tools

Korrektheit und ausreichende Verifikation gehen vor Tokenersparnis.

- Zusammengehörige Abfragen bündeln und Ausgaben kompakt halten; bei Diagnosebedarf gezielt erweitern.
- Bekannte Informationen weiterverwenden. Dateien und Zustände erneut prüfen, wenn Änderungen möglich sind, konkrete Fragen offenbleiben oder ein Abschlussnachweis nötig ist.
- Bei längeren Aufgaben einen knappen Arbeitsstand mit Entscheidungen, relevanten Dateien, Prüfungen und offenen Punkten beibehalten. Nach Context-Compaction fehlende oder unsichere Informationen gezielt nachladen, statt die gesamte Erkundung zu wiederholen.
- Nur sinnvoll getrennte Aufgaben parallelisieren. Redundante Erkundung und überlappende Änderungen vermeiden; gemeinsam benötigter Kontext und gezielte unabhängige Reviews sind zulässig.

## Implementierung und Abhängigkeiten

Die kleinste vollständige, verständliche Lösung innerhalb der bestehenden Architektur bevorzugen.

- Geeignete vorhandene Muster nutzen; Wiederverwendung nicht erzwingen, wenn eine kleine lokale Lösung dadurch deutlich komplizierter wird.
- Keine hypothetischen Erweiterungspunkte, parallelen Lösungen, unnötigen Konfigurationsschichten oder beiläufigen Refactorings außerhalb des Auftrags einführen.
- Abstraktionen nur einführen, wenn sie konkrete wiederkehrende Komplexität entfernen oder wichtige Systemgrenzen klarer und sicherer machen. Komplexität nicht lediglich verteilen.
- Fachliche Entscheidungen in der kanonischen Schicht halten; vorgesehene Grenzen zwischen Fachlogik und Darstellung respektieren. Synchronisierte Doppelzustände und versteckte Seiteneffekte vermeiden.
- Öffentliche Contracts erhalten, sofern ihre Änderung nicht zum Auftrag gehört.
- Zusammengehörige Zustandsänderungen möglichst atomar ausführen; andernfalls sichere Reihenfolge und Wiederaufnahme oder Kompensation vorsehen.
- Keine Debug-Reste, temporären Hilfsskripte oder unnötigen Logs hinterlassen. Veralteten Code nur innerhalb des Scopes sicher entfernen.

Neue Produktionsabhängigkeiten nur bei konkretem Nutzen gegenüber vorhandenem Stack oder einer überschaubaren lokalen Lösung ergänzen. Wartung, Bundle, Laufzeit, Lizenz und Sicherheitsfläche berücksichtigen. Keine Framework-Wechsel ohne ausdrückliche Notwendigkeit.

Für Kryptografie, Authentifizierung, Passwort-Handling, Signaturprüfung und komplexe Protokollparser etablierte, gepflegte Lösungen statt eigener Spezialimplementierungen verwenden, sofern verfügbar.

## Daten, Typen und Fehler

Externe, importierte, persistierte und nutzergesteuerte Daten an Systemgrenzen als nicht vertrauenswürdig behandeln. Mit vorhandenen Mechanismen validieren und erst danach in vertrauenswürdige interne Typen überführen.

Unklare Invarianten nicht durch ungesicherte Typannahmen, übermäßige Optionalität oder stille Fallbacks verdecken. Fachliche Defaults nur verwenden, wenn definiert oder sicher ableitbar. Relevante Fehler nicht verschlucken; Ursache und fachlichen Kontext diagnostizierbar halten. Keine spekulative Security-Infrastruktur außerhalb des Auftrags einführen.

## UI, Designsystem und Accessibility

Bei Oberflächen vorhandene Tokens, Primitives und Komponenten nutzen. Konkrete Designwerte aus der projektspezifisch festgelegten kanonischen Token- oder Designquelle beziehen. Bei angeforderten visuellen Änderungen die verbindliche Referenz oder das vereinbarte Ziel umsetzen.

Semantische Tokens bevorzugen und Werte nicht willkürlich duplizieren. Wiederkehrende Muster bei tatsächlicher Wiederholung in die gemeinsame UI-Schicht überführen; für kleine Projekte kein unnötig komplexes Designsystem bauen.

Semantisches HTML und zugängliche Patterns verwenden. Tastaturbedienung und sichtbaren Fokus erhalten, Icon-only-Controls zugänglich benennen und Interaktionen nicht ausschließlich über Farbe, Hover oder Mausbedienung vermitteln.

## Dokumentation und Kommentare

Dauerhaft relevantes Wissen dokumentieren, insbesondere Setup, Betrieb, Architektur, Contracts, wichtige Entscheidungen und Grenzen. Jede Information hat eine eindeutige kanonische Quelle. Betroffene Dokumentation im selben Change aktualisieren, wenn Aussagen falsch werden.

Keine offensichtlichen Implementierungsdetails, Sitzungsverläufe, erledigten Aufgaben, Doppelpflege oder zeremoniellen Dokumente erzeugen. Historische Pläne kennzeichnen; unbeteiligte Dokumentation nicht aus Vollständigkeitsgefühl ändern.

Kommentare erklären Zweck, Invarianten oder nicht offensichtliche Gründe statt den Code nachzuerzählen. Veraltete Kommentare korrigieren oder entfernen. TODOs konkret, begründet und auffindbar halten.

## Tests und Verifikation

Tests sichern Verhalten ab, nicht künstliche Coverage. Bei relevantem Risiko das erwartete Verhalten vor der Implementierung festlegen. Test-first besonders bei geschäftskritischer, sicherheits- oder datenrelevanter Logik, öffentlichen Contracts und reproduzierbaren Bugfixes bevorzugen.

Assertions aus Verhalten, Contract oder reproduziertem Fehler ableiten. Keine Tests ergänzen, die nur Typsystem, triviale Getter, Framework-Verhalten oder Implementierungsdetails wiederholen.

Prüfungen nach Risiko auswählen: fokussierte Tests, Typprüfung, statische Analyse, Lint, relevante breitere Testsuite oder Build. Projektspezifisch verpflichtende Gates einhalten. Teure vollständige Gates ausführen, wenn sie zur Diagnose, Risikoabsicherung oder zum Abschluss erforderlich sind. Erfolgreiche Prüfungen nur bei relevanten Änderungen, neuen Fehlern oder offenen Fragen wiederholen.

E2E-Tests für kritische Nutzerabläufe einsetzen, deren Zusammenspiel fokussierte Tests nicht ausreichend absichern. Ausgeführte E2E-Tests mit reproduzierbarem Aufruf und geeignetem Ergebnisnachweis belegen.

Für Dokumentation, risikoarme Konfiguration und explorative Prototypen die leichteste aussagekräftige Verifikation wählen. Für kleine Änderungen kein unverhältnismäßiges Testsystem einführen.

Sichtbare UI-Änderungen visuell oder interaktiv prüfen: zunächst den primär betroffenen Zustand und einen repräsentativen Breakpoint. Weitere Zustände, Screenshots oder E2E-Läufe nur bei konkretem Risiko, Unsicherheit oder Auftrag ergänzen. Nicht mögliche Prüfungen offenlegen.

Bei Fehlschlägen zuerst die relevante Fehlerstelle untersuchen. Eigene Fehler, bestehende Fehler und Umgebungsprobleme unterscheiden. Nur tatsächlich ausgeführte Prüfungen und beobachtete Ergebnisse berichten.

## Self-Review, Git und Abschluss

Vor Abschluss den vollständigen auftragsbezogenen Änderungsumfang inhaltlich prüfen, einschließlich ungestagter, gestagter und neuer Dateien. Bereits vorhandene fremde Änderungen davon unterscheiden und erhalten.

Intern auf unnötige Komplexität, Scope-Ausweitung, Architekturverletzungen, Debug-Reste, fehlende Validierung, Fehlerbehandlung, Tests und Dokumentationsdrift prüfen. Eine wesentlich einfachere, gleichermaßen korrekte und wartbare Lösung innerhalb des Scopes bevorzugen. Selbst verursachte Probleme beheben statt nur erwähnen.

- Commits nur auf ausdrücklichen Auftrag oder wenn der Projektworkflow sie verlangt erstellen. Nur auftragsbezogene Änderungen stagen; unzusammenhängende Änderungen trennen. Fokussierte Conventional Commits verwenden, sofern das Projekt nichts anderes vorgibt.
- Keine repositoryweiten Formatierungen oder Autofixes mit unnötigen Fremdänderungen ausführen.

Vollständig abgeschlossen ist eine Implementierung, wenn das angeforderte Verhalten umgesetzt, relevante Prüfungen erfolgreich ausgeführt, Änderungen geprüft, betroffene dauerhafte Dokumentation aktualisiert und keine bekannten selbst verursachten Fehler offen sind. Bei Prüfungsblockern ausdrücklich zwischen implementiert und vollständig verifiziert unterscheiden.

Im Abschlussbericht knapp Änderungen, ausgeführte und nicht mögliche Prüfungen sowie relevante Annahmen, Risiken und Restpunkte nennen.

## Kontinuierliche Verbesserung

Wiederholte Fehler möglichst durch Code, Typen oder Architektur verhindern, danach durch deterministische Tests oder Lint, anschließend durch Projektdokumentation. Erst zuletzt eine kurze Regel in die passende `AGENTS.md` aufnehmen. Keine dauerhaften Regeln für einmalige Fehler ansammeln; veraltete Regeln entfernen oder aktualisieren.
