#!/usr/bin/perl

use warnings;
use strict;


my %values;
my @mask;
while (<>) {
	chomp;
	if (/mask = ([10X]+)/) {
		@mask = reverse(split //, $1);
		next;
	} elsif (/mem\[(\d+)\] = (\d+)/) {
		my ($location, $value) = ($1, $2);
		my @maskbits;
		for (my $i = 35; $i >= 0; $i--) {
			if ($mask[$i] eq "X") {
				push @maskbits, $i;
				if ($location & (2**$i)) { $location = $location - (2**$i) }
			} elsif ($mask[$i] == 1) {
				unless ($location & (2**$i)) { $location = $location + (2**$i) }
			}
		}
		for (my $i=0; $i< (2** scalar @maskbits); $i++) {
			my $asd = scalar @maskbits;
			my @bits = split //, sprintf("%0${asd}b",$i);
			my $tosum = 0;
			for (my $ii=0; $ii< scalar @bits; $ii++) {
				$tosum = $tosum + ($bits[$ii] * (2 ** $maskbits[$ii]));
			}
			$values{$location+$tosum} = $value;
		}
	} else {
		print "ERROR\n";
		exit(1);
	}
}

my $sum = 0;
for (keys %values) {
	$sum = $sum + $values{$_};
}
print $sum, "\n";

