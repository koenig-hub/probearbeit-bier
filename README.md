# Probearbeit Bier

LaTeX-Projekt für die Matura-Probearbeit (XeLaTeX + Biber).

## Voraussetzungen

- `latexmk`
- `xelatex`
- `biber`

## Kompilieren

Hauptdokument (`main.pdf`):

```sh
latexmk main.tex
```

Reflexionsformular (`reflexionsformular.pdf`):

```sh
latexmk reflexionsformular.tex
```

Die Build-Konfiguration (XeLaTeX-Modus, Biber als Bibliographie-Tool) ist in `latexmkrc` hinterlegt und wird automatisch verwendet.

Zum fortlaufenden Beobachten und automatischen Neukompilieren bei Änderungen:

```sh
latexmk -pvc main.tex
```

## Aufräumen

Build-Artefakte (`.aux`, `.log`, `.bbl`, etc.) entfernen:

```sh
latexmk -c
```

Alle generierten Dateien inklusive PDF entfernen:

```sh
latexmk -C
```

## LaTeX-Templates

Die Arbeit ist in mehrere `.tex`-Dateien aufgeteilt. Aufbau und Formatierung richten sich nach dem *Handbuch Projekte KSWO 2025* (Kap. 7); die jeweiligen Handbuchstellen sind in den Dateien selbst kommentiert.

### Hauptdokument und Konfiguration

| Datei | Zweck |
|---|---|
| `main.tex` | Hauptdokument. Bindet alle anderen Dateien in der vorgeschriebenen Reihenfolge ein (Titelblatt, Inhaltsverzeichnis, Kapitel, Quellenverzeichnis, KI-Tools, Anhang, Selbständigkeitserklärung) und steuert die Paginierung (Seitenzahlen erst ab dem Abstract sichtbar). |
| `preamble.tex` | Präambel mit sämtlichen Formatvorgaben: Seitenränder, Schrift (Carlito als Calibri-Ersatz), Sprache und Schweizer Anführungszeichen, Zeilenabstände, Kopf-/Fusszeile, Beschriftung von Abbildungen/Tabellen, Pakete für Tabellen und Diagramme (`pgfplots`, `pgfplotstable`, `siunitx`) sowie `biblatex` mit Kurzbelegen in Klammern und eigenen Vorlagen für das Quellenverzeichnis. Hier werden nur Layout-Änderungen vorgenommen, kein Inhalt. |
| `latexmkrc` | Build-Konfiguration für `latexmk` (XeLaTeX + Biber). |
| `quellen.bib` | Literaturdatenbank. Jeder Eintrag braucht ein `keywords`-Feld (`literatur`, `internet`, `abbildung` oder `tabelle`), damit er im richtigen Teil des Quellenverzeichnisses erscheint. |

### Titelei und Schlussteile

| Datei | Zweck |
|---|---|
| `titelblatt.tex` | Titelblatt mit den obligatorischen Angaben: Titel und Untertitel, Typ der Arbeit, Autoren, Schule/Klasse, Abgabedatum und betreuende Lehrperson. Das Datum ist aktuell `\today` und muss vor der Abgabe durch das effektive Abgabedatum ersetzt werden. |
| `ki-tools.tex` | Pflichtabschnitt «Verwendete KI-Tools» am Ende des Quellenverzeichnisses: Name des Tools, Datum der Verwendung und eingegebene Prompts. Bei weiterer KI-Nutzung ergänzen. |
| `anhang.tex` | Optionaler Anhang für Material, das im Haupttext erwähnt wird (z.B. Brauprotokoll, Rohdaten, Fotos, Fragebogen). |
| `selbstaendigkeitserklaerung.tex` | Zwingende Selbständigkeitserklärung (Wortlaut aus dem Handbuch) mit Unterschriftsfeldern für beide Autoren. Wird nach dem Ausdrucken von Hand unterschrieben. |
| `reflexionsformular.tex` | **Eigenständiges Dokument** (nicht Teil von `main.tex`). Reflexionsformular zum KI-Einsatz, das bei Verwendung von KI-Tools zusätzlich zur Selbständigkeitserklärung eingereicht werden muss. Jeder Autor füllt ein eigenes Exemplar aus. Da das Handbuch keine Layout-Vorlage liefert, ist es eine eigene Vorlage – vor der Abgabe prüfen, ob eine offizielle Vorlage existiert. |

### Kapitel (`kapitel/`)

Die Kapitel folgen dem Aufbau einer naturwissenschaftlichen Arbeit (Handbuch Kap. 7.1.2). Jede Datei enthält im Kopfkommentar Hinweise, was inhaltlich hineingehört.

| Datei | Zweck |
|---|---|
| `00-vorwort.tex` | Optionales Vorwort (z.B. wie man zum Thema gekommen ist, Dank). Ohne Seitenzahl. Falls nicht gebraucht: leeren oder in `main.tex` auskommentieren. |
| `01-abstract.tex` | Abstract: max. eine A4-Seite, allgemeinverständliche Zusammenfassung von Fragestellung, Methode, Ergebnissen und Diskussion, ohne Quellenangaben. |
| `02-einleitung.tex` | Einleitung (Kapitel 1): Untersuchungsgegenstand, Problemstellung, Theorie, Ziel der Arbeit und am Schluss die Hypothesen. |
| `03-material-methoden.tex` | Material und Methoden: Zutaten und Bezugsquellen, Braugeräte, Rezept und Brauprotokoll, Messmethoden – so beschrieben, dass der Versuch wiederholbar ist. |
| `04-resultate.tex` | Resultate: Messwerte und Gärverlauf, ohne Interpretation. Tabelle und Diagramm werden beim Kompilieren direkt aus `daten/gaerung.csv` erzeugt. |
| `05-diskussion.tex` | Diskussion: Vergleich mit Literatur und Hypothesen, offene Fragen und Fazit (sachlicher und persönlicher Teil). Enthält Beispiele für Kurzbelege (`\parencite`, `\vgl`). |

### Weitere Verzeichnisse

| Pfad | Zweck |
|---|---|
| `daten/gaerung.csv` | Messdaten zum Gärverlauf (Semikolon-getrennt), aus denen Tabelle und Diagramm in den Resultaten generiert werden. Neue Messwerte hier eintragen, nicht im LaTeX-Code. |
| `bilder/` | Ablage für Fotos und Abbildungen, die mit `\includegraphics` eingebunden werden. |
| `docs/` | Grafiken für dieses README (z.B. Workflow-Diagramm). |

## Workflow: Templating & Overleaf

Das LaTeX-Templating (Layout, Struktur, Formatierung) erfolgt lokal auf einem Linux-Desktop. Der LaTeX-Sourcecode wird im Git-Repo [probearbeit-bier](https://github.com/koenig-hub/probearbeit-bier) gespeichert und versioniert.

Der Inhalt (Text) wird dagegen im Overleaf-Projekt [Probearbeit Bier](https://www.overleaf.com/project/6ab12604bc4b0cb3cf2402a7) bearbeitet, da Overleaf ein kollaboratives Online-Editieren erlaubt. Overleaf synchronisiert sich dabei mit demselben Git-Repo.

![Zusammenspiel von lokalem Templating, Git-Repo und Overleaf](docs/workflow.svg)

Daraus ergibt sich folgender Ablauf:

1. **Vor dem Bearbeiten in Overleaf:** alle Änderungen vom Git-Repo pullen, damit Overleaf mit dem aktuellen Stand startet.
2. **Bearbeiten:** Text/Inhalt wird in Overleaf angepasst.
3. **Nach dem Bearbeiten in Overleaf:** die Änderungen wieder ins Git-Repo pushen.
4. **Templating lokal:** Layout- und Strukturänderungen (Vorlage, Formatierung) werden lokal am gepullten Sourcecode vorgenommen und wie gewohnt kompiliert (siehe [Kompilieren](#kompilieren)) und anschliessend ebenfalls ins Git-Repo gepusht.

Wichtig: Da sowohl lokal als auch in Overleaf am selben Git-Repo gearbeitet wird, muss vor jeder Bearbeitung (egal ob lokal oder in Overleaf) zuerst der aktuelle Stand gepullt werden, um Konflikte zu vermeiden.
