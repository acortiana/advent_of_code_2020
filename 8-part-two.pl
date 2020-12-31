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


sub try_run {
	my $change_ins_pointer = shift;
	my $ins_pointer = 0;
	my $last_ins_pointer = $#$data;
	my $acc = 0;
	for (@$data) {
		$$_{execs} = 0;
	}
	while (($ins_pointer >=0) and ($ins_pointer <= $last_ins_pointer)) {
		my $ins = $$data[$ins_pointer];
		if ($$ins{execs} == 1) {
			return -1;
		}
		my $instruction = $$ins{ins};
		if ($ins_pointer == $change_ins_pointer) {
			if ($instruction eq "jmp") {
				$instruction = "nop";
			} elsif ($instruction eq "nop") {
				$instruction = "jmp";
			}
		}
		if ($instruction eq "acc") {
			$acc = $acc + $$ins{arg};
			$ins_pointer++;
		} elsif ($instruction eq "jmp") {
			$ins_pointer = $ins_pointer + $$ins{arg}
		} elsif ($instruction eq "nop") {
			$ins_pointer++;
		}
		$$ins{execs}++;
	}
	return $acc;
}

for (my $i = 0; $i <= $#$data; $i++) {
	my $result = &try_run($i);
	if ($result != -1) {
		print $result, "\n";
		last;
	}
}
