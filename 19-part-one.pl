#!/usr/bin/perl
#
use warnings;
use strict;
use Data::Dumper;

my $part = 0;
my @toverify;
my %rules;
while (<>) {
	chomp;
	if (/^$/) { $part = 1; next }
	if ($part == 0) {
		unless (/^(\d+): (.*)$/) { print "error\n"; exit(1) }
		my ($number, $data) = ($1, $2);
		$rules{$number} = {};
		$rules{$number}->{data} = $data;
	} else {
		push @toverify, $_;
	}
}

sub find_numbers {
	my ($input) = @_;
	my @list = ($input =~ m/\d+/g);
	return @list;
}

sub basic_resolution {
	my %subhash;
	while (1) {
		my $abccount=0;
		for (keys %rules) {
			my $rule = $_;
			if ($rules{$_}->{data} =~ /"([a-z]+)"/) {
				$rules{$_}->{data} =~ s/"([a-z]+)"/$1/g;
				$abccount++;
			}
			if ($rules{$_}->{data} =~ /"?([a-z]+)\s+([a-z]+)"?/) {
				$rules{$_}->{data} =~ s/"?([a-z]+)\s+([a-z]+)"?/$1$2/g;
				$abccount++;
			}
			if ($rules{$_}->{data} =~ /^([a-z]+)$/) {
				my $match = $1;
				unless (exists($subhash{$_})) {
					$subhash{$_} = {};
				       	$subhash{$_}->{data}= $match;
					$abccount++;
				}
			} else {
				for (&find_numbers($rules{$_}->{data})) {
					if (exists($subhash{$_})) {
						$rules{$rule}->{data} =~ s/^$_([^\d])/$subhash{$_}->{data}$1/g;
						$rules{$rule}->{data} =~ s/([^\d])$_([^\d])/$1$subhash{$_}->{data}$2/g;
						$rules{$rule}->{data} =~ s/([^\d])$_$/$1$subhash{$_}->{data}/g;
						$abccount++;
					}
				}
			}
		}
		if ($abccount == 0) { last }
	}
}

sub build_regex {
	my ($input) = @_;
	my $output_regex = $rules{$input}->{data};
	for (&find_numbers($rules{$input}->{data})) {
		my $result = &build_regex($_);
		$output_regex =~ s/^$_([^\d])/($result)$1/g;
		$output_regex =~ s/([^\d])$_([^\d])/$1($result)$2/g;
		$output_regex =~ s/([^\d])$_$/$1($result)/g;
		$output_regex =~ s/^$_$/($result)/g;
	}
	$output_regex =~ s/\s//g;
	return $output_regex;
}

sub dostuff {
    my ($regex) = @_;
    my $matchcount = 0;
    for (@toverify) {
    	my $match = 0;
    	if ($_ =~ $regex) { $match = 1; $matchcount++; }
	#printf("%-20s %-20s\n",$_, $match);
    }
    print $matchcount, "\n";
}


&basic_resolution;
my $regex = &build_regex(0);
$regex = '^' . $regex;
$regex = $regex . '$';
#print $regex, "\n";
&dostuff($regex);
