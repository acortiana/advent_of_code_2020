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
		for (@numbers) {
			my $third = $_;

			if ($first == $second) { next }
			if ($first == $third) { next }
			if (($first + $second + $third) == 2020) {
				#print "$first\n$second\n$third\n";
				print $first * $second * $third, "\n";
				exit(0);
			}
		}
	}
}
