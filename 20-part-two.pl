#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

my %tiles;
my $tileid;
my $boottileid;
no warnings 'recursion';

sub get_numbers {
	my ($input) = @_;
	my $text1 = join '', @$input;
	my $text2 = join '', reverse @$input;
	return [oct("0b".$text1), oct("0b".$text2)];
}

sub print_tile {
	my ($tileid) = @_;
	for (@{$tiles{$tileid}->{data}}) {
		my $text = join '', @$_;
		$text =~ s/1/#/g;
		$text =~ s/0/./g;
		$text =~ s/2/O/g;
		print $text, "\n";
	}
}

sub print_image_array {
	my ($array) = @_;
	for (@{$array}) {
		my $text = join '', @$_;
		$text =~ s/1/#/g;
		$text =~ s/0/./g;
		$text =~ s/2/O/g;
		print $text, "\n";
	}
}


while (<>) {
	chomp;
	if (/^\s*$/) { next }
	if (/^Tile (\d+):$/) {
		$tileid = $1;
		$tiles{$tileid} = {};
		$tiles{$tileid}->{data} = [];
		$boottileid = $tileid;
		next;
	}
	s/\./0/g;
	s/#/1/g;
	my @tmp = split //, $_;
	push @{$tiles{$tileid}->{data}}, \@tmp;
}

sub recalculate_NSWE {
	my ($tileid) = @_;
	my %results;
	my $sidelength = $#{$tiles{$tileid}->{data}->[0]};
	my (@leftarray, @rightarray);
	for (@{$tiles{$tileid}->{data}}) {
		push @leftarray, $_->[0];
		push @rightarray, $_->[$sidelength];
	}
	$results{N} = &get_numbers($tiles{$tileid}->{data}->[0]);
	$results{W} = &get_numbers(\@leftarray);
	$results{S} = &get_numbers($tiles{$tileid}->{data}->[$sidelength]);
	$results{E} = &get_numbers(\@rightarray);
	$tiles{$tileid}->{data2} = \%results;
}

sub flip {
	my ($object, $mode) = @_;
        my $sidelength = $#{$object->[0]};
	my $original_object = $object;

	if ($mode eq 'H') {
		for (my $i=0; $i <= $sidelength; $i++) {
			@{$object->[$i]} = reverse(@{$object->[$i]});
		}
	} elsif ($mode eq 'V') {
		my $newarray = [];
		for (my $i=0; $i <= $sidelength; $i++) {
			for (my $ii=0; $ii <= $sidelength; $ii++) {
				my $input = $object->[$i][$ii];
				$$newarray[$sidelength-$i][$ii] = $input;
			}
		}
		$object = $newarray;
	} else {
		print "error\n";
		exit(1);
	}
	@$original_object = @$object;
}

sub rotate_clockwise {
	my ($object,$times) = @_;
	my $original_object = $object;
	my $sidelength = $#{$object->[0]};
	for (1..$times) {
		my $newarray = [];
		for (my $i=0; $i <= $sidelength; $i++) {
			for (my $ii=0; $ii <= $sidelength; $ii++) {
				my $input = $object->[$i][$ii];
				$$newarray[$ii][$sidelength-$i] = $input;
			}
		}
		$object = $newarray;
	}
	@$original_object = @$object;
}

sub flip_tile {
	my ($tileid, $mode) = @_;
	my $object = $tiles{$tileid}->{data};
	&flip($object,$mode);
        &recalculate_NSWE($tileid);
}

sub rotate_clockwise_tile {
	my ($tileid,$times) = @_;
	my $object = $tiles{$tileid}->{data};
	&rotate_clockwise($object,$times);
	&recalculate_NSWE($tileid);
}


sub verify {
	my ($tile1, $tile2, $direction1,$direction2) = @_;
	if ($tiles{$tile1}->{data2}->{$direction1}->[0] == $tiles{$tile2}->{data2}->{$direction2}->[0]) {
		return 1;
	} else {
		return 0;
	}
}



sub arrange_tiles {
	my ($srctileid) = @_;
	my $combinations = [ ['S', 'N'], ['N', 'S'], ['E', 'W'], ['W', 'E'] ];
	for (@$combinations) {
		my $combination = $_;
		if (exists($tiles{$srctileid}->{$$combination[0]})) { next }
		for (keys %tiles) {
			my $dsttileid = $_;
			if ($srctileid == $dsttileid) { next }
			if (exists($tiles{$dsttileid}->{$$combination[1]})) { next }
			unless (exists($tiles{$dsttileid}->{N}) or exists($tiles{$dsttileid}->{S}) or exists($tiles{$dsttileid}->{E}) or exists($tiles{$dsttileid}->{W})) {
				for (1..4) {
					if (&verify($srctileid,$dsttileid,$$combination[0],$$combination[1])) { last }
					&rotate_clockwise_tile($dsttileid,1);
					if (&verify($srctileid,$dsttileid,$$combination[0],$$combination[1])) { last }
					for (1..2) {
						if (&verify($srctileid,$dsttileid,$$combination[0],$$combination[1])) { last }
						&flip_tile($dsttileid,'H');
						if (&verify($srctileid,$dsttileid,$$combination[0],$$combination[1])) { last }
						for (1..2) {
							if (&verify($srctileid,$dsttileid,$$combination[0],$$combination[1])) { last }
							&flip_tile($dsttileid,'V');
							if (&verify($srctileid,$dsttileid,$$combination[0],$$combination[1])) { last }
						}
					}
				}
			}
			if (&verify($srctileid,$dsttileid,$$combination[0],$$combination[1])) {
				$tiles{$srctileid}->{$$combination[0]} = $dsttileid;
				$tiles{$dsttileid}->{$$combination[1]} = $srctileid;
				&arrange_tiles($dsttileid);
				last;
			}
		}
		unless (exists($tiles{$srctileid}->{$$combination[0]})) {
			$tiles{$srctileid}->{$$combination[0]} = 0;
		}
	}

}

sub remove_borders {
	for (keys %tiles) {
		my $newarray = [];
		my $sidelength = $#{$tiles{$_}->{data}->[0]};
		for (my $i=1; $i <= $sidelength-1; $i++) {
			my $current = [];
			push @$newarray, $current;
			for (my $ii=1; $ii <= $sidelength-1; $ii++) {
				push @$current, $tiles{$_}->{data}->[$i]->[$ii];
			}
		}
		$tiles{$_}->{data} = $newarray;
	}
}

sub find_north_west {
	my $currentid = $boottileid;
	while (1) {
		if ($tiles{$currentid}->{W} != 0) {
			$currentid = $tiles{$currentid}->{W};
		} else {
			last;
		}
	}
	while (1) {
		if ($tiles{$currentid}->{N} != 0) {
			$currentid = $tiles{$currentid}->{N};
		} else {
			last;
		}
	}
	return $currentid;
}

sub build_image_array {
	my $array = [];
	my $firstid = &find_north_west;
	my $sidelength = $#{$tiles{$firstid}->{data}->[0]};

	while (1) {
		my @ordered_tilesid = ($firstid);
		while (1) {
			if ($tiles{$ordered_tilesid[$#ordered_tilesid]}->{E} != 0) {
				push @ordered_tilesid, $tiles{$ordered_tilesid[$#ordered_tilesid]}->{E};
			} else {
				last;
			}
		}
		for (my $i=0; $i <= $sidelength; $i++) {
			my $temp = [];
			push @$array, $temp;
			for (@ordered_tilesid) {
				push @$temp, @{$tiles{$_}->{data}->[$i]}
			}
		}



		if ($tiles{$firstid}->{S} != 0) {
			$firstid = $tiles{$firstid}->{S};
		} else {
			last;
		}
	}
	return $array;
}

sub find_monsters {
	my ($image) = @_;
	my $pattern = [
	       	[ 0, 18 ],
	       	[ 1, 0 ],
	       	[ 1, 5 ],
	       	[ 1, 6 ],
	       	[ 1, 11 ],
	       	[ 1, 12 ],
	       	[ 1, 17 ],
	       	[ 1, 18 ],
	       	[ 1, 19 ],
	       	[ 2, 1 ],
	       	[ 2, 4 ],
	       	[ 2, 7 ],
	       	[ 2, 10 ],
	       	[ 2, 13 ],
	       	[ 2, 16 ]
	];
	my $imagecopy = [];
	for (@$image) {
		my @linecopy = @$_;
		push @$imagecopy, \@linecopy;
	}
	my $sidelength = $#{$imagecopy->[0]};
	my $found = 0;
	for (my $y=0; $y <= $sidelength; $y++) {
		for (my $x=0; $x <= $sidelength; $x++) {
			my $match = 0;
			for (@$pattern) {
				my $local_y = $y + $$_[0];
				my $local_x = $x + $$_[1];
				unless (defined($imagecopy->[$local_y])) { last }
				unless (defined($imagecopy->[$local_y]->[$local_x])) { last }
				if ($imagecopy->[$local_y]->[$local_x] == 1 ) {
					$match++;
				} else {
					last;
				}
			}
			if ($match == scalar @$pattern) {
				$found++;
				for (@$pattern) {
					my $local_y = $y + $$_[0];
					my $local_x = $x + $$_[1];
					$imagecopy->[$local_y]->[$local_x] = 2;
				}
			}
		}
	}
	return [$found, $imagecopy];
}

sub count_sharpes {
	my ($object) = @_;
	my $count = 0;
	for (@$object) {
		for (@$_) {
			if ($_ == 1) { $count++ }
		}
	}
	return $count;
}


for (keys %tiles) {
	&rotate_clockwise_tile($_,0);
}

&arrange_tiles($boottileid);
&remove_borders;
my $image = &build_image_array;


my $end = 0;
for (1..4) {
	if ($end or (&find_monsters($image)->[0] != 0)) { $end = 1; last }
	&rotate_clockwise($image,1);
	if ($end or (&find_monsters($image)->[0] != 0)) { $end = 1; last }
	for (1..2) {
		if ($end or (&find_monsters($image)->[0] != 0)) { $end = 1; last }
		&flip($image,'H');
		if ($end or (&find_monsters($image)->[0] != 0)) { $end = 1; last }
		for (1..2) {
			if ($end or (&find_monsters($image)->[0] != 0)) { $end = 1; last }
			&flip_tile($image,'V');
			if ($end or (&find_monsters($image)->[0] != 0)) { $end = 1; last }
		}
	}
}

my $result = &find_monsters($image);
#print "monsters found: $result->[0]\n";
#&print_image_array($result->[1]);
print &count_sharpes($result->[1]), "\n";
