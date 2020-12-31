#!/usr/bin/perl
#
use warnings;
use strict;

my $counter = 1;
my @rules;
my $error_rate = 0;

sub verify_range {
	my ($value, $range) = @_;
	my ($min, $max) = split /-/, $range;
	if (($value < $min) or ($value > $max)) { return 0 }
	return 1;
}

while (<>) {
	chomp;
	if (/^$/) { $counter++; next; }
	if ($counter == 1) {
		unless (/(\d+-\d+) or (\d+-\d+)/) { print "error"; exit(1) }
		my ($range1, $range2) = ($1, $2);
		push @rules, $range1;
		push @rules, $range2;
	} elsif ($counter == 2) {
		next;
	} elsif ($counter == 3) {
		if (/^nearby/) { next }
		my @values = split /,/, $_;
		for (@values) {
			my $value = $_;
			my $match = 0;
			for (@rules) {
				if (verify_range($value, $_)) {
					$match = 1;
					last;
				}
			}
			if ($match == 0) {
				$error_rate = $error_rate + $value;
			}
		}
	}
}

print $error_rate, "\n";
