##---------------------------------------------------------------------------##
##  File:
##      mhexternal.pl
##  Author:
##      Earl Hood       ehood@convex.com
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
##  Copyright (C) 1994  Earl Hood, ehood@convex.com
##
##  This program is free software; you can redistribute it and/or modify
##  it under the terms of the GNU General Public License as published by
##  the Free Software Foundation; either version 2 of the License, or
##  (at your option) any later version.
##  
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU General Public License for more details.
##  
##  You should have received a copy of the GNU General Public License
##  along with this program; if not, write to the Free Software
##  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
##---------------------------------------------------------------------------##

package m2h_external;

##---------------------------------------------------------------------------
##	Global variables

$pre = '';	# Prefix to generated files
$ext = '';	# Extension for files
$ctype = '';	# Content-type of data
$TYPE = '';	# English name for data type
%ExtCnt = ();	# Array of filename counters for generated files
$inline = 1;	# Change to 0 if not to in-line GIFs/XBM images

##---------------------------------------------------------------------------
##	All that should be required is to add to, or edit, the %AppExt and
##	%AppType arrays for new, or changed, application suptypes.

%CTExt = (
##  Content-Type			Filename extension
##---------------------------------------------------------
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
    'image/x-cmu-raster',		'ras',
    'image/x-pict',			'pict',
    'image/x-portable-anymap',		'pnm',
    'image/x-pnm',			'pnm',
    'image/x-portable-bitmap',		'pbm',
    'image/x-pbm',			'pbm',
    'image/x-portable-graymap',		'pgm',
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
    'image/x-cmu-raster',		'CMU raster',
    'image/x-pict',			'Mac PICT image',
    'image/x-portable-anymap',		'Portable anymap',
    'image/x-pnm',			'Portable anymap',
    'image/x-portable-bitmap',		'Portable bitmap',
    'image/x-pbm',			'Portable bitmap',
    'image/x-portable-graymap',		'Portable graymap',
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
sub filter {
    local($header, *fields, *data) = @_;
    local($ret, $filename);

    $name = '';  $ctype = '';
    ($ctype) = $fields{'content-type'} =~ m%^\s*([\w-/]+)%;
	$ctype =~ tr/A-Z/a-z/;
    ($name) = $fields{'content-type'} =~ /name=(\S+)/i;
	$name =~ s/'"//g;
    $pre = $ext = $CTExt{$ctype};  $TYPE = $CTType{$ctype};
    if (!$ext) {
        warn "\nm2h_external'filter: Unrecognized content-type \"$ctype\"\n";
        return '';
    }
    $filename = &write_file(*data);

    ## Create HTML markup
    if ($inline && ($ext eq 'gif' || $ext eq 'xbm')) {
        $ret = join('', "<p>\n",
                    &htmlize($fields{'content-description'}),
                    "\n<p>\n",
                    qq|<a href="$filename"><img src="$filename" |,
                    qq|alt="$TYPE"></a>\n|,
                    "<p>\n");
    } else {
        $ret = join('', "<p>\n",
                    qq|<a href="$filename">|,
                    &htmlize($fields{'content-description'}) || 
                        $name || $TYPE,
                    "</a><p>\n");
    }
    $ret;
}

sub write_file {
    local(*stuff) = shift;
    local($fname, $cnt) = ('', '');

    if ($name) {
	$fname = $name;
    } else {
	if (!$ExtCnt{$ext}) { &set_cnt(); }
	$cnt = $ExtCnt{$ext}++;
	$fname = $pre . sprintf("%05d.",$cnt) . $ext;
    }

    ## $'OUTDIR is set by MHonArc that specifies destination path
    ## of filtered mail.
    ##
    if (open(OUTFILE, "> $'OUTDIR/$fname")) {
	print OUTFILE $stuff;
	close(OUTFILE);
    } else {
	warn "Warning: Unable to create $'OUTDIR/$fname\n";
    }
    $fname;
}

sub set_cnt {
    local(@files) = ();
    opendir(DIR, $'OUTDIR);
    @files = sort numerically grep(/^$pre\d+\.$ext$/, readdir(DIR));
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
