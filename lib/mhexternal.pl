##---------------------------------------------------------------------------##
##  File:
##	@(#) mhexternal.pl 1.11 97/05/13 11:23:46 @(#)
##  Author:
##      Earl Hood       ehood@medusa.acs.uci.edu
##  Description:
##	Library defines a routine for MHonArc to filter content-types
##	that cannot be directly filtered into HTML, but a linked to an
##	external file.
##
##	Filter routine can be registered with the following:
##
##		<MIMEFILTERS>
##		*/*:m2h_external'filter:mhexternal.pl
##		</MIMEFILTERS>
##
##	Where '*/*' represents various content-types.  See code below for
##	all types supported.
##
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1995-1997	Earl Hood, ehood@medusa.acs.uci.edu
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
##    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
##---------------------------------------------------------------------------##

package m2h_external;

%ExtCnt = ();	# Array of filename counters for generated files
$UnknownExt	= 'bin';
$UnknownType	= 'Unrecognized Data';
$SubDir		= 0;

%CTExt = (
##-----------------------------------------------------------------------
##  Content-Type			Extension:Description
##-----------------------------------------------------------------------
    'application/astound',		'asd:Astound presentation',
    'application/fastman',		'lcc:fastman file',
    'application/mac-binhex40', 	'hqx:Mac BinHex file',
    'application/mbedlet',		'mbd:mbedlet file',
    'application/msword',		'doc:MS-Word document',
    'application/octet-stream', 	'bin:Binary data',
    'application/oda', 			'oda:ODA file',
    'application/pdf', 			'pdf:PDF file',
    'application/pgp',  		'pgp:PGP message',
    'application/pgp-signature',	'pgp:PGP signature',
    'application/postscript', 		'ps:PostScript document',
    'application/rtf', 			'rtf:RTF file',
    'application/sgml',			'sgml:SGML document',
    'application/studiom',		'smp:Studio M file',
    'application/timbuktu',		'tbt:timbuktu file',
    'application/vnd.ms-excel',         'xls:MS-Excel file',
    'application/vnd.ms-powerpoint',    'ppt:MS-Powerpoint file',
    'application/vnd.ms-project',	'mpp:MS-Project file',
    'application/winhlp',		'hlp:WinHelp document',
    'application/wordperfect5.1',	'hlp:WordPerfect 5.1 document',
    'application/x-NET-Install',	'ins:Net Install file',
    'application/x-asap',		'asp:asap file',
    'application/x-bcpio', 		'bcpio:BCPIO file',
    'application/x-cpio', 		'cpio:CPIO file',
    'application/x-csh', 		'csh:C-Shell script',
    'application/x-dot',		'dot:dot file',
    'application/x-dvi', 		'dvi:TeX dvi file',
    'application/x-earthtime',		'etc:Earthtime file',
    'application/x-envoy',		'evy:Envoy file',
    'application/x-excel',		'xls:MS-Excel Spreadsheet',
    'application/x-gtar', 		'gtar:GNU tar file',
    'application/x-hdf', 		'hdf:HDF file',
    'application/x-javascript',		'js:JavaScript source',
    'application/x-ksh',		'ksh:Korn Shell script',
    'application/x-latex', 		'latex:LaTex document',
    'application/x-maker',		'fm:FrameMake document',
    'application/x-mif', 		'mif:Frame MIF document',
    'application/x-mocha',		'moc:mocha file',
    'application/x-msaccess',		'mdb:MS-Access database',
    'application/x-mscardfile',		'crd:MS-CardFile',
    'application/x-msclip',		'clp:MS-Clip file',
    'application/x-msmediaview',	'm14:MS-Media View file',
    'application/x-msmetafile',		'wmf:MS-Metafile',
    'application/x-msmoney',		'mny:MS-Money file',
    'application/x-mspublisher',	'pub:MS-Publisher document',
    'application/x-msschedule',		'scd:MS-Schedule file',
    'application/x-msterminal',		'trm:MS-Terminal',
    'application/x-mswrite',		'wri:MS-Write document',
    'application/x-netcdf', 		'cdf:Cdf file',
    'application/x-ns-proxy-autoconfig','proxy:Netscape Proxy Auto Config',
    'application/x-patch',		'patch:Patch file',
    'application/x-perl',		'pl:Perl source',
    'application/x-pointplus',		'css:pointplus file',
    'application/x-salsa',		'slc:salsa file',
    'application/x-script',		'script:A script file',
    'application/x-sh', 		'sh:Bourne shell script',
    'application/x-shar', 		'shar:Shar file',
    'application/x-sprite',		'spr:sprite file',
    'application/x-sv4cpio', 		'sv4cpio:SV4Cpio file',
    'application/x-sv4crc', 		'sv4crc:SV4Crc file',
    'application/x-tar', 		'tar:Tar file',
    'application/x-tcl', 		'tcl:Tcl script',
    'application/x-tex', 		'tex:TeX document',
    'application/x-texinfo', 		'texinfo:TeXInfo document',
    'application/x-timbuktu',		'tbp:timbuktu file',
    'application/x-tkined',		'tki:tkined file',
    'application/x-troff', 		'roff:Troff document',
    'application/x-troff-man', 		'man:Troff manpage',
    'application/x-troff-me', 		'me:Troff ME',
    'application/x-troff-ms', 		'ms:Troff MS',
    'application/x-ustar', 		'ustar:UStar file',
    'application/x-wais-source', 	'src:WAIS Source',
    'application/zip', 			'zip:Zip archive',
    'audio/basic', 			'snd:Basic audio',
    'audio/echospeech',			'es:Echospeech audio',
    'audio/midi',			'midi:MIDI audio',
    'audio/x-aiff', 			'aif:AIF audio',
    'audio/x-epac',			'pae:epac audio',
    'audio/x-midi',			'midi:MIDI audio',
    'audio/x-pac',			'pac:pac audio',
    'audio/x-pn-realaudio',		'ra:PN Realaudio',
    'audio/x-wav', 			'wav:Wave audio',
    'image/bmp',			'bmp:Window bitmap',
    'image/cgm',			'cgm:Computer Graphics Metafile',
    'image/fif',			'fif:FIF image',
    'image/gif',			'gif:GIF image',
    'image/ief',			'ief:IEF image',
    'image/ifs',			'ifs:IFS image',
    'image/jpeg',			'jpg:JPEG image',
    'image/png',			'png:PNG image',
    'image/tiff',			'tif:TIFF image',
    'image/vnd',			'dwg:VND image',
    'image/wavelet',			'wi:Wavelet image',
    'image/x-bmp',			'bmp:Windows bitmap',
    'image/x-cmu-raster',		'ras:CMU raster',
    'image/x-pbm',			'pbm:Portable bitmap',
    'image/x-pcx',			'pcx:PCX image',
    'image/x-pgm',			'pgm:Portable graymap',
    'image/x-pict',			'pict:Mac PICT image',
    'image/x-pnm',			'pnm:Portable anymap',
    'image/x-portable-anymap',		'pnm:Portable anymap',
    'image/x-portable-bitmap',		'pbm:Portable bitmap',
    'image/x-portable-graymap',		'pgm:Portable graymap',
    'image/x-portable-pixmap',		'ppm:Portable pixmap',
    'image/x-ppm',			'ppm:Portable pixmap',
    'image/x-rgb',			'rgb:RGB image',
    'image/x-xbitmap',			'xbm:X bitmap',
    'image/x-xbm',			'xbm:X bitmap',
    'image/x-xpixmap',			'xpm:X pixmap',
    'image/x-xpm',			'xpm:X pixmap',
    'image/x-xwd',			'xwd:X window dump',
    'image/x-xwindowdump',		'xwd:X window dump',
    'text/html',			'html:HTML document',
    'text/plain',			'txt:Text document',
    'text/richtext',			'rtx:Richtext document',
    'text/setext',			'stx:Setext document',
    'text/sgml',			'sgml:SGML document',
    'text/x-html',			'html:HTML document',
    'text/x-setext',			'stx:Setext document',
    'text/x-speech',			'talk:Speech document',
    'video/isivideo',			'fvi:isi video',
    'video/mpeg',			'mpg:MPEG movie',
    'video/msvideo',			'avi:MS Video',
    'video/quicktime',			'mov:QuickTime movie',
    'video/vivo',			'viv:vivo video',
    'video/wavelet',			'wv:Wavelet video',
    'video/x-msvideo',			'avi:MS video',
    'video/x-sgi-movie',		'movie:SGI movie',

);

##---------------------------------------------------------------------------
##	Filter routine.
##
##	Argument string may contain the following values.  Each value
##	should be separated by a space:
##
##	inline  	Inline image data by default if
##			content-disposition not defined.
##
##	usename 	Use (file)name attribute for determining name
##			of derived file.  Use this option with caution
##			since it can lead to filename conflicts and
##			security problems.
##
##	ext=ext 	Use `ext' as the filename extension.
##
##	type="description"
##			Use "description" as type description of the
##			data.  The double quotes are required.
##
##	subdir		Place derived files in a subdirectory
##
sub filter {
    local($header, *fields, *data, $isdecode, $args) = @_;
    local($ret,
	  $filename,
	  $name,
	  $nameparm,
	  $path,
	  $disp,
	  $ctype,
	  $type,
	  $ext,
	  $inline,
	  $inext,
	  $intype);

    ## Init variables
    $name	= '';
    $ctype	= '';
    $type	= '';
    $ext	= '';
    $inline	=  0;
    $inext	= '';
    $intype	= '';

    ## Get content-type
    ($ctype) = $fields{'content-type'} =~ m%^\s*([\w-\./]+)%;
    $ctype =~ tr/A-Z/a-z/;

    ## Get disposition
    ($disp, $nameparm) = &'MAILhead_get_disposition(*fields);

    ## Check if using name
    if ($args =~ /usename/i) {
	$name = $nameparm;
    } else {
	$name = '';
    }

    ## Chech if file goes in a subdirectory
    if ($args =~ /subdir/i) {
	$path = join('', 'msg', $'MHAmsgnum, '.dir');
    } else {
	$path = '';
    }

    ## Check if inlining (images only)
    if ($disp) {
	$inline = ($disp =~ /inline/i);
    } else {
	$inline = ($args =~ /inline/i);
    }

    ## Check if extension and type description passed in
    if ($args =~ /ext=(\S+)/i) { $inext = $1; }
    if ($args =~ /type="([^"]+)"/i) { $intype = $1; }

    ## Determine default filename extension
    ($ext, $type) = split(/:/, $CTExt{$ctype}, 2);
    $ext  = $inext   if $inext;
    $type = $intype  if $intype;
    if (!$ext) {
	$ext = $UnknownExt;
	$type = "$UnknownType: $ctype";
    }
    $pre = $ext;
    substr($pre, 3) = "" if length($pre) > 3;	# Prune prefix to 3 chars

    ## Write file
    $filename = &write_file(*data, $path, $name, $pre, $ext);

    ## Create HTML markup
    if ($inline && ($ctype =~ /image/i)) {
	$ret  = "<P>" . &htmlize($fields{'content-description'}) . "</P>\n"
	    if ($fields{'content-description'});
	$ret .= qq{<P><A HREF="$filename"><IMG SRC="$filename" } .
		qq{ALT="$type"></A></P>\n};

    } else {
	$ret  = qq{<P><A HREF="$filename">} .
		(&htmlize($fields{'content-description'}) ||
		 $nameparm || $type) .
		qq{</A></P>\n};
    }
    ($ret, $path || $filename);
}

sub write_file {
    local(*stuff, $path, $fname, $pre, $ext) = @_;
    local($tmp, $cnt) = ('', '');

    $tmp  = $'OUTDIR;
    if ($path) {
	$tmp .= $'DIRSEP . $path;
	mkdir($tmp, 0777);
    }

    if (!$fname) {
	if (!$ExtCnt{$ext}) { &set_cnt($tmp); }
	$cnt = $ExtCnt{$ext}++;
	$fname = $pre . sprintf("%05d.",$cnt) . $ext;
	$ExtCnt{$ext} = 0  if $path;
    }
    $tmp .= $'DIRSEP . $fname;

    if (open(OUTFILE, "> $tmp")) {
	binmode(OUTFILE);		# For MS-DOS
	print OUTFILE $stuff;
	close(OUTFILE);
    } else {
	warn "Warning: Unable to create $tmp\n";
    }
    $path ? $path.$'DIRSEP.$fname : $fname;
}

sub set_cnt {
    local(@files) = ();
    if (opendir(DIR, $_[0])) {
	@files = sort numerically grep(/^$pre\d+\.$ext$/i, readdir(DIR));
	close(DIR);
	if (@files) {
	    ($ExtCnt{$ext}) = $files[$#files] =~ /(\d+)/;
	    $ExtCnt{$ext}++;
	} else {
	    $ExtCnt{$ext} = 0;
	}
    } else {
	$ExtCnt{$ext} = 0;
    }
}

sub numerically {
    ($A) = $a =~ /(\d+)/;
    ($B) = $b =~ /(\d+)/;
    $A <=> $B;
}

sub htmlize {
    local($txt) = shift;
    $txt =~ s/&/\&amp;/g;
    $txt =~ s/>/&gt;/g;
    $txt =~ s/</&lt;/g;
    $txt;
}

sub dump_ctext_hash {
    foreach (sort keys %CTExt) {
	print STDERR $_,":",$CTExt{$_},"\n";
    }
}

1;
