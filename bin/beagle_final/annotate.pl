#!usr/bin/env/perl

# Author: Sahar Mozaffari
# Date: 
# Purpose: annotate GEMMA output files to include rsid, MAF, chr, gene, etc... 
# Usage: perl annotate.pl <file>
# Notes: uses VEP annovar 

use strict;
use warnings;

my $filename = $ARGV[0];

my %rs;
my %chr;
my %bp;
my %func;
my %gene;
my %detail;
my %maf;
my $dist;

open (ANN, "/lustre/beagle2/ober/users/cigartua/Hutterite_annotation/VEP_variant_files/VEP_annovar_1-22_conservation_selected_scores.txt") || die "nope: $!"; 
my $f = <ANN>;
while (my $line = <ANN>) {
    my @line = split "\t", $line;
    my $fakers = $line[5]; #$line[45];
    $rs{$fakers} = $line[12];#$line[14];
    $chr{$fakers} = $line[0];
    $bp{$fakers} = $line[1];
    $func{$fakers} = $line[6]; # $line[5];
    $maf{$fakers} = $line[16];
    if ($line[8] =~ /dist/) { #line[7]
	my @closer = split ";", $line[8];
	my @loc1 = split "=", $closer[0];
	my @loc2 = split "=", $closer[1];
	my @genes = split "\,", $line[7];
	if ($loc1[1] eq "NONE") {
	    $gene{$fakers} = $genes[1];
            $detail{$fakers} = $loc2[1];
	} elsif ($loc2[1] eq "NONE") {
                 $gene{$fakers} = $genes[0];
             $detail{$fakers} = $loc1[1];
	} elsif ($loc1[1] < $loc2[1]) {
	    if ($genes[0] eq "NONE") {
		$gene{$fakers} = $genes[1];
	    } else {
                $gene{$fakers} = $genes[0];
            }
	    $detail{$fakers} = $loc1[1];
	} elsif ($loc1[1] >= $loc2[1]) {
	    if ($genes[1] eq "NONE") {
		$gene{$fakers} = $genes[0];
	    } else {
		$gene{$fakers} = $genes[1];
	    }
	    $detail{$fakers} = $loc2[1];	
	}
    } else {
	$gene{$fakers} = $line[6];
	$detail{$fakers} = $line[7];
    }
}

open (NEW, ">annotated_$filename") || die "nope: $!";
open (FIL, "$filename") || die "nope: $!";
while (my $line = <FIL>) {
    my @line = split "\t", $line;
    my $fakers = $line[1];
    if ($rs{$fakers}) {
	print NEW (join "\t", $chr{$fakers}, $rs{$fakers}, $bp{$fakers}, $maf{$fakers}, $func{$fakers}, $gene{$fakers},$detail{$fakers}, @line);
    } else {
	print NEW (join "\t", "NA", @line);    
    }
}
close (NEW);
close (FIL);
close (ANN);
