# $Id: Makefile,v 1.5 2002/05/04 04:59:59 ehood Exp $

.PHONY: default vim restbl ctypetbl clean

TOP	  = ../..
include $(TOP)/etc/variables.mk

default: vim

restbl:
	$(PERL) mkrestbl.pl resource.lst > restbl.html

ctypetbl:
	$(PERL) dumpctypes.pl 1>ctypes.tmp 2>&1
	$(PERL) mkctypetbl.pl ctypes.tmp > ctypetbl.gml

vim:
	$(PERL) addvimtags.pl resource.lst ../../examples/mhonarc.vim

clean:
	$(RM) -f *.tmp *.gml
