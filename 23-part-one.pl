#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;
my $input = <STDIN>;
chomp $input;
my @objects;
my %objects2;
my @cups_sorted;
my $debug = 0;

my @cups_original_order;
for (split //, $input) {
	my $tmp = {};
	$tmp->{value} = $_;
	push @objects, $tmp;
	push @cups_original_order, $_;
	$objects2{$_} = $tmp;
}
@cups_sorted = sort { $a <=> $b } @cups_original_order;

for (my $i=0; $i <= $#objects; $i++) {
	my ($prev, $next);
	if ($i == 0) {
		$objects[$i]->{prev} = $objects[$#objects]
	} elsif ($i == $#objects) {
		$objects[$i]->{next} = $objects[0];
	}
	unless (defined($objects[$i]->{prev})) {
		$objects[$i]->{prev} = $objects[$i-1];
	}
	unless (defined($objects[$i]->{next})) {
		$objects[$i]->{next} = $objects[$i+1];
	}
}

sub get_destination_cup {
	my ($current_cup,$picked_up_cups) = @_;
	my $target_value = $current_cup - 1;
	my $destionation_cup;
	my %allowedcups = map { $_ => 1 } @cups_sorted;
	for (@$picked_up_cups) {
		delete($allowedcups{$_});
	}
	for (my $i = $target_value; ; $i--) {
		if ($i < $cups_sorted[0]) { $i = $cups_sorted[$#cups_sorted] }
		if (exists($allowedcups{$i})) {
			$debug and print "next cup $i\n";
			return $i;
		}
	}
}

sub do_one_round {
	my ($current_cup) = @_;
	my @picked_up_cups = (
		$objects2{$current_cup}->{next}->{value}, 
		$objects2{$current_cup}->{next}->{next}->{value}, 
		$objects2{$current_cup}->{next}->{next}->{next}->{value}
	);
	my $dest_cup = &get_destination_cup($current_cup,\@picked_up_cups);
	$objects2{$current_cup}->{next} = $objects2{$current_cup}->{next}->{next}->{next}->{next};
	$objects2{$current_cup}->{next}->{prev} = $objects2{$current_cup};

	$objects2{$picked_up_cups[2]}->{next} = $objects2{$dest_cup}->{next};
	$objects2{$picked_up_cups[0]}->{prev} = $objects2{$dest_cup};
	$objects2{$dest_cup}->{next}->{prev} = $objects2{$picked_up_cups[2]};
	$objects2{$dest_cup}->{next} = $objects2{$picked_up_cups[0]};
	return $objects2{$current_cup}->{next}->{value};
}

$debug and print "input: $input\n";
#my $current_cup = $objects2{1}->{next}->{value};
my $current_cup = $cups_original_order[0];
for (1..100) {
	$debug and print "count: $_\n";
	$debug and print "current cup: $current_cup\n";
	$debug and print "values before round: ";
	$debug and print &return_values($current_cup);
	$debug and print "\n";
	$current_cup = &do_one_round($current_cup);
}


sub return_values {
	my ($current_cup) = @_;
	my $result = '';
	for (1..scalar @cups_sorted) {
		my $value = $objects2{$current_cup}->{next}->{value};
		$result = $result . $value;
		$current_cup = $value;
	}
	return $result;
}

my $result = return_values(1);
$result =~ s/1//g;
print $result;
print "\n";
#print Dumper($objects[0]);
