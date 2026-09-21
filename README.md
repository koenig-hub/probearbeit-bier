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
