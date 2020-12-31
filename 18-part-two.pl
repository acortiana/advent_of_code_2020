#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

my $sum = 0;
while (<>) {
	chomp;
	my @abc = &parser1($_);
	$sum = $sum + &solve1(\@abc);
}
print $sum, "\n";

sub parenthesis_block {
        my ($input) = @_;
        my @chars = split //, $input;
        my @result;
        my $counter = 0;
        for (@chars) {
                if ($_ eq "(") { $counter++ }
                if ($_ eq ")") { $counter-- }
                push @result, $_;
                if ($counter == 0) { last }
        }
        my $result2 = join('', @result);
        return $result2;
}

sub parser1 {
	my ($input) = @_;
	my @result;
	my $parsed;
	while (not ($input =~ /^$/)) {
		if ($input =~ /^(\d+)/) {
			$parsed = $1;
			push @result, $parsed;
		} elsif ($input =~ /^(\s+)/) {
			$parsed = $1;
		} elsif ($input =~ /^\(/) {
			$parsed = &parenthesis_block($input);
			my $parsed2 = $parsed;
			$parsed2 =~ s/^\(//;
			$parsed2 =~ s/\)$//;
			my @tmp = &parser1($parsed2);
			push @result, \@tmp;
		} elsif ($input =~ /^(\))/) {
			last;
		} elsif ($input =~ /^([+*])/) {
			$parsed = $1;
			push @result, $parsed;
		}
		my $parsedcount = length($parsed);
		$input =~ s/^.{$parsedcount}(.*)$/$1/;
	}
	return @result
}

sub searchplus {
	my ($input) = @_;
	my $plus = 0;
	for (@$input) {
		if ($_ eq "+") { $plus++ }
	}
	return $plus;
}

sub solve1 {
	my ($input) = @_;
	my @array;
	my $i = 0;
	while (1) {
		if ($#{$input} == 0) { last }
		my $foundplus = &searchplus($input);
		if (ref($input->[$i]) ne '') {
			$input->[$i] = &solve1($input->[$i]);
		}
		push @array, $input->[$i];
		if ($#array == 2) {
			if ($foundplus and $array[1] eq "*") {
				@array = ($array[2]);
			} else {
				if ($array[1] eq "*") {
					$input->[$i] = $array[0] * $array[2];
				} else {
					$input->[$i] = $array[0] + $array[2];
				}
				splice @$input, $i-2, 2;
			}
		}
		if ($i < $#{$input}) {
			$i++;
		} else {
			$i = 0;
			@array = ();
		}
	}
	return $input->[0];
}


