#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

sub get_numbers {
	my ($input) = @_;
	my $text1 = join '', @$input;
	my $text2 = join '', reverse @$input;
	return [oct("0b".$text1), oct("0b".$text2)];
}

my %tiles;
my $tileid;
my %tilescount;
while (<>) {
	chomp;
	if (/^\s*$/) { next }
	if (/^Tile (\d+):$/) {
		$tileid = $1;
		$tiles{$tileid} = {};
		$tiles{$tileid}->{data} = [];
		next;
	}
	s/\./0/g;
	s/#/1/g;
	my @tmp = split //, $_;
	push @{$tiles{$tileid}->{data}}, \@tmp;
}

for (keys %tiles) {
	my %results;
	my $sidelength = $#{$tiles{$_}->{data}->[0]};
	my (@leftarray, @rightarray);
	for (@{$tiles{$_}->{data}}) {
		push @leftarray, $_->[0];
		push @rightarray, $_->[$sidelength];
	}
	$results{N} = &get_numbers($tiles{$_}->{data}->[0]);
	$results{W} = &get_numbers(\@leftarray);
	$results{S} = &get_numbers($tiles{$_}->{data}->[$sidelength]);
	$results{E} = &get_numbers(\@rightarray);
	for (keys %results) {
		for (@{$results{$_}}) {
			if (exists($tilescount{$_})) {
				$tilescount{$_}++;
			} else {
				$tilescount{$_} = 1;
			}
		}
	}
	$tiles{$_}->{data2} = \%results;
}

my $combinations = [['N','E'], ['N','W'], ['S','E'], ['S','W']];
my @result_tiles;
for (keys %tiles) {
	my $tileid = $_;
	my $result = 0;
	for (@$combinations) {
		my $nomatchcount = 0;
		for (@$_) {
			for (@{$tiles{$tileid}->{data2}->{$_}}) {
				$nomatchcount = $nomatchcount + $tilescount{$_};
			}
		}
		if ($nomatchcount == 4) {
			$result = 1;
			last;
		}
	}
	if ($result == 1) {
		push @result_tiles, $tileid;
	}
}
my $result = 1;
for (@result_tiles) {
	$result = $result * $_;
}
print $result, "\n";

#print Dumper(%tiles);
#print Dumper(%tilescount);
