TYPST ?= typst
PYTHON ?= python3
FLAGS = --font-path fonts --ignore-system-fonts
SOURCES = main.typ colm.typ colm.csl references.bib $(wildcard fonts/*.otf fonts/*.ttf)

.PHONY: all submission preprint final watch check-layout check-references
all: submission preprint final
submission: build/submission.pdf
preprint: build/preprint.pdf
final: build/final.pdf

build/%.pdf: $(SOURCES)
	mkdir -p build
	$(TYPST) compile $(FLAGS) --input mode=$* main.typ $@

build/reference.pdf: validation/reference.typ colm.typ colm.csl $(wildcard fonts/*.otf fonts/*.ttf)
	mkdir -p build
	$(TYPST) compile --root . $(FLAGS) validation/reference.typ $@

check-layout: build/reference.pdf
	$(PYTHON) validation/check-spacing.py $<

build/bibliography.pdf: validation/bibliography.typ validation/bibliography.bib colm.typ colm.csl $(wildcard fonts/*.otf fonts/*.ttf)
	mkdir -p build
	$(TYPST) compile --root . $(FLAGS) validation/bibliography.typ $@

check-references: build/bibliography.pdf
	$(PYTHON) validation/check-bibliography.py $<

watch:
	mkdir -p build
	$(TYPST) watch $(FLAGS) main.typ build/submission.pdf
