#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

my $seqA = 'ACG--TA';
my $seqB = 'ACTCCTC';

my $m = 0;
my $mm = 0;

my $i = length($seqA);
my $j = length($seqB);

my $a = "";
my $b = "";

do
  {
   $a = substr($seqA, $i-1, 1);
   $b = substr($seqB, $j-1, 1);

   if ( $a eq $b )
     {
      $m++;
     }

    else
     {
      $mm++;
     }

    $i--;
    $j--;

    }

   while($i>0 || $j>0);

printf "\n";

printf "Number of matches are: $m\n";

printf "\n";

printf "Number of mismatches are: $mm\n";


   
   