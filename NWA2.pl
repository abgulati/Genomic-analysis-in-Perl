#!/usr/bin/perl
use List::Util qw[min max];
use strict;
use warnings;
use diagnostics;

my $seqA = 'ACA';
my $seqB = 'GACAT';

my $m = 5;
my $mm = -4;
my $g = -20;
my $e = -1;

my @M = ();
my @E = ();
my @F = ();
my @v = ();
my @vtr = ();

$v[0][0] = 0;
$vtr[0][0] = 0;

my $score = 0;
my $Diag = 0;
my $UP = 0;
my $LEFT = 0;


for (my $i=1; $i<=length($seqA); $i++)
   {
     $v[$i][0] = $g + ($i-1)*$e;
     $M[$i][0] = $g + ($i-1)*$e;
     $E[$i][0] = $g + ($i-1)*$e;
     $F[$i][0] = $g + ($i-1)*$e;
    }

for (my $j=1; $j<=length($seqB); $j++)
   {
    $v[0][$j] = $g + ($j-1)*$e;
    $M[0][$j] = $g + ($j-1)*$e;
    $E[0][$j] = $g + ($j-1)*$e;
    $F[0][$j] = $g + ($j-1)*$e;
    }

for (my $i=1; $i<=length($seqA); $i++)
   {
     $vtr[$i][0] = "U";
    }

for (my $j=1; $j<=length($seqB); $j++)
   {
    $vtr[0][$j] = "L";
    }



for (my $i=1; $i<=length($seqA); $i++)
    {
     for (my $j=1; $j<=length($seqB); $j++)
        {
         if (substr($seqA, $i-1, 1) eq substr($seqB, $j-1, 1))
            {
              $score = $m;
             }
         else
           { 
            $score = $mm;
            }

          $M[$i][$j] = $v[$i-1][$j-1] + $score;
          $F[$i][$j] = max( ($M[$i-1][$j] + $g), ($F[$i-1][$j] + $e) );
          $E[$i][$j] = max( ($M[$i][$j-1] + $g), ($E[$i][$j-1] + $e) );       
                
          $Diag = $M[$i][$j];
          $UP = $F[$i][$j];
          $LEFT = $E[$i][$j];

          $v[$i][$j] = max($Diag, $UP, $LEFT);

         if ($v[$i][$j] eq $Diag)
           {
            $vtr[$i][$j] = "D";
            
            }
         elsif ($v[$i][$j] eq $UP)
          { 
           $vtr[$i][$j] = "U";
           
           }
         elsif ($v[$i][$j] eq $LEFT)
           {
            $vtr[$i][$j] = "L";
            
            }
        }

     }

printf"\n";

for (my $i=0; $i<=length($seqA); $i++)
    {
     for (my $j=0; $j<=length($seqB); $j++)
        {
          print (" $v[$i][$j] ");
          
         }
      printf"\n";
    }

printf"\n";

for (my $i=0; $i<=length($seqA); $i++)
    {
     for (my $j=0; $j<=length($seqB); $j++)
        {
          print (" $vtr[$i][$j] ");
          
         }
      printf"\n";
    }


printf"\n";


my $i = length($seqA);
my $j = length($seqB);
my $alnseqA = "";
my $alnseqB = "";


while ($i>0 || $j>0)
   {
     if ($vtr[$i][$j] eq "D")
       {
        $alnseqA = substr($seqA, $i-1, 1).$alnseqA;
        $alnseqB = substr($seqB, $j-1, 1).$alnseqB;
        $i--;
        $j--;
        }
    
      elsif ($vtr[$i][$j] eq "U")
        {
         $alnseqA = substr($seqA, $i-1, 1).$alnseqA;
         $alnseqB = "-$alnseqB";
         $i--;
        }
 
      elsif ($vtr[$i][$j] eq "L")
        {
         $alnseqA = "-$alnseqA";
         $alnseqB = substr($seqB, $j-1, 1).$alnseqB;
         $j--;
        }
     }


printf "Sequence 1: $alnseqA\n";
printf "Sequence 2: $alnseqB\n";