#!/usr/bin/perl

use warnings;
use strict;

my @player1;
my @player2;
my $deckpointer;
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

sub play {
	while ((scalar @player1 > 0) and (scalar @player2 > 0)) {
		my $cardplayer1 = shift @player1;
		my $cardplayer2 = shift @player2;
		if ($cardplayer1 > $cardplayer2) {
			push @player1, ($cardplayer1, $cardplayer2);
		} else {
			push @player2, ($cardplayer2, $cardplayer1);
		}
	}
}

sub calculate_score {
	my $deckpointer;
	my $score = 0;
	if (scalar @player1 > 0) {
		$deckpointer = \@player1;
	} else {
		$deckpointer = \@player2;
	}
	for (my $i = 1; scalar @$deckpointer > 0; $i++) {
		$score = $score + ((pop @$deckpointer) * $i);
	}
	return $score;
}

&play;
print &calculate_score, "\n";
