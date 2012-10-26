# Makefile to test system setup
# 
# The default test includes only font test using XeLaTeX
# additional tests might be added in the future

test: font-test
font-test: font-test.pdf review-font-test


# Build using XeLaTeX
%.pdf: font-test.tex
	 -xelatex -interaction nonstopmode $<

review-font-test: font-test.pdf
	 @if [ ! -e "$<" ] ; then echo "ERROR: PDF file not generated, review logs"; exit 1; fi
	 @if [ -e "font-test.log" ] &&  grep -q "Some font shapes were not available" font-test.log ; then \
	 	echo "ERROR: There was a problem inserting some fonts. Please review the output file: $<"; \
	  else \
	 	echo "All fonts were included, please review the file $< to ensure that fonts are embedded properly"; \
	 fi

# Build using LaTeX
%.dvi: %.tex $(EXTRAFILES)
	latex -interaction nonstopmode $<

%.ps: %.dvi
	dvips -Ppdf $<

#%.pdf: %.ps
#	 ps2pdf $<

# Build using pdflatex 
#%.pdf: font-test.tex
#	 pdflatex -interaction nonstopmode $<


clean:
	rm -f *.dvi *.log *.out *.aux *.pdf

.PHONY: clean test font-test
