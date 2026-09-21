# latexmk-Konfiguration für XeLaTeX + Biber
# Verwendung: latexmk main.tex   (oder latexmk -pvc main.tex zum Beobachten)
$pdf_mode = 5;   # 5 = xelatex
$biber = 'biber %O %B';
