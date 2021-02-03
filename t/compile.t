# -*- indent-tabs-mode: nil; -*-
# vim:ft=perl:et:sw=4

use strict;
use warnings;
use Test::More;

BEGIN {
    eval 'use Test::Compile::Internal';
    $Test::Compile::Internal::VERSION or plan skip_all => 'Test::Compile::Internal required';
}

my $test = Test::Compile::Internal->new;
grep { ok $test->pl_file_compiles($_), "$_ compiles" }
    qw{mha-dbedit mha-dbrecover mha-decode mhonarc},
    qw{admin/mhaadmin.cgi extras/mha-mhedit/mha-mhedit};
$test->all_files_ok(qw{contrib examples lib});

done_testing();

