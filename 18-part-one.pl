#!/usr/bin/perl

use warnings;
use strict;

my $sum = 0;
while (<>) {
	chomp;
	$sum = $sum + &solve1($_);
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
	$result2 =~ s/^\(//;
	$result2 =~ s/\)$//;
	return $result2;
}

sub solve1 {
	my ($input) = @_;
	my $tmp = $input;
	my $partial;
	while (1) {
		if ($tmp =~ /^\s*(\d+)\s*([+*])\s*(\d+)/) {
			my ($first, $operand, $second) = ($1, $2, $3);
			if ($operand eq "+") { $partial = $first + $second }
			if ($operand eq "*") { $partial = $first * $second }
			$tmp =~ s/^\d+\s*[+*]\s*\d+/$partial/;
		} elsif ($tmp =~ /^\s*(\d+)\s*([+*])\s*(\(.*)$/) {
			my ($first, $operand, $rest) = ($1, $2, $3);
			my $tmp2 = &parenthesis_block($rest);
			my $tmp2_quotemeta = quotemeta($tmp2);
			my $solved = &solve1($tmp2);
			unless (defined($solved)) {
				print "error\n";
				exit(1);
			}
			if ($operand eq "+") { $partial = $first + &solve1($tmp2) }
			if ($operand eq "*") { $partial = $first * &solve1($tmp2) }
			unless ($tmp =~ s/^\s*\d+\s*[+*]\s*\(\s*$tmp2_quotemeta\s*\)/$partial/) {
				print "error\n";
				exit(1);
			}
		} elsif ($tmp =~ /^\(/) {
			my $tmp2 = &parenthesis_block($tmp);
			my $tmp2_quotemeta = quotemeta($tmp2);
			$partial = &solve1($tmp2);
			unless ($tmp =~ s/^\(\s*$tmp2_quotemeta\s*\)/$partial/) {
				print "error\n";
				exit(1);
			}
		} else {
			last;
		}
	}
	return $partial;
}
