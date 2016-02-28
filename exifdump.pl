#!/opt/local/bin/perl

use strict;
use Image::ExifTool qw(:Public);
use Data::Dumper;
use Getopt::Long;

my $verbose = 0;
my $z = ".";
GetOptions('dir|file=s' => \$z,
	   'verbose' => \$verbose);

print "processing files...\n";
if (-d $z) {
    open I, "find \"$z\" -type f -print |";
    while(<I>) {
	chomp;
	&process($_);
    }
    close I;
} elsif (-f $z) {
    &process($z);
}


sub process {
    my $file = shift;
    my $info = ImageInfo($file);

    print <<END;
    $file make=$info->{'Make'} model=$info->{'Model'} filetype=$info->{'FileType'} imagewidth=$info->{'ImageWidth'} imageheight=$info->{'ImageHeight'} datetimeoriginal=$info->{'DateTimeOriginal'} createdate=$info->{'CreateDate'} filemodifydate=$info->{'FileModifyDate'}
END

    if ($verbose) {
	foreach my $key (sort keys %{ $info }) {
	    $info->{$key} =~ s/[^[:ascii:]]/.../g;
	    print "  '$key' => '$info->{$key}'\n";
	}
	print "=" x 50, "\n";
    }
}
