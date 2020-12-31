#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

my $ingredients = {};
my $allergens = {};
my $allergens2 = {};
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
	unless ($matchcount > 0) {
		delete($ingredients->{$myingredient});
	}
}

while (1) {
	for (keys %{$allergens}) {
		my $myallergen = $_;
		my $count = 0;
		my $ingredient;
		for (keys %{$ingredients}) {
			my $myingredient = $_;
			if ($ingredients->{$myingredient}->{allergens}->{$myallergen} == $allergens->{$myallergen}) {
				$ingredient = $myingredient;
				$count++;
			}
		}
		if ($count == 1) {
			$allergens2->{$myallergen} = $ingredient;
			delete($ingredients->{$ingredient});
			delete($allergens->{$myallergen});
		}
	}
	if (keys %{$allergens} == 0) { last }
}

my @dangerous_ingredients;
for (sort keys %{$allergens2}) {
	push @dangerous_ingredients, $allergens2->{$_};
}
print join(',', @dangerous_ingredients);
print "\n";


