#!/usr/bin/perl

use warnings;
use strict;

my $instructions = ();
while (<>) {
	chomp;
	unless (/([NSEWLRF])(\d+)/) { print "ERROR"; exit(1) }
	my ($command, $value) = ($1, $2);
	my $temp = ();
	push @$temp, $command;
	push @$temp, $value;
	push @$instructions, $temp;
}

sub move {
	my ($direction, $y, $x, $command, $value) = @_;
	if ($command eq "N") {
		$y = $y + $value;
	} elsif ($command eq "S") {
		$y = $y - $value;
	} elsif ($command eq "E") {
		$x = $x + $value;
	} elsif ($command eq "W") {
		$x = $x - $value;
	} elsif ($command eq "L") {
		$direction = ($direction - $value) % 360
	} elsif ($command eq "R") {
		$direction = ($direction + $value) % 360
	} elsif ($command eq "F") {
		if ($direction == 0) { $y = $y + $value; }
		if ($direction == 90) { $x = $x + $value; }
		if ($direction == 180) { $y = $y - $value; }
		if ($direction == 270) { $x = $x - $value; }
	}
	return ($direction, $y, $x);
}

my $y = 0;
my $x = 0;
my $direction = 90;
for (@$instructions) {
	my ($command, $value) = ($$_[0], $$_[1]);
	#printf("%-20d%-20d%-20d%-20s%-20d\n",$direction,$y, $x,$command,$value);
	($direction, $y, $x) = &move($direction, $y, $x, $command, $value);
}
print abs($y) + abs($x), "\n";
