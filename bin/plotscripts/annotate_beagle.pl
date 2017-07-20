#!usr/bin/env/perl

#use strict;
use warnings;

my $filename = $ARGV[0];
my $file2 =$ARGV[1];
my $file3 =$ARGV[2];
my $file4 =$ARGV[3];
my $file5 =$ARGV[4];
my $file6 =$ARGV[5];

my %rs;
my %chr;
my %bp;
my %func;
my %gene;
my %detail;
my %maf;
my $dist;

#open (ANN, "/lustre/beagle2/ober/users/smozaffari/POGWAS/data/all12_imputed_cgi.annovar_plink_annotations.hg19_multianno_Hutterite_AAF.txt") || die "nope: $!";
open (ANN, "/group/ober-resources/users/smozaffari/VEP_annovar_1-22_conservation_selected_scores.txt") || die "nope: $!"; 
#open (ANN, "anno_head") || die "nope:!";
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
#    if ($genes[2] eq "NONE") {
	    $gene{$fakers} = $genes[1];
#            } else {
#                $gene{$fakers} = $genes[1];
#            }
            $detail{$fakers} = $loc2[1];
	} elsif ($loc2[1] eq "NONE") {
 #           if ($genes[1] eq "NONE") {
	    $gene{$fakers} = $genes[0];
 #           } else {
 #               $gene{$fakers} = $genes[1];
 #           }
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

(my $newfilename = $filename) =~s/.*\///;
open (NEW, ">annotated_$newfilename") || die "nope: $!";
open (FIL, "$filename") || die "nope: $!";
while (my $line = <FIL>) {
    my @line = split "\t", $line;
    my $fakers = $line[1];
    if ($rs{$fakers}) {
	print NEW (join "\t", $chr{$fakers}, $rs{$fakers}, $bp{$fakers}, $maf{$fakers}, $func{$fakers}, $gene{$fakers},$detail{$fakers}, @line);
    } else {
#	print NEW (join "\t", "NA", @line);    
    }
}
close (NEW);
close (FIL);

(my $newfilename2 = $file2) =~s/.*\///;
open (NEW, ">annotated_$newfilename2") || die "nope: $!";
open (FIL, "$file2") || die "nope: $!";
while (my $line = <FIL>) {
    my @line = split "\t", $line;
    my $fakers = $line[1];
    if ($rs{$fakers}) {
        print NEW (join "\t", $chr{$fakers}, $rs{$fakers}, $bp{$fakers}, $maf{$fakers}, $func{$fakers}, $gene{$fakers},$detail{$fakers}, @line);
    } else {
 #       print NEW (join "\t", "NA", @line);
    }
}
close (NEW);
close (FIL);

(my $newfilename3 = $file3) =~s/.*\///;
open (NEW, ">annotated_$newfilename3") || die "nope: $!";
open (FIL, "$file3") || die "nope: $!";
while (my $line = <FIL>) {
    my @line = split "\t", $line;
    my $fakers = $line[1];
    if ($rs{$fakers}) {
        print NEW (join "\t", $chr{$fakers}, $rs{$fakers}, $bp{$fakers}, $maf{$fakers}, $func{$fakers}, $gene{$fakers},$detail{$fakers}, @line);
    } else {
#        print NEW (join "\t", "NA", @line);
    }
}
close (NEW);
close (FIL);

(my $newfilename4 = $file4) =~s/.*\///;
open (NEW, ">annotated_$newfilename4") || die "nope: $!";
open (FIL, "$file4") || die "nope: $!";
while (my $line = <FIL>) {
    my @line = split "\t", $line;
    my $fakers = $line[1];
    if ($rs{$fakers}) {
        print NEW (join "\t", $chr{$fakers}, $rs{$fakers}, $bp{$fakers}, $maf{$fakers}, $func{$fakers}, $gene{$fakers},$detail{$fakers}, @line);
    } else {
  #      print NEW (join "\t", "NA", @line);
    }
}
close (NEW);
close (FIL);


(my $newfilename5 = $file5) =~s/.*\///;
open (NEW, ">annotated_$newfilename5") || die "nope: $!";
open (FIL, "$file5") || die "nope: $!";
while (my $line = <FIL>) {
    my @line = split "\t", $line;
    my $fakers = $line[1];
    if ($rs{$fakers}) {
        print NEW (join "\t", $chr{$fakers}, $rs{$fakers}, $bp{$fakers}, $maf{$fakers}, $func{$fakers}, $gene{$fakers},$detail{$fakers}, @line);
    } else {
   #     print NEW (join "\t", "NA", @line);
    }
}
close (NEW);
close (FIL);

(my $newfilename6 = $file6) =~s/.*\///;
open (NEW, ">annotated_$newfilename6") || die "nope: $!";
open (FIL, "$file6") || die "nope: $!";
while (my $line = <FIL>) {
    my @line = split "\t", $line;
    my $fakers = $line[1];
    if ($rs{$fakers}) {
        print NEW (join "\t", $chr{$fakers}, $rs{$fakers}, $bp{$fakers}, $maf{$fakers}, $func{$fakers}, $gene{$fakers},$detail{$fakers}, @line);
    } else {
#        print NEW (join "\t", "NA", @line);
    }
}
close (NEW);
close (FIL);
=head
(my $newfilename7 = $file7) =~s/.*\///;
open (NEW, ">annotated_$newfilename7") || die "nope: $!";
open (FIL, "$file7") || die "nope: $!";
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
=cut

close (ANN);
