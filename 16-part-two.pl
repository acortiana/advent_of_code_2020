#!/usr/bin/perl
#
use warnings;
use strict;
use Data::Dumper;

my $counter = 1;
my @rules;
my %rules_hash;
my $error_rate = 0;
my @abc;
my @myticket;
my %rules_number;
my %rules_number2;

sub verify_range {
	my ($value, $range) = @_;
	my ($min, $max) = split /-/, $range;
	if (($value < $min) or ($value > $max)) { return 0 }
	return 1;
}

while (<>) {
	chomp;
	if (/^$/) { $counter++; next; }
	if ($counter == 1) {
		unless (/([^:]+): (\d+-\d+) or (\d+-\d+)/) { print "error"; exit(1) }
		my ($name, $range1, $range2) = ($1, $2, $3);
		$rules_hash{$name} = [];
		push @{$rules_hash{$name}}, $range1;
		push @{$rules_hash{$name}}, $range2;
		push @rules, $range1;
		push @rules, $range2;
	} elsif ($counter == 2) {
		if (/^your ticket/) { next }
		@myticket = split /,/, $_;
	} elsif ($counter == 3) {
		if (/^nearby/) { next }
		my @values = split /,/, $_;
		for (my $i=0; $i <= $#values; $i++) {
			my $value = $values[$i];
			my $match = 0;
			for (@rules) {
				if (verify_range($value, $_)) { $match = 1; last; }
			}
			if ($match == 0) { last; }
			unless (defined($abc[$i])) { $abc[$i] = [] }
			push @{$abc[$i]}, $value;
		}
	}
}

for (my $i=0; $i <= $#abc; $i++) {
	for (keys %rules_hash) {
		my $match = 0;
		my $name = $_;
		for (@{$abc[$i]}) {
			my $value = $_;
			for (@{$rules_hash{$name}}) {
				if (verify_range($value, $_)) { $match++; last; }
			}
		}
		if ($match == (scalar @{$abc[$i]})) {
			unless (exists($rules_number{$i})) { $rules_number{$i} = {} }
			$rules_number{$i}->{$name} = 1;
		}
	}
}

while (scalar keys %rules_number > 0) {
	for (keys %rules_number) {
		my $i = $_;
		my $keycount = 0;
		my $curkey;
		for (keys %{$rules_number{$i}}) {
			$curkey = $_;
			$keycount++;
		}
		if ($keycount == 1) {
			$rules_number2{$i} = $curkey;
			delete($rules_number{$i});
			for (keys %rules_number) {
				$i = $_;
				if (exists($rules_number{$i}->{$curkey})) {
					delete($rules_number{$i}->{$curkey});
				}
			}
		}
	}
}

my $result = 1;
for (my $i=0; $i <= $#myticket; $i++) {
	my $name = $rules_number2{$i};
	if ($name =~ /^departure/) {
		$result = $result * $myticket[$i];
	}
}
print $result, "\n";
