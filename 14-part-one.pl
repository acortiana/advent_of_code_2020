#!/usr/bin/perl

use warnings;
use strict;


my %values;
my @mask;
while (<>) {
	chomp;
	if (/mask = ([10X]+)/) {
		@mask = reverse(split //, $1);
		next;
	} elsif (/mem\[(\d+)\] = (\d+)/) {
		my ($location, $value) = ($1, $2);
		my @locations;
		my @combs;
		for (my $i = 35; $i >= 0; $i--) {
			if ($mask[$i] eq "X") {
			} elsif ($mask[$i] == 1) {
				unless ($value & (2**$i)) { $value = $value + (2**$i) }
			} elsif ($mask[$i] == 0) {
				if ($value & (2**$i)) { $value = $value - (2**$i) }
			}
		}
		$values{$location} = $value;
	} else {
		print "ERROR\n";
		exit(1);
	}
}

my $sum = 0;
for (keys %values) {
	$sum = $sum + $values{$_};
}
print $sum, "\n";

