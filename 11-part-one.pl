#!/usr/bin/perl
#
use warnings;
use strict;

my $array1 = ();
my $array2 = ();
while (<>) {
	chomp;
	my @line = split //, $_;
	push @$array1, \@line;
}

sub occupied_adjacent {
	my ($y, $x, $array) = @_;
	my $sum = 0;
	for (my $yshift = -1; $yshift < 2; $yshift++) {
		my $localy = $y + $yshift;
		if (($localy < 0) or ($localy > $#$array)) { next }
		for (my $xshift = -1; $xshift < 2; $xshift++) {
			if (($xshift == 0) and ($yshift == 0)) { next }
			my $localx = $x + $xshift;
			if (($localx < 0) or ($localx > $#{@$array[$localy]})) { next }
			if ($$array[$localy][$localx] eq "#") { $sum++ }
		}
	}
	return $sum;
}

sub count_occupied_seats {
	my $array = shift;
	my $sum = 0;
	for (@$array) {
		my $asd = $_;
		for (@$asd) {
			if ($_ eq "#") { $sum++ }
		}
	}
	return $sum;
}

my $oldseats = 0;
my $newseats = -1;
my $oldarray = $array1;
my $newarray = ();
while ($oldseats != $newseats) {
	for (my $y=0; $y <= $#$oldarray; $y++) {
		$$newarray[$y] = ();
		for (my $x=0; $x <= $#{@$oldarray[$y]}; $x++) {
			my $adj = &occupied_adjacent($y,$x,$oldarray);
			if ($$oldarray[$y][$x] eq "#") {
				if ($adj >= 4) { $$newarray[$y][$x] = "L"; next }
			} elsif ($$oldarray[$y][$x] eq "L") {
				if ($adj == 0) { $$newarray[$y][$x] = "#"; next }
			}
			$$newarray[$y][$x] = $$oldarray[$y][$x];
		}
	}
	$newseats = &count_occupied_seats($newarray);
	$oldseats = &count_occupied_seats($oldarray);
	$oldarray = $newarray;
	$newarray = ();
}
print $newseats, "\n";
