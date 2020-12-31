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

my %allowed_ecl = (
	amb => 1,
	blu => 1,
	brn => 1,
	gry => 1,
	grn => 1,
	hzl => 1,
	oth => 1,
);

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
	unless ($$_{'byr'} =~ /^\d{4}$/) { next } 
	unless (($$_{'byr'} >= 1920) and ($$_{'byr'} <= 2002)) { next }
	unless ($$_{'iyr'} =~ /^\d{4}$/) { next } 
	unless (($$_{'iyr'} >= 2010) and ($$_{'iyr'} <= 2020)) { next }
	unless ($$_{'eyr'} =~ /^\d{4}$/) { next } 
	unless (($$_{'eyr'} >= 2020) and ($$_{'eyr'} <= 2030)) { next }
	unless (($$_{'hgt'} =~ /^(\d+)(cm)$/) or ($$_{'hgt'} =~ /^(\d+)(in)$/)) {
		next;
	} else {
		my ($height, $unit) = ($1, $2);
		if ($unit eq "cm") {
			unless (($height >= 150) and ($height <= 193)) { next }
		} elsif ($unit eq "in") {
			unless (($height >= 59) and ($height <= 76)) { next }
		} else {
			print STDERR "error\n";
			exit(1);
		}
	}
	unless ($$_{'hcl'} =~ /^#[\da-f]{6}$/) { next }
	unless (exists($allowed_ecl{$$_{'ecl'}})) { next }
	unless ($$_{'pid'} =~ /^\d{9}$/) { next }
	$errorcount--;
	$okcount++;
}

#print "total: $total\n";
#print "errorcount: $errorcount\n";
print "$okcount\n";
