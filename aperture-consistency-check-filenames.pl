#!/usr/bin/perl -w

use strict;
use File::Basename;
use File::Copy qw(move copy);

my $DB = "/Users/Shared/Master\ Aperture\ 3\ Library.aplibrary/Database/apdb/Library.apdb";
my $QUERY = "SELECT imagePath FROM RKMaster WHERE fileIsReference=1 ;";

open I, "sqlite3 \"$DB\" \"$QUERY\" |";
while(<I>) {
    chomp;
    my $file = "/" . $_;
#    print "$file\n" if !-f $file;
    if (-f $file) {
	my($filename, $directories, $suffix) = fileparse($file);
	$directories =~ s/\/$//;
	open J, "find '$directories' -type f -print |";
	while(<J>) {
	    chomp;
	    next unless /$file/i;
	    my $found = $_;
	    if ($found ne $file) {
#		print "   found=$found\naperture=$file\n===\n";
#		print "moving $found\n   to: $file\n\n";
#		move($found, $file);
		print("mv '$found' '$file'\n");
	    }
	}
	close J;
    } 
}
close I;
