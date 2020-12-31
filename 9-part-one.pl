#!/usr/bin/perl

use warnings;
use strict;

my @array;
while (<>) {
	chomp;
	if (scalar(@array) != 25) {
		push @array, $_;
		next;
	}
	if (&number_analysis($_)) {
		push @array, $_;
		shift @array;
	} else {
		print $_, "\n";
		exit(0);
	}
}
print "finish\n";

sub number_analysis {
	my $number = shift;
	for (@array) {
		my $first = $_;
		for (@array) {
			my $second = $_;
			if ($first == $second) { next }
			if ($number == ($first + $second)) { return 1 }
		}
	}
	return 0;
}
