HTMLDOCS = \
            mhonarc.doc.html \
            mhonarc_intro.doc.html \
            mhonarc_qstart.doc.html \
            mhonarc_env.doc.html \
            mhonarc_clopts.doc.html \
            mhonarc_rcfile.doc.html \
            mhonarc_adding.doc.html \
            mhonarc_mime.doc.html \
            mhonarc_indexpg.doc.html \
            mhonarc_icons.doc.html \
            mhonarc_integrity.doc.html \
            mhonarc_tips.doc.html \
            mhonarc_notes.doc.html \
	    mhonarc_diagnostics.doc.html

TEXTDOC = mhonarc.txt

textdoc:
	/bin/rm -f $(TEXTDOC)
	@for i in $(HTMLDOCS) ;\
	do \
	    echo $$i ;\
	    lynx -dump $$i >> mhonarc.txt ;\
	done
	chmod 644 $(TEXTDOC)

