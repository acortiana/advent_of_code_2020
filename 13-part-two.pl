#!/usr/bin/perl

use warnings;
use strict;

my $rc = eval
{
	#use ntheory qw/chinese/;
	require ntheory;
	ntheory->import('chinese');
	1;
};

unless($rc) {
	print STDERR "ntheory perl module required\n";
	print STDERR "To install it use CPAN --> install ntheory\n";
	print STDERR "Consider that CPAN compiles the module using the C compiler. Make sure to have it installed (in debian-like distros, install 'build-essential' package)\n";
	exit(1);
}



my @lines = <STDIN>;
my @numbers;

my $counter = 0;
for (split (/,/, $lines[1])) {
        chomp;
        if ($_ =~ /\d+/) {
                my $tmp = [];
                $$tmp[0] = ($_- $counter) % $_;
                $$tmp[1] = $_;
                push @numbers, $tmp;;
        }
        $counter++;
}

print chinese(@numbers), "\n";
