#!/usr/bin/perl

# $Id: mhastart.pl,v 1.22 2003/01/25 20:24:17 Gunnar Hjalmarsson Exp $

=head1 NAME

mhastart.pl - Help script for the MHonArc Email-to-HTML converter

=head1 DESCRIPTION

This script, written in Perl, provides some help when using B<MHonArc>
E<lt>http://www.mhonarc.org/E<gt>. It's particularly useful if you run MHonArc
on a shared web server without shell access.

By means of C<mhastart.pl> you can invoke MHonArc from a browser, or let a mailing
list archive be updated automatically.

The script presupposes that the raw email messages are stored in mbox format.
It can be renamed to whatever you like, as long as the server understands that
it is a CGI script that shall be executed. A number of configuration variables
need to be set before running C<mhastart.pl>.

=cut

use strict;
my ($name, $mhonarc, $lib, $archive, $mbox, $mrc, $indexURL, $errordir, $adminpw, $encrypt,
    $msgpw, $msgmaxsize, $pop3, $pophost, $user, $password, %in, $scriptname, $wrongpw);

BEGIN	{
    if ($ENV{'HTTP_USER_AGENT'} and $ENV{'HTTP_USER_AGENT'} !~ /^libwww-perl/
      and $ENV{'QUERY_STRING'} ne 'update') {
        require CGI::Carp;
        errordir();
        if ($errordir and $errordir ne '') {
            import CGI::Carp 'carpout';
            open (LOG, ">>$errordir/ERRORLOG.TXT") or
              exit (print "Content-type: text/html\n\n", "<h1>Error</h1>\n",
                          "<pre>Couldn't open $errordir/ERRORLOG.TXT\n$!");
            carpout(\*LOG);
        } else {
            unless (eval { CGI::Carp -> VERSION(1.20) }) {
                # previous versions don't handle eval properly with fatalsToBrowser
                exit (print "Content-type: text/html\n\n", "<h1>Error</h1>\n<tt>", $@,
                            '<p>You should either upgrade to v1.20 or higher, or ',
                            "use the 'carpout' routine by setting the \$errordir ",
                            'configuration variable.');
            }
            import CGI::Carp 'fatalsToBrowser';
        }
    }
    sub errordir {

##---------------------------------------------------------------------------

# Configuration variables
# =======================

## Path to directory to which error messages will be redirected
#  If this variable is empty, fatal error messages will be echoed to the
#  browser window instead.
$errordir = '';

}}  # BEGIN block ends here

## Name of archive
$name = "Demo Mail Archive";

## Path to MHonArc program directory
$mhonarc = '/www/htdocs/gunnar/cgi-bin/mhonarc';

## Path to MHonArc library
$lib = $mhonarc.'/lib';

## Path to archive directory
$archive = '/www/htdocs/gunnar/mhonarc/demo';

## Path to mbox file
$mbox = $mhonarc.'/mbox/demo';

## Path to resource file
$mrc = $mhonarc.'/demo.mrc';

## Full URL to main index file
$indexURL = 'http://www.gunnar.cc/mhonarc/demo/maillist.html';

## Admin password (to access the Admin menu)
#  Note: If you are able to set up HTTP authentication via the server, it's
#  advisable that you do so. In that case you should comment out the following
#  line.
$adminpw = 'PASSWORD';

## Enable if $adminpw is encrypted (basic auth)
$encrypt = 0;       # 1 = enabled, 0 = disabled

## Password for passing a message to this script
#  The password is presupposed to be a string on a separate line, preceeding
#  the message's "From " line. If you want to pipe incoming messages directly
#  to this script, for instance via a .forward file, you need to disable this
#  password check by commenting out the following line.
$msgpw = 'abc';

## Max size for a message to pass to this script
$msgmaxsize = 100;  # KiB (kibibytes, i.e. bytes / 1,024)

## Update $mbox from pop account (requires the Net::POP3 module)
#  Note: If the script shall be used to process forwarded messages, this
#  variable must be disabled.
$pop3 = 0;          # 1 = enabled, 0 = disabled

## Set if $pop3 is enabled
$pophost  = 'pop.domain.com';
$user     = 'abc';
$password = 'xyz';

##---------------------------------------------------------------------------

=head2 Control MHonArc from a browser

If you call C<mhastart.pl> from a browser, and after having entered a
password, you end up at a page that allows you to execute MHonArc commands.
If you just wish to add or remove messages, there are a couple of buttons
that don't require all the arguments to be entered.

When adding messages, and if C<$pop3> is enabled, the script automatically
grabs the messages (if any) from the POP account, and adds them to the mbox
file, before MHonArc is invoked.

=head2 Automatic update

You can also pipe messages directly to C<mhastart.pl>, and let it update
your mbox file and archive instantly each time a message arrives. Optionally,
if the messages arrive on another server, you can pass them to this script
through a HTTP request from a script on the other server.

If you collect messages from a mailing list on a POP account, you can
instead update the archive by invoking this script via cron.

=head2 Refresh link

If you use a POP account, but do not let cron invoke the script automatically,
you can place a link to C<mhastart.pl> on e.g. the main index page with the
query string C<?update> appended to the URL. When clicking the link, the
script grabs messages from the POP account, adds them to the mbox file and
the archive, and loads the updated main index page.

=head1 DEMO

A demo installation of C<mhastart.pl> is available at
http://www.gunnar.cc/cgi-bin/mhonarc/mhastart.pl (password: C<demo>). Feel
free to send a test message to mhatest@gunnar.cc and add it to the archive.

=head1 EXAMPLES

=head2 Setting up a mailing list archive

This is how a basic MHonArc archiving of a mailing list can be set up by
means of C<mhastart.pl>:

=over 4

=item *

Upload the four MHonArc program files (C<mhonarc> and C<mha-d*>) and the
C<lib> directory to a directory designated for MHonArc, for instance
C</cgi-bin/mhonarc> (no editing of any MHonArc files is necessary).

=item *

Upload a resource file to the MHonArc directory. It can be empty to start with.

=item *

Upload an empty file, for instance in a separate sub-directory to the MHonArc
directory, in which the raw messages will be stored in mbox format.

=item *

Create a directory for the archive that is readable from the web.

=item *

Ensure that CGI scripts have write access to the archive directory and the mbox
file.

=item *

Create a POP account, and subscribe the email address to that account to the
mailing list.

=item *

Set the configuration variables in C<mhastart.pl>, upload the script (in ASCII
transfer mode), and make it executable (typically chmod 755).

=back

That's basically it. Now, when new messages arrive to the POP account, you can
easily add them to the mbox file and the archive.

To make use of MHonArc's extensive possibilities to customize the layout of your
archive, you need to study the MHonArc documentation.

=head2 Forwarding

By forwarding incoming messages to C<mhastart.pl>, you can make them update the
archive instantly. One way to do it is through a C<.forward> file as described
at E<lt>http://www.mhonarc.org/MHonArc/doc/faq/archives.html#forwardE<gt>,
replacing C<webnewmail> with C<mhastart.pl>. If you don't have root access to
the server, you will likely need to ask your web host to create the forward.

I'm maintaining a MHonArc archive on a server without email service. In that
case, I'm forwarding incoming (to another server) email to a first script,
which sends the messages to C<mhastart.pl> as HTTP requests. The supplementary
script is available at E<lt>http://www.gunnar.cc/mhonarc/mailfwd.pl.txtE<gt>.
Before sending a message, that script appends a password, and the subsequent
password check prevents C<mhastart.pl> from updating the archive with
arbitrary messages.

=head1 LATEST VERSION

The latest version of C<mhastart.pl> is available at:
http://www.gunnar.cc/mhonarc/mhastart.pl.txt

=head1 QUESTIONS / BUGS

For questions or bug reports regarding this help script, please use the
MHonArc Users mailing list:
http://www.mhonarc.org/MHonArc/doc/contacts.html#mailinglist

=head1 AUTHOR

  Copyright © 2002-2003 Gunnar Hjalmarsson
  http://www.gunnar.cc/cgi-bin/contact.pl

This script is free software and is provided "as is" without express or
implied warranty. It may be used, redistributed and/or modified under the
terms of the GNU GPL Licence E<lt>http://www.gnu.org/licenses/gpl.htmlE<gt>.

=cut

checkpath();
$in{'pw'} = $in{'routine'} = '';         # prevents "uninitialized" warnings
unshift (@INC, $lib);
($scriptname = $0 ? $0 : $ENV{'SCRIPT_FILENAME'}) =~ s/.*[\/\\]//;

if (!$ENV{'HTTP_USER_AGENT'}) {                        #
    exit (autoupdate(''));                             # if not invoked from a browser
} elsif ($ENV{'HTTP_USER_AGENT'} =~ /^libwww-perl/) {  #
    exit (autoupdate('fwd'));
}

if ($ENV{'QUERY_STRING'} eq 'update') {  # intended for update via hyperlink
    exit (refresh());                    # on the main index page
}

readinput();
if (defined $adminpw and $adminpw ne '') {
    die "You need to set some other password than \"PASSWORD\".\n" if $adminpw eq 'PASSWORD';
    exit (print loginpage()) unless checkpw();
}

if    (!$in{'routine'})                        { print frames() }
elsif ($in{'routine'} eq 'forms')              { print forms() }
elsif ($in{'routine'} eq 'adminstart')         { print adminstart() }
elsif ($in{'routine'} eq 'add')                { add() }
elsif ($in{'routine'} eq 'Remove')             { remove() }
elsif ($in{'routine'} eq 'Remove latest msg')  { remove_mbox() }
elsif ($in{'routine'} eq 'shell')              { shell() }
else {
    print "Content-type: text/html\n\n", 'Incorrect routine value!';
}

##---------------------------------------------------------------------------

sub checkpath {
    die "Variable \$mhonarc: $mhonarc is not a directory.\n" unless -d $mhonarc;
    die "Variable \$lib: $lib is not a directory.\n" unless -d $lib;
    die "Variable \$archive: $archive is not a directory.\n" unless -d $archive;
    die "Variable \$archive: I don't have write access to $archive.\n"
        unless -r $archive and -w _ and -x _;
    die "Variable \$mbox: $mbox is not a file.\n" unless -f $mbox;
    die "Variable \$mbox: I don't have write access to $mbox.\n" unless -r $mbox and -w _;
    die "Variable \$mrc: $mrc is not a file.\n" unless -f $mrc;
}

sub autoupdate {
    my $fwd = shift;
    my $size = $ENV{'CONTENT_LENGTH'} ? $ENV{'CONTENT_LENGTH'} : (stat(STDIN))[7];
    if ($pop3) {
        if ($size) {
            exit (print "Status: 403 Script Config Obstacle\n\n") if $fwd eq 'fwd';
            print "Requested action aborted:\n",
                  "$scriptname is not configured to process messages directly.\n\n";
        } else {
            updatearchive ('-add', '-quiet') if popretrieve();  # for invoking via cron
        }                                                       # (or the command line)
    } else {
        $size = sprintf ("%.f", $size / 1024);
        unless ($size > $msgmaxsize) {
            my $newmail = join ('', <STDIN>);     # grabs message, that was passed to this
            $newmail =~ s/^(.+)\r?\n(From )/$2/;  # script, for instant update of the archive
            my $pw = $1 ? $1 : '';
            if (defined $msgpw and $pw ne $msgpw) {
                exit (print "Status: 403 Password Check Failed\n\n") if $fwd eq 'fwd';
                print "Requested action aborted:\nPassword check failed\n\n";
            } elsif ($newmail =~ /^From /) {
                updatembox (\$newmail);
                updatearchive ('-add', '-quiet');
                print "Status: 204 No Content\n\n" if $fwd eq 'fwd';
            } else {
                die 'Unexpected request; no action taken';
            }
        } else {
            exit (print "Status: 413 Message Too Large\n\n") if $fwd eq 'fwd';
            print "Requested action aborted:\n",
                  "The message size ($size KiB) exceeds the maximum size\n",
                  "($msgmaxsize KiB) as specified in $scriptname.\n\n";
        }
    }
}

sub refresh {
    popretrieve() if $pop3;
    updatearchive ('-add', '-quiet');
    print "Location: $indexURL\n\n";       # loads the updated main index page
}

sub readinput {
    my $in = my $name = my $value = '';
    if ($ENV{'REQUEST_METHOD'} eq 'POST')	{
        read (STDIN, $in, $ENV{'CONTENT_LENGTH'});
    } else {
        $in = $ENV{'QUERY_STRING'};
    }
    $in =~ s/\+/ /g;
    for (split (/[&;]/, $in)) {
        ($name, $value) = split(/=/);
        $value =~ s/%(..)/pack("c",hex($1))/ge if $value;
        $in{$name} = $value;
    }
}

sub checkpw {
    my $result;
    $wrongpw = '';
    (my $cookiename = $name) =~ s/\W/_/g;
    if ($ENV{'HTTP_COOKIE'}) {
        for (split (/; /, $ENV{'HTTP_COOKIE'})) {
            my ($key, $val) = split (/=/, $_);
            if ($key eq $cookiename) {
                $result = $val eq $adminpw ? 1 : 0;
                last;
            }
        }
    }
    unless ($result) {
        if ($in{'pw'}) {
            my $pw = $encrypt ? crypt ($in{'pw'}, $adminpw) : $in{'pw'};
            print "Set-cookie: $cookiename=$pw\n";
            if ($pw eq $adminpw) {
                $result = 1;
            } else {
                $wrongpw = '<h4 style="color: #cc3300; background: none; font-family: '
                          ."arial, helvetica, sans-serif\">Incorrect password!</h4>\n";
            }
        } elsif ($in{'routine'} eq 'forms') {
            exit (print "Content-type: text/html\n\n",
                        "Your browser is set to refuse cookies.<br />Change that\n",
                        'setting to accept at least session cookies, and try again.');
        } elsif ($in{'routine'}) {
            exit (print "Content-type: text/html\n\n&nbsp;");
        }
    }
    return $result;
}

sub loginpage {
    return htmlbegin(), qq|<title>Login to $name - Admin</title>
</head>
<body><center><h3>Login to $name - Admin</h3>
$wrongpw<p>Enter password:</p>
<form action="$scriptname" method="post">
<input type="password" class="text" name="pw" /><br />
<input style="margin-top: 12px" type="submit" value="Log in" />
</form>
</center></body>
</html>|;
}

sub frames	{
    return "Content-type: text/html\n\n", qq|<html>
<head><title>$name - Admin</title></head>
<frameset rows="190,*">
<frame name="forms" src="$scriptname?routine=forms" scrolling="no">
<frame name="output" src="$scriptname?routine=adminstart"
  marginwidth="30" marginheight="10">
</frameset>
</html>|;
}

sub htmlbegin {
    return "Content-type: text/html\n\n", qq|<html>
<head>
<style type="text/css">
    body { background: white; color: black }
    p,td { font-family: arial, helvetica, sans-serif; font-size: 10pt }
    tt,input.text { font-family: 'courier new', monospace; font-size: 10pt }
    td tt { color: #000099 }
    h3 { font-family: arial, helvetica, sans-serif; color: #000099; background: none }
    .top { vertical-align: top }
    .small { font-size: 8pt; text-align: center; vertical-align: top }
    a         { color: #000099; background: none }
    a:visited { color: #000099; background: none }
    a:active  { color: #cc3300; background: none }
    a:hover   { color: #cc3300; background: none }
</style>
|;
}

sub forms {
    return htmlbegin(), qq|</head>
<body><center>
<h3>$name - Admin</h3>
<table border="1"><tr><td class="top">
    <table><form action="$scriptname" target="output" method="post">
    <tr>
    <td><b>Add<br />message(s)</b></td>
    </tr>
    <tr>
    <td style="text-align: center"><input type="hidden" name="routine" value="add" />
    <input type="submit" value="  Add  " /></td>
    </tr>
    </form></table>
</td><td class="top">
    <table><form action="$scriptname" target="output" method="post">
    <tr>
    <td><b>Remove message(s)</b></td>
    </tr>
    <tr>
    <td>From archive (msg #):<br />
    <input type="text" class="text" name="msgnumber" size="8" />
    <input type="submit" name="routine" value="Remove" /></td>
    </tr>
    <tr>
    <td>From mailbox file:<br />
    <input type="submit" name="routine" value="Remove latest msg" /></td>
    </tr>
    </form></table>
</td><td>
    <table><form action="$scriptname" target="output" method="post">
    <tr>
    <td><b>Other MHonArc<br />command</b></td>
    <td class="top"><input type="submit" value="Submit" /></td>
    <td class="top"><a href="http://www.mhonarc.org/MHonArc/doc/"
      target="doc">MHonArc doc.</a></td>
    <td class="top"><a href="$indexURL" target="archive">Main Index</a></td>
    </tr>
    <tr>
    <td colspan="4"><input type="text" class="text" name="command" size="40" />
    <input type="hidden" name="routine" value="shell" /></td>
    </tr>
    <tr><td colspan="4">
        <table width="100%" cellpadding="0" cellspacing="0" border="0"><tr>
        <td class="small">Path to resource file:<br /><tt>\$mrc</tt></td>
        <td class="small">Path to archive<br />directory:<br /><tt>\$archive</tt></td>
        <td class="small">Path to mailbox file:<br /><tt>\$mbox</tt></td>
        </tr></table>
    </td></tr>
    </form></table>
</td></tr></table>
</center></body></html>|;
}

sub adminstart {
    return "Content-type: text/html\n\n<pre>", '<b>Output will appear here</b>';
}

sub add {
    print "Content-type: text/html\n\n<pre>", "<b>Add messages to $name</b>\n\n";
    popretrieve() if $pop3;
    updatearchive ('-add');
}

sub remove {
    print "Content-type: text/html\n\n<pre>", "<b>Remove messages from $name</b>\n\n";
    updatearchive ('-rmm', $in{'msgnumber'});
}

sub remove_mbox {
    my @msgs = read_mbox ($mbox);
    my $deleted = $mbox . '_deleted';
    my $latestmsg = pop @msgs;

    open (FILE, ">>$deleted") or die "Couldn't open $deleted\n$!";
    flock (FILE, 2);
    print FILE @$latestmsg;
    close (FILE);

    open (FILE, ">$mbox") or die "Couldn't open $mbox\n$!";
    flock (FILE, 2);
    for (@msgs) { print FILE @$_ }
    close (FILE);

    print "Content-type: text/html\n\n<pre>", "<b>Remove raw messages from $name</b>\n\n",
          "The latest message was removed from $mbox\nand appended to $deleted.\n\n",
          'The mailbox file now includes ', scalar @msgs, ' message',
          (scalar @msgs == 1 ? '.' : 's.');
}

sub shell {
    my $checkpop;
    require 'shellwords.pl';
    @ARGV = shellwords ($in{'command'});  # the list of entered options is assigned
    my $command = shift @ARGV;            # to @ARGV, and with that passed to MHonArc
    for my $element (@ARGV)	{
        if    ($element eq '$archive') { $element = $archive }
        elsif ($element eq '$mbox')    { $element = $mbox }
        elsif ($element eq '$mrc')     { $element = $mrc }
        elsif ($element eq '-add')     { $checkpop = 1 }
    }
    print "Content-type: text/html\n\n<pre>";
    if ($command eq 'mhonarc' or $command =~ /^mha-d/) {
        print "<b>Command executed:</b>\n$command @ARGV\n\n<b>Output:</b>\n";
        popretrieve() if $pop3 and $checkpop;
        require "$mhonarc/$command" or die "Couldn't invoke $command\n$!";
    } else {
        print "That wasn't a MHonArc command, was it?";
    }
}

##---------------------------------------------------------------------------

sub updatembox {
    my $msgref = shift;
    open (FILE, ">>$mbox") or die "Couldn't open $mbox\n$!";
    flock (FILE, 2);
    print FILE ($pop3 ? join ('', @$msgref) : $$msgref) . "\n\n";
    close (FILE);
}

sub updatearchive {
    @ARGV = (@_, '-outdir', $archive);
    push (@ARGV, $mbox) unless $in{'routine'} eq 'remove';
    require 'mhamain.pl' or die "Couldn't require mhamain.pl\n$!";
    mhonarc::initialize();         # skipped the 'mhonarc' program file in
    mhonarc::process_input();      # order to avoid the ending exit call
}

sub popretrieve {
    require Net::POP3;
    my $pop = Net::POP3->new($pophost);
    my $cnt;

    POP: {
        $cnt = $pop->login ($user, $password);
        my $msgs = $pop->list();
        last POP unless $cnt > 0;

        my ($msg, $msgnum, $line, $list, $to, $subject, $tmp, $key, $aref, %header);

        ## Loop thru each message and append to $newmail
        foreach $msgnum (sort { $a <=> $b } keys %$msgs) {
            $msg = $pop->get ($msgnum);
            next unless defined $msg;

            ## Grab message header
            %header = ( );  $aref = undef;
            foreach $line (@$msg) {
                last if $line =~ /^$/;
                $tmp = $line; chomp $tmp;
                if ($tmp =~ s/^\s//)  {
                    next unless defined $aref;
                    $aref->[$#$aref] .= $tmp;
                    next;
                }
                if ($tmp =~ s/^([^:]+):\s*//) {
                    $key = lc $1;
                    if (defined ($header{$key})) { $aref = $header{$key} }
                    else                         { $aref = $header{$key} = [ ] }
                    push (@$aref, $tmp);
                    next;
                }
            }

            unshift (@$msg, 'From username@domain.com Sat Jan  1 00:00:00 2000');
            updatembox ($msg);
            $pop->delete ($msgnum);
        }
        $pop->quit();
        undef $pop;
        print "$cnt message".($cnt > 1 ? 's' : '')." from $user\@$pophost\n"
             ."appended to $mbox\n\n" if $in{'routine'} eq ('add' or 'shell');
    }
    $pop->quit() if defined $pop;
    return $cnt;
}

sub read_mbox {
# This subroutine returns a list of references, each of which is a
# reference to an array containing one message. The routine was copied
# from Mail::Util.pm v1.51, included in the CPAN library MailTools.
    my $file  = shift;
    my @mail  = ();
    my $mail  = [];
    my $blank = 1;
    local *FH;
    local $_;
    open(FH,"< $file") or die "Couldn't open '$file'\n$!";
    while(<FH>) {
        if($blank && /\AFrom .*\d{4}/) {
            push(@mail, $mail) if scalar(@{$mail});
            $mail = [ $_ ];
            $blank = 0;
        } else {
            $blank = m#\A\Z#o ? 1 : 0;
            push(@{$mail}, $_);
        }
    }
    push(@mail, $mail) if scalar(@{$mail});
    close(FH);
    return @mail;
}

