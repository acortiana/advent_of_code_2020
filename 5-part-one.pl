#!/usr/bin/perl
#
use warnings;
use strict;

my $highest_seat_id = 0;
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
    $encoded_column =~ s/L/0/g;
    $encoded_column =~ s/R/1/g;
    $column = oct("0b$encoded_column");
    $seat_id = ($row * 8) + $column;
    if ($highest_seat_id < $seat_id) {
	    $highest_seat_id = $seat_id;
    }
}
print "$highest_seat_id\n";

