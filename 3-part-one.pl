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

my $horizontal = 0;
my $tree_count = 0;
for (@items) {
    $horizontal += 3;
    my $myhorizontal = $horizontal % $linelength;
    if ($$_[$myhorizontal] eq "#") {
        $tree_count++;
    }
}

print "$tree_count\n";
