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
	my ($y, $x, $waypoint_y, $waypoint_x, $command, $value) = @_;
	if ($command eq "N") {
		$waypoint_y = $waypoint_y + $value;
	} elsif ($command eq "S") {
		$waypoint_y = $waypoint_y - $value;
	} elsif ($command eq "E") {
		$waypoint_x = $waypoint_x + $value;
	} elsif ($command eq "W") {
		$waypoint_x = $waypoint_x - $value;
	} elsif ($command eq "L") {
		for (my $i=1; $i <= ($value / 90); $i++) {
			my $new_waypoint_x = -$waypoint_y;
			my $new_waypoint_y = $waypoint_x;
			$waypoint_y = $new_waypoint_y;
			$waypoint_x = $new_waypoint_x;
		}
	} elsif ($command eq "R") {
		for (my $i=1; $i <= ($value / 90); $i++) {
			my $new_waypoint_x = $waypoint_y;
			my $new_waypoint_y = -$waypoint_x;
			$waypoint_y = $new_waypoint_y;
			$waypoint_x = $new_waypoint_x;
		}
	} elsif ($command eq "F") {
		$y = $y + ($waypoint_y * $value);
		$x = $x + ($waypoint_x * $value);
	}
	return ($y, $x, $waypoint_y, $waypoint_x);
}

my $y = 0;
my $x = 0;
my $waypoint_y = 1;
my $waypoint_x = 10;
#printf("%-20s%-20s%-20s%-20s%-20s%-20s\n","y","x", "waypoint_y", "waypoint_x", "command","value");
for (@$instructions) {
	my ($command, $value) = ($$_[0], $$_[1]);
	#printf("%-20d%-20d%-20d%-20s%-20s%-20d\n",$y, $x, $waypoint_y, $waypoint_x, $command,$value);
	($y, $x, $waypoint_y, $waypoint_x) = &move($y, $x, $waypoint_y, $waypoint_x, $command, $value);
}
print abs($y) + abs($x), "\n";
