.DEFAULT_GOAL := cv.pdf

TEXINPUTS := .:$$HOME/src/tex:
BIBINPUTS := .:$$HOME/src/bib:
BSTINPUTS := .:$$HOME/src/tex:$$HOME/src/bib:
.EXPORT_ALL_VARIABLES: BIBINPUTS

LATEX = latexmk -xelatex
PDFTK = docker run -ti --rm -v "$$(pwd -P)":/cwd -w /cwd mor1/pdftk

PDFS = cv.pdf annex-a.pdf annex-b.pdf annex-c.pdf statement.pdf
BIBS = $(wildcard $$HOME/me/publications/rmm-*.bib)
COVERSHEETS = cs-cv.pdf cs-a.pdf cs-b.pdf cs-c.pdf \
              cs-statement.pdf cs-contextual-factors.pdf
RESULTS = NAME-document-1.pdf NAME-document-2.pdf

.PHONY: all
all: $(RESULTS)

$(RESULTS): $(COVERSHEETS) $(PDFS)

.PHONY: view
view: $(RESULTS)
	open $(RESULTS)

.PHONY: clean
clean:
	$(LATEX) -c
	$(RM) *-blx.bib *.bbl *.run.xml *.xdv *.fls _region_.tex

.PHONY: distclean
distclean:
	$(LATEX) -C
	$(RM) *-blx.bib *.bbl *.run.xml *.xdv *.fls _region_.tex
	$(RM) $(PDFS) $(COVERSHEETS)

%.pdf: %.tex style.tex $(BIBS)
	$(LATEX) $<

.PHONY: count-statement
count-statement: statement.tex
	detex $< | wc -w

CS1 = document_1_application_coversheet_2020_draft_clean.pdf
CS2 = document_2_personal_statement_coversheet_2020_clean.pdf
coversheets: $(COVERSHEETS)
$(COVERSHEETS): $(CS1) $(CS2)
	$(PDFTK) $(CS1) cat 1   output cs-cv.pdf
	$(PDFTK) $(CS1) cat 2   output cs-a.pdf
	$(PDFTK) $(CS1) cat 3   output cs-b.pdf
	$(PDFTK) $(CS1) cat 4   output cs-c.pdf
	$(PDFTK) $(CS2) cat 1-2 output cs-statement.pdf
	$(PDFTK) $(CS2) cat 3   output cs-contextual-factors.pdf
