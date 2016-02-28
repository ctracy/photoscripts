#!/usr/bin/perl -w

use strict;
use File::Basename;
use File::Copy qw(move copy);

my $DB = "/Users/Shared/Master\ Aperture\ 3\ Library.aplibrary/Database/apdb/Library.apdb";
my $QUERY = "SELECT imagePath FROM RKMaster WHERE fileIsReference=1;";

my %f;
open I, "sqlite3 \"$DB\" \"$QUERY\" |";
while(<I>) {
    chomp;
    my $file = "/" . $_;
    #strip extension due to case-insensitivity issues
    $file =~ s/\.[a-z]+$//;
    $f{$file}++;
}
close I;

foreach (keys %f) {
    print "$_\n" if $f{$_} > 1;
}
