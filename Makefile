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
DROPPINGS = *-blx.bib *.bbl *.run.xml *.xdv *.fls _region_.tex

RESULTS = NAME-document-1.pdf NAME-document-2.pdf

.PHONY: all
all: $(RESULTS)

$(RESULTS): $(COVERSHEETS) $(PDFS)

.PHONY: view
view: $(RESULTS)
	open $^

.PHONY: clean
clean:
	$(LATEX) -c
	$(RM) $(DROPPINGS)

.PHONY: distclean
distclean:
	$(LATEX) -C
	$(RM) $(DROPPINGS) $(PDFS) $(COVERSHEETS) statement.tex

statement.tex: statement.in.tex
	$(RM) statement.tex
	sed "s/@WORDCOUNT@/$$(($$(detex $< | tail +43 | wc -w)-20))/" $< > statement.tex

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

%.pdf: %.tex style.tex $(BIBS)
	$(LATEX) $<
