#!/usr/bin/perl

use warnings;
use strict;

my @lines = <STDIN>;
my @numbers;

my $target = $lines[0];

for (split (/,/, $lines[1])) {
	chomp;
	if ($_ =~ /\d+/) { push @numbers, $_ }
}

my $busnumber;
my $diff;

for (@numbers) {
	my $i;
	for ($i=0; ($_ * $i) <= $target; $i++) {}
	my $localdiff = ($i * $_) - $target;
	unless (defined($diff)) {
		$diff = $localdiff;
		$busnumber = $_;
	} else {
		if ($diff > $localdiff) {
			$diff = $localdiff;
			$busnumber = $_;
		}
	}
}
print $diff * $busnumber, "\n";
