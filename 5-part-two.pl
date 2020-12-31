#!/usr/bin/perl
#
use warnings;
use strict;

my %seats_list;
while (<>) {
    my ($encoded_row, $encoded_column, $row, $column, $seat_id);
    chomp;
    unless (/(^[FB]{7})([RL]{3})$/) {
        print "error\n";
	exit(1);
    }
    ($encoded_row, $encoded_column) = ($1,$2);
    $encoded_row =~ s/F/0/g;
    $encoded_row =~ s/B/1/g;
    $row = oct("0b$encoded_row");
    if ($row == 0) { next }
    if ($row == 127) { next }
    $encoded_column =~ s/L/0/g;
    $encoded_column =~ s/R/1/g;
    $column = oct("0b$encoded_column");
    $seat_id = ($row * 8) + $column;
    $seats_list{$seat_id} = 1
}


for (keys %seats_list) {
	my $entry_one = $_;
	for (keys %seats_list) {
		my $entry_two = $_;
		if (($entry_one - $entry_two) == 2) {
			my $result = $entry_one - 1;
			if (exists($seats_list{$result})) { next }
			print $result, "\n";
			exit(0);
		}
	}
}
