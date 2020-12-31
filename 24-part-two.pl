#!/usr/bin/perl
#
use warnings;
use strict;

my $blacktiles = {};

sub switchtile {
	my ($x, $y, $blacktiles) = @_;
	if (exists($blacktiles->{"$x,$y"})) {
		delete($blacktiles->{"$x,$y"});
	} else {
		$blacktiles->{"$x,$y"} = 1;
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
	&switchtile($x, $y,$blacktiles);
}

sub neighbor_coordinates {
	my ($coordinates) = @_;
	my ($x, $y) = split /,/, $coordinates;
	my @result;
	push @result, join ',', $x-1, $y-1;
	push @result, join ',', $x-1, $y+1;
	push @result, join ',', $x+1, $y-1;
	push @result, join ',', $x+1, $y+1;
	push @result, join ',', $x-2, $y;
	push @result, join ',', $x+2, $y;
	return \@result;
}

sub tile_needs_switching {
	my ($coordinates,$blacktiles) = @_;
	my ($x, $y) = split /,/, $coordinates;
	my $blacktilesaround_count = 0;
	my $neigh_coordinates_ref = &neighbor_coordinates($coordinates);
	for (@$neigh_coordinates_ref) {
		my ($testx, $testy) = split /,/, $_;
		if (exists($blacktiles->{"$testx,$testy"})) { $blacktilesaround_count++ }
	}
	if (exists($blacktiles->{"$x,$y"})) {
		if (($blacktilesaround_count == 0) or ($blacktilesaround_count > 2)) {
			return 1;
		} else {
			return 0;
		}
	} else {
		if ($blacktilesaround_count == 2) {
			return 1;
		} else {
			return 0;
		}
	}
}

sub do_one_round {
	my $newblacktiles = {};
	%$newblacktiles = %$blacktiles;
	my %tobechecked_tiles;
	for (keys %$blacktiles) {
		$tobechecked_tiles{$_} = 1;
		my $neigh_coordinates = &neighbor_coordinates($_);
		for (@$neigh_coordinates) {
			$tobechecked_tiles{$_} = 1;
		}
	}
	for (keys %tobechecked_tiles) {
		if (&tile_needs_switching($_,$blacktiles)) {
			my ($x, $y) = split /,/, $_;
			&switchtile($x, $y, $newblacktiles);
		}
	}
	$blacktiles = $newblacktiles;
}

for (1..100) {
	&do_one_round;
}

my $result = keys %$blacktiles;
print $result, "\n";
