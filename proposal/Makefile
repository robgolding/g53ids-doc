document = proposal

$(document).pdf: $(document).ps
	ps2pdf $(document).ps

$(document).ps: $(document).dvi
	dvips $(document).dvi

$(document).dvi: *.tex
	latex $(document).tex && latex $(document).tex && rm *.toc *.aux *.log 2>/dev/null || echo

clean:
	rm -f *.aux *.toc *.log $(document).pdf $(document).ps $(document).dvi

show: $(document).pdf
	evince $(document).pdf &

pdf: $(document).pdf

ps: $(document).ps
