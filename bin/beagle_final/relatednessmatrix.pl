#!/usr/bin/env/perl                                                                                                                               

#Author: SVM
#Usage: perl relatednessmatrix.pl <what you want to name it> <file with list of individuals you want matrix for>
#changes relatedness file with columns and names of individuals to matrix of all individuals
#this was used to calculate a relatedness matrix for for GEMMA since we are using BIMBAM format
#name refers to file that has list of individuals you want to make new relatedness matrix for.

use strict;
use warnings;

my %rel;
my @list;
my @loop;

my $phen = $ARGV[0]; #name into output file - here using SNP for parent of origin
my $name = $ARGV[1]; #file with list of individuals you want matrix for 

#store in relatedness information
open (REL, "/lustre/beagle2/ober/users/smozaffari/POGWAS/data/maternalrelatedness") || die "nope: $!";
while (my $line = <REL>) {
    my @line = split (" ", $line);
    my $id1 = $line[0];
    my $id2 = $line[1];
    $rel{$id1}{$id2} = $line[2];
}
close (REL);

open (PED, $name) || die "nope: $!";
while (my $line = <PED>) {
    my @line = split (" ", $line);
    push @list, $line[1];
    push @loop, $line[1];
}
close(PED);

my $newrel = join("", ">/lustre/beagle2/ober/users/smozaffari/POGWAS/results/", $phen, "/", $phen, "relatedness");
open (NEW, $newrel) || die "nope $!";
for my $ind (0..$#list) {
    my $person1 = $list[$ind];
    for my $i (0..$#loop) {
        my $person2 = $loop[$i];
        if ($person2 < $person1) {
            print NEW ("$rel{$person2}{$person1} ");
        } else {
            print NEW ("$rel{$person1}{$person2} ");
        }
    }
    print NEW "\n";

}
close(NEW);
