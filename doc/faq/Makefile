# $Date: 2002/04/02 06:57:57 $ 

TOCFILE = faq.html
HTMLFILES = \
	    about.html \
	    general.html \
	    envs.html \
	    usage.html \
	    archives.html \
	    indexpgs.html \
	    msgpgs.html \
	    threads.html \
	    mime.html \
	    security.html \
	    # End of files

default: addbuttons pagetocs toc

addbuttons:
	perl _helper/addbuttons.pl $(HTMLFILES)

pagetocs:
	perl _helper/addtoc-i.pl $(HTMLFILES)

toc:
	perl _helper/addtoc.pl $(TOCFILE) $(HTMLFILES)

clean:
	/bin/rm -f *.tmp *.gml
