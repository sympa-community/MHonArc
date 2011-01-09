#!/usr/bin/perl
# $Id: Makefile.PL,v 1.15 2011/01/01 00:56:12 ehood Exp $
# Pseudo Makefile.PL:  Since MHonArc's history goes back to Perl 4 days,
# it has its own installation process.  This file generates a simple
# Makefile to (paritally) satisfy the standard Perl 5 way to install
# software.

use Config;

open(MAKEFILE, ">Makefile") ||
    die "Unable to create Makefile: $!\n";

## Map variable settings to install.me options
%vars = ( );
foreach (@ARGV) {
  # make sure to only process arguments that look like variables
  if (/=/) {
    ($var, $value) = split(/=/, $_, 2);
    $vars{$var} = $value;
  }
}
my $opt_prefix  = defined($vars{'PREFIX'}) ?
			"-prefix $vars{'PREFIX'}" : "";
my $opt_binpath = defined($vars{'INSTALLSCRIPT'}) ?
			"-binpath $vars{'INSTALLSCRIPT'}" : "";
my $opt_libpath = defined($vars{'LIB'}) ?
			"-libpath $vars{'LIB'}" :
		  defined($vars{'INSTALLSITELIB'}) ?
			"-libpath $vars{'INSTALLSITELIB'}" :
		  defined($vars{'INSTALLPRIVLIB'}) ?
			"-libpath $vars{'INSTALLPRIVLIB'}" : "";
my $opt_manpath = defined($vars{'INSTALLMAN1DIR'}) ?
			"-manpath $vars{'INSTALLMAN1DIR'}" : "";
   $opt_manpath =~ s/man1$//;

my $instme_args = "$opt_prefix $opt_binpath $opt_libpath $opt_manpath";

## Determine which perl should be used
my $perl  = $Config{'perlpath'};
unless (-x $perl) {
  $perl = join('/', $Config{'installbin'}, $Config{'perl'});
}
unless (-x $perl) {
  $perl = 'perl';
}
## Determine other commands that will be used
my $chmod = $Config{'chmod'} || '/bin/chmod';
my $mkdir = $Config{'mkdir'} || '/bin/mkdir';
my $rm    = $Config{'rm'} || '/bin/rm';

## Print Makefile
print MAKEFILE <<EOF;
# This Makefile is for the MHonArc software package.

CHMOD		= $chmod
MKDIR		= $mkdir
RM		= $rm
PRGS		= mhonarc mha-dbrecover mha-dbedit mha-decode
PERL		= $perl
INSTALLPRG	= install.me

default: _FORCE
	\$(CHMOD) a+x \$(PRGS)
	\$(CHMOD) -R a+r,a+X .

install: _FORCE
	\$(PERL) \$(INSTALLPRG) -batch $instme_args

install-ask: _FORCE
	\$(PERL) \$(INSTALLPRG) $instme_args

test: _FORCE
	\@echo "No tests"

clean: _FORCE
	\@echo "Nothing to clean"

_FORCE:

EOF

close(MAKEFILE);
exit(0);
