#!/usr/bin/perl
# $Id: cmp.pl,v 1.2 2002/12/03 06:00:57 ehood Exp $
# Compare two char mapping tables.  Comes in handy to see how different
# similiar mappings are.

my $map1 = require shift(@ARGV);
my $map2 = require shift(@ARGV);

my $h1 = $map1;
my $h2 = $map2;

my($char, $uni, $uni2);
while (($char, $uni) = each %$h1) {
  $uni2 = $h2->{$char};

  if (!defined($uni2)) {
    print "0:$char:$uni\n";
    next;
  }
  delete($h2->{$char});
  if ($uni ne $uni2) {
    print "!:$char:$uni:$uni2\n";
    next;
  }
}

while (($char, $uni2) = each %$h2) {
  print "1:$char:$uni2\n";
}
