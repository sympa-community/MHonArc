# $Id: variables.mk,v 1.5 2002/05/28 05:24:41 ehood Exp $
##-----------------------------------------------------------------------##
##  Common variables
##-----------------------------------------------------------------------##

ifeq ($(_variables_mk),)
_variables_mk:=1

## Programs
BZIP2		= /usr/bin/bzip2
CHMOD		= /bin/chmod
CP		= /bin/cp
GZIP		= /usr/bin/gzip
MKDIR		= /bin/mkdir
MV		= /bin/mv
PERL		= /usr/local/bin/perl
RM		= /bin/rm
TAR		= /bin/tar
ZIP		= zip

## Path and pathname separators.
## NOTE: Unix pathname conventions should used when possible since
##	 Win32 systems do handle "/".  However, PATHSEP should be
##	 be used since ":" under Win32 can be used in pathnames.
SEP		= /
PATHSEP		= :
ifneq ($(COMSPEC),)
  # Win32 environment
  SEP		= \\
  PATHSEP	= ;
endif

## Path to projects releases root
ifeq ($(PROJECTS_RELEASES),)
  PROJECTS_RELEASES = /mnt/WWW/customers/mhonarc.org/htdocs/release
endif

## Set include search path
ifeq ($(PERL_SEARCH_LIBS),)
  PERL_SEARCH_LIBS := $(TOP)/lib
endif


## List of perl files to check.  If not set, default to all files
## ending with .pm and .pl.

ifeq ($(PERL_PL_FILES),)
  PERL_PL_FILES = $(strip $(wildcard *.pl))
endif

ifeq ($(PERL_PM_FILES),)
  PERL_PM_FILES = $(strip $(wildcard *.pm))
endif

ifeq ($(PERL_FILES),)
  PERL_FILES    = $(PERL_PM_FILES) $(PERL_PL_FILES)
endif


endif
# NOTHING GOES BELOW THIS LINE
