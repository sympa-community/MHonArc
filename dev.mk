# $Id: dev.mk,v 2.4 2002/05/07 22:59:40 ehood Exp $
##-----------------------------------------------------------------------##
##  Development makefile.
##-----------------------------------------------------------------------##

.PHONY: release code-check

TOP     = .
SUBDIRS = \
	  lib \
	  # End SUBDIRS

include $(TOP)/etc/variables.mk

##-----------------------------------------------------------------------##

TAR_EXCLUDE	= ./etc/tar-exclude
DIST_DIR	= ./dist
INSTALL_ME	= $(PROJECTS_RELEASES)/install.me/latest/install.me
VERSION_NAME	= MHonArc$(_RELEASE_VERSION)

PERL_FILES	= \
		  Makefile.PL \
		  mhonarc \
		  mha-dbedit \
		  mha-dbrecover \
		  mha-decode \
		  # End PERL_FILES

##-----------------------------------------------------------------------##

default: code-check

release: version-check code-check
	@$(RM) -rf $(DIST_DIR)
	-@$(MKDIR) -p $(DIST_DIR)/$(VERSION_NAME)
	@echo "Copying files to $(DIST_DIR)..."
	$(TAR) -c -X $(TAR_EXCLUDE) -f - . | \
	    (cd $(DIST_DIR)/$(VERSION_NAME) && $(TAR) xfp -)
	$(CP) $(INSTALL_ME) $(DIST_DIR)/$(VERSION_NAME)
	(cd $(DIST_DIR)/$(VERSION_NAME) && $(PERL) Makefile.PL)
	(cd $(DIST_DIR)/$(VERSION_NAME) && $(MAKE) release-prep)
	@$(RM) -f $(DIST_DIR)/$(VERSION_NAME)/Makefile
	@(echo "Creating tar bundles..." && \
	  cd $(DIST_DIR) && \
	  $(TAR) -cf $(VERSION_NAME).tar $(VERSION_NAME) && \
	  echo "  ...bz2..." && \
	  $(BZIP2) -k $(VERSION_NAME).tar && \
	  echo "  ...gz..." && \
	  $(GZIP) $(VERSION_NAME).tar)
	@(echo "Creating zip bundle..." && \
	  cd $(DIST_DIR) && \
	  $(ZIP) -r $(VERSION_NAME).zip $(VERSION_NAME))

version-check:
	@$(PERL) etc/version-check.pl "$(_RELEASE_VERSION)" lib/mhamain.pl

code-check: make_subdirs perl_syntax

clean:
	$(RM) -rf $(DIST_DIR) Makefile

##-----------------------------------------------------------------------##

include $(TOP)/etc/rules.mk
