#!/usr/bin/perl
#
use warnings;
use strict;
use Data::Dumper;

my $input = [ [] ];
my $z_size = 0;
my $y_size = 0;
while (<>) {
	chomp;
	$y_size++;
	my @temp = split //, $_;
	push @{$input->[0]}, \@temp,
}

sub expand {
	my ($input) = @_;
	my $output = [];
	my $z_size = $#{$input};
	my $y_size = $#{$input->[0]};
	my $x_size = $#{$input->[0]->[0]};
	for (my $z=0; $z <= $z_size + 2; $z++) {
		unless (exists($output->[$z])) { $output->[$z] = [] }
		for (my $y=0; $y <= $y_size + 2; $y++) {
			unless (exists($output->[$z]->[$y])) { $output->[$z]->[$y] = [] }
			for (my $x=0; $x <= $x_size + 2; $x++) {
				#unless (exists($output->[$z]->[$y]->[$x])) { $output->[$z]->[$y]->[$x] = [] }
				if (($z == 0) or ($y == 0) or ($x == 0)) { $output->[$z]->[$y]->[$x] = "."; next }
				if (($z == $z_size+2) or ($y == $y_size+2) or ($x == $x_size+2)) { $output->[$z]->[$y]->[$x] = "."; next }
				$output->[$z]->[$y]->[$x] = $input->[$z-1]->[$y-1]->[$x-1];
			}
		}
	}
	return ($output);
}

sub verify {
	my ($input, $z, $y, $x) = @_;
	my $count = 0;
	for (my $zz = -1; $zz <= 1; $zz++) {
		for (my $yy = -1; $yy <= 1; $yy++) {
			for (my $xx = -1; $xx <= 1; $xx++) {
				if (($zz == 0) and ($yy == 0) and ($xx == 0)) { next }
				my $local_z = $z + $zz;
				my $local_y = $y + $yy;
				my $local_x = $x + $xx;
				if (($local_z < 0) or ($local_y < 0) or ($local_x < 0)) { next }
				unless (exists($input->[$local_z])) { next }
				unless (exists($input->[$local_z]->[$local_y])) { next }
				unless (exists($input->[$local_z]->[$local_y]->[$local_x])) { next }
				if ($input->[$local_z]->[$local_y]->[$local_x] eq "#") { $count++ }
			}
		}
	}
	if ($input->[$z]->[$y]->[$x] eq "#") {
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
				if ($_ eq "#") { $count++ }
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
	for (my $z=0; $z <= $#{$in}; $z++) {
		for (my $y=0; $y <= $#{$in->[$z]}; $y++) {
			for (my $x=0; $x <= $#{$in->[$z]->[$y]}; $x++) {
				$out->[$z]->[$y]->[$x] = &verify($in, $z, $y, $x);
			}
		}
	}
	$in = $out;
}
print &count($in), "\n";

