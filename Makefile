.DEFAULT_GOAL := cv.pdf

TEXINPUTS := .:$$HOME/src/tex:
BIBINPUTS := .:$$HOME/src/bib:
BSTINPUTS := .:$$HOME/src/tex:$$HOME/src/bib:
.EXPORT_ALL_VARIABLES: BIBINPUTS

LATEX = latexmk -xelatex
PDFS = resume.pdf research.pdf teaching.pdf service.pdf
BIBS = $(wildcard *.bib)
DROPPINGS = *-blx.bib *.bbl *.run.xml *.xdv *.fls _region_.tex

.PHONY: all
all: $(PDFS)
	$(MAKE) clean

.PHONY: view
view: $(PDFS)
	open $(PDFS)

.PHONY: clean
clean:
	$(LATEX) -c
	$(RM) $(DROPPINGS)

.PHONY: distclean
distclean:
	$(LATEX) -C
	$(RM) $(DROPPINGS)
	$(RM) $(PDFS) $(COVERSHEETS) cv.pdf

research.pdf: research.tex style.tex $(BIBS)
cv.pdf: cv.tex $(PDFS)
%.pdf: %.tex style.tex
	$(LATEX) $<
	$(RM) $(DROPPINGS)
