
# @(#) Makefile.PL 1.1 98/11/08 15:41:21
# Pseudo Makefile.PL:  Since MHonArc's history goes back to Perl 4 days,
# it has its own installation process.  This file generates a simple
# Makefile to (paritally) satisfy the standard Perl 5 way to install
# software.

open(MAKEFILE, ">Makefile") ||
    die "Unable to create Makefile: $!\n";

%vars = ( map { split(/=/, $_) } @ARGV );
my $opt_prefix  = defined($vars{'PREFIX'}) ?
			"-prefix $vars{'PREFIX'}" : "";
my $opt_binpath = defined($vars{'INSTALLSCRIPT'}) ?
			"-prefix $vars{'INSTALLSCRIPT'}" : "";
my $opt_libpath = defined($vars{'LIB'}) ?
			"-libpath $vars{'LIB'}" :
		  defined($vars{'INSTALLSITELIB'}) ?
			"-libpath $vars{'INSTALLSITELIB'}" :
		  defined($vars{'INSTALLPRIVLIB'}) ?
			"-libpath $vars{'INSTALLPRIVLIB'}" : "";
my $opt_manpath = defined($vars{'INSTALLMAN1DIR'}) ?
			"-prefix $vars{'INSTALLMAN1DIR'}" : "";
   $opt_manpath =~ s/man1$//;

my $instme_args = "$opt_prefix $opt_binpath $opt_libpath $opt_manpath";


print MAKEFILE <<EOF;
# This Makefile is for the MHonArc software package.

CHMOD		= /bin/chmod
RM		= /bin/rm
PRGS		= mhonarc mha-dbrecover mha-dbedit
PERL		= perl
INSTALLPRG	= install.me


default:
	\$(CHMOD) a+x \$(PRGS)
	\$(CHMOD) -R a+r,a+X .

install:
	\$(PERL) \$(INSTALLPRG) -batch $instme_args

install-ask:
	\$(PERL) \$(INSTALLPRG) $instme_args

test:
	\@echo "No tests"

clean:
	\@echo "Nothing to clean"

EOF

close(MAKEFILE);
exit(0);
