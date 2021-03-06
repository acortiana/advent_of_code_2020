#!/usr/bin/perl
#
use warnings;
use strict;
use Data::Dumper;

my $data = {};
while (<>) {
	chomp;
	unless (/^(\S+\s+\S+) bags/) { print STDERR "error1\n"; exit(1); }
	my $key = $1;
	$$data{$key} = {};
	if (/contain no other bag/) { next }
	my @temp1 = split / contain /, $_;
	my @temp2 = split /, /, $temp1[1];
	for (@temp2) {
		unless (/(\d+)\s+(\S+\s+\S+)\s+bag/) { print STDERR "error2\n$_\n"; exit(1); }
		my ($number, $local_key) = ($1, $2);
		$$data{$key}{$local_key} = $number;
	}
}


sub search1 {
	my ($bag, $target) = @_;
	my $sum = 0;
	if (defined($bag)) {
		for (keys %{$$data{$bag}}) {
			if ($_ eq $target) {
				$sum = $sum + $$data{$bag}{$_}
			} else {
				$sum = $sum + &search1($_, $target);
			}
		}
		return $sum;
	} else {
		for (keys %$data) {
			my $result = &search1($_,$target);
			if ($result > 0) { $sum++ }
		}
		return $sum;
	}
}

my $target = "shiny gold";
print &search1(undef,$target), "\n";