#!/usr/bin/perl
#
use warnings;
use strict;

my @pubkeys;
while (<>) {
	chomp;
	push @pubkeys, $_;
}

sub find_loop_size {
	my ($subject_number, $pubkey, $desired_loopcount) = @_;
	my $value = 1;
	my $loopcount = 0;
	while (1) {
		$value = $value * $subject_number;
		$value = $value % 20201227;
		$loopcount++;
		if (defined($pubkey)) {
			if ($value == $pubkey) { last }
		}
		if (defined($desired_loopcount)) {
			if ($desired_loopcount == $loopcount) { last }
		}
	}
	return ($loopcount, $value);
}

my ($loopcount, $value) = &find_loop_size(7,$pubkeys[0],undef);
my ($loopcount2, $value2) = &find_loop_size($pubkeys[1],undef,$loopcount);

print $value2, "\n";
