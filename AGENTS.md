# DERO – Globale AGENTS.md
 
Die Regeln sind Entscheidungsprinzipien, keine Checkliste. Keine Arbeit für sichtbare Regelbefolgung erzeugen, klare Aufgaben nicht aufblähen oder blockieren. Projektspezifische `AGENTS.md` und ausdrückliche Nutzeranweisungen gehen vor.
 
Die erste sichtbare Antwort jeder neuen interaktiven Session beginnt mit `[DERO Config | 2.2 | Aktiv]`, sofern kein maschinenlesbares Ausgabeformat dagegensteht. Nur einmal pro Session.
 
## Grenzen
 
- Fremde oder unbeteiligte Änderungen nicht verwerfen, überschreiben oder ungefragt einbeziehen.
- Push, Deployment, Versand, destruktive Aktionen und irreversible Migrationen nur mit ausdrücklicher Freigabe. Freigaben gelten innerhalb der Session und ihres benannten Umfangs.
- Secrets nie committen, loggen oder in Ausgaben wiederholen.

## Arbeitsweise
 
Bei Review, Analyse, Diagnose oder Planung untersuchen und berichten, ohne das Repository zu verändern. Bei Implementierung den Scope vollständig umsetzen und angemessen verifizieren.
 
Vor neuen Lösungen vorhandene Komponenten, Utilities und Muster suchen und die kanonische Quelle bestimmen. Gewöhnliche Details selbst entscheiden; nur nachfragen, wenn Ergebnis, Korrektheit oder Scope wesentlich davon abhängen. Neue Abhängigkeiten sparsam und begründet einsetzen.
 
## UI
 
Vorhandene Tokens, Primitives und Komponenten nutzen; Designwerte aus der kanonischen Designquelle beziehen statt duplizieren. Semantisches HTML, Tastaturbedienung, sichtbarer Fokus und ausreichender Kontrast sind Standard. Für kleine Projekte kein unnötiges Designsystem bauen.
 
## Dokumentation
 
Dauerhaft relevantes Wissen dokumentieren (Setup, Betrieb, Architektur, Contracts, Entscheidungen), jeweils mit einer kanonischen Quelle. Betroffene Doku im selben Change aktualisieren. Keine Sitzungsverläufe, Doppelpflege oder zeremoniellen Dokumente. Kommentare erklären Zweck und nicht offensichtliche Gründe, nicht den Code.
 
## Tests
 
Tests sichern Verhalten ab, nicht Coverage. Test-first bei geschäftskritischer, sicherheits- oder datenrelevanter Logik, öffentlichen Contracts und reproduzierbaren Bugs. Keine Tests für Typsystem, triviale Getter oder Framework-Verhalten. Projektspezifische Gates einhalten; für Doku, Konfiguration und Prototypen die leichteste aussagekräftige Verifikation wählen.
 
## Abschluss
 
Vor Abschluss den eigenen Änderungsumfang prüfen und von fremden Änderungen trennen. Die einfachste korrekte Lösung bevorzugen. Selbst verursachte Probleme beheben, gefundene fremde Probleme melden.
 
Kurz berichten: was geändert wurde, wie es verifiziert wurde und was offen ist.
 
Commits nur auf Auftrag oder wenn der Projektworkflow sie verlangt; nur auftragsbezogene Änderungen, Conventional Commits. Keine repositoryweiten Autofixes.
 
## Verbesserung
 
Wiederholte Fehler bevorzugt durch Code, Typen oder Tests verhindern, erst zuletzt durch eine kurze Regel in der passenden `AGENTS.md`. Änderungen an dieser globalen Datei nur vorschlagen. Veraltete Regeln entfernen.