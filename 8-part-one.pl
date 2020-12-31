#!/usr/bin/perl
#
use warnings;
use strict;
use Data::Dumper;

my $data = [];
while (<>) {
	chomp;
	unless (/(\w\w\w)\s+([\d+-]+)/) { print "error\n"; exit(1) };
	my ($instruction, $argument) = ($1, $2);
	my %hash;
	push @$data, \%hash;
	$hash{ins} = $instruction;
	$hash{arg} = $argument;
	$hash{execs} = 0;
}

my $ins_pointer = 0;
my $last_ins_pointer = $#$data;
my $acc = 0;
while (($ins_pointer >=0) and ($ins_pointer <= $last_ins_pointer)) {
	my $ins = $$data[$ins_pointer];
	if ($$ins{execs} == 1) {
		print $acc, "\n";
		exit(0);
	}
	if ($$ins{ins} eq "acc") {
		$acc = $acc + $$ins{arg};
		$ins_pointer++;
	} elsif ($$ins{ins} eq "jmp") {
		$ins_pointer = $ins_pointer + $$ins{arg}
	} elsif ($$ins{ins} eq "nop") {
		$ins_pointer++;
	}
	$$ins{execs}++;
}
print "instruction pointer out of range: $ins_pointer\n";
exit(1);
