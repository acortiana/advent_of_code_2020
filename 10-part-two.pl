#!/usr/bin/perl
#
use warnings;
use strict;
no warnings 'recursion';


my @array1;
while (<>) {
	chomp;
	push @array1, $_;
}

my @array2 = sort { $a <=> $b } @array1;
push @array2, $array2[$#array2] + 3;
unshift @array2, 0;

sub recursive_function {
	my ($start,$end,$ary) = @_;
	my $result = 0;
	if ($start == $end) { return 1; }
	my $value = $$ary[$start];
	for (my $i = $start+1; $i <= $end; $i++) {
		if ($$ary[$i] <= ($value + 3)) {
			$result = $result + &recursive_function($i,$end,$ary);
		} else {
			last;
		}
	}
	return $result;
}

my $start = 0;
my $end = 0;
my $count = 0;
my $total = 1;
for (my $i = 0; $i <= $#array2; $i++) {
	my $diff = $array2[$i] - $array2[$i-1];
	if ($diff < 3) {
		$count++;
		next;
	}
	if (($count > 1) and (($array2[$i] - $array2[$i - 1]) == 3)) {
		$total = $total * &recursive_function($start, $i - 1, \@array2);
	}
	$start = $i;
	$count = 0;
}

print $total, "\n";
