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
	if ($textarray[$min-1] eq $character) { $charcount++ }
	if ($textarray[$max-1] eq $character) { $charcount++ }
	if ($charcount == 1) {
		$okcount++;
	} else {
		$errorcount++;
	}
}
#print "total: $total\n";
#print "errorcount: $errorcount\n";
print "$okcount\n";
