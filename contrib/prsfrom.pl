#!/net/nf/bin/perl
#$Id: prsfrom.pl 1.2 1998/01/21 12:09:26 aburgers Exp aburgers $
# parse command-line arguments

require('getopt.pl');&Getopt('o');

# print a help message

if ($opt_h) {
	print <<HELP;exit;
usage:
	$0 -h
	$0 [-o output_mailbox] [input_mailbox]

mhonarc extracts the date from a message from Date: or Received:
fields from the message-header. The sender is extracted from a From:
field. There are several cases when these fields are missing ( e.g.
out-boxes of Eudora, DEC-mailx). In all these cases it is possible to
extract the sender and the date from the message separator line.

$0 checks messages in mailbox input_mailbox (or standard input if
input_mailbox is not specified) for the presence of Date:, Received:
and From: fields.  If information is missing $0 attempts to construct
these fields from the message separator.  $0 assumes the message are
separated by a line of the following form.

>From sender date

The new Date: and From: fields are written
directly after the message separator. A new mailbox is written to
standard output or the file specified with the -o option. If the -o
option is used some statistics are reported to standard output.
HELP
}

# open output-file

if ($opt_o) {
	open(OUT,">$opt_o") || die "Error opening file $opt_o\n";
	select OUT;
}

$msg = 0;
$inheader=0;
$date_found = 0;
$received_found = 0;
$from_found = 0;

# method
#
# The message header is assumed to start at a line starting with /^From /
# and end at the next blank line.
# The sender and the date are extracted from the /^From / line. The
# lines of the header are stored in array @headerlines and checked
# for the presence of Date:, Received: and From: fields.
#
# $inheader=1 means we are processing a header
# $inheader=0 means we are outside the a header

while (<>) {
	if ($inheader) { # process message-header
		push(@headerlines,$_);
		study;
		if      (/^date:/i) { 		# check for date field
			$date_found = 1;
		} elsif (/^received:/i) {	# check for received field
			$received_found = 1;
		} elsif (/^from:/i) {		# check for from field
			$from_found = 1;
		} elsif (/^\s*$/) {		# blank line ending header
			unless($date_found || $received_found) {
				if ($date) {
					print "Date: $date\n";
					$print_date++;
				} else {
					warn "No date in From field\n";
				}
			}
			unless($from_found) {
				if ($adress) {
					print "From: $adress\n";
					$print_from++;
				} else {
					warn "No adress in From field\n";
				}
			}

			# Copy header to new mailbox

			for $line (@headerlines) {
				print $line;
			}

			# Reset counters

			$inheader = 0;
			undef @headerlines;
			$date_found = 0;
			$received_found = 0;
			$from_found = 0;
		}
	}
	else { # process message-body and message separator
		if (/^From /) { #test for message-header
			($dum,$adress,$date) = split(' ',$_,3);
			$date   =~ s/\s*$//;
			$adress =~ s/\s*$//;
			$inheader = 1;
			$msg++;
		}
		print;
	}
}

# print statistics

if ($opt_o) {
	select STDOUT;
	print "Total number of messages found: $msg\n";
	print "Added a Date field to $print_date messages\n" if ($print_date);
	print "Added a From field to $print_from messages\n" if ($print_from);
}

__END__

=head1 NAME

B<prsfrom> - supply missing Date: and From: fields to mailboxes

=head1 SYNOPSIS

B<prsfrom> [B<-o> F<output_mailbox>] [F<input_mailbox>]

B<prsfrom> [B<-h>]

=head1 DESCRIPTION

B<prsfrom> is a tool meant to be used in conjunction with B<mhonarc>.
B<mhonarc> extracts the date from a message from Date: or Received:
fields from the message-header. The sender is extracted from a From:
field. There are several cases when these fields are missing ( e.g.
out-boxes of Eudora, DEC-mailx). In all these cases it is possible to
extract the sender and the date from the message separator line.

B<prsfrom> checks messages in mailbox F<input_mailbox> (or standard input
if F<input_mailbox> is not specified) for the presence of Date:,
Received:  and From: fields. If information is missing B<prsfrom>
attempts to construct these fields from the message separator.
B<prsfrom> assumes the message are separated by a line of the following
form.

>From sender date

The new Date: and From: fields are written directly after the message
separator. A new mailbox is written to standard output or the file
specified with the -o option. If the -o option is used some statistics
are reported to standard output.

If the -h option is specified a usage summary is written to standard
output.

=head2 Options

=over

=item B<-h>

A usage summary is written to standard output. No further processing is
done

=item B<-o> F<output_mailbox>

Default the new mailbox is written to standard output. With the
-o option a file to receive the new mailbox can be specified.
If the -o option is specified, some statistics are written
to standard output.

=back

=head1 RESTRICTIONS

B<prsfrom> also changes the headers of message in
mailboxes included as attachments in other message.

=head1 RETURN VALUE

The return value of B<prsfrom> is always 0

=head1 SEE ALSO

=for html
See the <a href="http://www.oac.uci.edu/indiv/ehood/mhonarc.html">mhonarc home-page</a>.

=head1 AUTHOR

=begin latex

A.R. Burgers\\
Netherlands Energy Research Foundation ECN\\
P.O. Box 1, 1755 ZG Petten, The Netherlands\\
e-mail: burgers@ecn.nl

=end latex

=for text
 A.R. Burgers
 Netherlands Energy Research Foundation ECN
 P.O. Box 1, 1755 ZG Petten, The Netherlands
 e-mail: burgers@ecn.nl

=for html
A.R. Burgers <br>
Netherlands Energy Research Foundation ECN <br>
P.O. Box 1, 1755 ZG Petten, The Netherlands <br>
e-mail: <a href="mailto:burgers@ecn.nl">burgers@ecn.nl </a>
