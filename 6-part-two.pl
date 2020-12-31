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
	if (exists($$current_hash{linecount})) {
		$$current_hash{linecount}++;
	} else {
		$$current_hash{linecount} = 1;
	}
}

my $result = 0;
for (@array) {
	my $partial_count = 0;
	my $arrayref = $_;
	for (keys %{$_}) {
		if ($_ eq "linecount") { next }
		if ($$arrayref{$_} == $$arrayref{linecount}) { $partial_count++ }
	}
	$result += $partial_count;
}

print $result, "\n";
