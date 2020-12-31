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
		for (my $xshift = -1; $xshift < 2; $xshift++) {
			if (($xshift == 0) and ($yshift == 0)) { next }
			my $cur_y = $y;
			my $cur_x = $x;
			while (1) {
				$cur_y = $cur_y + $yshift;
				$cur_x = $cur_x + $xshift;
				if (($cur_y < 0) or ($cur_y > $#$array)) { last; }
				if (($cur_x < 0) or ($cur_x > $#{@$array[$cur_y]})) { last; }
				if ($$array[$cur_y][$cur_x] eq "#") { $sum++; last; }
				if ($$array[$cur_y][$cur_x] eq "L") { last; }
			}
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
				if ($adj >= 5) { $$newarray[$y][$x] = "L"; next }
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
