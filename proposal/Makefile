document = proposal
$(document).pdf: *.tex
	xelatex $(document).tex && xelatex $(document).tex && rm *.aux *.toc *.log

$(document).ps: $(document).pdf
	pdf2ps $(document).pdf $(document).ps

clean:
	rm -f *.aux *.toc *.log $(document).pdf $(document).ps

show: $(document).pdf
	evince $(document).pdf &

pdf: $(document).pdf

ps: $(document).ps
