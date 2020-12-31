#!/usr/bin/perl
#
use warnings;
use strict;


my @array;
while (<>) {
	chomp;
	push @array, $_;
}

my @sorted_array = sort { $a <=> $b } @array;
my %results;
$results{1} = 0;
$results{2} = 0;
$results{3} = 1;
my $cur_joltage = 0;
for (@sorted_array) {
	my $diff = $_ - $cur_joltage;
	if (($diff > 3) or ($diff < 1)) {
		print "error\n";
		exit(1);
	}
	$results{$diff}++;
	$cur_joltage = $_;
}
print $results{1} * $results{3}, "\n";
