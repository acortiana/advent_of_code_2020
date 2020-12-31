#!/usr/bin/perl
#
use warnings;
use strict;

my @passports;
my $currentpassport;
while (<>) {
    if (/^\s*$/) {
	    push @passports, $currentpassport;
	    $currentpassport = {};
	    next;
    }
    my @entries = split /\s+/, $_;
    for (@entries) {
	    unless (/([^:]+):([^:]+)/) { print STDERR "error"; exit(1); }
	    my ($key, $value) = ($1, $2);
	    $$currentpassport{$key} = $value;
    }
}
push @passports, $currentpassport;

my $okcount = 0;
my $errorcount = 0;
my $total = 0;

for (@passports) {
	$total++;
	$errorcount++;
	unless (exists($$_{'byr'})) { next }
	unless (exists($$_{'iyr'})) { next }
	unless (exists($$_{'eyr'})) { next }
	unless (exists($$_{'hgt'})) { next }
	unless (exists($$_{'hcl'})) { next }
	unless (exists($$_{'ecl'})) { next }
	unless (exists($$_{'pid'})) { next }
	$errorcount--;
	$okcount++;
}

#print "total: $total\n";
#print "errorcount: $errorcount\n";
print "$okcount\n";
