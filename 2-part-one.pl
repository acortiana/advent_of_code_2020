#!/usr/bin/perl
#
use warnings;
use strict;

my $okcount = 0;
my $errorcount = 0;
my $total = 0;
while (<>) {
	my ($min,$max,$character,$text);
	if (/(\d+)-(\d+) (\S): (\S+)/) {
		($min,$max,$character,$text) = ($1,$2,$3,$4);
		$total++;
	} else {
		print STDERR "error\n";
		exit(1);
	}
	my @textarray = split //, $text;
	my $charcount = 0;
	for (@textarray) {
		if ($_ eq $character) { $charcount++ }
	}
	if (($charcount >= $min) and ($charcount <= $max)) {
		$okcount++;
	} else {
		$errorcount++;
	}
}
#print "total: $total\n";
#print "errorcount: $errorcount\n";
print "$okcount\n";
