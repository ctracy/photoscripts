#!/opt/local/bin/perl
#
# basic idea:
#
# provide a list of directories on the command line.
#
# recurse this directory, try to get exif data for every file
# (not just JPEGs but also MOV AVI etc)
#
# store all of this in a giant hash
#
# create another lookup hash(es) to be used in the dupechecking algorithm
#   (for speed)
#   this will probably be a hash of arrays
#   $res{x}{y} = @array_of_files_matching_this_res
#   $creation_date{time} = @array_of_files
#
# dupe algorithm:
#  foreach ( file )
#   check to see if we have another file matching exactly the same:
#    resolution
#     AND
#    creation date
#    gives candidate match
#
#    not sure if we need to compare file type (avi, mov, jpeg, etc)...
#
# improvements:
#
# camera pics in sequence can be within the same second
# could try to find ##### in filename, if we see 2 dupe files where ##### are in a sequence 
# this is most likely NOT a dupe

use strict;
use Image::ExifTool qw(:Public);
use Data::Dumper;

my %creation;
my %exifMisc;

print "processing files...\n";
my $z = shift @ARGV;
while ($z) {
    if (-d $z) {
	open I, "find \"$z\" -type f -print |";
	while(<I>) {
	    next if m|/Previews/|;
	    chomp;
	    &process($_);
	}
	close I;
    } elsif (-f $z) {
	&process($z);
    }
    $z = shift @ARGV;
}

# dupe checking algorithm - only on creation date
my %dupesDisplayed;
foreach my $file (sort keys %{ $creation{'file'} }) {
    if ($#{ $creation{'date'}{$creation{'file'}{$file}} } > 0) {
	my $cr;
	foreach (@{ $creation{'date'}{$creation{'file'}{$file}} }) {
	    if (!defined($dupesDisplayed{$_})) {
		$dupesDisplayed{$_} = 1;
		$cr = 1;
		my @s = stat($_);
		print "$_ :::: $s[7] bytes, EXIF: $exifMisc{$_}\n";
	    }
	}
	print "\n" if $cr;
    }
}


sub process {
    my $file = shift;
    my $info = ImageInfo($file);

# most interesting fields:
#  ImageHeight ImageWidth DateTimeOriginal CreateDate FileType Make Model GPSTimeStamp

    my $CreateDate;
    if (defined($info->{'CreateDate'})) {
	$CreateDate = $info->{'CreateDate'};
    } elsif (defined($info->{'DateTimeOriginal'})) {
	$CreateDate = $info->{'DateTimeOriginal'};
# photo booth is crazy -- doesn't have CreateDate or DateTimeOriginal
# create date is stored in FileModifyDate
    } elsif (defined($info->{'Keywords'}) and
	     $info->{'Keywords'} eq "Photo Booth" and
	     defined($info->{'FileModifyDate'})) {
	$CreateDate = $info->{'FileModifyDate'};
    } else {
#	print "Can't get creation date for $file!\n";
	return;
    }

# some devices have more precise GPS Timestamp available
    if (defined($info->{'GPSTimeStamp'})) {
	$CreateDate .= " " . $info->{'GPSTimeStamp'};
    }
    
    # make hour of day a don't care condition (hack)
    $CreateDate =~ s/(\d{4}:\d\d:\d\d\s)(\d\d)(:\d\d:\d\d)/$1xx$3/;

    push @{ $creation{'date'}{$CreateDate} }, $file;
    $creation{'file'}{$file} = $CreateDate;

    $exifMisc{$file} = "$info->{'Make'} $info->{'Model'} $info->{'FileType'} $info->{'ImageWidth'} $info->{'ImageHeight'} $CreateDate";
}
