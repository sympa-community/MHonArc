# $Id: Makefile,v 1.12 2002/07/27 05:13:10 ehood Exp $

.PHONY: default rcpages residx toc pagetocs buttons rcfileexs utildocs vim

TOP	  = ..

include $(TOP)/etc/variables.mk

TOCFILE	  = mhonarc.html
HTMLFILES = intro.html \
	    relnotes.html \
	    install.html \
	    quickstart.html \
	    commontasks.html \
	    layout.html \
	    resources.html \
	    rcvars.html \
	    contacts.html \
	    app-rcidx.html \
	    app-rcfileexs.html \
	    app-diagnos.html \
	    app-utilsprg.html \
	    app-api.html \
	    app-mimeconf.html \
	    app-bugs.html \
	    # End of HTMLFILES

UTIL_PODS = \
	    $(TOP)/mha-dbedit \
	    $(TOP)/mha-dbrecover \
	    $(TOP)/mha-decode \
	    # End of UTIL_PODS

RCLIST	  = _helper/resource.lst
RCVARLIST = _helper/rcvars.lst


default: rcpages residx rcfileexs toc pagetocs buttons utildocs vim

rcpages:
	$(MAKE) -C resources all

residx:
	$(PERL) _helper/addrcindex.pl $(RCLIST) resources.html app-rcidx.html

toc:
	$(PERL) _helper/addtoc.pl $(TOCFILE) $(HTMLFILES)

pagetocs:
	$(PERL) _helper/addtoc-i.pl $(HTMLFILES)

buttons:
	$(PERL) _helper/addbuttons.pl $(HTMLFILES)

rcfileexs:
	-@$(MKDIR) -p rcfileexs
	@for i in ../examples/*.mrc; do \
	  echo "Converting $$i to html..."; \
	  $(PERL) _helper/ppeg.pl $(RCLIST) $(RCVARLIST) $$i > \
		  rcfileexs/`basename $$i`.html; \
	done

vim:
	$(PERL) _helper/addvimtags.pl $(RCLIST) ../examples/mhonarc.vim

utildocs: $(UTIL_PODS)
	-@$(RM) -f pod2htm*~~

$(UTIL_PODS): _force
	-@$(MKDIR) -p utils
	pod2html --header --infile=$@ \
		 --outfile=utils/$(notdir $@).html

clean:
	$(RM) -rf *.gml \
	          pod2htm*~~ \
		  utils \
		  rcfileexs/*.mrc.html

_force:

