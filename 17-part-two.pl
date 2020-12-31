#!/usr/bin/perl
#
use warnings;
use strict;
use Data::Dumper;

my $input = [ [ [] ] ];
my $w_size = 0;
my $z_size = 0;
my $y_size = 0;
while (<>) {
	chomp;
	$y_size++;
	my @temp = split //, $_;
	push @{$input->[0]->[0]}, \@temp,
}

sub expand {
	my ($input) = @_;
	my $output = [];
	my $w_size = $#{$input};
	my $z_size = $#{$input->[0]};
	my $y_size = $#{$input->[0]->[0]};
	my $x_size = $#{$input->[0]->[0]->[0]};
	for (my $w=0; $w <= $w_size + 2; $w++) {
		unless (exists($output->[$w])) { $output->[$w] = [] }
		for (my $z=0; $z <= $z_size + 2; $z++) {
			unless (exists($output->[$w]->[$z])) { $output->[$w]->[$z] = [] }
			for (my $y=0; $y <= $y_size + 2; $y++) {
				unless (exists($output->[$w]->[$z]->[$y])) { $output->[$w]->[$z]->[$y] = [] }
				for (my $x=0; $x <= $x_size + 2; $x++) {
					if (($w == 0) or ($z == 0) or ($y == 0) or ($x == 0)) { $output->[$w]->[$z]->[$y]->[$x] = "."; next }
					if (($w == $w_size+2) or ($z == $z_size+2) or ($y == $y_size+2) or ($x == $x_size+2)) {
						$output->[$w]->[$z]->[$y]->[$x] = ".";
						next;
				       	}
					$output->[$w]->[$z]->[$y]->[$x] = $input->[$w-1]->[$z-1]->[$y-1]->[$x-1];
				}
			}
		}
	}
	return ($output);
}

sub verify {
	my ($input, $w, $z, $y, $x) = @_;
	my $count = 0;
	for (my $ww = -1; $ww <= 1; $ww++) {
		for (my $zz = -1; $zz <= 1; $zz++) {
			for (my $yy = -1; $yy <= 1; $yy++) {
				for (my $xx = -1; $xx <= 1; $xx++) {
					if (($ww == 0) and ($zz == 0) and ($yy == 0) and ($xx == 0)) { next }
					my $local_w = $w + $ww;
					my $local_z = $z + $zz;
					my $local_y = $y + $yy;
					my $local_x = $x + $xx;
					if (($local_w < 0) or ($local_z < 0) or ($local_y < 0) or ($local_x < 0)) { next }
					unless (exists($input->[$local_w])) { next }
					unless (exists($input->[$local_w]->[$local_z])) { next }
					unless (exists($input->[$local_w]->[$local_z]->[$local_y])) { next }
					unless (exists($input->[$local_w]->[$local_z]->[$local_y]->[$local_x])) { next }
					if ($input->[$local_w]->[$local_z]->[$local_y]->[$local_x] eq "#") { $count++ }
				}
			}
		}
	}
	if ($input->[$w]->[$z]->[$y]->[$x] eq "#") {
		if (($count == 2) or ($count == 3)) {
			return "#";
		} else {
			return ".";
		}
	} else {
		if ($count == 3) {
			return "#";
		} else {
			return ".";
		}
	}
}

sub count {
	my ($input) = @_;
	my $count = 0;
	for (@$input) {
		for (@$_) {
			for (@$_) {
				for (@$_) {
					if ($_ eq "#") { $count++ }
				}
			}
		}
	}
	return $count;
}


# Main
my $in = $input;
my $out;
for (my $i = 1; $i <= 6; $i++) {
	my $tmp = $in;
	$out = &expand($tmp);
	$in = &expand($tmp);
	for (my $w=0; $w <= $#{$in}; $w++) {
		for (my $z=0; $z <= $#{$in->[$w]}; $z++) {
			for (my $y=0; $y <= $#{$in->[$w]->[$z]}; $y++) {
				for (my $x=0; $x <= $#{$in->[$w]->[$z]->[$y]}; $x++) {
					$out->[$w]->[$z]->[$y]->[$x] = &verify($in, $w, $z, $y, $x);
				}
			}
		}
	}
	$in = $out;
}
print &count($in), "\n";

