##---------------------------------------------------------------------------##
##  File:
##      mhexternal.pl
##  Author:
##      Earl Hood       ehood@isogen.com
##  Date:
##	Fri Jul 12 08:34:55 CDT 1996
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
##	all subtypes.
##
##---------------------------------------------------------------------------##
##    MHonArc -- Internet mail-to-HTML converter
##    Copyright (C) 1995	Earl Hood, ehood@isogen.com
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

##---------------------------------------------------------------------------
##	Global variables

$pre = '';	# Prefix to generated files
$ext = '';	# Extension for files
$ctype = '';	# Content-type of data
$TYPE = '';	# English name for data type
%ExtCnt = ();	# Array of filename counters for generated files
$inline = 0;	# Can be changed by filter argument

##---------------------------------------------------------------------------
##	All that should be required is to add to, or edit, the %AppExt and
##	%AppType arrays for new, or changed, application suptypes.

$UnknownExt	= 'xxx';
$UnknownType	= 'Unrecognized Data';

%CTExt = (
##  Content-Type			Filename extension
##---------------------------------------------------------
    'application/mac-binhex40', 	'hqx',
    'application/octet-stream', 	'bin',
    'application/oda', 			'oda',
    'application/pdf', 			'pdf',
    'application/postscript', 		'ps',
    'application/rtf', 			'rtf',
    'application/x-bcpio', 		'bcpio',
    'application/x-cpio', 		'cpio',
    'application/x-csh', 		'csh',
    'application/x-dvi', 		'dvi',
    'application/x-gtar', 		'gtar',
    'application/x-hdf', 		'hdf',
    'application/x-latex', 		'latex',
    'application/x-mif', 		'mif',
    'application/x-netcdf', 		'cdf',
    'application/x-sh', 		'sh',
    'application/x-shar', 		'shar',
    'application/x-sv4cpio', 		'sv4cpio',
    'application/x-sv4crc', 		'sv4crc',
    'application/x-tar', 		'tar',
    'application/x-tcl', 		'tcl',
    'application/x-tex', 		'tex',
    'application/x-texinfo', 		'texinfo',
    'application/x-troff', 		'roff',
    'application/x-troff-man', 		'man',
    'application/x-troff-me', 		'me',
    'application/x-troff-ms', 		'ms',
    'application/x-ustar', 		'ustar',
    'application/x-wais-source', 	'src',
    'application/zip', 			'zip',
    'audio/basic', 			'snd',
    'audio/x-aiff', 			'aif',
    'audio/x-wav', 			'wav',
    'image/gif',			'gif',
    'image/ief',			'ief',
    'image/jpeg',			'jpg',
    'image/tiff',			'tif',
    'image/x-bmp',			'bmp',
    'image/x-cmu-raster',		'ras',
    'image/x-pict',			'pict',
    'image/x-portable-anymap',		'pnm',
    'image/x-pnm',			'pnm',
    'image/x-portable-bitmap',		'pbm',
    'image/x-pbm',			'pbm',
    'image/x-portable-graymap',		'pgm',
    'image/x-pcx',			'pcx',
    'image/x-pgm',			'pgm',
    'image/x-portable-pixmap',		'ppm',
    'image/x-ppm',			'ppm',
    'image/x-rgb',			'rgb',
    'image/x-xbitmap',			'xbm',
    'image/x-xbm',			'xbm',
    'image/x-xpixmap',			'xpm',
    'image/x-xpm',			'xpm',
    'image/x-xwindowdump',		'xwd',
    'image/x-xwd',			'xwd',
    'video/mpeg',			'mpg',
    'video/quicktime',			'mov',
    'video/x-msvideo',			'avi',
    'video/x-sgi-movie',		'movie',
);
%CTType = (
##  Content-Type			English name
##---------------------------------------------------------
    'application/mac-binhex40', 	'Mac BinHex file',
    'application/octet-stream', 	'Binary data',
    'application/oda', 			'ODA file',
    'application/pdf', 			'PDF file',
    'application/postscript', 		'PostScript file',
    'application/rtf', 			'RTF file',
    'application/x-bcpio', 		'BCPIO file',
    'application/x-cpio', 		'CPIO file',
    'application/x-csh', 		'Csh script',
    'application/x-dvi', 		'TeX dvi file',
    'application/x-gtar', 		'Gtar file',
    'application/x-hdf', 		'HDF file',
    'application/x-latex', 		'LaTex document',
    'application/x-mif', 		'Frame MIF',
    'application/x-netcdf', 		'Cdf file',
    'application/x-sh', 		'Sh script',
    'application/x-shar', 		'Shar file',
    'application/x-sv4cpio', 		'SV4Cpio file',
    'application/x-sv4crc', 		'SV4Crc file',
    'application/x-tar', 		'Tar file',
    'application/x-tcl', 		'Tcl script',
    'application/x-tex', 		'TeX document',
    'application/x-texinfo', 		'TeXInfo file',
    'application/x-troff', 		'Troff',
    'application/x-troff-man', 		'Troff Man',
    'application/x-troff-me', 		'Troff ME',
    'application/x-troff-ms', 		'Troff MS',
    'application/x-ustar', 		'UStar file',
    'application/x-wais-source', 	'WAIS Source',
    'application/zip', 			'Zip file',
    'audio/basic', 			'Basic audio',
    'audio/x-aiff', 			'AIF audio',
    'audio/x-wav', 			'WAV audio',
    'image/gif',			'GIF image',
    'image/ief',			'IEF image',
    'image/jpeg',			'JPEG image',
    'image/tiff',			'TIFF image',
    'image/x-bmp',			'Windows bitmap',
    'image/x-cmu-raster',		'CMU raster',
    'image/x-pict',			'Mac PICT image',
    'image/x-portable-anymap',		'Portable anymap',
    'image/x-pnm',			'Portable anymap',
    'image/x-portable-bitmap',		'Portable bitmap',
    'image/x-pbm',			'Portable bitmap',
    'image/x-portable-graymap',		'Portable graymap',
    'image/x-pcx',			'PCX image',
    'image/x-pgm',			'Portable graymap',
    'image/x-portable-pixmap',		'Portable pixmap',
    'image/x-ppm',			'Portable pixmap',
    'image/x-rgb',			'RGB image',
    'image/x-xbitmap',			'X bitmap',
    'image/x-xbm',			'X bitmap',
    'image/x-xpixmap',			'X pixmap',
    'image/x-xpm',			'X pixmap',
    'image/x-xwindowdump',		'X window dump',
    'image/x-xwd',			'X window dump',
    'video/mpeg',			'MPEG movie',
    'video/quicktime',			'QuickTime movie',
    'video/x-msvideo',			'MS video',
    'video/x-sgi-movie',		'SGI Movie',
);

##---------------------------------------------------------------------------
##	Filter routine.
##
##	Argument string may contain the following values.  Each value
##	should be separated by a space:
##
##	   inline	=> Inline image data with IMG element.
##	   usename	=> Use name attribute for determining name
##			   of derived file.  Use this option with caution
##			   since it can lead to filename conflicts and
##			   security problems.
##
sub filter {
    local($header, *fields, *data, $isdecode, $args) = @_;
    local($ret, $filename, $nameparm);

    ## Init variables
    $name = '';
    $ctype = '';
    $TYPE = '';
    $ext = '';
    $inline = 0;

    ## Get content-type
    ($ctype) = $fields{'content-type'} =~ m%^\s*([\w-/]+)%;
    $ctype =~ tr/A-Z/a-z/;

    ## See if name argument is to be used
    ($nameparm) = $fields{'content-type'} =~ /name=(\S+)/i;
    $nameparm =~ s/['";]//g;
    $nameparm =~ s/.*[\/\\:]//; 	# Remove path component
    if ($args =~ /usename/i) {
	$name = $nameparm;
    }

    ## Check if image inlining
    $inline = ($args =~ /inline/i);

    ## Determine filename extension
    $pre = $ext = $CTExt{$ctype};  $TYPE = $CTType{$ctype};
    if (!$ext) {
	$ext = $UnknownExt;
	$TYPE = $UnknownType;
    }

    ## Write file
    $filename = &write_file(*data);

    ## Create HTML markup
    if ($inline && ($ctype =~ /image/i)) {
        $ret = join('', "<P>",
                    &htmlize($fields{'content-description'}),
                    "\n</P><P>\n",
                    qq|<A HREF="$filename"><IMG SRC="$filename" |,
                    qq|ALT="$TYPE"></a>\n|,
		    "</P>\n");
    } else {
        $ret = join('', "<P>\n",
                    qq|<A HREF="$filename">|,
                    &htmlize($fields{'content-description'}) || 
                        $nameparm || $TYPE,
                    "</A></P>\n");
    }
    ($ret, $filename);
}

sub write_file {
    local(*stuff) = shift;
    local($fname, $tmp, $cnt) = ('', '');

    if ($name) {
	$fname = $name;
    } else {
	if (!$ExtCnt{$ext}) { &set_cnt(); }
	$cnt = $ExtCnt{$ext}++;
	$fname = $pre . sprintf("%05d.",$cnt) . $ext;
    }
    $tmp = $'OUTDIR . $'DIRSEP . $fname;

    ## $'OUTDIR is set by MHonArc that specifies destination path
    ## of filtered mail.
    ##
    if (open(OUTFILE, "> $tmp")) {
	binmode(OUTFILE);		# For MS-DOS
	print OUTFILE $stuff;
	close(OUTFILE);
    } else {
	warn "Warning: Unable to create $tmp\n";
    }
    $fname;
}

sub set_cnt {
    local(@files) = ();
    opendir(DIR, $'OUTDIR);
    @files = sort numerically grep(/^$pre\d+\.$ext$/i, readdir(DIR));
    close(DIR);
    if (@files) {
	($ExtCnt{$ext}) = $files[$#files] =~ /(\d+)/;
	$ExtCnt{$ext}++;
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

1;
