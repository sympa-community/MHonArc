use strict;
use warnings;

# Launch this test with
# perl -MTest::Harness -e 'runtests @ARGV' xt/perltidy.t

use English qw(-no_match_vars);
use File::Finder;
use FindBin qw($Bin);
use Test::More;
use Test::PerlTidy;

chdir "$Bin/.." or die $ERRNO;

my $finder = File::Finder->type('f')->name(qr{[.](?:pl|pm|t)$});
my @lib_files = grep { $_ !~ m@^lib/MHonArc/(?:UTF8|Char|CharEnt)/@ }
    $finder->in(qw(lib));
my @files = (
    'mhonarc',                       'mha-dbedit',
    'mha-dbrecover',                 'mha-decode',
    @lib_files,                      'lib/MHonArc/CharMaps.pm',
    'lib/MHonArc/Char/JP.pm',        'lib/MHonArc/Char/KR.pm',
    'lib/MHonArc/UTF8/Encode.pm',    'lib/MHonArc/UTF8/MapUTF8.pm',
    'lib/MHonArc/UTF8/MhaEncode.pm', 'examples/mha-p7m',
    'examples/mha-preview',          $finder->in(qw(examples)),
    $finder->in(qw(contrib)),        $finder->in(qw(xt))
);

foreach my $file (@files) {
    ok Test::PerlTidy::is_file_tidy($file, '.perltidyrc'), $file;
}

done_testing;
