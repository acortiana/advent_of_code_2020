#!/usr/bin/perl
#
use warnings;
use strict;

my %data;
my $input = <STDIN>;
my $counter = 0;
my $last;
for (split /,/, $input) {
	chomp;
	$counter++;
	$data{$_} = {};
	$data{$_}->{last1} = $counter;
	$last = $_;
}

for (; $counter < 2020 ; $counter++) {
	#print "$counter      $last\n";
	if (exists($data{$last})) {
		my $lastnew = $counter - $data{$last}->{last1};
		$data{$last}->{last1} = $counter;
		$last = $lastnew;
	} else {
		$data{$last} = {};
		$data{$last}->{last1} = $counter;
		$last = 0;
	}
}
print $last, "\n";
