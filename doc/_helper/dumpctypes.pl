#!/usr/local/bin/perl

unshift(@INC, "../../lib");
require "mhmimetypes.pl";
mhonarc::dump_ctext_hash();
