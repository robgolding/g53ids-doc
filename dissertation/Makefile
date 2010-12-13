# Makefile for LaTeX files

# Original file from  http://www.acoustics.hut.fi/u/mairas/UltimateLatexMakefile

# please check http://www.takeonthecity.nl/roels-latex-makefile/

# Copyright (c) 2009,2010 (in order of appearance):
#   Roel Meeuws <r.j.meeuws@gmail.com>
#   refer to more copyright info below

# ChangeLog:
#
# 2010-07-01 - version 1.2.1
#   - fixed bug in viewing code thanks to John Stowers
#   - fixed bug in using bash shell thanks to John Stowers
# 2009-10-07 - version 1.2
#   - Added support for vector format .svg files
#   - Added support for PGF/TikZ .tikz files which is basically a latex 
#     tikzpicture environment block in a separate file (begin and end
#     tag should be in file too!)
#   - font embedding using 'make embedpdf' although, this should not happen
#     using this makefile and xetex... 
#   - Fix of font embedding when converting .fig files. 
#   - OpenDocument Drawing file (*.odg) format supported (requires unoconv 
#     and OpenOffice.org)
#   - Remove all beamer temporary files when cleaning up
#   - Add rule for installing prerequisites 'make get-requirements' 
# 2009-07-02 - version 1.1
# 	- Added support for gnuplot .gpi files
# 	- Added support for graphviz .dot files
# 	- Added support for xfig .fig files
# 	- Fixed the handling of metapost pictures. We now support multiple figures
# 	  per metapost file 
# 	- Added Google latex makefile error detection and coloring.
# 	- Replaced manual coloring with colored print routines for better
#  	  readability and modularization
#  	- fixed rules for backup directory 
#  	- use XeTex instead of PDFLaTeX for generating pdfs for better font support
# 2009-06-11 - version 1.0
# 	- First version published.

# Copyright notice from original file:
# Copyright (c) 2005,2006 (in order of appearance):
#	Matti Airas <Matti.Airas@hut.fi>
# 	Rainer Jung
#	Antoine Chambert-Loir
#	Timo Kiravuo

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions: 

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software. 

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 

SHELL = /bin/bash

LATEX	= xetex -interaction=batchmode
BIBTEX	= bibtex
MAKEINDEX = makeindex
XDVI	= xdvi -gamma 4
DVIPS	= dvips
DVIPDF  = dvipdft
#MAKEDJVU= djvudigital --words
MAKEDJVU= pdf2djvu -q
DJVUVIEW= okular
L2H	= mk4ht xhmlatex 
GH	= evince
PDFVIEW = evince
CONVERT= convert
GZIP = gzip --best
SED = sed

RERUN = "(Rerun to get (cross-references|the bars) right)"
RERUNBIB = "No file.*\.bbl|Citation.*undefined"
MAKEIDX = "^[^%]*\\makeindex"
MPRINT = "^[^%]*print"
USETHUMBS = "^[^%]*thumbpdf"
FIGDIR = generated
BACKUPDIR=backups
LTITLE = LaTeX
DATE=$(shell date +%Y-%m-%d)

COPY = if test -r $(<:%.tex=%.toc); then cp $(<:%.tex=%.toc) $(<:%.tex=%.toc.bak); fi > /dev/null
RM = rm -f
QUIET= &>/dev/null
DISPLAYERROR= || ($(call echo-error,Errors encountered:) && $(call colorize-latex-errors, $(<:%.tex=%.log)))

#&& perl -0 -ne '$$now=0;$$previous=0;@matches=/(![^.]*[.]\s*\n(?:[^l].*\n)*(l[.][0-9]+.*)\n)/g;foreach $$text (@matches) { if ($$text =~ /^l[.][0-9]+.*$$/) { $$previous = $$text } else { $$text =~ /\n(l[.][0-9]+.*)/; $$now=$$1; if ( $$previous ne  $$now ) { print "\n$$text\n" } } }' $(<:%.tex=%.log) && false )

SRC	:= $(shell egrep -l '^[^%]*\\begin\{document\}' *.tex)
TRG	:= $(SRC:%.tex=%.dvi)
PSF	:= $(SRC:%.tex=%.ps)
PSZ	:= $(SRC:%.tex=%.ps.gz)
PDF	:= $(SRC:%.tex=%.pdf)
DJVU:= $(SRC:%.tex=%.djvu)

# Terminal color definitions

ifdef NO_COLOR
tput		=
else
tput		= $(shell tput $1)
endif

black	:= $(call tput,setaf 0)
red	:= $(call tput,setaf 1)
green	:= $(call tput,setaf 2)
yellow	:= $(call tput,setaf 3)
blue	:= $(call tput,setaf 4)
magenta	:= $(call tput,setaf 5)
cyan	:= $(call tput,setaf 6)
white	:= $(call tput,setaf 7)
bold	:= $(call tput,bold)
uline	:= $(call tput,smul)
reset	:= $(call tput,sgr0)
#
#
# User-settable definitions
#
LATEX_COLOR_WARNING	?= magenta
LATEX_COLOR_ERROR	?= red
LATEX_COLOR_INFO	?= green
LATEX_COLOR_UNDERFULL	?= magenta
LATEX_COLOR_OVERFULL	?= red bold
LATEX_COLOR_PAGES	?= bold
LATEX_COLOR_BUILD	?= blue
LATEX_COLOR_GRAPHIC	?= yellow
LATEX_COLOR_DEP		?= green
LATEX_COLOR_SUCCESS	?= green bold
LATEX_COLOR_FAILURE	?= red bold
LATEX_COLOR_FILENAME?= black bold
LATEX_COLOR_PROGNAME?= black bold

# Gets the real color from a simple textual definition like those above
# $(call get-color,ALL_CAPS_COLOR_NAME)
# e.g., $(call get-color,WARNING)
get-color	= $(subst $(space),,$(foreach c,$(LATEX_COLOR_$1),$($c)))

#
# STANDARD COLORS
#
C_WARNING	:= $(call get-color,WARNING)
C_ERROR		:= $(call get-color,ERROR)
C_INFO		:= $(call get-color,INFO)
C_UNDERFULL	:= $(call get-color,UNDERFULL)
C_OVERFULL	:= $(call get-color,OVERFULL)
C_PAGES		:= $(call get-color,PAGES)
C_BUILD		:= $(call get-color,BUILD)
C_GRAPHIC	:= $(call get-color,GRAPHIC)
C_DEP		:= $(call get-color,DEP)
C_SUCCESS	:= $(call get-color,SUCCESS)
C_FAILURE	:= $(call get-color,FAILURE)
C_FILENAME  := $(call get-color,FILENAME)
C_PROGNAME  := $(call get-color,PROGNAME)
C_RESET		:= $(reset)



echo-img      = echo -e "$(C_BUILD)====> $(C_INFO)Generating figure $(C_FILENAME)$1$(C_RESET)$(if $2, | $(red)Step $2$(C_RESET),)"
echo-tex-step = echo -e "$(C_BUILD)====> $(C_INFO)$1 $(C_PROGNAME)$2 $(C_RESET)| $(red)$3$(C_RESET)"
echo-gen      = echo -e "$(C_BUILD)====> $(C_INFO)Generating $1 $(C_RESET)"
echo-do       = echo -e "$(C_BUILD)====> $(C_INFO)$1 $(C_FILENAME)$(if $2,$2,)$(C_RESET)"
echo-error    = echo -e "$(C_BUILD)====> $(C_ERROR)$1 $(C_FILENAME)$(if $2,$2,)$(C_RESET)"
echo-warning  = echo -e "$(C_BUILD)====> $(C_WARNING)$1 $(C_FILENAME)$(if $2,$2,)$(C_RESET)"
echo-finish   = echo -e "$(C_BUILD)====> $(blue)Finished $(C_RESET)$1$(C_INFO)$(if $2, in $(red)$2$(blue) runs,)$(C_RESET)"



# Colorizes real, honest-to-goodness LaTeX errors that can't be overcome with
# recompilation.
#
# Note that we only ignore file not found errors for things that we know how to
# build, like graphics files.
#
# $(call colorize-latex-errors,<log file>)
define colorize-latex-errors
$(SED) \
-e '/^! LaTeX Error: File .*eps'"'"' not found\.$$/d' \
-e '/^! LaTeX Error: Cannot determine size/d' \
-e '/^! /,/^$$/{' \
-e '  H' \
-e '  /^$$/{' \
-e '    x' \
-e '    s/^.*$$/$(C_ERROR)&$(C_RESET)/' \
-e '    p' \
-e '  }' \
-e '}' \
-e 'd' \
$1
endef

define run-latex
	$(COPY) $(QUIET);\
	$(call echo-tex-step,Running,$(LTITLE),First Run);\
	$(LATEX) $< $(QUIET) $(DISPLAYERROR) ; runs=1; \
	if egrep $(MAKEIDX) $< $(QUIET);\
	then\
		$(call echo-gen,index);\
		$(MAKEINDEX) $(<:%.tex=%) $(QUIET);\
		$(COPY) $(QUIET);\
		$(call echo-tex-step,Running,$(LTITLE),Including Index);\
		$(LATEX) $< $(QUIET) $(DISPLAYERROR); let "runs=runs+1"; \
    fi;\
	bibrun=1;\
	while egrep -c $(RERUNBIB) $(<:%.tex=%.log) $(QUIET);\
	do\
		if [ "$$bibrun" -eq "1" ];\
		then\
			$(call echo-do,Parsing Bibliography);\
			$(BIBTEX) $(<:%.tex=%) $(QUIET);\
			for f in bu*.aux; do $(BIBTEX) $$f $(QUIET); done;\
		fi;\
		$(call echo-tex-step,Running,$(LTITLE),Applying bibliography (run $$bibrun));\
		$(COPY) $(QUIET);\
		$(LATEX) $< $(QUIET) $(DISPLAYERROR);\
		let "bibrun=bibrun+1";\
	done;\
	try=1;\
	while egrep -c $(RERUN) $(<:%.tex=%.log) $(QUIET);\
	do\
		$(call echo-tex-step,Running,$(LTITLE),Solving References (run $$try));\
		$(COPY) $(QUIET);\
		$(LATEX) $< $(QUIET) $(DISPLAYERROR);\
		let "try=try+1"; \
	done;\
	let "runs=runs + bibrun + try - 2";\
	if cmp -s $(<:%.tex=%.toc) $(<:%.tex=%.toc.bak) $(QUIET);\
	then\
		true;\
	else \
		if test -r $(<:%.tex=%.toc.bak); \
		then \
			$(call echo-tex-step,Running,$(LTITLE),Solving References (run $$try));\
			$(LATEX) $< $(QUIET) $(DISPLAYERROR);\
			let "runs=runs+1";\
		fi;\
	fi;\
	$(RM) $(<:%.tex=%.toc.bak) $(QUIET);\
	$(call echo-finish,$(LTITLE),$$runs);\
	$(call echo-warning,Undefined references and citations:);\
	echo -n "$(C_WARNING)" && egrep -i "(Reference|Citation).*undefined" $(<:%.tex=%.log) && echo -n -e "$(C_RESET)" || echo -e "$(C_INFO)None.$(C_RESET)";\
	true;
endef

define get_dependencies
	deps=`perl -ne '($$_)=/^[^%]*\\\(?:include|input)\{(.*?)\}/;@_=split /,/;foreach $$t (@_) {print "$$t.tex "}' $<`
endef

define get_dependent_dirs
	depdirs=`echo -n ". "; for dir in $$(for file in $$(perl -ne '($$_)=/^[^%]*\\\(?:include|input)\{(.*?)\}/;@_=split /,/;foreach $$t (@_) {print "$$t.tex "}' $<);do echo $$(dirname $$file); done | sort -u); do echo -n $$dir; echo -n " "; done`
endef

define getbibs
	bibs=`perl -ne '($$_)=/^[^%]*\\\bibliography\{(.*?)\}/;@_=split /,/;foreach $$b (@_) {print "$$b.bib "}' $< $$deps`
endef

define getepss
	epss=`perl -ne '@foo=/^[^%]*\\\(includegraphics|psfig|[a-zA-Z]+WallPaper\{[0-9]*\.?[0-9]*\})(\[.*?\])?\{(.*?)\}/g;if (defined($$foo[2])) { if ($$foo[2] =~ /.eps$$/) { print "$(FIGDIR)/$$foo[2]\n"; } else { print "$(FIGDIR)/$$foo[2].eps\n"; }}' $< $$deps | sort -u | sed ':begin;N;s/\n/ /;t begin'`
endef

define getpdfs
	pdfs=`perl -ne '@foo=/^[^%]*\\\(includegraphics|[a-zA-Z]+WallPaper\{[0-9]*\.?[0-9]*\})(\[.*?\])?\{(.*?)\}/g;if (defined($$foo[2])) { if ($$foo[2] =~ /.pdf$$/) { print "$(FIGDIR)/$$foo[2]\n"; } else { print "$(FIGDIR)/$$foo[2].pdf\n"; }}' $< $$deps | sort -u | sed ':begin;N;s/\n/ /;t begin'`
endef

define getfigdirs
	dirs="";\
	for file in $$epss $$pdfs;\
	do\
		dir=`dirname $$file`;\
		if (echo -e $$dirs | egrep -c $$dir) > /dev/null;\
		then\
			true;\
		else\
			dirs="$$dirs $$dir ";\
		fi\
	done
endef

define manconf
	mandeps=`if test -r $(basename $@).cnf ; then cat $(basename $@).cnf |tr -d '\n\r' ; fi`
endef

default: $(PDF)

push:
	../upload/upload.sh $(PDF)

# $(DEP) $(EPSPICS) $(BIBFILE)
$(TRG)	: %.dvi : %.tex %.d
	@$(run-latex)


$(PSF)	: %.ps : %.dvi %.d
	@$(call echo-do,Generating,$@)
	@$(DVIPS) $< -o $@ $(QUIET)

$(PSZ) : %.ps.gz : %.ps
	@$(call echo-do,Compressing,$@)
	@$(GZIP) -c $< > $@

$(PDF)	: LATEX = xelatex -interaction=batchmode -file-line-error-style
$(PDF)	: LTITLE = XeTeX
$(PDF)	: %.pdf : %.tex %.d
	@$(run-latex)
	@$(call echo-do,Optimizing,$@)
	@(pdfopt $@ $@.pdf)
	@mv $@.pdf $@ 

$(PDF:.pdf=.embedded.pdf)	: $(PDF)
	@$(call echo-do,Embedding fonts,$*)
	@$(call echo-warning,This operation removes any hyperlinks in,$@)
	@$(call echo-warning,This operation may increase file size of,$@)
	@(pdftops $< $<.ps)
	@(ps2pdf -dPDFSETTINGS=/prepress $<.ps $@)
	@-rm $<.ps

#$(PDF)  %.pdf : %.dvi
#	@$(call echo-gen,$@)
#	@$(DVIPDF) -o $@ $<


$(DJVU): %.djvu : %.pdf
	@$(call echo-gen,$@)
	@($(MAKEDJVU) -o $@ $< ) $(QUIET)


# image conversion rules
generated/%.eps	: 	%.png
	@$(call echo-img,$@)
	@$(CONVERT) -compress zip $< eps3:$@ 2> /dev/null 1> /dev/null

generated/%.eps	: 	%.tiff
	@$(call echo-img,$@)
	@$(CONVERT) -compress zip $< eps3:$@ 2> /dev/null 1> /dev/null

generated/%.eps	: 	%.jpg
	@$(call echo-img,$@)
	@$(CONVERT) -compress zip $< eps3:$@ 2> /dev/null 1> /dev/null

generated/%.eps	: 	%.bmp
	@$(call echo-img,$@)
	@$(CONVERT) -compress zip $< eps3:$@ 2> /dev/null 1> /dev/null

generated/%.eps	: 	%.gif
	@$(call echo-img,$@)
	@$(CONVERT) -compress zip $< eps3:$@ 2> /dev/null 1> /dev/null

generated/%.eps	:	%.pdf
	@$(call echo-img,$@)
	@pdftops -eps -level3 $< $@ 2> /dev/null 1> /dev/null


generated/%.eps	:	%.ps
	@$(call echo-img,$@)
	@ps2eps -l -q $<
	@mv $*.eps $@ 

generated/%.eps	:	%.eps
	@$(call echo-cpy,$@)
	@cp $< $@

mpfignum = $(shell echo $1 | sed 's/.*-\([0-9]\+\)\.\(eps\|pdf\)/\1/')
# this is now done in generated dependencies file
#generated/%.eps	: $(call mpfigname,$@)
#	@$(call echo-img,$@)
#	@echo $<
#	@mpost $<
#	@mv $*.$(call mpfignum,$@) $@

generated/%.eps :	%.fig
	@$(call echo-img,$@)
	@fig2dev -L eps $< > $@ 2> /dev/null

generated/%.eps :	%.dia
	@$(call echo-img,$@)
	@dia --export=$@ --filter=eps $< 2> /dev/null 1> /dev/null

generated/%.eps : %.gpi
	@$(call echo-img,$@)
	@(echo set terminal postscript eps enhanced color; cat $<) | gnuplot > $@

generated/%.eps : %.dot
	@$(call echo-img,$@)
	@dot -Teps $< > $@

generated/%.eps : %.svg
	@$(call echo-img,$@)
	@inkscape -z --file=$< --export-eps=$@ $(QUIET)

generated/%.eps: %.tikz
	@$(call echo-img,$@)
	@tikz2pdf -o $< $(QUIET)
	@mv tikz2pdf_temp.pdf $*.pdf
	@pdftops -eps -level3 $*.pdf $@ 2> /dev/null 1> /dev/null
	@-rm $*.pdf

generated/%.eps : %.odg
	@$(call echo-img,$@)
	@unoconv -f pdf $< $(QUIET)
	@pdftops -eps -level3 $*.pdf $@ 2> /dev/null 1> /dev/null
	@-rm $*.pdf

generated/%.pdf	:	%.pdf
	@$(call echo-cpy,$@)
	@cp $< $@

generated/%.pdf :	%.eps
	@$(call echo-img,$@)
	@epstopdf --outfile=$@ $< 2> /dev/null 1> /dev/null

generated/%.pdf :	%.fig
	@$(call echo-img,$@)
	@cd $(dir $<);fig2mpdf $(notdir $<) 2> /dev/null 1> /dev/null
	@pdftops $*.pdf $*.ps
	@ps2pdf -dPDFSETTINGS=/prepress $*.ps $*.pdf
	@-rm -rf $*.ps
	@mv $*.pdf $@

generated/%.pdf :	%.dia
	@$(call echo-img,$@,1)
	@dia --export=$(<:.dia=.eps) --filter=eps $< 2> /dev/null 1> /dev/null
	@$(call echo-img,$@,2)
	@epstopdf --outfile=$@ $(<:.dia=.eps) 2> /dev/null 1> /dev/null
	@-rm -rf $(<:.dia=.eps) &> /dev/null

generated/%.pdf :	%.ps
	@$(call echo-img,$@)
	@ps2pdf14 -dPDFSETTINGS=/prepress $< $@ 2> /dev/null 1> /dev/null

generated/%.pdf :	%.bmp
	@$(call echo-img,$@)
	@$(CONVERT) $< $@

generated/%.pdf :	%.png
	@$(call echo-img,$@)
	@$(CONVERT) $< $@

generated/%.pdf :	%.jpg
	@$(call echo-img,$@)
	@$(CONVERT) $< $@

generated/%.pdf :	%.tif
	@$(call echo-img,$@)
	@$(CONVERT) $< $@

generated/%.pdf :	%.tiff
	@$(call echo-img,$@)
	@$(CONVERT) $< $@

# this is now done in generated dependencies file
#generated/%.pdf	:	%.mp
#	@$(call echo-img,$@)
#	@mptopdf $< &> /dev/null
#	@rm $*.1
#	@mv $*-1.pdf $@

generated/%.pdf : %.gpi
	@$(call echo-img,$@,1)
	@(echo set terminal mp color; cat $<) | gnuplot > $(<:.gpi=.mp)
	@$(call echo-img,$@,2)
	@cd $(dir $<);mptopdf $(notdir $(<:.gpi=.mp)) &> /dev/null
	@mv $*-0.pdf $@
	@-rm -rf $(<:.gpi=.mp)* $*-*  $*.0 $*.log &> /dev/null

generated/%.pdf : %.dot
	@$(call echo-img,$@)
	@dot -Tpdf $< > $@

generated/%.pdf : %.svg
	@$(call echo-img,$@)
	@inkscape -z --file=$< --export-pdf=$@ $(QUIET)

generated/%.pdf : %.tikz
	@$(call echo-img,$@)
	@tikz2pdf -o $< $(QUIET)
	@mv tikz2pdf_temp.pdf $@

generated/%.pdf : %.odg
	@$(call echo-img,$@)
	@unoconv -f pdf $< $(QUIET)
	@mv $*.pdf $@

#generated/%.pdf : %.r
#	@$(call echo-img,$@)
#	@echo pdf(file="$$(pwd)/$@") >> /tmp/$
#	@R -slave -f $<
#	@

# This is a rule to generate a file of prerequisites for a given .tex file
%.d	: %.tex
	@$(call echo-do,Determining dependencies);\
	$(get_dependencies) ; \
	$(getbibs) ; \
	$(getepss) ; \
	$(getpdfs) ; \
	$(getfigdirs) ;\
	$(get_dependent_dirs) ;\
	$(manconf) ;\
	echo -e "$*.dvi $*.pdf $@ : $< $$deps $$bibs $$mandeps $(EXTRAS)" > $@ ; echo "" >> $@ ; \
	echo -e "$*.dvi : $$dirs $$epss" >> $@ ; echo "" >> $@ ; \
	echo -e "$*.pdf : $$dirs $$pdfs" >> $@ ; echo "" >> $@ ; \
	for file in $$epss $$pdfs; \
	do \
	    mpsrc=$$(echo $$file | sed 's/^generated\/\(.*\)-[0-9]\+.\(pdf\|eps\)/\1.mp/g'); \
		mpsrc=$$(echo $$mpsrc | grep [.]mp); \
		if [ $$mpsrc=="" ]; then continue; fi; \
		if [ -f $$mpsrc ]; \
		then \
			echo -e "$$file: $$mpsrc" >> $@; \
			echo -e "\t@\$$(call echo-img,\$$@)" >> $@; \
			if [ $${file##*.} != "pdf" ]; \
			then \
				echo -e "\t@cd \$$(dir \$$<);mpost \$$(notdir \$$<) \$$(QUIET)" >> $@; \
				echo -e "\t@mv \$$(basename \$$<).\$$(call mpfignum,\$$@) \$$@" >> $@; \
			else \
				echo -e "\t@cd \$$(dir \$$<);mptopdf \$$(notdir \$$<) &> /dev/null" >> $@; \
				echo -e "\t@mv \$$(basename \$$<)-\$$(call mpfignum,\$$@).pdf \$$@" >> $@; \
				echo -e "\t@rm -f \$$(basename \$$<).\$$(call mpfignum,\$$@) \$$<?* \$$(basename \$$<)-* \$$(basename \$$<).log mpgraph.mp" >> $@; \
			fi; \
		fi; \
	done; \
	echo "" >> $@; \
	echo -e "DEPDIRS=$$depdirs" >> $@ ; echo "" >> $@ ; \
	if [[ $$dirs != "" ]]; then\
		echo -e "$$dirs	:" >> $@ ;\
		echo -e "\t@\$$(call echo-do,Creating directory,\$$@)" >> $@ ;\
		echo -e "	@mkdir -p \$$@" >> $@ ;\
	fi


.PHONY	: all show clean ps pdf embedpdf html showps showpdf tidy verytidy clean-images pristine backup backupdir

all 	: $(TRG)

default :
	echo "$(blue)done.$(C_RESET)"

view	: showpdf
show	: showpdf

viewdjvu: showdjvu
showdjvu: djvu
	@for i in $(DJVU) ; do \
		$(call echo-do, Viewing,$<: $$i)\
		$(DJVUVIEW) $$i; \
	done

viewdvi : showdvi
showdvi	: $(TRG)
	@for i in $(TRG) ; do \
		$(call echo-do, Viewing,$<: $$i)\
		$(XDVI) $$i; \
	done

viewps	: showps
showps	: ps
	@for i in $(PSF) ; do \
		$(call echo-do, Viewing,$<: $$i)\
		$(GH) $$i; \
	done

viewpdf	: showpdf
showpdf	: pdf
	@for i in $(PDF) ; do \
		$(call echo-do, Viewing,$<: $$i);\
		$(PDFVIEW) $$i; \
	done

psgz: $(PSZ)

postscript: ps
ps	: $(PSF) 

pdf	: $(PDF)

embedpdf: $(PDF:.pdf=.embedded.pdf)

djvu: pdf $(DJVU)

$(BACKUPDIR):
	@$(call echo-do, Creating Backup Directory)
	@mkdir -p $(BACKUPDIR)

backupdir: $(BACKUPDIR)

backup: clean backupdir
	@$(call echo-do, Backing up project)
	@export NUM=`ls backup/ | grep backup.tar.bz2 | wc -l` && tar jcvf ` echo -e "backup/backup.tar.bz2."$$NUM` `find ./ -not -type d -a -not -regex .*backup.* -a -not -regex .*svn.* | tail -n +2`


# TODO: This probably needs fixing
html	: $(DEP) $(EPSPICS)
	  @$(L2H) $(SRC) $(QUIET)

refresh:
	rm -rf *.d

tidy	:
	@$(call echo-do, Cleaning up temporary files)
	@-rm -f $(TRG:%.dvi=%.bbl) $(TRG:%.dvi=%.blg) $(TRG:%.dvi=%.log) $(TRG:%.dvi=%.out) $(TRG:%.dvi=%.idx) $(TRG:%.dvi=%.ilg) $(TRG:%.dvi=%.ind) $(TRG:%.dvi=%.toc) $(TRG:%.dvi=%.d) $(TRG:%.dvi=%.nav) $(TRG:%.dvi=%.snm)

clean-images:
	@$(call echo-do, Cleaning up generated images)
	@-rm -rf $(FIGDIR)

verytidy	: tidy clean-images
	@$(call echo-do, Cleaning up intermediate files)
	@for dir in $(DEPDIRS); do cd $$dir && rm -f *.log *.aux *.dvi *.bbl *.blg *.ilg *.toc *.lof *.lot *.lol *.idx *.ind *.ps  *~ && cd - > /dev/null; done

clean:	verytidy
	@$(call echo-do, Cleaning up output files)
	@-rm -f $(TRG) $(PSF) $(PSZ) $(PDF) $(DJVU) $(PDF:.pdf=.embedded.pdf)

pristine: clean
	@$(call echo-do, Removing backups)
	@-rm -rf $(BACKUPDIR)

get-requirements:
	@$(call echo-do, Fetching required packages using apt-get)
	@sudo apt-get install imagemagick gnuplot unoconv texlive-full pdf2djvu okular bash dia xfig graphviz inkscape perl gzip evince ps2eps psutils pdfjam pdftk ghostscript

include $(SRC:.tex=.d)
