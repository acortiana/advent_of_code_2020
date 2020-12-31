#!/usr/bin/perl
#
use warnings;
use strict;

my %blacktiles;

sub switchtile {
	my ($x, $y) = @_;
	if (exists($blacktiles{"$x,$y"})) {
		delete($blacktiles{"$x,$y"});
	} else {
		$blacktiles{"$x,$y"} = 1;
	}
}

while (<>) {
	chomp;
	my ($x, $y) = (0, 0);
	while (not ($_ =~ /^$/)) {
		if ($_ =~ /^ne/) {
			$x++;
			$y++;
			$_ =~ s/^\w\w(.*)$/$1/;
		} elsif ($_ =~ /^nw/) {
			$x--;
			$y++;
			$_ =~ s/^\w\w(.*)$/$1/;
		} elsif ($_ =~ /^se/) {
			$x++;
			$y--;
			$_ =~ s/^\w\w(.*)$/$1/;
		} elsif ($_ =~ /^sw/) {
			$x--;
			$y--;
			$_ =~ s/^\w\w(.*)$/$1/;
		} elsif ($_ =~ /^w/) {
			$x--;
			$x--;
			$_ =~ s/^\w(.*)$/$1/;
		} elsif ($_ =~ /^e/) {
			$x++;
			$x++;
			$_ =~ s/^\w(.*)$/$1/;
		}
	}
	&switchtile($x, $y);
}

my $count = keys %blacktiles;
print $count, "\n";
