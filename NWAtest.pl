#!/usr/bin/perl
use List::Util qw[min max];
use strict;
use warnings;
use diagnostics;

my $seqA = 'CA';
my $seqB = 'CTA';

my $m = 10;
my $mm = 2;
my $g = -5;
my @v = ();
$v[0][0] = 0;
my $score = 0;


for (my $i=0; $i<=length($seqA); $i++)
   {
     $v[$i][0] = $i*$g;

    }


for (my $j=0; $j<=length($seqB); $j++)
   {
    $v[0][$j] = $j*$g;

    }

for (my $i=0; $i<length($seqA); $i++)
    {
      $a = substr($seqA, $i, 1);
 
      for (my $j=0; $j<length($seqB); $j++)
         {

          $b = substr($seqB, $j, 1);

         if ($a eq $b) 
            {
              $score = $m;
              printf"$score";
             }
         else
           { 
            $score = $mm;
            printf"$score";
            }

}
}
