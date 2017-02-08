#!/usr/bin/perl
use List::Util qw[min max];
use strict;
use warnings;
use diagnostics;

open (IN, "dna.fasta");
my @data = <IN>;
close(IN);
chomp (@data);

my $seq1 = $data[1];
my $seq2 = $data[3];

my $delta = 0.2;
my $eta = 0.5;

my $Diag = 0;
my $UP = 0;
my $LEFT = 0;
my $maxval = 0;
my $prob = 0;

my @M = ();
my @X = ();
my @Y = ();
my @T = ();
my @B = ();

#transitions originating from the beginning state
my $BX = $delta;
my $BY = $delta;
my $BM = 1 - 2*$delta;

#transitions originating from state M 
my $MX = $delta;
my $MY = $delta;
my $MM = 1 - 2*$delta;

#transitions originating from state X
my $XX = $eta;
my $XY = 0;
my $XM = 1 - $eta;

#transitions originating from state Y
my $YY = $eta;
my $YX = 0;
my $YM = 1 - $eta;

#probabilities
my $pgap = 1;
my $pm = 0.6;
my $pmm = 1 - $pm;

#initialize B

$B[0][0] = 1;
$B[0][1] = 0;
$B[1][0] = 0;

for (my $i = 1; $i<=length($seq2); $i++)
   {
    for (my $j = 1; $j<=length($seq1); $j++)
	    {
		  $B[$i][$j] = 0;
		  }
    }
	

#initialize M

$M[0][0] = 0;

for (my $i = 1; $i<=length($seq2); $i++)
   {
    $M[$i][0] = 0;
	}
	
for (my $i = 1; $i<=length($seq1); $i++)
   {
    $M[0][$i] = 0;
	}
	
	
#initialize X 

$X[0][0] = 0;
$X[1][0] = $pgap*$BX*$B[0][0];

for (my $i = 2; $i <= length($seq2); $i++)
   {
    $X[$i][0] = $pgap * $XX * $X[$i-1][0];
	}
	
for (my $i = 1; $i <= length($seq1); $i++)
   {
	$X[0][$i] = 0;
	}
	
#initialize Y

$Y[0][0] = 0;
$Y[0][1] = $pgap*$BY*$B[0][0];

for (my $i = 1; $i <= length($seq2); $i++)
   {
    $Y[$i][0] = 0;
	}
	
for (my $i = 2; $i <= length($seq1); $i++)
    {
	  $Y[0][$i] = $pgap * $YY * $Y[0][$i-1];
	  }
	  
#initialize T

$T[0][0] = 0;

for (my $i = 1; $i <= length($seq2); $i++)
   {
    $T[$i][0] = 'U';
	}
	
for (my $i = 1; $i <= length($seq1); $i++)
   {
    $T[0][$i] = 'L';
	}

#Recurrence	
	
for (my $i = 1; $i<=length($seq2); $i++)
   {
     for (my $j = 1; $j<=length($seq1); $j++)
	    {
		  if (substr($seq1, $j-1, 1) eq substr($seq2, $i-1, 1))
            {
			 $prob = $pm;
			 }
          else
             {
			  $prob = $pmm;
			  }
			  
		  $M[$i][$j] = $prob + max( ($MM * $M[$i-1][$j-1]), ($XM * $X[$i-1][$j-1]), ($YM * $Y[$i-1][$j-1]), ($BM * $B[$i-1][$j-1]) );
		  
          $Y[$i][$j] = $pgap + max( ($MY * $M[$i][$j-1]), ($YY * $Y[$i][$j-1]), ($BY * $B[$i][$j-1]) );
		  
		  $X[$i][$j] = $pgap + max( ($MX * $M[$i-1][$j]), ($XX * $X[$i-1][$j]), ($BX * $B[$i-1][$j]) );
		  
		  $Diag = $M[$i][$j];
		  $UP = $X[$i][$j];
		  $LEFT = $Y[$i][$j];
		  
		  $maxval = max ($Diag, $UP, $LEFT);
		  
		  if ($maxval eq $Diag)
		    {
			 $T[$i][$j] = "D";
			 }
			 
		  elsif ($maxval eq $UP)
             {
			  $T[$i][$j] = "U";
			  }
 
          elsif ($maxval eq $LEFT)
              {
    		   $T[$i][$j] = "L";
			   }
			   
	     }
     }

for (my $i = 0; $i<=length($seq2); $i++)
   {
	  for (my $j = 0; $j<=length($seq1); $j++)
	     {
		  print ( " $T[$i][$j] ");
		  }
	 printf"\n";
    }	
	
my $i = length($seq2);
my $j = length($seq1);
my $alnseq1 = "";
my $alnseq2 = "";

while ($i>0 || $j>0)
     {
	  if ($T[$i][$j] eq "D")
      	 {
		  $alnseq1 = substr($seq1, $j-1, 1).$alnseq1;
          $alnseq2 = substr($seq2, $i-1, 1).$alnseq2;
		  $i--;
		  $j--;
		  }
		  
	  elsif ($T[$i][$j] eq "U")
	      {
		   $alnseq1 = "-$alnseq1";
		   $alnseq2 = substr($seq2, $i-1, 1).$alnseq2;
		   $i--;
		   }
		   
	  elsif ($T[$i][$j] eq "L")
	      {
		   $alnseq1 = substr($seq1, $j-1, 1).$alnseq1;
		   $alnseq2 = "-$alnseq2";
		   $j--;
		   }
	  }
	  
	 
printf "Sequence 1: $alnseq1\n";
printf "Sequence 2: $alnseq2\n";



	
		  