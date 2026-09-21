# Kontext: Probearbeit "Bier selber brauen"

Diese Datei dokumentiert die Entscheidungen hinter dem LaTeX-Grundgerüst in
diesem Ordner, damit ein späterer Chat (z.B. auf claude.ai) den Kontext
schnell wiederfindet, ohne das Handbuch erneut durchsuchen zu müssen.

## Ausgangslage

- Autoren: zwei Schüler der Kantonsschule Wohlen, zu zweit.
- Zweck: **Probearbeit** vor der eigentlichen Maturaarbeit, im Rahmen des
  Projektunterrichts (PU).
- Thema: Bier selber brauen -- von der Zutatenbestellung über den
  Brauprozess bis zur Abfüllung in Flaschen.
- Arbeitstyp: **naturwissenschaftlich** (Kap. 7.1.2 im Handbuch), nicht
  geisteswissenschaftlich oder rein gestalterisch.
- Formatvorgaben-Quelle: `kswo-info/Handbuch_PU_KSWO_2025.pdf`
  (Kapitel 7 "Schriftliche Arbeit", v.a. 7.1 Aufbau, 7.3 Formale
  Gestaltung/Tab. 14, 7.5 Bibliografieren und Zitieren).

## Getroffene Entscheidungen

| Frage | Entscheidung | Warum |
|---|---|---|
| Arbeitsumgebung | Lokal aufbauen (XeLaTeX, Biber), Overleaf-kompatibel halten | Nutzer will evtl. später auf Overleaf wechseln; keine absoluten Pfade, nur Standardpakete verwendet |
| Schriftart | Carlito (Calibri-metrisch-kompatibel), Alternative Liberation Sans (Arial) auskommentiert | Handbuch verlangt "gut lesbare Schrift, z.B. Calibri oder Arial"; beide Fonts sind lokal bereits installiert |
| Dokumentklasse | `scrreprt` (KOMA-Script) | Sauberes Kapitel-Handling, gute Header/Footer-Integration via `scrlayer-scrpage` (kein fancyhdr-Konflikt mit KOMA) |
| Zitierstil | **Kurzbelege in Klammern**, z.B. `(Kruse 2015, S. 23)`, kein Fussnotenapparat | Explizite Nutzerentscheidung (Handbuch erlaubt beides, Kap. 7.5.2) |
| Bibliografie-Format | Eigene `\DeclareBibliographyDriver`-Treiber statt Standard-`authoryear`-Stil | Standardstile setzen "(Jahr)" direkt nach dem Namen; Handbuch will "Nachname, Vorname: Titel. ... Ort Jahr." -- musste von Hand nachgebaut werden |
| Quellenverzeichnis-Aufteilung | 4 `\printbibliography[keyword=...]`-Blöcke: Literatur/Internetquellen/Abbildungen/Tabellen | Handbuch S. 81 verlangt genau diese Aufteilung |

## Was im LaTeX-Code technisch gelöst wurde

- **Seitenformatierung** exakt nach Tab. 14 (S. 89): A4, Ränder
  oben 3 cm/unten 2.8 cm/links 3 cm/rechts 2 cm, Kopfzeile 1.2 cm,
  Fusszeile 1.8 cm, 11 pt/9 pt, Zeilenabstand 1.5/1.0, Blocksatz.
- **Paginierung**: Titelblatt, Inhaltsverzeichnis und Vorwort zählen mit,
  zeigen aber keine Seitenzahl (`\thispagestyle{empty}` nötig, weil
  `\chapter`/`\chapter*` sonst automatisch die "plain"-Kapitelseite mit
  sichtbarer Zahl erzwingt -- das war ein konkreter Bug, der gefixt wurde).
- **Fortlaufende Abbildungs-/Tabellennummerierung** übers ganze Dokument
  (nicht pro Kapitel) via `\@removefromreset` (kein `chngcntr`-Paket
  verfügbar, daher LaTeX-Kernel-Befehl direkt verwendet).
- **Kopfzeile** zeigt automatisch das aktuelle Kapitel
  (`scrlayer-scrpage`, `automark`-Option).
- **Eigene Bibliografie-Treiber** für `@book`, `@online`, `@incollection`,
  `@article` in `preamble.tex`, alle gegen die exakten Beispiele aus dem
  Handbuch (S. 94-96) getestet. Bekannte Stolpersteine dabei:
  - `\printfield{edition}` und `\printfield{volume}` hängen selbst schon
    "Auflage"/"Bd." an -- nicht doppelt ergänzen.
  - `author` ist ein Namensfeld: mit `\ifnameundef` prüfen, nicht mit
    `\iffieldundef` (sonst falsch-negativ).
  - `\newunit*` gibt es nicht (nur `\setunit*`) -- ein Sternchen nach
    `\newunit` wird sonst wörtlich als "*" ausgegeben.
  - Text, der auf ")" endet (z.B. `(Hrsg.)`), unterdrückt ein direkt
    danach eingefügtes `\addcolon` (biblatex-Doppelpunkt-Vermeidung) --
    Doppelpunkt stattdessen literal in den `\printtext`-Block schreiben.
- **Eigener Kurzbefehl `\vgl[Seite]{key}`** für Paraphrasen mit
  vorangestelltem "Vgl." (Handbuch S. 97/99).
- **Noch nicht abgedeckte Quellentypen**: Zeitungsartikel, Interviews,
  AV-Medien (Handbuch S. 95-97) -- bei Bedarf nach demselben Muster wie
  `@article`/`@incollection` in `preamble.tex` ergänzen.

## Tabelle direkt aus CSV-Daten (pgfplotstable)

`kapitel/04-resultate.tex` enthält eine Beispieltabelle, die beim
Kompilieren live aus `daten/gaerung.csv` erzeugt wird (`pgfplotstable`,
`col sep=semicolon` in `preamble.tex`) -- die Messwerte stehen nur in
der CSV, nicht im `.tex`-Quellcode. Neue Messreihe: einfach die CSV
aktualisieren, die Tabelle passt sich automatisch an.

**Bekannte Stolpersteine dabei (inzwischen behoben):**
- Die erste Spaltenüberschrift in `daten/gaerung.csv` war fehlerhaft
  (enthielt versehentlich eingefügten Titeltext mitten im Wort
  "Messzeitpunkt": `MesszeitpunTabelle 2.1: ... Kanti Pale Alekt`).
  **Auf Nutzerwunsch direkt in der CSV-Datei korrigiert** (Kopfzeile
  jetzt schlicht `Messzeitpunkt;...`); `04-resultate.tex` spricht die
  Spalte entsprechend wieder per Name statt per Index an.
- Die globale `\footnotesize`-Umdefinition (für Fussnoten gemäss Tab. 14)
  hatte `\singlespacing` eingebacken; das kollidierte mit pgfplotstables
  interner Spaltenbreitenmessung und erzeugte "TeX capacity exceeded"
  (Endlosschleife). Fix: `\footnotesize` setzt nur noch die Schriftgrösse,
  `\singlespacing` wird gezielt über `\@makefntext` nur auf den
  eigentlichen Fussnotentext angewendet.
- KOMA-Script hängt in seinem eigenen Caption-Default zusätzlich einen
  Punkt an die Nummer ("Tab. 1."), was zusammen mit `labelsep=colon` zu
  "Tab. 1.:" statt "Tab. 1:" führte. Fix: `labelformat=simple` erzwungen.
- Checkliste S. 103 verlangt, dass Tabellen "umrandet" sind -- die
  Tabelle nutzt daher volle `|...|`-Rahmen statt des booktabs-Stils
  (kein vertikaler Rahmen), der sonst im restlichen Dokument für Beispiel-
  Tabellen in Kommentaren vorgeschlagen wurde.

## Diagramm direkt aus CSV-Daten (pgfplots)

`kapitel/04-resultate.tex` enthält zusätzlich zur Tabelle ein Liniendia-
gramm (Restzucker vs. Alkoholgehalt über die Gärung), ebenfalls live aus
`daten/gaerung.csv` erzeugt (`pgfplots`, `compat=1.18` in
`preamble.tex`). Technik: `x expr=\coordindex` statt Datum-Parsing auf
der x-Achse (robuster, keine zusätzliche pgfplots-Datumsbibliothek
nötig).

## Datumsformat dd.mm.yyyy (Tabelle + Diagramm)

Auf Nutzerwunsch zeigen Tabelle und Diagramm die Messzeitpunkte im
Format `dd.mm.yyyy hh:mm` statt im ISO-Rohformat der CSV
(`yyyy-mm-dd hh:mm`). Umsetzung in `preamble.tex`: ein wiederverwendbarer
pgfplotstable-Spaltenstil `ddmmyyyy from iso` (feste Zeichenpositionen
per `xstring`, `\StrLeft`/`\StrMid`), angewendet in
`kapitel/04-resultate.tex`.

**Wichtiger, mühsam erarbeiteter Stolperstein:** `preproc cell content`
(der pgfplotstable-Hook, der diesen Stil intern nutzt) wird nur an der
Stelle ausgeführt, wo eine Spalte tatsächlich **getypesettet/gelesen**
wird -- er "klebt" NICHT an der Tabellenstruktur, wenn man erst
`\pgfplotstableread{...}\meinetabelle` aufruft und später separat
`\pgfplotstabletypeset{\meinetabelle}` (ohne den Stil dort erneut
anzugeben). Ein erster Versuch, CSV einmal einzulesen und für Tabelle
UND Diagramm wiederzuverwenden, ist daher **stillschweigend** (keine
Fehlermeldung!) gescheitert. Robuste Lösung, die tatsächlich
funktioniert:
- **Tabelle:** `ddmmyyyy from iso` direkt am `\pgfplotstabletypeset[...]`-
  Aufruf angeben, der `daten/gaerung.csv` einliest (nicht über einen
  Zwischenschritt).
- **Diagramm:** `xticklabels from table` wendet Spaltenstile ebenfalls
  nicht an. Stattdessen werden die Messzeitpunkte in einer Schleife
  (`\pgfplotstablegetelem` + `\foreach`) einzeln ausgelesen, mit
  `xstring` umformatiert und zu einer Liste zusammengebaut
  (`\gaerungticklabels`). Diese Liste muss mit
  `xticklabels/.expand once=\gaerungticklabels` (nicht
  `xticklabels={\gaerungticklabels}`!) eingebunden werden, sonst
  interpretiert pgfplots die ganze Liste als ein einziges Tick-Label
  (Kommas werden vor der Makroexpansion gesplittet, nicht danach).
- Ausserdem: Hilfsmakronamen in solchen Codeblöcken **kein** `@` geben,
  ausser der Block liegt explizit in `\makeatletter…\makeatother`.

## Echte Quelle bereits eingetragen

`quellen.bib` enthält bereits einen echten Eintrag (Zitierschlüssel
`bruecklmeier2022`):

> Brücklmeier, Jan: Bier brauen. Grundlagen, Rohstoffe, Brauprozess.
> 2. Auflage. Stuttgart 2022.

(Der zweite Eintrag, `wischenbart2013`, ist weiterhin nur ein generischer
Platzhalter zur Demonstration des Internetquellen-Formats und sollte durch
eine echte Quelle ersetzt werden.)

## Einleitung: Beispieltext

`kapitel/02-einleitung.tex` enthält bereits zwei kurze Beispielabsätze
(Motivation/Kontext, Fragestellung zur Gärtemperatur) mit zwei Zitaten auf
`bruecklmeier2022` (`\parencite{...}` und `\vgl[S.~45]{...}`) als
Ausgangspunkt -- als Platzhalter markiert, vor Abgabe durch eigene
Formulierungen zu ersetzen.

## Verwendete KI-Tools

Auf Wunsch des Nutzers gibt es jetzt einen eigenen Abschnitt
`ki-tools.tex` (eingebunden in `main.tex` direkt nach dem
Quellenverzeichnis, vor dem Anhang), der offenlegt, dass das
LaTeX-Dokumentgerüst mit Unterstützung von Claude entstanden ist --
gemäss Handbuch Kap. 7.4.2 (S. 92): "Die Verwendung von KI-Tools muss in
einem zusätzlichen Abschnitt am Ende des normalen Quellenverzeichnisses
nachgewiesen werden" (Name des Tools, Datum, verwendete Prompts).
**Wichtig:** Das Handbuch verlangt zusätzlich ein separates
Reflexionsformular zur Abgabe -- siehe `reflexionsformular.tex` (eigenes,
mit `xelatex reflexionsformular.tex` kompilierbares Dokument, **nicht**
in `main.tex` eingebunden, da es kein Teil des Aufbaus einer
schriftlichen Arbeit gemäss Kap. 7.1.2 ist, sondern separat "zusätzlich
zur Selbständigkeitserklärung eingereicht" wird). Jede/r Autor/in füllt
ein eigenes Exemplar aus.

**Achtung:** Das Handbuch beschreibt nur Zweck und Pflichtinhalt dieses
Formulars (Name des Tools, Datum, Prompts, Bestätigung der Richtlinien,
Raum für Reflexion), liefert aber -- anders als bei der
Selbständigkeitserklärung -- kein konkretes Layout im Handbuch selbst.
`reflexionsformular.tex` ist daher eine selbst erstellte, aus den
Handbuch-Vorgaben abgeleitete Vorlage. Vor der Abgabe bei der
Betreuungsperson bzw. im Sharepoint (Office 365, Info-Portal/Gymnasium/
Maturaarbeit) prüfen, ob eine offizielle Formularvorlage existiert.

## Offene Punkte / nächste Schritte

- Kapitel-Platzhalter in `kapitel/*.tex` enthalten grösstenteils noch
  keinen ausformulierten Text (Ausnahme: Einleitung, siehe oben), nur
  Kommentare, was gemäss Handbuch jeweils reingehört.
- Titelblatt (`titelblatt.tex`) enthält Platzhaltertext (Namen, Klasse,
  Referent/in, Titel) -- noch anzupassen.
- Bei Bedarf weitere Bibliografie-Treiber ergänzen (siehe oben).
- `reflexionsformular.tex` ausfüllen (Tool-Tabelle, Reflexionsfragen) und
  einreichen; vor Abgabe offizielle Formularvorlage prüfen (siehe oben).
- Vor der Abgabe: Checkliste Handbuch S. 103 (Kap. 7.6) durchgehen.
