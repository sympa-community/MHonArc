HTMLDOCS = \
            mhonarc.html \
            intro.html \
            install.html \
            qstart.html \
            overview.html \
            rcfile.html \
            adding.html \
            removing.html \
            indexpg.html \
            message.html \
            mime.html \
            details.html \
            diagnos.html \
            glossary.html \
	    contacts.html

TMPFILE = ,mhonarc
TEXTDOC = mhonarc.txt
MANPAGE = mhonarc.1

$(TEXTDOC): $(HTMLDOCS) mktxt
	/bin/rm -f $(TMPFILE) $(TEXTDOC) $(MANPAGE)
	@for i in $(HTMLDOCS) ;\
	do \
	    echo $$i ;\
	    lynx -dump -nolist $$i >> $(TMPFILE) ;\
	done
	perl mktxt < $(TMPFILE)
	/bin/rm -f $(TMPFILE)
	chmod 644 $(TEXTDOC) $(MANPAGE)

