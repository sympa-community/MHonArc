##---------------------------------------------------------------------------##
##  File:
##      $Id: mhnote.pl,v 1.3 2001/09/17 16:10:26 ehood Exp $
##  Author:
##      Earl Hood       mhonarc@mhonarc.org
##  Description:
##      Annotation routine for MHonArc.
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1995-1999   Earl Hood, mhonarc@mhonarc.org
##
##    This program is free software: you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation, either version 2 of the License, or
##    (at your option) any later version.
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.
##
##    You should have received a copy of the GNU General Public License
##    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##---------------------------------------------------------------------------##

package mhonarc;

use strict;
use warnings;

##---------------------------------------------------------------------------
##	Function for annotating messages.
##
sub annotate {
    my $notetxt = pop(@_);    # last arg is note data

    my (@numbers) = ();
    my ($key, %Num2Index, $num, $i, $pg, $file);
    local ($_);

    ## Create list of messages to annotate
    foreach (@_) {
        # range
        if (/^(\d+)-(\d+)$/) {
            push(@numbers, $1 .. $2);    # range op removes leading zeros
            next;
        }
        # single number
        if (/^\d+$/) {
            push(@numbers, int($_));     # int() removes leading zeros
            next;
        }
        # probably message-id
        push(@numbers, $_);
    }

    if ($#numbers < 0) {
        warn("Warning: No messages specified\n");
        return 0;
    }

    ## Make hash to perform deletions
    foreach $key (keys %IndexNum) {
        $Num2Index{$IndexNum{$key}} = $key;
    }

    ## Define %Index2MLoc for determining min main index page update
    $i = 0;
    foreach $key (sort_messages()) {
        $Index2MLoc{$key} = $i++;
    }

    ## Make sure notes directory exists
    my $notedir = get_note_dir();
    if (!-d $notedir and !mkdir($notedir, 0777)) {
        warn qq/Warning: Unable to create "$notedir": $!\n/;
        return 0;
    }

    ## Annotate messages
    foreach $num (@numbers) {
        if ($key = $Num2Index{$num} || $MsgId{$num}) {

            ## write note to file
            $file = join($DIRSEP, $notedir,
                msgid_to_filename($Index2MsgId{$key}));
            if (!open(NOTEFILE, ">$file")) {
                warn qq/Warning: Unable to create "$file": $!\n/;
                next;
            }
            print NOTEFILE $notetxt;
            close NOTEFILE;

            ## flag message to be updated
            $Update{$IndexNum{$key}} = 1;

            ## mark where index page updates start
            if ($MULTIIDX) {
                $pg        = int($Index2MLoc{$key} / $IDXSIZE) + 1;
                $IdxMinPg  = $pg if ($pg < $IdxMinPg || $IdxMinPg < 0);
                $pg        = int($Index2TLoc{$key} / $IDXSIZE) + 1;
                $TIdxMinPg = $pg if ($pg < $TIdxMinPg || $TIdxMinPg < 0);
            }

            next;
        }

        # message not in archive
        warn qq/Warning: Message "$num" not in archive\n/;
    }

    ## Clear data that will get recomputed
    %Index2MLoc = ();

    write_pages();
    1;
}

##---------------------------------------------------------------------------##
1;
