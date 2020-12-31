#!/usr/bin/perl

use warnings;
use strict;
use 5.010;
use experimental 'smartmatch';

my @player1;
my @player2;
my $deckpointer;
my $debug = 0;
while (<>) {
	chomp;
	if (/Player 1:/) {
		$deckpointer = \@player1;
		next;
	} elsif (/Player 2:/) {
		$deckpointer = \@player2;
		next;
	} elsif (/^$/) {
		next;
	}
	push @$deckpointer, $_;
}

sub test_equal_game {
	my ($game,$gamelist) = @_;
	for (@$gamelist) {
		if (@$_ ~~ @$game) {
			return 1;
		}
	}
	return 0;
}

sub play {
	my ($player1pointer, $player2pointer) = @_;
	my @player1 = @$player1pointer;
	my @player2 = @$player2pointer;
	my @player1games;
	my @player2games;
	while ((scalar @player1 > 0) and (scalar @player2 > 0)) {
		if ((&test_equal_game(\@player1, \@player1games)) or (&test_equal_game(\@player2, \@player2games))) {
			return (1, \@player1, \@player2);
		} 
		my @tmp1 = @player1;
		my @tmp2 = @player2;
		push @player1games, \@tmp1;
		push @player2games, \@tmp2;
		$debug and print "player1: ";
		for (@player1) { $debug and print "$_ "; }
		$debug and print "\n";
		$debug and print "player2: ";
		for (@player2) { $debug and print "$_ "; }
		$debug and print "\n";
		my $cardplayer1 = shift @player1;
		my $cardplayer2 = shift @player2;
		$debug and printf("%-20d%-20d\n",$cardplayer1, $cardplayer2);
		my ($winner, $abc, $def) = (0, undef, undef);
		if (($cardplayer1 <= scalar @player1) and ($cardplayer2 <= scalar @player2)) {
			my @tmpplayer1 = @player1[0..($cardplayer1-1)];
			my @tmpplayer2 = @player2[0..($cardplayer2-1)];
			($winner, $abc, $def) = &play(\@tmpplayer1, \@tmpplayer2);
		}
		if ($winner == 1) {
			push @player1, ($cardplayer1, $cardplayer2);
		} elsif ($winner == 2) {
			push @player2, ($cardplayer2, $cardplayer1);
		} else {
			if (($cardplayer1 > $cardplayer2) or ($winner == 1)) {
				push @player1, ($cardplayer1, $cardplayer2);
			} else {
				push @player2, ($cardplayer2, $cardplayer1);
			}
		}
	}
	if (scalar @player1 > 0) {
		return (1, \@player1, \@player2);
	} else {
		return (2, \@player1, \@player2);
	}
}

sub calculate_score {
	my ($winner, $player1, $player2) = @_;
	my $deckpointer;
	my $score = 0;
	if ($winner == 1) {
		$deckpointer = $player1;
	} else {
		$deckpointer = $player2;
	}
	for (my $i = 1; scalar @$deckpointer > 0; $i++) {
		$score = $score + ((pop @$deckpointer) * $i);
	}
	return $score;
}

my ($winner, $player1, $player2) = &play(\@player1, \@player2);
print &calculate_score($winner, $player1, $player2), "\n";

