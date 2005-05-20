#!/usr/bin/perl
##---------------------------------------------------------------------------##
##  File:
##      mhn2mbox
##  Version:
##      0.38 Nov 28 12:36:27 EST 2002
##  Author:
##      Anthony W       anthonyw@albany.net
##  Description:
##      A utility for converting MHonArc html archives into pseudo mbox
##      format.
##  Usage:
##      mhn2mbox /path/to/mhonarc/archives [ your-output-file ]
##
##---------------------------------------------------------------------------##
##    Copyright (C) 2000        AnthonyW anthonyw@albany.net
##
##    This program is free software; you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation; either version 2 of the License, or
##    (at your option) any later version.
##
##    This program is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.
##
##    You should have received a copy of the GNU General Public License
##    along with this program; if not, write to the Free Software
##    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
##    02111-1307, USA
##---------------------------------------------------------------------------##

# Library where MHonArc libs
# are located. CHANGE THIS TO MATCH YOUR SITE
use lib '/usr/lib/perl5/site_perl/5.6.0'; 

use HTML::Entities;
require 'mhamain.pl';
require 'base64.pl';
use strict;

my $NoArgs = 1;
my $USAGE		= "Usage: $0 html_dir [output_file]\n";
my $HTML_DIR            = shift || die $USAGE ;
my $OUTPUT_FILE         = shift || '-';      # write to STDOUT by default
my $debug               = $ENV{'CMD_DEBUG'};

print STDERR "HTML_DIR=$HTML_DIR\n" if $debug;


MAIN: {

  mhonarc::initialize();
  #mhonarc::get_resources();
  print STDERR "MHonArc initialized.\n"  if $debug;
  require 'ewhutil.pl';
  require 'mhtime.pl';
  require 'mhutil.pl';

  local(*DIR);

  print STDERR "Reading $HTML_DIR.\n"  if $debug;
  opendir(DIR, $HTML_DIR) || die qq/Unable to open "$HTML_DIR": $!/;
  my @files = grep(/^msg/i, readdir(DIR));
  closedir(DIR);

  open (MBOXFILE,">$OUTPUT_FILE") || die qq/Unable to open "$OUTPUT_FILE": $!/;

  foreach (sort @files) {
      my $name = "$HTML_DIR/" . $_ ;
      print STDERR "working on: $name\n" if $debug;
      &load_data($name);
      print MBOXFILE "\n\n";     # sometimes necessary to seperate messages
  } 

  close (MBOXFILE);
}

##---------------------------------------------------------------------------##
##      load_data: Function to read information from the headers of the html
## files produced by mhonarc. Adapted from mhmsgfile.pl
##
sub load_data {

    my $addendum = my $contype = my $index = my $datestr = ""; 
    my $from_addr = my $email_addr = my $binfile = ""; 
    my $description = my $docname = my $boundary = "";
    my $filename = shift;       # Name of file to read
    local(*MSGFILE);
    my @Derived = ();
    my @bodytext = ();
    my @array = ();

    if (!open(MSGFILE, $filename)) {
        warn qq/Warning: Unable to open "$filename": $!\n/;
        return 0;
    }
    my $href = parse_data(\*MSGFILE); 
    close(MSGFILE);

    my $date = $href->{'date'}[0];

# $day[$wday].', '.$d2[$mday].' '.$month[$mon].' '.($year+1900).' '.$d2[$hour].':'.$d2[$min].':'.$d2[$sec].' GMT';

    ## Determine date of message
    if (($date =~ /\S/) && (@array = mhonarc::parse_date($date))) {
        $index = mhonarc::get_time_from_date(@array[1..$#array]);
    } else {
        $index = time;
        $date  = mhonarc::time2str("", $index, 1)  unless $date =~ /\S/;
    }                            

    if (defined($href->{'from-r13'})) {
       $from_addr = mhonarc::mrot13($href->{'from-r13'}[0]);
       $email_addr = &extract_email_address($from_addr); 
       #$email_addr = mhonarc::extract_email_address($from_addr); 
       print MBOXFILE "From $email_addr $date\n"; 
       print MBOXFILE "From: $from_addr\n"; 
    } elsif (defined($href->{'from'})) {
       $from_addr = $href->{'from'}[0];
       $email_addr = &extract_email_address($from_addr); 
       #$email_addr = mhonarc::extract_email_address($from_addr); 
       print MBOXFILE "From $email_addr $date\n"; 
       print MBOXFILE "From: $from_addr\n"; 
    } else {
       print STDERR "WARNING: From Anonymous\n" if $debug;
       $from_addr = 'Anonymous';
       $email_addr = mhonarc::extract_email_address($from_addr); 
       print MBOXFILE "From $email_addr $date\n"; 
       print MBOXFILE "From: $from_addr\n"; 
    }

    print MBOXFILE "Date: $date\n";

    if (defined($href->{'msgtoheader'})) {
       print MBOXFILE "To: $href->{'msgtoheader'}[0]\n";
    }
    if (defined($href->{'subject'})) {
       print MBOXFILE "Subject: $href->{'subject'}[0]\n";
    }

    if (defined($href->{'reference'})) {
       print MBOXFILE "In-Reply-To: <$href->{'reference'}[0]>\n";
    }

    if (defined($href->{'message-id'})) {
       print MBOXFILE "Message-ID: <$href->{'message-id'}[0]>\n";
    }

    print MBOXFILE "MIME-Version: 1.0\n";
 
    if (defined($href->{'content-type'})) {
       $contype = $href->{'content-type'}[0];
    } elsif (defined($href->{'contenttype'})) {         # older versions
       $contype = $href->{'contenttype'}[0];
    }
    
    if (defined($href->{'msgbodytext'})) {
      push(@bodytext, @{$href->{'msgbodytext'}}) ;
    }

    if ($contype =~ /multipart/i ) {
         $boundary = join("", $$,'.',time,'.',$contype);

         if (defined($href->{'derived'})) {

            print MBOXFILE "Content-Type: $contype; boundary=\"Boundary..$boundary\"\n";
            push (@Derived, @{$href->{'derived'}});   
            print STDERR "Attachments: ",join(',',@Derived),"\n" if $debug;
            pop (@bodytext);

            foreach $binfile (reverse @Derived) {
                $description =  pop(@bodytext);
                $docname =  $binfile;
                $addendum .= "\n--Boundary..$boundary\n"; 
                $addendum .= "Content-Type: application\/octet-stream\; name=\"$docname\"\n";
                $addendum .= "Content-Transfer-Encoding: base64\n";
                $addendum .= "Content-Disposition: attachment\; filename=\"$docname\"\n";
                $addendum .= "Content-Description: \"$description\"\n\n";
                $addendum .= join("", mime_encode("$HTML_DIR/$binfile"));
            }
 
            print MBOXFILE "\n--Boundary..$boundary\n"; 
            print MBOXFILE "Content-Type: text/plain\n";
            print MBOXFILE "Content-Transfer-Encoding: 7bit\n";
            print MBOXFILE join("\n", @bodytext); 
            print MBOXFILE "\n"; 
            print MBOXFILE "$addendum";
            print MBOXFILE "--Boundary..$boundary--\n\n"; 
 
         } else {

            print MBOXFILE "Content-Type: text\/plain\n";
            print MBOXFILE join("\n", @bodytext); 

         }
    } else {

       print MBOXFILE "Content-Type: $contype\n\n";
       print MBOXFILE join("\n", @bodytext); 

    }
}

##---------------------------------------------------------------------------##
##      parse_data(): Function to parse the initial comment
##      declarations of a MHonArc message file into a hash.  A refernce
##      to resulting hash is returned.  Keys are the field names, and
##      values are arrays of field values. Adapted from mhmsgfile.pl
##
sub parse_data {
    my $fh = shift;     # An open filehandle
    my $start = "true";
    my $head = "false";
    my $subj = "false";
    my $tail = "false"; 
    my $body = "false";
    my ($field, $value);
    my $AddrExp = '[^()<>@,;:\/\s"\'&|]+@[^()<>@,;:\/\s"\'&|]+';
    my %field = ();
    local($_);
   
    while (<$fh>) {

       if (/^<!--X-Head-End-->/) { 
          $start = "false"; next; 
       }
       if (/^<!--X-Head-of-Message/) { 
          $head = "true"; next; 
       }
       if (/^<!--X-Body-Begin-->/) {
          $subj = "true"; 
       }
       if (/^<!--X-Body-of-Message/) {
          last if s/^<!--X-Body-of-Message-End// ;
          $body = "true"; $head = "false"; next;
       } 
       if ($start eq "true") { 
          next unless s/^<!--X-//;     # Skip non-field lines
          chomp;
          s/ -->$//;
          s/<a(.*?)href="(.*)"(.*?)>(.*)<\/a>/$7/ig;
          s/&lt;/</g;
          s/&gt;/>/g;
          s/&quot;/"/g;
          ($field, $value) = split(/: /, $_, 2);
          push(@{$field{lc $field}}, mhonarc::uncommentize($value));
          next;
       }
       if ($head eq "true") { 
          if (/^<li><em>To<.*?>:/i) {
              s/<\/li>//ig;
              s/<\/ul>//ig;
              s/<a( |  )href="(.*)">(.*)<\/a>/$3/ig;
              s/&lt;/</g;
              s/&gt;/>/g;
              s/&quot;/"/g;
              chomp;
              ($field, $value) = split(/: /, $_, 2);
              $field = "msgtoheader";
              push(@{$field{lc $field}}, $value);
              $head = "false" ;
          }
          next;
       } 
       if ($body eq "true") { 
         # Extract URLs
          chomp;
          next if /<!--X-Body-of-Message-->/;
          next if /^<(.*?)ul>$/i;
          
          $_=decode_html($_);
          
          s/<a(.*?)href="(.*)"(.*?)>(.*)<\/a>/$4/ig ; 
          $field = "msgbodytext";
          $value = $_ ; 
          chomp;
          push(@{$field{lc $field}}, $value);
          next;
       }
    }
    \%field;
}

##---------------------------------------------------------------------------##
##  subroutine to base64 encode a file
##---------------------------------------------------------------------------##

sub mime_encode
{
  my $file = shift ;
  my @encoded_data = ();
     local $/; # enable data slurp
     open (MMENCODE, "$file");
     print STDERR "MIME-encoding: $file\n" if $debug;
     @encoded_data = base64::b64encode(<MMENCODE>) ;
     close MMENCODE;
     return @encoded_data;
}

##---------------------------------------------------------------------------##
## Subroutine to remove html tags from a string
##---------------------------------------------------------------------------##
sub decode_html {

        s/<[^>]*>//gs;  # from page 716 of the "Perl Cookbook"
        $_=decode_entities($_);
        return $_;
}

##---------------------------------------------------------------------------##
## Subroutine to extract email addresses. Taken from mhutil.pl
##---------------------------------------------------------------------------##
sub extract_email_address {

    ##  Regexp for address/msg-id detection (looks like cussing in cartoons)
    my $AddrExp = '[^()<>@,;:\/\s"\'&|]+@[^()<>@,;:\/\s"\'&|]+';
    return ''  unless defined $_[0];
    my $str = shift;

    if ($str =~ /($AddrExp)/o) {
        return $1;
    }
    if ($str =~ /<(\S+)>/) {
        return $1;
    }
    if ($str =~ s/\([^\)]+\)//) {
        $str =~ /\s*(\S+)\s*/;
        return $1;
    }
    $str =~ /\s*(\S+)\s*/;
    return $1;
}

##---------------------------------------------------------------------------##

1;
