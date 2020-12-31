#!/usr/bin/perl

use warnings;
use strict;

my @array;
my @arraynew;
my $partoneanswer;

while (<>) {
	chomp;
	push @arraynew, $_;
	if (scalar(@array) != 25) {
		push @array, $_;
		next;
	}
	if (&number_analysis($_)) {
		push @array, $_;
		shift @array;
	} else {
		unless(defined($partoneanswer)) {
			$partoneanswer = $_;
		}
	}
}

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

sub verify2 {
	for (my $start = 0; $start < scalar(@arraynew); $start++) {
		for (my $number_to_sum = 2; $number_to_sum < scalar(@arraynew); $number_to_sum++) {
			my ($sum, $first, $last) = &verify($start,$number_to_sum);
			if ($sum == $partoneanswer) {
				print $first + $last, "\n";
				exit(0);
			}
		}
	}
}

sub verify {
	my ($start, $numbers_to_sum) = @_;
	if (($start + $numbers_to_sum) > $#arraynew) { return -1 }
	my $sum = 0;
	my $smallest = 99999999999999999999;
	my $largest = 0;
	for (my $i = 0; $i < $numbers_to_sum; $i++) {
		my $number = $arraynew[$start + $i];
		if ($number < $smallest) { $smallest = $number }
		if ($number > $largest) { $largest = $number }
		$sum = $sum + $number;
	}
	my $first = $arraynew[$start];
	my $last = $arraynew[$start+$numbers_to_sum-1];
	return ($sum, $smallest, $largest);
}

&verify2;
