##---------------------------------------------------------------------------##
##  File:
##      $Id: mhscan.pl,v 1.3 2001/09/17 16:10:37 ehood Exp $
##  Author:
##      Earl Hood       mhonarc@mhonarc.org
##  Description:
##      Scan routine for MHonArc
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
##	Function to do scan feature.
##
sub scan {
    local (
        $key,  $num,  $index,   $day,  $mon, $year,
        $from, $date, $subject, $time, @array
    );

    print STDOUT "$NumOfMsgs messages in $OUTDIR:\n\n";
    print STDOUT sprintf("%5s  %s  %-15s  %-43s\n",
        "Msg #", "YYYY/MM/DD", "From", "Subject");
    print STDOUT sprintf("%5s  %s  %-15s  %-43s\n",
        "-" x 5, "----------", "-" x 15, "-" x 43);

    @array = &sort_messages();
    foreach $index (@array) {
        $date    = &time2mmddyy((split(/$X/o, $index))[0], 'yyyymmdd');
        $num     = $IndexNum{$index};
        $from    = substr(&extract_email_name($From{$index}), 0, 15);
        $subject = substr($Subject{$index}, 0, 43);
        print STDOUT
            sprintf("%5d  %s  %-15s  %-43s\n", $num, $date, $from, $subject);
    }
}

##---------------------------------------------------------------------------
1;
