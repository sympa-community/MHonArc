##---------------------------------------------------------------------------##
##	@(#) Makefile 1.5 97/05/15 16:59:40 @(#)
##---------------------------------------------------------------------------##

CHMOD		= /bin/chmod
RM		= /bin/rm
PRGS		= mhonarc
TXTFILES	= ACKNOWLG CHANGES COPYING README RELNOTES INSTALL BUGS
DOSIFY		= dosify
PERL		= perl
INSTALLPRG	= install.me
INSTALLCFG	= install.cfg

default:
	$(CHMOD) a+x $(PRGS)
	$(CHMOD) -R a+r,a+X .
	$(DOSIFY) $(TXTFILES)

install:
	$(PERL) $(INSTALLPRG)

install-batch:
	$(PERL) $(INSTALLPRG) batch

test:
	@echo "No tests"

clean:
	@echo "Nothing to clean"
