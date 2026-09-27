LATEXMK ?= latexmk
CHKTEX ?= chktex
PYTHON ?= python3
export TEXMFVAR := $(CURDIR)/build/texmf-var
export TEXMFCONFIG := $(CURDIR)/build/texmf-config

SOURCES := main.ltx preamble.ltx $(shell find chapters -name '*.ltx' -print) $(wildcard support/*.cls support/*.sty)

.PHONY: all pdf lint clean distclean

all: pdf

pdf: main.pdf

main.pdf: $(SOURCES) bibliography.bib .latexmkrc
	$(LATEXMK) -lualatex -interaction=nonstopmode -halt-on-error main.ltx

lint:
	$(CHKTEX) -q -n1 -n8 -n13 main.ltx preamble.ltx $(shell find chapters -name '*.ltx' -print)
	$(PYTHON) support/check-kernel-names.py

clean:
	$(LATEXMK) -c main.ltx

distclean:
	$(LATEXMK) -C main.ltx
