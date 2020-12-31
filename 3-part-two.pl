#!/usr/bin/perl
#
use warnings;
use strict;

my $linelength;
my @items;

my $junk_first_line = <STDIN>;
while (<>) {
    chomp;
    $linelength = length($_);
    my @linechars;
    @linechars = split //, $_;
    push @items, \@linechars;
}

sub count_trees {
    my ($horizontal_shift, $vertical_shift) = @_;
    my $horizontal = 0;
    my $vertical = 0;
    my $tree_count = 0;
    for (@items) {
        $vertical++;
        if (($vertical % $vertical_shift) != 0) { next }
        $horizontal += $horizontal_shift;
        my $myhorizontal = $horizontal % $linelength;
        if ($$_[$myhorizontal] eq "#") {
            $tree_count++;
        }
    }
    return $tree_count;
}

my $one = &count_trees(1,1);
my $two = &count_trees(3,1);
my $three = &count_trees(5,1);
my $four = &count_trees(7,1);
my $five = &count_trees(1,2);
my $result = $one * $two * $three * $four * $five;

print "$result\n";
