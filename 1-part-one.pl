#!/usr/bin/perl
#
use warnings;
use strict;

my @numbers;
while (<>) {
	chomp;
	push @numbers, $_;
}

for (@numbers) {
	my $first = $_;
	for (@numbers) {
		my $second = $_;
		if ($first == $second) { next }
		if (($first + $second) == 2020) {
			#print "$first\n$second\n";
			print $first * $second, "\n";
			exit(0);
		}
	}
}
