#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

my $ingredients = {};
my $allergens = {};
while (<>) {
	chomp;
	my ($part1, $part2);
	unless (/^([^\(]+)\(contains\s+([^\)]+)\)$/) { print "error\n"; exit(1) }
	($part1, $part2) = ($1, $2);
	my @localingredients = split /\s+/, $part1;
	my @localallergens = split /,\s+/, $part2;
	for (@localingredients) {
		my $myingredient = $_;
		unless (exists($ingredients->{$_})) {
			$ingredients->{$myingredient} = {};
			$ingredients->{$myingredient}->{allergens} = {};
			$ingredients->{$myingredient}->{appearcount} = 0;
		}
		$ingredients->{$myingredient}->{appearcount}++;
		for (@localallergens) {
			my $myallergen = $_;
			unless (exists($ingredients->{$myingredient}->{allergens}->{$myallergen})) {
				$ingredients->{$myingredient}->{allergens}->{$myallergen} = 0;
			}
			$ingredients->{$myingredient}->{allergens}->{$myallergen}++;
		}
	}
	for (@localallergens) {
		unless (exists($allergens->{$_})) { $allergens->{$_} = 0 }
		$allergens->{$_}++;
	}
}

for (keys %{$ingredients}) {
	my $myingredient = $_;
	my $matchcount = 0;
	for (keys %{$ingredients->{$myingredient}->{allergens}}) {
		my $myallergen = $_;
		if ($ingredients->{$myingredient}->{allergens}->{$myallergen} == $allergens->{$myallergen}) {
			$matchcount++;
			last;
		}
	}
	if ($matchcount > 0) {
		$ingredients->{$myingredient}->{noallergens} = 0;
	} else {
		$ingredients->{$myingredient}->{noallergens} = 1;
	}
}

my $total = 0;
for (keys %{$ingredients}) {
	if ($ingredients->{$_}->{noallergens} == 1) {
		$total = $total + $ingredients->{$_}->{appearcount};
	}
}
print $total, "\n";
