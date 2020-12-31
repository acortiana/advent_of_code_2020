#!/usr/bin/perl

use warnings;
use strict;

my @array;
my $current_hash = {};
push @array, $current_hash;

while (<>) {
	chomp;
	if (/^\s*$/) {
		$current_hash = {};
		push @array, $current_hash;
		next;
	}
	my @values = split //, $_;
	for (@values) {
		if (exists($$current_hash{$_})) {
			$$current_hash{$_}++;
		} else {
			$$current_hash{$_} = 1;
		}
	}
}

my $result = 0;
for (@array) {
	$result += keys %{$_};
}

print $result, "\n";
